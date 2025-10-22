Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A27280318
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 10:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761128625; cv=none; b=MmfntLuz/rT1jF1HYHEFVaTYWur6d1ESYQmWnvRTeUUaynGWXZ/0sMDVkK3e28Vci0gZ8AiKKHdIXN3C3EHdEYsLLN8Ft8EwtuhIU4CPsrTtrfMTIhBzu+ypDgvbWX+DjxvdMz4XyPqaariHPSQqx4S+G2Z6e0mk9FKW8NlPmiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761128625; c=relaxed/simple;
	bh=YMRyZre+kBbFoPiHrqjDWIN+c5UsSggZobEPZ5cklR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lG9EDnoaA27Pj+KYwyANp6na6PGpacYOSuncpQI2VKf0SPED4LONGWKPeocScI1TQgSNySc7pKMIHTwjuAYFsGGCdxI6Gq8x62OrI4EqVENoYX0Pq5MWbcWZKjMdtuUtPRl428z3Fjv0K5OaPhUcmMQYYsPtbsns+79z2aNsGo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=MRYmpfoT; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="MRYmpfoT"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42420c7de22so3171965f8f.1
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 03:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761128622; x=1761733422; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=14Z/Egm0ib+pyI7E20I7AQcOKcoL8J1lei7NXkr+nVY=;
        b=MRYmpfoTb5rAdMhRE/Ku8yLHUhbgOKiMpOaIJLAz5VhZLz6QsR6HXq+6nRXT4RjiT2
         ymoh0IZ/trTyw641mDRvW2VE2uhm1fQU1ATqipDQIQpwk4BpE+WSgG+IemSXEXFxb5WO
         TErDCj7P5Lg6F+AH6DIQGxHo7YiKOCUw+AUFnrv6C8WXEoTE3d1QNwCImxY4W9dkf2Ya
         mvNgyCCfMOpvCz+nuBKXn9SJ71moNfIZ02sV7D3yKbSK8xWpw40wsMdq5VABtRtzcupw
         29+PTBm5vUyxHc8KswWInc/3VwRZDG76KepSK/FRgowVp94LIn77cmUtvCdNwR2stJwz
         g73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761128622; x=1761733422;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=14Z/Egm0ib+pyI7E20I7AQcOKcoL8J1lei7NXkr+nVY=;
        b=GrSxisRlQGow6/Yzdy9fSFNuyotaCkQcGZ3wpLGGAjw/cwGBaalIQHcxOWXxWGnxMF
         5TX5cfttNGzOfY4bFVnhT4zx2SoIgrsf8Em2RTlQFBiFet5qyVijy7SbY6yyZ/PhgRbJ
         waz7YR0vZfG5xelFA7spFEYldqDlr26Knhfir1lyBpjvH3N+3jvaLkQ2E09ir+KTPfhD
         DXGQm0UgCbs+HUv9T9wWYzq5u2jdAxiRQBnmZO5D7cWr9BrRICRP0K7QbHp1ncmX+3GL
         rVovxSWM2iotjrsHE4ThmJLPKYJ4GPtgwDKrNeiB46QkCUlYpb+SwLZRkrErI70v6yRb
         op5g==
X-Gm-Message-State: AOJu0Yz0e08DaBRGkXs5iVSodGZ7/WyCppOiZGhUJYIPno5F8NtQhLcR
	DWzO7Uzc/FRbP663jfQn2ZcGM7XeAftDezyYqSets42rWJj7jOSvhtxcovcZ
X-Gm-Gg: ASbGncvwE/UJd0JSEvnmlyavtmHgJoIweikf9ufWoOSRD/7VgcdHawZm9zlGQMnopu/
	kJNQMYlGDtcd3YoiMW/yyaCJ24BT1MXKjKtEr4IbELdfOaXrumAzTndTBhCe/V9QOdRogCtBUEp
	dpJZAMs9m/z6cmeb2G+g5iJJMKBg/gCoYY+PRJRyFTjim/Sl29Huba/hGraBcaTfy6L89mlj9oh
	oravNE6pyVr6tobOo8+AM4P+QqNmsHD6pWxYG9GgGkIQYErAjI2PZ66JHdpA0zRDfJbajENFHiT
	222n30HaEl1Xrlqsoly8CbJkN96gc5C9MbSqaNfhJCxGY1ILiLSrQzqr5jKfl7x6pzoPujVpKfm
	7DnKAEpR6e9lHlK3nlZxC9250oRv0K+2wWZ9iKAyf55Otl7jtuM747iWrYnZJ8R7y3yjYISsgJA
	N/YWuS+o3NTr8ECpeOClU2QY2Kk/mJRaq/xN3vxhMx1sjkM1Is4dQ=
X-Google-Smtp-Source: AGHT+IHC3YeUejmKrYXNkUxhYAL7YEasRTosBZae2wnCLum1tuqcSZ/3cUYt2n/DhFVyS/dLVqcNaA==
X-Received: by 2002:a5d:5c89:0:b0:427:241:cb86 with SMTP id ffacd0b85a97d-42704d1461bmr10607226f8f.7.1761128622241;
        Wed, 22 Oct 2025 03:23:42 -0700 (PDT)
Received: from [192.168.1.3] (p5b057850.dip0.t-ipconnect.de. [91.5.120.80])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42855c2fb92sm2193439f8f.46.2025.10.22.03.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 03:23:41 -0700 (PDT)
Message-ID: <36369902-7be0-4517-833b-71a69ed870c1@googlemail.com>
Date: Wed, 22 Oct 2025 12:23:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251022060141.370358070@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.10.2025 um 10:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No more screen problems, no dmesg oddities or 
regressions found.

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
