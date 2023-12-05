Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5FD68EA7
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Iin6s5kV"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-db537948ea0so4127792276.2
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 07:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701791651; x=1702396451; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OpCZZN7ifzLhrwAYxkGqYDBB1FuZ2YnYQt+7H4zDU+Q=;
        b=Iin6s5kVzyXQUuSaF/Ugmdu8l5rPE8+xWJUo434twzT6y7A0iTqAj42rAwIusMN32g
         +YSbQ2bbSyBqdX7DKd3AZAwrcSnSRJ4jvvHOUdzQeXgrgJFsSPc9UQLX7fOz61oA9jM9
         6XKyi7o9wraVvZ/DIessYMtncp6Nf/d5ZG14xgkXMd62C93MaBg7P2fDMoothTa3CSqC
         BfiMxIZmkAzeG7QUp4NmeIBvtyFbNnmsTypbxeJezV1mmRxzndBMkRLTYY8oE+w2v9WU
         9nDDEfvoedRr3PojxXLzDuvM7X5ode+M0CGjI1NVL7V12uTw9u0nPQyWT2xwKC5z5p+T
         dOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701791651; x=1702396451;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OpCZZN7ifzLhrwAYxkGqYDBB1FuZ2YnYQt+7H4zDU+Q=;
        b=cv7IyM0zesNBURlVRGA8c7sMdE7gqgJwpzFNBQR87HI6PO3Ud99Lpz2S1SuYQhBLa9
         rmcjZ8ERph2JWKrrtXJrwkqnHga3hI6919wfkAzJbR4RFnqef+RbPyAR9fJJ3zSHpakV
         fF5R/E1Vw486mqEAPSt+hTc0ZvbWfl+Qcp9tBorD/lzQN1B0lg5XR63h75BVFhoG9spO
         lhUtICLdtzhwd2pKXywRdd1WijfB+5z7DVTxRewyRyc1PteK7psxoPa8HTrfVcUfld4t
         kTPhWHK2Q2sS5w4orRsoxFv6AowL9nnxQPOY73EGGSXiYFcEc1t3Ks/SZRVqkUcx/9+9
         FQIg==
X-Gm-Message-State: AOJu0Yy3ly0iHC7V2HNQBgZ56KS7aAITEFjvSQKhlz8XsjP9CDZB8JDT
	PWg2bF1WkAcwXHBjS3DoN1z9lcL3z7uNn0uIuqVSlA==
X-Google-Smtp-Source: AGHT+IGCJb6NJTexBLiNBzgMwl8doc7Qk7WTAXljr3GKe9KFhu9oJQpIiiYrofNfQQq+O9e/tLSF6yqkhku8Pwwo5cc=
X-Received: by 2002:a25:b293:0:b0:db7:dacf:59fc with SMTP id
 k19-20020a25b293000000b00db7dacf59fcmr4225994ybj.112.1701791650893; Tue, 05
 Dec 2023 07:54:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031535.163661217@linuxfoundation.org>
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Dec 2023 21:23:59 +0530
Message-ID: <CA+G9fYuL_-Q67t+Y7ST5taYv1XkkoJegH2zBvw_ZUOhF9QRiOg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Johannes Berg <johannes.berg@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Dec 2023 at 08:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The x86 allmodconfig with gcc-8 failed but passed with gcc-13.

x86_64: gcc-8-allmodconfig: FAILED
x86_64: gcc-13-allmodconfig: PASS

Build error:
------------
In function 'nl80211_set_cqm_rssi.isra.44',
    inlined from 'nl80211_set_cqm' at net/wireless/nl80211.c:12994:10:
include/linux/fortify-string.h:57:29: error: '__builtin_memcpy'
pointer overflow between offset 36 and size [-1, 9223372036854775807]
[-Werror=array-bounds]
 #define __underlying_memcpy __builtin_memcpy
                             ^
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Suspecting commit:
-------------
wifi: cfg80211: fix CQM for non-range use
commit 7e7efdda6adb385fbdfd6f819d76bc68c923c394 upstream.


Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.4-135-gb0b05ccdd77d/testrun/21509070/suite/build/test/gcc-8-allmodconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.4-135-gb0b05ccdd77d/testrun/21509070/suite/build/test/gcc-8-allmodconfig/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.4-135-gb0b05ccdd77d/testrun/21509070/suite/build/test/gcc-8-allmodconfig/details/


--
Linaro LKFT
https://lkft.linaro.org
