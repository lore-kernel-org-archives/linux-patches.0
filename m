Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A530222564
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 08:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522788; cv=none; b=O6vBcFZkSKXvqR9HoW3W9ht9ZPC0M/c4mcqycT9qtYcyXuSToMpGir/hOcLeHLR6vjVtHsETfye7pFC2L9oYd/3lK1yrAJWofYxkdPtnK0o48/M7NncXc8FhrfDoL3a2GrYmTFyNiLHIMwCrcWJqnmMAEugmE0p71qKnPxQYrK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522788; c=relaxed/simple;
	bh=DaapRn/iW7Nn3mWXq/1zNU2x1WmgQpD91mDAIchYOno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j0eEtf9l/+inS/w9mgxerGmfMdytm/AQOzB3ZRBiY1luwaW4oTBFZ/oXrvQo2TUPbOPR1IK/Uy/KVMRvUOPdgBs/EJItbhK8Y4/qaDgJMDs09Uys95brko86d+wmY8NszZweNupyKE53hKRdfNQjyLNAaXUpnADHPAtJsmupyyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dIx44DYc; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dIx44DYc"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-52088c0aaa3so270698e0c.3
        for <patches@lists.linux.dev>; Fri, 14 Feb 2025 00:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739522785; x=1740127585; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s/SpVrueRYoLO67L8eIIkV6jzrQYHfIk1nopkq7+ltQ=;
        b=dIx44DYc3CCz3NhQOJlc8Pt8OYQ/bCvAJtM7ae/gIhr98o3cLJYzW6W376CShJODXs
         VZvNRaC8I2a9cs8zccICYFEhOkvTKODY1lSwy0Q1vT+rHr1QezYEO4c7VWRw9KdHRmx7
         4UPepmqDeiBLhxlt+EAqcCkkveVcxt+5MiPMFB4eATEbVlKcUmq5bbMS5qfqozhqHNuy
         +yuSBMrzMA6r/lmV7H/b5YcZxeXSpWz3oE72i4Wcq/5fDTQIJ72xEnhfNCSgPPZxnXnv
         3AkIf5Rh8FHZQEiGDt39jah3aOuwA5U5G4Oq5+QexM+bNK4Qc1/iv52a0+Q5LQmBYpiU
         WqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739522785; x=1740127585;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/SpVrueRYoLO67L8eIIkV6jzrQYHfIk1nopkq7+ltQ=;
        b=nhMPjKZY8qN7/Fv6bKxFvSy6crBjF5ZA4L6mic/EOe8qqkOfaDwnxeE8dMQ/ZAdX72
         PHf5KkmivQBey53nyaXb9yQhwm13oBnLIvkDUT2DyNHeqeFx9VjngFublxpgljuPOfe0
         N1XEgfuqjZQ2rMtRYJzkfs3sObImlW6q/7PTh8m0PlGZMgSvLU+9R4LfGHr7AgW8wQ6I
         tamqX1lBToVN+I9CeMUFNe1Jl0cB3k+epWMnTW75eQq+yv+bqlVygWT4yox6I2zO1FVV
         O653NWVGZw76swWBaoVzYaQMLfZ4rHWlrBfVefapPxxxZ21Ti0/5Mr/7d22YtupN+lST
         jMCw==
X-Forwarded-Encrypted: i=1; AJvYcCVa4ARj+pHeILtTpiJafb8VoJBbMmdvopJJigJM82vgYtl1BOMWFUqpt/8Ym86BFNZPVCOzHLwb@lists.linux.dev
X-Gm-Message-State: AOJu0YxQlTBL0sMZFdxsdmHz6hUmGDeuuQn6QMGYvQOyeML3eEvEmpl/
	IRGwwdKbah53y3tQAQWBfsckeHvye54df6KvPTaR5SU27y+PnAOI0MALhiuMb3YJpTZJ9FSaAhm
	OBsnY7qmx+DHqGeQAOeCzcoXzYSQHmbooi6jZPg==
X-Gm-Gg: ASbGncuxDe4/ODPqCOXsUa0MGKouQ9SlNQjqK8JETfu9F5BE3ig4VCsdvlbjuBqgHFq
	Q/l5nhxMex3uMERSBJxLB4JbKXHzc7tw8PzadBSW7Ggw9UbADHzLBTG8z2vRO/sJSm+RQFIevqj
	n+W4k076npJx46pZvWxFJ03KNd1RQEg2M=
