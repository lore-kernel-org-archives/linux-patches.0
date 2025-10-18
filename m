Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC38D23A98E
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 06:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760767594; cv=none; b=NLwWYAB3pXOzBm4wvY/EcLA7R7knfrt2H8lJKaDzDxhC+cMCGRvmr7gb6J15AM31017RflimuXm9ax1JZ/6rkGDC+13uhDgid59OF3UegIzCWwY7GbQC7Qgsl0x9uJL6ceMjNiuZlqOyEnqzA+5at46yR4n3+dvkMPr9IdsKGoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760767594; c=relaxed/simple;
	bh=Y7VjzJ7gtb5qwhTcI0eZoGslmJDABeIw4LK16Zz63y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HnfAYoJ799BEkAM8r4XSboQTc6HkAKeLqUaZSvwXHt3j4RPkdb+Q+XFQm91O3jzBsaqGS4mWpEDpzHQhWAZSbFE5HqxyDb9Ex5X66pmgPcYgxwPfiPYt1mb7BU3wxxhpu5DabeTqTakRRNFmRjGPW5nfnb1oQ1q8lUYD18KyPr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ivOrvuA7; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ivOrvuA7"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27ee41e074dso31603315ad.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 23:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760767592; x=1761372392; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aazlfJMFqoIIqAXzADQv4tBj3QeLA4CZuF+zY7Y2u30=;
        b=ivOrvuA7asdo4qETSmUoWqK7m4rufEVK+Rd5BN4jYSHrBJslzpb9pGcVU3LZ70outR
         0Q+W8r4mBGHNwj4PqevXcMOF0RY4euUNUYOBtsOe9FM1k54Uk/te4ljCVgBedLRfglaO
         35zAnz1Q++94Bq2cqPs+ZYPFm3v2iAnoBgWG69PYTCKDF1wvSpWWhcPzGEM7m8t7Mmue
         lvkBrjTSD5RAE9PfIY8s720HvMC2fY/5hgXsaqVAyz83DA+M5jo0Ic2F7H+LZZ9WJvW9
         uLTdcxWiIAdc0YjngxI02iRUxZUg/yWO8o0eJcEqZlu1jXhA/mM43+w6G0FQHvm5uDGC
         KIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760767592; x=1761372392;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aazlfJMFqoIIqAXzADQv4tBj3QeLA4CZuF+zY7Y2u30=;
        b=KnhR6S6L2lF2Y6Tvc/jDGJbs8vezND/yC2tWnj9+Xq/fC3HCM9KoJPd8eJxa0rldrc
         /9MfH7hX3WG3IdetGuYf/K+mjqWg802Aa24rw0F6OgCDBmIgL45VohXPQBMYZq9NVAuk
         mXBKScLdUWwbVofW8wC/ijkALzhpdIWtu0wVaeNctqbkckfKsNpeh6u/mdqoEG25nI7r
         18upeEtFeocA+9a1++pq6S73Z5pleEACB2GoO93+udwRr9jWCzMDRDbwr3OwFRpzWEEh
         oTa7JkJ7RTVB+YHaBZoXy5Q3nAKz1Mz8PmKS1KJG784eRFaRo6ihXeob7MepQtQDi7cA
         JNnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF4jUxAOt2vCGxeyUyDsTXvWdJ3F7l9Yo5Oj/qS3syc5UJqeXUTMkj/K7d1Ab1TZbUi+hR63AJ@lists.linux.dev
X-Gm-Message-State: AOJu0YwQ0G6FAtcSSvS65HSl5qmu8uLRIsE3xaRWu29FaPRsGkku9xgu
	7ZwPTIugF09oj3JSD8G37OvPMNfonIq6spSfsMeR7J2t0BkP6+f08hOELY94WtSbzhUSbzhiopM
	0nd59YOWIiHbShDZVnddeGE7u8r6h/cJVmDCN272ATg==
X-Gm-Gg: ASbGncsmz1/obDjgTqDiL+RMcIzkwFAoeE23OQBl5oRskjIyea0C1g6lT7W1MV86DM+
	ReARGHcGwiJY9S3se8K6qpsp7L/ur6BmQAL9NTY/mTxgkxV0eg048sdEvnu0Qn7YSEwgkpMeVJD
	ajd4u43oR1XQDuz63DTvbdLpoFfNuxozUjO1mrNNmGsr9IPL/T+P+i3QGhmqhsixAsBgrB2YlVK
	YWml76Jkf63BrvjZ6POI9Q0n+xjWcCqbyXtHMnIMMZ3PxTHVy0uJdU7vWamkrB8kKRIbbzyyILL
	ge5NNsuPWhsiGDJ2CFC2oufDrEFu2CK0OKaa0VaNy0muGsi92/bQH4gbNco=
