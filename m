Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C09944C659
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 22:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790807746; cv=none; b=PnUaBizXjyDzsPu3cpSNKsR+UkvgRiHTzT/Q9ssiiMMizDAea4jGZl4iwEpQJliHxjGQfNsAMQ7Ol5z8tiVyTJuW5/VGiyzMekdmoqG/f5Hzww7lAx/wYkAC6iIue/EmoEpS0PNQeNepDpD3a/0hMellM3pbXYAa9Vaa9H3zN6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790807746; c=relaxed/simple;
	bh=PPJ7XphEkFX2PI2orleZwG4vWcNUErLobmFaNusq4+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GigNQwemUu2zQc5qUV9tmJU4nJIkRSA6aY9xMi+QO9yemxtNsCiQbaENBT0boVyrRaR9NoAkvjgjc7Lw9UmONAe1jtagxc35gpMs4P6w+DdmJ662LzShg6P/B/Pq52X4nBUmWAfp4PIZsInQ/VyNO3CbMkr/DgH5XkEMGJ8ba9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gVkVvSHs; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gVkVvSHs"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912df756so45127975e9.3
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 15:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1790807741; x=1791412541; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DFv+6x6IaH2fd0p/1qIAFYVajO1+EzROb2Ys9uN8Cp4=;
        b=gVkVvSHs7hJ64p8p3rXnvgLI1fIUWI/4o8gK6WSisZOfo+KRi+MJGfmhuHVXM2+u0F
         1FkexiiojGdgQXj8lyJJIjnlKP29LvpqRW8sWL9lTugTEF5KehY3DcLcWzpaDV9NyVjN
         yYzMM7WiRUWjtChXA7mL65KEvnNiYLoypBkbyR7LfCVj8g8tKKyd1DAOeLYs9uvJ3DGJ
         alZVAjSz4d8GPBte9nhXt2gWcL9QjOOU5o2w71LThcrn3Vwh7kickmZuqCg3/y3kDmND
         mAp6dQQUCXelGUHbReoDLdJbAu3pkSbcH+17evFjAVI1Em7uT9/ekqnhHMnprhNRAx41
         QEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790807741; x=1791412541;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DFv+6x6IaH2fd0p/1qIAFYVajO1+EzROb2Ys9uN8Cp4=;
        b=m58Q5db4I3e7mlE4zr68wdMqClOZ05o5U7vl9TLEEazGfd+rzwLqstYJerkDt3uKBC
         MjRRlIiAHo8tPSgZHQ9+/Xp3UnwZEQ3/h6CKj83btEt8TsJkA+ruHOCrI/qNt9NQkSSW
         BKyTpn/AFaNVwmOy9OUXFW3TQEpnuyUoo7jybBh62ZX94D6l0wcbG+kbXrCb/erab27H
         LL470UtCiMPOLXXPVUWvyCguxqI9VPvdnoCSQTdHkiX4ieB9XNcYv3Wl6F5LkZ2poyBq
         IQjQ68wngGuox7NDVJcN01PJT4Ab1gqn08EkSyIaWuTXF/6wmVl5FukxNnMRWUAT5hkE
         UiOw==
X-Gm-Message-State: AFuF++k3XPkfPHVZAlxdAd9/M2IjKLimGiZtod3wallQE2XdwP0MXnIR
	4hAMyOQt04MetWcbR+KmJ5jatmMHjZC/9SIewlH5uaMtt5GVOHjMWKA5GVXI
X-Gm-Gg: AYBFou0tG9E9QgVonaJ6dJpVRZIMrUrLSAmczR9YpKBlSVDM/XgLs4hOScK9gr0P/qu
	2L9is7rA2fB/LTJR09Zy4jti1lVCINg6nCHxat0lbjYM93WGDV4t2+JENkhwuTYzZSqM7WzSBxS
	ekCf1ScOhz2gY9YE73A/T6toE+oGQfAQToKVCkyLJ0PvwBpar6aEWHsI1TbokiogjTdt2cBJNyv
	7z/f2r0GPwxaESfKfZWOUWkPC+n2NT7+jmfo3HeOTXukYhmPo6KpTKQNNcJIGOyaHNNEMrYGiI3
	p1nEbJz/hFz4/MAeyGD+KobnEVT4Y0FPtlso7t08C9I/vZvPK7uwLh0k/oU/4Odg5v4EBLPHxTm
	sFZNGrGd0KcYKImoTWPSupCZxm5UfhdRONrTj8n8q1yDePlvRd2RVtFrN5Inj3GiTFvVeVtjjdt
	kCT7o0dZqyM39lU52g3l/oFh4ncem55k+P+fFhN92jDDRigCdtv/YRtKN65tGM9AA9UpFmH4D6W
	L4R60OZCubAblNiNX6OnHOsv4L3ZrL9tQJYvB9ds973kdnJMaY=
X-Received: by 2002:a05:600c:a02:b0:4a0:1efa:c748 with SMTP id 5b1f17b1804b1-4a01efad866mr11709295e9.15.1790807741334;
        Wed, 30 Sep 2026 15:35:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b057568.dip0.t-ipconnect.de. [91.5.117.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f938f89sm14345795e9.9.2026.09.30.15.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 15:35:41 -0700 (PDT)
Message-ID: <8e66c4ee-a0d8-46c2-a59c-58bbba91fd2b@googlemail.com>
Date: Thu, 1 Oct 2026 00:35:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/877] 6.12.112-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152414.738996857@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2026 um 17:15 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.112 release.
> There are 877 patches in this series, all will be posted as a response
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
