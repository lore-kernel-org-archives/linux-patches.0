Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCECC85260
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 07:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728026055; cv=none; b=NbEwIWzEEw1RmsVm65R0d/iqUXF6QlTMCQK2JNJ7rIwc5wzzG7kVmYx3xWNSIYshox6V4X01l+LIN9eTMHqLBCV55/+PFknprxHDeduRDCEjRoe03hUFEFxqSSPHF/9E4JtqdlFFNakAfach5MuR9FvGR1KhuBZGv+ReCvHqLGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728026055; c=relaxed/simple;
	bh=1iMOmJ43CP6yXp20Vygffsp0eQ0LJHRK+2+LtCsCQqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufDOXSOfHJd8xpYB4k9yR2K6frxwIXmZN8dfT6ctJDZjaoKFHlQxN64kcNtc65uIw9jlBS+gtCScSlgBUEyKh3op1nFBUxJP2QwFLS3inJL9epA1xGmK+y1W3BrurTcPseeCRh/4rltCJb/+fs4zNFRGvXBB4HE9YzOJk60oaX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xz8lIaMC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xz8lIaMC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728026051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hBtwnr0LZruEJbvlzvyuk1+vZcUV6rsB3LNlgkW3ppA=;
	b=Xz8lIaMCGdSjd6MC/L6xu23krO2Twlt5boqi/vp+M7oY+tMSzWtizv18bFnnmdLisje5Cz
	zQz0vwKGT+KMnMEvGLGEIoy2y2Vhuif5alhjIbOBGABD2DOUF51HSICsXfa+p7ZBpWIc61
	0IE/LjeD/v2u4V0TFJrnN1RRsxjZhpA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-RY7lrr1aNHSbTSPpcKueNg-1; Fri, 04 Oct 2024 03:14:10 -0400
X-MC-Unique: RY7lrr1aNHSbTSPpcKueNg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37cd4acb55aso1293144f8f.0
        for <patches@lists.linux.dev>; Fri, 04 Oct 2024 00:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728026049; x=1728630849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hBtwnr0LZruEJbvlzvyuk1+vZcUV6rsB3LNlgkW3ppA=;
        b=D9/vqeeP8h+1XxhulfSg+/r8XydJA8beiIO7CtPY26/NPhtU+gWrPUdG94xlYO5s0W
         5kN1rqaUGOZWdWN8jQNZHsMNjF8vydezc5F2QP23I9IlXVzMhkSD+hg3KxsmLVad6moi
         Uj2r3JKqp+Ug6H7EmSsYnMkh/sLsy6WlZ7qk9Hv90+1yND++a5NqF+chAIJzispIx5eM
         nHJ0O5dOscmHWdAaZICWMhFZrvGY43r/xF7HNBBAvcJHybLHAGU6yN32ez80BnnXyemF
         eebInpn4a3uR2OoD50PRWLJPd+sOSf3tCVtv60dhHbuglq5dpvbK3OGsguE8nEkRVVcg
         FJQg==
X-Forwarded-Encrypted: i=1; AJvYcCURlk5+9I3rBioqa4sYWzbCfe2GO0qI4JbQZ4jnDq2RlFAG2QM3DMc0WgWwsYsbG/pvwbO9KVEV@lists.linux.dev
X-Gm-Message-State: AOJu0YzzK5j34COR5Ii8Dabz+w/NmH05OO+V+HHIY7XSt40pwrpykwPm
	VdIUOPC8maA+0/rBBFNSkavn5AhsQIbjEnK1oi9M3JeKo30QlxuWeLdjYS7JwXTGlCpWIPoIIsV
	ZiPCZHcW6pNhPbUmGPQybGxs7nWRecyU4WDGzX0zcxLh23vnC+kHLpyA=
X-Received: by 2002:a5d:5f54:0:b0:37c:cfdc:19ba with SMTP id ffacd0b85a97d-37d0e751784mr2002738f8f.28.1728026048945;
        Fri, 04 Oct 2024 00:14:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5EgGjYY0JfV/z7iaa59W+QZpz8ppmjKMbpPUYbcvmPnVnctrVU3GxGrg0lDO74dDBrAfR4w==
X-Received: by 2002:a5d:5f54:0:b0:37c:cfdc:19ba with SMTP id ffacd0b85a97d-37d0e751784mr2002722f8f.28.1728026048613;
        Fri, 04 Oct 2024 00:14:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:ced3:55bd:f454:e722? ([2a01:e0a:c:37e0:ced3:55bd:f454:e722])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d0822995fsm2673066f8f.38.2024.10.04.00.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 00:14:08 -0700 (PDT)
Message-ID: <609cf7e5-0fd6-4636-b5b1-b63fe319db28@redhat.com>
Date: Fri, 4 Oct 2024 09:14:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/panic: Select ZLIB_DEFLATE for
 DRM_PANIC_SCREEN_QR_CODE
To: Miguel Ojeda <ojeda@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20241003230734.653717-1-ojeda@kernel.org>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <20241003230734.653717-1-ojeda@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/10/2024 01:07, Miguel Ojeda wrote:
> Under `CONFIG_DRM_PANIC_SCREEN_QR_CODE=y`, zlib is used:
> 
>      ld.lld: error: undefined symbol: zlib_deflate_workspacesize
>      >>> referenced by drm_panic.c
>      >>>               drivers/gpu/drm/drm_panic.o:(drm_panic_qr_init) in archive vmlinux.a
> 
> Thus select `CONFIG_ZLIB_DEFLATE`.

Hi, good catch, yes it should select the zlib deflate.

Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>

Best regards,

-- 

Jocelyn

> 
> Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   drivers/gpu/drm/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index 1cb5a4f19293..cf5bc77e2362 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -152,6 +152,7 @@ config DRM_PANIC_SCREEN
>   config DRM_PANIC_SCREEN_QR_CODE
>   	bool "Add a panic screen with a QR code"
>   	depends on DRM_PANIC && RUST
> +	select ZLIB_DEFLATE
>   	help
>   	  This option adds a QR code generator, and a panic screen with a QR
>   	  code. The QR code will contain the last lines of kmsg and other debug
> --
> 2.46.2
> 

