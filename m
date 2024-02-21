Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228641841
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 00:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708476395; cv=none; b=Vp78WwlFJWxCJslvcPovznzwCzO09R6lDQgkxxoaHe9ff3P3mLRCRhq6DRsaLJdOTBQbQzfgdFhy5uyC9KpAQMCcb2HT1rCYD8yO+23VqlSD87OGh8VwuqpQqFyZQUUemk1xVxpE503mE6QxU+GAUlYAQzx4Ub/2i6Kt1tABMXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708476395; c=relaxed/simple;
	bh=rAvVro5JsMZ91WyT3WtUfDUvwGaJ6SlbknAv/TnNdZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K/K2hN5dOHJme/qV6qr2QGouScPe+cL1vdHmeXOrPIPdPYMPxzgrpF6osxUjCoJcuvBHFf0DgF3yFQDHxsbT9Kyy8oOJZbdPxrgs7MxMFedsfei6sLSWq5oJi9uEQbXHOMfjw8wfhnphGmNULjvA9lqhZFC+7q9lLMSJimCeF0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U1u4+QQx; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1u4+QQx"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7ce4512d308so3004812241.1
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 16:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708476393; x=1709081193; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pfa5AR7B3B2CvlFBekLtRqUu/kV/9aQmL+KzDlU1BuQ=;
        b=U1u4+QQxfOe6QooqZ7MotN26Ul8TOLhkMehuF+HLDobEuM3MwauT9KOLgqv+FcsZLH
         eMQPykEaATYKRwhYNsq4HJNdZi1RsDoxZi6r2aKP9Zel1H0GOcX98ZMw1qtnQO91gfPK
         yxQmmYy5B1BRdr4wEhNQQswbttrv42qag2zMBU2ZnT6SxKFLCEfk0UpQ731rm0cwsOMO
         FYc1HBDnTIrrNqEE2TLDEswPflrnvRpQI859hHRczLLJlRQXYci9jm7YeCcZSt3JRH88
         sMmpnLPvLsZTU3RyFnMy7vXtD56jE1vVDccb4+SFHsBK9EogBt7tiJzO1pxIb8nn88v6
         ST/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708476393; x=1709081193;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfa5AR7B3B2CvlFBekLtRqUu/kV/9aQmL+KzDlU1BuQ=;
        b=cV2zHfsfL3HgjugZctdRaZ0VGhSJFlb/M7ZpBwazYRBv07Is/UjbMl598yjV9YJXG+
         ngX9B7V/3fAEnHqXlY1coA+CGydGOIl8Hl0fv4DbxH4Tg/QqkR5pJqigH9yGc3BQA9qO
         N3pDwlWhBXCwHwHkXcdh8QxLmbY7oxgaIRl8Usz6qVngyPp0pFIzP/tlio2jyeOLCFUS
         p1TzuJxg0Mv03LJP+mIf13JpaHopCgEGaDBkPYTYGw80w2gO2G9ITAm11ZuWJo80f3M+
         +PbIZU0WKdm+xvPX0vDIDzieya+Y7SG+5Ubj1PdS/DgfqGfxZR3yvSU18JCyj7crANE7
         +bEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIDfyNyx6CW36U74HaAXXzN0AxUr5PATNx7STGVyK8eAakIrm/VfA5IpgW2lPF+fKiHwssAGoWWFxOa2LJP18lHDNqV/JOew==
X-Gm-Message-State: AOJu0Yw0YH50qvotus65Lm8ZNrSsNIiEEtIBUyHnQfL3qQ7QKjaFDQ5X
	uuMNNO1H0oLtzje2vIwsoZjMcggcbW4lvTpQAzc5IvBC7rksyu53jusVahEYXvhvwGzkEiNDPg/
	k141DmBVdwpg2UmCpDh8Ya+wMoRc=
X-Google-Smtp-Source: AGHT+IHqZeH3EY6RorUxqti0OnzPLHCax1fAAM/LQXLJOSYcBhDW2pPBbFHwT8ZpYvzFUfHdO2ahDdhMMi1Mnl11/9w=
X-Received: by 2002:a05:6102:12d6:b0:470:5ce1:cee7 with SMTP id
 jd22-20020a05610212d600b004705ce1cee7mr4872679vsb.14.1708476393060; Tue, 20
 Feb 2024 16:46:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220205633.096363225@linuxfoundation.org>
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 20 Feb 2024 16:46:21 -0800
Message-ID: <CAOMdWSKTfrKgwN=iLWZV3rtXkgbDvdq3-Nv9LO3qS4WkjG-W6w@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/309] 6.7.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.6 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 Feb 2024 20:55:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
