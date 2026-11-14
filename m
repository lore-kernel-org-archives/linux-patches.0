Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794677187;
	b=nEyqPyqfoGazv8liZAmFVvtICc8P6D6crX2PxJic9CzKj+WIeaoo25InXBgozEpAK03f
	 HiXDxn5yhoY2+NKFNRMYHrdM/bGu5sTiDdHwyEdKCkFNUWZkcESq9bhED0ZB0uan85b6f
	 9Ym6LCxUNGECfv+kE6KgnieF/hXxqbbhu71l3sgo6DM2YYWyNGl09yb+DRk45dUMmRKJx
	 fkWndqPAjqbsSfo7sWgczHkBg3glEoEvd9W3OfrTPPUh9XSguYnLmP4rttNMGS1RaBOWd
	 9gkeX61pdyKAqxmwDl9EV+MZk5ZlxoHrZjpEcX/ox8UmEN3UniPovT5sPwj8dNY9EGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794677187;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+znmWJGuLi0+VfYwsBvWce64M+CET7dyCJAEYtt+T78=;
	b=P0fylnFgqwSUPb/OUFHV28aIPvmjnQeokGtni53LJ2Ji7mEh/JU27modlcRK0qu6KPdH
	 0GXAWzRZ1Gx3GV5ukd4jyOapegei9rw/ZIbdahqqs/adSUA+1y3fvmOPYlw41rkFZM5gt
	 AUhldDCBfq05gqvKp/94ynvPyYr5+47aP8bmON0iYPcgsdDeK2lakF8NT6Coyxyc4e/oz
	 7qydQR35G0W/reDmxOOcm8vBPcEh1RxNYE+SsWuXtyKa/CPT2RCKIyBW9T49P+M3ccMb3
	 qAJXuNzxwQMXEk3nPCuKt3keyZlC74/Igi4pLjQHwoNBnb9iL7UXiJulcBx72LunGag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=E68cu0xe;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D7B606A334
	for <patches@lists.linux.dev>; Sat, 14 Nov 2026 17:26:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6D7B606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=E68cu0xe
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso6262175e9.3
        for <patches@lists.linux.dev>; Sat, 14 Nov 2026 09:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1794677185; x=1795281985; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+znmWJGuLi0+VfYwsBvWce64M+CET7dyCJAEYtt+T78=;
        b=E68cu0xecyG1DVMvs4WFvhkPF8PBnALBXjGKvoSJEglRqSjo9HFi0jdUD3Tz3GXMuo
         qxURQ/YuRXWQ2V7LudHC2ZOv5HYSKpjFiqWQv6PTcYnj1oK0gDQ5KTO3/uCsfjgyTnz9
         Ebnqyv6m0hbMtM7aCsc263pgCvWjyu0yKc3w7Onxn88Tnh5YRiJMr3sAYlo4tmsX1wjg
         T53FIVcvN1WVIKMIZmUBU0LfNrOP8qwAVpz5shX83aVRJv+VADO5RIBg9b/1VDogQJQj
         tg6B6BLG3oZ00TutN075Vg6GhL5jzmlsVnS8KsbLuPFrNUvrB/yRDJMIs2ENA54og1y8
         eNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794677185; x=1795281985;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+znmWJGuLi0+VfYwsBvWce64M+CET7dyCJAEYtt+T78=;
        b=Xm6awy2Yqr+hvZPkwfrZW6Iu0OD6TSP0n4OvJz4yH7RZSUeTTpgkGD40rjeXuGGN3J
         PS6TTwSI+gNVlJVhJ9oijDPmkqaphw2sLyTSfCO3HQlZiSexS0urGNZgkMvf34RthSWi
         Gm024pQTYJaWC4vxVGaTaW9Fe3/pAo8/xqmEqjTHzcu2toy29KK2VCpKNCNxJ8deCDyx
         Hljz6GSpvTfbHOdlfQVCeW65WdhHh2wEgk+OXDosUS7G738LF2Fay4Qzx7TK3stgo4mr
         fWwuRwlU8XdHX4hRuBWpX64JG5evbR42gZBHiSKm12Jgb3K01Qp2m5fMCEpoEZwNJDsi
         owjQ==
X-Gm-Message-State: APuU4Z/wcuMA+oFLx+FoK/oPCnrm9KW0442vEaAJouERYdkpr1DfRrc0
	132Ghia5zSUYCv+vI7pE325PRre7Pu+CJ26YKJw+7xQKKgBAkqO+dmw=
X-Gm-Gg: AYBFou1mtmVQyQ6NDBmDOZl2n+8E864PLEkUJ1zh5yXTkxOJwQ9gpRFiZLRCWd1WiEj
	WtIY0F/YTgaCARXN3duTYFpjf/M87cYarzcTpJHepnf6PlmxKn6TUq4kxJbgWqGpn5GagczF3Ao
	X+ErLOWl/CJ8V4iYqSmSvUCszfRvRighV0DI0mSRfXMpNF/pq4b4RUFpdwBqXdcM+nqRqOnf8qJ
	n7e/L6Kq+Xf+n/qvTcxq0k5ZlaZyiBz2vyauxMGXx15GyF1NRh8VGerxukbPtqQhFxJ4Pj1crj0
	wtJATLnZar/ik5jDq5a5azkvJcH7BUJygHgaF1Qbp10PZ6tR3cQDlA3/vj5anahIvoWRZhfYJ29
	ZmtuuE85ABGfkrLGJhilJ7clE7UfM/8GArzAU4is+SlkD1oOKhYCxHnCtwJ1XJfOilIybu4dbrQ
	40h2uFms1eVdgymhfHMQOd/5xYEjmJoBngj/sEJFUw7DCKRm1/DJ64ppi7pyJS+L56rfVGwD+aM
	5QqLIcDWf+HY7WhKEphUPVtqyPb2t6433WsaJViB8ommwcxTwwN3D2dg32a4QklycSNy3HNO3eY
	zXUvrjbK4Xn6xRCaxecn4a539BGgvyw/xdQvrrO6dfb4TdrWuXBboA+d85+9/bIKXcMP95iFce/
	ZKW+NtA==
X-Received: by 2002:a05:600c:a10a:b0:4a2:10f9:37ce with SMTP id 5b1f17b1804b1-4bb55a4f1d8mr90924655e9.15.1794677184998;
        Sat, 14 Nov 2026 09:26:24 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4c4.dip0.t-ipconnect.de. [91.42.196.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55ae5299sm166424125e9.11.2026.11.14.09.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 09:26:24 -0800 (PST)
Message-ID: <7fd966f7-49e3-4ab9-adb8-03ae961d0da4@googlemail.com>
Date: Sat, 14 Nov 2026 18:26:23 +0100
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
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261113153753.358973689@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.11.2026 um 16:45 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
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