X-Google-Smtp-Source: AGHT+IHw7R+YKzHxbRvPtqVHveDcGsf+JR70AmHfztdh/65g7vwQzHb9v03kO0aR/In7bOt2WwurKH7t1XzdIq0sxKg=
X-Received: by 2002:a17:902:e5cc:b0:269:8d16:42d1 with SMTP id
 d9443c01a7336-290cb278af5mr83894225ad.50.1760767592005; Fri, 17 Oct 2025
 23:06:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251017145147.138822285@linuxfoundation.org>
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 18 Oct 2025 11:36:20 +0530
X-Gm-Features: AS18NWDT1IrNVAEdIh-3uwC43DMp1BdTel7L0k_1kbuM11sAOiFrjCGmbmGqSJA
Message-ID: <CA+G9fYs1jVE3OGhp5QMr=XZ0NzmCXV-izshW2scAtSy+v4T17g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 Oct 2025 at 20:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.54-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following kernel crash noticed on the stable-rc 6.12.54-rc1 while running
LTP syscalls listmount04 test case.

This is a known regression on the Linux next and reported [1] and fixed [2].

This was caused by,
listmount: don't call path_put() under namespace semaphore
commit c1f86d0ac322c7e77f6f8dbd216c65d39358ffc0 upstream.

And there is a follow up patch to fix this.

mount: handle NULL values in mnt_ns_release()
[ Upstream commit 6c7ca6a02f8f9549a438a08a23c6327580ecf3d6 ]

When calling in listmount() mnt_ns_release() may be passed a NULL
pointer. Handle that case gracefully.

Christian Brauner <brauner@kernel.org>

First seen on 6.12.54-rc1
Good: v6.12.53
Bad: 6.12.54-rc1

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Test regression: 6.12.54-rc1 Internal error: Oops: mnt_ns_release
__arm64_sys_listmount (fs/namespace.c:5526)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

### LTP syscalls failures:
    ltp-syscalls/listmount04
    ltp-syscalls/madvise06
    ltp-syscalls/sendmsg03
    ltp-syscalls/sendto03
    ltp-syscalls/setsockopt05
    ltp-syscalls/setsockopt09
    ltp-syscalls/timerfd_settime02
    ltp-syscalls/wait403
    ltp-containers/userns08


### LTP test log listmount04
[ 3587.449309] <LAVA_SIGNAL_STARTTC listmount04>
Received signal: <STARTTC> listmount04
tst_buffers.c:57: TINFO: Test is using guarded buffers
tst_test.c:2021: TINFO: LTP version: 20250930
tst_test.c:2024: TINFO: Tested kernel: 6.12.54-rc1 #1 SMP PREEMPT
@1760715935 aarch64
tst_kconfig.c:88: TINFO: Parsing kernel config '/proc/config.gz'
tst_kconfig.c:676: TINFO: CONFIG_TRACE_IRQFLAGS kernel option detected
which might slow the execution
tst_test.c:1842: TINFO: Overall timeout per run is 0h 21m 36s
[ 3587.464366] <LAVA_SIGNAL_ENDTC listmount04>
Received signal: <ENDTC> listmount04
tst_test.c:1920: TBROK: Test killed by SIGSEGV!
Summary:
passed   0
failed   0
broken   1
skipped  0
warnings 0
[ 3587.523917] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=listmount04 RESULT=fail>


