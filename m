Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61777C
	for <patches@lists.linux.dev>; Wed,  6 Jul 2022 19:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=KfA7rQZnJC7/yvlTVPzr+t4ZswOKj5E0Kw9j6v3yIfw=; b=1NX6lk0iaqz4IM75k5SCvTRqR1
	WaTcvvKRSvGjupYn3ybjdUvewO4v171dyH3cSS6r1H5dSIwsnIH9am2iBB0iHiFIOPqetwLvt11x+
	DZ97m06d7DMeFx0KXdoP+MHat/B6T1vlLwMBbPHOfChUBxIZzbew91t/Fd6GtkyJl3Z2s+jU68/Jx
	z1x7RbAsXdOs3NP8dm0PHlIOzNZg78Pqa8Pu/PfFecCJpVvLsT4DmJaWFsuVpDK7bPUurmDj/61Zd
	ZZJInKqMJAkemeN72mXukq28wCM18f4CUXaD/kVoQuegrjPL9zWHtDaJxxbOQaMrxDqBlzhvep29/
	8G/ikdzQ==;
Received: from [2601:1c0:6280:3f0::a6b3]
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1o9AUe-00CAyZ-Sw; Wed, 06 Jul 2022 19:15:25 +0000
Message-ID: <7669696e-16ec-21fc-a992-92a5a77babce@infradead.org>
Date: Wed, 6 Jul 2022 12:15:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] drm: xlnx: add <linux/io.h> for readl/writel
Content-Language: en-US
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev,
 Hyun Kwon <hyun.kwon@xilinx.com>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
 Michal Simek <michal.simek@xilinx.com>, linux-arm-kernel@lists.infradead.org
References: <20220706184224.29116-1-rdunlap@infradead.org>
 <YsXekxslwDbfk4ax@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <YsXekxslwDbfk4ax@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/6/22 12:12, Ville Syrjälä wrote:
> On Wed, Jul 06, 2022 at 11:42:24AM -0700, Randy Dunlap wrote:
>> Add a header file to prevent build errors:
>>
>> ../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_write’:
>> ../drivers/gpu/drm/xlnx/zynqmp_dp.c:335:9: error: implicit declaration of function ‘writel’ [-Werror=implicit-function-declaration]
>>   335 |         writel(val, dp->iomem + offset);
>> ../drivers/gpu/drm/xlnx/zynqmp_dp.c: In function ‘zynqmp_dp_read’:
>> ../drivers/gpu/drm/xlnx/zynqmp_dp.c:340:16: error: implicit declaration of function ‘readl’ [-Werror=implicit-function-declaration]
>>   340 |         return readl(dp->iomem + offset);
>>
>> Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
> 
> Should be
> Fixes: a204f9743b68 ("drm: Remove linux/i2c.h from drm_crtc.h")
> probably?

Ack, thanks.

> 
> allmodconfig caught a few other drivers needing io.h but somehow
> this one built for me without that header on both arm and x86.
> Was this on some other architecture, or maybe there's some weird
> config dependency that pulls in io.h for allmodconfig?

x86_64 in linux-next 20220706. (some randconfig)

> 
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: Daniel Vetter <daniel@ffwll.ch>
>> Cc: Michal Simek <michal.simek@xilinx.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> ---
>>  drivers/gpu/drm/xlnx/zynqmp_dp.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
>> +++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/clk.h>
>>  #include <linux/delay.h>
>>  #include <linux/device.h>
>> +#include <linux/io.h>
>>  #include <linux/module.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/pm_runtime.h>
> 

-- 
~Randy
