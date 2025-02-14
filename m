Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9942CCC5
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 03:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739505171; cv=none; b=k4jHKP77XSa7GGEMeI2VnWEtqmE3Tsm8iWJZbq3gbXl8BAjNFq+cQHKCqGSr87XqL7OgHLCXdfrbLiIedkUXLcHqr6QbcVQRO/Jsq+ZYpEJi9KpCNaFRX6Zurn69ep8No23PvugkaL+CkS4bl+b3LTaw7iG3Jc/ubq6F5kpL60E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739505171; c=relaxed/simple;
	bh=Rs2j6gfwxMYn37DhzP1+0JgF/bStoQ+oF9AGaTTN5Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E2HKveK1srmV3tMfiqJiBbN0fqeR2a33Oh9Sui4ypuugfdEy6+R5CHYQqFS699YS1Q4NMOSvqklgcjsoRFGioDFF01UjhhAY5whjyk/nsGlDeWdR3MCIgOGj6OOcBRZZZNkTX1qE2xJI9OSmtv1d8Yg8J2qDG/9iDc0HL0uxVeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=m0dAAx2G; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="m0dAAx2G"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43690d4605dso10276255e9.0
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 19:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739505168; x=1740109968; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cGTgsvQRtLrU16wvAkbEa6kMfXqNaErqcnGKNV8MsW8=;
        b=m0dAAx2GdS9TpwyQUmY0pNxnh0mxzX2b/k4WpH5CiRHp89uQBXOrxiG/u3WwG0R0aB
         sUQtfCXNuHKxDjFoT5Cx/MUqQtgTI6t7mGM86fwQuL03QJ58MWtinlHcjjRK/vsP/IPt
         /HAyuOXPDK7TVXVNGxh1PQ+6xInJJ+YCemCBKMKrL0u9hO1MFvmjRClXJNL01WCxS0qv
         ps5EyulQCnXey2QTJC+LvYFXXt6y3COKxzEszPHM0n4wHFif6fZAfP79dc5w+S47yCr2
         zr48LroMLEddHutQRzyBacfmYSwmqg9M1zY40v3xmjvPRp2mUWVG77cQQkPKzpWQLPMn
         DSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739505168; x=1740109968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cGTgsvQRtLrU16wvAkbEa6kMfXqNaErqcnGKNV8MsW8=;
        b=mnBS2iceAgKfamoX9iCJUekbe8cYBMCCXdWAgXd6cfKxXuz0yXf7bI3MeD1vIHg7pB
         B5/9mYPdO+qQGvzD8udvyTpSYRRrsM1kNZRIvF3sPfB3p14p4a2/WxLXRzQf+moqOkBZ
         fbCezFsOPvtWKl/hkSp9C/PsPKoLNhDqlSaWHyp8pOL7j65TdkQJUCSE3hi5BEy/wP93
         k+3TuuQd2yzeDquDqxtKsXRgxrcd1D3K5zMp6dhJGJ8z4qo+5ppEPUsgdLyW3e0dQ2Qa
         GBRQ3er7K5nTPbtTwp/uvjyXWLoJDoVl8CahDxH5+GAw95gl/oZTy4NFim0J0mRN5+S4
         xltg==
X-Gm-Message-State: AOJu0YzmbVd/pVBtAmNxZ1POVKzIJrDb4XnLKLqi5U8uF556HjP9adJc
	zz+UI4GeB4ENHKNKzrpXMClQ+mOUiOkaljKjPzNBLv7U/VgUqss=
X-Gm-Gg: ASbGnctIrSK3NALhlV9OE3fXMXukhWRHQMvlSZVZoJ/8zTI9YEVIVuQD1d2YyLL2qmV
	1mr5vhqP/ACKDBbwBmORDynXyeLbQyaiMCvAptOz9FTmO8KgfD2cv0KcEvgElnmx1mrw33kgpi6
	sh/vwgrW3Yw/+61ZttyAWFco9nH9Z3HDUpJUuNK+48YwL2/41GAA+eLSzGgIfcMOSEL2Hy76z4e
	0rxJMeIm8YeuPJYotjAnzziqAgZejux6GWn6xeTds01K55WKGnKTxWNb57TAgOg29K9ElJXJppD
	/ANHDGSiqZfjLKibg2sAZFz5UT3hRit+tq/MFvvh1Cxp2b6ko9hye4dUABHn7NOouaI+
X-Google-Smtp-Source: AGHT+IHnuZCZZN3hYCYtZNp8eBMnru/Soke5PXNSGlagpibSv/+mbMRJgyuZcAKim0m1e8spt/YyVQ==
X-Received: by 2002:adf:e752:0:b0:38e:53e7:da50 with SMTP id ffacd0b85a97d-38f244e9028mr5242524f8f.30.1739505168074;
        Thu, 13 Feb 2025 19:52:48 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4779.dip0.t-ipconnect.de. [91.43.71.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b4118sm3582837f8f.18.2025.02.13.19.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 19:52:46 -0800 (PST)
Message-ID: <85123df4-8339-455e-87aa-65570d39dab5@googlemail.com>
Date: Fri, 14 Feb 2025 04:52:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142440.609878115@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2025 um 15:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
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
