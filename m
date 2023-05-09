Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02768174F7
	for <patches@lists.linux.dev>; Tue,  9 May 2023 19:30:42 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4361113bdd1so432271137.0
        for <patches@lists.linux.dev>; Tue, 09 May 2023 12:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683660642; x=1686252642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yDoEr8WUcosWAB75TDES0XOSAOF70d3PYdw53BsU/vk=;
        b=ZsEvVKJUooBL3kBWnwS/yGvHSKL06QhfHH8U9mp8k1NQa6oiAay5POTOjtD2MEkkVs
         CnY0SjzBIiU/I4j4tZ3I0LBw6QO1tMsqnHUOAcyZ4UpLVVocmb7dNXei4KLphxWOZfyN
         0/+wPgLft0o3PZ6+7cNysdw4C1gsZe+uOtpauquOYh8F3ZOkJ5pynm6mmpahCAi5Flx8
         AUFhcDQVyFpT2keS7OPJmXQT1OMFd9KjWj8c3gxRRx5vf44Yu8/a+uQ70AL106SKBDF7
         2b2yluloOXQtUrtfdj/c9MFYTmaD/jfG+r749/E/ik5Ic5bWMCpGxX1znI02jwSPTz/g
         RXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683660642; x=1686252642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDoEr8WUcosWAB75TDES0XOSAOF70d3PYdw53BsU/vk=;
        b=Rt2At6fq8aYErbfg/l2Bprv7ISYkrs/FOY2uk5NWX/uZF49L6ry52q9t0sZXe1LbVd
         CKXYG2clfv1CYoBby2UtSdt2zovaFpAYdvBoT29N35KZahbNDNjAhyZHSJ+XT/GpHCc0
         l5ZBhiuMqh/yt7lphjZ8h2FdCNFUYKr1ETvU9f/7DTCjornJX0glTssjmlZWpsyDDkMA
         Ytfd2iXsgkK7A1hLs31KT25hT5za3YXBbVdoKbxYX3IQQeVf0Y58N+nYkgG6lhZZ0Lfg
         O9OWLO2818zCQCVul0YF1DoFzjbq077ZgdocCHnQOJXj+ZXxQurZaTZKbP2GgGQ4X+c5
         w25g==
X-Gm-Message-State: AC+VfDzUH0e+CI9DoBVKPT9798uT2BDiqMrcvcZg/w0UeYV0J3hT2in4
	RiQ3Vhprp0VxSClsGZIzAZIQlzXfaSJrkEDNb1Q+mg==
X-Google-Smtp-Source: ACHHUZ5fYrN1bZ1MeR0WEVPl0NR6Kbq8GyLkmS3HqomWcgnKMgebrUFYqSL+BI/lDoWX3+QFhnJCEqwg1ULmh/7Lxls=
X-Received: by 2002:a67:fd98:0:b0:430:e0:ac2e with SMTP id k24-20020a67fd98000000b0043000e0ac2emr4792589vsq.15.1683660641705;
 Tue, 09 May 2023 12:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030705.399628514@linuxfoundation.org> <20230509080658.GA152864@d6921c044a31>
 <20230509131032.GA8@9ed91d9f7b3c> <2023050913-spearhead-angrily-fc58@gregkh> <20230509145806.GA8@df3c0d7ae0b0>
In-Reply-To: <20230509145806.GA8@df3c0d7ae0b0>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 May 2023 01:00:30 +0530
Message-ID: <CA+G9fYuCLSuPchYoSfqnu6y+CUV+Km3TVFr1NhGj0dik-ScEdQ@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
To: Rudi Heitbaum <rudi@heitbaum.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	ntfs3@lists.linux.dev, almaz.alexandrovich@paragon-software.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 May 2023 at 20:28, Rudi Heitbaum <rudi@heitbaum.com> wrote:
>
> On Tue, May 09, 2023 at 03:56:42PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, May 09, 2023 at 01:10:32PM +0000, Rudi Heitbaum wrote:
> > > On Tue, May 09, 2023 at 08:06:58AM +0000, Rudi Heitbaum wrote:
> > > > On Tue, May 09, 2023 at 05:26:44AM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.3.2 release.
> > > > > There are 694 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> > > > > Anything received after that time might be too late.
> > > >
> > > > Hi Greg,
> > > >
> > > > 6.3.2-rc2 tested.
> > >
> > > Hi Greg,
> > >
> > > Further testing and have seen ntfs3: NULL pointer dereference with ntfs_lookup errors
> > > with 6.3.2-rc2 (I have not seen this error before.) No other errors in the logs.
> >
> > Can you reproduce this without the extern, gpl-violation module loaded?

Please share the steps to reproduce
 test case / Kconfigs / device under test environment / firmware / boot loaders.

- Naresh
