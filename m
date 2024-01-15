Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4339718E17
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 19:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0v2TiYM"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4696d3423aeso138970137.0
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 11:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705348051; x=1705952851; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jde4lpmFdsAFmDNQO8S4NfMsn10GcVLzErOQlO9jFaM=;
        b=m0v2TiYMMTrnlH6gvG/Wdkzf3arXbN5WnGVmH3/4t5TwykQuqTOPLung29Lurr0JKb
         xcRa2MXBWNhDygSDA2zzWPYZsMED0zhNfTVoryBUkt3+GsLBMy9Gy5IFRimEA2jUfvss
         OFVQfCc/88M4s3OhCFewc6bo+8qt/L2lOAggBu7yvbFq2AO0pLHR1wcw6XSp03+AInRU
         kngrP8ZPvSyaOJ18G+6ifiuBODYPXwYnbsr94trMy4kpjMQbZXuS4mMcLAsTQ8m/Wr+z
         Dok7fkGc/jpLgz/fgoFuHOQkFu7Gqc3gla1Grj4HjJ6j1WIIWvfOK8RhZ7X160DJi5QN
         Ulcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705348051; x=1705952851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jde4lpmFdsAFmDNQO8S4NfMsn10GcVLzErOQlO9jFaM=;
        b=PGpyRBwcZmI93u4iQVPjHrUU4TQcNtAfOKv3zqripW9hSlODIWCeeQDfXXbxDkoKAK
         vEiMhfHRmWevmLF51oY/FtLeIPvMwTq6leO1g/04BOK0D7zvSQGFzs7eYOcPgX8Mf5r3
         7AtAlRfcylI7zSG+om7LcGJi1pIf7I6dyhmqD9TCXZJsUjCwYzugvWX4RFW1L1Xk9SlK
         WHgsWCxzrOy/hrySNbrb3SXFqDbq0v2ONkwkVOInBKYepDHBeEcM3caQr343S5QlY9lI
         2nL6s81P4lMUrlx9eVf4q3EX6EsbSQhq85Bom15UrysvJ7NccDt+rKf4JvJ/cHhtzMHS
         mDYg==
X-Gm-Message-State: AOJu0YwNkCCPspPwqEVfFFXs4o9T7zyVtAC4Ix5ghaWG1Qjk7an+sYr/
	9hVzAQ+KrhJsqr9xqHCPyalf1l2nIq2lwFFYgvE=
X-Google-Smtp-Source: AGHT+IHregLe8WyP6+3NAesPPtoO6c++SbsJWado1i51htlQ7l0vXhxAKYCYLuD9rgjNGDLCA4qdUnE52WR0+WhgXfM=
X-Received: by 2002:a67:fd64:0:b0:468:df5:2e47 with SMTP id
 h4-20020a67fd64000000b004680df52e47mr3883309vsa.11.1705348051084; Mon, 15 Jan
 2024 11:47:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094209.301672391@linuxfoundation.org>
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 15 Jan 2024 11:47:19 -0800
Message-ID: <CAOMdWSJqEfcsrKG4aiijMU0DX_YLZ1n+sQ+g1Va52mq81R51yQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/59] 5.15.147-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.147 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.147-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
