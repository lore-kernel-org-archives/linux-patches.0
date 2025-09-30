Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243D2288C89
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 21:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759266640; cv=none; b=Zt66B7OtYVTKR+97+AqLQRmnkJpHbrcfW71BwgdFkJsGumu5/lHPP1EfQypH0P3A5Ndi27ZM+xa7j3xgsIkVgO4wiv1cZxrj3O6U/vfgLIL+VIjSD+/xD/n6BEpNSLWjYdJe6lVFwm4LWdRIMcGfw1nu8p26xE9NvNOtYA2f8/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759266640; c=relaxed/simple;
	bh=IY/T5MW0cQ6hRm9986aMUWP4hxXi0edg7BRspaUZmxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WHoIHG9DUbjZwO+4Bb1wqIUgj7LRMtZbiDmc+3HXyTmuFglc56qjLvGdwuQBMDSCA8tNPYtZo/3eTcvl3lBs3CRzLM9rLII/JqkRfAeYKo7aw+IsXVtgtqEHPyVzdf0cQ8aanX75cPaPQ35YvKa3GfPaK4F+NGNIn8HdS9nGeTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=af5Lcwiw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="af5Lcwiw"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e47cca387so45809985e9.3
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 14:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759266637; x=1759871437; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bHb1TeK0SDtTGD/hGQdOAwIIPezVefzkx8O/f8zdLfw=;
        b=af5LcwiweuPDhYLbDM59zciq6LNDmf9x0Uhki4wKNFuBnX60ntiV36gAww2ZV6kX1+
         NVfE0eabRFDF3aN+kXyGUw4+mZDOdDvLaZ4FuSNWLZPQm1qZjB463rcmaMB1EI73spBx
         cO9MBOuxtAXkEGfRN53vsiZbhleZRutiWUcrJTrzgBKh8NCbcPxT9VGsIU0NK3D9hvxB
         BgHPBCWFTxDDgBiOfxhms0A/dyZsFXXfXxi4XcAZWwAQpUcW1gXcwUmaJeSlW6lyKud2
         ulIO2LW+JymThB6WbJ+E5oSrCGu5sGrfBPbQ6esmkx+plBeb+P3o5QKUEL/PlUzcdM32
         3myA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759266637; x=1759871437;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bHb1TeK0SDtTGD/hGQdOAwIIPezVefzkx8O/f8zdLfw=;
        b=SwfpGFObCi/2L7qjnT78jnqSlOXeui2x/oYaTxYIhdj08k2Q2/1R2+f1452h4QhXnB
         56jKzm4Aiscrpuy2RCEuGfF88mkjieBLVlopuAJRaUxeTsvWSAe5YEnPRIjeJAsYLHcE
         0C11ahvN5fbLcfsKxo11t+ngPZnb6lZY3cyAsXfojDnQVib8tY3SNZksRliXP/MGDR+X
         PRVzR0zA0+7b5/i2ib4bWTVm6OhfK84zEp0uz+a2EL47toZ/Txd8P6rRaIqDJprvinri
         dwRyKUMTT5KnMykUStNW1pev4Yx8KRNwxO1bH8IdsCGwYAgsD02UMRGHWBjfCVa8lU+9
         WBWQ==
X-Gm-Message-State: AOJu0YwORRLmP87ZY8ngJuGXOSLSJQjGUC6MpRd+MzD2/t+Du2b+pAcx
	hHGW2cRD2NGecI5DEK2GmEDlx0iSl9OrgYnbDGBwB12RaGytrBky+xQ=
X-Gm-Gg: ASbGncu+o3pyssx9Ia/mxzaA/XZrj6H/F6+/XDRukVCCpzSdbcAPA5phJIOOvM4S4hA
	sFWtB0WD2tBxmO8QE3LxlC3Pc/NBQs4sykv3YniHWg0LujB2k8n+10Wy0ACp5316swqjvTXQIN8
	6zB2qYVfADojycFNwxdPqKMKjL+fi0qLAKJH4sLzWkMXPp/89izn/mpI4pr6DosfOX1YzV2S6bO
	HCYUSR+3PKq3LmyYoypuPPdyjAppxH1QRAv9evKiuG568C+IayLYDbZAQOLboi+tRGPLugA+Zj4
	XmJKs9hchK//IQW9DxUohRZvghHaaZGPUzPSEaqk+Q1Zc+HN/cLVV+YQ9cgJZcy7k58PQB1Wlew
	R16j5AJf11otKQOHpOMXcVDcjjNaduHq8kUL9M+8g6ZjsLTro6SvTZnFwTLMW7d5Ep8X68vfsep
	Xa7p3bSdOJZLfqua9FrQ3dsQc=
X-Google-Smtp-Source: AGHT+IEtRCdZtfm6bV+C3kHsNpx319GbRTyLtQCVbRdZ4EJBOZT09wV8Fky23E8en9rieAf9Q7cbwg==
X-Received: by 2002:a5d:584a:0:b0:402:4142:c7a7 with SMTP id ffacd0b85a97d-425577f325amr883446f8f.16.1759266637039;
        Tue, 30 Sep 2025 14:10:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4965.dip0.t-ipconnect.de. [91.43.73.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5c3eca22sm21222835e9.4.2025.09.30.14.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 14:10:36 -0700 (PDT)
Message-ID: <4e557716-474d-4aa9-96f3-9bf154781582@googlemail.com>
Date: Tue, 30 Sep 2025 23:10:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143831.236060637@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2025 um 16:45 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
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
