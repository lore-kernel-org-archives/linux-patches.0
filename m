Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A673C2770
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 09:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776159051; cv=none; b=gpKoWlyPtuDES1kgd1wq20tSFpU7dzR75GZzFDDvsnEIqPjpd3vBmUUcg8C1Ndp7HsxejTVfxB1Ika53SnVqgmP9y7WI3eOfsXUPKqn5YDbND3diW+SIa7cK5XTR8SFPpeE/HYT5cKyShX/8PkQvhFG37OWJkULrTG+JLfgsx8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776159051; c=relaxed/simple;
	bh=uqOESQ4voGFI6L6rlvosXujbAWM1bCcUHKcASu6iGgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAWJLGxKvtGX3DPYthNfKONIa9cfNHEaE1q1imxq/rPsAS7NGBouLN+gDOgU6zZ0u15sSYe6Xriz7R81moYmASp/AKKSMTj65Oc1iz0ojDTCKe8wx8C2+7q41H88UKf0ByoJ+fdCJKit3PK4pRt+LilqtyrJFCYBtBIU82LLLpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=oreYwn7V; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="oreYwn7V"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488ab2db91aso83647435e9.3
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 02:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776159048; x=1776763848; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i2HeO3cXP7an/0r0tpwKnzN8RJZ4Ea05CvLrKgmWj0A=;
        b=oreYwn7VVTpXXjiaf6MBE7yQWPoBftLKNgw+pLM0X6hpzJuoT9IuFdBNTHJyGDPbdC
         p7c7YfjQESMIA0QlLxj4auIWOY39npiyHaS3zFmPDhFAM4ifRXRJBlIC/6jZAhOr2kai
         AKWBoN4iTuy8U8WXwnvJt/hWubRen4rOeVLzN3qfFj4sJTfQVuMwyyOvC19/ddUnCs5/
         OhVp/hhyyKCGUmjQ37yxXRYSCQCf0ug9p4FApDuOe2NWywIEqj8FPwmkEFQOXIjlyHB0
         jBpxxAcGSzfGrlSLldqV3uorrhpXPqhyvn0Qho0v7qiaCb0/bBDz7LcezFqs/YwvekRH
         Mj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776159048; x=1776763848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2HeO3cXP7an/0r0tpwKnzN8RJZ4Ea05CvLrKgmWj0A=;
        b=eo1+gwQtTjlE7B10fKfr0FPnWRfUvGmJNl2p8fTuGyKFdKclWk44L540eB1veXiGnJ
         FP+HtcT4plL6VBXXFol/c+JasFjXn851FTWRbiAVLSEhVXX41HNjW9HiSOz4zQhARH17
         LP0+Dm87lCF3XiqN8W0CC5IxSlmlxBfK4EFO/DfeaG6BgbOVX1ZLyxVXdXEfI73d5tSj
         oRxKYMv68OeOo27/7tcM68ZqVGyGeg9Mlx2W3DmTQRMGWgigin2wRVzi6eWDJLkUBAvE
         Se7lGRnH6D+TWUNxRKVi1geBjTpJpKnboGuiifH5G87zWHEHV601RvalD0cSQpzvSDeL
         q+8g==
X-Gm-Message-State: AOJu0YziaNe6zmRIvOABsI5UzIcvnYL5Fv0qNzZX8qMUC5UaOF0fB2l4
	U2XJmd+B8H/jsbOIjl00dM2vwE0cSScsNd4JbXuJpK1QhSiXeP5VW1Y=
X-Gm-Gg: AeBDieuNLZkXFWIq6gl2mRpJ7OZkflt5m3zgsCttJfcutrf0yhF9jB2zfrOnUAhxVli
	Ia3BnIdT7gFPkSfX2XC7hwgIFDfQmRjvoP/iJG4Myc2fAyvfurYl6Gz/33FSDpLGHUFLbyGhSRL
	/T97G6S14M0TdOtqNYC92HXl/6zxY0IGv6tnOcv41fLiQx9/BBbeA33vJ6x13T1kIkNwDu2xzAv
	iFnUH3E20nhkcGgsEw5oZeGNucAvZC/2fhV6BYyWPz1zBU2ugAhP8zN/zkt2UpZMqm/tTj1WHRQ
	t0An2l11hJOc6rRTaN8wr99EDBPc7RT4PNY3BXp8AMMqrBaUmh0M3wvXN8g0MoMc2KSgsL0zdPA
	X9TE82HJec540hNGo5haKiwg341/Bibwfu60dIOE+RqYhOjPQiXYhi8n6+fHFwjwj8/Z9DlElix
	f+PDsKT5YJU4aqz517OMLZquRSSU6sxEYtoaOyBiDr7trHWBJYXqyUTB758m9aVOe1Q/pKidFea
	Bw=
X-Received: by 2002:a05:600c:3150:b0:486:fcc7:d6a with SMTP id 5b1f17b1804b1-488d67f4c4dmr253156735e9.13.1776159048090;
        Tue, 14 Apr 2026 02:30:48 -0700 (PDT)
Received: from [192.168.1.3] (p5b05757c.dip0.t-ipconnect.de. [91.5.117.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d683e54fsm115353265e9.23.2026.04.14.02.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 02:30:47 -0700 (PDT)
Message-ID: <9b41afa7-01b5-466a-93db-635d552af16a@googlemail.com>
Date: Tue, 14 Apr 2026 11:30:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155724.497323914@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.04.2026 um 18:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
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
