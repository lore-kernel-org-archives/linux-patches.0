Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE3B49219D
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406808; cv=none; b=FtMDyGYfudSyP9VkAkbUnD5FIYhbh9bLYqlLKBHfVOqhtG6FVK9X1pfbHfz2iJ0gkm2O8OGhyOWLBh1n+xFJM4JEfLT++OwTuXquZ0TzEfGnW/oDpSrfYKNumWJ26G3FUXtG/XXklcGfnHrYet+DO/226hjLl64M7bDR4q2GxBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406808; c=relaxed/simple;
	bh=pU8YoxfaiYcGyjJ2bzXSTvUUJeEHYPgFb5yIn8TMU+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gghq2qOl1o1u6EjmpxJwLCVxV96ICXnyqHhI//PY5lpF3gMZIe1BHKf+u5C5tsheM/+bdSoxhVQxh+sJA9isKtLNp/ipNO/4LwY5qmOlwg9EHGcBjz24CxbOzPXNt4AwltBD84wSOpcfhFZCqBQpjFkHhYh+dmM8yZzc3JPETIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpMtjeRj; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpMtjeRj"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469b2e1d5so2530004b3a.1
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 10:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789406806; x=1790011606; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=glDU7GH43DqZJrOds8Mk6qv3pqgdcJGDTfDGiTxJPj8=;
        b=mpMtjeRjaaO+s5ZMDfXNSI37eSpX3GkljC2py68789EMx2JHKLU4S9sUpKDWbG90T2
         DYiFtSgDItNobMCO9c22wjsW8b/UjPC8N34FUnfAY0DjLQtV/ymh7n3/aH2RMgvEtFDf
         yFZlfKazA13zIsUbwYMxEmoJGlgyS0kpuBMlT/k46Am6VCWRRp/5wYLU0zFGlCKwarw2
         CO+xttk9Ysmf6vtrxwfCQ5WufM5WpU5C5iNCcw+SJMLcEBYZgRB+NJmj+sx8hmm/0pnP
         dhckWJ5BtRMuwGzlXxg4Ca2MR2+DIhgXPR8bSd0arHdbGqe/iLYLibbLvm/7yImsUZu/
         YsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789406806; x=1790011606;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=glDU7GH43DqZJrOds8Mk6qv3pqgdcJGDTfDGiTxJPj8=;
        b=LswzeczriTyRpQcu/etfpqDIIgBrP5B6njG0os/a/I6dJ9mh0n0u5AVMIyRIspJ3I4
         hEUzUNsM16kd85vLxF6SrMegyLGpNvFgPTqyoBJAiu24KkGFHFfmz7tIzcvYSXX7Vng3
         5A3lmRwKL51y6y4UMKaiKzYsC577I8DPqg1xjp3bx9L4scG1XZBAc3beHFXp61VFKp+T
         DciKYPRrRWSyw7aUvXWmqfuMMOpxQyEsU2iv/vTm/zwszYZxC/72oyEhdJRjwN2h5h8I
         9X+tHVQkrL5l+ft5FYwRKCNfMZEVAgJmVYwtHnF3MJ1HSmT4dYJdSD+z0Xxxzt6xG3U1
         51gg==
X-Gm-Message-State: AFuF++l+3+s9eS64B9iN0dgvgK8ckVbCwArECXLqS9+h3FAykgt5FlOe
	oC934WbqDi3T+oMxe22TzoDFzWmj12BrP5g0TwlefEFEaEkOlMADYugV
X-Gm-Gg: AYBFou1sATQEHd5HMo7PNioOzrf2UboYVx3nXsRdjAxByqmpW4IT8OFa6E4elOCT6jC
	p8VshMxCAecAxN2WmCCHfCWt8jhoa6CPNUGgMxiyRxxVJ+tOYAtSts9tTjqL51IF1CPhTL4gByo
	ON73+EGCinBUIAubyH60q20XSGFUl4LnM+YQmyKah34UUSLiYm6x0+2NY49JrEjqQysFSTKwEyO
	c0s0IDMu9dHRG4tFoxtZywoNOXXopK3CCjwShsE9umi9A+jj2reVslJc8+1BFRnfDHAI/6WQKDa
	sgJokqyl3NWxYj8P5wv9D0EwkLHA4DrA7+z5X/Hck5GQ0AyLFzzoY6IWjOjl/KAhTTw7hdbVj+d
	EtobeehbOPh1LbIf43Pm1yM9vbwA7TnHV+JVWhZkFSfSTqrVhOhsqeDMNpnqIkGq3u7NRj+nqBk
	GBKVQLZiqo30qWPkTX1uDgiwU4iu6RPYDO/vVsfTQdWJ7d9b7qcQzcEupgJfftSHvUd7D8V3oyv
	fdFQFwj3EUHrG3tg3hWPT+MpQ==
X-Received: by 2002:a05:6a21:918c:b0:3cd:61d5:f342 with SMTP id adf61e73a8af0-3db404eff3emr8925150637.9.1789406806046;
        Mon, 14 Sep 2026 10:26:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6529a71sm5483635a12.5.2026.09.14.10.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 10:26:45 -0700 (PDT)
Message-ID: <f37a16b7-b9e3-45f4-8ecf-409a4eeee674@gmail.com>
Date: Mon, 14 Sep 2026 10:26:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/935] 5.15.221-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065526.833703348@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 23:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.221 release.
> There are 935 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.221-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
