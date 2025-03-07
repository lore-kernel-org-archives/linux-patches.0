Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E5656B81
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 03:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741319466; cv=none; b=BmN3jn8h9Sc2jJWtJWZbv79Ja1rEOJJrhnYATjgItSg+ZiS9w6Bt8VEO+XysthUUXH2iYMqoC+OYgeDc1HP+IMxTrtXRZIYyRw9Nmeso6b4TaCVBlWd3QLptPHXeFNg38uSmgy/xeMzxMMG+LD3M3pZa/F8Erjx97jdTjrnDNhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741319466; c=relaxed/simple;
	bh=6A6wZPfLa/IRgcrPXRsfSxNs3jDNMzsxLVMMdvEPVwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N1F8TQJzdoHAhKBa8VC177ma1340WVxL4Q6OvRDYmJ78MwyeY2COxR1ls4vJX3cJsnEayFhhpgHFvh2QboSsisJ94qwRh7rMGZD/PWYRagCPVrKXGEnjLFtxexh34cqd3p2mR3ZOf1GFire6gE+E1ecUEZKdNb3TeAN+IPH7wX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eJ/lCSWN; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eJ/lCSWN"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43bd732fd27so11989235e9.0
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 19:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741319462; x=1741924262; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rzppPm1nBJImvG0nTyvZg/NFELuZGzODWqCodJYs074=;
        b=eJ/lCSWNhC5d4Lm9XiBeqaEniouV6z1gpua3wdZnhmFRga93m2nsgmdWb9i8/W88iY
         IZBtcn8rLnT2YbiCfgwdBbcBMNX2mQVz/fNswvq/LWDxYrc9UawamJWqLKlsZnmgsfMe
         pX5YJm7HiM2w9Mua1Qbf5hvIsVS6yjCzJrAvNV5YCSSoSpuZ90Sg6H694THPxDiKXQSN
         GcTzkU183/ZMbNncLqZGk6CPjqrT3FBKOXETjOmheA7MHBY7c4ryZEyWbqneFMOL3w0B
         O6HcJOVUPkR1r+OEHLCzwHpFe5e8NZQsnM5H0baWWMNvBjEJMPer4V3iqFYtsq1yp3xc
         Fnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741319462; x=1741924262;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rzppPm1nBJImvG0nTyvZg/NFELuZGzODWqCodJYs074=;
        b=alScHcOYOqiGP+nipXcFE/uc7ZAc9eHU+uQsINOW9XJbmTwt9v6rt2bUsUOy36ayJI
         NWTC5fD3QpjY2qkYCVUslJKm01Yu/AM5r757cxyndZieJEOcn2WzMHTVHEN2VNeV4K+g
         F9eIejKsVxrb+BYQrdoY26FIf2TqG+pXLtAwafzWZuw+Ht+2kR6o+dkjFmpp4dO5P2Kx
         99YP58//oBaouH4I+OCD/RqU3Pm6gahXOVqgvLEdlGrjy2qzwuj49Noc4qVXm+OAzkLx
         2lj1B8wrRbjZonhRasHyzjPya0clLPkg7vUhDaGo79Sx7pjXgSH4ywo5H277i4iFR89m
         VNuw==
X-Gm-Message-State: AOJu0YwNNVZmyzTTGYZZ2O9EYirMyBFyeXGxVy+CpyFf5P3uocY9TWuK
	mhQsAXGEsWEN5k0Hkkb7kOIXA6oUxUtyRKExo8AfmXQBYehADTw=
X-Gm-Gg: ASbGnctzHOFfqMNq7Z+VEODkGmczFbfZEvP2UX+6TY6cwbNBVsAiQQW6Ev974rFZpq3
	GSKUMm6SFe4sgr7opEhAKlWtmXM7cZlLSyXv/hioWPoRcMQ2TTGiEzHUQyLxTsNSmmMZVP901zb
	4ut6IU/fu1CCsvzO6NZRN3geqKvxjPkepd8e4Zu40pn7kEpVg2Z6IPe0Z4X6eaqN0qXO41rP8YD
	tLLsO3B+91nrLlLMpvrqQh0WPnWePBkv1ufKKh8575TiD3h32xrKaWGRCmwwHd1tEgWeRLhVbaH
	AxoPM2MejjPgQNEsqygAK5Xu+pd6lcs+r0bdkJA2Z7RS83JZEYWRw507J+i4V5rTIzhFwJAgHIo
	hUcHZ2VROSxtDnJ+h9RtM
X-Google-Smtp-Source: AGHT+IGTSc/ZTKJYPLzz096emF7HgPU2CoDwC5SL9Rk9Z5VgReE/fWMvUgx99d/bXdhOzbX/rGdDhQ==
X-Received: by 2002:a05:600c:1d10:b0:43b:da56:4d57 with SMTP id 5b1f17b1804b1-43c601d9414mr14276025e9.10.1741319461842;
        Thu, 06 Mar 2025 19:51:01 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4f54.dip0.t-ipconnect.de. [91.43.79.84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bcbcc53d3sm70512715e9.0.2025.03.06.19.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 19:51:01 -0800 (PST)
Message-ID: <93d5bd26-2896-46c9-9c70-816581a84d57@googlemail.com>
Date: Fri, 7 Mar 2025 04:51:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151416.469067667@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.03.2025 um 16:21 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
