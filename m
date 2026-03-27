Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BC1231832
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774631230; cv=none; b=e/rXIWCE/A8rx8s+pp10rzs/+AbX0bqH49j1vKZ7f9ZN3NpqPvs8pM20ShilLAD8kSWUSaxqBXHqycFJ4J91XaHGlvOs+8LYtnkBU+VvU4EoKQHNR+FEittmn+R3mie3DtDzMg8rBIQmqAjZfP2M1els5B67088BdhRsuMxS6PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774631230; c=relaxed/simple;
	bh=2eKbL7xYfeVPWfGy2MlBh+ZEdyTwNLEWnxOA3MYI+d8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mX6JcA23PSTUrd7VRRdFiDgxVUb5HMF+phaee6OjHMmk+9VJ3zJdCW1ECUxAg+tk0FmWkZct4F2A0jMy969DukyDuiN+PA1p2pWpVsrMkv+jIdM/j9gpfRoPBAWLLVchKTU/pdZDcrKF//hDSSKY3MkZzSt/vjXgbJNIlZyrxXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0eMstvZ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0eMstvZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774631230; x=1806167230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2eKbL7xYfeVPWfGy2MlBh+ZEdyTwNLEWnxOA3MYI+d8=;
  b=Q0eMstvZwFwsK8szSPM9iXDJp4U22UEssBB1+20MSPbUsdKpIM5JUzBS
   QZTHG1BKV+jtMYVzYo68reGsXEyPaZUmLWFoPSa2gYIe3s4ILonnHd+iO
   40JvkgSIfPxpSRK0/0UXAnp1rpMW5H5zPkK2Ry3MSdUixNO7M74kr7laJ
   gDE0xVz2Nq6Ylg94NzjXL65wBXDYVRX7D2pyQFmZf1SetoYSO7OvsaQla
   GtdK00x7eaRpORNVNrUeRfgRQ7sj1XF5g2Q5l2Ke0iF4hg9xRrr562nKm
   wdJudfLoGfC6aac+C3WcmPKUuBqfSimqqpaYbJoItY9Te5UrKhUdHXKts
   Q==;
X-CSE-ConnectionGUID: jqRZqtp7SLaRPQmTyDAm/A==
X-CSE-MsgGUID: UDX0EY08Q4mIlDJBg9C+IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79315414"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="79315414"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:07:09 -0700
X-CSE-ConnectionGUID: vVguU01ESZ+tI90ciJoe/Q==
X-CSE-MsgGUID: iQwTMJ8DQYGw+mM6rXAYsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="225625326"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.180]) ([10.125.110.180])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:07:08 -0700
Message-ID: <065bdf0c-dd55-4d8e-8ba0-aac20dc8a727@intel.com>
Date: Fri, 27 Mar 2026 10:07:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] dax/hmem: Parent dax_hmem devices
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-8-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-8-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> For test purposes it is useful to be able to determine which
> "hmem_platform" device is hosting a given sub-device.
> 
> Register hmem devices underneath "hmem_platform".
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/hmem/hmem.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index e1dae83dae8d..af21f66bf872 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -96,6 +96,7 @@ static int __hmem_register_device(struct device *host, int target_nid,
>  		return -ENOMEM;
>  	}
>  
> +	pdev->dev.parent = host;
>  	pdev->dev.numa_node = numa_map_to_online_node(target_nid);
>  	info = (struct memregion_info) {
>  		.target_node = target_nid,