X-Google-Smtp-Source: AGHT+IEmsJZT+jXKj4JBRFBmsWO8P+p3scpYQLSYSd7oc2CaHyRP52nyDmef7v9VG3cRCZJx74tDbUVT3Hl5ru2KBmM=
X-Received: by 2002:a05:6122:2028:b0:520:3d87:5cdb with SMTP id
 71dfb90a1353d-52067c9792amr8941602e0c.9.1739522785112; Fri, 14 Feb 2025
 00:46:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250213142436.408121546@linuxfoundation.org>
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 14 Feb 2025 14:16:13 +0530
X-Gm-Features: AWEUYZmYXnFVTFbZ3xpIYpccIn9qqsxnpqLJJ2bHanM_Ra-e0XbxIu6KOWpiedk
Message-ID: <CA+G9fYuVj+rhFPLshE_RKfBMyMvKiHaDzPttZ1FeqqeJHOnSbQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com, 
	"Darrick J. Wong" <djwong@kernel.org>, Long Li <leo.lilong@huawei.com>, 
	Wentao Liang <vulab@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Feb 2025 at 20:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on the arm64, powerpc builds failed with gcc-8/13 and clang
on the Linux stable-rc 6.12.14-rc1.

Build regression: arm, powerpc, fs/xfs/xfs_trans.c too few arguments

Good: v6.12.13
Bad:  6.12.14-rc1 (v6.12.13-423-gfb9a4bb2450b)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

* arm, build
  - clang-19-davinci_all_defconfig
  - clang-nightly-davinci_all_defconfig
  - gcc-13-davinci_all_defconfig
  - gcc-8-davinci_all_defconfig

* powerpc, build
  - clang-19-defconfig
  - clang-19-ppc64e_defconfig
  - clang-nightly-allyesconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - clang-nightly-ppc64e_defconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig-hardening
  - gcc-13-ppc64e_defconfig
  - gcc-8-defconfig
  - gcc-8-lkftconfig-hardening
  - gcc-8-ppc64e_defconfig
  - korg-clang-19-lkftconfig-hardening
  - korg-clang-19-lkftconfig-lto-full
  - korg-clang-19-lkftconfig-lto-thing


## Build log arm and powerpc
fs/xfs/xfs_trans.c:843:33: error: too few arguments provided to
function-like macro invocation
  843 |         xfs_trans_apply_dquot_deltas(tp);
      |                                        ^
fs/xfs/xfs_quota.h:169:9: note: macro 'xfs_trans_apply_dquot_deltas'
defined here
  169 | #define xfs_trans_apply_dquot_deltas(tp, a)
      |         ^
fs/xfs/xfs_trans.c:843:2: error: use of undeclared identifier
'xfs_trans_apply_dquot_deltas'; did you mean
'xfs_trans_apply_sb_deltas'?
  843 |         xfs_trans_apply_dquot_deltas(tp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |         xfs_trans_apply_sb_deltas
fs/xfs/xfs_trans.c:475:1: note: 'xfs_trans_apply_sb_deltas' declared here
  475 | xfs_trans_apply_sb_deltas(
      | ^
fs/xfs/xfs_trans.c:843:2: warning: expression result unused [-Wunused-value]
  843 |         xfs_trans_apply_dquot_deltas(tp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 warning and 2 errors generated.


## Source
* kernel version: 6.12.14-rc1
* git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git sha: fb9a4bb2450b6b0f073a493bd6a1f54f231413e9
* git describe: v6.12.13-423-gfb9a4bb2450b
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b

## Build
* build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2szXNYzJaqUDby0ajsj9cBcVrPY/
* build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b/testrun/27280977/suite/build/test/clang-19-davinci_all_defconfig/log
* build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b/testrun/27280977/suite/build/test/clang-19-davinci_all_defconfig/history/
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b/testrun/27280977/suite/build/test/clang-19-davinci_all_defconfig/
* kernel config: arm-clang-19-davinci_all_defconfig and gcc-8-ppc64e_defconfig
* architectures: arm, powerpc
* toolchain version: clang and gcc

## Steps to reproduce
# tuxmake --runtime podman --target-arch arm --toolchain clang-19
--kconfig davinci_all_defconfig LLVM=1 LLVM_IAS=1

--
Linaro LKFT
https://lkft.linaro.org
