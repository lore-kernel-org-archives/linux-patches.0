Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACE71799B
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 10:27:26 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2b962535808so92797111fa.0
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 03:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1694514445; x=1695119245; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nAtcapW5A2eYCMdDal3WMSIZ7DcndsXa8JTxiNms/o=;
        b=jhrIhrwbFmGJHX3KhGPIH6GSPmPKUY+FSxZCI4ld97GupsBVpOq5lOhmbEcfCSXBul
         +K8MM1EVRdS0JBy7RLCMxB/8FmEXUK4u0G4MNTbnZBaxT1pCUvTb2FVEG+BZhNHR+qYZ
         d7tyrfqBzzNvUD6KO/6RmZPHLutbZuGrToWxedqVCKTQAU8gBrzHaEKyUWz8g8e1Ccy4
         oeClULh66e8KRm32Uwdjyja7AKJ5oV06zU+VKwXafgzTcU01Kysqly+YloPT26U4Hx6U
         Zr/+WvQia3BO9O3ewIa+wSwUP0VZgHZlHv9y3arsHoAIKhPibLu5b9TVLRdZIsqQp0rL
         /2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694514445; x=1695119245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9nAtcapW5A2eYCMdDal3WMSIZ7DcndsXa8JTxiNms/o=;
        b=ESTrwKV6HwR9StzWufmMJfk8848IEV2Nxe62/MOWU+v0fH4WCaoQVbaWtBEov/nNgj
         Vb2mKDL0NYywtoIoT4rgbswlZbgH8okwttTp3jXjvvKcyL/fIRbnr6KKc3h/toez92No
         wxGdJwSyjhG7lf00kcLE1wEQlcCG9bs6rVG5UT/32rQv3zkGFsCAHLJRs6LXcQIOkwNw
         unf+BwH4lrD+3kgXc3QH6eTA1nRUu7CfIxta+OSFEJi6OgDQtXDgT3a51H61dsX2lSfu
         qLq25EhHjcp3SBDi28XG6JObFFbT6BcP/yhueN/0T+9/MuCo4pw5gFpisaZpV7fAUhsA
         Socg==
X-Gm-Message-State: AOJu0YzvXtbxWQx6WkKVJ89k+EIOj24gau4ET4rWeGK2zbzp0RLkPiQK
	+Q99YH8zL3aRIg2IiNMLd1FZ4OVIO67vzSYVBD4g/Q==
X-Google-Smtp-Source: AGHT+IHWgn+HnM07fBBSXLrHBH2jRmH2HvCWi8b0JAGpmFtkUyfgz0ePS0MBfuPCdDGkJXyz8ESfbJQnECbrn33c6Wo=
X-Received: by 2002:a2e:8957:0:b0:2bc:d7d6:258f with SMTP id
 b23-20020a2e8957000000b002bcd7d6258fmr11131770ljk.35.1694514444672; Tue, 12
 Sep 2023 03:27:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134633.619970489@linuxfoundation.org>
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 12 Sep 2023 19:27:13 +0900
Message-ID: <CAKL4bV6JJ5PXVuo=8+8LpdAn7saJN54AtZn_f-UxjH5q7kJ_fA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
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

On Tue, Sep 12, 2023 at 6:17=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.53-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.53-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