### Test cash log
listmount04: [ 1440.660118] /usr/local/bin/kirk[418]: listmount04:
start (command: listmount04)
[ 1440.761870] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000080
[ 1440.762768] Mem abort info:
[ 1440.763156]   ESR = 0x0000000096000004
[ 1440.763722]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1440.764204]   SET = 0, FnV = 0
[ 1440.764486]   EA = 0, S1PTW = 0
[ 1440.764883]   FSC = 0x04: level 0 translation fault
[ 1440.765393] Data abort info:
[ 1440.765795]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[ 1440.766288]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[ 1440.766738]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ 1440.767213] user pgtable: 4k pages, 48-bit VAs, pgdp=000000000d4c1000
[ 1440.767819] [0000000000000080] pgd=0000000000000000, p4d=0000000000000000
[ 1440.768448] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[ 1440.769002] Modules linked in: tun overlay btrfs xor xor_neon
raid6_pq zstd_compress libcrc32c snd_soc_hdmi_codec hantro_vpu
dw_hdmi_cec dw_hdmi_i2s_audio brcmfmac rockchipdrm v4l2_h264
dw_mipi_dsi v4l2_vp9 hci_uart brcmutil analogix_dp crct10dif_ce btqca
v4l2_jpeg panfrost dw_hdmi v4l2_mem2mem btbcm snd_soc_simple_card
snd_soc_audio_graph_card snd_soc_spdif_tx cec gpu_sched
snd_soc_simple_card_utils bluetooth cfg80211 drm_display_helper
videobuf2_v4l2 drm_shmem_helper snd_soc_rockchip_i2s
videobuf2_dma_contig pwrseq_core phy_rockchip_pcie drm_dma_helper
rtc_rk808 videobuf2_memops drm_kms_helper videobuf2_common rfkill
snd_soc_es8316 rockchip_saradc industrialio_triggered_buffer
rockchip_thermal kfifo_buf pcie_rockchip_host coresight_cpu_debug drm
fuse backlight ip_tables x_tables
[ 1440.775190] CPU: 3 UID: 0 PID: 131415 Comm: listmount04 Not tainted
6.12.54-rc1 #1
[ 1440.775866] Hardware name: Radxa ROCK Pi 4B (DT)
[ 1440.776277] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 1440.776893] pc : mnt_ns_release
(arch/arm64/include/asm/atomic_ll_sc.h:96
arch/arm64/include/asm/atomic.h:51
include/linux/atomic/atomic-arch-fallback.h:944
include/linux/atomic/atomic-instrumented.h:401
include/linux/refcount.h:264 include/linux/refcount.h:307
include/linux/refcount.h:325 fs/namespace.c:156)
[ 1440.777267] lr : __arm64_sys_listmount (fs/namespace.c:?
fs/namespace.c:5569 fs/namespace.c:5526 fs/namespace.c:5526)
[ 1440.777694] sp : ffff80008d663d30
[ 1440.777987] x29: ffff80008d663d30 x28: ffff0000bba30000 x27: 0000000000000000
[ 1440.778622] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[ 1440.779256] x23: 0000000000000000 x22: 0000000000000020 x21: fffffffffffffff2
[ 1440.779890] x20: 0000000000000100 x19: 0000aaaab5ee1110 x18: 0000000000000000
[ 1440.780524] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[ 1440.781158] x14: 0000000000000000 x13: ffff80008d660000 x12: ffff80008d664000
[ 1440.781791] x11: 0000000000000000 x10: 0000000000000001 x9 : ffff80008044cdf0
[ 1440.782425] x8 : 0000000000000080 x7 : 0000000000000000 x6 : 0000000000000000
[ 1440.783059] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff80008d663e00
[ 1440.783692] x2 : ffff800081700c70 x1 : ffff80008d663d50 x0 : 0000000000000000
[ 1440.784326] Call trace:
[ 1440.784545]  mnt_ns_release
(arch/arm64/include/asm/atomic_ll_sc.h:96
arch/arm64/include/asm/atomic.h:51
include/linux/atomic/atomic-arch-fallback.h:944
include/linux/atomic/atomic-instrumented.h:401
include/linux/refcount.h:264 include/linux/refcount.h:307
include/linux/refcount.h:325 fs/namespace.c:156)
[ 1440.784882]  __arm64_sys_listmount (fs/namespace.c:?
fs/namespace.c:5569 fs/namespace.c:5526 fs/namespace.c:5526)
[ 1440.785278]  invoke_syscall (arch/arm64/kernel/syscall.c:50)
[ 1440.785618]  el0_svc_common (include/linux/thread_info.h:127
arch/arm64/kernel/syscall.c:140)
[ 1440.785948]  do_el0_svc (arch/arm64/kernel/syscall.c:152)
[ 1440.786247]  el0_svc (arch/arm64/kernel/entry-common.c:165)
[ 1440.786524]  el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:789)
[ 1440.786904]  el0t_64_sync (arch/arm64/kernel/entry.S:598)
[ 1440.787238] Code: aa1303e0 14000019 5280002a f9800111 (885f7d09)
All code
========
   0: aa1303e0 mov x0, x19
   4: 14000019 b 0x68
   8: 5280002a mov w10, #0x1                    // #1
   c: f9800111 prfm pstl1strm, [x8]
  10:* 885f7d09 ldxr w9, [x8] <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0: 885f7d09 ldxr w9, [x8]
[ 1440.787776] ---[ end trace 0000000000000000 ]---


## Lore link,
[1] https://lore.kernel.org/all/CA+G9fYueO8kP8mXVNmbHkyrFPKpt-onPfeyNXLuLGGjiO1WFfQ@mail.gmail.com/
[2] https://lore.kernel.org/all/20251017145215.505418259@linuxfoundation.org/

## Build
* kernel: 6.12.54-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 6122296b30b695962026ca4d1b434cae639373e0
* git describe: v6.12.53-278-g6122296b30b6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.53-278-g6122296b30b6

## Build
* Test log: https://lkft.validation.linaro.org/scheduler/job/8496757#L6787
* Test details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.53-278-g6122296b30b6/log-parser-test/internal-error-oops-Oops_PREEMPT_SMP__mnt_ns_release-064d7f50/
* Build plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/34CRZ9uzNjZKMeKVqBaBBIUC2Z9
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/34CRXmuzdt1HaZluq4cBw4zG4lh/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/34CRXmuzdt1HaZluq4cBw4zG4lh/config

--
Linaro LKFT
