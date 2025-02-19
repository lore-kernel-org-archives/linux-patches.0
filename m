Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D16C1DED57
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955536; cv=none; b=BKVF3mxedhjffQTXbxIr/XQMZDEj49K6LOd3QBkJilkloa1qwuAwXrL2w7IbZgKWfgxCwkqRHNAzqUmCPht0WKid7XqxwF7q/bGrDfODcFfk4ye/OFvZy8NXv4xVtNx57+VYX4BkpUDui6SuP1OMSwi7b9dntchqmnf083KbRO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955536; c=relaxed/simple;
	bh=wO/6BSf/ZusKqipQukzO7Dtz9mSKLmO+4Ku4WrpLgw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s2SfDXq47vJlwjWM4ERi00edtIpBtElOuEW5VGK7Zt86m4FojdgZTOBIFJddyz8/YiFRgWm6rAqBXl+dkTnOVt6cUpqW5F7wK+IklGKMHrhHpgsvqm4/eB+OMYZeKMPwbugB93Zcq0aWWdD6gaIKu9wFkeQLvUqKoO+auu90vNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lCghoFID; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCghoFID"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e0505275b7so5701245a12.3
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 00:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739955532; x=1740560332; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sPYgKL9mz20WeqRf2n6s6KWAKXTyT5lCL3eATb+Q0X0=;
        b=lCghoFIDckYwjmwghIhy1RZ21a4XUIedUYKuobmGRjf7f2uIXQ8fzF38OXkL0M8W98
         Uvin5bocjajuxlQ+gRJuzGXafpq1wmA8YhQBVXcV3MAdCTVrVorg65zb9+3gCZ6ds2ly
         +GSC48KiZ6zZnuRwq26nzO4U0qPfZQ46mPm3nJRz+Dugjz5nMmwKCqsO5dxm6D967xg0
         a65Cq54YmXIn4MbIz6DTyBIC0WhEWZiSHTBdUHWFEeMICGaFHoHjNkb2UQ2aXTiiYYK8
         YbrnJKQhMyKMnZVWaYvNSl2Z+YyCIdq2tQf9D6UrFpxZEhYhHHeutnqMt54dX/1Q2gYq
         E0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739955532; x=1740560332;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sPYgKL9mz20WeqRf2n6s6KWAKXTyT5lCL3eATb+Q0X0=;
        b=EHsxDk/Kk3tjbaqRN81TqDIp9AG7NZtjODPE6ZDt2hb6P3JIi83R0iB3dYLa+wpYvD
         /R2fYN8wWgFKQ46Mc/aTmoE/0CrkBKqMr28+4ekRVV5W2Opv1ly3HM4DbL6YJM2fPpM7
         Gaz5YSGuHFo6E2QyB91FcONouEBRp+MmdwTDSC3e9PJ3udTsqeGINpRCT/HOvnrLVqoe
         99uty5/JnAZZq8h4SUmefYDhN0dDxlutCEZsqEDyD/DetHlwpBc5VtUMLrmuxMNlDyKf
         AHhKg34IqNi0zLrwpeitTBhcydeTQEp4R+P8LhN+R90Hkue8ESiv0QWX889c8P2Nrvaw
         vAIw==
X-Gm-Message-State: AOJu0Yymy7Mv+xm+KmsNlFFTs8q9V8N0jhrXvFv0Z7QlhwHMk4TbkNxt
	lVtiKMImef+hHyWkMjGJgrdiAdPfbqznrNfqWd3DTPlUKTvqXsIwQHjx4I3z
X-Gm-Gg: ASbGnctx9srVw0wcMAfDsUshz1fzkk4HXvszigjlt1nJCkretAxChogTxrJc8TWYfio
	fK5UTtz5F46fAkF5ib5ACSaLHuEGcJrsdkYnkWxs76fsSbjtJ1YLrZDpTi8Yko89xag+gv11Npz
	mhtWX3cncx/5YAyOSU4bKobVkm3QXVW/tfPeWefv7Ay6FHdwjfj4SieXHJ96hNuUU61yTfZFibn
	4/28Rh8oygKsM423Z0a+nRpyFlZa5D8SC3CDwghd/gDfLvvfogF8sAwAN+gO55wcVDJEadjqoB8
	KMgnfO0UgOBsYUEbM6xc5T/2zu8nwnZ3XSk1JgjGyJTq1HzseSx+kwjcOA==
X-Google-Smtp-Source: AGHT+IF+lRwCFoZ/rYv2lYXMEsn99+2d5jWGkVFmY3F0KjL0NpDI7z/zZK2DhXNxEYNjhrHWOodACA==
X-Received: by 2002:a17:907:a088:b0:abb:b1ce:b4ed with SMTP id a640c23a62f3a-abbccc4df42mr258290166b.8.1739955531800;
        Wed, 19 Feb 2025 00:58:51 -0800 (PST)
