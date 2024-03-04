Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2807A7C0A8;
	Mon,  4 Mar 2024 23:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709593548; cv=none; b=cBzu9ZjTiN04dZbcZjf2z3MB96renwnS8tCVRkF+HNvIdhkPUFmGrBU7lZlhbfvNoeybJIzIlgdRYwFgdtUr7BDQT/k2bjHUlMUk/paq01N/KzDDBg1qCBelzdPvWwR+REXzwEWfgjuac07EDT6qIEPeQU0rbPhYL1+qSW/x+Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709593548; c=relaxed/simple;
	bh=pRGVP07ilnJmLF4KLslJUTm/7cLvt0pOTlDjP9yALDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bv23/KmLpAqggsKnQ5NXGMz3OVZ6x590QB9mQGDpYi3eKo6GYTpB8oiwDoCNrfynAVgOxquEW5hrG3LAwFYOPVrOejqgH5uxFiiH64X23ZCDwGvNjD5N2gMP/KCA3k9UfFK2Ny/paF3zDREaR2k9FsKLTyWFIyWeuTHwFCF+q/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVb7wcVr; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVb7wcVr"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso4162652a12.1;
        Mon, 04 Mar 2024 15:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709593546; x=1710198346; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94VO5VSfBbhMqWKVT1INERLTOk6iNbs+9HtRzlUVIOQ=;
        b=PVb7wcVrq15bhalq5xq1X9XdOk6isShoBUQGhWgf46gHZj8z4jJveW1HOTHehKknCw
         Z9WBeOQnDCbT+CGsC0gbPlncUZA7aQh4Ng5AMkrD15B4MAV9tP4NnoE6eyFVxRXAj3D+
         olztMFgRVnX8Sl+QI/lXHIAotBP9EPyg9MIIIdqjKB9VsIz2RFdg8oBctp6Rbcf89Q+s
         PJqAn92kKAAlH0Yo1g2rf/AXc5TNdhvu5lOnXc8PSH69p1v+RiH2j0IZvctSTawLe2XA
         wLMItyYYy6Xm2/JI0WDqSwtAj8seSGh6/eTFbzrStppKsjdYmnY7KbsgO/jJxiFFoWy6
         QIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709593546; x=1710198346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94VO5VSfBbhMqWKVT1INERLTOk6iNbs+9HtRzlUVIOQ=;
        b=Tu4s7HWKFqdHYdX+4mnBQpzRiiWpEMKO+Om+10UBijAwgNAQEqkdN7/3o/KU1P4A/J
         HypsOU9C1Jj53pE/+CZMA8If5fNTWkliT1OhSIrjg6A/M3EVbqP94OJI7Eczt2L4SDz3
         XNHj0EZkk5Ib+sqN5+ZC/6yYkaD9o4GdMwt2/0KtT51bY3lyavYDclHLdMMrLG3Lxryg
         MPXC+E42nQorFSZn/ewP8YTaTgSIUlhlUOsRQ318BfCeg/54m8YPKvthdLBcemJ6yL0w
         fPYfV9f3PZzHQUl1/6Uhs9EnywZn45/KaZ5luJiwT2SpjolPTa3CUZ0HjaLIGxQm81pE
         GlOA==
X-Forwarded-Encrypted: i=1; AJvYcCUjkaOWNM3NDvj06xEJy/BGc6aJLQaSKczulVfQzq9I5ZUY319sOfWf+OKKDu2mTJ4DfMZNDZpIomB14G4PB1gHbm4BKA3h3w9Y5QEHeQghNjxU8OTNjiRA1V2aHIOo
X-Gm-Message-State: AOJu0Yxqwm4PkO4YZf/Suq6UM7bwHiNqVradHyFZHwm3UYsyct3ut4QU
	nrDUC7+HaWuh1z0zbiu6dP/Ox5Lg4pubjUQEME//xatfGSgUXR45cDdrT8ArV3AifLZqYPaHc5F
	P6H/W857J0ivRLCRZRprnrh2Iygo=
