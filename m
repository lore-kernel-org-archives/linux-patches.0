Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A689EFBF1
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 21:56:22 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-51d9890f368so1345960a12.2
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 14:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1688075780; x=1690667780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOf/JougOyhsOkb+dRe1n/eQScesKh9WdkdB5A99fRk=;
        b=dps2aQjRsOXr/g4E2iSUfNcqKD1mHXWZ6ONP5IMR3oSFjwhakhw7A5juUsLZTP8pck
         bALZOCQImGAvmlg8eN0TfsDBRHjwvinGpEx7eeHFaLbrl27tv9F6CmkODLcuvnii8653
         W0zQpdZb92H72YEaiGbUS0VOlDPLagz6/8pjl9+Sq5vgnJuCWiiP8RL8MNdiCEiaakDB
         tcmUtdurnJZ5q/nOLdw5hkBJnFjBiBcP1CkkQbZhDxoY8UUHxqzVXKOuxnaRPwYk5q5m
         hHpkEHEjHbnYPiVFFcpIQIH9XZ/uYxotgwEEcimdkmPhMxg2TfWrSwLoipB29MP97s7E
         pQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688075780; x=1690667780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOf/JougOyhsOkb+dRe1n/eQScesKh9WdkdB5A99fRk=;
        b=A1CKSsxJfTza70VS1Vb1Vghocw2E57ZNZMRkBt410j6OPwJUx8CjsRCgNINAYMgZgw
         P7JCmcXBOuhKYBH4MxIAE6KwDL+QYtDSmc7OvpVmqX6u02uXBBlrfQ2ERqdfLVfUrXxm
         oqwpMkFlNchDrZCDDtUYnVv1c2IaCjOJPegp0OF1eeRoSViji1HCIsbY6N5T/NyQKDLS
         BgsTKQvrIxyQxoHkPswJT8kf7cw7Mk+ybokKF3CUt+FEg/MBQUaPf7pCGqqUidUZjIPv
         TgZpoDMMSN76MKRsz6mW2gOl+dVvo/Mc28c+RBt7REl6eHG9vz4pOVLsZ3iccvwmjy+W
         N6vg==
X-Gm-Message-State: ABy/qLZ2PUP/FyMt7ugI23Q+gz2oWhvvdq+sfkT32KJNC/c431B4n7j5
	e8R3QLMrC/woIU3gruxxbCJWEVIHGho02oVU8ifd3A==
X-Google-Smtp-Source: APBJJlFNR0w1BjJGgwrHeJAqiblVmG1i91+46JqLPZi03yOqFYxDfY+UqfovKXnkj4grIoEqvKwIxkiezjLHq/RQy6A=
X-Received: by 2002:aa7:c152:0:b0:51d:e4a3:3c8a with SMTP id
 r18-20020aa7c152000000b0051de4a33c8amr321502edp.3.1688075780431; Thu, 29 Jun
 2023 14:56:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.651069086@linuxfoundation.org>
In-Reply-To: <20230629184151.651069086@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 30 Jun 2023 06:56:09 +0900
Message-ID: <CAKL4bV4hMiGuZ9c2MmbToy=pbMFmL6fHji4zOh4h0G2m0FGMUA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/30] 6.1.37-rc1 review
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

On Fri, Jun 30, 2023 at 3:46=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.37 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Jul 2023 18:41:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.37-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.37-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
