Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3CD33CFD
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FKuiGSlH"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-7c451cc7fe8so1327401241.0
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 11:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700852759; x=1701457559; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YNyfHMRrBzIt574Bt9GDCoLKWnWTa1vAH4W/mLYLces=;
        b=FKuiGSlH5aH0UY6mckHdEjusQwY3RsjqMJ0lQeDs8UrVuGkMTe3LAsY85wVVLiYtFY
         oXkRmI2Hq1RacD8rKQx1yKZBYTD1JRhpMr6jOLd+DIe7cexj4jbaMaytvC2NJxYuxg65
         WOSDKg8HiBv5q7CNZLRtICIB5EdCucFnysuWDWO1jw1j+gKt7lJsPuN/eH+WoALRmiPq
         XLApYB66KTS6GgCSFSTKSjaNm6Y/ucoecsrBrhXRaPMoulZnuzLA3hTj4xO/mvOT+Ygf
         ytRJFcteL8MOWT8sSgP7ubG7pFfN5s6qsF2XKOclqn1MnTiIC1Ami9az3t7diQM8EfUs
         /EYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700852759; x=1701457559;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YNyfHMRrBzIt574Bt9GDCoLKWnWTa1vAH4W/mLYLces=;
        b=ayg2+IjxX6yKFEuG3/H+Qm/XRK66QZrP00hGadBkW2EGkbmp2D6YWHvceMT2DPiEcE
         jxVMroXXB7/6Zy5QcCgdw+eSP3dggD5ufPT3ON8GFsU9UWBM0de3V8LrAI+xQbLVNo9/
         qEoZlOKVzy4HdnS1dXo689AsGrPtPNRK3YX9Cg2Iq5LQLZgPBXx1Xx3lQ7vCvn28ItB9
         BBm1PAgYzxhB/HqY9mRIz6m1B2m8hvQySxAycozLhT3vNWcbuqwczcdfJ0etBwxa4DML
         StIqEDc9DKBalmyDrrCqRG9w0gY1a8cAUWMjHWPtvXA/ls6pTUuniDfqjmYNhdWqY3pC
         3NwQ==
X-Gm-Message-State: AOJu0YyQRSrIXyKr30Coo+lkFojktwIALwihFDPyWwGzTpkd99AtP3U9
	xgjTrHFo1U9K2Bk+4u9TnCDSR+xaATQ3uDlTObcK3A==
X-Google-Smtp-Source: AGHT+IGgEKPztEosXm9/H1kGq+JZEFdW00hbUz3Qf/fuM0hwoW0eNL4uztgDJFSz9DPS80w+JweeHhkk5qO8D0/fxFk=
X-Received: by 2002:a1f:4845:0:b0:49a:9855:2fbb with SMTP id
 v66-20020a1f4845000000b0049a98552fbbmr4456731vka.5.1700852759253; Fri, 24 Nov
 2023 11:05:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231124172028.107505484@linuxfoundation.org>
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 25 Nov 2023 00:35:47 +0530
Message-ID: <CA+G9fYtrUpJ_+-k6dBaX0yZX-dkkrz3Qg-1FRwkG83pZvN44ow@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/530] 6.6.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zhen Lei <thunder.leizhen@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	"Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Nov 2023 at 23:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h



> Zhen Lei <thunder.leizhen@huawei.com>
>     rcu: Dump memory object info if callback function is invalid


Following build warnings / errors noticed while building the
arm64 tinyconfig on stable-rc linux-6.6.y.


kernel/rcu/update.c:49:
kernel/rcu/rcu.h: In function 'debug_rcu_head_callback':
kernel/rcu/rcu.h:255:17: error: implicit declaration of function
'kmem_dump_obj'; did you mean 'mem_dump_obj'?
[-Werror=implicit-function-declaration]
  255 |                 kmem_dump_obj(rhp);
      |                 ^~~~~~~~~~~~~
      |                 mem_dump_obj
cc1: some warnings being treated as errors


rcu: Dump memory object info if callback function is invalid
[ Upstream commit 2cbc482d325ee58001472c4359b311958c4efdd1 ]

Steps to reproduce:
$ tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig tinyconfig config debugkernel dtbs kernel modules xipkernel

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2YdN5Tb5NAFPo7H9WWQd0APrWu1/


--
Linaro LKFT
https://lkft.linaro.org
