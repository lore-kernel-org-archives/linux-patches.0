Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9949258EC2
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 21:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776721897; cv=none; b=GvhIXZdi/tnbphpX4V8Wlp/M+AFLhMO14ux3lNd1Xxs68UJ8kX206546+buChdKlG8OOyabtMzyqOfLESnWEqtbU+OrEQyPy/yahSZrHjM6ODiujhJEXaCYbiHSQ7lV7sVkdtMOw/aF9nG0/wmzH9QQaSelpWE2239dxOlUOiH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776721897; c=relaxed/simple;
	bh=UCH09i9kr3HwymcHQIHQgdfUhNnnJhDUwwT8dkBQh/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PH7UvuaiKKO/CJoi/MuxOLvU6C515bM/8f9HrVioTBz+WG/KUUBI/PdbzP/qGob6MHpoQLlMjsIzpAUysmFDVe4A2EvZu1Hn9ImaOD6Ah0MeLN8YCsIHkL9aE6+FHgO4/kjygZABk3YsGYHfsl5PLLNs2XBwM2Iot8PH5lVkweg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SqypVWJS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SqypVWJS"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488d2079582so41359105e9.2
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 14:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776721894; x=1777326694; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OWGpw+d0ooBuRhyWKv3BkdREzSb/1BEA1ncaeoqJZ48=;
        b=SqypVWJSlCPFFoGyTWZrJByZyPq2hTL/mPCQ8mgNyL2LAL6Vn/2NEJKln9y1FvRJmR
         uHPZeEFMx/C5LFJe6c9thasmmIDB2xC/ugJzVth+zmcOVj0WgdPTBu1iDnH131+p43Vh
         eNc+ER3NxhX94UWVddw0HLN4kXHycHOQA3+p4FymRBY540c5t1nDngZiJOwVW731CpT3
         zrkLqnlOs6FE+ktbd+fd7EwfYv6sms7o+DMMUjW+TLLBT4MUI//KTR6XTuhb1QcV2Vmz
         iOsWReexRg2VyMthLiS3taZFSIMjzC5ZbJJVBxokBkRPrC0sR5hzovMS3S7Nzvkm6ZY5
         2q8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776721894; x=1777326694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OWGpw+d0ooBuRhyWKv3BkdREzSb/1BEA1ncaeoqJZ48=;
        b=jLfL/ePQLzpkdQatyfOrS5m9S6QBDdRFVYJlexr6Q9dt/FGYU1gO81T9TUnUMBYfr4
         1nRHmAvzLVMcBuapVt4o/FZmnO2tiznR4m9DJQJjdPLTCU8risWzRfI0A6IBHUdoRxF3
         Fgq/HBMvfstdsyMVOFGqrIlRvd67JBF8rZNKL27Smo9SxwCELP1JzOI9wzDbErJfmWEz
         pn+k8X/qIAxRfV3SpYjqDdSRjyJc3QWzMLxx7WWhi8ecykWqH21WFGtUysz5jaZJJls3
         DOt4ODJXh+Hi7gESYKmVJU9lKyerEneJYYasQyENlk0QjnBKaJNKzZyjCm9kItY990bT
         Cbqw==
X-Gm-Message-State: AOJu0YwBj7zeBOTc80Jr+4/g0dzR1OnR3MghmuNtOerhOKjiLTRpdYTL
	m67AjNK1HaJCGug1M96orwMNpWFMvzrRss41EnypRusjgdk/cdbt0UE=
X-Gm-Gg: AeBDieuZldvdgFhoVAvQfLE6SrLWBL3LZqSklR2RMaGI6gG4lDCpErnQdIxY+1XriZA
	aw7d82wdRgdzeE5h9BDBfqoJOMd8fAlkTJLSAerPf2fUxMm1abg+3Spe6qf8EwKlUCFChNblBu+
	vaq8bTmULO9Dz1tsHCIyFsZLGjSBNE860uACclqw3pVYTY+/qy8GNRPpFgNvHDPwW43nWdlFClP
	e4cQp5bVOX06BuCb5NYWw6BLW+nnAUiEqmhwWK64SO+r9RdVHbQIO1zQwc2c0lJCI8XbuvOX9C6
	t72ArKHGkrFrTNCTifaDzuKN2SgenxITZCFgGm5qeTU021wR93c1FXmh762SQGRWSM0Fo1DXqp/
	vvTfWgU28UlJPItUn+QRQTBIiALz4fErv2QECXl7IktXwhjgJHE8Fa7Gd8XW6jfShSQBUzkknJ1
	bMX20F6DepmSxULCTyVy0flIPpKLG86LU6kUF8faU9AcgZXK174N+iq0n0lmeKUsxD0Yq9utSEI
	6kyMWmClE+0xg==
X-Received: by 2002:a05:600c:3483:b0:486:fba7:b150 with SMTP id 5b1f17b1804b1-488fb7787d7mr197990245e9.15.1776721894021;
        Mon, 20 Apr 2026 14:51:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b42df.dip0.t-ipconnect.de. [91.43.66.223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb78becdsm147966165e9.5.2026.04.20.14.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 14:51:33 -0700 (PDT)
Message-ID: <5474b829-b135-42d4-ba66-bdca67f04d66@googlemail.com>
Date: Mon, 20 Apr 2026 23:51:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153934.013228280@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.04.2026 um 17:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
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
