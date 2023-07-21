Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB19B27F00
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 17:54:47 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5216f713f8bso2900090a12.2
        for <patches@lists.linux.dev>; Fri, 21 Jul 2023 10:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1689962085; x=1690566885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjkRTaECuNngklkqmuey8QDFNRY+Ib5isKPE9flrp4o=;
        b=DYlabRZyrBAtigJv1oK1ilQ1nyN4CpyVfMjId24nLyeQwNgBmY/XEjNeVodRL567/0
         NGAD7R8fk5si13uFZifLYe6C21iKvssMliXk04MZyhhhZNg8sIFoxSG+mWEQ3Oqb0h6n
         3XvIDwvm33o5CRA+1pYC1nC8LP7Xxth00zKmN6/m6MVsClIEyyHkciTLIagQbOrPnWwh
         78LP6VDlTZzsoK5zgHhDVT5Qy9zeLL2K7AWOCfN40N3YFH2grtwTa2A/P/fz8SC4ktor
         xFvSgsWRuun2vdvxtzY4WBsskvgDYcH8L/a3aQHrZs2bqco20mwpVKt2GP/crc7s3BE/
         8nrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689962085; x=1690566885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjkRTaECuNngklkqmuey8QDFNRY+Ib5isKPE9flrp4o=;
        b=ESrNaTIndKHj+74U7APo/ZwmuKjxYcjmLftL/+1gZUB9MA5OR5b6F+3/tDa4tDc76L
         PkYa8uhZvhSz0iitu81IHmhv2Cr95b5tgU2o4UWizu3qs6/wTnzsB7qKfBbedVWFIF3Q
         5zU/uHRVexuEFW22jwYYarkS/jb4QyEioVvtH1LyfpUE5TYZllcBS73Rj9zYqWcdnXUW
         sREXZ4sSMmBkZQjW8NqmxNvGHFr6Yjx7djYAYSCOLbAc9yFvnlNFFVQsPLNNu684Pmnd
         S63vRTgrERzYqNfdbs5/AF8RKVfS1nWdTXAmC5Yfh/u5+TLT356h5RBz47DE4fSwAZSc
         H9hA==
X-Gm-Message-State: ABy/qLZgEmspmOJU6E2Hiw7kWF2UYhguyKpRmtmIwDiexmEQ9ZpNGsOe
	EnuWSpJOrDInkQRnEqBe5suFradfYYPLs/phCvBsGA==
X-Google-Smtp-Source: APBJJlF4l3FSenIHeRPlauSq1HxXG7xMFKq+3I+4+GnzMmk3eVgiT4h/Qip7SqbYCPlEeqqDEiXVZvzaaIgsxpT2pxg=
X-Received: by 2002:aa7:cd09:0:b0:51e:54d2:b52a with SMTP id
 b9-20020aa7cd09000000b0051e54d2b52amr1993264edw.26.1689962085413; Fri, 21 Jul
 2023 10:54:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230721160528.800311148@linuxfoundation.org>
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 22 Jul 2023 02:54:34 +0900
Message-ID: <CAKL4bV4J5wK=piP7n8txU9RWR=yiH=fArTEDQHUYTHgvZLDLnQ@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/292] 6.4.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, Jul 22, 2023 at 1:09=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.5 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Jul 2023 16:04:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.4.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.4.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
