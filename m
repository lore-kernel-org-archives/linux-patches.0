Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF7C3FC2
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749404460; cv=none; b=q303GwWK5Lh1ri7Iu8TBjLGBPWNjO1Jy8Ey0U0CAmO4SIhwPkeiblkpQiDjUTRrd8dyBJ0NuNMsOSNukSEhZWoFvkl8IFUbYapGsDS686niKG6VzI8YJREDPz/gcZu4N9eIJkvETQ+cYhd2V0MnVdJYmj2QN/2dvlCZHvHwCLGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749404460; c=relaxed/simple;
	bh=tNa7t++GLpb5XVp7b/gfkdm8zfOa/b9SJSrTVO5CBW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uxQARyjuBKwSEAGefo7gOvSSB1PzmZ51DL9QzLtQ20UqJHhykbXN8Py8rC1TLv6QC2Qe8cb5H4oaAv0QUiTYUCrjmpQrF8Ns6MUT09jsPTXp40auEQohCBQLRTXiPR27HnlnQz4PB0T/Ii0tzChsoU6tAVWS9j/jRK2/wAME+sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WAOnYTw3; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WAOnYTw3"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so346549f8f.0
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 10:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1749404457; x=1750009257; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V298GByS0UihQqnZbWCQzM9pjzFH0uvqjj1S1drsO9Y=;
        b=WAOnYTw3ayJcZbBe6Lk60FRrPR9+QgwTFnAJBABnookSZFlWn/aM4Bq+372y2pFv95
         nljQyyQ2fYi6eDB/yFpAumZSfFxGULPn2pZ+Pjl6enEO3rvivFXyoFyOobNpCGPZgGf2
         UYDmPGa3FpDdk2V44M/ZL1ZoAqCvui2v2IphiQPsbmnsj2Jy6msb2wpxWIDWYEqC9kAI
         Fz6yXwt8uj1fO56bx7E+Kj2QiVDpTSm/eLZIaypXt3uLE/asrqc6Y5v9oOVOFsEQCvdn
         xM9UYmMTI+XrVD+n/xqfrmI/5p8CjoVP8el0S6/Xy0RUYV9DKZiCvaeQgIPkbUL3IzFF
         Ua0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749404457; x=1750009257;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V298GByS0UihQqnZbWCQzM9pjzFH0uvqjj1S1drsO9Y=;
        b=sBKvCQK1XXsUD/w5BNWbdX6OJDBengahs5VBML/YYX/zG440ekRueHGfnxSmkOqkWG
         BijcspCchIPCeiaFy3OjoIMQ++4QZWCB2qyqdfPltVujVLD9lRidK/ap6gRGpSpc8Ovz
         PDKRu5aj4sy6l5ddkdXp4VSQqfwC8NyclOtdj78yon5q+N4hLK2takYm3E6phawRPKyu
         WD23xd81xdqrNdAkcLmAgJLAWj+Q9snF/nD0qzOXZDHgauyxEZkN8IZPZKoHuFbiD4Lj
         6fSvjCMWLp3qqILQoq10vT0aXD0Tx2cpuBIX6UV2ocO9dOjb9u3xkQjpd4X0E6ZAVTAJ
         4Egw==
X-Gm-Message-State: AOJu0YzZx+mnc1uy5RSJdZMhJewFd2r0gMUUbrVMos/e+P+Co20nS986
	SQ5U1REXVAeDRhAmetjf6yRvWvWqOrehidzUupjB7ICvZZNLiSMG068=
X-Gm-Gg: ASbGncsy0+gdwfBbz4El2yVLYsi6/aEAMgy0v2eLjJaEvSDJcVbMVb4rmNbuHw4yEt/
	I/dP8MZ0OamE5VmHbqkHnKO4yYa2JtrlnrqUwklbL+Jzn3lbgBb8BAggnkyEWCU/v5XoQucOixV
	1tNdc5Lys8r0S1uKR+dF3D4it7qMYwoZ5OBghUmFUj09HDfTkaDi/8MGB/MJovmir0JC0k7oK86
	hXjJKBmOZzTR2tUmXNkn0VQ0bNM+LHR3A80eAUoAnRQiIFHCa/jfwOFvRJN83TEm35ErvAjDzY1
	C0UCMin1W5QxuHQmXrQUw47jhcrnrX4LPe1tPFvfFO6JZ0WXYZL5JHlNBRVLcmNjglK8+TMdnod
	V2AMN+HN/H6OU9bQds93Mp3lV7E4=
X-Google-Smtp-Source: AGHT+IHnN4ArvaernVN0i2Q3r5CdugEYMRzyU+aoqQurZJvd+6mjnN24e9YgyDP9K/6+UPyhBfAazw==
X-Received: by 2002:a05:6000:2585:b0:39f:175b:a68d with SMTP id ffacd0b85a97d-3a53188da55mr8344003f8f.11.1749404456378;
        Sun, 08 Jun 2025 10:40:56 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace02.dip0.t-ipconnect.de. [91.42.206.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a5323ae18esm7821035f8f.33.2025.06.08.10.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 10:40:55 -0700 (PDT)
Message-ID: <79767ec6-14cd-4fdc-975d-e303d3d2fd78@googlemail.com>
Date: Sun, 8 Jun 2025 19:40:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250607100719.711372213@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.06.2025 um 12:07 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
