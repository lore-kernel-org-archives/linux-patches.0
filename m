Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA91DF73C
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 22:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069007; cv=none; b=GZO2JlYbEc/SWC1pmd+MFBwgg3Kx4ziypP/ighrK9MsDWgdejNrltrVRrxJm4Ez8dI6Cv6mPpUHvx5iGnLRbDGE/zQNj7rhDWK6AYG/cE76WVqGi8dA2YXzrVRMy/A+cRiHbQypf0Ca6vaBBW9tUKojhlwL5swy1WAqsc8/mBLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069007; c=relaxed/simple;
	bh=FgQNl90BZ0fIkgQbd6eIgd41f/uNSpGEZfaclUBgIWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnZjxVwrRFPhvJ0tmn33+DZ0uKl8hReQMGAxvKa7MuunRfIqfH9HYvalliVtGaGr+pVnss7Mc3P8AADPE4GtY2oXZ+4eD4qa6MLPjfa6M1TjTrFkfmlcUuuSCBTJw82dVtMZYfQBETRoJXrDT6Iwtit6hRkkQsFH33lsbNFh3uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=b4BVAtQD; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="b4BVAtQD"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso65144125e9.2
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 15:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1777069005; x=1777673805; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pTBHxscSUbuTHgt2EwkR8Brb8rC3RTP/i8kdYc/Dde0=;
        b=b4BVAtQDdzY3JdKEoZ1P1/K+PEVlRDvZx1g0AYnx2tIaGww276bFQ7HBwh8ig3o8NS
         yNfiPoS/1wzkixNneULwOaIv5NywLKcpCFLLXXozXslnt5ekgYZLLw15Sv6va83x9Ra3
         SrZdETj2RKdtOfoLhuQVoG5KLVw+5a4/j3vNfFDK+Rdv1C2MgfXt7OFEHFA8odwSFwrW
         +Dl7qnzPOWdA92tAq0AiA6NucBd0EBwMzUA+1E4B0LJzQHr6wP2qaWVCjY9Cn4oBdAXz
         tERqB2zpxhZG3IDPtUbfBajaKiVhoKyOk5RhB2fwwhOC1psWQT5ZBcyL6nSSLMBN7Svq
         Mo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777069005; x=1777673805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTBHxscSUbuTHgt2EwkR8Brb8rC3RTP/i8kdYc/Dde0=;
        b=ZJlzt7ACdRcrFKHC48iSq41+I2UefXBzPJ2w8UamBICVkdoBmr2lKL6D7WFfi//OCT
         D12/Whf4z1KX6riFAMqs/Qk+BtYVqoO0ti7e2NgrM5RIoX+qYtK9oeDyXnShcyyRl0Su
         O2Go0SkOEhmtiDYdvPoTIQ9tL42J3S/RC6xw4QkVemiUrSf+ATvydox4deEpyidL0vdW
         D3l3Km27pMFKsabIrb4SsF3aU59dIVhsFbPzGaZ4LilQju22ASsrz+Jx+JfqpB09cmt2
         HsCJW0lBr/uY5aR+/+wJnihGPhQqhT6UTxzC62asEjEG1qwlWnNwjc04oHXTjFhWKIWH
         ZB/w==
X-Gm-Message-State: AOJu0YyPUgzoVX+htIoyZJG6q7HV+ecdYwUCTyNDnjs3adBOI0stGrnd
	9Cne8srMhGSFMKiTaCaW+X1k9sHNpc4f79Gnyk1Z5Gn87eUSzkcV3qc=
X-Gm-Gg: AeBDieu4Qo5aADzdEEQATjAcExRiA0R9R2ArKJJnES/YF8xR+tXIbLBENfaL1pDp6EE
	9TRdMAwudG/YIMWkfPAtDg9jEUyZ1ef0/e8eoi8loEvcsrMrQFxy4cWJTRzxfPU2yXW6kqHWnvJ
	5VyoA/ca34ZksWPLe7fvYdHbbEUfcig/7+/DwxhSTazhz4r9TDrbfDVULKufNFs2AkOJHKQxHPD
	YOxFZpc351axAZnTg0IlvMjcqmKrILYvCn1RvfDy88t3OY12u9PZhNoqCDK8n5Y4aVf5xwngk8H
	ELUYTtCosTgrUCtq+D9oX/QOKWI01vBjbwortAVdMc4bt2XDhGJrhU+kHWO38QJWIFqQlYiZtR9
	1IpIx4ldHSIECqV0Uc2d9MCXnljFYNkXCQFwKFSyQ8/o4UPP5ZhoNEWDLoX0Z7MiMlAY6j55WBn
	SC+mB02+gGxPrMIYQ6lgaVyoOAsrTZvCGf3W3w0iXqUJIjiiBpn9VTovHunCYU/SiXU5R3oyQzH
	2eVoHIl5nPj
X-Received: by 2002:a05:600c:3e8f:b0:48a:65a5:751f with SMTP id 5b1f17b1804b1-48a65a57799mr65252065e9.31.1777069004787;
        Fri, 24 Apr 2026 15:16:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4e21.dip0.t-ipconnect.de. [91.43.78.33])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1c773fsm699136155e9.12.2026.04.24.15.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 15:16:44 -0700 (PDT)
Message-ID: <d88e43c9-59d4-45f2-b9e4-873d4486c9c5@googlemail.com>
Date: Sat, 25 Apr 2026 00:16:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132420.410310336@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.04.2026 um 15:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
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
