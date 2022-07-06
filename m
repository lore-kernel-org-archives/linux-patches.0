Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14207C
	for <patches@lists.linux.dev>; Wed,  6 Jul 2022 19:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657137547; x=1688673547;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kjpy062Qltmyrk4wWOWM13YvF6LSPgS7JtHTzMPxwgo=;
  b=A44Fv93k+RmVUyx2FRx3721X5p9vRJn06cwg81Of3A1wqdyx2nPRw1nu
   C/rQRGk54XHwCdB+sCzSheao10frcEK8WnCsjt1JFK8mdBX7CQvHwgWvV
   XrZe6R37YCzw3OMAKZoGmzR+wWQYD4LeaBHv/jVRCUaJRHkanigpBVYQD
   kjRx050+5tJIH4ag1Ot+NZ2yOgorL2/8IuuAaWQ2YefE1Zm5EAa+iouCV
   u1Bp69NBdfLS9apMN3cKST2Cpvs2u33aAPSA8tG+ASGxHbwdQuVyf+nXv
   SZWmwDP9AA/kwW4qV/VWMJ+Q/wOCCBNw/8Utkobd9tWleU3ei2Q23vXxA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="263642166"
X-IronPort-AV: E=Sophos;i="5.92,250,1650956400"; 
   d="scan'208";a="263642166"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 12:59:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,250,1650956400"; 
   d="scan'208";a="626043566"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.161])
  by orsmga001.jf.intel.com with SMTP; 06 Jul 2022 12:59:03 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 06 Jul 2022 22:59:02 +0300
Date: Wed, 6 Jul 2022 22:59:02 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drm: xlnx: add <linux/io.h> for readl/writel\
Message-ID: <YsXphrTyCnLgwR5t@intel.com>
References: <20220706184224.29116-1-rdunlap@infradead.org>
 <YsXekxslwDbfk4ax@intel.com>
 <7669696e-16ec-21fc-a992-92a5a77babce@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7669696e-16ec-21fc-a992-92a5a77babce@infradead.org>
X-Patchwork-Hint: comment

On Wed, Jul 06, 2022 at 12:15:23PM -0700, Randy Dunlap wrote:
> 
> 
> On 7/6/22 12:12, Ville Syrjälä wrote:
> > On Wed, Jul 06, 2022 at 11:42:24AM -0700, Randy Dunlap wrote:
> >> Add a header file to prevent build errors:
> >>
> >> ../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_write’:
> >> ../drivers/gpu/drm/xlnx/zynqmp_dp.c:335:9: error: implicit declaration of function ‘writel’ [-Werror=implicit-function-declaration]
> >>   335 |         writel(val, dp->iomem + offset);
> >> ../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_read’:
> >> ../drivers/gpu/drm/xlnx/zynqmp_dp.c:340:16: error: implicit declaration of function ‘readl’ [-Werror=implicit-function-declaration]
> >>   340 |         return readl(dp->iomem + offset);
> >>
> >> Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
> > 
> > Should be
> > Fixes: a204f9743b68 ("drm: Remove linux/i2c.h from drm_crtc.h")
> > probably?
> 
> Ack, thanks.
> 
> > 
> > allmodconfig caught a few other drivers needing io.h but somehow
> > this one built for me without that header on both arm and x86.
> > Was this on some other architecture, or maybe there's some weird
> > config dependency that pulls in io.h for allmodconfig?
> 
> x86_64 in linux-next 20220706. (some randconfig)

OK. Must be some oddball config option combo then.

Changed the Fixes tag and pushed to drm-misc-next. Thanks.

> 
> > 
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
> >> Cc: David Airlie <airlied@linux.ie>
> >> Cc: Daniel Vetter <daniel@ffwll.ch>
> >> Cc: Michal Simek <michal.simek@xilinx.com>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> ---
> >>  drivers/gpu/drm/xlnx/zynqmp_dp.c |    1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> --- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
> >> +++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
> >> @@ -25,6 +25,7 @@
> >>  #include <linux/clk.h>
> >>  #include <linux/delay.h>
> >>  #include <linux/device.h>
> >> +#include <linux/io.h>
> >>  #include <linux/module.h>
> >>  #include <linux/platform_device.h>
> >>  #include <linux/pm_runtime.h>
> > 
> 
> -- 
> ~Randy

-- 
Ville Syrjälä
Intel
