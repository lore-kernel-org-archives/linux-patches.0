Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA561C17
	for <patches@lists.linux.dev>; Wed, 15 May 2024 00:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715733423; cv=none; b=WkbjHy0asB0VTm1ZKYU1tKBdNDLKrfbP65M7SLnN83DcLuq4sMqn21YW8S2y7tWBk7w04Y07Kuq/+Qv87hIx96pWer9nto7iiEdF6mEGH7bqH0+K8ZvULUkGkk9vQEVDgS/4R+vNBER0NFjOx7E1uniZg4DdJYWobO6itKcboFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715733423; c=relaxed/simple;
	bh=oBWUlEWluAHTiq7x5PmtdIOTVCfEATl1uVh/AdUEqHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VMvdrgcZ69QEXCdVZ8yaO8uM72GeZGXAL1tn0nvJSebG1D4haACrK0XC2El4broAx/WSVa25GBYTKpN463AvR05HbaJtDUEUpr7UJ0m5WbfLEHDHQRUwTyx3pOrZE8IOaDkSWCpPSMmlb4zz+RJ1S9+u7JR8Y/T/P3CEYRN2Juk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1SBHa9JO; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1SBHa9JO"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2b9cdbd6da9so175083a91.1
        for <patches@lists.linux.dev>; Tue, 14 May 2024 17:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715733422; x=1716338222; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vk8qZUNPyTPW/A1KHzQN8z/XqvExIz1hHrnYNu4UtMQ=;
        b=1SBHa9JOWoOWFw4xnzkv/iB+KKEYXKZ7jwmznYLySA4obaIY3v/FlWvRGYZQeJGfPX
         cjTd39GXBz0jygdItxA+PLB9DrCRWIy87i2ySPa+y65MV6xvueBTx4UcFIVIdd9lSNU1
         vHKy0qhg/0qURTD79YqZJymo4RQj3GtYBlM6z/5hc2VCFnyPYJeag3ag4nNE+f66RwzX
         XbIseMv7C88pdPX7CdPlCNvUixbjfbpmjM5kSA41Qx767/be+VCkjBJblLZnYpmVuvlY
         miZA0M0jOPTNvJzGaYdRmd7PfPzuj0dSK6hXCUj3UxN1SUEA/oZ395zhap+UQgDx/3qi
         VmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715733422; x=1716338222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vk8qZUNPyTPW/A1KHzQN8z/XqvExIz1hHrnYNu4UtMQ=;
        b=pIHSll80Je0RdD1CkGJwVLfasiL2J/Z3dTUlsymCDfh6t72QkKY1XqKgoJDzmyxDLk
         IymhPgz3q94e1ZlJX8MmlF0+q9g1biZ6Zq5ShIO4RopWqLhjxNhj0jxJLUU9ijmdt+Kb
         8ghmfDS0AXgHe1JvLdHfZVwA69x9+zI9DpbLZ2WkIQM66nZ/s9eIOBJIXygwDWJQ1jll
         07H0uhP7wfaclj/BDbPUfclCQG4dmTWLrkZQVDFQDN1uq3WHyh2yzAo0aXXIglCJoKFL
         Dtl9QMlE29GSk9j1Xrj7dHdxUu/dcbZnwfQtxlpngrdlbn13Y1kbSx1Yscl5vhlaaDgu
         qfsw==
X-Forwarded-Encrypted: i=1; AJvYcCVJlTuRoqcFygEoMPfHY2RwrvS/SVaIwIJWSFpkHXP1bDcwDzn1O7+F2Kuk27ND8yLZi7+P8JxmDuA873ZX2XpI/XvZTBZMbw==
X-Gm-Message-State: AOJu0YxaAc7pxRwEgDUXlg3UgVxXMGIgMP+hONdthQnYbC7veZSH/l3c
	la57PWsEQpaic2Di9c94BfwzIsdiSO2sdEHAXm4OfrSli9upfAtNDoZxzxB2z3UZhfHWIELWXVa
	EKy3nWvBKTxKwtshQ8W2Rz5KCoF9cdeaqExhl
