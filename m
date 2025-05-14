Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC5B27E7E1
	for <patches@lists.linux.dev>; Wed, 14 May 2025 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747242413; cv=none; b=tFKCpl4Nea0AyDEDbIt7rao0CReoo6DJFwBwDz8UKqX61UIdpyq07KWNLP+e+CcrsjGEARVPbJonvAirKlWjB/TBZE6cd7wbWTIPX0vyrG/gAtn8AS7CP3J4yh5tK5wAL8lwRdFQpqNqRFZkH2CbTDgT28rBgbLx6D9xZP2CBu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747242413; c=relaxed/simple;
	bh=4ZcNJ1/Kj6qOCqVHS5T59S4CICHm0I1/inrMIZtN+Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D0SBuasAap7Pysho49CQyfsMXItoWTOgO+IFqVRRzbVirZSK4Qma+hBiMS5u9ON4HMx9DH4AMRenMRAg32MMd7dIhBNnPG/NYRKvK1cVFic26crKZ8jAkjokh3oLZlR6vdkjlBuaPICwFO8VXVIzPu2cXr1ZrScHDHlMZ9l1ZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=klHhVZdC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="klHhVZdC"
Received: from [100.65.162.40] (unknown [20.236.10.66])
	by linux.microsoft.com (Postfix) with ESMTPSA id B028D211B7C9;
	Wed, 14 May 2025 10:06:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B028D211B7C9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1747242411;
	bh=f0gMxV/ZQZV4bqhupc6f6zi9Hhwn8hX16kXnhneAKhY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=klHhVZdCD4nU7GjQqdb9O6705X/D448NP7WFkU1CpKfTnVEQqqM7VghcjUMWZlSW0
	 srvmFe9l93WzbhrqsgVNc+Pnrgh9NKKoKokx2giufkmeX7LUjFnPSK2hpst5zmE/NR
	 s9Q4vCKHlAprNS8SM3UxIDQWigtOrleh2qlrgctA=
Message-ID: <12a44a1e-8246-4a08-991b-935450bf2dfa@linux.microsoft.com>
Date: Wed, 14 May 2025 10:06:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172027.691520737@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The kernel, bpf tool and perf tool builds fine for v6.6.91-rc1 on x86
and arm64 Azure VM.

KernelCI with LTP and kselftest results: dashboard 
<https://dashboard.kernelci.org/tree/9c2dd8954dad0430e83ee55b985ba55070e50cf7?o=microsoft&p=t&ti%7Cc=v6.6.90&ti%7Cch=9c2dd8954dad0430e83ee55b985ba55070e50cf7&ti%7Cgb=linux-6.6.y&ti%7Cgu=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fstable%2Flinux.git&ti%7Ct=stable>


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik

