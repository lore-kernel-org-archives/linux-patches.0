Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8057C
	for <patches@lists.linux.dev>; Wed,  6 Jul 2022 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657134745; x=1688670745;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=DZdncc++SX6z3qvBj/0o2B0yIiwG2l2LTgHc5TLKSbU=;
  b=SgVdBQgAd6wUgTJGu5CK7DcHttI0Mdz7L41REDYxvTn+5qSnDGWwK0Jg
   h3BQRzsHN9X04b9zfPXA0zAG5JxRZdK6YrDgo6iQNjTYqTERltNL6skuG
   c+ApR+V8N3x4AgwFyxFUGITHwgv1ORLhQFHyoyAgnuKzGs51JKVR89dqa
   I77JvxRWMbq3ZzEtR3JkpHnL+Mx4hwmsnKIK3ZneeTQ6jNk9cAsMvhK8s
   fm82zI0Oq8lknnxKUwKLdC8OKD/ISiBoh3gJh0wRugoHrL7sfPFsXsCDp
   1rqUe4p8F0JtAkTS3yJTSdgcyL5SPN6D0QtirAwdBrU9MYg+Ygt027WFW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="309400295"
X-IronPort-AV: E=Sophos;i="5.92,250,1650956400"; 
   d="scan'208";a="309400295"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 12:12:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,250,1650956400"; 
   d="scan'208";a="568197894"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.161])
  by orsmga006.jf.intel.com with SMTP; 06 Jul 2022 12:12:20 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 06 Jul 2022 22:12:19 +0300
Date: Wed, 6 Jul 2022 22:12:19 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drm: xlnx: add <linux/io.h> for readl/writel
Message-ID: <YsXekxslwDbfk4ax@intel.com>
References: <20220706184224.29116-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220706184224.29116-1-rdunlap@infradead.org>
X-Patchwork-Hint: comment

On Wed, Jul 06, 2022 at 11:42:24AM -0700, Randy Dunlap wrote:
> Add a header file to prevent build errors:
> 
> ../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_write’:
> ../drivers/gpu/drm/xlnx/zynqmp_dp.c:335:9: error: implicit declaration of function ‘writel’ [-Werror=implicit-function-declaration]
>   335 |         writel(val, dp->iomem + offset);
> ../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_read’:
> ../drivers/gpu/drm/xlnx/zynqmp_dp.c:340:16: error: implicit declaration of function ‘readl’ [-Werror=implicit-function-declaration]
>   340 |         return readl(dp->iomem + offset);
> 
> Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")

Should be
Fixes: a204f9743b68 ("drm: Remove linux/i2c.h from drm_crtc.h")
probably?

allmodconfig caught a few other drivers needing io.h but somehow
this one built for me without that header on both arm and x86.
Was this on some other architecture, or maybe there's some weird
config dependency that pulls in io.h for allmodconfig?

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Michal Simek <michal.simek@xilinx.com>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/gpu/drm/xlnx/zynqmp_dp.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
> +++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
> @@ -25,6 +25,7 @@
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/device.h>
> +#include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>

-- 
Ville Syrjälä
Intel
