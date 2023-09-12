Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41C0443D
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 02:25:16 +0000 (UTC)
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-770fc5363e6so134374585a.2
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 19:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694485515; x=1695090315; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPH7BllVgYHUBzqVctyR+AwmpoGJ0bqUUfOFZqFnbbk=;
        b=UKWMOpuvFNsL1EQ85qP1LWlWt+20ljS4tZJ/b0+RWfaTtOWAqoiVJqWBt0Olj+v1rJ
         TXqR4AqcZSF5YNuiN8yvJFtpp+DHO3ZcH129DgTo0F/ORoLev22tJqZ98mZBjzR//gIX
         /BHHKHB0soS+AFkFuFmADoJedZE8pDGCBuJs01nMlyUJZUPDwKfmPU4S791mOA0Ou2eO
         taWjQw84980xyPIUFembXhopL9THC3KERqdtMa/HpIfm5o8s3UQE6zJmvNbZltJrWbLR
         UKiQYifJcQC5AKBJly4nCAx6rnEp2w72ATgdlIV2LEAZpKOhFsPxAlMidlNtRrWYDU7B
         285A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694485515; x=1695090315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BPH7BllVgYHUBzqVctyR+AwmpoGJ0bqUUfOFZqFnbbk=;
        b=tPBtdS6D52fKOkNC/b9up+IINmvXknIbcmZ3U4aRX9sEvJdP+pioLug4griTfbRkd2
         Kc6hBrbDlTFw5J5A+bmIhO4shfDgEagM/lXOITjOCHbLpzrZhFBFIMIj3JZ9bF6q/w6d
         DYzJrh5uCarwD7iBakwJAkJ+5kVs9o92jSbGrkiHkBR+f0nITeE36OSzkUhhJHtMrnp+
         i+pMLZpZSviKOVOzwlh7It6woJ5GC9nunmL6i11pVc/XqZKsmVIEPpBPuGHLsSaBJ2bu
         BtiWGycCYM7jr/txSoW1fsCCHQZolwnJqeecaO9uqc0txG03f7KkhIx/8NIL4unPur2b
         6TKQ==
X-Gm-Message-State: AOJu0Yx+eUz0TbOALCFaT543BL3i5appdDnJHmWN2zkqvUum84nCpIac
	dHiunTwdZo0otclLDKB6b3GBCiny3ojGomxs8uttoA==
X-Google-Smtp-Source: AGHT+IGrE5jMhbjwcI0STJIohBq/DbBZL++GuIpzAw5avk5UWgn5reyR+CTkf/20lvaYDnuHaKBywL/Ttmtxg9hnn5w=
X-Received: by 2002:a05:620a:c43:b0:76f:2c0f:9ddb with SMTP id
 u3-20020a05620a0c4300b0076f2c0f9ddbmr14110575qki.8.1694485515418; Mon, 11 Sep
 2023 19:25:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134633.619970489@linuxfoundation.org> <1ffe4f64-f238-859a-ab14-7559d03c4671@linaro.org>
In-Reply-To: <1ffe4f64-f238-859a-ab14-7559d03c4671@linaro.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Mon, 11 Sep 2023 20:25:03 -0600
Message-ID: <CAEUSe7_XA16yZAHA+YTbJygwaUYkU5gs=FnV9BAmQRYzwgVjvQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, jack@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Mon, 11 Sept 2023 at 14:58, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wr=
ote:
> On 11/09/23 7:40 a. m., Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.53 release.
> > There are 600 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.53-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> We're seeing this new warning:
> -----8<-----
>    /builds/linux/fs/udf/inode.c:892:6: warning: variable 'newblock' is us=
ed uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized=
]
>      892 |         if (*err < 0)
>          |             ^~~~~~~~
>    /builds/linux/fs/udf/inode.c:914:9: note: uninitialized use occurs her=
e
>      914 |         return newblock;
>          |                ^~~~~~~~
>    /builds/linux/fs/udf/inode.c:892:2: note: remove the 'if' if its condi=
tion is always false
>      892 |         if (*err < 0)
>          |         ^~~~~~~~~~~~~
>      893 |                 goto out_free;
>          |                 ~~~~~~~~~~~~~
>    /builds/linux/fs/udf/inode.c:699:34: note: initialize the variable 'ne=
wblock' to silence this warning
>      699 |         udf_pblk_t newblocknum, newblock;
>          |                                         ^
>          |                                          =3D 0
>    1 warning generated.
> ----->8-----
>
> That's with Clang 17 (and nightly) on:
> * arm
> * powerpc
> * s390

For what it's worth, bisection points to 903b487b5ba6 ("udf: Handle
error when adding extent to a file").

In order to reproduce:

  #pip3 install -U tuxmake
  tuxmake --runtime podman \
    --target-arch arm \
    --toolchain clang-17 \
    --kconfig multi_v5_defconfig \
    LLVM=3D1 LLVM_IAS=3D1

or:

  #pip3 install -U tuxmake
  tuxmake --runtime podman \
    --target-arch powerpc \
    --toolchain clang-17 \
    --kconfig defconfig \
    LLVM=3D1 LLVM_IAS=3D0 LD=3Dpowerpc64le-linux-gnu-ld

or:

  #pip3 install -U tuxmake
  tuxmake --runtime podman \
    --target-arch s390 \
    --toolchain clang-17 \
    --kconfig defconfig \
    LLVM_IAS=3D1


Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
