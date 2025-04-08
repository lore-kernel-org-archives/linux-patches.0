Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3E12405F5
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 19:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744139342; cv=none; b=e+6byY0tYTuyPlRDrqse7ptj354gMgwI/V3Qgnyd3omy6qNb5Q0swCs+PYDEBdKVK75MnTBQi1mdsUnfuqij8hVupr9zpMHY77uAUEIHVcTLNctsi0v730vJl+g3Mng5xby/RZ6UBs9HMgRyUJgqtnS0eprQbwh3Aiu3SWqZwQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744139342; c=relaxed/simple;
	bh=8A4acg57zaaXvB4L/di558pqfuX3mjReVzFTVKTlAzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPhDeJvhPT1h2oFBtjYzFHC9CwCTDZ6RTUy1ILHWO/Gx2C3e0okBK6xLFOKHS1ajzUmBzK7zK2AUOJXdLjWpbs0Lr2B5JPdHjDSQtNaWCfOsBOLiKKFr1aYPJUycy7KKnpsHZMtY5DdTvLUD9MWIK80tccSUJjhqjYJBp26WHZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=nfjVU2A+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nfjVU2A+"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso4390549f8f.2
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 12:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744139339; x=1744744139; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KxvEQKikAl3w73dRH9r3+dRotJi8XhMnm87jGgxr3Lw=;
        b=nfjVU2A+EcT8d4jtleXBAPJTDo+cmy99QyF1gBp4HdU4+TK+FDofdxRnCEIY+mU+HR
         1QVpr5QKXwYHWQEfxKyUs32xQfpTu1fsdfogZOKeNXTdvaK+evUSCJUpH5lW4KDGKZ+7
         0LxLhsVGwTh78p5XwjKGMKIwOq6Bf5KWFTLE74BWT5X7t5/FpMOtViqV9HU9bM/bzWpq
         tyt1rElLK0tAuT1sGF15pnSycTCWHapOs6wpcb+0x7gXiPxYI7vfpnAsMPWPY+TvkatO
         k1O2VIPnTqhMnV5TKXT3PZ+FlgTShWLVqb9VjDZHKvdgqAKqpSZ2tQaBqWp8Fn5d2XhF
         8gIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744139339; x=1744744139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KxvEQKikAl3w73dRH9r3+dRotJi8XhMnm87jGgxr3Lw=;
        b=c0Io6M9+EqgiAbe5znhdbf9MzHG2owt+eE+gbGlzvX5mJYc+bu5Qv4+kPF9KuTdCfO
         8Wka6GJKk/uBxhOVtC3klJIhoORBBoYI3wLClGYDq9SxMXZmzO6mwTSwuXZkAJCm7t7T
         R26iYfLKLqTxxhJuBGAIM4W8jefbMUuiI+ZgLQ0fUOdI8Tl3ehiaBW8NhEoc/F2RG9mt
         NuLX50sVdKhMg1LUSanoGEeJJUs2ihDdljj2Jl3PcJDg6eieOSdhXEfqgMmAda+IA5BW
         lAw68qjP0iSCPyo2L0z9lt50xxQsP+MKk0EPGP+hblaFZDLY2IbV/V9s+ROryFomtQkk
         0GSg==
X-Gm-Message-State: AOJu0Yyf2EY2uJuL5YtWXTqopmQNrFfN4SwdOXFRVydD7lz9zH9Wb8cK
	0X/FIzbbqcGavdQm05d6i+HOIrrqC/5AyVdYgqSYMzbE6lKmt90=
X-Gm-Gg: ASbGncu2+FNUAb4TF4X/d34y32H9DZI+ylXLyHqAcvx1fGQ2EBpXjd1D9HV+kvFR6+V
	o29Gzwi7W3wPevGO5EC7a+XR7lNpL4H7jYIyMXZ5Cy0uZ7Lc27VOX+39NUq7ZwL93N86pWkroK3
	GfYRR6UyF46ALFukOB858vhY6K4CrLpMxzkwN9ID23kewB7s5K9oOKbD2clbghxHKC8O1p6uw0b
	s20Hoqqp72N7yRlhNECV5N++O8tTkdsQ0+0sJW4AjQSF50DoMBMegVXL2r/RvRcckXo2W4E71BP
	2RbJidKAcTiK1KtyWMnFBnsweDnJPK1VMGW6t3o7nCJoo2n0LzqZv4D/oPiUTHEAuEQln4NI/b+
	34dnmkz2mfsezMO8NTmyKUA==
X-Google-Smtp-Source: AGHT+IGudv+3ownp5u5XRlhHUkQ0JXvgmmZ0RCo/VKmjLTeyr5vDN95Gz2ym3PFbFmPip890LIgotg==
X-Received: by 2002:a05:6000:248a:b0:39a:c9d9:84d2 with SMTP id ffacd0b85a97d-39d87cdcbccmr305984f8f.46.1744139338705;
        Tue, 08 Apr 2025 12:08:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b057de8.dip0.t-ipconnect.de. [91.5.125.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301ba17csm15856242f8f.58.2025.04.08.12.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 12:08:57 -0700 (PDT)
Message-ID: <10bc5f7d-a385-49ae-a805-becf46318fb7@googlemail.com>
Date: Tue, 8 Apr 2025 21:08:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408154144.815882523@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250408154144.815882523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2025 um 17:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 731 patches in this series, all will be posted as a response
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
