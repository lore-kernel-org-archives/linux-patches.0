Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D524503B
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 00:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782432297; cv=none; b=nvwceSOkkNXOrMdfgIw5fz7XlVjnLHexdQju/PDKHWQPj5o3sZiDmOYTnCwaoDxUOJXHGC+tU1AJMpBadnAN7LEvRBgSHMEpYHu6h5zm2RzbKJzxonuI1Rr6GnZbdvGHPkpXwyte3LyacDbuQOq6Jchuh5jXHHWh9h29/l9pesY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782432297; c=relaxed/simple;
	bh=6npILbQz1DAujwGLQS/wVPTVMOw2YgD223tQgQ/sffo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H0Ug7YfgZl/A4mkk5WuCE728lJRt2Fc3tLYbjsh+dlMDPX84PsXj2dz700ETCmFigD7gzI3DgiISeaiH0f+skygo5bnSlkg5/pbsuitb6FKn2tSsgm6A3aM12i3uyoJfbfCpJqW+YxX8/FPfhyNGeVRm0uBczfDLXSuDtdCh3t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7AEPyer; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7AEPyer"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-69de16f5e80so202914eaf.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 17:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1782432294; x=1783037094; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FWC2jBknzrOAkBFz+eAheUaf25DyynwIce2dfcZykbA=;
        b=f7AEPyerLxveI0SGfEVJWh+kWo9zZx0rnB3ZXYdwn5VDw0nma+Lf0U/djsfxTt/OrN
         QSVhssT2NCbL3Qf9Tt+q69HXMoV99mSM7KWpAe/9HRNejxhT9EalCSbl/9HrfbRQpgOn
         FE/q5vtegazj/P6Uag1o7/RpJi/vSP4O89g98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782432294; x=1783037094;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FWC2jBknzrOAkBFz+eAheUaf25DyynwIce2dfcZykbA=;
        b=itbaWrOYFXWMNgg9lSSgM+UWy91SSW+T6q5yqSTu4CosMcyyNa6B6/uVS4Pima+GR6
         5txXrys8R121XrHEewKAoxw8218wc2T2Ngz/Zqaz78W7QZrMY6WJDldfLOdPMnPqb9m/
         6/qZNlGb8wu5l3+xkdxrRNZunxJJnW4eD48bQs3tq39clgCbb+Sj1YseGMXiYKaol5R4
         NYNSpPEdvKr5D5GFE20e6mTFXog77MqJyoYm1rjOoM1S+VoRR/0j0Lz5iHRJlRvf9mEL
         LKpK5nyC++iSu3JpUwW+6c9eViOjYJGBfHx3MyoDGBDzJ7CmnZvlui7rh+hNVxFQroBe
         sUqQ==
X-Gm-Message-State: AOJu0YzNCE9FQJ9/rRDtPFsc1v2pMFFZ5XqvzclVfXGoMOuzHQgPpxsK
	ZbWuIKJStzkD8AeTGQNVXDSJ6jKiXhcgUHbb1Ral0ddsq5CYgtwAQVsS+438brSrF2afhzIT9Lp
	1V5bYOB8=
X-Gm-Gg: AfdE7cnk6y1DfoiBeQSk4vk15iHibhmNN5+d+E0GE+WgTtXe7pk/3Hw1MVVl98+zsRk
	OaWWzoC1bqyEK9HNn0mRbP/YVT3oGZ9iPfh94D8unA73CPCjQjbIw5nj1sSIsyFMgK+TcPVnvdx
	FbF8zTa78fXOE69eQdg+FLyRMew42Ovukp3NWYIb2FJmEx+8jqMYRY+MQGnMrQBA01tS5wicVVy
	yLpeEVEIMJ7IvRkJK4vHk8/B0syc1Blpu2qh+LfQfPnG70o4of4o5v5/EHzAffczhjS2DUgG/To
	VxTh9Bq/VohUU2FfP004il1IkylApVQI7FvtfKShpZsxsa1Pomtss8zZ6/3i5be6PJLjzOHdh+M
	SvbiJu6v6EfQoKri/w6YSiuuqzytmH2BQjz05RNnCHfxKR5UgCDTuxuW8V7zhB8VAkNMDw3fh7M
	huYufMrGyBcJSP/wPTM7Pp
X-Received: by 2002:a05:6820:2902:b0:6a0:e2f5:3b04 with SMTP id 006d021491bc7-6a13519c66cmr4165794eaf.20.1782432294200;
        Thu, 25 Jun 2026 17:04:54 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a1414aba15sm398446eaf.11.2026.06.25.17.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 17:04:53 -0700 (PDT)
Message-ID: <ef6cff6e-cbd0-476d-892e-a80c3ecc1f98@linuxfoundation.org>
Date: Thu, 25 Jun 2026 18:04:52 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/26 07:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.37 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
