Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B71390991
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 02:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772503424; cv=none; b=ZmK3Mi/HjHkaynqM2ouh/FasuVRn85wDCPDmSt61LdDA3UbmBenvu8uATNesn5x0s84SQIqeVNm8XtUpQSLbxh7ZE8Q2NzHMkQJfgEhsK2ZeychOjklqNBP2Hx6o2I99KT7X3nezaVR6PdShBYS+5tcLYI64ZxGgAgn6Hod3ta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772503424; c=relaxed/simple;
	bh=T3U0Pwj5QKpXzxmSRwkH+YRim8csie0y/decyOjdWik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jUadigBnCKXis7mTDVjyRtjdUVMiZ2yCcze7Zm6V7Yk07JT41o4xhbmyrFvUsfDkMAdKXvPdPDezKvSCka7izTbI8F14873X1hWEPrVJVLnA6rilWuQBt+p1j3VqMjbbNGOMi6HvyFCsfSKTRrOY9yZW5Jvps025ckuJwlPLAmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Zm2sYYJZ; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Zm2sYYJZ"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48371bb515eso77987885e9.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 18:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772503421; x=1773108221; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=acyJ4a+uK5qh5x2co2XOASuajgxYlRjQTIZAPblgzpo=;
        b=Zm2sYYJZXYT3ubFHHbe4MW5otBmezcY7Sv8PdS60Uk3rtwvyFaag6Xv3RsC9yLsa3W
         PIs6pvJoOACooYX9TO1Ayw/IH2Hmdp9zPmTzrbKk8jdGvJZ4D3N0aPor66MqcmYmXWYs
         Flmw0uqkSunTmAs6BHRVF+fwtSbkXgqYsphg6xvm9fSDCu8zowILDAtKz+ArEi4DmLUb
         vIyo0gnR4Hf7iu2jQIsL8fB344ytrt7wVLKGziFqVU8CDQifcKLH6hwOVzFouZvjfOLx
         QJrhd8WjDCVOwffXCBm42fcbqYA6ArenSZR9cKgXkqMuQ+ETO2LwwJpbxfoGbZUirdJH
         4DvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772503421; x=1773108221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=acyJ4a+uK5qh5x2co2XOASuajgxYlRjQTIZAPblgzpo=;
        b=LYFjL42Y6kE35Gme0/letiZuINXCDwFW3FyoQgpnBIvufX4/ZMH4iHMGUSkMdbtKYz
         AfMKWY38dGuyV2StQsPu/SobNWRwIu+UBjAMU1bHH+CFByBVo8b4/Ijb3fdEgyrT2HpD
         b4DECmNuDRKuBx/sAZZckrpzvACuHOOHckfPdzb2kuItFfoHKJ6jVb6VLYTxYYi4ImSc
         r0bTV9Yw/GOMTDkp64Z8Bxjh48NEg/lC6pzQwcIt+YyCS5b88dJ4ZEhVQ6g/1JmrqlVm
         IwcFs8iFhujBnGHgI2gowi15299jQLItYY3eltpstKy3sM7nVAsHf7VtHB9p8dN3HW5w
         Da1g==
X-Forwarded-Encrypted: i=1; AJvYcCUk8pcwid3jKdVto84ZwHLTBE7M1CH10vQqZavOfoqYXuqYSQ+dogsHbSVsa7s7lcchwGtUtG6z@lists.linux.dev
X-Gm-Message-State: AOJu0YzVSmAkCjFZqJInCzR5ICdULbnUGIB4BFAWZBQeM6tDY8zRSrqo
	eLM1olCHZWzAUp61keAmrlTwb1STiyMnMjLCrXO74eJ171OwtuIahT0=
X-Gm-Gg: ATEYQzybZ8Y/GonJMFwAB82/dx0Y09gwwU38VnKIHzyY9RFrz3R9bOtZdlUgFhpuKL5
	9wxqt2QHU+G0MmimVv9FmASE40jmN4y1kudE3/h6v1gDtLG3I3DEtnDPSjI4V3lezoRxqKCN3aw
	Bnaix8Yzm7FTaYcKVwgN8PFaK7LmA8krDKu73DxGqqVfCx7mkkOSqwYiXc/p00dgbO6FfEHYVFT
	EN5lLfdpZa7zY2zgZU4gQa4uI9zuIh2tYVGkyjZ4wvVslpfWPTeztkVz1WdzKasIlsBVygJdSEd
	DQjmVa1lbo3ZqinleaT7vGgR2sYUmRdaKC8RyaLVBKgCCpdwXDArj5ufYozlOgGE5eqa88S/ULV
	5kJVnTHBtbBZLmwJQdHQTnrXOSh937wN5ETZOrjWt654IDaN1RzTelT1o/ueygbi1S518Zwx5bJ
	HIGFkWJQ1ONRpvKWbYLGIIa53guLa+eMGyu4un2xMNc0xh6ikE+MuVwMAlXmaaYfRnYYuZWw0QN
	R58EbUCmVD+
X-Received: by 2002:a05:600c:c4a6:b0:483:4a95:66da with SMTP id 5b1f17b1804b1-483c9bc1d50mr279462375e9.13.1772503421472;
        Mon, 02 Mar 2026 18:03:41 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b503425asm13146276f8f.25.2026.03.02.18.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 18:03:41 -0800 (PST)
Message-ID: <cf6ccea7-fb2c-4999-902b-0787efee6754@googlemail.com>
Date: Tue, 3 Mar 2026 03:03:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160834.2518716-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 17:08 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
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
