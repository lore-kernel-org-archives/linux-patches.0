Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDC47C6F6
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207637; cv=none; b=f/G6yltTCCT6SIoUy1P2Lz08LoTZ9spxrO9qxNQT0yPO9dnTtb6RYUBiNIslVdn1XYTVGjznPwD1ACx5hl7keAqqXqYkrSqSsBBAIJf6UiVkUcGElS0x4iyHW6tT57Wirq9CafScYn3Npa6yOBeVpF0LW9Vk9x3qrVS5EM2pPg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207637; c=relaxed/simple;
	bh=aPkZ1pZjNnJJI5Q/fiChvIDLNBuCtmd06jZTdL+Ggyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FXyWLrVGpjZLVgHAMiSvArKblGdESA1Uqj6Eb8cm0dFDT7BX9UL80YmUnuVjWEcg6zPcZn0UP5ftEw7EUVdhws3l5uccTezDEpiUMspd5q9+9udZ3AaShN0CjxLiAGM9utKP0BnlawaEEr4/0S0g7qz0jMdOEhz9TNBTNcb7v0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qYe5K3Wh; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qYe5K3Wh"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5131a9b3d5bso803838e87.0
        for <patches@lists.linux.dev>; Thu, 29 Feb 2024 03:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709207634; x=1709812434; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sLTFaT7Nkx/eCJKDRCtLdc30QfXkBoGZ+x/B0puoFKM=;
        b=qYe5K3WhSNGWqEoc/bnNasAi5scLHJQ+7T/ZGNZbuDxjKBMpGNoPS0piF2yncEYEHP
         LCHprBMFbIhJ8PYjZoHPrevJ+ewryWasWXEPbDzmmc+kErS3dn0tUfOSfwsaF715FtIr
         2SNAmRIU4cxomDJs1ygdgg8CiuE93FWuOiLESuJWBDtJ36O+e+dGXUlpXX9QIWwEAfY7
         3xdK3RoDn7dze/g5bDbHllcZI+8rp4UZTBrrtqSpcI17kAm/WFADVSPeaTKJzCTq6srr
         6MANQeLr2rLvBsRXARfeYLLjvq95a4rFc3reNfcIoBYsr+bMF5hIM2vyIuzDnX+6HLcu
         nNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709207634; x=1709812434;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sLTFaT7Nkx/eCJKDRCtLdc30QfXkBoGZ+x/B0puoFKM=;
        b=rT/pUY+kgqkNx91RAiants7txu7BfwlNhtIDB6Rd4IBPu9KltgguUcAwld1cK3GTCK
         e683Z1CcOqfXygjziSem39Wgx33Qg9sFgIuHR188JyD7qS8eodVxO1sv9PUSk5NA9Bbm
         R1I9VNgPV95ttuRrT1mLPVXyOwiLjnrTEvK8zR0M2GTqv8AXk+EkjX4E2e/Y1QrSxnA+
         r4DuMhNtj24gvmzN+69hv9wNDeec872sKly97Xu4RrprU9Mr8sun+MSdDJlcTORZkXPC
         Tb9+l4DvWeHPaRYmt2Lu+y0FsaFSN0M6L5M3hsyFzEMQ3xGrl2E8Hn6ZJ/GI85orTFtl
         4SxA==
X-Forwarded-Encrypted: i=1; AJvYcCUDg4koHWAHfV8AKmrnEG2nOJAZdqZbHABqed7pGwYV3u1Nb+Q+UBJSIWgOBMWtnnKnJIzrkjXzuvq4Else+5TVvt1man7j7w==
X-Gm-Message-State: AOJu0Yx/vTzJCXr/LfZifCkMVKYCwuN7A6zlBFrqRPIckd7e5HwjQbdH
	pCAwadm2S7/IkXPZMH+lwyW7/ejr134Q4zn50IVkLQ0WssQ7LfgrfxTA8TmM6rk=
X-Google-Smtp-Source: AGHT+IGP0/pA++rl3U7efvrQPpAwssqlcxwqZNQ6Tt9Nv8HtPUR9CpPCo6oXDAAXGe9esJJngWtvkQ==
X-Received: by 2002:a05:651c:2105:b0:2d3:776:a8ab with SMTP id a5-20020a05651c210500b002d30776a8abmr967147ljq.45.1709207633804;
        Thu, 29 Feb 2024 03:53:53 -0800 (PST)
Received: from [172.30.204.118] (UNUSED.212-182-62-129.lubman.net.pl. [212.182.62.129])
        by smtp.gmail.com with ESMTPSA id b10-20020a2e894a000000b002d0d02e50fdsm201372ljk.78.2024.02.29.03.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 03:53:53 -0800 (PST)
Message-ID: <2f6bf03f-b0c4-46d2-baad-4047c78663bc@linaro.org>
Date: Thu, 29 Feb 2024 12:53:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: dts: qcom: sc7180: Disable pmic pinctrl node on
 Trogdor
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>, Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, cros-qcom-dts-watchers@chromium.org
References: <20240229012828.438020-1-swboyd@chromium.org>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20240229012828.438020-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/29/24 02:28, Stephen Boyd wrote:
> We don't use this pmic pinctrl node on any Trogdor devices. The
> AP_SUSPEND pin is here, but this pinctrl device isn't a supplier to
> anything in the devicetrees that include this file. Disable this device
> node in the DTS so that we don't waste time or memory on this device.
> 
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

If you don't use this pmic, perhaps the pins should be explicitly
"parked" instead?

Konrad
