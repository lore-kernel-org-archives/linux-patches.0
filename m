Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE6B1EEE0
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729541355; cv=none; b=Um9ZRKGUeglSQ3OycDpQBGSioqZESTF1LG9Q91vF9fb7Z4nETpWFzZPYKrQRJHVR4c62Qeg3L77Gep7QR81rhDM+FKPw53GzAjuwxfQ8sdM8ucHoda/zP4F2aKpHWEK4N7pC2My8Tabu10l8VhlmQ3d7I53zgG2hwclrtqlCKqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729541355; c=relaxed/simple;
	bh=I6t9p1EaDfvb/Eliq/u4F2cQjKpPa4rONmqDu33+ZwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ka2JkPvrQlV/MOeSoRSajXxQb7W4wYYX3lJUmFCNenM6/vrJr9qhi4JgrNvEcKH3C4dGjvYdi7rBlkqvvUkMFlycSuUVwGzje39tGmwtWXWtLe/NpboePILM5gAC3f3UZ1mcotogrl3j78HBEbjckcJFmoV7S+tnVAL7mmW4kbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KLPO9u9T; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KLPO9u9T"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-50d399891d6so1225002e0c.1
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 13:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729541353; x=1730146153; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X7UfXJmHqQAN/EECC23EYEuOCLTpAVln9L8WakW7sCk=;
        b=KLPO9u9T4oINwl7ciypkM2tLcO0rNtrFljQpjSV+NdSPVTPF/nG2KthFp1ANwPaUKM
         choVEqHqTwIszZJW6bvlmpAztU8DrMEy7Q1NcRZW1jgaAfQWFLlIAzV2tPJRpldZNhhE
         xJ1r4JDs/aNtzmF8SFFeEq7LfJwcax3xBD8yNez77vRALJh6JE+k1LcdThcan9OEY0ZL
         Nh/FM3JgN6AeAPmHjQme/lJbNtrBm6FayscQKTEspFd9peqzCnOzLYeq3cxYtg+QEW4f
         hrKZOx0eEyfjJmivUIuQanvrroL+C/b+AuTooCu8vrF8X9mgkvKdYQ1GfuAcUZqgwaTf
         W0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729541353; x=1730146153;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7UfXJmHqQAN/EECC23EYEuOCLTpAVln9L8WakW7sCk=;
        b=kDW7EtNF9IGHyLb6Q0bjDwzlqqfyhOCrfPYie7wm31L+WFYicDs3PGvuilyK1grJh0
         sKezRprVjnSnR3MhcRYHFdW7rJvRX4Zh6eOhlvtBU0raXSzXhO0N5CV3KdWdRelMabQC
         pDK+j9zi900ag+zoiudGV/+FEVl2x7r9dTBs2qAO8WlJaM6ojI0rE5vUKkPApu9OULfM
         WT/5UlhdLsa8AFAZbizgVeCJFoIMjn9oFOPyS/kG61fjRiJa/WJQ0i1LOfTrpJ4QFN6e
         oK2qYPzKRa7JJ+a3b+yTD+Ca4yGa/GaX79u7lD+3jZDpiGGz10yqkkwDlgMPtzzf8Ahg
         pN9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUjQx1dh3pLxhsHjZNfHY3ztjGkwV8eLuaI3qaZwrNNCgVgkXPfdbkHpdaVCB8x1eQt5fpBFTl/@lists.linux.dev
X-Gm-Message-State: AOJu0YwrwL5oZ5kOtnok3ftXbIdniX3MGm1TX7sWfQ8t29GCEQ7O3iL+
	hNknDWwcb/gJzCpr9Z1GXxIxNbm0Ft27Ym66OAwdkQoit6o5zrqaSjzbUpLOAM27Mu9IQkQp1Du
	Yu1ZgUnmrQiRSJmFZaJfzDBvTZQw9w5cVcpBqiQ==
X-Google-Smtp-Source: AGHT+IHOy4P9Q03evxUVUvw+iLlP+PcSvEmnXr9naHrpQxbtIPqDsLLua0p6Q8JDW2ufPcobKza/hdFknJsTy785kG4=
X-Received: by 2002:a05:6122:179a:b0:50a:b5a3:e00c with SMTP id
 71dfb90a1353d-50dda180bdemr8605836e0c.1.1729541352168; Mon, 21 Oct 2024
 13:09:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102249.791942892@linuxfoundation.org>
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Oct 2024 01:38:59 +0530
Message-ID: <CA+G9fYtXZfLYbFFpj25GqFRbX5mVQvLSoafM1pT7Xff6HRMeaA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Oct 2024 at 16:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The arm allmodconfig build failed due to following warnings / errors with
toolchain clang-19.
For all other 32-bit arch builds it is noticed as a warning.

* arm, build
  - clang-19-allmodconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build warning / error:
-----------
fs/udf/namei.c:747:12: error: stack frame size (1560) exceeds limit
(1280) in 'udf_rename' [-Werror,-Wframe-larger-than]
  747 | static int udf_rename(struct user_namespace *mnt_userns,
struct inode *old_dir,
      |            ^
1 error generated.

Links,
---
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.113-92-g6a7f9259c323/testrun/25501845/suite/build/test/clang-19-allmodconfig/details/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2nkFE9BnBhh1xegvL7gVqMnXz2x/

metadata:
---
git_describe: v6.1.113-92-g6a7f9259c323
git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git_sha: 6a7f9259c323c90fd1384904b8d547666568a716
config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2nkFE9BnBhh1xegvL7gVqMnXz2x/config
download_url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2nkFE9BnBhh1xegvL7gVqMnXz2x/
toolchain: clang-19
arch: arm
config: allmodconfig

--
Linaro LKFT
https://lkft.linaro.org
