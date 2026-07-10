Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C540861E
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 22:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783724014; cv=none; b=X8DrFmPMWjFfpFUsBPSzLORCnwAlBEyoAhvN7YFBE7EJsY6NpKZOzQ1zejtCpPxwdgE9izOCLYE7p5WaFYevaQAg/O+RHtPUC11QcFtlir1PYsxzARiCMJcGq6IRv3D4CqcG9i4UGpL9Mq0JXjWJdr56UzvIY7BXtmiGiKA655A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783724014; c=relaxed/simple;
	bh=XWDly2bshxB9+r2/vatmL2lJD5sH3CtBSsQ7Czp2trA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oGSjJmDlUDEchaka6rgU1+GZW8Wqqm+GNUbnz38Gk9y80fdNxnVccf21Jw6O0DcibD/A6h3RB0ZA0tEgmftV7MGn9lQgN5D5tKw23H+x68NN1A55GCRTDwoNt1iDoR2WUIg6pvLUtGFcZIZvruxxqq1lMrmcoXn85c4oZWmHMDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Joyu/drr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Joyu/drr"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47df440fcd5so743348f8f.3
        for <patches@lists.linux.dev>; Fri, 10 Jul 2026 15:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783724012; x=1784328812; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bZMuJmOMRKFkwmQjMCN1ntzaT1XaecLSvQONyrn+oG4=;
        b=Joyu/drrUOtaPwSb7SwNGkVZn5ov/+OmUzONzmkEA3cGowzU+w+I6cgHx7GSFf74p9
         CVQcgi234tRibVo2PAJl7pMCh9/UwaTWOBFi+vOIDCY45m2SvSzVBWbFmKnHSbFDypG1
         JD0ij3vLdCtrIDvxjjIZNe2Y/vGh5QNwyptdwXBQxSeEscdXK2fgW04dZ9eAaAtDUZxm
         C05+EsosDQAwJqnXP//1KyxYjkRoVkfHsv4Weqs0x0JRjlnoshivXYtRaAWl3pb138q6
         OxdPnm0Rwo0hWhVaC8XBMVgDdkZ9EYL9F/zxlc5LwqczrGA8cXR8FNvRV+1viGlPWvNV
         HLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783724012; x=1784328812;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bZMuJmOMRKFkwmQjMCN1ntzaT1XaecLSvQONyrn+oG4=;
        b=IoACl7Cli/NjKVUmjypTiqdJYSFKkRX0tTFdjW2RCBxb6FfJpQmTwZA+ar84gswo0B
         JayxJYJ3tO3uJ45T98dpoWwpj9b3FHixqCwQuuvEIDzAyg419TNI4kX/lkFR3quhaCf5
         /p8mEzn0GzmkaaJcL3otedCKJXBfAm8/ODy20Vz/eLcErRPyBoLZpDvxVg98hIMedcKx
         F6hiumRO+QyKGLmrk47jYrte/UarN+VfRV7GNWx8RvtJmvv8/lEYWTxFETmblq/rTNgL
         kGALqA8L9Djcq4UHZadpVkSucPMRRj78DzXPGiqLUCLQ/eUQe/xVxh9uQdXPjYQJ0Qb7
         2p0A==
X-Gm-Message-State: AOJu0Yw62oi2xMmvRoUxbro3v+4ZYUnZxAjYAPp8p35fcw3DpM6jm9Ui
	kgsAp2Sye6TAcV2cXYDrvZNdA4mVGBEBebzFeXbH9hoKUfE90w+vARHW
X-Gm-Gg: AfdE7clHRHwRiytwWVFQzItyaCsuynlhr22kL2KY5NRXhu6rAhb6+Ifv/+Cw990ofD0
	2EGf5+OzUaG0OnedXKjqVhJr2uASSLZMV6ueWxXyrKyUmDeJ0oeiw+4X2/3Qk/TbxfD8YQaeu0q
	4/E1Rx3ik6Cp/Wio80LXHbuORVMfWhiEaRkY5MI4ctZ4kBRtgxGtET/mWlpLVMzfH1j084JZnq7
	FT9ia1Ujl0NRkm5UzvnH7+TopXLiEqmoSFoJit+JyH9JcjY/zVScJAn9UEZZ2ZYKYVkE5t+ex+E
	C9FHqAZb3GTYOaJDvnliVVnK0lVzA6DUkPw7dj0O7SparX4/4o6/lhTvwLQM24qa78RGxcCap77
	b1Vn/D3f59Hs1zGOIld49mkYD1Tuu614wxjlGrogu2q190mOkviuKgi6r/HG1NL4p4fEEZUPx0+
	Ml+lFnLeez3D0nHr2XH4/IZOgNI5MIYAFs2+UGhGxximMut54vo/V1obvWxrWTdiTclTyFK4+At
	AcCqTTyQ+dj3LA=
X-Received: by 2002:a05:6000:4010:b0:47f:2baf:5e31 with SMTP id ffacd0b85a97d-47f2dca845cmr596773f8f.1.1783724011546;
        Fri, 10 Jul 2026 15:53:31 -0700 (PDT)
Received: from ?IPV6:2001:9e8:f113:9101:fced:7ed3:a061:c995? ([2001:9e8:f113:9101:fced:7ed3:a061:c995])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9b4d850dsm64826572f8f.0.2026.07.10.15.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2026 15:53:31 -0700 (PDT)
Message-ID: <84daa623-6767-437e-915b-933dbebd2e8a@gmail.com>
Date: Sat, 11 Jul 2026 00:53:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Content-Language: en-US
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, Florian Fainelli <f.fainelli@gmail.com>,
 linux-mips@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable@vger.kernel.org
References: <20260702155115.766838875@linuxfoundation.org>
 <34b7e26f-df63-4523-b4d2-5de13c192a8c@gmail.com>
 <20260710163023.agent5-0013@kernel.org>
From: Jonas Jelonek <jelonek.jonas@gmail.com>
In-Reply-To: <20260710163023.agent5-0013@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sasha,

On 10.07.26 23:03, Sasha Levin wrote:
> On Thu, Jul 09, 2026 at 11:45:14AM +0200, Florian Fainelli wrote:
>> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, same build failure
>> as 6.1 for MIPS:
>>
>> arch/mips/kernel/smp.c: In function 'stop_this_cpu':
>> arch/mips/kernel/smp.c:396:2: error: implicit declaration of function
>> 'rcutree_report_cpu_dead'; did you mean 'rcutree_prepare_cpu'?
>> [-Werror=implicit-function-declaration]
>>    rcutree_report_cpu_dead();
>>    ^~~~~~~~~~~~~~~~~~~~~~~
>>    rcutree_prepare_cpu
> The offending backport was dropped before 6.6.144 was released, so the
> build failure itself is gone.
>
> That still leaves 6.6.y and 6.1.y without 9f3f3bdc6d9d ("MIPS: smp:
> report dying CPU to RCU in stop_this_cpu()") while both trees already
> ship 91840be8f710 ("irq_work: Fix use-after-free in irq_work_single()
> on PREEMPT_RT"), which is what exposes the MIPS reboot hang that
> 9f3f3bdc6d9d fixes.
>
> Jonas, could you send backports of 9f3f3bdc6d9d for 6.6.y and 6.1.y
> with that adaptation? I'd rather take the author's version than adapt
> it here.
>

Sure, I adopted it accordingly and sent patches for 6.6.y and 6.1.y.

Best regards,
Jonas
