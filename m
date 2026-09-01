Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B1D283FF5
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 00:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221752; cv=none; b=VlBaCXUfbddksF1k5pobNW1Hgl2qZkytYDVay5bpw2khtA2psv9NV1DMMamEdWzG+KhUlPP4+trlJkW/Q/u7n7sDcQ9J/9rgnql7q36ROzK5cAFgJRQp38gzqmcDI3aA5FAZhGT+3nxBSqexMKpTx7sSL8fsJedvZ7uLvrrsEGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221752; c=relaxed/simple;
	bh=yCGJm1jGkR5RuGr2i5gkhz3GBdsvJF4mNpsE9U0bBo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WXGi0lLm9V/puKG0uNjH/vwbbRWftaYy2Yh+718askI4yrQeGkGDVbIVAmrUN+GBmt6gwKqUqtrlne4hVmh+idOttfnqJrEWO7AtWVnlICkacuaui6Ah5S4fraIYD3Pw3fNxFioBUuXcBAi0Ov1vVlzYQO7x8oXT+sPK+g2Xec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l64txUJo; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l64txUJo"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ceab75934dso48586555ad.2
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788221749; x=1788826549; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VfqEXN2Uyf15PT99s9ZwevHcWniSGZO3B8ZSbTXjUBU=;
        b=l64txUJokCwBY7HPZKsWTnXdupPjGwSVDnzH6xKEq10Bdns4D4q5/4Jy+mltoEazj1
         55+8b2UgiaeSOtUrtkzqN6QwiwtXRDUO4nO2bNAfoOgwoKxF9TwQ/HwbrNTqSk4RCmFY
         pRmL5AUl0rabffqzNCpC0ybyCitqjnb6v/MtbQr2LRLWJeDh4tiW03axxLLFcSMo1A4M
         wko7ZXzdZ6GLJyZcfXnn7vDMnb/NF0qZE6Ls0bM8LObpj3pL91aWOdex4aPGvheZiWXQ
         a1GzU4ZvBI85AXfEl4Pj6XyhI36eYpx6nO2UYAJNG6VbtHy/6xHx7iF3TOYhSB85+MLG
         twsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788221749; x=1788826549;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VfqEXN2Uyf15PT99s9ZwevHcWniSGZO3B8ZSbTXjUBU=;
        b=nDJAlBxdjZGwYkeS00ToX11oYibEfDWosmgEr3izJYZYQmmxI+Lvjt4DY5Kt2e1KCM
         envlraQw6eCz8Y2LL1TGXSuP1lrvSpYxJdtRpCQPs1xp/YTtLjcELmNf2QA5H5a+v4kD
         hdNGVD8fZkscwurbYsOj1wflWI9qEHuMXdO7QPz8Yx2TzAUqxjTG7wmo64lH3uAqkVGC
         YGw7ZXBydEF7sC2n0cS+KAEGTr0mek5WfzNhWyRA06m1/c9mmHREGWWY3gsUgme45M3b
         zVtoJEByfEiWbdYz7WB6NSL6X2XrjwL3e1drvbkUTl2oa/yocl+LTA3HgrENap8mEliE
         fjlg==
X-Gm-Message-State: AFuF++nD3AiboesCLhhmyZTIo7W3lBj5a6gKXI08nTsSPaDQdFZ6Iq9j
	ZPRsrc/DltTnvrKTyeJF+bNwixQfSS7PwT2wRPdnhmzXMaepcViNV0qj
X-Gm-Gg: AYBFou0k+YV5MkUZh4083uS8l6zYUWfDrSii127tcL9wDMt/kNOzn6jr7SLsqSFHyqK
	fEifFVrGEyJ5tKWyF3mZnFJ56knNEQKSTuBsohpnfe8SoOoyZc4o7+J7GmVloqPRDyMgM+s9zgr
	7Uz9NTu9CfvWqfhgKMrfG5PXf2XKzzFs6pPRyNoKvp60botXtrkYEpaON9CXetzaBlBXnlGSmY8
	g8XIUOwIfCmocIhxW9zZ982HmpWcXOdnAYTeHQpE9agIfkWZ6i0tzm/q9VwMVuZrfumDjWJl4v2
	Iw8RnaCXKd64bokqxMIofzonuoGSZSoDR3srXyEqJ46ltTYseoz/B5MagyEcoXO9MktN9tAQKDX
	6Wtp/UuEnMjpuJ+kHzvZ+7D8wADahG/YGbSb3Oxnhf/2GHl3HmNk3oxwF8mtUNCKWOI7YjkdaOv
	zWIpRBXMkqPtHw6k6EW4hrEt7Jo7I55EbC4zHTqCFHDZty3pVBAr42XJlyJGcMbEOXhdsjtH+/5
	z2hiJ6nII/mgG+r7sEU91SKWTY/9w==
X-Received: by 2002:a17:90b:530c:b0:381:1c96:829b with SMTP id 98e67ed59e1d1-396d0d4c43amr46596844a91.3.1788221749583;
        Mon, 31 Aug 2026 17:15:49 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d3fdf6sm32745466c88.6.2026.08.31.17.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 17:15:48 -0700 (PDT)
Message-ID: <478c7bc6-bdd7-45c1-ae8f-cc7e672912de@gmail.com>
Date: Mon, 31 Aug 2026 17:15:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133359.207714926@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.49 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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