Received: from [192.168.0.9] (pc-201-96-67-156-static.strong-pc.com. [156.67.96.201])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbb186c5d5sm352597966b.51.2025.02.19.00.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 00:58:51 -0800 (PST)
Message-ID: <bee822ff-b6eb-47ab-8d6d-af11e89ef5b2@gmail.com>
Date: Wed, 19 Feb 2025 09:58:50 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 097/230] drm/amdgpu/gfx9: manually control gfxoff for
 CS on RV
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Lijo Lazar <lijo.lazar@amd.com>,
 Sergey Kovalenko <seryoga.engineering@gmail.com>,
 Alex Deucher <alexander.deucher@amd.com>
References: <20250219082601.683263930@linuxfoundation.org>
 <20250219082605.490351110@linuxfoundation.org>
Content-Language: en-US, pl-PL
From: =?UTF-8?B?QsWCYcW8ZWogU3pjenlnaWXFgg==?= <mumei6102@gmail.com>
In-Reply-To: <20250219082605.490351110@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

This patch has to be changed for 6.12 - "gfx_v9_0_set_powergating_state" 
has 'amdgpu_device' argument instead of 'amdgpu_ip_block' argument there.

On 2/19/25 09:26, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alex Deucher <alexander.deucher@amd.com>
> 
> commit b35eb9128ebeec534eed1cefd6b9b1b7282cf5ba upstream.
> 
> When mesa started using compute queues more often
> we started seeing additional hangs with compute queues.
> Disabling gfxoff seems to mitigate that.  Manually
> control gfxoff and gfx pg with command submissions to avoid
> any issues related to gfxoff.  KFD already does the same
> thing for these chips.
> 
> v2: limit to compute
> v3: limit to APUs
> v4: limit to Raven/PCO
> v5: only update the compute ring_funcs
> v6: Disable GFX PG
> v7: adjust order
> 
> Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
> Suggested-by: Błażej Szczygieł <mumei6102@gmail.com>
> Suggested-by: Sergey Kovalenko <seryoga.engineering@gmail.com>
> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3861
> Link: https://lists.freedesktop.org/archives/amd-gfx/2025-January/119116.html
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org # 6.12.x
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   36 ++++++++++++++++++++++++++++++++--
>   1 file changed, 34 insertions(+), 2 deletions(-)
> 
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> @@ -7415,6 +7415,38 @@ static void gfx_v9_0_ring_emit_cleaner_s
>   	amdgpu_ring_write(ring, 0);  /* RESERVED field, programmed to zero */
>   }
>   
> +static void gfx_v9_0_ring_begin_use_compute(struct amdgpu_ring *ring)
> +{
> +	struct amdgpu_device *adev = ring->adev;
> +	struct amdgpu_ip_block *gfx_block =
> +		amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_GFX);
> +
> +	amdgpu_gfx_enforce_isolation_ring_begin_use(ring);
> +
> +	/* Raven and PCO APUs seem to have stability issues
> +	 * with compute and gfxoff and gfx pg.  Disable gfx pg during
> +	 * submission and allow again afterwards.
> +	 */
> +	if (gfx_block && amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 1, 0))
> +		gfx_v9_0_set_powergating_state(gfx_block, AMD_PG_STATE_UNGATE);
> +}
> +
> +static void gfx_v9_0_ring_end_use_compute(struct amdgpu_ring *ring)
> +{
> +	struct amdgpu_device *adev = ring->adev;
> +	struct amdgpu_ip_block *gfx_block =
> +		amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_GFX);
> +
> +	/* Raven and PCO APUs seem to have stability issues
> +	 * with compute and gfxoff and gfx pg.  Disable gfx pg during
> +	 * submission and allow again afterwards.
> +	 */
> +	if (gfx_block && amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 1, 0))
> +		gfx_v9_0_set_powergating_state(gfx_block, AMD_PG_STATE_GATE);
> +
> +	amdgpu_gfx_enforce_isolation_ring_end_use(ring);
> +}
> +
>   static const struct amd_ip_funcs gfx_v9_0_ip_funcs = {
>   	.name = "gfx_v9_0",
>   	.early_init = gfx_v9_0_early_init,
> @@ -7591,8 +7623,8 @@ static const struct amdgpu_ring_funcs gf
>   	.emit_wave_limit = gfx_v9_0_emit_wave_limit,
>   	.reset = gfx_v9_0_reset_kcq,
>   	.emit_cleaner_shader = gfx_v9_0_ring_emit_cleaner_shader,
> -	.begin_use = amdgpu_gfx_enforce_isolation_ring_begin_use,
> -	.end_use = amdgpu_gfx_enforce_isolation_ring_end_use,
> +	.begin_use = gfx_v9_0_ring_begin_use_compute,
> +	.end_use = gfx_v9_0_ring_end_use_compute,
>   };
>   
>   static const struct amdgpu_ring_funcs gfx_v9_0_ring_funcs_kiq = {
> 
> 

