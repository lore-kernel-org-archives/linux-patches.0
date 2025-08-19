Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5C01F8EFF;
	Tue, 19 Aug 2025 02:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755568872; cv=none; b=ug+XxVhUv2vG3mI4HmLXkZl9G2CWC5azEH8iy/EnoCFgnEYBti6SoVFw3R51fU7RAdDjvGRIPAeq7XqROsO872emZ7XI7XzAH0yklYlxVVfwIwd8eZvqvVOAXRcPJPdMbK8BWTRQFSS9kjq+Tt+H7N8mzEi8y2HaqsF0AMPn/3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755568872; c=relaxed/simple;
	bh=PUkNlXKrmXY1CLgusGbdGf67x2cphnPK0xcltNm/Pnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bejg6/KpmleRtseH9+YKf15YpcXL7doQ188qoChLbeAt2DcaC7FLhXYf59NyxgPYzh6P6AooTx59HAKWJp59Jb4ni42VQxsP0RBIgFNDclonmZIwYVJ9gDkpd0YinRshUCmNAJOXlSPTjRx4EJNHnfUsRVc31VW1zwOJjw7+j14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8gM6zTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8gM6zTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8513EC4CEEB;
	Tue, 19 Aug 2025 02:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755568870;
	bh=PUkNlXKrmXY1CLgusGbdGf67x2cphnPK0xcltNm/Pnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V8gM6zTpI4jGfutyv8uTMMwZ9+TjZKeLUvOgai/D4/vXbmo5eW34untPXahra9Lva
	 61N/2Tni0GlkAenRGHPy16B8qZmez5XDY8jo+j25YrJAaPMDQCgI8q0GwFT7vW3Us2
	 woOeg208mpKHhvzkOcBV8lYXW2aFqHGUg6eX7/OPePeWgim3tsazSCdxeFtud+EinT
	 SELPM+R3nhc79KjMSj5ALnQlUOQUHLfqsyUfZnjQIAWMO0R0eIYdjrso4zvwzwSbg7
	 BUDlwef1VRh/vl7zzCXivNOVz4ZGxCppETE2YndWki/Cb5Ft1cL3iULdG+4thSV+eO
	 Fy3fgzx8fw3UA==
Date: Mon, 18 Aug 2025 22:01:09 -0400
From: Sasha Levin <sashal@kernel.org>
To: Michael Walle <mwalle@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Lee Jones <lee@kernel.org>
Subject: Re: [PATCH AUTOSEL 6.12 27/69] mfd: tps6594: Add TI TPS652G1 support
Message-ID: <aKPa5TMzs-hAfEgE@laps>
References: <20250804003119.3620476-1-sashal@kernel.org>
 <20250804003119.3620476-27-sashal@kernel.org>
 <DC5CEJ4YYRRB.3VTJAONRBJPVB@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DC5CEJ4YYRRB.3VTJAONRBJPVB@kernel.org>

On Mon, Aug 18, 2025 at 08:34:03AM +0200, Michael Walle wrote:
>Hi Sasha,
>
>On Mon Aug 4, 2025 at 2:30 AM CEST, Sasha Levin wrote:
>> From: Michael Walle <mwalle@kernel.org>
>>
>> [ Upstream commit 626bb0a45584d544d84eab909795ccb355062bcc ]
>>
>> The TPS652G1 is a stripped down version of the TPS65224. From a software
>> point of view, it lacks any voltage monitoring, the watchdog, the ESM
>> and the ADC.
>>
>> Signed-off-by: Michael Walle <mwalle@kernel.org>
>> Link: https://lore.kernel.org/r/20250613114518.1772109-2-mwalle@kernel.org
>> Signed-off-by: Lee Jones <lee@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>
>> LLM Generated explanations, may be completely bogus:
>>
>> **YES**
>>
>> This commit should be backported to stable kernel trees for the
>> following reasons:
>>
>> 1. **Hardware Enablement (Device ID Addition)**: This patch adds support
>>    for a new PMIC variant (TPS652G1) by adding its device ID and
>>    configuration. According to stable kernel rules, patches that "just
>>    add a device ID" are explicitly allowed for stable backporting.
>>
>> 2. **Self-Contained Changes**: The modifications are isolated to adding
>>    support for the new device without altering existing functionality:
>>    - Adds `TPS652G1` to the `enum pmic_id`
>>    - Adds TPS652G1-specific MFD cells configuration
>>    - Adds device-specific IRQ mappings (subset of TPS65224 IRQs)
>>    - Adds compatible strings "ti,tps652g1" to I2C and SPI device tables
>>    - Properly handles the stripped-down nature of TPS652G1 (no RTC, ADC,
>>      watchdog, ESM)
>>
>> 3. **Low Risk**: The changes follow the existing driver pattern and only
>>    add conditional paths for the new device:
>>   ```c
>>   if (tps->chip_id == TPS65224 || tps->chip_id == TPS652G1)
>>   ```
>>   This ensures existing device support remains unaffected.
>>
>> 4. **User Benefit**: Without this patch, users with TPS652G1 hardware
>>    cannot use their devices on stable kernels. This directly impacts
>>    hardware functionality for affected users.
>>
>> 5. **Proper Implementation**: The patch correctly handles the TPS652G1
>>    as a feature-reduced variant of TPS65224, sharing the same register
>>    layout and CRC handling while properly excluding unsupported
>>    features.
>>
>> The patch is relatively small, follows established driver patterns, and
>> enables essential hardware support without introducing architectural
>> changes or new features beyond device enablement.
>
>While this is correct, the MFD patch on it's own is rather useless,
>as the individual driver implementations are missing. See
>https://lore.kernel.org/all/20250703113153.2447110-1-mwalle@kernel.org/
>
>I don't care too much, I just want to point out, that just having
>this patch might be misleading regarding the support of this PMIC.

Yeah, it doesn't make sense to keep it in. I'll drop it.

Thanks!


-- 
Thanks,
Sasha
