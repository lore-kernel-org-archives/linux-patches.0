Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C1F27456
	for <patches@lists.linux.dev>; Thu, 17 Oct 2024 02:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729133096; cv=none; b=uS37xwfPrRM49nNzN/dCGFPyTE3SNe83lvC6IUThxTrWJs+4VEX8A43dTaQSvSmI/xbyq2pqGdNOASxj43ztgLyfbVy2wOIaReQ1mhlVXX2Xd4XcZwchSZ15caWEsIQpKYHe9CKgbds+GosKzRHadXunRR4W/HOWgKWyUGN6+7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729133096; c=relaxed/simple;
	bh=7ta3z/hV/IpZ4ahIXqlJcX/G80JpAJT4ilUcS4INWxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VxdmpTUFWy+8U7YvzNJ4zFfCMIaWYvLgyGYbo5EMXi+d/r6xfFsZPbfcfMJpE27wAegmcNRmJyJt2AMacGlu0cihVf+QtjQzm2eh9H1R84RQaI4C4ugMiKqjtKs4vREjJlrHA/1pnhQyKpo2mGMDKJ3DXABbO1UB859yGVC7vrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fsGLmLEY; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fsGLmLEY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=ECKMUpYSJvQNNNhUeowTTPXY5+HEoB+I2ZvTarA4H6I=; b=fsGLmLEYMnvUIBf1xYys/7h2gB
	TTnJybOtwM/KZbqq1J4v2ECpHy3k7z4gatjn0FJ+mgi02f1KPaxcrauATe1bLAt/HozZZLXZ541VC
	VGPLXOPuuSeDI0Ybc22spxT2LOC82ZplJUKIiekOBT5yitnN0WzEIY6jiVPG3bs5Igb/GPD+oml37
	Xa2Bttxysn2xp0zdCFlRk/RERQoeRkf4QCHl7xzY72IrCG5rZCyzGH93u2Bz0QjSJhi8udWcHnlSS
	Dbv8dSH906agIEdmyFfgBlSVFo1zLUecZp32NZdJM+hQ/8uB6n/Ugut8c64T6kLLxgpfUsEiht4fy
	e4Q3Z8Rw==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t1GVN-00000009nfx-3KZh;
	Thu, 17 Oct 2024 02:44:50 +0000
Message-ID: <3380e075-ea9e-495a-b011-c2af47dbc1d5@infradead.org>
Date: Wed, 16 Oct 2024 19:44:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] >>>>>>>>>>>>>>>>>>>>>>> FIXME <<<<<<<<<<<<<<<<<<<<<<
To: dri-devel@lists.freedesktop.org
Cc: patches@lists.linux.dev, Stephen Rothwell <sfr@canb.auug.org.au>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Thomas Zimmermann <tzimmermann@suse.de>
References: <20241017024305.61318-1-rdunlap@infradead.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20241017024305.61318-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Whoops, I reverted the subject line change.
Will resend it.

On 10/16/24 7:43 PM, Randy Dunlap wrote:
> 
> drivers/gpu/drm/drm_fbdev_dma.c:1: warning: no structured comments found
> drivers/gpu/drm/drm_fbdev_shmem.c:1: warning: no structured comments found
> drivers/gpu/drm/drm_fbdev_ttm.c:1: warning: no structured comments found
> 
> Fixes: 731fddf4302e ("drm/fbdev-dma: Remove obsolete setup function")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: dri-devel@lists.freedesktop.org
> ---
>  Documentation/gpu/drm-kms-helpers.rst |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> --- linux-next-20241016.orig/Documentation/gpu/drm-kms-helpers.rst
> +++ linux-next-20241016/Documentation/gpu/drm-kms-helpers.rst
> @@ -110,15 +110,6 @@ fbdev Helper Functions Reference
>  .. kernel-doc:: drivers/gpu/drm/drm_fb_helper.c
>     :doc: fbdev helpers
>  
> -.. kernel-doc:: drivers/gpu/drm/drm_fbdev_dma.c
> -   :export:
> -
> -.. kernel-doc:: drivers/gpu/drm/drm_fbdev_shmem.c
> -   :export:
> -
> -.. kernel-doc:: drivers/gpu/drm/drm_fbdev_ttm.c
> -   :export:
> -
>  .. kernel-doc:: include/drm/drm_fb_helper.h
>     :internal:
>  

-- 
~Randy

