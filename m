Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C0F241E7
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RJ6iMfRu"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3b2ea7cc821so2987764b6e.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698136462; x=1698741262; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lDTsgqY5CgCJtGIHbt13mkSoTHTopvrjP0Xbs63E/kI=;
        b=RJ6iMfRuCL1zS2ds3LXZ7GMGdjkTTzEoeezAidw8pIpmg8zOzo3KNxT7ecAlLNg8xE
         TmarNflDn0bU+UO9hne1y/dcNPm0sqAWnjgG+N8xjsTDkkfItNPAWb4B3UdchWtgL5Sy
         9yQTd92zozugkcYdEFL+8Fu44SaaIQvMN/0HgTNh9JpjdQpSrJz3DDaCUyrZaPHzAOaT
         UdKE+rqFJqL05PdDzHH/XykD5douHqwcJrr+m0euj0vYc4ck+6k8GEQZUlI9WpjLx9lO
         qlwE6ynHIhUVTHQOtFaElxKoObVg85igRGWGAOKXVhGiwixrTAFMay0c0Z5B4AhjZGlo
         OCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698136462; x=1698741262;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lDTsgqY5CgCJtGIHbt13mkSoTHTopvrjP0Xbs63E/kI=;
        b=siKLq8DbwDoMTRmM6rY4kF9s7r2PKvUqCNz4KcRlxDK0OA7B7PkbkZpRXQ/ydb3VFC
         BiQ4F9KdZHcFA8mhnsHVz7EvXeB0MtWjgSdDn/Mi4cWZSE4TxYn9GdVEmw4hlBDZKM3A
         aO6CuSifK5sXjS2TvSvbgsIYaFPbWmL1t+oWMroafDGj5kcDpsR/6eNiTsu3k/7zM/sd
         wPfWCSL+q4BPeKoT5X8R3I9O2LbFng7FM8IC4uoJiwz/QVy0hpm7L0Q5CZ7uRl4HAdwJ
         R9FVkb6iyn3qp7IurXxmqAqVTikO5j9s/RRc2qMi2GeL1G7aw6N1BgOtLLPX3BjgFjej
         Wa8w==
X-Gm-Message-State: AOJu0YyVMdcOZ4Ng2RxyLObQxyfgF1lZqJBkyQqDKi5vZjsgu2HS3k/v
	UkUn5NREZLM36cn7eLcd2ELRFQ==
X-Google-Smtp-Source: AGHT+IEW7sI0oHCUsnHs9+KSFkzlgkRcy+wQYt/479OJAFhaxUD9jCpwlHEtfCkfxlhA+jaO8kpnlg==
X-Received: by 2002:a05:6871:89f:b0:1ea:2162:a898 with SMTP id r31-20020a056871089f00b001ea2162a898mr13096151oaq.16.1698136462161;
        Tue, 24 Oct 2023 01:34:22 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.126])
        by smtp.gmail.com with ESMTPSA id kz8-20020a05687c320800b001eb7196de06sm753739oac.54.2023.10.24.01.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 01:34:21 -0700 (PDT)
Message-ID: <3d00d797-8924-4688-bdb4-73a55cea19a9@linaro.org>
Date: Tue, 24 Oct 2023 02:34:19 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/98] 4.19.297-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104813.580375891@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 23/10/23 4:55 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.297 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.297-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.297-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 33864da1a6f6659bbf20a96027f771d5f430baa7
* git describe: v4.19.296-99-g33864da1a6f6
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.296-99-g33864da1a6f6

## No test regressions (compared to v4.19.296)

## No metric regressions (compared to v4.19.296)

## No test fixes (compared to v4.19.296)

## No metric fixes (compared to v4.19.296)

## Test result summary
total: 57308, pass: 49017, fail: 1540, skip: 6718, xfail: 33

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 214 total, 202 passed, 12 failed
* arm64: 64 total, 54 passed, 10 failed
* i386: 36 total, 30 passed, 6 failed
* mips: 43 total, 43 passed, 0 failed
* parisc: 6 total, 0 passed, 6 failed
* powerpc: 47 total, 47 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 54 total, 44 passed, 10 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* rcutorture


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org

