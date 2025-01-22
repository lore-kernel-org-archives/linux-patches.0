Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B8418E25
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 13:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737551769; cv=none; b=M5niPEYb75e4NspCOMgziiLQ0dm4qZNTqfDqZQiAr7hMtr5jVNcG7EsdhVl1b5Y9YkkUttmuXyBZeCOmviXNbVp6Ud/KE83/pA+Fq9Y09sK1tdi1jF8dkZlWK1Bcb3ts7h5kvNQyJhE1E3rAS0cd/74fjVlWvpk7s7OPAteP8r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737551769; c=relaxed/simple;
	bh=wEojSraMVtOeiRVPj3JWtoHevJvymxM5EL3m72FiLs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cnuw1NoYvBgTTlwegIS+8HeQg50MhTOMjnEfmWsWU0eaXvrWeAFC1h6uVpLTTKbL63yT6VPVlVGNazip3s/PD5ry0gGrRFrTzpHoVLKUPLJ3ITR/eR3NLSWHJh2mmvZl7DrM/27St2cNu/32AXY0ktZ0gnU8uyzVDjHFq684Eh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+h+RamZ; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+h+RamZ"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2efe25558ddso8900539a91.2
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 05:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737551765; x=1738156565; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9Jh/U9Rlb0tgofzLRhGf/P1sAsmpMdVmhHEnvxDE6g=;
        b=G+h+RamZyX6bCScf2hzb/Axm8J5VVJWUF589RTQKW+/SFfEZxX3Hib8dD6me63HC03
         Z3txB827XiIVr25xJzhVKH6YdvgiO0SPOdC2tRsTCqLxeqWOF3wrTVrDb/B4Qi/J8mY3
         2W+jcl6SKBpnN1gxEzvUxqjILu1yoinQmeYw+QaIp3bI17Vb/oyJJNB7GZhD8uueDQbk
         VSxLCLO0Fq48EpvioKWuV5Jol4KnNTigYrVdWKfNthhbtG630TuJzXwQX4n/tVE9FFRG
         ubpRT/izsT7W0zQImpgcRdAyiS2W+adbsLdfKWpwrBNeQKQwriAMC5/N7GUWUee2dAIK
         yggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737551765; x=1738156565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9Jh/U9Rlb0tgofzLRhGf/P1sAsmpMdVmhHEnvxDE6g=;
        b=RS452s3I3Qk9ULpS0SzySb7ZIdYSOEfCcbTjeNpa7iyS9Z35bqck3QNoIRpSUPzNqL
         4v2Sqjic9PxPkVev9TrwzUhG+s72swlUUOejGqhqo/fEfdVPQ4+qORJzDjY35d5eyDbG
         EpY680GhJAwuAdTND2+NkP9O1xTfvBIdVLeg+UXm67RvFeDWShPXjorfJ4+dqgPC9IeM
         3gooUcASmps3Xn8+WO85isagja1/2Vq59v88L5gFvjYqdlLgfFvZmHxptWMiG7XJyBnQ
         xiuijTDCx5KX39K2T2HkZNKYmK74ewM9CZhR0SMbpJw/nIte4JdYV+cWk2y8xcDlfx06
         fmwQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7CqUUlrCJHBDdRqV6helcp/K6/pVHL7mRPAdZrMV1NHeKVASWqQvfgIUGE4Abqgbo2IlpQVwt@lists.linux.dev
X-Gm-Message-State: AOJu0YxTPyUsx7XCJUuTGC/+CgDDEB0U7EDWouOToe7GEtzQszp6D1fP
	HxZy9nWJN944Q5PXHnP98Kh07IB6HH+vFcuvq20QQcEDexeBIdgwaHT4JRg92EhHbZWmbxOm6Xe
	m+AM/0Bgb4cMl51mQ6N9wP4vFwpo=
X-Gm-Gg: ASbGncuMvATHnxobkH5CBlEX2Nr+JkO9sfm9f1Zkp8yBajq/4yof2qrCi7LsSfjCIw5
	Rx7ZjcXSAB4vWm1E2IkKlX9FUdDBF9uS1OcZ5GyIlrRrlPqJ3BY9zbEuVvjCwEppkMQ==