X-Google-Smtp-Source: AGHT+IHeqrDxqHwSqE8LkP9zNnO4aoIPfWbbw91OWLX6RaFgTT+3fK4f+394LqJxYkdL3RuANgpc2LoWG62WKveVJjY=
X-Received: by 2002:a17:90b:438d:b0:2a2:f4f4:2c4a with SMTP id
 98e67ed59e1d1-2b66001a442mr24360414a91.21.1715733421460; Tue, 14 May 2024
 17:37:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514101006.678521560@linuxfoundation.org> <5beea8ed-b92b-4bee-b77b-4a3d57a5c001@oracle.com>
In-Reply-To: <5beea8ed-b92b-4bee-b77b-4a3d57a5c001@oracle.com>
From: Martin Faltesek <mfaltesek@google.com>
Date: Tue, 14 May 2024 19:36:24 -0500
Message-ID: <CAOiWkA8SNRbCPZ_gHQRczZovokZbFSJXQc1vUmtD0quZV9tp0Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc1 review
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, 
	Vegard Nossum <vegard.nossum@oracle.com>, Darren Kenny <darren.kenny@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Build failure on arm:

In file included from drivers/iommu/mtk_iommu_v1.c:22:
drivers/iommu/mtk_iommu_v1.c:579:25: error: 'mtk_iommu_v1_of_ids'
undeclared here (not in a function); did you mean 'mtk_iommu_of_ids'?
  579 | MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
      |                         ^~~~~~~~~~~~~~~~~~~
./include/linux/module.h:244:15: note: in definition of macro
'MODULE_DEVICE_TABLE'
  244 | extern typeof(name) __mod_##type##__##name##_device_table
         \
      |               ^~~~
./include/linux/module.h:244:21: error:
'__mod_of__mtk_iommu_v1_of_ids_device_table' aliased to undefined
symbol 'mtk_iommu_v1_of_ids'
  244 | extern typeof(name) __mod_##type##__##name##_device_table
         \
      |                     ^~~~~~
drivers/iommu/mtk_iommu_v1.c:579:1: note: in expansion of macro
'MODULE_DEVICE_TABLE'
  579 | MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
      | ^~~~~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:289: drivers/iommu/mtk_iommu_v1.o] Err=
or 1
make[1]: *** [scripts/Makefile.build:552: drivers/iommu] Error 2

This is from patch:

bce893a92324  krzk@kernel.org           2024-05-14  iommu: mtk: fix
module autoloading

+MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);

should be, I think:

+MODULE_DEVICE_TABLE(of, mtk_iommu_of_ids);


On Tue, May 14, 2024 at 11:29=E2=80=AFAM Harshit Mogalapalli
<harshit.m.mogalapalli@oracle.com> wrote:
>
> Hi Greg,
>
> On 14/05/24 15:48, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.159 release.
> > There are 168 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> > Anything received after that time might be too late.
> >
>
> No problems seen on x86_64 and aarch64 with our testing.
>
> Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>
> Note: selftests have a build problem in 5.15.y, 5.10.y, 5.4.y, 4.19.y
>
> 5.15.y revert:
> https://lore.kernel.org/all/20240506084635.2942238-1-harshit.m.mogalapall=
i@oracle.com/
>
> This is not a regression in this tag but from somewhere around 5.15.152 t=
ag.
>
> Reverts for other stable releases:
> 5.10.y:
> https://lore.kernel.org/all/20240506084926.2943076-1-harshit.m.mogalapall=
i@oracle.com/
> 5.4.y:
> https://lore.kernel.org/all/20240506085044.2943648-1-harshit.m.mogalapall=
i@oracle.com/
> 4.19.y:
> https://lore.kernel.org/all/20240506105724.3068232-1-harshit.m.mogalapall=
i@oracle.com/
>
> Could you please queue these up for future releases.
>
>
> Thanks,
> Harshit
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.159-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
>
