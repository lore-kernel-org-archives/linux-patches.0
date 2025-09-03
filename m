Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65F52FF673
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 11:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756900287; cv=none; b=LgLPs9zQmCk4BguFzc1N1hr5gc+00uET91BQrASOTguhE5LCh1IhmeNfUMKaEtHbauI9KPCge2br5Gj/xW0Mr+yAr8kidBnZyELRRresxgl+Cu+CgXLe21iFSoEbvlGlHwWOq6UiA42yG1pKDEXQ0tX65aq7V51moGHcwDOVzt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756900287; c=relaxed/simple;
	bh=nLBdBuaIf1/aVBs0fJxzcj9UY0fYGaAL/FzD81BuuFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPh0lzM5rNsTy2dIrPts9w+DW3L1KLioCHbtiyH6cj299PQVMCS5F9qwmK0N4+L4IjuYkLVewcmwa4yzRgYuHCbKbKnbQjE9UDlWO+8FThsp9HzDl3RCvCw2P7Ny49JCln5ufocOYuzjSJX9Vn4fB47ZRc87SD17nzejnctSI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VVqxo/aH; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VVqxo/aH"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b8b02dd14so21251585e9.1
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 04:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756900284; x=1757505084; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+poAW3AComNrsNKMjhX2QMWKG3Ybru0jXQ935AA12eE=;
        b=VVqxo/aHBM+D0tnXfadnF2qy2LQi8MsrhExt5BXLenqbzW7u+k8myPj2TnpN/xJOHg
         LXLIOIu+f1EYNE7IJS0nzXOTnUc2ydFCiZaGi+DWq6owJwl+f6Mzobp3CnrJvkW8XfaY
         hO7q/wmq8JxGaxzaM26X035YdLwqE7PVjhRb06OraAWhgy0m4Tb3rM/aJuujriQlTdJ2
         2nIMLUwRQxFRxqvqMU/oGMsEAxAGG1T/eS9GHYOlpqPtrYVO1JUuvY1LJzyrPVk/PRlk
         oQpAySrDSJ6lkklaqh2KU+RQvwI9zCcHQ8nDrVeBFkujyz1cD5mLCJ0IRgWZ1vD2Jgi+
         LmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756900284; x=1757505084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+poAW3AComNrsNKMjhX2QMWKG3Ybru0jXQ935AA12eE=;
        b=fZurZ+IpW/K7cfTGzT3u3Zy5UpJNTrs/OEWztEEtKq8BlsXQrnmJ2Tkpl9yKehGz+q
         RS757E/9gEOhyf3PfVwS1gtJ8Vl3womme6LNZlwLr1gMo4chBxF0vMwoedB3K4+Yv6K/
         7rjVVtzbjIP1aT+K/FHfO9D18azcNoYdzKAxai2tlOAwTGv2tXNVI79KcXVUfuvhtZux
         UX/JzrXlTG6fMlRQObPMulq21hyWIMPdexWA2tc6LkG7b58G7T+gwDLhT8BFYXeq8/t5
         Vwp3yu4RrUHROL4tmE+QzPdGPmg5+Xe8kBwE0rHrWlEIIBpTF6s8OaJCeR9ScpDqX8fU
         28+g==
X-Gm-Message-State: AOJu0YyrudFn4lJQl7xYo6hG2f5NKwhJJGxXUqv3Ai0yRoQOLcOogs9m
	pi+m3UDl1soXGUowrsc74OwetqXGYxSppzV4QM4mKHRL3SeCWPpmgxTfEzXzaYg=
X-Gm-Gg: ASbGnctAvjQQ6LVu0VQwOCK/3pbj3kPAv2zfWSPXJgU+gSTFx6xVy+7nqP7I3wLaIRW
	HnfMteg1lRuoC4JYJWECani3kj2KCkP0dZgoA4bQ3ioP6/z46/zCLNfLutvPR2UDGowtqwthmgD
	MdouZzDH6TAYDes+QQAXbQdwcdo2A1WGqYssW8jThlzW4FYDstc7UGMjZEP1oWSekcTMcv/mqzi
	CU+uczd82I+rEdxL7NlhmB7lVdNIQWQXAqMqTYfDwVWt9yLwXVsO5zBRIT9Hz+kQtl5hi2alWGZ
	5kIaUIn2QhzlZ6sIzZ930kh6yA/YBH7NkefmB//Is7nP2NgtJy14OQFGQLkEt3GD9ovmNlI1v7/
	kDqwH964pTCBkY9GPHCVs9bdbZvPdbQZgav2UmGjlzvIgQFrktRJUjcQS4a12k0HeJxOw2pcREg
	==
X-Google-Smtp-Source: AGHT+IH8KQaV6Ll+X0GX7vVi1QC4bMGUrCiEpULUwaoVTVKkkRFfOk03P6Y5OSqOIWzXBzBujnsLCg==
X-Received: by 2002:a05:600c:1ca9:b0:45b:8c3f:7d5a with SMTP id 5b1f17b1804b1-45b8c3f7dc6mr90956135e9.4.1756900283871;
        Wed, 03 Sep 2025 04:51:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4f3e.dip0.t-ipconnect.de. [91.43.79.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45cb5693921sm30003685e9.0.2025.09.03.04.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 04:51:23 -0700 (PDT)
Message-ID: <170ff207-cba5-44ce-9d93-75f7b711bba6@googlemail.com>
Date: Wed, 3 Sep 2025 13:51:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/75] 6.6.104-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250902131935.107897242@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.09.2025 um 15:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.104 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
