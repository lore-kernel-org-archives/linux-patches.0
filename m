Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10FB1991DD
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 22:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744929938; cv=none; b=LWTpnoZsQwZJuXM+F9PxikLbt7+YwGQN9pnp9e4rLjYN8hcloMZa/wK2PSdGytNS//MFoVmupT4DtQnd+Hg0J9pbs6sDNmIOEvjgVmtk+5mY9MKhUBzmJt7HTBKJDHTA7tJ5hXXpDCQKGK4/co+BcaUbeTkUje0m/4wX9ThwNX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744929938; c=relaxed/simple;
	bh=EGnAWq3PAIQZybaAJOEJZx3CT6TXDduyQI2GFDKbAQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXcqVYuCNiXXf6eyzd7/c78aTDApGj/8C60q0Co/7VSJyvbRd0YpkjPwk82Mfw4bUZuvg2532x5KuGTUX64hphvTHGobNxcw0eArairTYyvcU8sbUo5/93W2UKguEURP05o6DbyKDPDZOBX4VlgODr8PBUkiA2TJPajvDg9NTsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ngJ31LgO; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ngJ31LgO"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so13381355e9.3
        for <patches@lists.linux.dev>; Thu, 17 Apr 2025 15:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744929935; x=1745534735; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ck/BCeGd5u3fGI1syuC0GfqN57I10Eknap5ds8LXTfk=;
        b=ngJ31LgOUvCLcOhRsiULmY0TBKCgxu91/VciNNQBEO5wvt9oL7eKm0SN3+sLs6KWs3
         4dyDNVEE6/xNh60+UTb3YXhDRhVLe+bGU86bIkrtCHMSTYNd837aXThDVHJqa27ySNLh
         Yzh1IPBkoROBWMn+2yCXIMrhPVxsLAODfm2Ac6KnV6V1ZXksqcAQH6mFW5HTAXfOW8ly
         ZnMvR7ZTiQAHQM6Yj3ZXmG/M4JVJYZouIxVZZ+Xt4rnDwTO1HW0TQd2Dn/iphCJc6OUT
         sqrhx2YprXJiVnZ/d3ubXnAfPgYG0HTB2w1h8NOAKftTvGqQRqc1NcAbDip0HZe5pfJk
         OiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744929935; x=1745534735;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ck/BCeGd5u3fGI1syuC0GfqN57I10Eknap5ds8LXTfk=;
        b=aZkiVXg6ij/inF/XfIFbhdoDhNQAroNe/JeJ5inHMKvdI4qna97LdjUzokO0Aef7u/
         nM4alIv7ek/I99M/XJcW/xvHCSjme9WWDaDk5Krn+PySXH2Hy1bO6FPY5BTUQoiD4MgI
         jo+FpTvvfuHs/ocrbdFnfI3qv456r6W1CgEtMG6QjX4TeNK5rb8ywxJeH7CLcUU3TSkH
         DTHLOGUjp1ACFFmbw05oPeI5PxCyxkDS5N24jZO5OZPJd5jb0qLgTzRaTOv1u7dIjmiX
         bxaiv/oNDcUNJfa4yEjB09Vx14Zcr1bnsWJupJxymobvwJ0Qw2j12+3d1XK5HK8XtjYy
         Sg3g==
X-Gm-Message-State: AOJu0YyRYCTd0tIwUOFG4iHCH4HN4qGwpL5llkeVMBp3ZiAwgljnpZVn
	qtq+e2S+0uIw+5Tsp/GtME7Zr+hfiOS2esIDYupvJ0pZfLWu9rg=
X-Gm-Gg: ASbGnct2Xuy1ijtZut5rLnV2cDy50L54jk7ZsQJFDleVPK8u0nmfthCMiD68YyFSfcB
	Iq/BsTrQwteh//6kRqpZrka8u9KXEs8tPAarPMWf7A82wE+8AT1B4XeN0+/HIAKmtMKNx10/4YH
	fR2GKEcwHhTuhJSQJKUMIqWEGzSGpD9kp7iaZtObDAR0tF54754kUERnNJGnyzvQHrozwZgdHWW
	KThDux93LkELDV/WIlVkV8Kcu5jk3yYdALmT3M+FgJm7NWq2FVUusCB7kD61HD+lHp0EuerwNqA
	G8asR1TLKcyI8AtJSoJVekGD/7K/phySEQZy6prYRkW1Dw0vZu/20h0cKwfYa49vpwlhmVcOQJU
	F+vlEPkoIhSNvGfaJIpQ+0OAVrfJf
X-Google-Smtp-Source: AGHT+IH0hKr8nGCFTX0glH2QV5NFxX9UnibsOOHGq2Ivr66QNfElAZtEL8q24lXa60FNV8FA5rfqWA==
X-Received: by 2002:a05:600c:358b:b0:439:9424:1b70 with SMTP id 5b1f17b1804b1-4406ac17329mr5447455e9.30.1744929934978;
        Thu, 17 Apr 2025 15:45:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b057cb5.dip0.t-ipconnect.de. [91.5.124.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa433104sm945242f8f.29.2025.04.17.15.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 15:45:34 -0700 (PDT)
Message-ID: <63fa6d57-d8b4-4518-a5f6-8072869992f5@googlemail.com>
Date: Fri, 18 Apr 2025 00:45:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/393] 6.12.24-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250417175107.546547190@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.04.2025 um 19:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 393 patches in this series, all will be posted as a response
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
