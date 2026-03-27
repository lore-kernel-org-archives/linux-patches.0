Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219AE37418F
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774631188; cv=none; b=DdyxsBmjHlmYgVHXlVpHJ/wMpYOhmHqgCQyBf3l9lQkGPkVxRn74880lCeebsPgwMbZw9D7sVrRL103JhXNY/gm1F2gjlLsUV7AXlUZ9dgkDwIle5/L9rsET5M+z5i8Qb9chh9iwbGfWruUlyUMa2UWUAwf0JGvPr8PAq7lAd8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774631188; c=relaxed/simple;
	bh=UwndItpshjirI9E2ygumuVUz+yWfSx7dt+yErdD2uK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRWZTAjEGZj5c/R9/jUExUC7LVlj33SI0R78nQ6Zjvc/89PqnP14Za0ehlE3YUNbpeQw+FirfQvtptPI/0AnPIT8oxvm2bKjW2yj9HIPbbQRDUPXUrK/udXVMOeIGb/WAFq+jTw4ZmRRmQWZU8fbeL3JhBtGsofhohE75IoF49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tn/4UP8Q; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tn/4UP8Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774631183; x=1806167183;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UwndItpshjirI9E2ygumuVUz+yWfSx7dt+yErdD2uK8=;
  b=Tn/4UP8QbjWRxXvEzZxEfUUuriwP7IA0kaQMqrs4Uuagx1bpRXHYD7LY
   hWNr74r2gc0NuA3bLqbI2+lK1UwzFYGxt8KJ8Ps4Lxjquk2F44UCtjMDL
   YQfAdEDv4jed0Ahx6HaRzwnUWePM0ViqIQAdsOLDg+dKtocyldEmrqpNv
   hMrTnqqxq7n6xg90GlPPfqirejsX6bbPJKhq50Yhyl+uvFiDvce1d/Drx
   Qge+lRolsMER/+BvRSbgpkPHkfUOeVIxpbp2PRLoBis1fJpLp1wkt0Yjg
   w6i6+iu0q2R6EXK6BQfcBiPqA7EfY3Wpac8cRTbb7YNNmtnO0SrCulDfQ
   Q==;
