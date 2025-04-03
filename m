Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C94D224B1C
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 19:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743709992; cv=none; b=IyNhZx1/bUxPXzl4972J5ARlasH6m4nafUKoyNgnU74tAlKE/gxeZsAOEExuI6nHsRVj66RlqaG19HV6J5dMSWcO72vW1LfS1ikPUgUe/48Hg05lDviQ0zoGnpcn1nW7yfC6zlM/Kec5eS/OPCd3ZUt5nPSbemzdK7enI9OKq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743709992; c=relaxed/simple;
	bh=EqrX3cvjeRiYPY6y27M2pPrYu3nuvoLp/+5WruydRCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyTZRhWNfHpKxS7q9W2f5psBIKBU7uDIdXwk0xCm/wgh+A6kitXlYSlADgBC3ZaTibN6ZgUZLA7zpA8Bs97vgy1rKY7i90ab49aH4Sn/NO28spxgnX9TXHo95rAHs9Bt6k+0tj0xIVBmXt56R1HCuVJBilMsGUcikZSfRIMCdKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hIniMH01; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hIniMH01"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43cfebc343dso9141015e9.2
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 12:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743709988; x=1744314788; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6du6KAtTyYabq94pzb2wgfnhQXGYymn0VC+kdziS+Bk=;
        b=hIniMH01s/GV/IzDVNynCponVXBYM316GO4Au90GlmrYoFAwgsnrapfoVl15LyiIT9
         cJ6PuergJH6MMm+LHew2Lg9+mQkwsPkYmUFN34ydGZHDHAWsJAnCNoXwcsnO9RAnkyll
         2Y2z/5FuFjYR2tojPjVCtVpJFh7F9CBAQGei03N49mp/HQ/YdnG9UJ8IRwJ/1sS0nEqG
         rQ3tr1gDQBgMJ0U+T+WWuzfThqzLww4ESvEmtNngyoVrIctXlNPWCckfRyGBUuVXciWp
         pxq6u1nnmlxTv9faTDfN+5JA5gBYubzLxDckhWlV9l8PT8x+oFsyPg7bUDin5P8QlTH/
         587A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743709988; x=1744314788;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6du6KAtTyYabq94pzb2wgfnhQXGYymn0VC+kdziS+Bk=;
        b=nZchm9pQYU3t1UC6VWBtiZ7Jro0q91kJpTaPHmWoJf4SVo73EBXB+CEv42KjEuHRNp
         6nY9MBi7OO7WlT1TH8wRJrsCkMPAxxJseIIzPQtv9pabpF3eXFl99t5UZts4+zrQcCYr
         3WmV5inE51LipS6e7prcJHOoLA2h/5Itrgy1uROnd+RKeB7KmKVQP20o036q9YuNTrdp
         sle7OpQTYZlMvpGJDvw+Uye954ZtJZl2Z3peL/R5ZhVxPbBvS3WTmP0A6F6PAenVccPl
         H8ECHc24ljaMIMdro92WqNErBjDS2alc6mfxxGNwhS67Kk7l7g3VvexVk1kPi+oLvdu+
         QpDA==
X-Gm-Message-State: AOJu0Yy5htkLX0gSIUdmjlDpQEqdgZ5lbDDtrlYxWcAdFwsqe6/Lwbr2
	vgeJWLpyXVa6dBBP1Y228vqkpLSP9+VtGu1U58DlV+LCBQfrcqQ=
X-Gm-Gg: ASbGnct6ch4nEUAdw80MzByqaWiv7hfsD7PD6tj0BJ4JQnFuLkvVY3vavEa1Y3lwgu5
	kcTiRfSen4JCPHTS7dwltv/3gGk++O0htQB8/pIdq1BGamJUNND6Rz86xqMnvTT50EHKgD9V6DM
	bdWIwd8+p1ir5n35zFtyk1oswQ/oKw/dr+LoH6zMpCCpiLhPW+nt70cPoKVU2bn3cGuQtf2M1zJ
	jNVRf110DJy5NevMbABUsz32fNviYxDlnv9Dz6XVsyn5/hTxxp3RTPbhG0DBtAt9g3Y3tHhJIFB
	au4jRI5dQ6G4WBpeUNK1vp6lGGt/NAS6/JVpk/EjzG/rW60ek8hSKyfsGQMU4RUpBKbwnkZdy+X
	OK40BDuw33CzuTWm6F31rwiU=
X-Google-Smtp-Source: AGHT+IGtsE86kbuUK/yEkO0/b3rX2k2QXtMhucX+uUUKI+GteGJnqYOo/i38OP3DqvE8R3eNi180+g==
X-Received: by 2002:a05:600c:4ecc:b0:43d:2313:7b49 with SMTP id 5b1f17b1804b1-43ecf85f4d2mr3032015e9.12.1743709988208;
        Thu, 03 Apr 2025 12:53:08 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac393.dip0.t-ipconnect.de. [91.42.195.147])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec169abd7sm30040945e9.18.2025.04.03.12.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 12:53:06 -0700 (PDT)
Message-ID: <22486e30-3b38-4361-a3eb-899103ceaff3@googlemail.com>
Date: Thu, 3 Apr 2025 21:53:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151621.130541515@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.04.2025 um 17:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
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
