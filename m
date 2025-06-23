Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853AB2D542B
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 20:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750711342; cv=none; b=K6+sech+dacm91N0DSNVJqLfI5CPNcnJqHih2KCPteYrsOGIaRiWOy8QpGYQuFw2tpv2O2FvLQyT/BQhpokQTkXDag+2667gSkdBzWnhcZ1DKtibx6JHeFnEvNMVuEmcxaO1VuGWbfL0m4apxUm7O/plYpnZpOlxq1BCKAx0wz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750711342; c=relaxed/simple;
	bh=Wmo/ZDyQ4ImKtrJP3QIyntQ5jCXk1PtVU098o5eDPqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rALsd4ohkfruCC9av0Qtu3wV62Bcn3O7E7dAGxO3wBQyrjrJVsPCAMebz6SvZVUOYc/eQ9JGkZcWcsodn/m68e+QKTQPe71E++9P2/IM8Q9ZyVQmDNXDDE426JS0yvTIAXsjvNZLJhJ6nPHStYxLPXrHQbKIyLJt1Hs8AP3nrLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pl8hZl7i; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pl8hZl7i"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-311c95ddfb5so3430907a91.2
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 13:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750711339; x=1751316139; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R1GMvmqx8uhrSae96cG9GRQgWxsC+nfXg2Ck3Wi+fO4=;
        b=Pl8hZl7ifNVSAIbhPrl+G/ZRDy4AIMc+aNbVfmG1gfpcnay3IFzXn7OhkOeAB1nzmk
         ruWG0mxLSmx7lYQRGyLMiaB9v9h60JV/HqTWlHcgEeLPw3FpNOLJsIvuqTBQjaJaooWE
         fC7USUMrS1kOwC0CU5oSN9QK0IG3/UHH9QaKorPbs4YTN3DMPj/4eaUUesIz3PgjnSGA
         PxKznIsU4uLhh1PiiLqFJ/m5x8P+UCjAXPCAL38rUcRmA/6X0wjB8/yKxKTNixxgTZXm
         QMR+ORQBNl4lqNpNUgLX8tK7EPcoh1KxDA7jgqmGpnBXMCmoo7cgNaQESeyHK4Gh3o8N
         Hg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750711339; x=1751316139;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1GMvmqx8uhrSae96cG9GRQgWxsC+nfXg2Ck3Wi+fO4=;
        b=DWCzlaL260XU685vDK+/DitpC66EgZRiws8z/ErBB1Fg5t2llxLzzjVujrXyh/sXZS
         ljJ5//ZleU2KyDOCuOUuGrd/my1YKyftEo23ndin6sdSb1VD3l+wYXMapx1VfUIAIug4
         NBMeshmPFzjJP3EJZLKG3fsemHWo5lgpiIexZLQoWvoWGkvh0aDV5TcBXAL7Y119qArU
         vQOnzK5O2qO/pwwq6gcOT+c9mcncXO0Qq0Eaqt4IkuroMbp+dL+PwTyUyxCo3iVYYo2p
         /UwPq7wdtfJXfGHc/7ITmKs6ZcXrKxs6P/+dQ4j8mZ6if8EhW5dNzDTLPgXZC+bk+AKV
         kSjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKjwKi/DWKDskYB7o9XXQ0xQkGs61/leDaeX7w1nyAiBFSGSx47hqlDGK0kHVKats8VQZZa/AU@lists.linux.dev
X-Gm-Message-State: AOJu0YzjBC7TDrLQQpKYKgylrEFxZFESINptIadVu+6NoG8peVuCiNab
	OP0VVciZskMIXxN0vH77ekw/gL+cQjvp4mUM+VoSl8RnY4k21fMkQpZKIen93eO0rBB4tgkWhEr
	hCLkQTv4kDJaoRNLOUnfc/a7WcNpI8PNnxwehXdq25g==
X-Gm-Gg: ASbGnctLP+Pnbhycdf2cNtKfo6PyY1RyqprC+wXKzWvYbAjyaGb8ZPdzYhpU/vhw6K0
	aXMmI0WrCk1M6Sqf2bVWbXYM54y5N/O5qAQEtJ56fovvecwxn9bHcZyWs4ePqxzDlrclSsvzm6O
	QUmSzDv24Rtxmrs05blkcCcdq0BxPV/RlGLaoRnbe0pgm59VmfspBZo2UbW0OL++ijaXU9awvEw
	ypk
X-Google-Smtp-Source: AGHT+IFldOr82kECNHRGpbqAwkSHs/i+CSLaKvpxnRfW9bQfBnUjG7vDZLwfLs8m8yr8Dg3Wptvso52CY6mHfjG5K6E=
X-Received: by 2002:a17:90b:3bc5:b0:312:25dd:1c86 with SMTP id
 98e67ed59e1d1-3159d8cf587mr24603693a91.18.1750711338873; Mon, 23 Jun 2025
 13:42:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130632.993849527@linuxfoundation.org>
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jun 2025 02:12:05 +0530
X-Gm-Features: Ac12FXxCahOKxqInrOQt0BqXjl0ygzYTl3HNC4qxXj17qIpUny0WkUR4sQ_jwKU
Message-ID: <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.186 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 allyesconfig builds with gcc-12 and clang failed on
the Linux stable-rc 5.15.186-rc1.

Regressions found on arm64
* arm64, build
  - gcc-12-allyesconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: stable-rc 5.15.186-rc1 arm64
drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
of field in 'struct' declared with 'designated_init' attribute

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build errors
drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
of field in 'struct' declared with 'designated_init' attribute
[-Werror=designated-init]
  702 |         {
      |         ^
drivers/scsi/qedf/qedf_main.c:702:9: note: (near initialization for
'qedf_cb_ops')
cc1: all warnings being treated as errors

## Source
* Kernel version: 5.15.186-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: cab9785699236a7505c3f740e006a05ae70f47b0
* Git describe: v5.15.185-412-gcab978569923
* Project details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.15.y/v5.15.185-412-gcab978569923/
* Architectures: arm64
* Toolchains: gcc-12
* Kconfigs: allyesconfig

## Build arm64
* Build log: https://qa-reports.linaro.org/api/testruns/28835767/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.15.y/v5.15.185-412-gcab978569923/build/gcc-12-allyesconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYENOCa5bRAG0bKRLJc7p69cI/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYENOCa5bRAG0bKRLJc7p69cI/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12
--kconfig allyesconfig


--
Linaro LKFT
https://lkft.linaro.org
