Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28D143876
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712596248; cv=none; b=Fz9NY0IsacSloHcglTNUxg/msKMsgAZWKWw4XUHhE/rtrLQclYeB+gL1PyRC32e/dy/eHpeVMLzKYOFX+nvrxKOxlXWQ2aCTVRXVholb2xMabELoYA0f3dGSNxSKbOENk3x8Uk4l95jtqRR7WMXyQ6GhRP85YsyVE+Zct2wmUQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712596248; c=relaxed/simple;
	bh=cylWH1nnV2bxqs+WbEQuW213MzLnqSLV8ZuKW654Nsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kq2TkxlsFt4G1CCJPjzgz2aAcfH31Io8FMgRmYURGyh01iY1V5JoBNS+xa2SP05VrersrYKf/q1063mDcpkZPcGWPo8f0+Dcm0yMPfu/lzuGH9y5WiCMMWZY3LaBg+JWwp7Tpbu4LkXgTi0L493wJtRZDW8076cAGoq8pUqnoKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hh5DFOnv; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hh5DFOnv"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7e3b3e33aa7so1475548241.3
        for <patches@lists.linux.dev>; Mon, 08 Apr 2024 10:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712596245; x=1713201045; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dgNLDg69yxbLlzA2rtbGSv5XoBTDQC7WuQwQX8jNXm4=;
        b=Hh5DFOnvnJGV483Q1AyEtFOtuO6mdCnlMd2v4lAYymF7L0hRB8LGqujAA0qVXXEcqS
         dihelMVRpav3kUbqVYZL0rOp3VEne5AWR0T0OoqlISbW9Y0GltxyyR+eJ3b0wh6USZhI
         H+Dp04EEUtg2i6P0DD1mkGQQfUZtfO1WwBa+1cBkle5I/dtaGGdpo5Qa+NmrP4VDtj6L
         i/vIWq00Bq353QraCjp8WtTJxZBFux/uUh3ykd5bwbmsl4uXMDdJXWZpwoNNWcwvl16S
         SmB1xuyNWyJneZ2B98jEJBMTX8E/MVN+lbNFqGqqDJQpUDcZoX3HuJufzkFUkgAs7Gaw
         PD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712596245; x=1713201045;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dgNLDg69yxbLlzA2rtbGSv5XoBTDQC7WuQwQX8jNXm4=;
        b=Yh6A7nX+aXE3cgFM59WNitxr71B4NZLFA/EXApvajq4xBY+uxWd0XXW7aOzQVRkvDv
         CcefRy38Iw1aUK0xskeTsJNPOsTCK5d4MyH5smj3wRYscJv9XnTJm5kTBsiCFa56AYLE
         dd+Xtgt0SyLv+QtTGVm2IH4pRtCnStDU33mfYtBFQa8j60+Ezc4XYsbKKx9gUB49BtnG
         45w7Zim5+jgh3lASza+HNP4eOjcmTJwjzWGsB1S7ww+lF49G3m9YiOiucfDZyk12PErD
         jw363w1Jhzju6Epk0MhgYMpXYntNTAINo0/I876TJ5NXp+YLElB6zOJ5+ef3Lz5QBtir
         BERA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ8M3HJ4bD6m8z+14Xy/+4EIAOfCn7rwcBfWR+sIw5Nepz+CURjTn9oBkPRcotchmp5X4N+HqM/Rv0xYBwwsjqv5tpn6+3sA==
X-Gm-Message-State: AOJu0Yx1gFKecGBrt7DoMSJEzpgh8b9uIeiONx2eAlwQO1dWbTYPsXVd
	34z8UqIZ4MExGGQuPXewHQ+wDbObhLUH3Jp0BvyPhMw1f383tYA0oPo8Q6UA90reFGfU9QmyFJ5
	+b0U38rHjhH08RrP3bVYYiMa54yIh2rztPnT6pQ==
X-Google-Smtp-Source: AGHT+IE4rZuhK6L+sff4J6NG4CwRQVKSfgKAx18voJzxhLCWPvTOZ87xJxM9RoHsSuBANnjuKv9ClsQST7QStSFG6TU=
X-Received: by 2002:a1f:eec2:0:b0:4da:9aa1:dd5e with SMTP id
 m185-20020a1feec2000000b004da9aa1dd5emr6423714vkh.10.1712596245531; Mon, 08
 Apr 2024 10:10:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125256.218368873@linuxfoundation.org>
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 8 Apr 2024 22:40:34 +0530
Message-ID: <CA+G9fYvt2MTfghC9OtdV-bFF+dN9sY3MzgpcQ608tSTt3XUBNQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/138] 6.1.85-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Thomas Richter <tmricht@linux.ibm.com>, 
	Sumanth Korikkar <sumanthk@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Apr 2024 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.85 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.85-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The s390 defconfig build failed with gcc-13 and clang-17 due following
build warning / errors on Linux stable-rc linux-6.1.y.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build error:
--------
arch/s390/kernel/perf_pai_crypto.c:40:26: error: field 'mode' has
incomplete type
   40 |         enum paievt_mode mode;          /* Type of event */
      |                          ^~~~


Commit detail,
  s390/pai: rework pai_crypto mapped buffer reference count
  [ Upstream commit d3db4ac3c761def3d3a8e5ea6d05d1636c44c2ba ]

Steps to reproduce:
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig defconfig


Links:
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.84-139-g76e1877fe563/testrun/23349327/suite/build/test/gcc-13-defconfig/log
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.84-139-g76e1877fe563/testrun/23349327/suite/build/test/gcc-13-defconfig/details/


--
Linaro LKFT
https://lkft.linaro.org