X-CSE-ConnectionGUID: Po1lyESJSPulE0pryx0NtA==
X-CSE-MsgGUID: bWPayj4HQBOEkucEIlwAXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79315313"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="79315313"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:06:22 -0700
X-CSE-ConnectionGUID: xLd6HYlzTOmsjhCHyfuE0g==
X-CSE-MsgGUID: un/7xKWXSv63NUpGUjBbLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="225625101"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.180]) ([10.125.110.180])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:06:21 -0700
Message-ID: <15065a06-e674-4bb2-b9d7-89057ff1ded9@intel.com>
Date: Fri, 27 Mar 2026 10:06:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] dax/hmem: Fix singleton confusion between
 dax_hmem_work and hmem devices
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-7-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-7-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> dax_hmem (ab)uses a platform device to allow for a module to autoload in
> the presence of "Soft Reserved" resources. The dax_hmem driver had no
> dependencies on the "hmem_platform" device being a singleton until the
> recent "dax_hmem vs dax_cxl" takeover solution.
> 
> Replace the layering violation of dax_hmem_work assuming that there will
> never be more than one "hmem_platform" device associated with a global work
> item with a dax_hmem local workqueue that can theoretically support any
> number of hmem_platform devices.
> 
> Fixup the reference counting to only pin the device while it is live in the
> queue.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/bus.h         |  15 +++++-
>  drivers/dax/hmem/device.c |  28 ++++++----
>  drivers/dax/hmem/hmem.c   | 108 +++++++++++++++++++-------------------
>  3 files changed, 85 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index ebbfe2d6da14..7b1a83f1ce1f 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -3,7 +3,9 @@
>  #ifndef __DAX_BUS_H__
>  #define __DAX_BUS_H__
>  #include <linux/device.h>
> +#include <linux/platform_device.h>
>  #include <linux/range.h>
> +#include <linux/workqueue.h>
>  
>  struct dev_dax;
>  struct resource;
> @@ -49,8 +51,19 @@ void dax_driver_unregister(struct dax_device_driver *dax_drv);
>  void kill_dev_dax(struct dev_dax *dev_dax);
>  bool static_dev_dax(struct dev_dax *dev_dax);
>  
> +struct hmem_platform_device {
> +	struct platform_device pdev;
> +	struct work_struct work;
> +	bool did_probe;
> +};
> +
> +static inline struct hmem_platform_device *
> +to_hmem_platform_device(struct platform_device *pdev)
> +{
> +	return container_of(pdev, struct hmem_platform_device, pdev);
> +}
> +
>  #if IS_ENABLED(CONFIG_DEV_DAX_HMEM)
> -extern bool dax_hmem_initial_probe;
>  void dax_hmem_flush_work(void);
>  #else
>  static inline void dax_hmem_flush_work(void) { }
> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
> index 675d56276d78..d70359b4307b 100644
> --- a/drivers/dax/hmem/device.c
> +++ b/drivers/dax/hmem/device.c
> @@ -4,13 +4,11 @@
>  #include <linux/module.h>
>  #include <linux/dax.h>
>  #include <linux/mm.h>
> +#include "../bus.h"
>  
>  static bool nohmem;
>  module_param_named(disable, nohmem, bool, 0444);
>  
> -bool dax_hmem_initial_probe;
> -EXPORT_SYMBOL_FOR_MODULES(dax_hmem_initial_probe, "dax_hmem");
> -
>  static bool platform_initialized;
>  static DEFINE_MUTEX(hmem_resource_lock);
>  static struct resource hmem_active = {
> @@ -36,9 +34,21 @@ int walk_hmem_resources(struct device *host, walk_hmem_fn fn)
>  }
>  EXPORT_SYMBOL_GPL(walk_hmem_resources);
>  
> +static void hmem_work(struct work_struct *work)
> +{
> +	/* place holder until dax_hmem driver attaches */
> +}
> +
> +static struct hmem_platform_device hmem_platform = {
> +	.pdev = {
> +		.name = "hmem_platform",
> +		.id = 0,
> +	},
> +	.work = __WORK_INITIALIZER(hmem_platform.work, hmem_work),
> +};
> +
>  static void __hmem_register_resource(int target_nid, struct resource *res)
>  {
> -	struct platform_device *pdev;
>  	struct resource *new;
>  	int rc;
>  
> @@ -54,17 +64,13 @@ static void __hmem_register_resource(int target_nid, struct resource *res)
>  	if (platform_initialized)
>  		return;
>  
> -	pdev = platform_device_alloc("hmem_platform", 0);
> -	if (!pdev) {
> +	rc = platform_device_register(&hmem_platform.pdev);
> +	if (rc) {
>  		pr_err_once("failed to register device-dax hmem_platform device\n");
>  		return;
>  	}
>  
> -	rc = platform_device_add(pdev);
> -	if (rc)
> -		platform_device_put(pdev);
> -	else
> -		platform_initialized = true;
> +	platform_initialized = true;
>  }
>  
>  void hmem_register_resource(int target_nid, struct resource *res)
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index dd3d7f93baee..e1dae83dae8d 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -59,20 +59,11 @@ static void release_hmem(void *pdev)
>  	platform_device_unregister(pdev);
>  }
>  
> -struct dax_defer_work {
> -	struct platform_device *pdev;
> -	struct work_struct work;
> -};
> -
> -static void process_defer_work(struct work_struct *w);
> -
> -static struct dax_defer_work dax_hmem_work = {
> -	.work = __WORK_INITIALIZER(dax_hmem_work.work, process_defer_work),
> -};
> +static struct workqueue_struct *dax_hmem_wq;
>  
>  void dax_hmem_flush_work(void)
>  {
> -	flush_work(&dax_hmem_work.work);
> +	flush_workqueue(dax_hmem_wq);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(dax_hmem_flush_work, "dax_cxl");
>  
> @@ -134,24 +125,6 @@ static int __hmem_register_device(struct device *host, int target_nid,
>  	return rc;
>  }
>  
> -static int hmem_register_device(struct device *host, int target_nid,
> -				const struct resource *res)
> -{
> -	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
> -	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> -			      IORES_DESC_CXL) != REGION_DISJOINT) {
> -		if (!dax_hmem_initial_probe) {
> -			dev_dbg(host, "await CXL initial probe: %pr\n", res);
> -			queue_work(system_long_wq, &dax_hmem_work.work);
> -			return 0;
> -		}
> -		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> -		return 0;
> -	}
> -
> -	return __hmem_register_device(host, target_nid, res);
> -}
> -
>  static int hmem_register_cxl_device(struct device *host, int target_nid,
>  				    const struct resource *res)
>  {
> @@ -170,35 +143,55 @@ static int hmem_register_cxl_device(struct device *host, int target_nid,
>  
>  static void process_defer_work(struct work_struct *w)
>  {
> -	struct dax_defer_work *work = container_of(w, typeof(*work), work);
> -	struct platform_device *pdev;
> -
> -	if (!work->pdev)
> -		return;
> -
> -	pdev = work->pdev;
> +	struct hmem_platform_device *hpdev = container_of(w, typeof(*hpdev), work);
> +	struct device *dev = &hpdev->pdev.dev;
>  
>  	/* Relies on cxl_acpi and cxl_pci having had a chance to load */
>  	wait_for_device_probe();
>  
> -	guard(device)(&pdev->dev);
> -	if (!pdev->dev.driver)
> -		return;
> +	guard(device)(dev);
> +	if (!dev->driver)
> +		goto out;
>  
> -	if (!dax_hmem_initial_probe) {
> -		dax_hmem_initial_probe = true;
> -		walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
> +	if (!hpdev->did_probe) {
> +		hpdev->did_probe = true;
> +		walk_hmem_resources(dev, hmem_register_cxl_device);
>  	}
> +out:
> +	put_device(dev);
> +}
> +
> +static int hmem_register_device(struct device *host, int target_nid,
> +				const struct resource *res)
> +{
> +	struct platform_device *pdev = to_platform_device(host);
> +	struct hmem_platform_device *hpdev = to_hmem_platform_device(pdev);
> +
> +	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
> +	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> +			      IORES_DESC_CXL) != REGION_DISJOINT) {
> +		if (!hpdev->did_probe) {
> +			dev_dbg(host, "await CXL initial probe: %pr\n", res);
> +			hpdev->work.func = process_defer_work;
> +			get_device(host);
> +			if (!queue_work(dax_hmem_wq, &hpdev->work))
> +				put_device(host);
> +			return 0;
> +		}
> +		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> +		return 0;
> +	}
> +
> +	return __hmem_register_device(host, target_nid, res);
>  }
>  
>  static int dax_hmem_platform_probe(struct platform_device *pdev)
>  {
> -	if (work_pending(&dax_hmem_work.work))
> -		return -EBUSY;
> +	struct hmem_platform_device *hpdev = to_hmem_platform_device(pdev);
>  
> -	if (!dax_hmem_work.pdev)
> -		dax_hmem_work.pdev =
> -			to_platform_device(get_device(&pdev->dev));
> +	/* queue is only flushed on module unload, fail rebind with pending work */
> +	if (work_pending(&hpdev->work))
> +		return -EBUSY;
>  
>  	return walk_hmem_resources(&pdev->dev, hmem_register_device);
>  }
> @@ -224,26 +217,33 @@ static __init int dax_hmem_init(void)
>  		request_module("cxl_pci");
>  	}
>  
> +	dax_hmem_wq = alloc_ordered_workqueue("dax_hmem_wq", 0);
> +	if (!dax_hmem_wq)
> +		return -ENOMEM;
> +
>  	rc = platform_driver_register(&dax_hmem_platform_driver);
>  	if (rc)
> -		return rc;
> +		goto err_platform_driver;
>  
>  	rc = platform_driver_register(&dax_hmem_driver);
>  	if (rc)
> -		platform_driver_unregister(&dax_hmem_platform_driver);
> +		goto err_driver;
> +
> +	return 0;
> +
> +err_driver:
> +	platform_driver_unregister(&dax_hmem_platform_driver);
> +err_platform_driver:
> +	destroy_workqueue(dax_hmem_wq);
>  
>  	return rc;
>  }
>  
>  static __exit void dax_hmem_exit(void)
>  {
> -	if (dax_hmem_work.pdev) {
> -		flush_work(&dax_hmem_work.work);
> -		put_device(&dax_hmem_work.pdev->dev);
> -	}
> -
>  	platform_driver_unregister(&dax_hmem_driver);
>  	platform_driver_unregister(&dax_hmem_platform_driver);
> +	destroy_workqueue(dax_hmem_wq);
>  }
>  
>  module_init(dax_hmem_init);

