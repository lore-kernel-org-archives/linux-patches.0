Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01E1D8DF8
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 08:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729068667; cv=none; b=JBZCvOvF79lLwlDGUd4bsi7dPfs1VDkuBO7Tr6iLG/oysOT+cfjg8RRUmWNSH9K23sZXqWd/Y6JXBjzIVI2XyL15Zb150MkwDJEOxZavr+EBEpetd+hwYOqiFeb8W+ucb7WOGUHVJRgc7mwKh8dmuA6V3ggoml6EpVOjMOjeN+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729068667; c=relaxed/simple;
	bh=8NydIpP6V+e+N8ggMR7M80MrPzVoop16b/UyH2Qmok0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T6gt2GxzpWv5Pve0C1xa0eqdCnB+J/6tz6/EoLdcmKXCCF9lIi3J6rsH2FFoJqTU1CyI3BwZizKpqr8qT2xx1va0Kn5Hg4fJNs9nuMTKEKRKEavYi2F+8Y4xNhMQzALtLkLoyv+lKcRTJqWYfdlpk+6qXoKItfoT5l7RK6GyeuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NTpFucSG; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NTpFucSG"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-50d3365c29cso380514e0c.0
        for <patches@lists.linux.dev>; Wed, 16 Oct 2024 01:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729068664; x=1729673464; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7ANHELgOaoT88BOZwA8pHzeo9xESw2DEE11rjn4SfNE=;
        b=NTpFucSGiRIDDgw21gJwnOO0bd3F2VEi9HKfRAXCqYmbZsWSNUzGvrWtl1J0s7N6wC
         Czndm1zSeIY6ardyJvQoi461qRyxfX54Xk6MDlaZJ1DoIEnChAB3YUdBhbJdab++Mgfi
         ye8HJTchojJsYwdG2pDVUxuvVI05FzSGcab5eaUr+KOqHVR0Zjlp8ne7lW1nI5hinDte
         OhKXRHqexB/lZJU/8ZRMM4sW3sFSm03SIfkG6Dm1MGCAp8ZoiQZtC4oSHFd6F3tayhu8
         5Pj7IA18M1XrQoDBBkH0B1fEQiFEPuiDy0OPHSPOVVBRJr03tR1SvE7XyjIrU4ZJvI0E
         iPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729068664; x=1729673464;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ANHELgOaoT88BOZwA8pHzeo9xESw2DEE11rjn4SfNE=;
        b=CVTpqrt66OEnl2RauoSu5+ye+YzH5+8aIHINewuHbXhvnTeQ4oFeStXmUwHilQH1EG
         N9PMfNj1VPD/DfR1KPEtKK6PrBCKc379pqMJRq/q7fM4bppeKJNEuerPS8I2xA5MFPbX
         mM1nCLQ4E0BBkd1V0L5wubSfuQQLqyU9LxIhY4K6l4KXztAUKx5H/QNEuHP/fFS/gbbv
         ciB+hPRh/DCJw5rQ29KGUNGO1mV4Oo2hT334Pz88eVarIC9+4V5qwtT/y/l4pYC46HLB
         qnU4gM0BnBn/PW3p5iYoXQw9qSErO5UlSENi/cHSybvL3hChPGvB0/J055fnTaeS7Gsu
         llxg==
X-Forwarded-Encrypted: i=1; AJvYcCVgTbTFds+swfv9zflBGadLdAFCAFHQs76NYxGLw8pRdsdTc1B4A+IciBMy6gSAqbeW57sjSt3d@lists.linux.dev
X-Gm-Message-State: AOJu0YyxYZqyNNFZG/8gO2XQeCfEWqccidgV6hVWa4mHK0zZsZPrhgmT
	OsNBqWxn0Vc2q5V4lnAPy9Cd1pN3bjsIoyic7CyH4MSyHVNAecLlvkwcD3Maj2p3Ene8+tG7qG4
	xjvWFz0c6xvMv2mjsZa7GAlO1FqjocBQVCr2o9A==
X-Google-Smtp-Source: AGHT+IGVdvndE6DwHCl5J6Bx21l+qKZV4+9g/LmWrxs09SV5bTqLudTXO07JdxM9UxTa7+v8ReLIVtv+66nQOC8lm9A=
X-Received: by 2002:a05:6122:17a6:b0:50d:6cfc:ac4d with SMTP id
 71dfb90a1353d-50d6cfcc2d5mr5461175e0c.5.1729068664655; Wed, 16 Oct 2024
 01:51:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241015112501.498328041@linuxfoundation.org>
In-Reply-To: <20241015112501.498328041@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Oct 2024 14:20:53 +0530
Message-ID: <CA+G9fYtG=-cqLSb5utqMT4FuT=yHrcgr0UCf1pkUbECfDLdO=Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 16:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 791 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

From last week's regressions reports,
The LTP syscalls fanotify22 test failed (broken).
This regression is noticed on linux.6.10.y [1], linux.6.11.y, linux.6.6.y and
the Linus mainline and next master branch.

Now this has started failing on two additional branches linux.6.1.y and
linux.5.15.y.

 ltp-syscalls
  - fanotify22

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Anders bisected to patch
  b1a855f8a4fd ("ext4: don't set SB_RDONLY after filesystem errors")
    [ Upstream commit d3476f3dad4ad68ae5f6b008ea6591d1520da5d8 ]

There is a fix discussed and posted in these upstream links,
  - https://lore.kernel.org/linux-ext4/20241004221556.19222-1-jack@suse.cz/
  - https://lists.linux.it/pipermail/ltp/2024-October/040433.html

The stable-rc 6.1. (6.1.113-rc1 and 6.1.113-rc2)
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.112-792-g7e3aa874350e/testrun/25467530/suite/ltp-syscalls/test/fanotify22/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.112-792-g7e3aa874350e/testrun/25468775/suite/ltp-syscalls/test/fanotify22/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.112-792-g7e3aa874350e/testrun/25468775/suite/ltp-syscalls/test/fanotify22/details/

[1] https://lore.kernel.org/stable/CADYN=9KBXFJA1oU6KVJU66vcEej5p+6NcVYO0=SUrWW1nqJ8jQ@mail.gmail.com/

--
Linaro LKFT
https://lkft.linaro.org