On 5/12/2025 10:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
>      Linux 6.6.91-rc1
>
> Peter Zijlstra <peterz@infradead.org>
>      x86/its: Use dynamic thunks for indirect branches
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/ibt: Keep IBT disabled during alternative patching
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Align RETs in BHB clear sequence to avoid thunking
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/its: Add support for RSB stuffing mitigation
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
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/bhi: Do not set BHI_DIS_S in 32-bit mode
>
> Daniel Sneddon <daniel.sneddon@linux.intel.com>
>      x86/bpf: Add IBHF call at end of classic BPF
>
> Daniel Sneddon <daniel.sneddon@linux.intel.com>
>      x86/bpf: Call branch history clearing sequence on exit
>
> James Morse <james.morse@arm.com>
>      arm64: proton-pack: Add new CPUs 'k' values for branch mitigation
>
> James Morse <james.morse@arm.com>
>      arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users
>
> James Morse <james.morse@arm.com>
>      arm64: bpf: Add BHB mitigation to the epilogue for cBPF programs
>
> James Morse <james.morse@arm.com>
>      arm64: proton-pack: Expose whether the branchy loop k value
>
> James Morse <james.morse@arm.com>
>      arm64: proton-pack: Expose whether the platform is mitigated by firmware
>
> James Morse <james.morse@arm.com>
>      arm64: insn: Add support for encoding DSB
>
> Jens Axboe <axboe@kernel.dk>
>      io_uring: ensure deferred completions are posted for multishot
>
> Jens Axboe <axboe@kernel.dk>
>      io_uring: always arm linked timeouts prior to issue
>
> Al Viro <viro@zeniv.linux.org.uk>
>      do_umount(): add missing barrier before refcount checks in sync case
>
> Daniel Wagner <wagi@kernel.org>
>      nvme: unblock ctrl state transition for firmware update
>
> Kevin Baker <kevinb@ventureresearch.com>
>      drm/panel: simple: Update timings for AUO G101EVN010
>
> Thorsten Blum <thorsten.blum@linux.dev>
>      MIPS: Fix MAX_REG_OFFSET
>
> Marco Crivellari <marco.crivellari@suse.com>
>      MIPS: Move r4k_wait() to .cpuidle.text section
>
> Marco Crivellari <marco.crivellari@suse.com>
>      MIPS: Fix idle VS timer enqueue
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: adc: dln2: Use aligned_s64 for timestamp
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: accel: adxl355: Make timestamp 64-bit aligned using aligned_s64
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>      types: Complement the aligned types with signed 64-bit one
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: temp: maxim-thermocouple: Fix potential lack of DMA safe buffer.
>
> Lothar Rubusch <l.rubusch@gmail.com>
>      iio: accel: adxl367: fix setting odr for activity time update
>
> Dave Penkler <dpenkler@gmail.com>
>      usb: usbtmc: Fix erroneous generic_read ioctl return
>
> Dave Penkler <dpenkler@gmail.com>
>      usb: usbtmc: Fix erroneous wait_srq ioctl return
>
> Dave Penkler <dpenkler@gmail.com>
>      usb: usbtmc: Fix erroneous get_stb ioctl error returns
>
> Oliver Neukum <oneukum@suse.com>
>      USB: usbtmc: use interruptible sleep in usbtmc_read
>
> Andrei Kuchynski <akuchynski@chromium.org>
>      usb: typec: ucsi: displayport: Fix NULL pointer access
>
> RD Babiera <rdbabiera@google.com>
>      usb: typec: tcpm: delay SNK_TRY_WAIT_DEBOUNCE to SRC_TRYWAIT transition
>
> Jim Lin <jilin@nvidia.com>
>      usb: host: tegra: Prevent host controller crash when OTG port is used
>
> Prashanth K <prashanth.k@oss.qualcomm.com>
>      usb: gadget: Use get_status callback to set remote wakeup capability
>
> Wayne Chang <waynec@nvidia.com>
>      usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN
>
> Prashanth K <prashanth.k@oss.qualcomm.com>
>      usb: gadget: f_ecm: Add get_status callback
>
> Pawel Laszczak <pawell@cadence.com>
>      usb: cdnsp: fix L1 resume issue for RTL_REVISION_NEW_LPM version
>
> Pawel Laszczak <pawell@cadence.com>
>      usb: cdnsp: Fix issue with resuming from L1
>
> Jan Kara <jack@suse.cz>
>      ocfs2: stop quota recovery before disabling quotas
>
> Jan Kara <jack@suse.cz>
>      ocfs2: implement handshaking with ocfs2 recovery thread
>
> Jan Kara <jack@suse.cz>
>      ocfs2: switch osb->disable_recovery to enum
>
> Borislav Petkov (AMD) <bp@alien8.de>
>      x86/microcode: Consolidate the loader enablement checking
>
> Dmitry Antipov <dmantipov@yandex.ru>
>      module: ensure that kobject_put() is safe for module type kobjects
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>      clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()
>
> Jason Andryuk <jason.andryuk@amd.com>
>      xenbus: Use kref to track req lifetime
>
> John Ernberg <john.ernberg@actia.se>
>      xen: swiotlb: Use swiotlb bouncing if kmalloc allocation demands it
>
> Paul Aurich <paul@darkrain42.org>
>      smb: client: Avoid race in open_cached_dir with lease breaks
>
> Alexey Charkov <alchark@gmail.com>
>      usb: uhci-platform: Make the clock really optional
>
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu/hdp6: use memcfg register to post the write for HDP flush
>
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu/hdp5: use memcfg register to post the write for HDP flush
>
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu/hdp5.2: use memcfg register to post the write for HDP flush
>
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu/hdp4: use memcfg register to post the write for HDP flush
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Copy AUX read reply data whenever length > 0
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Fix wrong handling for AUX_DEFER case
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Remove incorrect checking in dmub aux handler
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Fix the checking condition in dmub aux handling
>
> Aurabindo Pillai <aurabindo.pillai@amd.com>
>      drm/amd/display: more liberal vmin/vmax update for freesync
>
> Maíra Canal <mcanal@igalia.com>
>      drm/v3d: Add job to pending list if the reset was skipped
>
> Silvano Seva <s.seva@4sigma.it>
>      iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_tagged_fifo
>
> Silvano Seva <s.seva@4sigma.it>
>      iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      iio: adis16201: Correct inclinometer channel resolution
>
> Simon Xue <xxm@rock-chips.com>
>      iio: adc: rockchip: Fix clock initialization sequence
>
> Angelo Dureghello <adureghello@baylibre.com>
>      iio: adc: ad7606: fix serial register access
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Shift DMUB AUX reply command if necessary
>
> Dave Hansen <dave.hansen@linux.intel.com>
>      x86/mm: Eliminate window where TLB flushes may be inadvertently skipped
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      staging: axis-fifo: Correct handling of tx_fifo_depth for size validation
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      staging: axis-fifo: Remove hardware resets for user errors
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      staging: iio: adc: ad7816: Correct conditional logic for store mode
>
> Aditya Garg <gargaditya08@live.com>
>      Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5
>
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>      Input: synaptics - enable SMBus for HP Elitebook 850 G1
>
> Aditya Garg <gargaditya08@live.com>
>      Input: synaptics - enable InterTouch on Dell Precision M3800
>
> Aditya Garg <gargaditya08@live.com>
>      Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
>
> Manuel Fombuena <fombuena@outlook.com>
>      Input: synaptics - enable InterTouch on Dynabook Portege X30-D
>
> Vicki Pfau <vi@endrift.com>
>      Input: xpad - fix two controller table values
>
> Lode Willems <me@lodewillems.com>
>      Input: xpad - add support for 8BitDo Ultimate 2 Wireless Controller
>
> Vicki Pfau <vi@endrift.com>
>      Input: xpad - fix Share button on Xbox One controllers
>
> Gary Bisson <bisson.gary@gmail.com>
>      Input: mtk-pmic-keys - fix possible null pointer dereference
>
> Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>
>      Input: cyttsp5 - fix power control issue on wakeup
>
> Hugo Villeneuve <hvilleneuve@dimonoff.com>
>      Input: cyttsp5 - ensure minimum reset pulse width
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix learning on VLAN unaware bridges
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: always rejoin default untagged VLAN on bridge leave
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix VLAN ID for untagged vlan on bridge leave
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix flushing old pvid VLAN on pvid change
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix clearing PVID of a port
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: allow leaky reserved multicast
>
> Paul Chaignon <paul.chaignon@gmail.com>
>      bpf: Scrub packet on bpf_redirect_peer
>
> Jozsef Kadlecsik <kadlec@netfilter.org>
>      netfilter: ipset: fix region locking in hash types
>
> Julian Anastasov <ja@ssi.bg>
>      ipvs: fix uninit-value for saddr in do_output_route4
>
> Oliver Hartkopp <socketcan@hartkopp.net>
>      can: gw: fix RCU/BH usage in cgw_create_job()
>
> Kelsey Maes <kelsey@vpprocess.com>
>      can: mcp251xfd: fix TDC setting for low data bit rates
>
> Daniel Golle <daniel@makrotopia.org>
>      net: ethernet: mtk_eth_soc: reset all TX queues on DMA free
>
> Alexander Lobakin <aleksander.lobakin@intel.com>
>      netdevice: add netdev_tx_reset_subqueue() shorthand
>
> Guillaume Nault <gnault@redhat.com>
>      gre: Fix again IPv6 link-local address generation.
>
> Cong Wang <xiyou.wangcong@gmail.com>
>      sch_htb: make htb_deactivate() idempotent
>
> Wang Zhaolong <wangzhaolong1@huawei.com>
>      ksmbd: fix memory leak in parse_lease_state()
>
> Eelco Chaudron <echaudro@redhat.com>
>      openvswitch: Fix unsafe attribute parsing in output_userspace()
>
> Sean Heelan <seanheelan@gmail.com>
>      ksmbd: Fix UAF in __close_file_table_ids
>
> Norbert Szetei <norbert@doyensec.com>
>      ksmbd: prevent out-of-bounds stream writes by validating *pos
>
> Namjae Jeon <linkinjeon@kernel.org>
>      ksmbd: prevent rename with empty string
>
> Marc Kleine-Budde <mkl@pengutronix.de>
>      can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls
>
> Veerendranath Jakkam <quic_vjakkam@quicinc.com>
>      wifi: cfg80211: fix out-of-bounds access during multi-link element defragmentation
>
> Marc Kleine-Budde <mkl@pengutronix.de>
>      can: mcan: m_can_class_unregister(): fix order of unregistration calls
>
> Wojciech Dubowik <Wojciech.Dubowik@mt.com>
>      arm64: dts: imx8mm-verdin: Link reg_usdhc2_vqmmc to usdhc2
>
> Dan Carpenter <dan.carpenter@linaro.org>
>      dm: add missing unlock on in dm_keyslot_evict()
>
>
> -------------
>
> Diffstat:
>
>   Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
>   Documentation/admin-guide/hw-vuln/index.rst        |   1 +
>   .../hw-vuln/indirect-target-selection.rst          | 168 +++++++++++++++++
>   Documentation/admin-guide/kernel-parameters.txt    |  18 ++
>   Makefile                                           |   4 +-
>   arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |  25 ++-
>   arch/arm64/include/asm/cputype.h                   |   2 +
>   arch/arm64/include/asm/insn.h                      |   1 +
>   arch/arm64/include/asm/spectre.h                   |   3 +
>   arch/arm64/kernel/proton-pack.c                    |  13 +-
>   arch/arm64/lib/insn.c                              |  76 ++++----
>   arch/arm64/net/bpf_jit_comp.c                      |  57 +++++-
>   arch/mips/include/asm/idle.h                       |   3 +-
>   arch/mips/include/asm/ptrace.h                     |   3 +-
>   arch/mips/kernel/genex.S                           |  63 ++++---
>   arch/mips/kernel/idle.c                            |   7 -
>   arch/x86/Kconfig                                   |  11 ++
>   arch/x86/entry/entry_64.S                          |  20 ++-
>   arch/x86/include/asm/alternative.h                 |  24 +++
>   arch/x86/include/asm/cpufeatures.h                 |   3 +
>   arch/x86/include/asm/microcode.h                   |   2 +
>   arch/x86/include/asm/msr-index.h                   |   8 +
>   arch/x86/include/asm/nospec-branch.h               |  44 +++--
>   arch/x86/kernel/alternative.c                      | 198 ++++++++++++++++++++-
>   arch/x86/kernel/cpu/bugs.c                         | 178 +++++++++++++++++-
>   arch/x86/kernel/cpu/common.c                       |  72 ++++++--
>   arch/x86/kernel/cpu/microcode/amd.c                |   6 +-
>   arch/x86/kernel/cpu/microcode/core.c               |  60 ++++---
>   arch/x86/kernel/cpu/microcode/intel.c              |   2 +-
>   arch/x86/kernel/cpu/microcode/internal.h           |   1 -
>   arch/x86/kernel/ftrace.c                           |   2 +-
>   arch/x86/kernel/head32.c                           |   4 -
>   arch/x86/kernel/module.c                           |   7 +
>   arch/x86/kernel/static_call.c                      |   4 +-
>   arch/x86/kernel/vmlinux.lds.S                      |  10 ++
>   arch/x86/kvm/x86.c                                 |   4 +-
>   arch/x86/lib/retpoline.S                           |  39 ++++
>   arch/x86/mm/tlb.c                                  |  23 ++-
>   arch/x86/net/bpf_jit_comp.c                        |  61 ++++++-
>   drivers/base/cpu.c                                 |   3 +
>   drivers/clocksource/i8253.c                        |   4 +-
>   drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c              |   7 +-
>   drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c              |   7 +-
>   drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c              |  12 +-
>   drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c              |   7 +-
>   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  36 ++--
>   .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  28 ++-
>   drivers/gpu/drm/panel/panel-simple.c               |  25 +--
>   drivers/gpu/drm/v3d/v3d_sched.c                    |  28 ++-
>   drivers/iio/accel/adis16201.c                      |   4 +-
>   drivers/iio/accel/adxl355_core.c                   |   2 +-
>   drivers/iio/accel/adxl367.c                        |  10 +-
>   drivers/iio/adc/ad7606_spi.c                       |   2 +-
>   drivers/iio/adc/dln2-adc.c                         |   2 +-
>   drivers/iio/adc/rockchip_saradc.c                  |  17 +-
>   drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   6 +
>   drivers/iio/temperature/maxim_thermocouple.c       |   2 +-
>   drivers/input/joystick/xpad.c                      |  40 +++--
>   drivers/input/keyboard/mtk-pmic-keys.c             |   4 +-
>   drivers/input/mouse/synaptics.c                    |   5 +
>   drivers/input/touchscreen/cyttsp5.c                |   7 +-
>   drivers/md/dm-table.c                              |   3 +-
>   drivers/net/can/m_can/m_can.c                      |   2 +-
>   drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  42 ++++-
>   drivers/net/dsa/b53/b53_common.c                   |  36 ++--
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  16 +-
>   drivers/nvme/host/core.c                           |   3 +-
>   drivers/staging/axis-fifo/axis-fifo.c              |  14 +-
>   drivers/staging/iio/adc/ad7816.c                   |   2 +-
>   drivers/usb/cdns3/cdnsp-gadget.c                   |  31 ++++
>   drivers/usb/cdns3/cdnsp-gadget.h                   |   6 +
>   drivers/usb/cdns3/cdnsp-pci.c                      |  12 +-
>   drivers/usb/cdns3/cdnsp-ring.c                     |   3 +-
>   drivers/usb/cdns3/core.h                           |   3 +
>   drivers/usb/class/usbtmc.c                         |  59 +++---
>   drivers/usb/gadget/composite.c                     |  12 +-
>   drivers/usb/gadget/function/f_ecm.c                |   7 +
>   drivers/usb/gadget/udc/tegra-xudc.c                |   4 +
>   drivers/usb/host/uhci-platform.c                   |   2 +-
>   drivers/usb/host/xhci-tegra.c                      |   3 +
>   drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
>   drivers/usb/typec/ucsi/displayport.c               |   2 +
>   drivers/xen/swiotlb-xen.c                          |   1 +
>   drivers/xen/xenbus/xenbus.h                        |   2 +
>   drivers/xen/xenbus/xenbus_comms.c                  |   9 +-
>   drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
>   drivers/xen/xenbus/xenbus_xs.c                     |  18 +-
>   fs/namespace.c                                     |   3 +-
>   fs/ocfs2/journal.c                                 |  80 ++++++---
>   fs/ocfs2/journal.h                                 |   1 +
>   fs/ocfs2/ocfs2.h                                   |  17 +-
>   fs/ocfs2/quota_local.c                             |   9 +-
>   fs/ocfs2/super.c                                   |   3 +
>   fs/smb/client/cached_dir.c                         |  10 +-
>   fs/smb/server/oplock.c                             |   7 +-
>   fs/smb/server/smb2pdu.c                            |   5 +
>   fs/smb/server/vfs.c                                |   7 +
>   fs/smb/server/vfs_cache.c                          |  33 +++-
>   include/linux/cpu.h                                |   2 +
>   include/linux/module.h                             |   5 +
>   include/linux/netdevice.h                          |  13 +-
>   include/linux/types.h                              |   3 +-
>   include/uapi/linux/types.h                         |   1 +
>   io_uring/io_uring.c                                |  61 +++----
>   kernel/params.c                                    |   4 +-
>   net/can/gw.c                                       | 151 +++++++++-------
>   net/core/filter.c                                  |   1 +
>   net/ipv6/addrconf.c                                |  15 +-
>   net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
>   net/netfilter/ipvs/ip_vs_xmit.c                    |  27 +--
>   net/openvswitch/actions.c                          |   3 +-
>   net/sched/sch_htb.c                                |  15 +-
>   net/wireless/scan.c                                |   2 +-
>   113 files changed, 1733 insertions(+), 529 deletions(-)
>
>
