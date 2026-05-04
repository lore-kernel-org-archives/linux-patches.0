Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6CA30149F
	for <patches@lists.linux.dev>; Mon,  4 May 2026 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929865; cv=none; b=uQj4kxa1vVszLfsGzyKCaVVvbxiZOgx1Pq87sLM7bzv6dBGk0Eh8fYj+bNs0Zr8hRJfI0xONA1lvXLPstlcnzq52l3u/C1oCJ6/eDEG9HomPKJdTR2w/et8NBihNqhY1rDd1PuNaqRQEXStQ49TrZszSzGwL/bzUJoYvLBYM4OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929865; c=relaxed/simple;
	bh=aXLhzVVDDZVTIAysVaQv57AbFUyuiddQ1N6wPA+Lz/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hOAjSXMuJgwUSL9OXYeyc4QMw1DXNylIYlr2x/dKM4UGVS3F7aAKs8VJvt5EsS81XrGQBvQJcHjodqMmB1DcnJYZOpAqan81dCxv/o1iUeI2DthvlsG2sGrk8GM7MVY7ud+F1uoP5BcwwL3QkBa8Y/SeQSwKjwAUODh7c3L9u5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NYAxjznH; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NYAxjznH"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ef2a1cc06dso6180493eec.0
        for <patches@lists.linux.dev>; Mon, 04 May 2026 14:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777929863; x=1778534663; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jQyQ7sqWzfJEVFfcsdMCu5sAldv5fbt7DHbnFvMIyu8=;
        b=NYAxjznHKJC69RfA4LQQLVnSryNbhSWZfX/1SFGLO/nZoafO6l1yP7uhXCthy7D7Cv
         UKeYinRTYF4YpspWlMNzD8mjd7yDIfG7QJeqSXctr/yH2qtak88dLN7sI1p1yDvaDsSh
         rnbhrV5EcbLVVgDARaOwkPUU2jhbDVM4XVZUP9kBh8LJA3LFmc9+kHOhfdGrvCgJMa/T
         NfyV0ygMRzYCuqrKEHsAN5GV9zuTeGUYIjElt0RvZfZCw7hre8ALZ08Scm+LX/sNaG6y
         gRNv+kQw4lwmQNvXLf94hYIxCKV5uio1RRg4bF03wnIOy9hl+8MtB/YDRX3CDxgdSHur
         feXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929863; x=1778534663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQyQ7sqWzfJEVFfcsdMCu5sAldv5fbt7DHbnFvMIyu8=;
        b=C1Q+mXRwWfvgm9RpBYzHsLRgLLT6SlUpf8sOd/UrrCDYYBfB0kCeqeFlSF5uXkNte/
         yaS614Ch2JQgM7hqqo18du+42v2ITm47RIMP9dr7km9DSZhN3j64rDJSXGlxGgJY8cAk
         qmIeQffudNPzIXhWPRGS5/jC90417xuq6Kv50jkcLXw2FUas+RpykVWP3De0AESKZXF3
         G0UPZIacbjukADFtnX/DwcbIT+Rqtmw9qnZnW+Ia/q1iNGlJkfUT/uFUg7m3rTGEt5U8
         OI0eiRgqSdFyd1RkUz3ihvoChVJGNBKxaVA7sEsIq9HTDdUrH5P/uIAJQ1Dy1O7RZLo8
         YnNQ==
X-Gm-Message-State: AOJu0Yy5PiLnP7wi7fsJgklQ2PCn0KH0+8mAKVVrp26Eh2LC0CpnMgzT
	/etsRKtN2hClrGtjXMUP4wpH5jZlrakvyIidQAkntowIPAfwMqZi42sB
X-Gm-Gg: AeBDiesikMXVujYtqRncBR3WNww4zZM/JZeqGsjRgfJH+a8hlf0zN00pTmgfVuU3N5b
	BlbyevHdDnolx1Ntq8UG3clhXIQfZnE4okBHPBX+DuyUERJpcUFVGtLJvRHucXT7oQWdy1a1lMl
	AzK7BYBHvwrfPfp/jJ0VXsAAVoFEdVbWuNtZkdyEEwyftiyvZcwJRl9NsHs/EG39jXnhvHZAqDG
	0Dn0JVdj3wKXX/JtSORyuqnyo00LwEYn1Hlbq/U19Qi8doaqK+ZNIYlXX1y9zvskIVBoDlyQAby
	CAcLnQbVpJYZ0H6TMaFJiSR2Ro+Axt94YgnhLw7rEiG0oi7uALtXFX4Xc094UlaAXiaJ/7LQho6
	keKQXt36nGtZJ848Qu5R78aFWhb5w3VbMCLWw7iuLnclB9zrdeoue9AR1aY0p5vw7YoCYRvOdcT
	p+FJJT/1vCklK7frID4X2D52j1qNKTYFy++9iaGJAmqak1oLhIkwnt4mPkzmkg
X-Received: by 2002:a05:7300:fb96:b0:2dd:6937:79d1 with SMTP id 5a478bee46e88-2efb89a0612mr6059363eec.15.1777929862781;
        Mon, 04 May 2026 14:24:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee3889d634sm21012510eec.3.2026.05.04.14.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 14:24:22 -0700 (PDT)
Message-ID: <fdb726b4-41ff-42f7-87cf-00f308fa27fb@gmail.com>
Date: Mon, 4 May 2026 14:24:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260504135142.814938198@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 06:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
