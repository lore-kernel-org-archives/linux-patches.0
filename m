Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B03C1DE3BB
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 08:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955550; cv=none; b=F05NATrO6NUujrGqqG9I4nk516P12qOnD/sQV0Uj0MW/z4HEAlbyTeGS0BOCEdbcjtUB8Pk9bDDW9WjldDCxNfqAM61RM+ibgJkOV6mgz7js57X95KriSYmtIsGgduNZjQUg/365CrbyTqzG7MOGV8nnr7wtD5zNBLq21TtTmuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955550; c=relaxed/simple;
	bh=IrzFKL+oIfGWI2q1BLYSb0MXOUzPdMMijI+zZGL3rEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aywKBH+j/fAAE7WujAP7IP3dhmhg9Gt2pcn+maWJd9Ojdn9kUXAEsjb/TfCZpX56ec/nbTa6mszf4fbA/7EW/4X62IbphRHS30+WNM+F/Nxtn7iNlapa3gnbUPkJ8/NgomviHeeceZ5hPwyyuEKvO6i8qyhntmcAbEC8MfrDD+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ur5nvPOT; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ur5nvPOT"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5ded46f323fso8481102a12.1
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 00:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739955547; x=1740560347; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdLd4d/2KvKjfUhQztRQPCox3np4HSwf6kDWlFesZVw=;
        b=Ur5nvPOTLMiA/rBtPABInxqTm5Lne3Gn/0cWRjWu5bnRYW2aXuAaFO77HXez+W6bSH
         VssJ+T+jFtq1Cuv/J2/HoC3bBNa9jipDRxAfROG7iEyZRvJ7YPQ9EMRtrZxHl9Tjm0D1
         h+PFoC/NfhMTZAnZkH/g3401Qn/PQHn8PqNfsRi+XZqzB7VAnxoUm5E0bkRDupP5o6rG
         VPLlTjMl5cb73tjp+MiJYL0YEh0HSoXgJ0dS7sowIWguQxoCUmP5STBozlrrhHjcYnLY
         EXrybYC33IsK1CQoGTTvI5quLn5/YM5i4yKWqUBbgrpo/ZRKM32cO4M+DeWHrWRtAFyv
         QZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739955547; x=1740560347;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdLd4d/2KvKjfUhQztRQPCox3np4HSwf6kDWlFesZVw=;
        b=YY/BIVgmqDd3uNWnqSOyxc45mK+HP3o19c+qu4LTFfUBj0UOdSezDNTCmjdC2mccZ1
         Xye1ebun4sdExvNwpnuI+zS1z1Z0/GHcmgwqbGmHCm7q9SQJMoXOW+CedTUvjGyhrOEN
         bslD+pP3qFTNdd3eV6Cp1yjkxWyH+hUdJI5o7Q3QXvD48AwKs39id2FS3++lXO1zgKMh
         iRZixxVBbxJdC/5sYy7Rkmw+BYESpz9n9VjqR3bV3eyQJ++v6kIb7P+RN0fDy3ygAWVc
         7FBS9HnMTZETNObTAruPf6V7l1dtv5hum2tjpZk/TLBlfMJMa2naV8ifJtcl5qG7UVUn
         Z/zA==
X-Gm-Message-State: AOJu0YzUbmMRpJqUVE9DkqkBFoxiqsAm/RGtQoveW/gPAE1UK31cx8Fl
	M0RL/Wuhb8DMUew/sdQXhm2sstgGPl7IMwRfcH1ThbcNcIUrser3
X-Gm-Gg: ASbGncsK6/pSmXvAy9pvFRgzUrGpnKOat7Y9CdO67FqfwPO2aLwWxS9pJ6f3JvR8AdE
	FGmol+jp03N9eRbWbMvooSZotgevv30g/4CRcTzDuSZyQQU2ccfuA9o0Nm+7mVFHXhe3fnzGt+A
	fuMrGCzrKUBxfL34tfkU2GnFMf5Z+m9QZXX2mUjdb9zm/nlibsEsKyUFW7C/VE7lKn/Gu8LMEqq
	3sjySbTXnh6ZuaaTphgSfYfJekaDgrnRBxrjSV9oFQakiW+l8GnPFv3zMBNIK2k1m4TsXgsIoXk
	SRfNj2uGAwVtlI7KL/2ud0ZZ4/XSPDuE5lOOn5VcD/Zpf4YdUXgnMHnMcg==
X-Google-Smtp-Source: AGHT+IFwjUlxoWQ4SJRaGj/REGKr2twn6c6LaS+NPPraquSZEVgdYZMC5ImE+AiM5Q6Av78vsPAdqA==
X-Received: by 2002:a17:907:7dac:b0:abb:b12b:e104 with SMTP id a640c23a62f3a-abbcce4cba5mr256021366b.31.1739955547086;
        Wed, 19 Feb 2025 00:59:07 -0800 (PST)
Received: from [192.168.0.9] (pc-201-96-67-156-static.strong-pc.com. [156.67.96.201])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb98ed07afsm568376866b.102.2025.02.19.00.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 00:59:06 -0800 (PST)
Message-ID: <96738386-9155-4eea-b91d-8590ef3b4562@gmail.com>
Date: Wed, 19 Feb 2025 09:59:05 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 116/274] drm/amdgpu/gfx9: manually control gfxoff for
 CS on RV
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Lijo Lazar <lijo.lazar@amd.com>,
 Sergey Kovalenko <seryoga.engineering@gmail.com>,
 Alex Deucher <alexander.deucher@amd.com>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082614.161530240@linuxfoundation.org>
Content-Language: en-US, pl-PL
From: =?UTF-8?B?QsWCYcW8ZWogU3pjenlnaWXFgg==?= <mumei6102@gmail.com>
In-Reply-To: <20250219082614.161530240@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

This patch has to be changed for 6.13 - "gfx_v9_0_set_powergating_state" 
has 'amdgpu_device' argument instead of 'amdgpu_ip_block' argument there.

On 2/19/25 09:26, Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
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
> @@ -7439,6 +7439,38 @@ static void gfx_v9_0_ring_emit_cleaner_s
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
> @@ -7615,8 +7647,8 @@ static const struct amdgpu_ring_funcs gf
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

