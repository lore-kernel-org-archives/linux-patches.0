Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E65D71750
	for <patches@lists.linux.dev>; Sun, 16 Feb 2025 06:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739685927; cv=none; b=IVr/Uj6TYZDskxF5x5fjEu0lOyQ7U8Z4H4MtYgFF4XzaiIPx7zCDWMNVY5GocQgpM3fDZWmp43Kh9z9KXXF/tcrcbdnK1CjogZLKh20Th4mLKxhjEkq4JHwwTecTRJhvknkAbaeNbSTwsfXzGwwgMw8tROMTSV7eHmlNFxsPWK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739685927; c=relaxed/simple;
	bh=OhaL9slNmUsK/Mpa2QptKckfEEgfXXdFLpuPR71wGL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wf/cmm/EANcWcauwM+Gg9FypnvKp8BEWOEprcUfUBK4EP3W4c5IDZR0s8Fl9HYmE4VnCnmD5+YgMxrkpWXlAKkg4Lw6aYdU1WW0GDzbCFhSKXAFP0iLJ74ikoyp5m7uZ+OzgIHp/UzkOw4NHUzlgCR5YqluWFk25yudbeBMZURI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CxHtHy0K; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CxHtHy0K"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38f22fe8762so1638424f8f.2
        for <patches@lists.linux.dev>; Sat, 15 Feb 2025 22:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739685923; x=1740290723; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=seds6rEanzkvGS/3OLh60miuFhKKG+9f4hFXMzC6V9M=;
        b=CxHtHy0Kun8B/l2vKibDhFXymtb6AKQ9QQ0isU32JUQVrk2kCACix3naonElB44oEe
         2kT9axttx+A0Oa0D4CqmPVl/0eJ8lwP1N2RdSVIHFnAaJow2q9BBM9pW6gj7qGs1adC2
         48RH/G7fR/wZ4XJ+F//qb5lI7FHliqZfGUuQ7vSw5D4/qDNovbj2aSV1cBPj3/t0fn8s
         HOsqyCQEAODVnbbysIvylTxIwJ/6yfptP+SrRK6AwiDDxKOJJF53i6Bw72IoCd8NMhnP
         FS9lCsODc6SZ9Fb9/TD5eI44Mv1O7wxhaqhpkxfekH0dKM/KpgW2FQPm8ootoVumsrTa
         VgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739685923; x=1740290723;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seds6rEanzkvGS/3OLh60miuFhKKG+9f4hFXMzC6V9M=;
        b=AQeHbEQv3gBiDAVcRa+kXL6wbFexhYqpMwYGCAe6kxdwaoW7hnHR8uumWWNHysZf+O
         yY/LfQR/uE0yHTqWi+9f3Sb1kIveBKSZEX8cvUdt0aA19DYWjz6XoEdMpMLBG4KvSIcj
         hyRQFIUlHMLp6bx5z8r7F/pgTA/hncRkGoYAhOwfo4qDDirsvPj4PX8s9AIaIEiOIYkB
         nlHAAqLSwL6r+EL3ldNxQql7k5FYdihkKPYD81+1Ip0UmGoKekhAJqhZulRw09mhSnw6
         5V/SaslReNKmt4h4quJh94wxOkpJKLWUS9/qjrucfG3Jlcj6ZE5ipJ8PzexRcXeSJ3oC
         dqXQ==
X-Gm-Message-State: AOJu0YyJTG1/H50vMY41IeS38n5S0BMuxkdbUv7QxMu+D7K03oV/ujB2
	8dQTReWqOS/pnX1m6Cz0xJzxbPCNMixDc/vrKMf5CZXG1LdiLCk=
X-Gm-Gg: ASbGncsSA+xyryW0VrvCCxeM/oc6AliId7adL1KUSjl1vzYUEbmPXrL8jLDdvc8/r0S
	dOXQQmphoeOgvDASk4QLQen0Oi0ZO7RM/UhQZQhp17g4/FP6w1vbJzBNGAtwWkLxsNEV3BNC0sx
	i708QnIQ8zCV6WqcNAfAUewnoCocrPW+IIoTqHz8ubYXxhCRBD3A8+tVUrPldqJ9DsyochMRD8j
	Ns6zcftWt7iY3/1osurZXAcczw70uuM1HsWy9elT79wy97nPd2QWd0+YW6q1CryzncOg87U6OQ8
	HElqqxQJuV29B5Bigr8zm5VnDnMDb1784O37ny3mLuKk5GGUOf65Vs8XXRck8qI5l8UB
X-Google-Smtp-Source: AGHT+IHCHA4n/7FH5Y+lRBDP7CtQ0JE291+E2RuWebGty35SOl7fQM5SuPMzQk81ZJZ2t1ABlSP04A==
X-Received: by 2002:a5d:5f50:0:b0:38f:28dc:db50 with SMTP id ffacd0b85a97d-38f33f11953mr5975112f8f.1.1739685923257;
        Sat, 15 Feb 2025 22:05:23 -0800 (PST)
Received: from [192.168.1.3] (p5b2b47ca.dip0.t-ipconnect.de. [91.43.71.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b4335sm9042195f8f.15.2025.02.15.22.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2025 22:05:21 -0800 (PST)
Message-ID: <259fc09b-3185-47b4-a10d-46feb2e09eb0@googlemail.com>
Date: Sun, 16 Feb 2025 07:05:19 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250215075701.840225877@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250215075701.840225877@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.02.2025 um 08:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 418 patches in this series, all will be posted as a response
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
