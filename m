Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872965;
	b=1jkAcDD2oSb0bYYj+osySMQMJYcoD5wVyUN69+UW22DUN5RsMSh2nQP9y1RVvGh/vhB/
	 wTe/1KRaY6lLrsdl7OaHJDi2qZQvyDXMJju3uy4ldNmIQ+6SKyeEQukqthkJ5YKFTo564
	 AWTI7zNjP815xqCWLfHRWAFser8H+n2AirUqIQGUBHzh1EHvptGiOhphJud5n+NKqWExk
	 4X+918yyLjl85tl5AQcGGSe62DdOyWcXywuku0BNwbK4i/43NYnIqFxUqVX2nz3XPcrqt
	 a2MvcwLYkBaf2NFKcmMpdrxyqnuwnbhBO7CmpWGEsFPAQ5R9t5Ppi0fqM7iupEdmm1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872965;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xOdSrRSD68sU03mdy3xyH/obHFukp7AFHKnxKyzExEA=;
	b=4uDwJaClwQQmwrR49Z+57rOkInP4MznfJB0XRRPP2B3vI9WOllOb2sYn1UhEVBZFkRKF
	 vRP15CnEcuHJTc0BYnv0nuBrwspOpEhE4VKQpujwP/CazEd9eLzr1fGCE6ZT3Xt27+Qki
	 JpOljfjYgh3rZ6OsJY+wN5MMwxLs9xWRhHqqojwutjA5fX1l81YlpPqnADjBNIsy8GMcB
	 NyeIQsX6yOeGRW/S8GdAIASk6oLyyaPNj3jHdoc7GqmcgFClsXgay1OMhPdeVs6BYTREM
	 +F5rYEMJToDf7FRPbqCduSD5sJJK4np35C54RH6bKn4BQur1Njiybsv0fgMDwQPgEgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=B3imazEI;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC52D606A31A
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 20:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC52D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=B3imazEI
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so1084925f8f.3
        for <patches@lists.linux.dev>; Sat, 24 Oct 2026 13:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792872963; x=1793477763; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xOdSrRSD68sU03mdy3xyH/obHFukp7AFHKnxKyzExEA=;
        b=B3imazEIc2ztSDsjXQ5gcrfYKs53bPqByMzMXCaa0R16ahSXRJoQgCo6iwwKW90Co6
         Gc6S5pKmhe1jLot3X4GFSDzPBcHjDK/2HrrkaIImnBgTk3MeLyDqnY0Kci5LkNMYrzDq
         7Y1jKzvTZf0hsZPTKZZeCggEentnh+D7GkUW+aFvojJuraFBCQRRtEeXmBWsP+v7Gv+u
         44FfaJ57kkx+zjA6Jb4Lj1fDdLbTnIUMMfWr5Ei9jG62CDnPciRK+enkg8O3vRQvHkqI
         Cx2NNVIaFEtEtOfsf9VimbYbcCzrlHWDFq+ViT1OBk/PTSF6kNrSYoVwSYAJMxJPySoL
         zXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792872963; x=1793477763;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xOdSrRSD68sU03mdy3xyH/obHFukp7AFHKnxKyzExEA=;
        b=tCPNtNqMPnlQU7BMeWDIV/Edk26fSQEjFMD5h4wTcXlWyyCppGae64D5cZcxK2W/ew
         AmO1MmT+miVvcZwA1ZRFkyTfAMmG/W9r0Gkl+UGSZxKWewD7e0xxMuUl6ULSgsmNxAqk
         NL4sYjztKsO9OcUInox7nRM0eMTAjwtsdbH+KxX772UDSa9QmuV/uEP7RggYGsBGy6Kz
         SxQgdA+tSYDL3G6Mq0qaf6cS5H92Dcx0FmhkUNen4ewEqXPzgjxfPNs1RQ3FFlovl8W0
         j5pzJgQNPZ12V78Bixdvmae7qfYC2D2px00FJGmXUU7FAkMe9Zb48GzdcYE5ZEINnfDF
         vQWA==
X-Gm-Message-State: AFq9FYJBxS3TZhL4SMF1pyLCDgwRy5a/AIz5sBn1CbOndcc0pB2s0v6U
	wZkyX7iCj+llg9M8elzewn00l9AUjqwxEjJJ34Re+HQCxTZ2a592ZY8=
X-Gm-Gg: AYBFou0sI0ilq1OlQMyGsxrI7VEhSqNENINuG+1g+7H7hbsgmKxJO/oexgFowQdMYdJ
	jXvYXXA+/IMyFUuBSSEr+NaxmsEdwsWPfmvDkff3rWya/BWEyZYnhxoHOplzj4WgxJo/Fy2MBD4
	AAmdcn/E82ge2nFoCEI+KTqvU1wRWmskyavBFeVMI3BihHHqKUGW8stuaNRiDivcVCPvaMVZr88
	3m6vYvJjHiO1Nsh+SP+rZ66anaq0Ql5dH08+50WCFzHbpVgQoO6Urap0fpEaogxV+IdSf0Q9Elr
	tyCUqMwzV8eXcVNZSG036TA8foNQIP+PZJb/8SEJ/AFX5TooDXKvXPzNUvjY9ofTx8z+kauy5vf
	QfeyTmz+KYsrCX967DaJE3aT7t3aLqnK1l++lwjQM2DjbLX7XHbaUMKmuWepQULWqmc24qABp4b
	1SB+CeXmUUm8NA9Oh/gVRLHigoZoOZZ1el1SkfE6MgL4H+fs7jx6rtqBurn1IStqNywwJDrvDZA
	wvYvDexWyoy0Sw/1la09l7WzeRofFnOIRgwn8PAQCNtlK+D+9L3onnLrlGc+tAgL369wokd5Roe
	uquTkN6j1bOcf593ZEr2puXBCQbsmw==
X-Received: by 2002:a05:6000:4549:b0:48c:7306:18e9 with SMTP id ffacd0b85a97d-48e3eba0c36mr2612894f8f.43.1792872963065;
        Sat, 24 Oct 2026 13:16:03 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4b2b.dip0.t-ipconnect.de. [91.43.75.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e4115f496sm5555426f8f.5.2026.10.24.13.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 13:16:02 -0700 (PDT)
Message-ID: <1cf833a2-1ca8-4fee-97f8-fb9b8e76b868@googlemail.com>
Date: Sat, 24 Oct 2026 22:16:02 +0200
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261024064731.125251200@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.10.2026 um 08:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
