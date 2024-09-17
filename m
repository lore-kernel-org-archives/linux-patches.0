Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285C14BFA3
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 10:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726568194; cv=none; b=sxqJ6RPr9rmCCDGAdCdjUdCU5Q70REvjEGoQHGAuTXWTFbs7J4krNG7nKrXTftTuxMZZl2P4qfo8hmmmR99UN7uomi7wYfI6sYQJeWzOZK/yOTYrhM5tQgzJiNXK/4zSdhOJC1G4oiKG772SgML6oiQf9MLEQKaEdFWX+h8zlsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726568194; c=relaxed/simple;
	bh=7uTw2Xdc4FdW8Wguya1dEDJdgUqDCcIuNIjLGieyNvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Afyz7K2a+yq31u2db2adVC3MICv1VnwBv64qiXikOsR7KO3kvnGNxYyVhYmuVdvLn+DdCHOAmXa3NhJUDqr/74bTJPL3XGyWluQ2/TjBRquy5YpRrtTy3/a1VxMgEaHQ1VB+OKQ4g+qvs3mtV+EWd3CGmFEaAqbQuIBtMQacpoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ud0Vo48o; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ud0Vo48o"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f75c205e4aso58671711fa.0
        for <patches@lists.linux.dev>; Tue, 17 Sep 2024 03:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726568190; x=1727172990; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2RIH+rGbvMwZNuIYE1wkPZCJpfjU4C5REBdV9ppb+nc=;
        b=Ud0Vo48oEwVURNeVWz0mD/skHIDtpoa3yy0Dk2hLt44Nr9B2uqdYQGUjXUP70nenHx
         hMOK+ZMW5FNoviJS8qMqZ2X4rQVuErWOaLnv7gwfa2kLc62UszZ4hGkXZ/xjI6h/gQg5
         6ac2gvKmcEWYMLYBW1IPXW+GE3VEj3VCXlI2aT+8uWliXBA3YSG08jEMfowNP+DC96b/
         k1ai4u2hfiaVzQtzVIBy47o6pzIj1H0cZ59po+/FGixEYqI1Q+fV3S35+OWbzkyzkQy2
         8SCBzXI0b6ARgIZYNEH+pp71vMBN4fNAk0pHhJe/YwH6ORLQOg/DBYUf/t17u7VFv/+G
         tI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726568190; x=1727172990;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2RIH+rGbvMwZNuIYE1wkPZCJpfjU4C5REBdV9ppb+nc=;
        b=ne6w88lyYjYyKRefAaEleT0KqfkUN2oEFn9jzqTyeKxJnawBhp9DZBhB6J/57i056c
         o0J6u/6By8ZxvEJ4WpBZ1QjkCU/yQSfl4N+gwI8gLb0H8eZ5gWVkLETowJRNGBy5mD9H
         Neq1X9JvRRcX5mFDTJ0hmxizbjDWQzfg8rXzu+sltCq171dF01lOeg57yz33TxgZWCkn
         XhhE3eSqPyVF8DwViNmSSh2/Gpr16MXcnTsWz3ruA8EtrvEdB0/etnhv4h9SG2pdYPbH
         Nwal/gHU71Fc9tFLIlVyjPK0PcTiX0213cch/krnGTaa0fIifcstn0vRrFN/IXIlrpQt
         VX9w==
X-Forwarded-Encrypted: i=1; AJvYcCXOu8VrhvuSkGBjPFG2euF/kyYhKmnVBBXnsjKbn1Yf6rQU9SJnWoMQU+ckFsUfWjYpDWYW3TPz@lists.linux.dev
X-Gm-Message-State: AOJu0YzhRrWTSuoiucS7VJvMT5XXJsMx5FG2lHmxxRAI24g2bl29HGp8
	jpEoS7cVWSH2eTVq9RqXmgJ83FuvUSYsMW6c3gKKhGgVQevki4Bpv1XmaTzBnndmLuIE51DQkQi
	hmfZbJndawMmElivp+Td2DiFXfIRzAR4pHUE7uQvSntIs1nAwOV0=
X-Google-Smtp-Source: AGHT+IEwjK+qN1NAncZoepbBFqxMMHpAHTJm2GY7gFtHq4zje3zC3w3ucZADOfEc9PbgoFaEb/FwjyKKPawCwz/1quM=
X-Received: by 2002:a2e:be83:0:b0:2f7:503e:ed43 with SMTP id
 38308e7fff4ca-2f787edf4a8mr102581301fa.26.1726568189502; Tue, 17 Sep 2024
 03:16:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240916114228.914815055@linuxfoundation.org>
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Sep 2024 15:46:15 +0530
Message-ID: <CA+G9fYvw7WaDjKp+v_snxnhgEzUDD1xZ9udJpqQcgAoQZXK5Vw@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/121] 6.10.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Anders Roxell <anders.roxell@linaro.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Sept 2024 at 17:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The s390 builds failed on the Linux stable-rc linux-6.10.y and linux-6.6.y due
to following build warnings / errors with gcc-13 and clang-19 with defconfig.

* s390, build
  - clang-19-allnoconfig
  - clang-19-defconfig
  - clang-19-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-13-allmodconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig


First seen on v6.10.10-122-ge9fde6b546b5
  Good: v6.10.10
  BAD:  v6.10.10-122-ge9fde6b546b5

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build log:
--------
arch/s390/kernel/setup.c: In function 'reserve_lowcore':
arch/s390/kernel/setup.c:741:31: error: implicit declaration of
function 'get_lowcore'; did you mean 'setup_lowcore'?
[-Werror=implicit-function-declaration]
  741 |         void *lowcore_start = get_lowcore();
      |                               ^~~~~~~~~~~
      |                               setup_lowcore
arch/s390/kernel/setup.c:741:31: warning: initialization of 'void *'
from 'int' makes pointer from integer without a cast
[-Wint-conversion]
cc1: some warnings being treated as errors

Build Log links,
--------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10.10-122-ge9fde6b546b5/testrun/25149541/suite/build/test/gcc-13-defconfig/log
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2m9VsokpNpc89Dqg5cG7ddRusdA/

Build failed comparison:
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20240909/testrun/25079447/suite/build/test/gcc-13-lkftconfig-kunit/history/

metadata:
----
  git describe: v6.10.10-122-ge9fde6b546b5
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: e9fde6b546b56159c192819586894f0e5b8ff6f3
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2m9VsokpNpc89Dqg5cG7ddRusdA/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2m9VsokpNpc89Dqg5cG7ddRusdA/
  toolchain: gcc-13, gcc-8 and clang-19
  config: defconfig, tinyconfig and allnoconfig
  arch: s390

Steps to reproduce:
---------
 - # tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
