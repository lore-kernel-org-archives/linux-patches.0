Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE11ED8
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 06:15:34 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id z9so355703ilu.10
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 22:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I3cbFWF/3wbRJ/LJGSbr3S2YLSTVjERFCva7QGH+gmg=;
        b=TQXq8UL4QgqOzU99DZ2FZnR8wuYuOhizw+MMZjtpJkUFGvg9P5i/lw/RWwqrdLoDKQ
         UnpYETf8awGpkGv3IpRi451RomQ6opklMdUuCi/w2gZGRvoMjNeIrHS4ZTPjma5Cv/Ud
         loNtoud4t9r43vBYNniWgJcERDfHHrHCNMnplIvKD71BxqW7j1JsRNYzUaMxlrgy1NHn
         6xdNTQN8tz+KfNNFtAnd4cswjrjr9nbNCsv8wa5thCsyCu4zRmoJ3wvA83cBbsAM1nN7
         IfS70kBNMfXBwfegiGQRDlLftR0WgGHsIJ9aky32vwQM38kMW3gkXoC+vm0tjq4uMYNc
         2iBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3cbFWF/3wbRJ/LJGSbr3S2YLSTVjERFCva7QGH+gmg=;
        b=Vuzrnxq6bUHu/aRx7bLMTgUkmMjRdYFBrtoKYOn8qDrdX/ezItkvjZ5JZiIhzItqFg
         KfrhRQ9Pw45GymGm4k0tfIg8U8aj70fQdymf6sfYHey1lc4gLDyVLWvbphHWq6qBy8hC
         Qoo96BqzitSV87ffJc+Yg05INCYuQ5bg+Y3yKYc8a2HsqEdR+ycARzDHco7y3g4hSSAi
         6elLxh8yQ2BJqJ9M926kjZlG55eVFkDJHWiLXIR2iz685euLnCeSFZ99H/VBvMIRRtx5
         5OKLD78PAUxcrLApaS/OUXxf3M31MuoOEjHgYmVsvb6fjidAzEzvRZzjEoekjnf9/qHR
         bT0A==
X-Gm-Message-State: ANoB5pkNNk+w9Orc6ze1tWo4pJjjigPqpqK3WKq3jwX+980a1mIAWptF
	K7xD4NBnuWzRUnd5VXrz9oPARmiMBLuwq4PcTcs0BQ==
X-Google-Smtp-Source: AA0mqf6datZ2W/Sl/db9jupMjDNWdTR8+AnW/Km4dlC/pKlQg+8tzrVb8F6lOwvMJ2ylFNiAwvsV75vh6r2wBQp1BT8=
X-Received: by 2002:a92:db4b:0:b0:302:5575:9e46 with SMTP id
 w11-20020a92db4b000000b0030255759e46mr29366206ilq.41.1669875333395; Wed, 30
 Nov 2022 22:15:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221130180544.105550592@linuxfoundation.org>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 1 Dec 2022 11:44:53 +0530
Message-ID: <CA+G9fYuJVxhKbeN9OGCr2_zyfa1k3j4DS1gAoTW0P89Eyz2FHg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Daniel Borkmann <daniel@iogearbox.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, bpf <bpf@vger.kernel.org>, 
	llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Dec 2022 at 00:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
Regressions found on x86_64:

    - build-clang-15-allmodconfig-x86_64
    - build-clang-nightly-allmodconfig-x86_64

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

    bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
    [ Upstream commit c86df29d11dfba27c0a1f5039cd6fe387fbf4239 ]

Causing the following build warnings / errors with clang-15 allmodconfig
on x86_64,

Build error:
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
ARCH=x86_64 SRCARCH=x86 CROSS_COMPILE=x86_64-linux-gnu-
'HOSTCC=sccache clang' 'CC=sccache clang'
kernel/bpf/dispatcher.c:126:33: error: pointer type mismatch ('void *'
and 'unsigned int (*)(const void *, const struct bpf_insn *,
bpf_func_t)' (aka 'unsigned int (*)(const void *, const struct
bpf_insn *, unsigned int (*)(const void *, const struct bpf_insn
*))')) [-Werror,-Wpointer-type-mismatch]
        __BPF_DISPATCHER_UPDATE(d, new ?: &bpf_dispatcher_nop_func);
                                   ~~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/bpf.h:938:54: note: expanded from macro '__BPF_DISPATCHER_UPDATE'
        __static_call_update((_d)->sc_key, (_d)->sc_tramp, (_new))
                                                            ^~~~
1 error generated.

Build logs:
  - https://builds.tuxbuild.com/2IHYTj6JN108YShWQ8K8Fd0HyVW/

--
Linaro LKFT
https://lkft.linaro.org
