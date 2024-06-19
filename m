Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73202433B9
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718831763; cv=none; b=Y24Kct8rCvXy+bFhM4opkPhHgl8prorobLa3ra0w4msKKv80byVA4IDUm2U/XoRWXlc40xd96SKRMVV5YMX9mfdKsWZzfvLza4HbdDJopAr+RKql0B8lrPT1w5636yyeSsZ3EEiMz0I6aIp0h22xxvPcuJ4GWivZaq+O8TQsibQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718831763; c=relaxed/simple;
	bh=C+KO6WOHrjxoga94KRP33XIx6lWs1G8zXZg+g0TEIXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f2dqrgnz/cWO6ctrhGp3yueIdP2IipI+3nXxV7sOUy44ErYUUZIxH515rgUe82TKYhG0gAFGE36AxRpvFvox8Iw9d7xbsr57tMlmSNSka198CoJDjs9++fCYuejcekESPyvn0pPaCX76uWhvmiNdACUB33yrihdeqXpLdY0nBh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OzleQX5u; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzleQX5u"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-48d7a81a594so88392137.2
        for <patches@lists.linux.dev>; Wed, 19 Jun 2024 14:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718831761; x=1719436561; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P51anmAPzV9wYSDoUqP/bhaw8/p6FKuq0IY5YhnZqM0=;
        b=OzleQX5u2JwL/n+r28oI295F5Dw/a4youG9vEK1ZGvyVWFSrSWG+gJk674GP8B5r2G
         ec7DJsg/vOdzD/SXPGA9MP6iSg+u85aOgR5Bg9ELNuP75MOEhk2VZwiPvSTpm+qbPmIA
         kkoJTJtipW3LyKcNRgPH3L+wX13CbqKhkoHFhmKRYHiemzE9rF9kT4oSR8f0eVbUMkYD
         VPBhB+aEswE3K2h8LVCrxUXEI1nwOLg582h3TkdUTk+wde9ykv0CF1aniDrUfQYHsh5Y
         WWSxnELaPQmB4llbajsBKQm877GvshfIQmBU6RHvlE3QsWeDWu4BphVHG9psdqlqORff
         aYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718831761; x=1719436561;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P51anmAPzV9wYSDoUqP/bhaw8/p6FKuq0IY5YhnZqM0=;
        b=jQrtCdHUZ6gjW228qPASAnRFwbV11AIIX0E8oa6lbqL6Ae1HoAX87fbQHAUIsVStTp
         QB6Mjd5BAjAbNCIelJ91f1NJrvVYHpyGFssDQXuzEVi76VS50x6c+CO7pNRKL5GeT2dA
         SYUWAOKIhC/UaTs1TH5AgumG6OPnzgSTq83eCrka8I3uppN4nGJifVDlLMEdFzFxwt5n
         Sz7q2ofl963aY0DZDLvsgMWrSyJWlwtHYKILOgbI7Mq9OfuRECsiH8x7fiM4NEevxp0Y
         TM0285Sz90JkBeUtIpfvyKn12ypG9aPu9bsOqs2cL2ul/uUpQXEhcXPqlUnyYTTlomy6
         PWBQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7PUE/t9dffAT61kByt6GWemUY33/3pNJUFguoI1xoWK5x+BIrFn0wfbmZbH6INQOfZwEaI8K687sVbruwo7Gr8y/oPChP7w==
X-Gm-Message-State: AOJu0YwdS7bwRnm1xLt4N2AIJUXfZyvw2Q5e+YViJxQ2nLMRpeSfg7mJ
	yjz7YYzz25NolJqJI0aq6VLuYXuZOjwlJMGqR3uXNkn62wQIAKb/myaPHI8LVAD80lhqkgCPQ/5
	d/nAXw10kYEud/S0qCzjq5LoGydhH/3fL
X-Google-Smtp-Source: AGHT+IHUYhwn5CA+as4/BnMoW/s7G1P+1RaW4HbsMU7gltMXF/rPb1W5yXJHb/MReLCjSN3zDFFboHoNMbef0Ypr9iA=
X-Received: by 2002:a05:6102:317:b0:48f:1674:f5b5 with SMTP id
 ada2fe7eead31-48f1674f725mr2932551137.18.1718831761348; Wed, 19 Jun 2024
 14:16:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619125609.836313103@linuxfoundation.org>
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 19 Jun 2024 14:15:41 -0700
Message-ID: <CAOMdWS+Vk5Mp_EWUpzZYZjXHeqFXLU_XNoyxXMyX+QboeQkq7w@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.9.6 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