X-Google-Smtp-Source: AGHT+IFU6wGe8LUboiIVob1DUkFoAn3TgjaROsKBSFUZVlNuZiB5QzcXusrtlcs57qHCjDZWoev1aYGdv4D1uqjXe4Q=
X-Received: by 2002:a17:90a:d90e:b0:29a:f195:70d9 with SMTP id
 c14-20020a17090ad90e00b0029af19570d9mr7530089pjv.8.1709593546246; Mon, 04 Mar
 2024 15:05:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211551.833500257@linuxfoundation.org> <20240304224813.73380-1-sj@kernel.org>
In-Reply-To: <20240304224813.73380-1-sj@kernel.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 5 Mar 2024 00:05:33 +0100
Message-ID: <CADo9pHi0az-CL_hktmpCVcuoiDaUJn2U208=TwAvBM6YQhfFqw@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/162] 6.7.9-rc1 review
To: SeongJae Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Den m=C3=A5n 4 mars 2024 kl 23:48 skrev SeongJae Park <sj@kernel.org>:
>
> Hello,
>
> On Mon,  4 Mar 2024 21:21:05 +0000 Greg Kroah-Hartman <gregkh@linuxfounda=
tion.org> wrote:
>
> > This is the start of the stable review cycle for the 6.7.9 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.9-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> > and the diffstat can be found below.
>
> This rc kernel passes DAMON functionality test[1] on my test machine.
> Attaching the test results summary below.  Please note that I retrieved t=
he
> kernel from linux-stable-rc tree[2].
>
> Tested-by: SeongJae Park <sj@kernel.org>
>
> [1] https://github.com/awslabs/damon-tests/tree/next/corr
> [2] a8588364073d ("Linux 6.7.9-rc1")
>
> Thanks,
> SJ
>
> [...]
>
> ---
>
> ok 1 selftests: damon: debugfs_attrs.sh
> ok 2 selftests: damon: debugfs_schemes.sh
> ok 3 selftests: damon: debugfs_target_ids.sh
> ok 4 selftests: damon: debugfs_empty_targets.sh
> ok 5 selftests: damon: debugfs_huge_count_read_write.sh
> ok 6 selftests: damon: debugfs_duplicate_context_creation.sh
> ok 7 selftests: damon: debugfs_rm_non_contexts.sh
> ok 8 selftests: damon: sysfs.sh
> ok 9 selftests: damon: sysfs_update_removed_scheme_dir.sh
> ok 10 selftests: damon: reclaim.sh
> ok 11 selftests: damon: lru_sort.sh
> ok 1 selftests: damon-tests: kunit.sh
> ok 2 selftests: damon-tests: huge_count_read_write.sh
> ok 3 selftests: damon-tests: buffer_overflow.sh
> ok 4 selftests: damon-tests: rm_contexts.sh
> ok 5 selftests: damon-tests: record_null_deref.sh
> ok 6 selftests: damon-tests: dbgfs_target_ids_read_before_terminate_race.=
sh
> ok 7 selftests: damon-tests: dbgfs_target_ids_pid_leak.sh
> ok 8 selftests: damon-tests: damo_tests.sh
> ok 9 selftests: damon-tests: masim-record.sh
> ok 10 selftests: damon-tests: build_i386.sh
> ok 11 selftests: damon-tests: build_arm64.sh
> ok 12 selftests: damon-tests: build_m68k.sh
> ok 13 selftests: damon-tests: build_i386_idle_flag.sh
> ok 14 selftests: damon-tests: build_i386_highpte.sh
> ok 15 selftests: damon-tests: build_nomemcg.sh
>  [33m
>  [92mPASS [39m
>

Works fine on my Arch Linux desktop with model name    : AMD Ryzen 5
5600 6-Core Processor
after the Arch Linux manual intervention for new mkinitcpio settings
and version in Arch

Tested by: Luna Jernberg <droidbittin@gmail.com>
