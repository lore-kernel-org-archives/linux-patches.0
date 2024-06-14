Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA52187349
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718407284; cv=none; b=O0cqXfIRaVISM/Htlg4/YRXJoJBcF1bWnLMpASs5gYv8YkHon9n6bPVyR1CqvjNJ8ufdMRtxb8E5k68FFwiTzyJHXsfDu0xRXdUkI8XoXk7rS/4rIBfIYuLj+9DmQzj04PE8fbZGP6zZ7yz/ng3q5YEP6D8E2vAqnqB9SwQ5vu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718407284; c=relaxed/simple;
	bh=JlwKIzdDc2gilccjbO1/bZmedm07qgXPguzxriJ3hi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KrpFtSDRIoY2t6LQSMIHvAQdxqW7DQ3mKA2vcghvfyWqXfpd9sAPPL1Cp/BFYaBS8jkiSWgayF5IoiS41B5cGCDnUd+mwocoVJLSDXXSZOM03ix1VfVxgGS794zmHVwxAICH/n4RUrHPCTDkL9z9iLprlcdMBYIPdzR90pXLCTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=aXOnHy0H; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="aXOnHy0H"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57c83100bd6so3333017a12.3
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 16:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1718407281; x=1719012081; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fXu7k1QKS8vI2uwVYNkcYSTHvjBL0gY7WbM8/Ozvj/A=;
        b=aXOnHy0Hgw+bVpLzoGMj+cJjVJLjvRkdCbEbagZrTjK+8SjZxNtvRPPiG72bF0bxra
         5EYs4c0XeVY/9au/MDVcrOxuTkHKweVXxo0f3xSVL5EsktPPy5Io8ftFi/RFa4yJ9oMi
         sgZ3+Mjuak8Yl3z3avimBBdqa+Pc6R7nhJsVuunE1qBINWGZaoFAuGSRXTHp4x0/Peaj
         mePp4QDeoz1EJTAxDyR/aVJnf7SBfx/yP9EXlybw3B7bxBtR4/spyAwkueh5EtqrwEpy
         tJC5pRnpyQnZL4wS63MBmogXPNUD95zUdmGsj6BNuXHISCPMld8w2CtC4PY434S78xuF
         nwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718407281; x=1719012081;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fXu7k1QKS8vI2uwVYNkcYSTHvjBL0gY7WbM8/Ozvj/A=;
        b=gpOx297qpauHCApBgYKc2UWX8I6LTLknSiV5MuoZGrzqXbar0v7azYlXtkqQBQ1cs3
         HWyQxUMQfIiKXIaVsY6NMJCyHG3PqRXRNg8O0YLIx55r22H8it5n5ZVQ55047RLZY6fR
         W2os+KYvLxpRjd909Q5N9xWt2SwWq5hVApreZlr7g736T4v7jpFJmbqL/6xRMT0afuN6
         XDrgQ3b9j+gnEF/iFDKvitCDQvambGiSHefqK9BuFqAzzwduE+0k6WQ61Bd8KAE/ZRAo
         LovPBeFlpvzVRYUmyZeqhPFz7lM2bZap/En7vN/XIIPDiC/LhAxZvTPtWBL5s+yb17yY
         mBbA==
X-Gm-Message-State: AOJu0Yz4UbPkGFgdyeRizfENhSk/Jla5kRdDceCaTwrgtlVKHaK7dZIS
	dv8gs4F/LuMj97TcloXnCCQQkON4eE1tE+xDpRQuT/jJ49KkKpU=
X-Google-Smtp-Source: AGHT+IGhHA4QPh7/6Dd6EnaARY+JdOci3GUIQJT1ngUwmjquFtmH0GCsJTa8YTNcfm0uCQTQVMLBsg==
X-Received: by 2002:a50:9b04:0:b0:578:60a6:7c69 with SMTP id 4fb4d7f45d1cf-57cbd69e7a0mr3017216a12.30.1718407280589;
        Fri, 14 Jun 2024 16:21:20 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4225.dip0.t-ipconnect.de. [91.43.66.37])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb743adacsm2856765a12.86.2024.06.14.16.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 16:21:20 -0700 (PDT)
Message-ID: <0fbe98f5-584e-402f-b50a-0438515ead7b@googlemail.com>
Date: Sat, 15 Jun 2024 01:21:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/85] 6.1.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113214.134806994@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.06.2024 um 13:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.94 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works w/o regressions on 2-socket Ivy Bridge Xeon E5-2697 v2. It runs 8 
VMs with some load for an hour now, and I don't see any problems or hiccups. No dmesg 
oddities either.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
