Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4767E58D
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115598; cv=none; b=IyS9onQoOyeJkmaS3/R7AmeadAjSu3ZT9kirQ2xgi2YIvNvnckegfufR0Ym350BqCV8Inq3QhdHmwcVIcBHE50nPJYTM/jmVoB5468VVVBQtJBWXzMTCPrmX9RPQaFDKOzf86IkjIQD0d69taVAEb+VzFknJjR8rBHs5ImZltKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115598; c=relaxed/simple;
	bh=6X91lMekL01ZmVivh+brw0rHJYy4siRC8QtoCXyWn8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qD2up0Z5NHw+tmn2UEhRpUiq9MNMBpjxJxU2xgh0IwMvTKFTt8pTCgN/OqdeEcSO3Tz13Uv9UOPRohnhMiLtaEiVQb+NrVfkRsIlZPO+Av3YkvdgdBlvQIso2943LB82covmmVLzb86d/aEU3rVVtUHskuh/aD/UqWVfLm6ClmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=is1sOiwM; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="is1sOiwM"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-466f6d4b6d3so1303683137.3
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 08:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706115596; x=1706720396; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=baC3tSGKJf5L9BsT2VeHElLsHskdvqnXXlzRQDL99Ik=;
        b=is1sOiwMpPNMiIAzuI7fS6LzjV87PQwFBymrYhRtPGVHvwFfx7L8kcX6h+ovd0JAMc
         cJ81ZStIwJnkbex0nV9zNkh9XaYuuZDRCDyV5kf41v50TeYeaS4/IxtTVbxgev0y/gdv
         Z/cKlnNAtWn2D8Q6pmQuS5WBKOsuaa0RijuNh9Z6g/XKyW7RFatvFq/uvgQFgHntYMDv
         bf5MV+gIhoTpH17l5CYFPXjShxAhcg5ba4zNm5zuN9ZQopBybDAsbxFhb+H5sfqdfQhw
         wXENAAQ/c8t7d860EdgHcBy6Wk7sVtHPWPZasGRDf681XOpFOtWmzEVxkBFTCpzgzA7q
         0FGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706115596; x=1706720396;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=baC3tSGKJf5L9BsT2VeHElLsHskdvqnXXlzRQDL99Ik=;
        b=iNM953Kt34is7ZJvK+1j0AzZ4TFZb75JZV/mvzd3RpgQpY9e23Gbzgu4Oo4Ic8ML7e
         7dmSBxr/O/2ECL4NrgYIxwYdduslM8rKJIdMpRAwctYoi0GyTuwkRgFDdV00vzNHIMQi
         ccvxtVUFCMRnnOPPENroQfDgDyXMZBnzffu95pMr9c/BY23t7o4H/LMLZWfhvVjnyg31
         19B8fIyWMbnPez4iTomImhh0BkOGcJG2bz0zzxFJ1qOa9shzpgSpxUqjoq+15pFFVGW2
         tQM7DPNQy5AI0aIs0WdTdI4tkJYtLv3N8brv3bJopub1MrH7GMKNbOPTJX7RFeYAhS2m
         CpQg==
X-Gm-Message-State: AOJu0Ywva92/yub32FSu5swkx0lbwPMn/7UWac8qZhl9SGI8ERPnitEZ
	7GJsgKoajBZ5WVOEmzyUQOG8sGpeeXIj8C2VYaKiSeAPtgSw7G5nm3VNTwkXrFJVPukqeatLZZ3
	07aYIGYcMXg08E9WsDVLBYIT8Fu8=
X-Google-Smtp-Source: AGHT+IHHHg6o4mu6bj9LdU87AIAY7nHHo5ilf8npZvOACFjk+qIgHBs3ZbULRshNxsy6GcbyDklWarcJOMR57UiP0Is=
X-Received: by 2002:a05:6102:2263:b0:468:1cc5:ed88 with SMTP id
 v3-20020a056102226300b004681cc5ed88mr2777853vsd.23.1706115595872; Wed, 24 Jan
 2024 08:59:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240123174510.372863442@linuxfoundation.org>
In-Reply-To: <20240123174510.372863442@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 24 Jan 2024 08:59:44 -0800
Message-ID: <CAOMdWSLOLKUA3dnmS5HJ5Z28DcmrFJYqpDKVsNW0MAbis4_j8Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/414] 6.1.75-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.75 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.75-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
