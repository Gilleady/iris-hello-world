Include Ensemble

Class helloWorld.bo.orders.update.Method [ Abstract ]
{

ClassMethod Execute(pHost As helloWorld.bo.orders.Operation, pRequest As helloWorld.bo.orders.update.Request, Output pResponse As helloWorld.bo.orders.update.Response) As %Library.Status
{
    Try {
        Do pRequest.NewResponse(.pResponse)
    } Catch (exception) {
        $$$LOGERROR("Error generating response at update method: " _ exception.DisplayString())
        Return exception.AsStatus()
    }

	Set httpRequest = ##class(%Net.HttpRequest).%New()

	Set httpRequest.ContentCharset	= "UTF-8"
	Set httpRequest.ContentType		= "application/json"

    Set order = pRequest.Order

	$$$ThrowOnError(order.%JSONExportToString(.httpRequestBody))

    Set order = httpRequestBody

    Set url = "https://run.mocky.io/v3/b780cff1-b40c-484f-95c4-ba44e1b78be5/" _ pRequest.Order.Id

    Try {
        $$$ThrowOnError(pHost.Adapter.SendFormDataArray(.httpResponse, "PUT", httpRequest , "", order, url))
    } Catch(exception) 
    {
        $$$LOGERROR("Error sending request at update method: " _ exception.DisplayString())
        Return exception.AsStatus()
    }

	Set httpResponseBody = ""

    Try {
        Set dynamicResponse = ##class(%Library.DynamicObject).%FromJSON(httpResponse.Data)
    } Catch(exception) {
        $$$LOGINFO(httpResponse.Data)
        $$$LOGERROR("Error reading response at update method: " _ exception.DisplayString())
        Return exception.AsStatus()
    }

    Set order = ##class(helloWorld.obj.orders.Order).%New()

    Set order.Id = dynamicResponse.id
    Set order.Details = dynamicResponse.details
    Set order.ProductId = dynamicResponse.productId
    Set order.Quantity = dynamicResponse.quantity
    Set order.CustomerId = dynamicResponse.customerId

    Set pResponse.Order = order

    Return $$$OK
}

}
