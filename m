Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84328814
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 17:14:30 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1c3d6d88231so47533495ad.0
        for <patches@lists.linux.dev>; Tue, 19 Sep 2023 10:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695143670; x=1695748470; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qilWP4l16Pko8V2zY8Gw+Fh5MGg9mIKSWEZuLvQUUxU=;
        b=FtFxX4Vf+KH3MvHo1OARVIjPkqe2sn+RmO1wPjml7Ra1v1orvVlx7ErKNL6nUqrikR
         eN5Si3Ya4d1IwfvZoyN8WZmL0nQPPfYN6f0eoiFknJeV72J4QmH9cVkDunojsH/feClh
         qY+7WpNMQRySM0C6HOVMEAFAO2hz+dIZWwtnPRstDglW6YpqBa1AwHNeR1/Ax5dLNC2Q
         L/qtLY54yOCeds/K5oAX2/0jirKnkuQ0E3Z7JdOZFwGjMsXSdAXXZaH58rsqxKsCCdP5
         B6uytOctfksuQUhayrLztdTXIU9exwCi8UV62kAkG1V4zYAFFgav2vf2WRx5mrvmtAP9
         5ltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695143670; x=1695748470;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qilWP4l16Pko8V2zY8Gw+Fh5MGg9mIKSWEZuLvQUUxU=;
        b=DLLBoxaZi7qhUXs3+yDC9/1YldT5GSV2XwSvSDetFcoWdsrfGIRBCXX+GOgkpspUwt
         ECCaz9MXc22HwmuxKYPQNZLfR+1QBSDwDcBVZZdJ8/Ec31fqbOIgX0IQ/xTRItE6e+Ih
         hOMxOlKBebUazRjZXU+mL7OnroD48G1JT9E2Zd5s2AR93OMbb44OwxNja4yaoS5JQ6ls
         xnuHoRq7WBXdhN4Sde69E3UUuXXLkvDNfg2258qX6e1fIphGB4XbtHeYPm01kqF9YywA
         rizjHzGVGbMZVcFqq62LWPw9yjT39JBdluJv2899YRpxvWlvcpbPr/eN/qRbkkygOwtu
         KqCg==
X-Gm-Message-State: AOJu0YxDTXzCpGYPcKk4y1s9LosxA0ZDJvCN7O9cKfJa9kmFDkbqQAir
	caz2q51BIkmxrTCOtD7dJAQeA+l7dSZNb+WhOwWucWOLGzY=
X-Google-Smtp-Source: AGHT+IHHUaQ/wQAHUHYD4e4oP+9he47YSvDdrnOdpG6XSIk6oKvwiWwLqQknQFLVEBdSb3rmyCX02ogBy5WeRcq4XQc=
X-Received: by 2002:a17:903:18e:b0:1c5:66d4:b302 with SMTP id
 z14-20020a170903018e00b001c566d4b302mr58839plg.16.1695143669921; Tue, 19 Sep
 2023 10:14:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191113.831992765@linuxfoundation.org>
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 19 Sep 2023 10:14:18 -0700
Message-ID: <CAJq+SaD7MCJCTRGpV_UVhkfixKoQtdGpFjaD03QX4Q7fwZEByQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.132 release.
> There are 511 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.132-rc1.gz
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
