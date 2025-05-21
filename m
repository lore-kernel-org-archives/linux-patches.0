Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6741A23AF
	for <patches@lists.linux.dev>; Wed, 21 May 2025 14:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747837394; cv=none; b=bGzY4xeuFEjh5jTMi/JXMuVXhId16aJCv2BZBFAzOZXSuX+AEtQK9oeAFRiXhdGZFV+wmr2UhiQ5iXblmmJqx1U3UpZu0ryM9OhPkgbmF7pbRoZaJKthC1yisORG3xdNV3L8z2ZyZpQHjDM7Ir57fZ15v4Fw0WqlYTlQwcUHTLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747837394; c=relaxed/simple;
	bh=iHhskWt3REXPFQt3U4rsyEt/YNK9o488HeapSlwvdTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HN0m+11Qm55bsz4am2VGeYNE9Edg/YYnFw6s5xpEyo+bMk99lIdPJc5mn/2UI1k8El51jzdefgZTZwR/vDvplXh4nXFNY+/j8Tyf6ZyjwgaNGx5tn+hjrztBmRM4g9v5oyXtdASZEZ+pDggyzKcmz+Avy8fJOT9d3bYvNmClAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=HWPIIbv5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="HWPIIbv5"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so74354725e9.1
        for <patches@lists.linux.dev>; Wed, 21 May 2025 07:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747837391; x=1748442191; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hJdrh3L1t2pXOV+bbYlaC+xr2LBJsGiRXUAwh3/gxE0=;
        b=HWPIIbv5UTLuTrNWXH4TGfrkx4nzh736rjcGVvMuHxdvjuXY3SVsqs2hf1gUmkW78M
         n6d3J006ol1IuacpWrLd6/OJGksAlvvisPQlfhi5+GJs2UAI4RU8U2SItQI418EpG/fv
         HiPJA7aTXDbx5qCnd9QKfcz+IT8h1aW7A1fH2/bX8y6yEnpgu/nkGg4gP2sluvkzu7Q0
         kBvUbP+TYiUWQyF0GGpJpn5FEkaPnnOJixVVeRYJsr0GVkBZMYNIFdMyqlL4ghcvsgb7
         7vy6c4fFzsliQc65c+YspYoqQcfKpDyEGMoZMyIXvLSHDhBt9mBSXWpyou9lpbfTLwef
         WcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747837391; x=1748442191;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJdrh3L1t2pXOV+bbYlaC+xr2LBJsGiRXUAwh3/gxE0=;
        b=uEz/S/TQxf+5dhRfuA7tfmbLNLn/EfZdJrbVFe11GpAfNNc65VuMy1t2HfeMs3Chyq
         kuXqwfNGEBoV4vuBA1i26/YbACa4javQS2SVhw9o771hR9LGQhNN/onIxKAcEVnRNhR1
         wsc1CWwDk6nAU6lh9eYePyPxazUNTqQGnYra/MTnkx6Kb49SLPkPQQANdJpU5muvrYjz
         RyJWkUjyxKVN5aGHTNJ2A1VpoBZyWhogSpq979Jh6bLHcGAn5sJd2rXoeJknrjQVCgTt
         eLMUeu0OT2PT2LvO0q6Bm66YCtyl9PSRBKAq6JyAeJAezQEtiGz//UWKRNXIPmty9gNt
         fPRw==
X-Gm-Message-State: AOJu0Yx6aYVU5WDtIBFSRp5b7vj7W363FSXZLiObM94bPT4MyM/8EVHS
	FAyaWxL81qHseutCVPAkYZ36yJBYF/CKO8TUdhsBoE2QT6tkJ+0gM1E=
X-Gm-Gg: ASbGncsNgC6VTptmw265ZElLE69DcCj1C0ZBgGQUMnm4jXZAztEtcIpIUrv5A6qioyw
	2istPiZCaU66ysPrAM/sese9M6w6BUevbabO0neN9eugFsH5ByXMM/QrNViN825pA0aDEM72giT
	fdCSCY+3BiJtZ8HlFH7tl7prrTl7TBHPMSBxwizLuRVIremwxxkV0RL/dVunFyqteXuG4UKJf8j
	zQxZT1ttYgUoZ12jC9fNrBEcVWORIbEhF0dj7sCXjlveIJ55AUJyEBwDcH/7GpqFnQzL4OuVDCd
	5PJNUu+eeEPIVwi48Ok2E+avfwIBu+RbwnwKEZQvANDYWWyuvSWzaQhCHNCp2L/Vpkvi4b9XurK
	vtvws3OE3Sd3XQWcPLVyvJ2HPaKE=
X-Google-Smtp-Source: AGHT+IGtE5oKab5YMYXOizL8Nkh3l5Qve9bCmylWGg2p1Wz9sS6jb3o/Zpy/DJdRh4lj5xxkad2bCw==
X-Received: by 2002:a05:600c:6806:b0:43c:fb95:c76f with SMTP id 5b1f17b1804b1-442fd618ee7mr185274145e9.9.1747837391193;
        Wed, 21 May 2025 07:23:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac604.dip0.t-ipconnect.de. [91.42.198.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f6b297easm75430375e9.6.2025.05.21.07.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 07:23:10 -0700 (PDT)
Message-ID: <0b7de680-f624-493e-a7d8-072ebe68dce3@googlemail.com>
Date: Wed, 21 May 2025 16:23:08 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/97] 6.1.140-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125800.653047540@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.05.2025 um 15:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.140 release.
> There are 97 patches in this series, all will be posted as a response
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
