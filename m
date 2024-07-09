Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82241FA3
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 23:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720567502; cv=none; b=LwcT5MnU8Z/2GDgYk3Tuu+U6ZZOugmXIAlWnl3nZ47CmsaPAYAw/MedxVTCsCfaFOEnP5xKur9mkBDLimt7kIrwUz8bRtDa59YSdSVx1/rMT1FepqkgfdiP3KGc24EXFVTJoJ0m2eGU3Rwe3h3UXqbV6YbCviAX+4A0ulDPT8RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720567502; c=relaxed/simple;
	bh=3wd4Qol3aqeCV1nizcM27I0+dRh0M5u2+YrTk6xMtdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qC//KoNZsDlC6SLkwn/GK7RO1byYgPpmyKuQqQTAdY9fIGUbuftFVcj8G1A50WclIJziBfrSawtOpapMCzi837E52eiIclpy3NWOa6NITxQv2qFCbhckiPHTNA/fgqYyY6pmZks6+SwaY0EDerk5/5YuKnik5cUFWYFhgc8d3ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VT/LAlLg; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VT/LAlLg"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3679f806223so120309f8f.0
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 16:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720567499; x=1721172299; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sCLuNRSdxoCvw7coN+ntMs6AADRM0+szp3T9Yi7LlLo=;
        b=VT/LAlLgCEBVLsJ/5hGCtauT0yb70Y3lJkF2Dw4CBdrdEp3md5n4VWTcabfnViPwyX
         8c1d7yR3YGKEFbBzq1P6XY9w6ePIrOs1cKNefzjukjdxYqBe41kNM18kGCu5L0zZtLKJ
         GuoeMm0l4teocOZBgJ1fl7UhapDpWJRR/JEriLvIXH+m6scZ8WqW6AEsdO2aty+3w714
         9icczKVwj4Wsa1pn9BhfrBSAkI2z7Ylkwfou2cCfigXyp4/3e+/QNP+tFq/WaBeXiaqo
         LkGwWnzyLSr0+W0Md0RJpiXoNxyheuoYAolcQ6Um5lWZ11cKiWQPNsVpgsQn8IREDfLQ
         RHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720567499; x=1721172299;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sCLuNRSdxoCvw7coN+ntMs6AADRM0+szp3T9Yi7LlLo=;
        b=qvcOlB7XB0XGWsIM1LMuSXWAnmcBQXVl/DcpslEJjsF1eV93vaFY3XZXXxkU5igxdU
         UsJ7HlSp/Cnr5B/UKE0WFkJJCWeFEcZE7Qnz2ZIYRii6jSP62BoVWBPnrY5eAomb47w2
         +YkiR0Gvgli4EaFVFmQoYooKlvoImCeMrlbLaySKMCfEt5LxWUKloscsacqc8uI0mEgG
         NHv0XCVn5uAQZ3//IXnbJp3g7JnnK+TBerW+pi0d05MmuQ1lTA/FSbHoS6mTsGJewRwI
         SdWymDvQaqJc1zrb+AhV51BPD3p6wV4xVfdkE50nFnCpYHTpmlaRITmec7TMcmhOjoRn
         rYjA==
X-Gm-Message-State: AOJu0YzFbO768XwUnFlf2kk0QQzxC+zAys0FtVaZ7EgOWRckamBT0dkS
	mWzc9OW/wN/KMoC9ntuuna1gByDO98/jjT6hWcmfKyDwEgZghxY=
X-Google-Smtp-Source: AGHT+IE/yJzrOgxlV7O/VV3pkZx/COzzqyCU+Nj1pbPJYC6Ou/focaDzyDRoxJgvU7kRaumc1e/sUQ==
X-Received: by 2002:a5d:65cb:0:b0:363:b3ea:7290 with SMTP id ffacd0b85a97d-367d2b5484amr2929332f8f.20.1720567498954;
        Tue, 09 Jul 2024 16:24:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b0577f1.dip0.t-ipconnect.de. [91.5.119.241])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cde890ebsm3697113f8f.58.2024.07.09.16.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 16:24:58 -0700 (PDT)
Message-ID: <c65f79a1-f6fc-4266-b2f4-bef5fa001044@googlemail.com>
Date: Wed, 10 Jul 2024 01:24:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110708.903245467@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.07.2024 um 13:07 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
