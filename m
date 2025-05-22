Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0581A23B7
	for <patches@lists.linux.dev>; Thu, 22 May 2025 05:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747890548; cv=none; b=fh5dmsaVHH8SnR/nrAvebnS8geKu792j5nBuh/UK/8oICo39zJ9nwme3eMsMJ70U9lKyvmFLa+cQJWjjZP+S6DrwMhii4s2p9+Is/JNqrDLQCWN7nD+JB4WdhihHLAAFsK0FnatVHb5hAPKjz7H3ri21guO6lRPj7z81ME7Kuvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747890548; c=relaxed/simple;
	bh=gGZTipmAKXzX+moHmjPTB2xHvtEe5/IKeDIsVCYi5CY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eLJwEISwLN4EZWL9h7eSHm/0AisTM9Lpd/5Ao/a0/csVpBrM/dWRsYwVEpDrDoX6W+lkdNjD6XBhO/izNg2hO/DsR9zsLWIzR/7T/WJ40YvbwlYa9HGkjP+m0a5d6tPXy+NvBcbiDlFxuEbYf0Vq8QRyunmOF23+i7ZSdihCxWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iHB+peuA; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iHB+peuA"
Received: from [100.65.232.110] (unknown [20.236.11.185])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7FC71206833E;
	Wed, 21 May 2025 22:09:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7FC71206833E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1747890546;
	bh=/qom+kgHnHDaVvu41DqXCUUW/JHiOPJQLRfO2jyC1nU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iHB+peuAZfFEKgSkaNDiVJZ5NL0JU5on9ywq1GWKaf8waaRR79TIo0XqLPaDzaGdI
	 S2ZI0C15/afa5TJ/TcPjAm5S2emodArNbYdMmxZ0KcB5mLaUL4Hl3xiT6VTURTlgXk
	 13NrCplNW3YR23amCaxCAIvfj3LnUbYBVrp2rq7I=
Message-ID: <220d6669-7087-4ee9-80d7-89a968f46771@linux.microsoft.com>
Date: Wed, 21 May 2025 22:09:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125753.836407405@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v5.15.184-rc1 on x86
and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik

