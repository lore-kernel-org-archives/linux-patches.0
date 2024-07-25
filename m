Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867967172F
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 20:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721941032; cv=none; b=qOjZwLxCYgnqbmD/CKC8+rWi5/b1rluWSWlxFB2CWQRk60sxFTE3uQBlTqx/EFywfYDF+T729WLTu2qibbw7NMeukXH38zr+pvFGFIJuxnP7yt4YmHazOqyLzGGnfzTI78VA79NbHf+AXlnn133iOdqVYQYvMPDFfwpf9De4LDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721941032; c=relaxed/simple;
	bh=reOOWCtPXHtudVyvhtpVFQaCkI0eAVibR2zDwbghal8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cIK1VPWOydDR/N1AePruu3vznSVveh+7O4z/O6NiUhlEXjpSEswgYJV73+VLHY/604wUdtVlF7u6pIaFUfR+n09jhDy3TYYiD4Vb71HwhyS5BOH0X9qAqEC8oNWx5EZaEb/TUHTXRZLDJg/wsyf5ef5i+70upz6Qd/V3ixU35To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=f6Fczq0d; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="f6Fczq0d"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a7aada2358fso170198966b.0
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 13:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721941029; x=1722545829; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ITLRKgsFGJ1CBYARQ2ugrkuk06dIpFRf6Suyurskfbg=;
        b=f6Fczq0d9rGLrN2Aizc395snUGcK58hZ+LG/uGNmY2HyROMaa7+Ot0qfq+Psi6orCz
         a7DVPPFrz8q0kgGcisNX6j7Da5AJ7B8DXAdpumUbM2mDeLvtFIz42dQjmLZvssk0/iIS
         +kKqqkwNVkZ9K7+ABQK61jwjizPHiKr4xn34YU/iLkZ4Noq25shHCWqm1JThMyjK+Nvh
         kUcpqtWPgk2AaK0t79ptbbcU3apVrl1zur68ow4+vT9eSQTg5Bn3niORjBp5aE5JcTme
         UiKt8FNNBsmdrqJ2ZQvO3k6YBYTBNEWyhrZ0SzzDf6G4ezhIWcThq2Wh3MOtrjI189hC
         AgzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721941029; x=1722545829;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITLRKgsFGJ1CBYARQ2ugrkuk06dIpFRf6Suyurskfbg=;
        b=nYk5JIp840Kvc/SbsqSv0be1Of4v8MRXuxRT/PA3Q99BK4vmcPyCJ99ej078CtB8DY
         ZiQ70mz80LyYa6fyqSHCORNDDGRaJn+kBtqQq7ueNvSIH6iSTFN9SE1shH0/F1Jjj40s
         i09rzKV57dTSTNdp0Pi3CFitlu3AAJWHP0WScEOywPjrxzyqFfD5TmXFJynefLQgyeYl
         6LeItezUQvCKxaucnHFOmJRGD8Er0dDryHEk+rBzIpGAwP6SfI94wsd8rD9iBaauLzN4
         Fj8TC1yyKA6lgLzZ3ImwjhnVtsZbqL3+XrbVBu2pZ1dVpjkKH05z8HZj0TrgCkeZbe2V
         q67g==
X-Gm-Message-State: AOJu0Ywf2BR9pSkt3IP7srSq1boDfk8C0J7Aiu7dM4RgTHXEjoTyhVJk
	vcqnTWTCk/cAyfhx9uhK3HfumUtgLurPxgu8Uu4Fu1XkLokYmrM=
X-Google-Smtp-Source: AGHT+IGZYxgmpffCRJ6OnzywU/FMC/AL5aA+XJHC6Tx5WDw/6vkELco3NUcaJSTEAl8rrmgCXbdxlg==
X-Received: by 2002:a17:906:7315:b0:a7a:b561:356d with SMTP id a640c23a62f3a-a7ab561632bmr661063766b.26.1721941028724;
        Thu, 25 Jul 2024 13:57:08 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac836.dip0.t-ipconnect.de. [91.42.200.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acab4dd63sm107078366b.55.2024.07.25.13.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 13:57:08 -0700 (PDT)
Message-ID: <871137f1-d889-40e6-838b-8522575a3fab@googlemail.com>
Date: Thu, 25 Jul 2024 22:57:06 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142731.678993846@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.07.2024 um 16:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
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
