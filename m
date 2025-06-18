Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CBB3085A0
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750270010; cv=none; b=F7ecWs/7F1zpBNtxxLst4bdaFg3TwZY9uAK+MnLDFlACJ4nQWaDC+L5wjqP9heJxsMTtLu7H2AAhE1AMAeWdH+cr7F3upUMIB9EU0SD0LtXRVUhOtyTKl45LfN5VmS30t+wCzRVl6mOX6C3sGLSCnbNvOpIGdN3Nkuu9JcvYdI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750270010; c=relaxed/simple;
	bh=4UxIorS9u/2wr6VbykR0LVGJhqyFnyu9BzNhtKoDquM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d0tqqeZ61WxMJRECVoUt+SOdULbxf/qPOIvpiC5yhr9U9r+ddzuwsdTI8PoowCXc2x0vzWcUaBUtnF2hMGv9PsLsAv8CgM1qNPrtIMkmEMLhq2SWkQvFDYOrCw5eab8XcOB+f+cmBUCMY/apaUkFX8VLwIlQMLWoCiAni4JbAx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eSGOrH2r; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eSGOrH2r"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad8a8da2376so1187361866b.3
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 11:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750270007; x=1750874807; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CVsnoAaBCTIdKKJkVTQB78TAIaC0K0blIS1rLndiaXA=;
        b=eSGOrH2rnj+aRM1bz82kgeTpCDwDQVO2BSrJXKClK/2YnLXvifu1hxosWB8yp6g8I1
         3jttKtpgx0NWUrFcCf4JDOqy99gvrQ4dhlxa5inQ1gbE7nQMKSZyK1/ZzZQoqq+xFYpP
         4Pj5oddFHjOevN+l8D23mN7vcA7/fb3iL0SHB4u1ELz6jNxDSqsELcZlgP+3lYC8z2M5
         vfGriVgPjMSQr2Q9G3EJX+y/HAtf74qcKKxdzqCFtDu/c8vfaYVTqP6R9OHpLKHRRox8
         A7Dw+G+mrQA5w/cuD94+LOQxZxL1JwZ1wqyG0Emuc2nyjux7/PVLWt70fvOYDL3vWH1r
         4igw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750270007; x=1750874807;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CVsnoAaBCTIdKKJkVTQB78TAIaC0K0blIS1rLndiaXA=;
        b=Rn9QWv0jLdGzuISFQObKVwpjxb4gI9AwLNe7q4h332yqssZvumq+wF5vdFeK8KORB5
         IF1sKNmA80nhofXqhEyZpSvKUvFW3aoNXzQPR8zq+SMepSApmTGu8ku2ePHgGyL7I8Jb
         MZyqVgBUkii7Cunvw4uaBbRnVQee5t6gBSUKnCUo1J5/qEJXDXrty4B3Tn4kWTQ44qKN
         tRexBtSSsglbhVfVi/20sZTQl0Ng9pHaBe4ROs9+hzHQXgKpcE+ZKb0ENoWin2jpi91/
         8bgz/dGtpSg87GrsJ3T10Ts4ZdQCFnTAO9vR2kQL874FhovWx/hX8eavIkWjp9PM6FpP
         ATBw==
X-Gm-Message-State: AOJu0YzCnrdAfIhNdoCX2CmGeQVnH7j2s4qiJefH6FvF9PTc4WuoO/pG
	Tci9XBrTnf7EVU8gMos5i22lmwnuokKdl0qNIDSTVN65MZmc1AyoF0mXQ5H4xooCg7M=
X-Gm-Gg: ASbGnctFa+dcTG6meowAulPytpuiD11CZ/yi6q1uE/KD/kN9XVr5D9OMBP0KcYENoxO
	Lcxdx3z/Kkvk7zIsFHZbrhW9eb0nGnGpn6ftQwxfywHZPbDLGUBLdiSCRk4Oa4BlEul5P75Jzmv
	acHamfDlBrpYLxkILIGizlwHLz3ru8Rh73Oh0IPBKom+BwS/+D+wX6j7AuJH8fC/q4teneZ6tmc
	zpD3o61vFNGFtOxqDKm8CMY+HnMyBvvSQKqrWPJHu2UFvvoWrhnC/3yM+L7wO9h88QFJXcuW7gS
	qBINdUD5b4JnFx5V29KuVtP2nRLyW3254tLh96KDCkr7hGuOfrZ0+lEIMucwjgObvWSgecAt3t5
	7WbKSuxudUZm1OMei2mseFhwRtepWEUJxV1WafZTxP5Kr5ncAMgQ=
X-Google-Smtp-Source: AGHT+IHf7Susr5VjmYbzL3tuCAynwWMlblBJ1gw7Rc53j97yh7bCjJFvjkknlqgE5T/JBDjzuzcbqw==
X-Received: by 2002:a17:907:2d26:b0:ad2:4b33:ae70 with SMTP id a640c23a62f3a-adfad43868bmr1934234366b.31.1750270007014;
        Wed, 18 Jun 2025 11:06:47 -0700 (PDT)
Received: from [192.168.23.225] (ip-037-024-206-101.um08.pools.vodafone-ip.de. [37.24.206.101])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8158d8esm1090533766b.5.2025.06.18.11.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:06:46 -0700 (PDT)
Message-ID: <a91ca229-0603-4385-9f9e-01f3c3ede855@linaro.org>
Date: Wed, 18 Jun 2025 20:06:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 296/356] ath10k: snoc: fix unbalanced IRQ enable in
 crash recovery
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Caleb Connolly <caleb.connolly@linaro.org>,
 Loic Poulain <loic.poulain@oss.qualcomm.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152350.087643471@linuxfoundation.org>
Content-Language: en-US
From: Casey Connolly <casey.connolly@linaro.org>
In-Reply-To: <20250617152350.087643471@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/17/25 17:26, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Caleb Connolly <caleb.connolly@linaro.org>
> 
> [ Upstream commit 1650d32b92b01db03a1a95d69ee74fcbc34d4b00 ]
> 
> In ath10k_snoc_hif_stop() we skip disabling the IRQs in the crash
> recovery flow, but we still unconditionally call enable again in
> ath10k_snoc_hif_start().
> 
> We can't check the ATH10K_FLAG_CRASH_FLUSH bit since it is cleared
> before hif_start() is called, so instead check the
> ATH10K_SNOC_FLAG_RECOVERY flag and skip enabling the IRQs during crash
> recovery.
> 
> This fixes unbalanced IRQ enable splats that happen after recovering from
> a crash.
> 
> Fixes: 0e622f67e041 ("ath10k: add support for WCN3990 firmware crash recovery")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>

If fixing my name is acceptable, that would be appreciated...

Otherwise I believe this patch makes sense for 6.6

Thanks,

> Tested-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> Link: https://patch.msgid.link/20250318205043.1043148-1-caleb.connolly@linaro.org
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/ath/ath10k/snoc.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 2c39bad7ebfb9..1d06d4125992d 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -937,7 +937,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
>   
>   	dev_set_threaded(&ar->napi_dev, true);
>   	ath10k_core_napi_enable(ar);
> -	ath10k_snoc_irq_enable(ar);
> +	/* IRQs are left enabled when we restart due to a firmware crash */
> +	if (!test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
> +		ath10k_snoc_irq_enable(ar);
>   	ath10k_snoc_rx_post(ar);
>   
>   	clear_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags);

-- 
Casey (she/they)