On 5/20/2025 6:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 5.15.184-rc1
>
> Alexander Lobakin <alexandr.lobakin@intel.com>
>      ice: arfs: fix use-after-free when freeing @rx_cpu_rmap
>
> Florian Westphal <fw@strlen.de>
>      netfilter: nf_tables: do not defer rule destruction via call_rcu
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>      netfilter: nf_tables: wait for rcu grace period on net_device removal
>
> Florian Westphal <fw@strlen.de>
>      netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
>
> Josef Bacik <josef@toxicpanda.com>
>      btrfs: do not clean up repair bio if submit fails
>
> Filipe Manana <fdmanana@suse.com>
>      btrfs: don't BUG_ON() when 0 reference count at btrfs_lookup_extent_info()
>
> Eric Dumazet <edumazet@google.com>
>      sctp: add mutual exclusion in proc_sctp_do_udp_port()
>
> Feng Tang <feng.tang@linux.alibaba.com>
>      selftests/mm: compaction_test: support platform with huge mount of memory
>
> GONG Ruiqi <gongruiqi1@huawei.com>
>      usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()
>
> Dan Carpenter <dan.carpenter@linaro.org>
>      usb: typec: fix potential array underflow in ucsi_ccg_sync_control()
>
> RD Babiera <rdbabiera@google.com>
>      usb: typec: altmodes/displayport: create sysfs nodes as driver's default device attribute group
>
> Andrei Kuchynski <akuchynski@chromium.org>
>      usb: typec: ucsi: displayport: Fix deadlock
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>      clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()
>
> Fengnan Chang <changfengnan@bytedance.com>
>      block: fix direct io NOWAIT flag not work
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_groups
>
> Shuai Xue <xueshuai@linux.alibaba.com>
>      dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
>
> Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
>      dmaengine: ti: k3-udma: Use cap_mask directly from dma_device structure instead of a local copy
>
> Ronald Wahl <ronald.wahl@legrand.com>
>      dmaengine: ti: k3-udma: Add missing locking
>
> Fedor Pchelkin <pchelkin@ispras.ru>
>      wifi: mt76: disable napi on driver removal
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>      phy: renesas: rcar-gen3-usb2: Set timing registers only once
>
> Ma Ke <make24@iscas.ac.cn>
>      phy: Fix error handling in tegra_xusb_port_init
>
> Steven Rostedt <rostedt@goodmis.org>
>      tracing: samples: Initialize trace_array_printk() with the correct function
>
> pengdonglin <pengdonglin@xiaomi.com>
>      ftrace: Fix preemption accounting for stacktrace filter command
>
> pengdonglin <pengdonglin@xiaomi.com>
>      ftrace: Fix preemption accounting for stacktrace trigger command
>
> Nicolas Chauvet <kwizart@gmail.com>
>      ALSA: usb-audio: Add sample rate quirk for Microdia JP001 USB Camera
>
> Christian Heusel <christian@heusel.eu>
>      ALSA: usb-audio: Add sample rate quirk for Audioengine D1
>
> Wentao Liang <vulab@iscas.ac.cn>
>      ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()
>
> Jeremy Linton <jeremy.linton@arm.com>
>      ACPI: PPTT: Fix processor subtable walk
>
> Filipe Manana <fdmanana@suse.com>
>      btrfs: fix discard worker infinite loop after disabling discard
>
> Nathan Lynch <nathan.lynch@amd.com>
>      dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"
>
> Peter Zijlstra <peterz@infradead.org>
>      x86/its: FineIBT-paranoid vs ITS
>
> Eric Biggers <ebiggers@google.com>
>      x86/its: Fix build errors when CONFIG_MODULES=n
>
> Peter Zijlstra <peterz@infradead.org>
>      x86/its: Use dynamic thunks for indirect branches
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Align RETs in BHB clear sequence to avoid thunking
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Add "vmexit" option to skip mitigation on some CPUs
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Enable Indirect Target Selection mitigation
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Add support for ITS-safe return thunk
>
> Josh Poimboeuf <jpoimboe@kernel.org>
>      x86/alternatives: Remove faulty optimization
>
> Borislav Petkov (AMD) <bp@alien8.de>
>      x86/alternative: Optimize returns patching
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Add support for ITS-safe indirect thunk
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Enumerate Indirect Target Selection (ITS) bug
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      Documentation: x86/bugs/its: Add ITS documentation
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/speculation: Remove the extra #ifdef around CALL_NOSPEC
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/speculation: Add a conditional CS prefix to CALL_NOSPEC
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/speculation: Simplify and make CALL_NOSPEC consistent
>
> Peter Zijlstra <peterz@infradead.org>
>      x86,nospec: Simplify {JMP,CALL}_NOSPEC
>
> Trond Myklebust <trond.myklebust@hammerspace.com>
>      NFSv4/pnfs: Reset the layout state after a layoutreturn
>
> Abdun Nihaal <abdun.nihaal@gmail.com>
>      qlcnic: fix memory leak in qlcnic_sriov_channel_cfg_cmd()
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>      ALSA: sh: SND_AICA should depend on SH_DMA_API
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>      net: dsa: sja1105: discard incoming frames in BR_STATE_LISTENING
>
> Mathieu Othacehe <othacehe@gnu.org>
>      net: cadence: macb: Fix a possible deadlock in macb_halt_tx.
>
> Cong Wang <xiyou.wangcong@gmail.com>
>      net_sched: Flush gso_skb list too during ->change()
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>      spi: loopback-test: Do not split 1024-byte hexdumps
>
> Li Lingfeng <lilingfeng3@huawei.com>
>      nfs: handle failure of nfs_get_lock_context in unlock path
>
> Zhu Yanjun <yanjun.zhu@linux.dev>
>      RDMA/rxe: Fix slab-use-after-free Read in rxe_queue_cleanup bug
>
> David Lechner <dlechner@baylibre.com>
>      iio: chemical: sps30: use aligned_s64 for timestamp
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: adc: ad7768-1: Fix insufficient alignment of timestamp.
>
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
>      tracing: probes: Fix a possible race in trace_probe_log APIs
>
> Hans de Goede <hdegoede@redhat.com>
>      platform/x86: asus-wmi: Fix wlan_ctrl_by_user detection
>
>
> -------------
>
> Diffstat:
>
>   Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
>   Documentation/admin-guide/hw-vuln/index.rst        |   1 +
>   .../hw-vuln/indirect-target-selection.rst          | 156 +++++++++++++
>   Documentation/admin-guide/kernel-parameters.txt    |  15 ++
>   Makefile                                           |   4 +-
>   arch/x86/Kconfig                                   |  11 +
>   arch/x86/entry/entry_64.S                          |  20 +-
>   arch/x86/include/asm/alternative.h                 |  32 +++
>   arch/x86/include/asm/cpufeatures.h                 |   3 +
>   arch/x86/include/asm/msr-index.h                   |   8 +
>   arch/x86/include/asm/nospec-branch.h               |  57 +++--
>   arch/x86/kernel/alternative.c                      | 243 ++++++++++++++++++++-
>   arch/x86/kernel/cpu/bugs.c                         | 139 +++++++++++-
>   arch/x86/kernel/cpu/common.c                       |  63 +++++-
>   arch/x86/kernel/ftrace.c                           |   2 +-
>   arch/x86/kernel/module.c                           |   7 +
>   arch/x86/kernel/static_call.c                      |   2 +-
>   arch/x86/kernel/vmlinux.lds.S                      |  10 +
>   arch/x86/kvm/x86.c                                 |   4 +-
>   arch/x86/lib/retpoline.S                           |  39 ++++
>   arch/x86/net/bpf_jit_comp.c                        |   8 +-
>   block/fops.c                                       |   5 +-
>   drivers/acpi/pptt.c                                |  11 +-
>   drivers/base/cpu.c                                 |   8 +
>   drivers/clocksource/i8253.c                        |   6 +-
>   drivers/dma/dmatest.c                              |   6 +-
>   drivers/dma/idxd/init.c                            |   8 +
>   drivers/dma/ti/k3-udma.c                           |  10 +-
>   drivers/iio/adc/ad7768-1.c                         |   2 +-
>   drivers/iio/chemical/sps30.c                       |   2 +-
>   drivers/infiniband/sw/rxe/rxe_cq.c                 |   5 +-
>   drivers/net/dsa/sja1105/sja1105_main.c             |   6 +-
>   drivers/net/ethernet/cadence/macb_main.c           |  19 +-
>   drivers/net/ethernet/intel/ice/ice_arfs.c          |   9 +-
>   drivers/net/ethernet/intel/ice/ice_lib.c           |   5 +-
>   drivers/net/ethernet/intel/ice/ice_main.c          |  20 +-
>   .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   7 +-
>   drivers/net/wireless/mediatek/mt76/dma.c           |   1 +
>   drivers/phy/renesas/phy-rcar-gen3-usb2.c           |   7 +-
>   drivers/phy/tegra/xusb.c                           |   8 +-
>   drivers/platform/x86/asus-wmi.c                    |   3 +-
>   drivers/spi/spi-loopback-test.c                    |   2 +-
>   drivers/usb/typec/altmodes/displayport.c           |  18 +-
>   drivers/usb/typec/ucsi/displayport.c               |  19 +-
>   drivers/usb/typec/ucsi/ucsi.c                      |  34 +++
>   drivers/usb/typec/ucsi/ucsi.h                      |   3 +
>   drivers/usb/typec/ucsi/ucsi_ccg.c                  |   5 +
>   fs/btrfs/discard.c                                 |  17 +-
>   fs/btrfs/extent-tree.c                             |  25 ++-
>   fs/btrfs/extent_io.c                               |  15 +-
>   fs/nfs/nfs4proc.c                                  |   9 +-
>   fs/nfs/pnfs.c                                      |   9 +
>   include/linux/cpu.h                                |   2 +
>   include/linux/module.h                             |   5 +
>   include/net/netfilter/nf_tables.h                  |   2 +-
>   include/net/sch_generic.h                          |  15 ++
>   kernel/trace/trace_dynevent.c                      |  16 +-
>   kernel/trace/trace_dynevent.h                      |   1 +
>   kernel/trace/trace_events_trigger.c                |   2 +-
>   kernel/trace/trace_functions.c                     |   6 +-
>   kernel/trace/trace_kprobe.c                        |   2 +-
>   kernel/trace/trace_probe.c                         |   9 +
>   kernel/trace/trace_uprobe.c                        |   2 +-
>   net/netfilter/nf_tables_api.c                      |  54 +++--
>   net/netfilter/nft_immediate.c                      |   2 +-
>   net/sched/sch_codel.c                              |   2 +-
>   net/sched/sch_fq.c                                 |   2 +-
>   net/sched/sch_fq_codel.c                           |   2 +-
>   net/sched/sch_fq_pie.c                             |   2 +-
>   net/sched/sch_hhf.c                                |   2 +-
>   net/sched/sch_pie.c                                |   2 +-
>   net/sctp/sysctl.c                                  |   4 +
>   samples/ftrace/sample-trace-array.c                |   2 +-
>   sound/pci/es1968.c                                 |   6 +-
>   sound/sh/Kconfig                                   |   2 +-
>   sound/usb/quirks.c                                 |   4 +
>   tools/testing/selftests/vm/compaction_test.c       |  19 +-
>   77 files changed, 1112 insertions(+), 184 deletions(-)
>
>
