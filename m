Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3061AAC4
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 01:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733536134; cv=none; b=RW8zT22TynX65uxizaF3Dfzv1gm5V25gZTlLyJvltZq81uJvZOJOk3qpiOiAfk1Mgw8Y0NSsvqG6r+7xO3TOOjeMapG3ttXeDIyWuHYuiL6kcWfRBSu2ShLCzt12S64cBK3xsvg60wjl+m6rvIr9UT/pHn/wt+8jZKrDI5vpmnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733536134; c=relaxed/simple;
	bh=Zdgltk7uwxlen0gUVYovPYuPpMIbCIGOYcQyUhX0JNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ii1cUmeRkmsmcP4WiA7ysc8En3rv8Fs1jp0xtZn7Cn0g4cB4grrvHA1F6yWjFpxQX/8CrcTSs5qSuJYtBZXd5M2Ft2QHD81dulzxh+qPJqRQb6t1Xzrr1KDUyx7/h+iTgBIxk5+RrhQodJ5EF+JQbyOEwtkj72SQUiw6eQsQfvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=AZqu2yn1; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="AZqu2yn1"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-434e406a547so3452355e9.3
        for <patches@lists.linux.dev>; Fri, 06 Dec 2024 17:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1733536131; x=1734140931; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RrYd70wAC5ZjUR7n6BKKE+G4uykE0J77QcJcQjSXc78=;
        b=AZqu2yn1UF0eziyYW+7WHjmCo6aQgwXCIXSKlGOKguh7Nrmxye9SGnprSeqC7jf4rW
         QVMN/Y47YCih+qKptb8nBwjyfgMp3i4937TfkBS4Lsj4+OFdeDkVPdQAxVRuiLBaV2UM
         TOXLaZjYg+YVLL1gZYynh80OmqkR12Krj5+YRkaNFZYwlHcrEbmMbWs2Nv1EtiIJlnQR
         OO1aLvavq2VE7Eoq6TlgRxtbubYcMqaWEfwqWrBIX3hxv0FYySa4k4W8vPZxo4f6TJBL
         fdJRycI7nFqHJ25xn9hCOv2hlUF1yESxqUAPfd+pBOqa0cvuDoMq0Jhxy2e28NrRRSki
         rQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733536131; x=1734140931;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RrYd70wAC5ZjUR7n6BKKE+G4uykE0J77QcJcQjSXc78=;
        b=et2jMSBe/aC/ntnDkHleU5lwakLi6tf+sc/TLfxCjnyjcKOLguizNTns/on1ENz7m5
         uU48PUV7JjpaEd2WdnlfK3qDp1XfANhh/H3orCQNsrZIDfmg9zdAyDbrCRFpqHv558uX
         ciT0hsJbwfcsyNDwdDgz6wSR8cwcNPj1zKvM68/WlIg0H37+5FDNcRTVZZR0pvuWC2H7
         drDA22sz0c1VHzauC43fQcIzlcPORtIvEaWCnLzcuNMICZRMm2ToiJ4dv/wJEsP8pEB5
         kMpghqKmmr0Gc7M+vhVS0jNenZSJP6J54lpjyWRb6uoN8dbLQwzDMBHp5L32Rm0Y4Yon
         FVFg==
X-Gm-Message-State: AOJu0YxaoOZEdK4GRTj+GFWUz3eDVq+kWgX0AaST52gNU9GpVWIM1PQu
	0IXRKvRcAvRPUHHcnfG52neGs+Lx+Qt0NTyqNxkDhdljMbtwYcQ=
X-Gm-Gg: ASbGncuRE88EGBrW1yvbJvxZX/VNviNxt84ogZ1Ar53OjkoZ8V5bJ2Gp+XYcwTFi35t
	4jQTDrh6M37AU18dtFLBjF9ikvc49eVwzl8vwEDJ7gEd8shvjRqEvjl1hNfarxLXjE9IX/3fyH1
	HQaymfDF+AA/nra5XwoHpQlZWDd2xZyrr0Vdqt8B7L+/pF0l3YZYMl/6MjMv/LS8m8o56hM/xgy
	qECDMMFFUdtEIN/pMS5+GUas6CoavIUHNifq7i8FOeLI2kE+hTIlWm2RMqFd8sLrvbZhlbkgZ/u
	Dc/nWfS+Gh6oviMxcWTkFGJSNg==
X-Google-Smtp-Source: AGHT+IE1PrZQ4PmshzLfEKIIicbjlO0LbAc+K/ecNBX5W2XRaACydj32Q+1A32LEF4rZz9SjX0FBpg==
X-Received: by 2002:a05:600c:a41:b0:434:9e1d:7629 with SMTP id 5b1f17b1804b1-434ddedbb2cmr36793995e9.33.1733536130940;
        Fri, 06 Dec 2024 17:48:50 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4e5c.dip0.t-ipconnect.de. [91.43.78.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434da0d26b0sm74258645e9.9.2024.12.06.17.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 17:48:50 -0800 (PST)
Message-ID: <1e3cbdcf-ca6c-4721-bd18-d064827107b1@googlemail.com>
Date: Sat, 7 Dec 2024 02:48:49 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241206143653.344873888@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.12.2024 um 15:26 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
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
