Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEB638F255
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 08:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373641; cv=none; b=R4o6g6VTR201tVl4AwKa1CZrnChQ8JhJTh6rzd9Wkn5cs3ipN0bDo1/K7+S8r3rfWLzKfvSHhqa2WhnzYuuebO8j38G5nakQCs+3MTClljL3E/hdmipO6ZG+OOVY8DdW70HBvSXzosdBftQbPxZKjEj9V+nQ8X6QijXoKutfyfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373641; c=relaxed/simple;
	bh=1qAturnWzQariAYGkFzim5QAVMrBYTGsi09OCtKLOwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fmWipe7tKgkCbcQxTBm8uWoON5qLyLUHjCkz/V5TvKysXugqn8D+sKhqH/vocFv56Vd2rsNtBsIIYJGk6qyg2tZDCsjG9pWuz/vMcgWlGBkCqRhiF9TBkbidVyLdvaQb3cc32xUwLbNppHNUZ5b4Hw7iOKTqeH/+7X6J5n0UOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQw9/3BT; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQw9/3BT"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b7be8dbabfso1240111e87.2
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 01:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789373638; x=1789978438; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=euFeN8L1qX1vuAtmRRhYoG7+Fn8wfxabvK2hQ7ks/1Q=;
        b=LQw9/3BTw5tns299fTHHPd6MWrNftV8qRqakFZE0CPXL7z3W3W4JLzdoCt/ui9LoUW
         4kmC9wbEGitv1x+GR2KAIzuFPc8NKqvobUOUY7lS7buHXPurbz+QWJGpb4VZOxoNqFl4
         vZ2Qkq+h4h3PvMbQneVrzpYbxMF4FeF3zRjstsEkszFB86zi0PMTL+fuzIgHIwcxtZOB
         3R6+2hWoBROla9S0ot5eoX57ATfF8BHa/y6E6R+F6dcgpuz4NZ4+K8zz1yuHxVNEus/g
         aSPDdv1MIbMN1akgMrb2B4yZjN15u9IvfJT7yoV4VgpjDv+I0ToXGwz4CvPQXu/xannk
         Wx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789373638; x=1789978438;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=euFeN8L1qX1vuAtmRRhYoG7+Fn8wfxabvK2hQ7ks/1Q=;
        b=VgFCONpAjttM5HwA9N0jX2Atb3PBnpvfJJFr7SI9E2s3uG0dGt/4J+kZ2LmZICkDZQ
         s6cOMBnVCdHkRx0SDEJA75jvCqQGg5Dd6OwVAQj0taMu9GEgOHAm2+qB3k4cj0i1Jn51
         EyeDHxeFO3mJDAdCmAvYh6z6WupKQNrM+XoAlILxcz+/UH2zbOdODCMKiZRmwbk0M6Wy
         yyyPshCVua9+468wfu84KxFG8YssgpWsl/zOq5rAmIK8sTIoHslqNuHqvdZVKk9ROCtj
         8mgaZcwvHN/kMfSb1qf9m3h4b1pGFoEaPdEhJkwt5D4pLqemxNEveqzoQKviYx7H7xqY
         AMzg==
X-Gm-Message-State: AFuF++lJXWtRAek6r5acAdrtcsyLT2+P0IwkEMKDxfgzIDb2lHmKvLvs
	+75L1bsfaP066TfA1hTToFCLUxQI1nqI14N3gF9oMFmjdHHYiaEhzQb7
X-Gm-Gg: AYBFou2Y+YCNNDfhz1wRPJp2ONOU5m8TQPB6GhVKUwzNltf/bwsbuqyjCfYwsMWCHLi
	ZSWouRrlYzHq15Jg4vEIe7tUU+OqKWrTTKfaMfjhXaA+flRhudhPWRD4Emjz1w4EJbeIN9W7hX6
	XzHh/YIQd1wqdZAf/x52Q2Q3AZ576YqNgfYG9JKMh7QkXgkqSj8TVCVvYZolaJZIMdP8gvF2o7i
	zywQpJLXOy6nOq5A5fMk5xES9OE5JWWwb7GS4NUD8BKUgtNiJl0hyYTiHFYEc40Rf8hvcQtjf3o
	Qz2PSeKhdBu8BzoKWjVVRiW+Y/ePudsbr8M0BWk5vtvTMAkB19bWi6jJmpZ0hOoSJ5DDE2ksMMw
	+/lJ1VsTdpLS7+9eyejQDc80e7aCFw+t6O7U2rXNpnCxBUCAN2fNnxDLZxzRtIohDsaBoST7Om2
	qhPjbDlUAXa7gyWcaxiLhWh2etbTKjHPhPTXeMrCJ5XEeEiiFZ8xP3LEarFgH+gQ17CNOBGOMdD
	PMUxVDZRx1kvuF2JJCfs+/bXyppA8QXjFdLj31h22gRZAigb1FUrOw=
X-Received: by 2002:a05:6512:6181:b0:5b6:184c:7da8 with SMTP id 2adb3069b0e04-5b8ae6b8b5bmr368579e87.49.1789373637454;
        Mon, 14 Sep 2026 01:13:57 -0700 (PDT)
Received: from ?IPV6:2a10:a5c0:800d:dd00:8fdf:935a:2c85:d703? ([2a10:a5c0:800d:dd00:8fdf:935a:2c85:d703])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8a03a8778sm2275500e87.2.2026.09.14.01.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 01:13:56 -0700 (PDT)
Message-ID: <d601964b-e437-4990-bbdd-0337bba49102@gmail.com>
Date: Mon, 14 Sep 2026 11:13:54 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Herve Codina <herve.codina@bootlin.com>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Kalle Niemi <kaleposti@gmail.com>
References: <20260722142834.868902312@linuxfoundation.org>
Content-Language: en-US, en-AU, en-GB, en-BW
From: Matti Vaittinen <mazziesaccount@gmail.com>
In-Reply-To: <20260722142834.868902312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/07/2026 17:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.

Oh, time flies. :) Well, statement understood...

... Still, even though I know I am late - I am seeing our tests failing 
for stable 6.12.x. Other stables as well as mainline releases and 
linux-next are passing.

The actual failure seems identical to one discussed here:
https://lore.kernel.org/all/072dde7c-a53c-4525-83ac-57ea38edc0b5@gmail.com/

I believe above was fixed by Herve.

Bisecting stable points the:

> Saravana Kannan <saravanak@google.com>
>      Revert "treewide: Fix probing of devices in DT overlays"
which matches the issue in discussion.

Maybe the 6.12 stable is missing Herve's latest fix(es)?

As explained in original report, the issue is seen with our out-of-tree 
device-tree overlay stuff. I have no idea if there is any in-tree stuff 
impacted but I guess the overlay stuff Geert has in Renesas tree might 
also be impacted - if it was based on 6.12.

I believe there is an "existing easy fix", in a form of a patch which is 
already applied to other stables. Unfortunately I lost track of the 
relevant fixes during the discussion so I can't point the relevant one.

Herve, do you happen to know what might be missing?

I suppose this would be worth fixing because 6.12 is expected to be 
alive for a while.


Ps. I am not sure if this mail thread is the right place to report 
issues _after_ the stable is out? I'd appreciate a pointer if there is a 
better place (for the future reports).

Yours,
	-- Matti

-- 
Matti Vaittinen
Linux kernel developer at ROHM Semiconductors
Oulu Finland

~~ When things go utterly wrong vim users can always type :help! ~~
