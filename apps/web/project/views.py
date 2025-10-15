from django.http import HttpResponse, JsonResponse

def index(request):
    return HttpResponse("Django web is up. Try /healthz or /api/healthz")

def healthz(request):
    return JsonResponse({"status": "ok"})
