Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D252D16C854
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 02:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741315403; cv=none; b=LDdTGleQ5YeHzGgGXP3wW7xLywkyaR9bTnpvQ0MkMH1+NI8X39jQPLaRNbtIgR1mIiRAKN4P/0p3EOF4mf+imz5DcsIcfsmFmqpUiD4i4Iw9HXP+b/NY+Vr18EWOH0BvWvZHk7zaP6BuC551EfJZuCjpqmNe4S+bv/CEcFwYHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741315403; c=relaxed/simple;
	bh=lu1RNpPtTTMW8hPrwHoqzvYwwBZs4o04id7aariJlpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c1REJF/3AZAmsUYRJcLxNALnuA2hEzwFHj/kQtiNDq6kCM7ytI0995ijiP8NJcbSKEJM3A1tI1OwOuDGJN9RL7a4VBLtH8cot1qPqMgzq6Fbp8luG+CQfPV5BIvFf1cuHFVub3rN5vkqMiPT7MhzlkPOlOsysyxjhr7JphY8nlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BuEys4nT; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BuEys4nT"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-390cf7458f5so1271819f8f.2
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 18:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741315400; x=1741920200; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=21l7JhXFBnRN90S1P9ZzisrlFHAVFiQS1Uh0soZKZtw=;
        b=BuEys4nTdLD1MHZeNMNd/3zvEWD7urwImR+MUzRvu37HeyRm7Xx77da2V2rmt/PUbS
         Gp9dP8e6B8hXtxDuoihsz1GhJbdjRE6ExcA3IcGwn58BKBMBZuQw/VueXV5/PteeHbhZ
         c/Hk93vJib6pvGRd7vwkcxZCwmYLYn3QgEwJezggqB0uH7msupvyd34bjnwQDFIQqVV5
         tntfkkzAWHkTxx9FI4hzhJU4upY9mKpzsYPgmEtNUSSo151RklnmgcpMxBgkwX3SSMtH
         rs9kO72F3CPiPkdOZQ6UKBhOeXBhd4S0cVbUIvJU2nFBCwSWtAgZoFoDoGUt2AirytO+
         jk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741315400; x=1741920200;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21l7JhXFBnRN90S1P9ZzisrlFHAVFiQS1Uh0soZKZtw=;
        b=ShXqgkL2ZaM+vAgYZ4ni23kDV29a7aqCCVJLgF6zvJ24BaeoX1HLOCkYXURaDA1T9c
         8DndRSmKTn68bv+EmI0Iw5nO7oqINcyvM+xK8zwCAqy1sJZrP5cBQSJv1Ys1Z8QsNTiL
         ttH9VDv4Bvu7A9hb8T3B3tjKoN5G6Pq1GJsFOYmMC10VPCf6sD4Rc6J3g9ef0rAJvdnZ
         jcGkvKelTLjOrgSbdqPtMO0o4rgGM9B7lyZdl5sLQd/vbwt/Mz/ABAvlgu8hP8+kxpHa
         2Y8ORj9faOIXwKTOrajKysyT0rI3n5x2OTsPoYHZHu7PoR50zd+DFk0AhHRw0FMBeaBh
         5giA==
X-Gm-Message-State: AOJu0YzSJ+bf49JjLTYOdIdo1/ZdsZIUXEywaWnx3S1HHiEus8FYIX3D
	H07ou+LmtMycqGvbA5C6YnwkutiusAHg2yQbPa+zpe3D0qFSy8E=
X-Gm-Gg: ASbGncvF+cMDvv8gMN7lTSvH55NtdbtGYBNuXHIgp+x3YDG33o1zr/PsmC1pX79FnmV
	guZE3LCGwGUpIv55hR1wEZE4ImzymilzQ0qB+EMcw8A7KTmU9Yfbzk4eiZRlOiBGDrjgQurZVPq
	CCidzT8U8Gl1t+4OpY5W/nvWbu/y04g3QN1HJDKcLlcMaWCqFkgXgMZ55NW3+X75pFAGFdj2NLK
	PsIi6sginFvcwjJ8TbpD3a7Hhjl2aiKtk78PJQjssHC161NFOJtAmkngCohNFgdepayZL3ziKMv
	/weOHihUhykjkx7dBVZEtcS0/7R0BJJ9X1lpPU+jI/0lIkIvDHmKx03gkv0+LPiCHCI4uYaKeRW
	1+II+nuKNSmShX+RG0iaD
X-Google-Smtp-Source: AGHT+IG9eA+HEVAdvrRkowX3CKCIOamcUeu8hO48HnBvAUkscRzOTUfZ/2WqBVl6lxgKs3RZoZThBg==
X-Received: by 2002:a05:6000:2cb:b0:391:306f:57de with SMTP id ffacd0b85a97d-39132db1ac3mr1248059f8f.45.1741315399899;
        Thu, 06 Mar 2025 18:43:19 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4f54.dip0.t-ipconnect.de. [91.43.79.84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfba686sm3863532f8f.19.2025.03.06.18.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 18:43:18 -0800 (PST)
Message-ID: <c941f071-3453-4b0c-a2e8-19c54962c9ac@googlemail.com>
Date: Fri, 7 Mar 2025 03:43:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151412.957725234@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250306151412.957725234@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.03.2025 um 16:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 147 patches in this series, all will be posted as a response
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