X-Google-Smtp-Source: AGHT+IFWMvcT+QkvIP1xH/39QSLF0moZDq/F5rwJB86pfW+yPXRAeQHq2ybk5LYQAJVQOLCXDFmjRvTLjj6VSUQVBnw=
X-Received: by 2002:a17:90b:280e:b0:2ee:7c65:ae8e with SMTP id
 98e67ed59e1d1-2f782c700c6mr31665025a91.11.1737551764861; Wed, 22 Jan 2025
 05:16:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250122093007.141759421@linuxfoundation.org>
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 22 Jan 2025 14:15:52 +0100
X-Gm-Features: AbW1kvaFAHuUZpcaFMWS5KDT_m6tDYYZ7gYyInLr3kvePcfBcEzBIDMlDh3f2vE
Message-ID: <CADo9pHigk1FHxtJZ9x4Qt6jvBtM=g=etzQfzbfHPN1qHyO5Xqg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Luna Jernberg <droidbittin@gmail.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Works fine on my Dell OptiPlex 3050 Micro
with: Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
that runs Arch Linux

Testing on this machine this time as my other one is already on 6.13

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den ons 22 jan. 2025 kl 10:30 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.11-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
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
>     Linux 6.12.11-rc2
>
> Ryan Lee <ryan.lee@canonical.com>
>     apparmor: allocate xmatch for nullpdb inside aa_alloc_null
>
> Wayne Lin <Wayne.Lin@amd.com>
>     drm/amd/display: Validate mdoe under MST LCT=3D1 case as well
>
> Nicholas Susanto <Nicholas.Susanto@amd.com>
>     Revert "drm/amd/display: Enable urgent latency adjustments for DCN35"
>
> Leo Li <sunpeng.li@amd.com>
>     drm/amd/display: Do not wait for PSR disable on vbl enable
>
> Tom Chung <chiahsuan.chung@amd.com>
>     drm/amd/display: Disable replay and psr while VRR is enabled
>
> Tom Chung <chiahsuan.chung@amd.com>
>     drm/amd/display: Fix PSR-SU not support but still call the amdgpu_dm_=
psr_enable
>
> Christian K=C3=B6nig <christian.koenig@amd.com>
>     drm/amdgpu: always sync the GFX pipe on ctx switch
>
> Kenneth Feng <kenneth.feng@amd.com>
>     drm/amdgpu: disable gfxoff with the compute workload on gfx12
>
> Gui Chengming <Jack.Gui@amd.com>
>     drm/amdgpu: fix fw attestation for MP0_14_0_{2/3}
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/smu13: update powersave optimizations
>
> Ashutosh Dixit <ashutosh.dixit@intel.com>
>     drm/xe/oa: Add missing VISACTL mux registers
>
> Matthew Brost <matthew.brost@intel.com>
>     drm/xe: Mark ComputeCS read mode as UC on iGPU
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     drm/i915/fb: Relax clear color alignment to 64 bytes
>
> Xin Li (Intel) <xin@zytor.com>
>     x86/fred: Fix the FRED RSP0 MSR out of sync with its per-CPU cache
>
> Frederic Weisbecker <frederic@kernel.org>
>     timers/migration: Enforce group initialization visibility to tree wal=
kers
>
> Frederic Weisbecker <frederic@kernel.org>
>     timers/migration: Fix another race between hotplug and idle entry/exi=
t
>
> Koichiro Den <koichiro.den@canonical.com>
>     hrtimers: Handle CPU state correctly on hotplug
>
> Tomas Krcka <krckatom@amazon.de>
>     irqchip/gic-v3-its: Don't enable interrupts in its_irq_set_vcpu_affin=
ity()
>
> Yogesh Lal <quic_ylal@quicinc.com>
>     irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     irqchip: Plug a OF node reference leak in platform_irqchip_probe()
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: gfp: Fix the GFP enum values shown for user space tracing to=
ols
>
> Donet Tom <donettom@linux.ibm.com>
>     mm: vmscan : pgdemote vmstat is not getting updated when MGLRU is ena=
bled.
>
> Ryan Roberts <ryan.roberts@arm.com>
>     mm: clear uffd-wp PTE/PMD state on mremap()
>
> Leo Li <sunpeng.li@amd.com>
>     drm/amd/display: Do not elevate mem_type change to full update
>
> Ryan Roberts <ryan.roberts@arm.com>
>     selftests/mm: set allocated memory to non-zero content in cow test
>
> Guo Weikang <guoweikang.kernel@gmail.com>
>     mm/kmemleak: fix percpu memory leak detection failure
>
> Xiaolei Wang <xiaolei.wang@windriver.com>
>     pmdomain: imx8mp-blk-ctrl: add missing loop break condition
>
> Suren Baghdasaryan <surenb@google.com>
>     tools: fix atomic_set() definition to set the value correctly
>
> Sean Anderson <sean.anderson@linux.dev>
>     gpio: xilinx: Convert gpio_lock to raw spinlock
>
> Rik van Riel <riel@surriel.com>
>     fs/proc: fix softlockup in __read_vmcore (part 2)
>
> Marco Nelissen <marco.nelissen@gmail.com>
>     filemap: avoid truncating 64-bit offset to 32 bits
>
> Paul Fertser <fercerpav@gmail.com>
>     net/ncsi: fix locking in Get MAC Address handling
>
> Takashi Iwai <tiwai@suse.de>
>     drm/nouveau/disp: Fix missing backlight control on Macbook 5,1
>
> Dave Airlie <airlied@redhat.com>
>     nouveau/fence: handle cross device fences properly
>
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]
>
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock: reset socket state when de-assigning the transport
>
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock/virtio: cancel close work in the destructor
>
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock/virtio: discard packets if the transport changes
>
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock/bpf: return early if transport is not assigned
>
> Heiner Kallweit <hkallweit1@gmail.com>
>     net: ethernet: xgbe: re-add aneg to supported features in PHY quirks
>
> Paolo Abeni <pabeni@redhat.com>
>     selftests: mptcp: avoid spurious errors on disconnect
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: fix spurious wake-up on under memory pressure
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: be sure to send ack when mptcp-level window re-opens
>
> Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
>     i2c: atr: Fix client detach
>
> Kairui Song <kasong@tencent.com>
>     zram: fix potential UAF of zram table
>
> Luke D. Jones <luke@ljones.dev>
>     ALSA: hda/realtek: fixup ASUS H7606W
>
> Luke D. Jones <luke@ljones.dev>
>     ALSA: hda/realtek: fixup ASUS GA605W
>
> Stefan Binding <sbinding@opensource.cirrus.com>
>     ALSA: hda/realtek: Add support for Ayaneo System using CS35L41 HDA
>
> Juergen Gross <jgross@suse.com>
>     x86/asm: Make serialize() always_inline
>
> Peter Zijlstra <peterz@infradead.org>
>     sched/fair: Fix update_cfs_group() vs DELAY_DEQUEUE
>
> Luis Chamberlain <mcgrof@kernel.org>
>     nvmet: propagate npwg topology
>
> Tejun Heo <tj@kernel.org>
>     sched_ext: Fix dsq_local_on selftest
>
> Hongguang Gao <hongguang.gao@broadcom.com>
>     RDMA/bnxt_re: Fix to export port num to ib_query_qp
>
> David Vernet <void@manifault.com>
>     scx: Fix maximal BPF selftest prog
>
> Ihor Solodrai <ihor.solodrai@pm.me>
>     selftests/sched_ext: fix build after renames in sched_ext API
>
> Oleg Nesterov <oleg@redhat.com>
>     poll_wait: add mb() to fix theoretical race between waitqueue_active(=
) and .poll()
>
> Lizhi Xu <lizhi.xu@windriver.com>
>     afs: Fix merge preference rule failure condition
>
> Marco Nelissen <marco.nelissen@gmail.com>
>     iomap: avoid avoid truncating 64-bit offset to 32 bits
>
> Henry Huang <henry.hj@antgroup.com>
>     sched_ext: keep running prev when prev->scx.slice !=3D 0
>
> Hans de Goede <hdegoede@redhat.com>
>     ACPI: resource: acpi_dev_irq_override(): Check DMI match last
>
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>     platform/x86: ISST: Add Clearwater Forest to support list
>
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>     platform/x86/intel: power-domains: Add Clearwater Forest support
>
> Jakub Kicinski <kuba@kernel.org>
>     selftests: tc-testing: reduce rshift value
>
> Koichiro Den <koichiro.den@canonical.com>
>     gpio: sim: lock up configfs that an instantiated device depends on
>
> Koichiro Den <koichiro.den@canonical.com>
>     gpio: virtuser: lock up configfs that an instantiated device depends =
on
>
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>     scsi: ufs: core: Honor runtime/system PM levels if set by host contro=
ller drivers
>
> Max Kellermann <max.kellermann@ionos.com>
>     cachefiles: Parse the "secctx" immediately
>
> David Howells <dhowells@redhat.com>
>     netfs: Fix non-contiguous donation between completed reads
>
> David Howells <dhowells@redhat.com>
>     kheaders: Ignore silly-rename files
>
> Zhang Kunbo <zhangkunbo@huawei.com>
>     fs: fix missing declaration of init_files
>
> Brahmajit Das <brahmajit.xyz@gmail.com>
>     fs/qnx6: Fix building with GCC 15
>
> Leo Stone <leocstone@gmail.com>
>     hfs: Sanity check the root record
>
> Lizhi Xu <lizhi.xu@windriver.com>
>     mac802154: check local interfaces before deleting sdata list
>
> Paulo Alcantara <pc@manguebit.com>
>     smb: client: fix double free of TCP_Server_Info::hostname
>
> David Lechner <dlechner@baylibre.com>
>     hwmon: (ltc2991) Fix mixed signed/unsigned in DIV_ROUND_CLOSEST
>
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>     i2c: testunit: on errors, repeat NACK until STOP
>
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>     i2c: rcar: fix NACK handling when being a target
>
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>     i2c: mux: demux-pinctrl: check initial mux selection, too
>
> Pratyush Yadav <pratyush@kernel.org>
>     Revert "mtd: spi-nor: core: replace dummy buswidth from addr to data"
>
> David Lechner <dlechner@baylibre.com>
>     hwmon: (tmp513) Fix division of negative numbers
>
> Chenyuan Yang <chenyuan0y@gmail.com>
>     platform/x86: lenovo-yoga-tab2-pro-1380-fastcharger: fix serdev race
>
> Chenyuan Yang <chenyuan0y@gmail.com>
>     platform/x86: dell-uart-backlight: fix serdev race
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     i2c: core: fix reference leak in i2c_register_adapter()
>
> MD Danish Anwar <danishanwar@ti.com>
>     soc: ti: pruss: Fix pruss APIs
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     reset: rzg2l-usbphy-ctrl: Assign proper of node to the allocated devi=
ce
>
> Ma=C3=ADra Canal <mcanal@igalia.com>
>     drm/v3d: Ensure job pointer is set to NULL after job completion
>
> Ian Forbes <ian.forbes@broadcom.com>
>     drm/vmwgfx: Add new keep_resv BO param
>
> Ian Forbes <ian.forbes@broadcom.com>
>     drm/vmwgfx: Unreserve BO on error
>
> Yu-Chun Lin <eleanor15x@gmail.com>
>     drm/tests: helpers: Fix compiler warning
>
> Jakub Kicinski <kuba@kernel.org>
>     netdev: avoid CFI problems with sock priv helpers
>
> Leon Romanovsky <leon@kernel.org>
>     net/mlx5e: Always start IPsec sequence number from 1
>
> Leon Romanovsky <leon@kernel.org>
>     net/mlx5e: Rely on reqid in IPsec tunnel mode
>
> Leon Romanovsky <leon@kernel.org>
>     net/mlx5e: Fix inversion dependency warning while enabling IPsec tunn=
el
>
> Mark Zhang <markzhang@nvidia.com>
>     net/mlx5: Clear port select structure when fail to create
>
> Chris Mi <cmi@nvidia.com>
>     net/mlx5: SF, Fix add port error handling
>
> Yishai Hadas <yishaih@nvidia.com>
>     net/mlx5: Fix a lockdep warning as part of the write combining test
>
> Patrisious Haddad <phaddad@nvidia.com>
>     net/mlx5: Fix RDMA TX steering prio
>
> Pavel Begunkov <asml.silence@gmail.com>
>     net: make page_pool_ref_netmem work with net iovs
>
> Kevin Groeneveld <kgroeneveld@lenbrook.com>
>     net: fec: handle page_pool_dev_alloc_pages error
>
> Sean Anderson <sean.anderson@linux.dev>
>     net: xilinx: axienet: Fix IRQ coalescing packet count overflow
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     nfp: bpf: prevent integer overflow in nfp_bpf_event_output()
>
> Viresh Kumar <viresh.kumar@linaro.org>
>     cpufreq: Move endif to the end of Kconfig file
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     pfcp: Destroy device along with udp socket's netns dismantle.
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     gtp: Destroy device along with udp socket's netns dismantle.
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: add the missing error handling inside get_canonical_dev_path
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpuidle: teo: Update documentation after previous changes
>
> Karol Kolacinski <karol.kolacinski@intel.com>
>     ice: Add correct PHY lane assignment
>
> Sergey Temerkhanov <sergey.temerkhanov@intel.com>
>     ice: Use ice_adapter for PTP shared data instead of auxdev
>
> Sergey Temerkhanov <sergey.temerkhanov@intel.com>
>     ice: Add ice_get_ctrl_ptp() wrapper to simplify the code
>
> Sergey Temerkhanov <sergey.temerkhanov@intel.com>
>     ice: Introduce ice_get_phy_model() wrapper
>
> Karol Kolacinski <karol.kolacinski@intel.com>
>     ice: Fix ETH56G FC-FEC Rx offset value
>
> Karol Kolacinski <karol.kolacinski@intel.com>
>     ice: Fix quad registers read on E825
>
> Karol Kolacinski <karol.kolacinski@intel.com>
>     ice: Fix E825 initialization
>
> Artem Chernyshev <artem.chernyshev@red-soft.ru>
>     pktgen: Avoid out-of-bounds access in get_imix_entries
>
> Ilya Maximets <i.maximets@ovn.org>
>     openvswitch: fix lockup on tx to unregistering netdev with carrier
>
> Paul Barker <paul.barker.ct@bp.renesas.com>
>     net: ravb: Fix max TX frame size for RZ/V2M
>
> Jakub Kicinski <kuba@kernel.org>
>     eth: bnxt: always recalculate features after XDP clearing, fix null-d=
eref
>
> Michal Luczaj <mhal@rbox.co>
>     bpf: Fix bpf_sk_select_reuseport() memory leak
>
> Sudheer Kumar Doredla <s-doredla@ti.com>
>     net: ethernet: ti: cpsw_ale: Fix cpsw_ale_get_field()
>
> Ard Biesheuvel <ardb@kernel.org>
>     efi/zboot: Limit compression options to GZIP and ZSTD
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  arch/x86/include/asm/special_insns.h               |   2 +-
>  arch/x86/kernel/fred.c                             |   8 +-
>  drivers/acpi/resource.c                            |   6 +-
>  drivers/block/zram/zram_drv.c                      |   1 +
>  drivers/cpufreq/Kconfig                            |   4 +-
>  drivers/cpuidle/governors/teo.c                    |  91 +++----
>  drivers/firmware/efi/Kconfig                       |   4 -
>  drivers/firmware/efi/libstub/Makefile.zboot        |  18 +-
>  drivers/gpio/gpio-sim.c                            |  48 +++-
>  drivers/gpio/gpio-virtuser.c                       |  49 +++-
>  drivers/gpio/gpio-xilinx.c                         |  32 +--
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   5 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_fw_attestation.c |   4 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |   4 +-
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  41 ++-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |  25 +-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   4 +-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.h |   2 +-
>  .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  14 +-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |  35 ++-
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.h  |   3 +-
>  .../gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c   |   4 +-
>  .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  11 +-
>  drivers/gpu/drm/i915/display/intel_fb.c            |   2 +-
>  drivers/gpu/drm/nouveau/nouveau_fence.c            |   6 +-
>  drivers/gpu/drm/nouveau/nvkm/engine/disp/mcp77.c   |   1 +
>  drivers/gpu/drm/tests/drm_kunit_helpers.c          |   3 +-
>  drivers/gpu/drm/v3d/v3d_irq.c                      |   4 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |   3 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_bo.h                 |   3 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   7 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_gem.c                |   1 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  20 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   7 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c         |   5 +-
>  drivers/gpu/drm/xe/xe_hw_engine.c                  |   2 +-
>  drivers/gpu/drm/xe/xe_oa.c                         |   1 +
>  drivers/hwmon/ltc2991.c                            |   2 +-
>  drivers/hwmon/tmp513.c                             |   7 +-
>  drivers/i2c/busses/i2c-rcar.c                      |  20 +-
>  drivers/i2c/i2c-atr.c                              |   2 +-
>  drivers/i2c/i2c-core-base.c                        |   1 +
>  drivers/i2c/i2c-slave-testunit.c                   |  19 +-
>  drivers/i2c/muxes/i2c-demux-pinctrl.c              |   4 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   1 +
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   4 +
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   1 +
>  drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   1 +
>  drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
>  drivers/irqchip/irq-gic-v3.c                       |   2 +-
>  drivers/irqchip/irqchip.c                          |   4 +-
>  drivers/mtd/spi-nor/core.c                         |   2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  19 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  25 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   7 -
>  drivers/net/ethernet/freescale/fec_main.c          |  19 +-
>  drivers/net/ethernet/intel/ice/ice.h               |   5 +
>  drivers/net/ethernet/intel/ice/ice_adapter.c       |   6 +
>  drivers/net/ethernet/intel/ice/ice_adapter.h       |  22 +-
>  drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   1 +
>  drivers/net/ethernet/intel/ice/ice_common.c        |  51 ++++
>  drivers/net/ethernet/intel/ice/ice_common.h        |   1 +
>  drivers/net/ethernet/intel/ice/ice_main.c          |   6 +-
>  drivers/net/ethernet/intel/ice/ice_ptp.c           | 165 +++++++-----
>  drivers/net/ethernet/intel/ice/ice_ptp.h           |   9 +-
>  drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |   2 +-
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c        | 285 +++++++++++----=
------
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |   5 +
>  drivers/net/ethernet/intel/ice/ice_type.h          |   2 -
>  .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  22 +-
>  .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  12 +-
>  .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  11 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   1 +
>  .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   1 +
>  drivers/net/ethernet/mellanox/mlx5/core/wc.c       |  24 +-
>  drivers/net/ethernet/netronome/nfp/bpf/offload.c   |   3 +-
>  drivers/net/ethernet/renesas/ravb_main.c           |   1 +
>  drivers/net/ethernet/ti/cpsw_ale.c                 |  14 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   6 +
>  drivers/net/gtp.c                                  |  26 +-
>  drivers/net/pfcp.c                                 |  15 +-
>  drivers/nvme/target/io-cmd-bdev.c                  |   2 +-
>  drivers/platform/x86/dell/dell-uart-backlight.c    |   5 +-
>  .../x86/intel/speed_select_if/isst_if_common.c     |   1 +
>  drivers/platform/x86/intel/tpmi_power_domains.c    |   1 +
>  .../x86/lenovo-yoga-tab2-pro-1380-fastcharger.c    |   5 +-
>  drivers/pmdomain/imx/imx8mp-blk-ctrl.c             |   2 +-
>  drivers/reset/reset-rzg2l-usbphy-ctrl.c            |   1 +
>  drivers/ufs/core/ufshcd.c                          |   9 +-
>  fs/afs/addr_prefs.c                                |   6 +-
>  fs/btrfs/volumes.c                                 |   4 +
>  fs/cachefiles/daemon.c                             |  14 +-
>  fs/cachefiles/internal.h                           |   3 +-
>  fs/cachefiles/security.c                           |   6 +-
>  fs/file.c                                          |   1 +
>  fs/hfs/super.c                                     |   4 +-
>  fs/iomap/buffered-io.c                             |   2 +-
>  fs/netfs/read_collect.c                            |   9 +-
>  fs/proc/vmcore.c                                   |   2 +
>  fs/qnx6/inode.c                                    |  11 +-
>  fs/smb/client/connect.c                            |   3 +-
>  include/linux/hrtimer.h                            |   1 +
>  include/linux/poll.h                               |  10 +-
>  include/linux/pruss_driver.h                       |  12 +-
>  include/linux/userfaultfd_k.h                      |  12 +
>  include/net/page_pool/helpers.h                    |   2 +-
>  include/trace/events/mmflags.h                     |  63 +++++
>  kernel/cpu.c                                       |   2 +-
>  kernel/gen_kheaders.sh                             |   1 +
>  kernel/sched/ext.c                                 |  11 +-
>  kernel/sched/fair.c                                |   6 +-
>  kernel/time/hrtimer.c                              |  11 +-
>  kernel/time/timer_migration.c                      |  43 +++-
>  mm/filemap.c                                       |   2 +-
>  mm/huge_memory.c                                   |  12 +
>  mm/hugetlb.c                                       |  14 +-
>  mm/kmemleak.c                                      |   2 +-
>  mm/mremap.c                                        |  32 ++-
>  mm/vmscan.c                                        |   3 +
>  net/core/filter.c                                  |  30 ++-
>  net/core/netdev-genl-gen.c                         |  14 +-
>  net/core/pktgen.c                                  |   6 +-
>  net/mac802154/iface.c                              |   4 +
>  net/mptcp/options.c                                |   6 +-
>  net/mptcp/protocol.h                               |   9 +-
>  net/ncsi/internal.h                                |   2 +
>  net/ncsi/ncsi-manage.c                             |  16 +-
>  net/ncsi/ncsi-rsp.c                                |  19 +-
>  net/openvswitch/actions.c                          |   4 +-
>  net/vmw_vsock/af_vsock.c                           |  18 ++
>  net/vmw_vsock/virtio_transport_common.c            |  38 ++-
>  net/vmw_vsock/vsock_bpf.c                          |   9 +
>  security/apparmor/policy.c                         |   1 +
>  sound/pci/hda/patch_realtek.c                      |   3 +
>  tools/net/ynl/ynl-gen-c.py                         |  16 +-
>  tools/testing/selftests/mm/cow.c                   |   8 +-
>  tools/testing/selftests/net/mptcp/mptcp_connect.c  |  43 +++-
>  .../selftests/sched_ext/ddsp_bogus_dsq_fail.bpf.c  |   2 +-
>  .../selftests/sched_ext/ddsp_vtimelocal_fail.bpf.c |   4 +-
>  .../testing/selftests/sched_ext/dsp_local_on.bpf.c |   7 +-
>  tools/testing/selftests/sched_ext/dsp_local_on.c   |   5 +-
>  .../selftests/sched_ext/enq_select_cpu_fails.bpf.c |   2 +-
>  tools/testing/selftests/sched_ext/exit.bpf.c       |   4 +-
>  tools/testing/selftests/sched_ext/maximal.bpf.c    |   8 +-
>  .../selftests/sched_ext/select_cpu_dfl.bpf.c       |   2 +-
>  .../sched_ext/select_cpu_dfl_nodispatch.bpf.c      |   2 +-
>  .../selftests/sched_ext/select_cpu_dispatch.bpf.c  |   2 +-
>  .../sched_ext/select_cpu_dispatch_bad_dsq.bpf.c    |   2 +-
>  .../sched_ext/select_cpu_dispatch_dbl_dsp.bpf.c    |   4 +-
>  .../selftests/sched_ext/select_cpu_vtime.bpf.c     |   8 +-
>  .../tc-testing/tc-tests/filters/flow.json          |   4 +-
>  tools/testing/shared/linux/maple_tree.h            |   2 +-
>  tools/testing/vma/linux/atomic.h                   |   2 +-
>  157 files changed, 1327 insertions(+), 639 deletions(-)
>
>
>
