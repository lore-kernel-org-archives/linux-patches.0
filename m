Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021858;
	b=h1VeAsR0SVl32lwgdleYffbxJwTC7kf2nt2plM7Cq4CqN1yJYm9jLbk+82SYALA9Ooee
	 X/1wLMTcX8WUR1U81SwZmEzJXpbZqAzmEE2DO92OgH/gIgPPUOGmiq1Ng+ecWPxB5wn5N
	 uxe4gCt0ZMhI4yEbTK7xzIhHrKmCUPwUJr0HFNtepKoHZvbxxOBOASqOrs84fNKvuARR+
	 +E3QPu23Ez9GGlkB+n/DfhB1NXVQQfFNEbI95xgraP0OwntFAWfmIO+RR/DBrWsfhHYFk
	 O3ha6HPQQ8dSQWeg7OlW7PPwwx8FOsM85m1vQXiGk0ANPrbg/xizkUURSNYy+zFmd8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021858;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=48OtHS5KbzDbomtmruIpKoy7JhC4iIT3iSOaWC02Jqg=;
	b=k8VHAn1tnQp+ZWo/aDcc7Soy2Ngvv1DfC4HCzDxo9elTpsAHajHbAKgkX8JKgCRuUjbO
	 kwcxfXrgtX6oHHt9sf/MahXUirXND2jWQuZIQJQQMWoDZ5Wzaulqk3WNNQcX9UdhNdRpf
	 Du0ymFdSXUfYUELkyobgiOBfWrxF3f9BhTJ4uQWN/QSoqNyGGyonpD5oly2Vs5VrbaoPt
	 dF2MAf8jT51upKTLyvd4rhUkmiML1yOAzpTUP2/oJwX5jewJBxPx+P+mldCF9kmh/QsVq
	 sNFVBvhYDh4spgiwBeaYsB5Yzugw4LqOmCVYmfHrAQ/3SreFVo/3wJZ0IZg2Rn7nArQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=aw1KoR1g;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7228B606A32A
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7228B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=aw1KoR1g
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3990510E048;
	Wed, 18 Nov 2026 18:10:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1795021849;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=48OtHS5KbzDbomtmruIpKoy7JhC4iIT3iSOaWC02Jqg=;
	b=aw1KoR1gyPb3DGrSWoyzLEyAqkVqfCFdmT+eocapB/ydMBDjcQltJ5ITL+cpvajDsYq3Si
	R2ksZtMHYTzq4a0oyL2bQp3ueMuswjz0M7ccrtfBkAxqcyNvCZk8YMac6Re9IecBmhQF2c
	dMxwL2XFEUCmq2t5OKAIO+qZ9dZ/IwS6Ma0w7R508ZcRSFkRldujjovTNOtOHlh9XrXIVI
	bJ934gqu8julGtMwAXlWuSbJBkWYNK4bh+V5f6zPB9CE3EIFdsUxXp2AfWvVId70pfvDsQ
	ppmWNIe5neKeVwiaYDvPPaaJiS8/8xwmBg+VX2KqaXSXcJFZQuOe//JnPT4AiQ==
Date: Wed, 18 Nov 2026 18:10:40 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
Message-ID: <av3cECm1GWOmq18i@duo.ucw.cz>
References: <20261118150007.957976754@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YDVmP5dpcfwy1+l6"
Content-Disposition: inline
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--YDVmP5dpcfwy1+l6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1756 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build failure here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/181495=
65363
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/3=
084779815

Best regards,
									Pavel
								=09

In file included from arch/arm/boot/dts/qcom/qcom-apq8074-dragonboard.dts:6:
4471
16:35:43
arch/arm/boot/dts/qcom/qcom-msm8974.dtsi:4:10: fatal error: dt-bindings/clo=
ck/qcom,dsi-phy-28nm.h: No such file or directory
4472
16:35:43
    4 | #include <dt-bindings/clock/qcom,dsi-phy-28nm.h>
4473
16:35:43
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
4474
16:35:43
  DTC     arch/arm/boot/dts/allwinner/sun5i-a13-empire-electronix-d709.dtb
4475
16:35:43
  DTC     arch/arm/boot/dts/broadcom/bcm47081-buffalo-wzr-600dhp2.dtb
4476
16:35:43
compilation terminated.
4477
16:35:43
make[3]: *** [scripts/Makefile.dtbs:131: arch/arm/boot/dts/qcom/qcom-apq807=
4-dragonboard.dtb] Error 1
4478
16:35:43
make[2]: *** [scripts/Makefile.build:466: arch/arm/boot/dts/qcom] Error 2
4479
16:35:43
make[2]: *** Waiting for unfinished jobs....
4480
16:35:43
  DTC




>=20
> Responses should be made by Fri, 20 Nov 2026 14:55:44 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11=
9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.12.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.12.119-rc1
>=20
> Li RongQing <lirongqing@baidu.com>
>     apparmor: avoid potential double free when remapping DFA tables
>=20
> Justin Chen <justin.chen@broadcom.com>
>     net: bcmgenet: if UMAC was suspended in SW_RESET, restore it to SW_RE=
SET
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: bcmgenet: stop Tx NAPI before disabling the queues
>=20
> Matthew Brown <matthew@bargrove.com>
>     ceph: fix leaked inode reference on writeback abort at umount
>=20
> Baolin Liu <liubaolin@kylinos.cn>
>     fs/ntfs3: reject FS_IOC_SETFSLABEL on readonly mounts
>=20
> Georgia Garcia <georgia.garcia@canonical.com>
>     apparmor: fix NULL pointer dereference in unpack_pdb
>=20
> Zygmunt Krynicki <me@zygoon.pl>
>     apparmor: fail policy unpack on accept2 allocation failure
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     remoteproc: imx_dsp_rproc: Only reset carveout memory at RPROC_OFFLIN=
E state
>=20
> Bharath SM <bharathsm@microsoft.com>
>     smb: align durable reconnect v2 context to 8 byte boundary
>=20
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amdgpu: Fix vbios build number parsing logic
>=20
> Eduard Zingerman <eddyz87@gmail.com>
>     selftests/bpf: include limits.h needed for PATH_MAX directly
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: mitigate parser generating large xtables
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: fix: accept2 being specifie even when permission table is p=
resnt
>=20
> Christian Bruel <christian.bruel@foss.st.com>
>     arm64: dts: st: Use 128kB size for aliased GIC400 register access on =
stm32mp23 SoCs
>=20
> Christian Bruel <christian.bruel@foss.st.com>
>     arm64: dts: st: Adjust interrupt-controller for stm32mp23 SoCs
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     nvme-tcp: fix use-after-free of netns by kernel TCP socket.
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf libunwind: Fixup conversion perf_sample->user_regs to a pointer
>=20
> Namhyung Kim <namhyung@kernel.org>
>     perf tools: Fix compile error on sample->user_regs
>=20
> Leo Yan <leo.yan@arm.com>
>     perf tools: Fix compilation error on arm64
>=20
> Dan Carpenter <dan.carpenter@linaro.org>
>     platform/x86/amd/pmc: fix leak in probe()
>=20
> Tony Ambardar <tony.ambardar@gmail.com>
>     libbpf: Fix accessing BTF.ext core_relo header
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     soc: qcom: pmic_glink: Drop redundant pg assignment before taking lock
>=20
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Fix 64-by-32 division cocci warnings
>=20
> Steven Price <steven.price@arm.com>
>     irqchip/gic-v3-its: Fix over allocation in itt_alloc_pool()
>=20
> Hemanth Selam <hemanth.selam@gmail.com>
>     selftests/cgroup: set the test plan after the setup checks
>=20
> Jakub Sitnicki <jakub@cloudflare.com>
>     net: lwtunnel: Drop skb metadata before LWT encapsulation
>=20
> Szymon Wilczek <swilczek.lx@gmail.com>
>     fs/ntfs3: fix deadlock in ni_read_folio_cmpr
>=20
> Brian Norris <briannorris@chromium.org>
>     PM: runtime: Only queue an idle check for RPM-linked suppliers (part =
2)
>=20
> J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     nvmet-auth: reject incomplete DHCHAP messages
>=20
> Shakeel Butt <shakeel.butt@linux.dev>
>     kernfs: avoid READ_ONCE() on a kgid_t in kernfs_new_node()
>=20
> Damien Le Moal <dlemoal@kernel.org>
>     scsi: core: Fix additional sense code definition
>=20
> Krzysztof Wilczy=C5=84ski <kwilczynski@kernel.org>
>     PCI/sysfs: Decouple acpi_index from the optional device name element
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     vdpa_sim: disable page faults around vringh_need_notify_iotlb()
>=20
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>     mm: fix OOM killer inaccuracy on large many-core systems
>=20
> SeongJae Park <sj@kernel.org>
>     mm/damon/reclaim: use parameter context correctly
>=20
> Cheng Xu <chengyou@linux.alibaba.com>
>     RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables
>=20
> Dominique Martinet <asmadeus@codewreck.org>
>     libbpf: fix cross-endian build with newer libbpf
>=20
> Imre Kaloz <kaloz@kernel.org>
>     rtc: ds1685: do not sleep in the power-off handler
>=20
> Imre Kaloz <kaloz@kernel.org>
>     rtc: ds1685: arm the wake-up alarm at power-off only if an alarm is s=
et
>=20
> Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>     minix: reject rmdir of a directory with a corrupted link count
>=20
> Jori Koolstra <jkoolstra@xs4all.nl>
>     Fix a drop_nlink warning in minix_rmdir
>=20
> Jori Koolstra <jkoolstra@xs4all.nl>
>     Add error handling to minix filesystem for inode corruption detection
>=20
> Nickolai Zeldovich <nickolai@csail.mit.edu>
>     fs_pin: do not trust the pin after a spurious wakeup in pin_kill()
>=20
> Nickolai Zeldovich <nickolai@csail.mit.edu>
>     ucount: read the parent ucounts before dropping the rlimit count
>=20
> Nickolai Zeldovich <nickolai@csail.mit.edu>
>     splice: retry tee() instead of returning 0 when it races
>=20
> Zhiyu Zhang <zhiyuzhang999@gmail.com>
>     watch_queue: keep info_id separate from rcu_head
>=20
> Xiao Liang <shaw.leon@gmail.com>
>     tun: drop batched packets while the device is down
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: advertise that sctp is being mediated
>=20
> Jhonata Poma-Hansen <jhonata.poma@gmail.com>
>     netlink: check sk_rcvbuf before charging the dump skb
>=20
> Eric Dumazet <edumazet@kernel.org>
>     openvswitch: use eth_type_trans_careful() in internal_dev_recv()
>=20
> Eric Dumazet <edumazet@kernel.org>
>     net: use eth_type_trans_careful() in __dev_forward_skb2()
>=20
> Sun Jian <sun.jian.kdev@gmail.com>
>     selftests/bpf: cover short IPv4/IPv6 inputs with adjust_room
>=20
> Eric Dumazet <edumazet@kernel.org>
>     loopback: use eth_type_trans_careful()
>=20
> Eric Dumazet <edumazet@kernel.org>
>     net: add eth_type_trans_careful()
>=20
> Kyle Zeng <kylebot@openai.com>
>     tcp: initialize mapped children before route lookup
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: fix check SCTP bind, and connect permission checks
>=20
> Kyle Zeng <kylebot@openai.com>
>     tcp: avoid double destroy in tcp_abort() of an unaccepted child
>=20
> Rosen Penev <rosenp@gmail.com>
>     net: bgmac: fix TX DMA unmapping and slot cleanup
>=20
> Kyle Zeng <kylebot@openai.com>
>     gro: do not GRO GSO packets with inconsistent payload
>=20
> Jakub Kicinski <kuba@kernel.org>
>     eth: bnxt: hand XDP frags over to the copybreak skb
>=20
> Jakub Kicinski <kuba@kernel.org>
>     eth: bnxt: free XDP frags when xdp_do_redirect() fails
>=20
> J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     apparmor: check connect permission for SCTP
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     apparmor: Fix namespace reference leak in __aa_find_or_create_ns()
>=20
> Maxime B=C3=A9lair <maxime.belair@canonical.com>
>     apparmor: convert duplicated dfa transitions to match_char()
>=20
> Maxime B=C3=A9lair <maxime.belair@canonical.com>
>     apparmor: fix table_size() integer overflow on 32 bit
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: add additional flags to extended permission.
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: add support for 2^24 states to the dfa state machine.
>=20
> Maxime B=C3=A9lair <maxime.belair@canonical.com>
>     apparmor: report a label allocation failure as -ENOMEM
>=20
> Jamie Nguyen <jamien@nvidia.com>
>     selftests: net: txtimestamp: fix out-of-bounds read in raw UDP checks=
um
>=20
> Kunhai Dai <daikunhai@didiglobal.com>
>     blk-iocost: publish hweights as one atomic value
>=20
> Bart Van Assche <bvanassche@acm.org>
>     block/blk-iocost: Inline iocg_lock() and iocg_unlock()
>=20
> Bart Van Assche <bvanassche@acm.org>
>     block/blk-iocost: Split ioc_rqos_throttle()
>=20
> Muchun Song <muchun.song@linux.dev>
>     block: introduce init_wait_func()
>=20
> Muchun Song <muchun.song@linux.dev>
>     block: remove redundant explicit memory barrier from rq_qos waiter an=
d waker
>=20
> Chris Mason <mason@kernel.org>
>     rnbd-srv: publish the sess_dev at the end of OPEN
>=20
> Chris Mason <mason@kernel.org>
>     rnbd-srv: fix use-after-free on two CLOSE messages
>=20
> Josef Bacik <josef@toxicpanda.com>
>     block/rnbd-srv: drop the sess_dev kobject unlocked
>=20
> Josef Bacik <josef@toxicpanda.com>
>     block/rnbd-srv: don't free the device on a sysfs error
>=20
> Josef Bacik <josef@toxicpanda.com>
>     drbd: take req_lock to skip the initial sync as peer
>=20
> Josef Bacik <josef@toxicpanda.com>
>     drbd: stop the start_resync timer of a dying device
>=20
> Josef Bacik <josef@toxicpanda.com>
>     block: partitions/mac: compute the sectors in 64 bits
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-mq: exit the hctxs of a queue under tag_list_lock
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-mq: quiesce a queue that joins a quiesced tag set
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-mq: don't forget a timer the driver has restarted
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-mq: don't bring back flags of a completed request
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-mq: keep sharing tags fairly after a queue update
>=20
> Josef Bacik <josef@toxicpanda.com>
>     block: don't lose the status of a failed flush request
>=20
> Josef Bacik <josef@toxicpanda.com>
>     block: fix use-after-free of the disk in sync_bdevs()
>=20
> Dominik Maier <dmnk@google.com>
>     xattr: always invoke cap_convert_nscap() for security.capability writ=
es
>=20
> Josef Bacik <josef@toxicpanda.com>
>     fork: Let nobody keep a task that may not come to life
>=20
> Markus Probst <markus.probst@posteo.de>
>     rtc: s35390a: Read 24-hour mode on access
>=20
> Alexandre Belloni <alexandre.belloni@bootlin.com>
>     rtc: s35390a: fix typo in comment
>=20
> Nick Huang <sef1548@gmail.com>
>     rtc: s35390a: use u8 instead of char for register buffer
>=20
> Andr=C3=A9 Draszik <andre.draszik@linaro.org>
>     rtc: s35390a: drop needless struct s35390a::rtc member
>=20
> Markus Probst <markus.probst@posteo.de>
>     rtc: s35390a: Fix alarm not disabling
>=20
> Markus Probst <markus.probst@posteo.de>
>     rtc: s35390a: Add missing newline to dev_err
>=20
> Joas Antonio dos Santos <joasantonio108@gmail.com>
>     net: mctp: free reassembly head skb when key_add fails on SOM
>=20
> Linkui Xiao <xiaolinkui@kylinos.cn>
>     net: bridge: netlink: do not clear the vlan info dump error
>=20
> Eric Dumazet <edumazet@google.com>
>     net: bridge: use atomic ops to read/change p->flags (III)
>=20
> Eric Dumazet <edumazet@google.com>
>     bridge: add bridge_flags_bit enum
>=20
> Danielle Ratson <danieller@nvidia.com>
>     bridge: Add internal flags for neigh_forward_grat
>=20
> Eric Woudstra <ericwouds@gmail.com>
>     bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
>=20
> Karol Kolacinski <karol.kolacinski@intel.com>
>     ice: E822: keep Tx timestamps disabled during offset calibration
>=20
> Jacob Keller <jacob.e.keller@intel.com>
>     ice: set in_use only after preparing Tx timestamp index
>=20
> Joas Antonio dos Santos <joasantonio108@gmail.com>
>     net: dcb: initialize PFC value before calling getpfccfg
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: bcmgenet: restore the Tx coalescing setting when the rings are r=
ebuilt
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: bcmgenet: recover from a failed resume
>=20
> Doug Berger <opendmb@gmail.com>
>     net: bcmgenet: revise suspend/resume
>=20
> Doug Berger <opendmb@gmail.com>
>     net: bcmgenet: introduce bcmgenet_[r|t]dma_disable
>=20
> Doug Berger <opendmb@gmail.com>
>     net: bcmgenet: consolidate dma initialization
>=20
> Doug Berger <opendmb@gmail.com>
>     net: bcmgenet: remove dma_ctrl argument
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-throttle: make blkio.reset_stats reset I/O counts
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-throttle: pass the I/O counts of a dead group on
>=20
> Li Lingfeng <lilingfeng3@huawei.com>
>     block: flush all throttled bios when deleting the cgroup
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-iolatency: flush enable_work after going offline
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-cgroup: don't free a blkg with its punt work queued
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-cgroup: fix root io.stat byte counts on 32-bit
>=20
> Josef Bacik <josef@toxicpanda.com>
>     blk-throttle: don't truncate the cgroup v1 iops limits
>=20
> Chris Mason <mason@kernel.org>
>     nvmet: don't clear sq->ctrl for a Connect with sqsize 0
>=20
> Chris Mason <mason@kernel.org>
>     nvmet-rdma: fix double puts after a failed RDMA WRITE
>=20
> Chris Mason <mason@kernel.org>
>     nvmet-rdma: disable interrupts under rsp_wr_wait_lock
>=20
> Chris Mason <mason@kernel.org>
>     nvmet-rdma: flush nvmet-wq on module exit
>=20
> Josef Bacik <josef@toxicpanda.com>
>     nvme-loop: don't BUG() if a scan runs beside a reset
>=20
> Josef Bacik <josef@toxicpanda.com>
>     nvmet-tcp: don't read a removed port at Connect time
>=20
> Josef Bacik <josef@toxicpanda.com>
>     nvmet: fix NULL dereference in debugfs host_traddr
>=20
> Josef Bacik <josef@toxicpanda.com>
>     nvmet-tcp: stop listening when a port is removed
>=20
> Josef Bacik <josef@toxicpanda.com>
>     nvmet-auth: take only AUTH_Negotiate for a negotiation
>=20
> Josef Bacik <josef@toxicpanda.com>
>     nvmet: don't truncate the length of big discards
>=20
> Chaitanya Kulkarni <kch@nvidia.com>
>     nvmet: ignore discard return value
>=20
> Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
>     kdb: unify CMD_BUFLEN definition into kdb_private.h
>=20
> Rongzheng Wang <testwrzwrz@gmail.com>
>     nvmet: use the enabled transport when disabling a port
>=20
> Qing Zhang <diasyzhang@tencent.com>
>     nvmet: protect nvmet_ports_list with nvmet_config_sem
>=20
> Avi Weiss <thnkslprpt@gmail.com>
>     nvmet: prevent double-free after metadata SGL allocation failure
>=20
> Andrea Parri <parri.andrea@gmail.com>
>     nvmet: zns: reject a NUMD whose byte count wraps
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: xilinx: formatter_pcm: Fix read-modify-write of AUD_CTRL in hw_=
params
>=20
> Sicong Huang <congei42@163.com>
>     nfp: flower: fix use-after-free in neighbour update work
>=20
> Peter Morrow <pdmorrow@gmail.com>
>     net/mlx4: always create the eth and ib auxiliary devices
>=20
> Feng Yang <yangfeng@kylinos.cn>
>     bpf: Fix out-of-bounds btf->types write for split BTF
>=20
> =C3=96mer Mete Kaya <omermetekaya0@gmail.com>
>     usbnet: fix EVENT_RX_PAUSED race in usbnet_skb_return()
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: mv88e6xxx: fix 6351 family statistics snapshot
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: lan966x: don't disable hardirqs in fdma tx clear path
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     devlink: region: fix snapshot id leak on kernel-allocated ids
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: microchip: fdma: fix DCB corruption under sustained load
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: microchip: fdma: use little-endian types for descriptor fields
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: lan966x: release the in-flight slot of a stale TX skb
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: lan966x: fix the DB dataptr of frames from ndo_xdp_xmit
>=20
> Harkirat Gill <harkirat.gill@amd.com>
>     drm/amdgpu: re-enable GFXOFF for compute on GFX12
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     perf print_insn: Include sys/types.h for ssize_t
>=20
> Paul Moses <p@1g4.org>
>     perf mmap: Preserve the consumed cursor in forward mode
>=20
> Paul Moses <p@1g4.org>
>     perf mmap: Use the head selected by read_init
>=20
> Len Brown <len.brown@intel.com>
>     x86_energy_perf_policy: Cleanup: Check fseek() in VM path
>=20
> Len Brown <len.brown@intel.com>
>     x86_energy_perf_policy: Fix optarg keyword matching
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: lan966x: do not warn on MAC entries that are not port destined
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: lan966x: do not inject uninitialised bytes past skb->len
>=20
> Dudu Lu <phx0fer@gmail.com>
>     net: xps: bound the cleanup loop by the old map's num_tc
>=20
> Allison Henderson <achender@kernel.org>
>     net/rds: do not initialize transports after rds_init() failed
>=20
> Allison Henderson <achender@kernel.org>
>     net/rds: do not fail init when CONFIG_SYSCTL=3Dn
>=20
> Cheng Yongkang <teel4res@gmail.com>
>     net: tun: hold napi_mutex when deleting NAPI in tun_detach_all()
>=20
> Sally Marcher <me@gry.sh>
>     ALSA: usb-audio: Add correct datainterval in the quirks-table for Mic=
robook II
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ALSA: pcmtest: Honor the enable parameter
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: usb: cdc_mbim: don't enable BHs in tx_fixup under netpoll
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: usb: cdc_ncm: don't enable BHs in tx_fixup under netpoll
>=20
> Binbin Deng <18983559317@163.com>
>     net: atlantic: Unregister before clearing RXNFC rules
>=20
> Paolo Abeni <pabeni@redhat.com>
>     gtp: hold RCU in gtp_genl_send_echo_req()
>=20
> Qingfang Deng <qingfang.deng@linux.dev>
>     pppoe: drop discovery frames with no MAC header
>=20
> Tung Nguyen <tung.quang.nguyen@est.tech>
>     tipc: fix refcount panic in tipc_rcv() when receiving shared skb
>=20
> Jerome Brunet <jbrunet@baylibre.com>
>     clk: cdce925: Size the PLL child name buffer for any int
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     clk: lmk04832: Handle reset GPIO lookup errors
>=20
> Eric Dumazet <edumazet@kernel.org>
>     ipmr: clear skb->cb[] in reg_vif_xmit()
>=20
> alex todadze <todadzealexi19@proton.me>
>     net: stmmac: fix rx checksum offload with extended descriptors
>=20
> Dudu Lu <phx0fer@gmail.com>
>     net/sched: taprio: unwind the netdevice notifier if register_qdisc() =
fails
>=20
> Alexandre Cassen <acassen@corp.free.fr>
>     net/sched: act_api: inherit filter offload flags only on new actions
>=20
> Dudu Lu <phx0fer@gmail.com>
>     net/sched: gred: keep the qdisc lock while updating the table
>=20
> Zhang Yi <zhangyi@everest-semi.com>
>     ASoC: codecs: es*: Modify the registers related to ALC RECOVERY
>=20
> Ravi Hothi <ravi.hothi@oss.qualcomm.com>
>     ASoC: codecs: wsa883x: Fix VI sense port channel count
>=20
> Ravi Hothi <ravi.hothi@oss.qualcomm.com>
>     ASoC: codecs: wsa884x: Fix VI sense port channel count
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: codecs: wsa883x: disable runtime PM on unbind
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: codecs: wsa884x: disable runtime PM on unbind
>=20
> Hungyu Lin <dennylin0707@gmail.com>
>     thermal: Fix CPU mask truncation in power limit trace event
>=20
> Sasha Levin <sashal@kernel.org>
>     selftests/thermal: allow cross builds of the Intel tests
>=20
> Aleksei Oladko <aleksey.oladko@virtuozzo.com>
>     selftests: fix ARCH normalization to handle command-line argument
>=20
> TJ Adams <tadamsjr@google.com>
>     block: advance iterator after copy-in for SG_DXFER_TO_FROM_DEV
>=20
> Waiman Long <longman@redhat.com>
>     cgroup/cpuset: Make sure compute_partition_effective_cpumask() is onl=
y called for valid partition
>=20
> Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>     libceph: reject bad connect_seq in msgr1 READY reply
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     ceph: don't keep a mon_addr string that failed to parse
>=20
> Xiang Mei <xmei5@asu.edu>
>     ceph: fix off-by-one NUL termination in decode_encrypted_symlink()
>=20
> Tal Zussman <tz2294@columbia.edu>
>     ceph: don't clear write_congested when collecting folios
>=20
> Tal Zussman <tz2294@columbia.edu>
>     ceph: fix writeback_count leak when a bounce page allocation fails
>=20
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     ceph: Convert ceph_move_dirty_page_in_page_array() to move_dirty_foli=
o_in_page_array()
>=20
> Tal Zussman <tz2294@columbia.edu>
>     ceph: fix error handling when the OSD client is stopping in ceph_subm=
it_write()
>=20
> Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>     ceph: fix generic/421 test failure
>=20
> Alex Markuze <amarkuze@redhat.com>
>     ceph: fix page vector leak on encrypted netfs read EIO path
>=20
> Xiubo Li <xiubo.li@clyso.com>
>     ceph: mark the superblock active after mounting
>=20
> Max Kellermann <max.kellermann@ionos.com>
>     ceph: remove unused field `i_cap_migration_resv`
>=20
> Henry Martin <bsdhenrymartin@gmail.com>
>     netlink: fix out-of-bounds bitmap access clearing stale mc groups
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ALSA: pcmtest: Reject invalid fill_mode values
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: ump: Drain sequencer callbacks before freeing their client
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Notify UMP EP and FB changes
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Allow system notification in atomic
>=20
> Dimitris Charisis <dchar@cslab.ece.ntua.gr>
>     maple_tree: fix maple_range_64 crashes in RCU mode
>=20
> Pedro Falcato <pfalcato@suse.de>
>     maple_tree: Replace mt_free_one() with kfree()
>=20
> Pedro Falcato <pfalcato@suse.de>
>     maple_tree: Use kfree_rcu in ma_free_rcu
>=20
> Ren Tamura <ren.tamura.oss@gmail.com>
>     tools/cgroup: sum shrinker object counts across NUMA nodes
>=20
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>     ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
>=20
> Ting-Han Hou <ue081723@gmail.com>
>     scripts/gdb: fix stack depot out-of-bounds diagnostic
>=20
> Ting-Han Hou <ue081723@gmail.com>
>     scripts/gdb: fix radix tree lookup pointer handling
>=20
> Ilya Leoshkevich <iii@linux.ibm.com>
>     scripts/gdb/radix-tree: add lx-radix-tree-command
>=20
> Avi Weiss <thnkslprpt@gmail.com>
>     profiling: fix sampling step on 64-bit big-endian systems
>=20
> Edward Adam Davis <eadavis@sina.com>
>     kernel/reboot: avoid potential deadlocks during suspension
>=20
> Aditya Sharma <adi.sharma@zohomail.in>
>     bpf: Remove nmi_uaccess_okay() check in bpf_send_signal_common()
>=20
> Ayushman Rout <ayushmanrout27@gmail.com>
>     bpf: Use memmove() to load bytes from an skb and an xdp_buff
>=20
> Feng Yang <yangfeng@kylinos.cn>
>     bpf: Propagate btf_add_type() errors in btf_check_all_metas()
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     scsi: elx: libefc: Fix resource leak in efcport_init() error path
>=20
> Dudu Lu <phx0fer@gmail.com>
>     net/sched: etf: initialise the sock_exterr_skb before filling it
>=20
> Nandor Kracser <nandor@riptides.io>
>     tls: avoid field-spanning write when copying crypto info
>=20
> Greg Thelen <gthelen@google.com>
>     selftests/net: tcp_mmap: remove unused -k option and keepflag
>=20
> Allison Henderson <achender@kernel.org>
>     net/rds: keep the connected peer's scope id apart from the bound one
>=20
> Allison Henderson <achender@kernel.org>
>     net/rds: include the scope id in the sendmsg connection cache check
>=20
> Gal Pressman <gal@nvidia.com>
>     net/mlx5e: IPsec, Fix out-of-bounds comparison of neighbour keys
>=20
> Eric Dumazet <edumazet@kernel.org>
>     net: fix frag_list leak in skb_segment_list() error path
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: sparx5: fix tx DCB index drift in fdma xmit
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: sparx5: activate FDMA tx in start()
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: sparx5: split sparx5_fdma_{start(),stop()}
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: sparx5/lan969x: do not read past skb->len when injecting a frame
>=20
> Florian Fuchs <fuchsfl@gmail.com>
>     ALSA: sh: aica: Fix spu_memset() stride
>=20
> Gregory Price (Meta) <gourry@gourry.net>
>     cgroup/cpuset: check effective mems for a movable-only configuration
>=20
> Xingyuan Mo <hdthky0@gmail.com>
>     sctp: reject forged cookie peer_addr with unknown address family
>=20
> Jiale Yao <yaojiale02@163.com>
>     regulator: irq: freeze deferred hardware access during suspend
>=20
> Marco Crivellari <marco.crivellari@suse.com>
>     regulator: irq_helper: replace use of system_wq with system_dfl_wq
>=20
> Steven Rostedt <rostedt@goodmis.org>
>     cpuidle: haltpoll: Only define guest_halt_poll_ns tracepoint when used
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
>=20
> Michail Andreas Michalopoulos <mike.michalo@gmail.com>
>     ksmbd: select CRYPTO_AES
>=20
> Ivan Hu <ivan.hu@canonical.com>
>     ACPICA: Initialize parser_state.aml_end in acpi_install_method()
>=20
> Nickolai Zeldovich <nickolai@csail.mit.edu>
>     nsproxy: Fix cred leak in the error path of prepare_nsset()
>=20
> Avi Weiss <thnkslprpt@gmail.com>
>     signal: skip blocked signals in dequeue_synchronous_signal()
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     netfs: Restore selective debug mask handling
>=20
> Tianyi Chen <hi@tychen.cc>
>     eventpoll: propagate wakeup source creation failure in ep_modify()
>=20
> Nickolai Zeldovich <nickolai@csail.mit.edu>
>     proc/kcore: advance the vmalloc retry by the last copy, not the total
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ASoC: wm8994: follow AIF clock source changes in MCLK gating
>=20
> Binbin Deng <18983559317@163.com>
>     tipc: fix use-after-free of broadcast reception link at node release
>=20
> Rand Deeb <rand.sec96@gmail.com>
>     ata: libata-core: Ignore forced transfer modes the host does not supp=
ort
>=20
> Travis Howard <thoward@lafayetteinstrument.com>
>     tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
>=20
> Eric Dumazet <edumazet@kernel.org>
>     net: shrink the payload-only part of skb dataref to one bit
>=20
> Tianyi Gao <tianyi@cloudflare.com>
>     veth: schedule the peer's NAPI after XDP_TX when only GRO is enabled
>=20
> Daniel Machon <daniel.machon@microchip.com>
>     net: sparx5/lan969x: do not clobber the PSFP cycle timer update period
>=20
> Willem de Bruijn <willemb@google.com>
>     virtio-net: fix frag overflow in big packets receive
>=20
> Eric Joyner <eric.joyner@amd.com>
>     ionic: free port_info when probe fails after the port is set up
>=20
> Nikhil P. Rao <nikhil.rao@amd.com>
>     ionic: fix port_info use-after-free on firmware recovery
>=20
> Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>
>     mailbox: qcom-cpucp: read mbox hardware register using readq()
>=20
> Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
>     mailbox: qcom-cpucp: Add support for Nord CPUCP mailbox controller
>=20
> Daniel Wagner <wagi@kernel.org>
>     nvme-fabrics: clear the poll map if no poll queues are mapped
>=20
> Daniel Wagner <wagi@kernel.org>
>     nvme-fabrics: limit each queue type to the number of online CPUs
>=20
> Daniel Wagner <wagi@kernel.org>
>     nvme-fabrics: reset io_queues before computing the queue mapping
>=20
> James Clark <james.clark@linaro.org>
>     perf cs-etm: Don't add global v0 HW_IDs to unformatted queues
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf cs-etm: Bounds-check CPU in cs_etm__get_queue()
>=20
> Namhyung Kim <namhyung@kernel.org>
>     perf c2c: Fix memory leaks on output fields
>=20
> Waldemar Brodkorb <wbx@openadk.org>
>     sh: Select BINFMT_FLAT_NO_DATA_START_OFFSET for !MMU
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate whe=
n idle
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ASoC: wm8994: fix MCLK index used for setting MCLK rate
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ASoC: wm8994: don't lose the AIF clock ratio when staying at 32kHz SY=
SCLK
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ASoC: wm8994: fix MCLK gating for AIF clocks sourced from MCLK2
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     selftests: ALSA: pcmtest: Compare all captured bytes in ni_capture
>=20
> Alexandre Cassen <acassen@corp.free.fr>
>     net/mlx5: HWS, fix modify header pattern compare on big-endian
>=20
> Anil Kaushik <anilkaushikwireless@gmail.com>
>     gtp: hold RCU for the device lookup when adding a PDP context
>=20
> Anil Kaushik <anilkaushikwireless@gmail.com>
>     gtp: set a valid genl command in PDP context get and dump replies
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     selftests: ALSA: pcmtest: Make room for the longest fill pattern
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     selftests: ALSA: pcmtest: Check the frame count of each transfer
>=20
> Takashi Iwai <tiwai@suse.de>
>     platform/x86: ibm_rtl: Fix potential OOB read at signature search
>=20
> Jiale Yao <yaojiale02@163.com>
>     Drivers: hv: vmbus: Check ACPI companion before use
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ocfs2: initialize status waiters before publishing them
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: reserve xattr value tree metadata only once
>=20
> Carolina Jubran <cjubran@nvidia.com>
>     net: skbuff: don't copy alloc_cpu in skb header copies
>=20
> Michail Andreas Michalopoulos <mike.michalo@gmail.com>
>     ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
>=20
> Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>
>     ksmbd: reject foreign RPC pipe handles on IPC$ read and write
>=20
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix fd_limit accounting across durable reconnects
>=20
> ChenXiaoSong <chenxiaosong@kylinos.cn>
>     smb/server: fix trailing period in generated short names
>=20
> Henry Hu <huhai@kylinos.cn>
>     ksmbd: report IPv4 and IPv6 addresses independently in iface query
>=20
> ZhangGuoDong <zhangguodong@kylinos.cn>
>     smb: move some duplicate definitions to common/smb2pdu.h
>=20
> ChenXiaoSong <chenxiaosong@kylinos.cn>
>     smb: move create_durable_rsp_v2 to common/smb2pdu.h
>=20
> ChenXiaoSong <chenxiaosong@kylinos.cn>
>     smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
>=20
> ChenXiaoSong <chenxiaosong@kylinos.cn>
>     smb: move create_durable_req_v2 to common/smb2pdu.h
>=20
> ZhangGuoDong <zhangguodong@kylinos.cn>
>     smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
>=20
> Pali Roh=C3=A1r <pali@kernel.org>
>     cifs: Update description about ACL permissions
>=20
> Henry Hu <huhai@kylinos.cn>
>     ksmbd: fix invalid Next offset in interface info replies
>=20
> Henry Hu <huhai@kylinos.cn>
>     ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioc=
tl()
>=20
> Henry Hu <huhai@kylinos.cn>
>     ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
>=20
> Mingming Cao <mmc@linux.ibm.com>
>     ibmveth: wait for the RX poll to return before freeing the RX queue
>=20
> Mingming Cao <mmc@linux.ibm.com>
>     ibmveth: wait for in-flight transmits in ibmveth_close()
>=20
> Mingming Cao <mmc@linux.ibm.com>
>     ibmveth: return the error when set_channels cannot add TX queues
>=20
> Mingming Cao <mmc@linux.ibm.com>
>     ibmveth: fix netpoll races with RX replenish
>=20
> Ovidiu Panait <ovidiu.panait.rb@renesas.com>
>     net: stmmac: Track the TX DMA threshold per queue
>=20
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     net: stmmac: Correct usage of maximum queue number macros
>=20
> Furong Xu <0x1207@gmail.com>
>     net: stmmac: Drop useless code related to ethtool rx-copybreak
>=20
> Jiale Yao <yaojiale02@163.com>
>     team: reject CAN, IEEE 802.15.4 and 6LoWPAN devices in team_port_add
>=20
> Ido Schimmel <idosch@nvidia.com>
>     ipv6: Hold RCU when emitting route hardware flags notification
>=20
> Rosen Penev <rosenp@gmail.com>
>     net: phy: marvell: keep WOL_EIE across interrupt reconfiguration
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     platform/x86: gpd pocket fan: Cancel work before releasing GPIOs
>=20
> Eric Dumazet <edumazet@kernel.org>
>     ipv6: account route exceptions to the netns of their dst
>=20
> Sagi Maimon <maimon.sagi@gmail.com>
>     net: axienet: release every RX buffer in axienet_dma_bd_release()
>=20
> Ido Schimmel <idosch@nvidia.com>
>     bridge: mcast: Delete empty MDB entry when port group creation fails
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     net: bcmasp: fix network filter lookup and wake filter pair allocation
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     net: bcmasp: account for offload header in TX short packet padding
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     net: bcmasp: fix OF node reference leak for phy_dn
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     net: bcmasp: validate minimum RX packet size in bcmasp_rx_poll()
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     net: bcmasp: unmap previous DMA mappings on TX map failure
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     net: bcmasp: fix mib counters struct alignment with ethtool stats
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     net: hix5hd2: serialize timeout recovery with interface teardown
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     net: phy: realtek: restore RTL8211F RGMII delays on resume
>=20
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: phy: realtek: create rtl8211f_config_rgmii_delay()
>=20
> Marek Vasut <marek.vasut@mailbox.org>
>     net: phy: realtek: Avoid PHYCR2 access if PHYCR2 not present
>=20
> Michael Klein <michael@fossekall.de>
>     net: phy: realtek: add RTL8211F register defines
>=20
> Daniel Braunwarth <daniel.braunwarth@kuka.com>
>     net: phy: realtek: Add support for WOL magic packet on RTL8211F
>=20
> Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>     net: phy: realtek: disable PHY-mode EEE
>=20
> Heiner Kallweit <hkallweit1@gmail.com>
>     net: phy: realtek: use string choices helpers
>=20
> Heiner Kallweit <hkallweit1@gmail.com>
>     net: phy: move realtek PHY driver to its own subdirectory
>=20
> Anirudh Virdi <avirdi@redhat.com>
>     net: qede: initialize extack in qede_flow_spec_to_rule()
>=20
> Binbin Deng <18983559317@163.com>
>     octeontx2: Fix use-after-free of qos node in delete path
>=20
> Rishikesh Jethwani <rjethwani@purestorage.com>
>     tls: device: protect async RX resync state during device-down
>=20
> Eric Dumazet <edumazet@kernel.org>
>     tcp: tcp_metrics: use the socket netns, not the dst device netns
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     net: openvswitch: drop IP fragments on SCTP set action
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     vhost: vringh: use get_user()/put_user() for IOTLB 16-bit accesses
>=20
> Rob Herring (Arm) <robh@kernel.org>
>     dt-bindings: clock: mediatek: Add MT8516 fallbacks
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: cs42l56: Remove the ADC Mute Switch control
>=20
> Liang Hao <haohlliang@gmail.com>
>     timers: Clear pending_map on CPU hotplug
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     rtc: class: Make the time32 hctosys limit configurable
>=20
> Baek Kyu, Kim <pocj8ur4in@gmail.com>
>     rtc: mpfs: Fix alarm register word order
>=20
> James Hilliard <james.hilliard1@gmail.com>
>     net: stmmac: avoid duplicate XSK TX completions
>=20
> Yongzhao Chen <yongzhao.derek@gmail.com>
>     net: phy: qca83xx: read resolved QCA8337 link status
>=20
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: options: dss: avoid printing uninit csum
>=20
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: options: mpc: avoid printing uninit data
>=20
> Pengfei Zhang <zhangfeionline@gmail.com>
>     net: stmmac: xgmac: do not treat TBU as a TX event
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/mlx5: Fix CQ resize destination index mask
>=20
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net/sched: act_api: reject duplicate actions in a batch
>=20
> Fan Wu <wufan@kernel.org>
>     ipe: fix enforcement audit
>=20
> Manuel Ebner <manuelebner@mailbox.org>
>     ipe: fix invalid sgid value in audit event documentation
>=20
> Gregory Price (Meta) <gourry@gourry.net>
>     cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
>=20
> Li RongQing <lirongqing@baidu.com>
>     block, bfq: initialize active lists for all actuators
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: aloop: Keep the timer source alive until card release
>=20
> Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
>     pNFS/flexfiles: make pg_init retry loops killable
>=20
> Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
>     nfsv4/pnfs: use the MDS authflavor for data server connections
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: pcm: Protect channel-map reads against runtime detach
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: jack: Pin the module while debugfs files are open
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: pcm: Remove channel-map controls before freeing substreams
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: pcmtest: Pin the module while pattern files are open
>=20
> Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
>     nios2: ksyms: Declare __mulsi3 export
>=20
> Sung Byeongchan <tjdqudcks0424@naver.com>
>     netfilter: xt_dccp: handle reserved options as single-byte
>=20
> Shuangfeng He <huangya90@gmail.com>
>     netfilter: flowtable: use the vlan id, not the full tci, in the tuple=
 key
>=20
> Julian Anastasov <ja@ssi.bg>
>     ipvs: fix more races around the overload flag
>=20
> J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
>=20
> Alok Tiwari <alok.a.tiwari@oracle.com>
>     octeontx2-af: Fix CQ enable state tracking after AQ writes
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: oss: Keep emulation modules loaded until object teardown
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: pcm: Protect the unregister notifier traversal
>=20
> Qiliang Yuan <odys.yuan@gmail.com>
>     selftests/bpf: Run the cpumask map insert tests only for the test task
>=20
> KaFai Wan <kafai.wan@linux.dev>
>     selftests/bpf: Use _exit() in uprobe_multi_test clone-ed child
>=20
> Troy Mitchell <troy.mitchell@linux.dev>
>     dt-bindings: vendor-prefixes: Add Sensylink
>=20
> Serhat Kumral <serhatkumral1@gmail.com>
>     RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
>=20
> Zhiwei Zhang <202275009@qq.com>
>     RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume =
control
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     ASoC: tlv320aic32x4: clean up driver code formatting and logging
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     ASoC: tlv320aic32x4: move regmap_config into i2c and spi drivers
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: sta350: Fix definition of limiter threshold controls
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: sta32x: Fix definition of limiter threshold controls
>=20
> Serhat Kumral <serhatkumral1@gmail.com>
>     RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() fail=
ure
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/core: Reject LAG selection when source MAC lookup fails
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/core: Free unpublished port statistics after initial-read failure
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/core: Preserve the selected source GID on failed AH modification
>=20
> Igor Velkov <iav@iav.lv>
>     power: supply: gpio-charger: Report discharging without input power
>=20
> Aleksandr Nogikh <nogikh@google.com>
>     usb: gadget: dummy_hcd: prevent unbind via sysfs
>=20
> Igor Skalkin <igor.skalkin@oss.qualcomm.com>
>     usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket
>=20
> Alexei Starovoitov <ast@kernel.org>
>     bpf: Use memmove() to store bytes in an xdp_buff
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Use memmove() to store bytes in an skb
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Use the socket of a sk_lookup test run under RCU
>=20
> Paul Chaignon <paul.chaignon@gmail.com>
>     bpf: Craft non-linear skbs in BPF_PROG_TEST_RUN
>=20
> Paul Chaignon <paul.chaignon@gmail.com>
>     bpf: Reorder bpf_prog_test_run_skb initialization
>=20
> Paul Chaignon <paul.chaignon@gmail.com>
>     bpf: Refactor cleanup of bpf_prog_test_run_skb
>=20
> Mahe Tardy <mahe.tardy@gmail.com>
>     bpf: fix cgroup_skb prog test run direct packet access
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Keep the symbols of a program until it has ended
>=20
> Alexei Starovoitov <ast@kernel.org>
>     bpf: Don't take a program with a target program for an iterator
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nft_compat: restrict raw table targets/matches
>=20
> Florian Westphal <fw@strlen.de>
>     selftests: netfilter: fix return value in zone subtest
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: fix unlikely UaF in gc worker
>=20
> Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
>     power: supply: qcom_battmgr: report full batteries
>=20
> Alexei Starovoitov <ast@kernel.org>
>     bpf: Don't take an extension for a writable raw tracepoint program
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Don't take an extension for an iterator program
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Don't bind a program to a netdev that goes away
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Fix stale offload->prog pointer after realloc
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Bound the nesting that the BTF show code follows
>=20
> Alexei Starovoitov <ast@kernel.org>
>     bpf: Clear sk_refcnt of a clone before its storage is linked
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Update the SRH state if End.B6 fails late
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Pull the inner header for End.DT6 in End.BPF
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Validate the SRH which End.DT6 uncovers in End.BPF
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Read the probe of a perf event under event_mutex
>=20
> Tao Chen <chen.dylane@linux.dev>
>     bpf: Add show_fdinfo for perf_event
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Don't let bpf_skb_adjust_room() use up the MSS
>=20
> Jakub Sitnicki <jakub@cloudflare.com>
>     bpf: Make bpf_skb_adjust_room metadata-safe
>=20
> Jakub Sitnicki <jakub@cloudflare.com>
>     net: Helper to move packet data and metadata after skb_push/pull
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Look at all 64 bits of a BPF_JSET mask on 32-bit
>=20
> Josef Bacik <josef@toxicpanda.com>
>     bpf: Reject sleepable programs for task_vma iterator
>=20
> Joonhoe Kim <26rote@gmail.com>
>     power: supply: qcom_battmgr: report the USB type from USB_ADAP_TYPE
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: jack: Protect the index scan against control removal
>=20
> Brad Fitzpatrick <bradfitz@tailscale.com>
>     gre: keep the UDP tunnel GSO type when completing GRO
>=20
> Joas Antonio dos Santos <joasantonio108@gmail.com>
>     calipso: update payload_len when removing the CALIPSO option
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass con=
trols
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass con=
trols
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: tlv320adc3xxx: Fix definition of AGC Target Level contr=
ol
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
>=20
> Yuan Chen <chenyuan@kylinos.cn>
>     bpf: Claim the per-CPU send_signal irq_work before filling it
>=20
> Puranjay Mohan <puranjay@kernel.org>
>     bpf: Implement bpf_send_signal_task() kfunc
>=20
> Sasha Levin <sashal@kernel.org>
>     ARC: Strip libgcc debug information when generating BTF
>=20
> Tal Zussman <tz2294@columbia.edu>
>     btrfs: update the inode item when removing a free space inode
>=20
> Tal Zussman <tz2294@columbia.edu>
>     btrfs: drop the extent maps of the written part of a failed ordered e=
xtent
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: remove leftover EXTENT_UPTODATE clear from an inode's io_tree
>=20
> Piotr Gli=C5=BAniewicz <p.glizniewicz@gmail.com>
>     ALSA: 6fire: take stream_mutex in the Digital Thru control
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     platform: cznic: turris-omnia-mcu: stop button emulation producers
>=20
> =C3=96mer Mete Kaya <omermetekaya0@gmail.com>
>     usbnet: fix smp_processor_id() use in preemptible context
>=20
> Fabrice Derepas <fabrice.derepas@canonical.com>
>     ima: reject a kexec buffer whose declared size exceeds the buffer
>=20
> Tao Cui <cuitao@kylinos.cn>
>     blk-iocost: account zone append completions in latency stats
>=20
> Tao Cui <cuitao@kylinos.cn>
>     blk-iocost: charge zone appends as writes
>=20
> Colin Ian King <colin.i.king@gmail.com>
>     selftests/bpf: Fix spelling mistakes in descr literal strings
>=20
> Yuan Chen <chenyuan@kylinos.cn>
>     bpftool: Fix inverted tracefs validation when scanning /proc/mounts
>=20
> Qiliang Yuan <odys.yuan@gmail.com>
>     selftests/bpf: Expect at least one kprobe miss in missed/perf_kprobe
>=20
> Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
>     HID: wacom: fix wacom_intuos_irq NULL pen_input deref
>=20
> Dmitriy Geels <dmitriy.geels@gmail.com>
>     HID: logitech-hidpp: cancel reset_hi_res_work on probe failure
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: vmaster: Protect follower lookup and setup
>=20
> Qiliang Yuan <odys.yuan@gmail.com>
>     selftests/bpf: Unmount the bpffs that cgroup_hierarchical_stats mount=
ed
>=20
> Qiliang Yuan <odys.yuan@gmail.com>
>     selftests/bpf: Keep the bpffs of cgroup_hierarchical_stats private
>=20
> Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
>     net: use the full socket in sk_mc_loop()
>=20
> Eric Dumazet <edumazet@kernel.org>
>     ipv4: use RCU protection in inet_netconf_get_devconf()
>=20
> George Melikov <mail@gmelikov.ru>
>     bnx2x: fix header length calculation for encapsulated TSO
>=20
> Muchun Song <muchun.song@linux.dev>
>     dax/bus: Return errors for invalid mapping targets
>=20
> Stefano Munari <stefanomunari.sm@gmail.com>
>     net: usb: lan78xx: reject invalid EEPROM write requests
>=20
> J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     macsec: prevent AES-GCM nonce reuse after packet number wrap
>=20
> KaFai Wan <kafai.wan@linux.dev>
>     selftests/bpf: Fix prog_tests framework subtest count checks
>=20
> Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>     tracing: Print a signed histogram key as signed
>=20
> Atharva Vartak <atharva.a.vartak@gmail.com>
>     net/smc: hold a reference on net_device returned by pnet_find_base_nd=
ev()
>=20
> Jianan Huang <jnhuang95@gmail.com>
>     f2fs: quota: fix quota flush failure during filesystem freeze
>=20
> pengdonglin <pengdonglin@xiaomi.com>
>     tracing: Avoid BTF lookup in atomic context
>=20
> Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>     tracing: Clamp the printed end of a histogram bucket at U64_MAX
>=20
> Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>     tracing: Only report the stacktrace modifier on a real field
>=20
> Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>     tracing: Print the bucket size as unsigned
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix ETDM probe error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix HDMI TX startup error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix ETDM startup error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix ETDM MCLK error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Propagate IRQ lookup errors
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix runtime resume error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix FE startup error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix paired memif clock error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix main clock error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix timing system clock error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix register access clock error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8195: Fix tuner clock error handling
>=20
> Amadeusz S=C5=82awi=C5=84ski <amade@asmblr.net>
>     ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer=
()
>=20
> Amadeusz S=C5=82awi=C5=84ski <amade@asmblr.net>
>     ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
>=20
> Amadeusz S=C5=82awi=C5=84ski <amade@asmblr.net>
>     ASoC: soc-card-test: Check return value of kunit_device_register()
>=20
> Amadeusz S=C5=82awi=C5=84ski <amade@asmblr.net>
>     ASoC: soc-topology-test: Check return value of kunit_device_register()
>=20
> Amadeusz S=C5=82awi=C5=84ski <amade@asmblr.net>
>     ASoC: ops: Fix return value in snd_soc_limit_volume()
>=20
> Amadeusz S=C5=82awi=C5=84ski <amade@asmblr.net>
>     ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger
>=20
> Hongbo Li <lihongbo22@huawei.com>
>     ASoC: remove unused substream in macro soc_link_mark_pop
>=20
> Abraham Zukor <abe@maticrobots.com>
>     spi: tegra114: initialize native chip selects inactive
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: rockchip: rk3288_hdmi_analog: Use dev_err_probe() for error han=
dling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: rockchip: rk3288_hdmi_analog: Drop redundant probe error messag=
es
>=20
> Sasha Levin <sashal@kernel.org>
>     selftests: keep the build status from wrapping to success
>=20
> Michael Auer <mick@yoxcu.de>
>     ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown
>=20
> Robert Oscilowski <drgitx@gmail.com>
>     ASoC: qcom: sdm845: set quaternary MI2S codec DAI to I2S format
>=20
> Alexey Klimov <alexey.klimov@linaro.org>
>     ASoC: qcom: sdm845: add handling of secondary MI2S clock
>=20
> Cezary Rojewski <cezary.rojewski@intel.com>
>     ASoC: Intel: avs: Prevent module info underflow
>=20
> Cezary Rojewski <cezary.rojewski@intel.com>
>     ASoC: Intel: avs: Unprepare a stream when recovery occurs
>=20
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
>=20
> Serhat Kumral <serhatkumral1@gmail.com>
>     IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
>=20
> Sasha Levin <sashal@kernel.org>
>     kselftest/arm64: signal: copy each test binary only once
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: core: Serialize snd_refcount put and sync
>=20
> Qiliang Yuan <odys.yuan@gmail.com>
>     selftests/bpf: Create the vxlan devices of test_tunnel with their MAC
>=20
> Jaewon Jung <jaewon8868@gmail.com>
>     selftests/ftrace: Avoid unlink error on first run
>=20
> Youngsung Ahn <ays511.kr@gmail.com>
>     RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
>=20
> Honggang LI <honggangli@163.com>
>     RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA mes=
sage in 2GiB size
>=20
> xiongweimin <xiongweimin@kylinos.cn>
>     RDMA/rxe: Hold netdev reference for transmit skbs
>=20
> Youngsung Ahn <ays511.kr@gmail.com>
>     RDMA/rxe: validate inline sge_offset in finish_packet() before indexi=
ng inline_data[]
>=20
> Youngsung Ahn <ays511.kr@gmail.com>
>     RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
>=20
> Youngsung Ahn <ays511.kr@gmail.com>
>     RDMA/rxe: refuse to destroy a QP with type 2 MWs still bound
>=20
> Sahaj Chaudhari <sahaj123.sc@gmail.com>
>     spi: omap2-mcspi: handle DMA setup failures
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcm: Add refcount for races between drain and unlink
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: Add simple refcount helper functions
>=20
> Zhu Ling <zhuling2709@phytium.com.cn>
>     irqchip/gic: Fix UBSAN shift-out-of-bounds in GIC helpers
>=20
> Fuad Tabba <fuad.tabba@linux.dev>
>     irqchip/gic-v3: Don't register a redistributor that was never counted
>=20
> Fuad Tabba <fuad.tabba@linux.dev>
>     irqchip/gic-v3-its: Don't free the tables of an enabled ITS
>=20
> Fuad Tabba <fuad.tabba@linux.dev>
>     irqchip/gic-v3-its: Don't free a vPE table shared with another ITS
>=20
> Steven Price <steven.price@arm.com>
>     irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor
>=20
> Pengpeng Hou <hppiscas@163.com>
>     irqchip/riscv-imsic: Reject overlapping group index fields
>=20
> Fuad Tabba <fuad.tabba@linux.dev>
>     irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
>=20
> David Howells <dhowells@redhat.com>
>     rxrpc: Revert "rxrpc: rxperf: Fix missing decoding of terminal magic =
cookie"
>=20
> Carolina Jubran <cjubran@nvidia.com>
>     IB/IPoIB: Cancel normal flush work on device stop
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     veth: clear rx queue hint in veth_xmit
>=20
> Qiliang Yuan <odys.yuan@gmail.com>
>     selftests/bpf: Expect at least one tp_recursion miss in missed
>=20
> Sagi Maimon <maimon.sagi@gmail.com>
>     net: axienet: free outstanding TX buffers in axienet_dma_bd_release()
>=20
> Kyrylo Biryuk <illofspeed@gmail.com>
>     ata: libahci: re-enable FBS after error handling on a port multiplier
>=20
> Long Zhao <longzhao@ambarella.com>
>     dt-bindings: vendor-prefixes: add Ambarella
>=20
> Fenglin Wu <fenglin.wu@oss.qualcomm.com>
>     spmi: pmic-arb: return 0 in spmi_pmic_arb_register_buses() on success
>=20
> Xingui Yang <yangxingui@huawei.com>
>     scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait=
 state
>=20
> Damien Le Moal <dlemoal@kernel.org>
>     scsi: core: Prepare for using combined sense codes
>=20
> Damien Le Moal <dlemoal@kernel.org>
>     scsi: core: Rename sense field of struct scsi_failure
>=20
> Damien Le Moal <dlemoal@kernel.org>
>     scsi: core: Define all additional sense codes and their qualifiers
>=20
> Damien Le Moal <dlemoal@kernel.org>
>     scsi: scsi_debug: move ASC and ASCQ definitions to scsi_proto.h
>=20
> Niklas Cassel <cassel@kernel.org>
>     scsi: libsas: Add dev_parent_is_expander() helper
>=20
> Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
>     scsi: scsi_debug: Add write support with block lengths and 4 bytes of=
 data
>=20
> Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
>     scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
>=20
> Xingui Yang <yangxingui@huawei.com>
>     scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
>=20
> Xingui Yang <yangxingui@huawei.com>
>     scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net/mlx5e: use skb_share_check() in the loopback selftest hook
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: stmmac: selftests: use skb_share_check() in the loopback receive=
 hook
>=20
> Nicolai Buchwitz <nb@tipi-net.de>
>     net: selftests: use skb_share_check() in the loopback receive hook
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: MSFT: Serialize handle map cleanup with event processing
>=20
> Kiran K <kiran.k@intel.com>
>     Bluetooth: btintel: Zero version data before parsing TLVs
>=20
> Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
>     Bluetooth: btintel: propagate version TLV parsing errors
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: hci_sync: Protect IRK identity reads with RCU
>=20
> Eric Dumazet <edumazet@kernel.org>
>     Bluetooth: btmtk: fix skb double free on ISO padding failure
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: 6lowpan: Drain RCU readers on registration failure
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: msft: Lock failed probe cleanup against feature readers
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: MGMT: Reject quality report requests during unregister
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: ISO: Hold the listener during disconnect notification
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: hci_sync: Serialize devcoredump reset during device open
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: hci_core: Keep RCU protection through LTK filtering
>=20
> Hitalo Souza <enghitalo@gmail.com>
>     Bluetooth: Add missing newline to bt_dev_{err,warn}_ratelimited()
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: 6LoWPAN: Use RCU-safe device list removal
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: MGMT: Fix leaking instance on Add Extended Advertising Par=
ameters
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: MGMT: Fix pending state of instances added without HCI tra=
ffic
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: HCI: Fix tracking of instances sharing handle 0x00
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: MGMT: Fix advertising instances with Global Advertising
>=20
> Kiran K <kiran.k@intel.com>
>     Bluetooth: btusb: Preserve event and ACL packet ordering
>=20
> Zijun Hu <zijun.hu@oss.qualcomm.com>
>     Bluetooth: btusb: Make btusb_recv_{event,acl}() take struct hci_dev *
>=20
> Chris Lu <chris.lu@mediatek.com>
>     Bluetooth: btmtk: Improve BT firmware logging
>=20
> Chris Lu <chris.lu@mediatek.com>
>     Bluetooth: btmtk: Validate the firmware layout before parsing it
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: L2CAP: hold l2cap_conn::lock in l2cap_connect_cfm()
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: L2CAP: take chan->lock for l2cap_chan_add/ready/del
>=20
> Chris Lu <chris.lu@mediatek.com>
>     Bluetooth: btmtksdio: Pass the hardware device id to mt79xx_setup()
>=20
> Chris Lu <chris.lu@mediatek.com>
>     Bluetooth: btmtksdio: Remove redundant firmware filename override
>=20
> Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
>     PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_si=
mple() error path
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     ARM: 9492/1: alignment: fix LSR #32 and ASR #32 offset decoding
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     ARM: 9486/1: set !LPAE MAX_PHYSMEM_BITS to 32 and remove supersection=
 mappings
>=20
> Atul Akella <atul.akella@gmail.com>
>     rpmsg: virtio: fix error handling in TX buffer wait
>=20
> Patrick Oppenlander <patrick.oppenlander@gmail.com>
>     rpmsg: virtio: EPOLLOUT support
>=20
> Dr. David Alan Gilbert <linux@treblig.org>
>     rpmsg: virtio: Remove uncallable offchannel functions
>=20
> Avi Weiss <thnkslprpt@gmail.com>
>     rpmsg: mtk: release channel OF node on device teardown
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8737: Fix definition of zero cross switches
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume con=
trol
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time c=
ontrols
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume c=
ontrol
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8991: Fix definition of right input PGA controls
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume c=
ontrol
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: wm8990: Fix definition of right input PGA controls
>=20
> Tim Douglas <me@timdoug.com>
>     serial: pmac_zilog: report received breaks
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     serial: ma35d1: Do not force-enable an unselected console
>=20
> Muhammad Bilal <meatuni001@gmail.com>
>     platform/x86: hp-bioscfg: fix oops on short integer attribute buffer
>=20
> Muhammad Bilal <meatuni001@gmail.com>
>     platform/x86: hp-bioscfg: validate SPM state returned by firmware
>=20
> Muhammad Bilal <meatuni001@gmail.com>
>     platform/x86: hp-bioscfg: fix off-by-one in password length check
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: pcm: Unlink substreams before releasing them
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: track SSID regardless of country data
>=20
> Julian Anastasov <ja@ssi.bg>
>     ipvs: fix buffer overflow when sending sync messages
>=20
> Binbin Deng <18983559317@163.com>
>     module: Fix uninitialized count read of unloaded taint tracking record
>=20
> Kees Cook <kees@kernel.org>
>     mm/slab: Mark the kmem_buckets_create() context as a Context: section
>=20
> Vlastimil Babka <vbabka@suse.cz>
>     mm, slab: add kerneldocs for common SLAB_ flags
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_senso=
r_data() kernel-doc
>=20
> Florian Fainelli <florian.fainelli@broadcom.com>
>     tools/thermal/tmon: Fix string truncation warning in optarg copy
>=20
> Weigang He <geoffreyhe2@gmail.com>
>     thermal/drivers/sprd: validate the sensor id from the device tree
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Use fixed control index for us16x08 mixer elements
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: vmaster: Serialize hook registration with control callbacks
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: line6: Use kzalloc() for PCM buffer allocation
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcm: Protect delay DMA sync in forward and rewind, too
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
>=20
> Amadeusz S=C5=82awi=C5=84ski <amade@asmblr.net>
>     ALSA: pcm: Fix driver_tstamp value reporting
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     kcov: report spurious PCs in the interrupt selftest
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     resource, kunit: stop selecting GET_FREE_REGION
>=20
> Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>     ocfs2: validate chunk and block counts of the local quota file
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: fix possible deadlock between nfs_sync_rwlock and fs_reclaim
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: retain all security xattrs during inode creation
>=20
> Zhiling Zou <zhilinz@nebusec.ai>
>     lib: validate in-memory LZ4 chunk length
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: scsi_debug: Fix a locking bug in resp_write_same()
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     ASoC: codecs: wcd937x: request watchdog IRQs without devm
>=20
> Priyanka Mani <priyankamani2100@gmail.com>
>     ASoC: mediatek: mt8365: Fix out-of-bounds read in get_iir_coef()
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: atmel-i2s: use optional API for gclk
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: atmel-i2s: use optional API for muxclk
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: atmel-i2s: fix MCK generator error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: intel: atom: Fix .shutdown() being skipped on rollback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: Intel: atom: Use scoped_guard() for scoped locking
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: intel: atom: Use __free(kfree) for stream pointer
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollb=
ack
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on ro=
llback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: yc: Fix acp6x_pdm_dma_close() being skipped on rollback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: ps: Fix acp63_sdw_dma_close() being skipped on rollback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: ps: Fix acp63_pdm_dma_close() being skipped on rollback
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: amd: acp: Fix .close() being skipped on rollback
>=20
> Mingxuan Guo <gmx472@qq.com>
>     firmware: cs_dsp: clear dsp->running on the cs_dsp_run() error path
>=20
> Yao Sang <sangyao@kylinos.cn>
>     nvme: pass partition flags to passthrough checks
>=20
> Sung Byeongchan <tjdqudcks0424@naver.com>
>     nvmet-auth: reject undersized AUTH_SEND payloads
>=20
> Palla Raghunath <raghunathpalla.0209@gmail.com>
>     nvmet-fc: don't drop the last assoc reference in nvmet_fc_delete_ctrl=
()
>=20
> Surabhi Gogte <sgogte@purestorage.com>
>     nvme-tcp: store and use the caller's network namespace
>=20
> Peijie Shao <shaopeijie@cestc.cn>
>     nvme-tcp: fix selinux denied when calling sock_sendmsg
>=20
> Heiko Carstens <hca@linux.ibm.com>
>     s390/uprobes: Fix off-by-one bug in emulated PER handling
>=20
> Heiko Carstens <hca@linux.ibm.com>
>     s390/ptrace: Preserve ILC when updating system call number
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     clk: qcom: rcg2: Clear force enable after rate failure
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     clk: qcom: rcg2: Propagate force-enable status errors
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     clk: qcom: rcg2: Initialize shared floor clock state
>=20
> Abel Vesa <abel.vesa@oss.qualcomm.com>
>     clk: qcom: mmcc-msm8960: Configure PLL15 only on APQ8064
>=20
> Abel Vesa <abel.vesa@oss.qualcomm.com>
>     clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset
>=20
> Abel Vesa <abel.vesa@oss.qualcomm.com>
>     clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     clk: qcom: gcc-x1e80100: Don't poll the status bit of GCC_USB4_n_SYS_=
CLK
>=20
> Yuho Choi <oss.patchbox@gmail.com>
>     bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_p=
ort()
>=20
> Yuho Choi <oss.patchbox@gmail.com>
>     bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()
>=20
> Linkai Gong <gonglinkai@kylinos.cn>
>     char: scx200_gpio: check cdev_add() return value
>=20
> Sasha Levin <sashal@kernel.org>
>     tools: hv: remove unused rte_smp_mb()
>=20
> Weigang He <geoffreyhe2@gmail.com>
>     thermal/drivers/ti-soc-thermal: Cancel pending alert work on remove
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     comedi: pcmuio: validate the IRQs supplied by userspace
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     comedi: pcmmio: validate the IRQ supplied by userspace
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     comedi: dmm32at: validate the IRQ supplied by userspace
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     comedi: dt2814: validate the IRQ supplied by userspace
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     comedi: ni_atmio16d: validate the IRQ supplied by userspace
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     comedi: comedi_parport: validate the IRQ supplied by userspace
>=20
> Thomas Fourier <fourier.thomas@gmail.com>
>     net: alacritech: fix dma_free_coherent() in error path
>=20
> Weiming Shi <bestswngs@gmail.com>
>     fs/ntfs3: do not mark frame pages uptodate on read error
>=20
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: remove ntfs_bio_pages and use page cache for compressed I/O
>=20
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     ntfs: Do not kmap pages used for reading from disk
>=20
> Ethan Ferguson <ethan.ferguson@zetier.com>
>     ntfs3: add FS_IOC_SETFSLABEL ioctl
>=20
> Ethan Ferguson <ethan.ferguson@zetier.com>
>     ntfs3: add FS_IOC_GETFSLABEL ioctl
>=20
> Tapio Reijonen <tapio.reijonen@vaisala.com>
>     serial: max310x: don't power down the port mid-transmission on close
>=20
> Tapio Reijonen <tapio.reijonen@vaisala.com>
>     serial: max310x: fix RS485 delays being programmed as bit-times
>=20
> Tapio Reijonen <tapio.reijonen@vaisala.com>
>     serial: max310x: centralize the RS485 transceiver programming
>=20
> Tapio Reijonen <tapio.reijonen@vaisala.com>
>     serial: max310x: fix breaks not reaching the wire in RS485 mode
>=20
> Tapio Reijonen <tapio.reijonen@vaisala.com>
>     serial: max310x: don't clobber the TX break bit in set_termios
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     tcp_cubic: fix divide by zero and endless loop on bad module params
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     tcp_hybla: fix divide by zero on rtt0 =3D=3D 0
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     tcp_bic: fix divide by zero on max_increment =3D=3D 0
>=20
> Jeff Chen <jeff.chen_1@nxp.com>
>     wifi: mwifiex: append hotfix number to firmware version string
>=20
> Chien Wong <m@xv97.com>
>     wifi: mac80211: reserve MME tailroom for protected beacons
>=20
> Chien Wong <m@xv97.com>
>     wifi: mac80211: fix encryption tailroom
>=20
> Yonatan Nachum <ynachum@amazon.com>
>     RDMA/efa: Fix race between admin command timeout and completion
>=20
> Haitam Lazaar <haitam@lazaarsec.com>
>     RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses
>=20
> Luca Leonardo Scorcia <l.scorcia@gmail.com>
>     clocksource/drivers/timer-mediatek: Fix random crash at boot
>=20
> Joas Antonio dos Santos <joasantonio108@gmail.com>
>     calipso: hash the cache key, not the option start, in calipso_cache_a=
dd()
>=20
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>     PCI: qcom: Honor IOMMU provider's #iommu-cells in qcom_pcie_config_si=
d_1_9_0()
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: pcm: Protect delay DMA sync against concurrent HW_FREE
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: rawmidi: Drain input work before freeing the runtime
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     fbdev: gxt4500: Release WC setup on probe failure
>=20
> Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>     platform/x86/amd/pmc: clear devm-managed pointers on remove to preven=
t stale reuse
>=20
> Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>     platform/x86/amd/pmc: Use managed APIs for mutex
>=20
> Jiale Yao <yaojiale02@163.com>
>     platform/olpc: Reserve space for a string terminator
>=20
> Aleksandrova Alyona <aga@itb.spb.ru>
>     platform/x86: intel_telemetry: initialize default trace verbosity
>=20
> Daasaradhi Mannava <daasaradhimannava@gmail.com>
>     platform/x86: msi-ec: Report valid charge thresholds when unset
>=20
> Ahmed Yaseen <yaseen@ghoul.dev>
>     platform/x86: asus-wmi: validate custom fan curves on enable
>=20
> Ali Ahmet Memi=C5=9F <aliamemis@disroot.org>
>     ALSA: hda: intel: Don't free card in the probe work
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: jack: Remove debugfs before freeing unregistered jacks
>=20
> Dan Carpenter <error27@gmail.com>
>     mm/hmm/test: reject overflowing page counts
>=20
> Harry Yoo (Meta) <harry@kernel.org>
>     selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback t=
est
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: ath10k: avoid IDR mutation during TX cleanup
>=20
> Kunwu Chan <kunwu.chan@gmail.com>
>     rcutorture: Fix divide-by-zero with fwd_progress_div=3D1
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: codecs: rt5659: propagate GPIO errors
>=20
> Roberto Bergantinos Corpas <rbergant@redhat.com>
>     nfs: set gencount on protocol-specific remove
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interf=
ace()
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     power: supply: generic-adc-battery: Propagate charged GPIO errors
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: defrag: fix check to see if next extent can be defragged too
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: qgroup: fix swapped blocks existence check when tracing after =
COW
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix off-by-one end offset check in report_setget_bounds()
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: accessors: inline eb bounds check and factor out the error rep=
ort
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: accessors: use type sizeof constants directly
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: accessors: simplify folio bounds checks
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: accessors: delete token versions of set/get helpers
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: don't use token set/get accessors in inode.c:fill_inode_item()
>=20
> David Sterba <dsterba@suse.com>
>     btrfs: don't use token set/get accessors for btrfs_item members
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix incomplete iteration over fs state when logging messages
>=20
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_m=
od_log_insert_root()
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix off by one super block end offset calculation when writing=
 super blocks
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: refactor read_key_bytes() to remove the dest_folio parameter
>=20
> Tal Zussman <tz2294@columbia.edu>
>     block: honor IOCB_NOWAIT in the block device buffered read path
>=20
> Tal Zussman <tz2294@columbia.edu>
>     block: use iomap_dirty_folio for block devices
>=20
> Jiale Yao <yaojiale02@163.com>
>     ACPI: PCI: pci_link: clear driver_data before free
>=20
> Adri=C3=A1n Larumbe <adrian.larumbe@collabora.com>
>     drm/panfrost: Explicitly enable MMU interrupts at device init
>=20
> Ali Ahmet Memi=C5=9F <aliamemis@disroot.org>
>     ALSA: control_led: Fix deadlock between sysfs writes and card disconn=
ect
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: control: Relax __free() variable declarations
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-snapshot: make the chunk list sorted by the chunk number
>=20
> Yuan Chen <chenyuan@kylinos.cn>
>     bpftool: Fix out-of-bounds read in kprobe_multi link info dump
>=20
> Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
>     RDMA/mlx5: Cancel software CQ notifications before teardown
>=20
> Mark Zhang <markzhang@nvidia.com>
>     RDMA/mlx5: Support driver APIs pre_destroy_cq and post_destroy_cq
>=20
> Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
>     RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
>=20
> Ting-Han Hou <ue081723@gmail.com>
>     ALSA: virtio: reset I/O message fill level on prepare
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: timer: Pin the module for userspace timer controllers
>=20
> Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
>     mailbox: qcom-ipcc: remove stray disable_irq_wake() call
>=20
> Linkai Gong <gonglinkai@kylinos.cn>
>     mailbox: arm_mhuv2: time out if the receiver never comes up
>=20
> Beleswar Padhi <b-padhi@ti.com>
>     mailbox: ti-msgmgr: Read exact number of trailing message bytes
>=20
> Breno Leitao <leitao@debian.org>
>     mailbox: pcc: Free the channel before unmapping the shared memory
>=20
> Sang-Hoon Choi <csh0052@gmail.com>
>     xhci: dbc: lock the minor IDR on registration failure
>=20
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>     bpf, riscv: Fix stack-passed arguments for indirect trampolines
>=20
> Kees Cook <kees@kernel.org>
>     kbuild: Mark the initcall ordering recipe as recursive
>=20
> Maxim Skokov <skokovmaksimevg@gmail.com>
>     bpf: test_run: Fix false -EBADMSG after skb leaves CHECKSUM_COMPLETE
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: Add NULL check for the driver pointer at unsol event work
>=20
> Ting-Han Hou <ue081723@gmail.com>
>     scripts/make_fit: Ignore schema checks when decomposing DTBs
>=20
> Ting-Han Hou <ue081723@gmail.com>
>     clang-tools: Import os for broken pipe handling
>=20
> Leizhen Zhang <lzsx618@gmail.com>
>     kconfig: fix infinite loop in conf_choice() when no choice value is v=
isible
>=20
> Jiale Yao <yaojiale02@163.com>
>     vfio/pci: Drain eventfd RCU callbacks on module exit
>=20
> Leon Romanovsky <leon@kernel.org>
>     PCI/P2PDMA: Gate the host bridge whitelist warning on verbose
>=20
> Leon Romanovsky <leon@kernel.org>
>     PCI/P2PDMA: Safely terminate ACS redirect lists
>=20
> Antoni Pokusinski <apokusinski01@gmail.com>
>     rtc: abx80x: properly handle shared IRQs
>=20
> Antoni Pokusinski <apokusinski01@gmail.com>
>     rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()
>=20
> Leo Cheng <leo-cheng@vip.qq.com>
>     nvmem: layouts: onie-tlv: fix device_node reference leak in error path
>=20
> Leo Cheng <leo-cheng@vip.qq.com>
>     nvmem: layouts: sl28vpd: fix device_node reference leak in error path
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mac80211: use link address as TA for non-MLO 4-addr station on =
MLD AP
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: reg: protect regdb pointer with RCU
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix mbssid/rnr allocation in beacon data
>=20
> Aloka Dixit <aloka.dixit@oss.qualcomm.com>
>     wifi: mac80211: remove redundant null check in ieee80211_assign_beaco=
n()
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: limit injected HT/VHT MCSes
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: init radiotap iter after length checks
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: kill wake_txqs_tasklet on unregistration
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: mesh: use hlist_add_head_rcu()
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: clear fragment cache entry 'is_protected'
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: ath6kl: don't take RTNL in del_virtual_intf
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: intel: Cancel delayed work at shutdown, too
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: line6: Fix potential OOB write in line6_capture_copy()
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: line6: Reject too small max packet sizes
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb: us16x08: Fix racy accesses of mixer elements
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Fix data race at mixer_ctl_feature_info()
>=20
> Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>     ALSA: usb: mixer: use snd_kcontrol_chip()
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: caiaq: Fix races at MIDI URB and trigger accesses
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     gpu: buddy: Drop the stale @p line from the gpu_buddy_print() kernel-=
doc
>=20
> Jan Beulich <jbeulich@suse.com>
>     x86/PVH: don't truncate initrd address/size
>=20
> Gui-Dong Han <hanguidong02@gmail.com>
>     xen/blkback: Prevent missed completion when draining I/O
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     xen/pcifront: Fix PCI device reference leak in AER handling
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     cpufreq: qcom-cpufreq-hw: fix device node refcount leak in phandle pa=
rsing
>=20
> Jake Labelle <southampton.jake.labelle@gmail.com>
>     nilfs2: reject non-regular inodes in dsync recovery
>=20
> Micha=C5=82 Kope=C4=87 <michal@nozomi.space>
>     ASoC: mediatek: mt8188: Constrain UL8 FE to its back end's capabiliti=
es
>=20
> Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>     ASoC: mediatek: remove dpcm_xxx flags
>=20
> Micha=C5=82 Kope=C4=87 <michal@nozomi.space>
>     ASoC: mediatek: common: Keep codec references until the card is bound
>=20
> Rosen Penev <rosenp@gmail.com>
>     crypto: talitos - init tasklets before requesting IRQs
>=20
> Rosen Penev <rosenp@gmail.com>
>     crypto: talitos - Use platform_get_irq() to retrieve interrupt
>=20
> Rosen Penev <rosenp@gmail.com>
>     crypto: talitos - use devm_platform_ioremap_resource()
>=20
> Rosen Penev <rosenp@gmail.com>
>     crypto: talitos - allocate channels with main struct
>=20
> George Abraham P <george.abraham.p@intel.com>
>     crypto: qat - force an edge when re-enabling all VF2PF interrupts
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: Don't free card at probe error in vga_switcheroo handler
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/intel: Move firmware loading into the probe work
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: Avoid non-operational GPU warning at regular device removal
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: info: Fix memory leak at card removal
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Fix missing direction and ump_group handling in 32bit comp=
at ioctl
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: core: Add missing barriers for power_ref vs card->shutdown
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcmtest: Fix a bogus pointer read in snd_pcmtst_pcm_pointer()
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: Fix potential UAF for gating jack
>=20
> Krzysztof Wilczy=C5=84ski <kwilczynski@kernel.org>
>     PCI/sysfs: Handle a malformed _DSM result in acpi_attr_is_visible()
>=20
> Krzysztof Wilczy=C5=84ski <kwilczynski@kernel.org>
>     PCI/sysfs: Stop reporting _DSM failures as -EPERM
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8365: Handle constraint return value in FE startup
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8188: Handle constraint return value in FE startup
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: common: Handle constraint return value in FE startup
>=20
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: copy function name into dcn_optc_lock_unlock_state t=
race event
>=20
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: copy function name into dcn_fpu trace event
>=20
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: use right type for amdgpu_dc_performance event entri=
es
>=20
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: fix vready offset assignment in dcn_optc_lock_unlock=
_state
>=20
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: remove duplicated prev_p_state_change_support assign=
ment
>=20
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_st=
ate
>=20
> Ting-Han Hou <ue081723@gmail.com>
>     checkkconfigsymbols.py: Parse Git status output line by line
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt792x: compute the assoc RSSI from the chain signals
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     kobject: Fix the kobj_set_name reference in kset_register() kernel-doc
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in se=
t_fmt
>=20
> John Crispin <john@phrozen.org>
>     wifi: mt76: mt7996: disable the RX NAPIs before the DMA cleanup
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7996: fix PLE free page and AC queue register offsets
>=20
> Cristian Papa <pcristian292@gmail.com>
>     wifi: mt76: feed the station RSSI average from the chain signals
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     wifi: mt76: mt7615: validate MCU response lengths
>=20
> Ahmed Naseef <naseefkm@gmail.com>
>     wifi: mt76: mt7615: read MT7663 temperature from the correct offset
>=20
> Ryan Leung <untilscour@protonmail.com>
>     wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()
>=20
> Cristian Papa <pcristian292@gmail.com>
>     wifi: mt76: mt7603: don't drop short frames looped back on PS entry
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: mt76: usb: fix source overread in mt76u_copy
>=20
> Mark Anthony Agarro <markanthonyagarro@gmail.com>
>     wifi: mt76: mt7925: keep the join ROC until the station is authorized
>=20
> Mark Anthony Agarro <markanthonyagarro@gmail.com>
>     wifi: mt76: mt7921: keep the join ROC until the station is authorized
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: mt76: mt76x02: validate RX padding before use
>=20
> Ryan Leung <untilscour@protonmail.com>
>     wifi: mt76: fix wcid teardown ordering in mt76_reset_device()
>=20
> Ryan Leung <untilscour@protonmail.com>
>     wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
>=20
> Ryan Leung <untilscour@protonmail.com>
>     wifi: mt76: mt7915: publish wcid before MCU add commands
>=20
> Devin Wittmayer <lucid_duck@justthetip.ca>
>     wifi: mt76: mt7921: honour FIF_FCSFAIL instead of hardcoding drop_err
>=20
> Mark Anthony Agarro <markanthonyagarro@gmail.com>
>     wifi: mt76: mt7925: honour mac80211's FIF_FCSFAIL instead of hardcodi=
ng drop_err
>=20
> Devin Wittmayer <lucid_duck@justthetip.ca>
>     wifi: mt76: mt7925: fix the lock inversion in suspend and resume
>=20
> Devin Wittmayer <lucid_duck@justthetip.ca>
>     wifi: mt76: mt7921: fix the lock inversion in suspend and resume
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails
>=20
> Devin Wittmayer <lucid_duck@justthetip.ca>
>     wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path
>=20
> Devin Wittmayer <lucid_duck@justthetip.ca>
>     wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
>=20
> Devin Wittmayer <lucid_duck@justthetip.ca>
>     wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_=
mtx
>=20
> Devin Wittmayer <lucid_duck@justthetip.ca>
>     wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_=
mtx
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7915: guard firmware memory dump write on disabled memd=
ump
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7996: validate firmware event lengths before parsing
>=20
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7915: check default EEPROM firmware size before copying
>=20
> Jiale Yao <yaojiale02@163.com>
>     pinctrl: sprd: free maps on DT map failure
>=20
> Leizhen Zhang <lzsx618@gmail.com>
>     gen_init_cpio: stop parsing on lines with a missing argument list
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: caiaq: Allow zero-length packet handling for EP1
>=20
> Priyank Rathod <rathodpriyank@google.com>
>     PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices=
()
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: reject inconsistent xattr bucket during defrag
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: allow xattr bucket entries to span multiple blocks
>=20
> Wilson Felipe Pereira <wfelipe@google.com>
>     init/main: fix false-positive kernel panic on environment variable ov=
erwrite
>=20
> Wilson Felipe Pereira <wfelipe@google.com>
>     init/main: fix off-by-one in argv_init cleanup
>=20
> Florian Schmaus <florian.schmaus@codasip.com>
>     selftests/epoll: fix race condition in multi-waiter wakeup tests
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: fix deadlock in inline-data truncate transactions
>=20
> Petr Vorel <pvorel@suse.cz>
>     checkpatch: skip CamelCase cache for --no-tree without root
>=20
> Wilson Felipe Pereira <wfelipe@google.com>
>     selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in =
test_no_kmem_bypass
>=20
> Li Wang <li.wang@linux.dev>
>     selftests/cgroup: replace hardcoded page size values in test_zswap
>=20
> Li Wang <li.wang@linux.dev>
>     selftests/cgroup: use runtime page size for zswpin check
>=20
> Li Wang <li.wang@linux.dev>
>     selftests/cgroup: avoid OOM in test_swapin_nozswap
>=20
> Li Wang <li.wang@linux.dev>
>     selftests/cgroup: skip test_zswap if zswap is globally disabled
>=20
> Jiayuan Chen <jiayuan.chen@shopee.com>
>     selftests/cgroup: add test for zswap incompressible pages
>=20
> Guopeng Zhang <zhangguopeng@kylinos.cn>
>     selftests/cgroup: conform test to KTAP format output
>=20
> Michal Koutn=C3=BD <mkoutny@suse.com>
>     selftests: cgroup: Optionally set up v1 environment
>=20
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix link count underflow when removing corrupted directory
>=20
> Roberto Bergantinos Corpas <rbergant@redhat.com>
>     NFS: return DENIED in decode_lock_denied if we cannot decode owner
>=20
> Marc Kleine-Budde <mkl@pengutronix.de>
>     spi: spi-sun4i: sun4i_spi_handler(): fix race condition between trans=
fer completion and RX FIFO interrupt
>=20
> Marc Kleine-Budde <mkl@pengutronix.de>
>     spi: spi-sun4i: sun4i_spi_transfer_one(): fix setting of clock rate
>=20
> Marc Kleine-Budde <mkl@pengutronix.de>
>     spi: spi-sun4i: sun4i_spi_fill_fifo(): always apply A10 FIFO fill lev=
el workaround
>=20
> Marc Kleine-Budde <mkl@pengutronix.de>
>     spi: spi-sun4i: sun4i_spi_transfer_one(): fix transfers for SUN4I_FIF=
O_DEPTH
>=20
> Linus Walleij <linusw@kernel.org>
>     dt-bindings: dma: dma40: Restore disabled-channels
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     efi/libstub: Free cmdline_ptr in efi_pe_entry
>=20
> Vincent Mailhol <mailhol@kernel.org>
>     efi/libstub: make local GUID variables static
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     x86/efistub: Merge PE and handover entrypoints
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     efi/libstub: Use cleanup helpers for freeing copies of the memory map
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     efi/libstub: Simplify PCI I/O handle buffer traversal
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     efi/libstub: Simplify GOP handling code
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     efi/libstub: Use C99-style for loop to traverse handle buffer
>=20
> Ard Biesheuvel <ardb@kernel.org>
>     x86/efistub: Drop long obsolete UGA support
>=20
> Nicolas Saenz Julienne <nsaenz@amazon.com>
>     x86/efi: Drop support for the EFI_PROPERTIES_TABLE
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     efi/riscv: libstub: Don't set image_size in handle_kernel_image()
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exi=
t_boot()
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     sh: defconfig: Enable the current M66592 UDC symbol
>=20
> Florian Fuchs <fuchsfl@gmail.com>
>     sh: uaccess: Require offsettable operands for 64-bit user access
>=20
> Aurelien Jarno <aurelien@aurel32.net>
>     riscv: fix RVG_SYSTEM_CSR_MASK width mask
>=20
> Eric Dumazet <edumazet@kernel.org>
>     ipv4: reserve one IP ID per segment for UDP GSO packets
>=20
> Eric Dumazet <edumazet@kernel.org>
>     ipv4: fix IP ID reuse in ip_select_ident_segs()
>=20
> Chen-Yu Tsai <wens@kernel.org>
>     arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
>=20
> Chen-Yu Tsai <wens@kernel.org>
>     arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video e=
ngine
>=20
> Mike Snitzer <snitzer@kernel.org>
>     pNFS/flexfiles: don't reset to MDS for v4 error when previous layout =
forbid it
>=20
> Mike Snitzer <snitzer@kernel.org>
>     pNFS/flexfiles: don't read through MDS when previous layout forbid it
>=20
> Mike Snitzer <snitzer@kernel.org>
>     pNFS/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS over the mdsthreshold h=
int
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Validate memcpy configuration
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Validate fixed physical channel indexes
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix V4B event group mapping
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix event group bounds
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix logical channel bounds check
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Reject direction changes after allocation
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Validate DMA specifier length
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Validate disabled channel indexes
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix memcpy channel parsing
>=20
> Rosen Penev <rosenp@gmail.com>
>     dmaengine: ste_dma40: turn d40_base phy_chans into a flexible array
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Put the LCPA SRAM node
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix probe LCLA free
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix LCLA allocation order
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix DMA registration unwind
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix probe IRQ leak
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Init hardware before registration
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Handle runtime PM resume errors
>=20
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     dmaengine: ste_dma40: Remove redundant pm_runtime_mark_last_busy() ca=
lls
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Check runtime PM in IRQ
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix probe runtime PM disable
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix failed start cleanup
>=20
> Linus Walleij <linusw@kernel.org>
>     dmaengine: ste_dma40: Fix physical cyclic capability
>=20
> Roman Demidov <roman.demidov.nn@gmail.com>
>     drm/msm/a6xx: fix use-after-free of OPP in a6xx_pm_resume
>=20
> Jiale Yao <yaojiale02@163.com>
>     wifi: ath12k: Reserve space for a string terminator
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     floppy: unregister platform device on add_disk failure
>=20
> Yang Xiuwei <yangxiuwei@kylinos.cn>
>     floppy: avoid NULL deref in reset_interrupt when cont is cleared
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     floppy: flush pending work before releasing resources on init failure
>=20
> J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     NFS: filelayout: calculate dense stripe width in 64 bits
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     SUNRPC: treat every client-side TLS error alert as fatal
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     SUNRPC: reject a client-side TLS alert record that is not two octets
>=20
> Logan Gunthorpe <logang@deltatee.com>
>     dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()
>=20
> Logan Gunthorpe <logang@deltatee.com>
>     dmaengine: ioat: disable relaxed ordering before registering the devi=
ce
>=20
> Aloka Dixit <aloka.dixit@oss.qualcomm.com>
>     Revert "wifi: mac80211: do not use old MBSSID elements"
>=20
> Dan Carpenter <error27@gmail.com>
>     wifi: carl9170: NUL terminate string in debugfs
>=20
> Dan Carpenter <error27@gmail.com>
>     wifi: b43legacy: debugfs: NUL terminate string in debugfs
>=20
> Dan Carpenter <error27@gmail.com>
>     wifi: b43: don't pass unterminated string to sscanf()
>=20
> Dominic White <github@singe.za.net>
>     wifi: cfg80211: allow zero HE OBSS PD offsets
>=20
> Yibo Tan <lhfff@tju.edu.cn>
>     soc: qcom: pmic_pdcharger_ulog: prevent work requeue during remove
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     soc: qcom: pmic_glink: Avoid losing early rpmsg probe
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     soc: qcom: pmic_glink: simplify locking with guard()
>=20
> Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
>     firmware: qcom: tzmem: Use DO_ONCE_SLEEPABLE() in qcom_tzmem_enable()
>=20
> Joonhoe Kim <26rote@gmail.com>
>     drm/msm/dpu: round up the compressed INTF width
>=20
> Xueqin Luo <luoxueqin@kylinos.cn>
>     cpufreq: sti: avoid NULL dereference in dev_err()
>=20
> Xueqin Luo <luoxueqin@kylinos.cn>
>     cpufreq: tegra194: fix double-pointer error in get_cpu_ndiv
>=20
> Xueqin Luo <luoxueqin@kylinos.cn>
>     cpufreq: sparc-us2e: fix frequency table index copy-paste error
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     svcrdma: Fix svc_rdma_recv_cid_init() kernel-doc
>=20
> hpp.iscas <hppiscas@163.com>
>     perf/marvell: cn10k_tad: Publish the OF module alias
>=20
> Hongyan Xu <getshell@seu.edu.cn>
>     ASoC: mt6359-accdet: manage private workqueues with devres
>=20
> Yaozhong Li <yaozhonguwl@gmail.com>
>     arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly
>=20
> Yaozhong Li <yaozhonguwl@gmail.com>
>     arm64: dts: rockchip: fix analog headphone output on rk3399-firefly
>=20
> Detlev Casanova <detlev.casanova@collabora.com>
>     arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards
>=20
> Dragan Simic <dsimic@manjaro.org>
>     arm64: dts: rockchip: Prepare RK356x SoC dtsi files for per-variant O=
PPs
>=20
> Dragan Simic <dsimic@manjaro.org>
>     arm64: dts: rockchip: Update CPU OPP voltages in RK356x SoC dtsi
>=20
> Linus Walleij <linusw@kernel.org>
>     ARM: dts: ux500: Use AB8505 charger compatible
>=20
> Detlev Casanova <detlev.casanova@collabora.com>
>     arm64: dts: rockchip: Rename rk3328 HDMI audio card
>=20
> Jiale Yao <yaojiale02@163.com>
>     ASoC: rt722-sdca: always cancel jack work on remove
>=20
> Jiale Yao <yaojiale02@163.com>
>     ASoC: rt712-sdca: always cancel jack work on remove
>=20
> Jiale Yao <yaojiale02@163.com>
>     ASoC: rt711-sdca: always cancel jack work on remove
>=20
> Jiale Yao <yaojiale02@163.com>
>     ASoC: rt711-sdw: always cancel jack work on remove
>=20
> Jiale Yao <yaojiale02@163.com>
>     ASoC: rt5682-sdw: always cancel jack work on remove
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_fg: Finalize current measurements
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_charger: Recover inactive AB8505 charger
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_charger: Retry AB8505 USB detection
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_charger: Skip absent AB8505 main charger
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_charger: Handle detection errors
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_charger: Respect AB8505 register layout
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_charger: Decode AB8505 USB status
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_charger: Fix AC charger re-enable
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500: Preserve battery termination current
>=20
> Linus Walleij <linusw@kernel.org>
>     power: supply: ab8500_btemp: Fix event temperature reporting
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     selftests/alsa: Do not take another control's event as our own
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     spi: bcm63xx-hsspi: Disable runtime PM on remove
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     spi: fsl: unmap immr_spi_cs on remove
>=20
> Johan Hovold <johan@kernel.org>
>     spi: fsl: switch to managed controller allocation
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     perf/dwc_pcie: Fix PCI device reference leak in probe
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Clear stale overflow status before using a counter
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Don't log through pmu.dev in the overflow interrupt handler
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Validate the hardware-reported counter width
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Unfreeze counters after handling an overflow interrupt
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Don't share the overflow interrupt, and keep it pinned
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Accept an overflow interrupt on MSI message number 0
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Fix the counter overflow delta fixup
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Clear stale event fields before reprogramming a counter
>=20
> Dave Jiang <dave.jiang@intel.com>
>     perf/cxl: Program the requested event group on configurable counters
>=20
> Jan Stancek <jstancek@redhat.com>
>     .gitignore: drop Module.markers
>=20
> Linus Walleij <linusw@kernel.org>
>     dt-bindings: power: supply: ab8500: Add AB8505 charger
>=20
> Zhihao Cheng <chengzhihao1@huawei.com>
>     md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
>=20
> Ryan Brue <ryanbrue.dev@gmail.com>
>     power: supply: bq24190_charger: don't reset registers across system s=
uspend
>=20
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     power: supply: bq24190: Remove redundant pm_runtime_mark_last_busy() =
calls
>=20
> Chen-Yu Tsai <wens@kernel.org>
>     dt-bindings: media: sun4i-a10-video-engine: Fix IOMMU count for H6
>=20
> Sang-Hoon Choi <csh0052@gmail.com>
>     md/raid5: protect big_stripe_tree lookup with RCU
>=20
> Linkai Gong <gonglinkai@kylinos.cn>
>     clk: imx: composite-93: return timeout from gate enable
>=20
> Li Youhong <liyouhong@kylinos.cn>
>     md/raid5: drain released_stripes before destroying the cache
>=20
> Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>     md: take reconfig_mutex when enabling PPL on an inactive array
>=20
> Aristo Chen <aristo.chen@canonical.com>
>     phy: freescale: fsl-samsung-hdmi: initialize default rate
>=20
> Pei Xiao <xiaopei01@kylinos.cn>
>     phy: freescale: fsl-samsung-hdmi: Use helper function devm_clk_get_en=
abled()
>=20
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Support dynamic integer
>=20
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Simplify REG21_PMS_S_MASK lookup
>=20
> Adam Ford <aford173@gmail.com>
>     phy: freescale: fsl-samsung-hdmi: Replace register defines with macro
>=20
> Laurence Oberman <loberman@redhat.com>
>     scsi: st: Record the tape position after a successful MTLOAD
>=20
> Laurence Oberman <loberman@redhat.com>
>     scsi: st: Restore changed drive settings after reset also for MTLOAD =
and MTRETEN
>=20
> Niklas Cassel <cassel@kernel.org>
>     scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
>=20
> Niklas Cassel <cassel@kernel.org>
>     scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
>=20
> Niklas Cassel <cassel@kernel.org>
>     scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
>=20
> Niklas Cassel <cassel@kernel.org>
>     scsi: scsi_debug: Take the zone metadata lock before the data lock
>=20
> Niklas Cassel <cassel@kernel.org>
>     scsi: scsi_debug: Refuse a negative physblk_exp
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Only enable USB3 when not in high-speed mode
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Handle rk_udphy_reset_deassert errors
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Avoid xHCI SErrors
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Rename mode_change to phy_needs_reinit
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Hold mutex in DP PHY configure
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Properly handle TYPEC_STATE_SAFE and TYPEC_STAT=
E_USB
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Drop DP HPD handling
>=20
> Zhang Yubing <yubing.zhang@rock-chips.com>
>     phy: rockchip: usbdp: Support single-lane DP
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Add missing mode_change update
>=20
> Frank Wang <frank.wang@rock-chips.com>
>     phy: rockchip: usbdp: add rk3576 device match data
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Limit DP lane count to muxed lanes
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Drop seamless DP takeover
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Handle missing clock-names DT property graceful=
ly
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Fix devm_clk_bulk_get_all check
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Do not lose USB3 PHY status
>=20
> Sebastian Reichel <sebastian.reichel@collabora.com>
>     phy: rockchip: usbdp: Update mode_change after error handling
>=20
> Akash Sukhavasi <akash.sukhavasi@gmail.com>
>     phy: HiSilicon: Fix error handling in hi3670_pcie_allclk_ctrl()
>=20
> Joonhoe Kim <26rote@gmail.com>
>     drm/msm/dpu: compute the CRTC bandwidth from the state being checked
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: handle perf mode in _dpu_core_perf_crtc_update_bus()
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: drop core_clk_rate overrides from _dpu_core_perf_calc_cr=
tc
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: make fix_core_ab_vote consistent with fix_core_ib_vote
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: change ib values to u32
>=20
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: extract bandwidth aggregation function
>=20
> Joonhoe Kim <26rote@gmail.com>
>     drm/msm/dpu: disable the slave encoder before the master
>=20
> Oleg Keri <okerixx@gmail.com>
>     drm/msm/dp: don't report link training success after a reinit
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     soc/tegra: flowctrl: Release OF node reference on error
>=20
> Igor Velkov <iav@iav.lv>
>     arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz
>=20
> Igor Velkov <iav@iav.lv>
>     arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and =
WP# pins
>=20
> Mostafa Saleh <smostafa@google.com>
>     iommu/arm-smmu-v3-test: Fix arm_smmu_v3_test_debug_print_used_bits()
>=20
> Mostafa Saleh <smostafa@google.com>
>     iommu/arm-smmu-v3: Ensure L2 tables are visible before L1 ptrs
>=20
> Yuri Zaporozhets <yuriz@vodafonemail.de>
>     ASoC: dwc: Use OF match data again for StarFive JH7110
>=20
> Matthias Goergens <matthias.goergens@gmail.com>
>     isofs: return long Joliet names whole
>=20
> Slavin Liu <bolin.liu@seu.edu.cn>
>     clocksource/drivers/dbx500-prcmu: Check timer register mapping
>=20
> Thorsten Blum <blum@kernel.org>
>     hwrng: intel - return -ENOMEM when ioremap() fails
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: ump: Avoid dereference with max_src_size=3D0
>=20
> Liu Dalin <liudalin@kylinsec.com.cn>
>     rtc: ftrtc010: fix integer overflow in time calculation
>=20
> Thorsten Blum <blum@kernel.org>
>     hwrng: intel - return -ENOMEM when kmalloc_obj() fails
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: tcrypt - Avoid reading req->base after submission
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     crypto: atmel - handle authenc requests without plaintext
>=20
> Bartosz Szpila <bszpila@google.com>
>     platform/chrome: cros_ec_typec: Validate SVID and mode counts in disc=
overy data
>=20
> Hemanth Selam <hemanth.selam@gmail.com>
>     nvdimm/pmem: Release gendisk on probe failure
>=20
> Mikko Perttunen <mperttunen@nvidia.com>
>     drm/tegra: Drop reference on postfence
>=20
> Mikko Perttunen <mperttunen@nvidia.com>
>     drm/tegra: Don't pass an ERR_PTR to drm_syncobj_replace_fence()
>=20
> Mikko Perttunen <mperttunen@nvidia.com>
>     drm/tegra: Fix syncobj_in wait return value check
>=20
> Lance Yang <lance.yang@linux.dev>
>     mm/memory_hotplug: fix missing rollback in __add_pages()
>=20
> Chuanhong Guo <gch981213@gmail.com>
>     pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     cpufreq: amd-pstate: Propagate cppc_set_auto_sel() errors on mode cha=
nge
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     cpufreq: amd-pstate: Restore previous mode when changing driver mode =
fails
>=20
> Ian Rogers <irogers@google.com>
>     perf thread_map: Add thread_map__tgid()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf bpf: Move the LIBBPF_CURRENT_VERSION_GEQ macro to bpf-utils.h
>=20
> Ian Rogers <irogers@google.com>
>     perf trace: Copy sockaddr arguments by their length
>=20
> Shuming Fan <shumingf@realtek.com>
>     ASoC: rt712: avoid duplicate reset in io_init
>=20
> Yichong Chen <chenyichong@uniontech.com>
>     debugfs: make debugfs_create_str() read-only
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     misc: nsm: fix CBOR short-length decoding
>=20
> Jasper Wise <jaspwise@amazon.co.uk>
>     misc: nsm: mark device ready before registering the hwrng and misc de=
vice
>=20
> Linkai Gong <gonglinkai@kylinos.cn>
>     misc: enclosure: fix UAF on device_register() failure
>=20
> Omar Ramadan <omar@blockcast.net>
>     amt: pull the AMT header behind the transport header in amt_parse_typ=
e()
>=20
> Yuya Kusakabe <yuya.kusakabe@gmail.com>
>     seg6: fix HMAC validation when an extension header precedes the SRH
>=20
> Mateusz Nowicki <mateusz.nowicki@posteo.net>
>     arm64: dts: st: fix sai3b unit address on stm32mp231
>=20
> Weigang He <geoffreyhe2@gmail.com>
>     ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepa=
re_cpus()
>=20
> Weigang He <geoffreyhe2@gmail.com>
>     ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()
>=20
> Liu Dalin <liudalin@kylinsec.com.cn>
>     rtc: ftrtc010: use devm clock APIs to fix use-after-disable in remove
>=20
> Liu Dalin <liudalin@kylinsec.com.cn>
>     rtc: ftrtc010: fix clock resource leak on probe failure
>=20
> Andr=C3=A9 Draszik <andre.draszik@linaro.org>
>     rtc: ftrtc010: drop needless struct ftrtc010_rtc::rtc_dev member
>=20
> Ze Huang <ze.huang@oss.qualcomm.com>
>     drm/imx/lcdc: avoid duplicate clk_per enable
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
>=20
> Lucas Costa <2000.costalucas@gmail.com>
>     staging: sm750fb: free cmap on framebuffer release
>=20
> Xilin Wu <sophon@radxa.com>
>     drm/msm/dp: Initialize the debugfs connector pointer
>=20
> Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>     drm/msm/mdp5: drop cursor pipe for msm8x76
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     dt-bindings: display/msm: hdmi: Correct name of disallowed supplies
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     drm/msm: Properly handle msm_ioremap() without name
>=20
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: skip stats handling for channel VSIs on rebuild
>=20
> Qingfang Deng <qingfang.deng@linux.dev>
>     ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
>=20
> Matthias Goergens <matthias.goergens@gmail.com>
>     x86/hibernate: Ignore page-zero RAM in E820 checksum
>=20
> Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>
>     dt-bindings: vendor-prefixes: Add Sophos
>=20
> Danish Khateeb <danishkhateeb03@gmail.com>
>     tools/nolibc: check for overflow in malloc()
>=20
> Danish Khateeb <danishkhateeb03@gmail.com>
>     tools/nolibc: stop rounding malloc() sizes up to 4096 bytes
>=20
> Arnd Bergmann <arnd@arndb.de>
>     f2fs: quota: fix unused-label warning
>=20
> Andreas Kemnade <andreas@kemnade.info>
>     rtc: bd70528: properly enable wakeup
>=20
> Nguy=E1=BB=85n V=C4=83n Cao Nguy=C3=AAn <nguyennvc@greennode.ai>
>     RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET
>=20
> Nicolas Schier <n.schier@fritz.com>
>     kconfig: tests: Provide defconfig outfile for savedefconfig
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     pinctrl: stm32: Fix clock reference leak in stm32_pctl_probe()
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     pinctrl: nuvoton: Fix clock reference leak in ma35_get_bank_data()
>=20
> Hongyan Xu <getshell@seu.edu.cn>
>     RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
>=20
> Hongyan Xu <getshell@seu.edu.cn>
>     RDMA/hfi1: shut down the trap timer before unregistering
>=20
> Serhat Kumral <serhatkumral1@gmail.com>
>     RDMA/siw: Fix length of first chunk in siw_try_1seg()
>=20
> Quanye Yang <quanyeyang@proton.me>
>     RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id
>=20
> Alireza Haghdoost <haghdoost@uber.com>
>     perf symbols: Don't let a module's last symbol overlap the next module
>=20
> Qingshuang Fu <fuqingshuang@kylinos.cn>
>     selftests/timers: clocksource-switch: Fix unchecked open()/read()
>=20
> Abdifatah Suruur <suruurism@gmail.com>
>     vfio/cdx: prevent read-only region mappings from becoming writable
>=20
> Abdifatah Suruur <suruurism@gmail.com>
>     vfio/fsl-mc: prevent read-only region mappings from becoming writable
>=20
> Abdifatah Suruur <suruurism@gmail.com>
>     vfio/platform: prevent read-only region mappings from becoming writab=
le
>=20
> Quanye Yang <quanyeyang@proton.me>
>     RDMA/rtrs-clt: Don't WARN on unexpected info-response opcode
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     time: Prevent time64_to_tm() day truncation on 32-bit
>=20
> Jiale Yao <yaojiale02@163.com>
>     RDMA/cxgb4: Do not allow userspace to write the status page
>=20
> Jiale Yao <yaojiale02@163.com>
>     RDMA/mlx4: Do not allow the user to write to the clock page
>=20
> Jiale Yao <yaojiale02@163.com>
>     RDMA/mad: Reject receive completions shorter than GRH
>=20
> Ian Rogers <irogers@google.com>
>     perf python: Initialize debug output on module load
>=20
> Quanye Yang <quanyeyang@proton.me>
>     RDMA/rtrs-clt: Reject invalid queue_depth from the peer
>=20
> Yili Zhang <zhangyili01@baidu.com>
>     RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FA=
ILURE
>=20
> Pengpeng Hou <hppiscas@163.com>
>     clk: si5351: fail prepare when PLL reset times out
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     clk: ti: adpll: unregister OF clock provider on remove
>=20
> Dairui Zhang <zhangdairui@gmail.com>
>     IB/mad: fix UAF and double-free in RMPP receive reassembly
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     media: venus: Drop session events without an instance
>=20
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
>=20
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Fix the PD and DPI table size
>=20
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
>=20
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Validate SRQ max_sge at create time
>=20
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Detect wrong sge_len passed for inline
>=20
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Fix integer overflow in send payload size computation
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim3: Fix FDEJECT ioctl for exclusive open
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Fix FDEJECT ioctl for exclusive open
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Return -EROFS when opened with BLK_OPEN_WRITE flag
>=20
> Logan Odell <loganodell@google.com>
>     PCI/IOV: Read VF config values that need not match PF
>=20
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx93-9x9-qsb: fix reserved memory node names for remotep=
roc
>=20
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx93-14x14-evk: fix reserved memory node names for remot=
eproc
>=20
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8ulp-evk: fix reserved memory node names for remoteproc
>=20
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8qm-mek: fix reserved memory node names for remoteproc
>=20
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8dxl-evk: fix reserved memory node names for remoteproc
>=20
> Li RongQing <lirongqing@baidu.com>
>     IB/isert: Don't share drop_cmd_list across concurrent connection tear=
downs
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
>=20
> Waiman Long <longman@redhat.com>
>     cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root=
 only
>=20
> Waiman Long <longman@redhat.com>
>     cgroup/cpuset: Disable cpuset_cpumask_can_shrink() test if not load b=
alancing
>=20
> Xiang Mei (Microsoft) <xmei5@asu.edu>
>     fs/ntfs3: fix slab-out-of-bounds write in attr_insert_range()
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     soc: ti: k3-ringacc: Correct ring API kernel-doc
>=20
> Ian Rogers <irogers@google.com>
>     perf vendor events intel: Fix snowridgex umask encoding.
>=20
> Ian Rogers <irogers@google.com>
>     perf vendor events intel: Fix skylakex umask encoding.
>=20
> Ian Rogers <irogers@google.com>
>     perf vendor events intel: Fix sierraforest umask encoding.
>=20
> Ian Rogers <irogers@google.com>
>     perf build: Clean libperf-gtk.so in 'make clean'
>=20
> Ian Rogers <irogers@google.com>
>     perf test code-reading: Fix duplicate kernel maps and machine leak
>=20
> Ian Rogers <irogers@google.com>
>     perf machine: Explicitly pass in host perf_env
>=20
> Ian Rogers <irogers@google.com>
>     perf test: Avoid use perf_env
>=20
> Ian Rogers <irogers@google.com>
>     perf debug: Add function symbols to dump_stack
>=20
> Ian Rogers <irogers@google.com>
>     perf machine: Factor creating a "live" machine out of dwarf-unwind
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192-mt6359: Fix error handling in MTKAIF calibrati=
on
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: Propagate errors in I2S DAI DAPM event handle=
rs
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: Propagate errors in TDM DAI DAPM event handle=
rs
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: Propagate mt8192_afe_gpio_request() errors in=
 ADDA DAI
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime res=
ume
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: mt8192-afe-gpio: Use guard() for mutex locks
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: switch to devm_clk_get_optional()
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: fix MCK clock error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: fix error handling in APLL enable functions
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: fix AFE clock error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8192: fix APLL mux error handling
>=20
> Ovidiu Panait <ovidiu.panait.rb@renesas.com>
>     spi: rspi: Fix DMA mode when the DMA controller is built as a module
>=20
> Niko Huuskonen <niko.huuskonen.00@gmail.com>
>     ALSA: caiaq: Fix the Kore controller key map
>=20
> Niko Huuskonen <niko.huuskonen.00@gmail.com>
>     ALSA: caiaq: Serialize access to the EP1 command buffer
>=20
> Arka Mondal <arka@arkamondal.net>
>     iio: dac: ad5758: Fix the offset calculation
>=20
> Arka Mondal <arka@arkamondal.net>
>     iio: dac: ad5758: Reject out-of-range raw values
>=20
> Arka Mondal <arka@arkamondal.net>
>     iio: dac: ad5758: Fix alignment for DMA safety
>=20
> Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
>     staging: iio: adc: ad7816: Protect sysfs attributes with mutex
>=20
> Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
>     staging: iio: adc: ad7816: Serialize SPI operations
>=20
> Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
>     staging: iio: adc: ad7816: Sort headers alphabetically
>=20
> Chen-Yu Tsai <wenst@chromium.org>
>     drm/exynos/fimd: fix register offset type in fimd_trigger()
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     ALSA: via82xx: use helper to activate DXS controls
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     ALSA: oxygen: use helper to activate the SPDIF PCM control
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: oxygen: Use guard() for mutex locks
>=20
> Yibo Tan <lhfff@tju.edu.cn>
>     ASoC: amd: acp3x-es83xx: Keep an owned codec device reference
>=20
> Yibo Tan <lhfff@tju.edu.cn>
>     ASoC: amd: acp-es8336: Use an owned codec device reference
>=20
> Yishai Hadas <yishaih@nvidia.com>
>     RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
>=20
> Yishai Hadas <yishaih@nvidia.com>
>     RDMA/mlx5: Set RQ event handler for raw-packet QP
>=20
> Yishai Hadas <yishaih@nvidia.com>
>     RDMA/mlx5: Set SRQ event handler before xarray insertion
>=20
> Yishai Hadas <yishaih@nvidia.com>
>     RDMA/mlx5: Set WQ event handler before firmware RQ insertion
>=20
> Yishai Hadas <yishaih@nvidia.com>
>     RDMA/hns: Pin CQ buffer writable to match device DMA write access
>=20
> Ginger Li <ginger.jzllee@gmail.com>
>     wifi: mac80211: Fix a race when expiring a mesh path
>=20
> Mateusz Nowicki <mateusz.nowicki@posteo.net>
>     arm64: dts: st: fix arm,smc-id of the SMC watchdog on stm32mp2
>=20
> Alexandre Torgue <alexandre.torgue@foss.st.com>
>     arm64: dts: st: introduce stm32mp23 SoCs family
>=20
> Guanghui Feng <guanghuifeng@linux.alibaba.com>
>     iommu/vt-d: Fix IQE handling to cover all descriptors in submission r=
ange
>=20
> Abel Vesa <abel.vesa@oss.qualcomm.com>
>     arm64: dts: qcom: sm8150: Use SM8150_CX for the SDHC power domain
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     PCI: aardvark: Disable PHY on probe failures
>=20
> Linus Walleij <linusw@kernel.org>
>     ARM: dts: gemini: Use a level-high interrupt for TVE200
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: synproxy: fix reset of ct seqadj when reopening a connecti=
on
>=20
> Akhil P Oommen <akhilpo@oss.qualcomm.com>
>     drm/msm/a6xx: Fix secondary rail vote in ARC votes
>=20
> Daniel Palmer <daniel@0x0f.com>
>     m68k: apollo: Fix interrupt setup
>=20
> Shashank Mohan Jain <jain.sm@gmail.com>
>     bitmap: bitmap_parselist(): don't wrap around on a huge group size
>=20
> Shashank Mohan Jain <jain.sm@gmail.com>
>     bitmap: bitmap_parselist(): reject trailing characters after group si=
ze
>=20
> Shashank Mohan Jain <jain.sm@gmail.com>
>     bitmap: bitmap_parse(): reject non-hex character before 8 digits
>=20
> WangYuli <wangyuli@uniontech.com>
>     MIPS: Only check -msym32 when need-compiler
>=20
> Orgad Shaneh <orgads@gmail.com>
>     MIPS: Octeon: size the swiotlb for a modular OHCI platform driver
>=20
> Peter Wang <peter.wang@mediatek.com>
>     scsi: ufs: core: Serialize AHIT register access between sysfs and hos=
t driver
>=20
> Aaron Kling <webgeek1234@gmail.com>
>     dt-bindings: vendor-prefixes: Add Retroid Pocket
>=20
> Marek Vasut <marek.vasut+renesas@mailbox.org>
>     dt-bindings: vendor-prefixes: Add Retronix Technology Inc.
>=20
> Adam Skladowski <a39.skl@gmail.com>
>     dt-bindings: vendor-prefixes: Add LeEco
>=20
> Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>     ARM: dts: qcom: msm8974: add MDSS reset
>=20
> Luca Weiss <luca@lucaweiss.eu>
>     ARM: dts: qcom: msm8974: Sort header includes alphabetically
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     ARM: dts: qcom: msm8974: Use the header with DSI phy clock IDs
>=20
> Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
>     arm64: dts: qcom: lemans-ride-common: fix SerDes PHY regulator suppli=
es
>=20
> Bruno Produit <bruno.produit@trailofbits.com>
>     hfs/hfsplus: serialize B-tree close against folio release
>=20
> Paul Sajna <sajattack@postmarketos.org>
>     arm64: dts: qcom: sdm845-lg: fix sdcard pinctrl nodes
>=20
> Aaron Kling <webgeek1234@gmail.com>
>     dt-bindings: vendor-prefixes: Add Chip Wealth Technology
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8183: Fix APLL enable error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8183: Fix clock handling in mux disable path
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() f=
ailure
>=20
> Sudeep Holla <sudeep.holla@kernel.org>
>     ACPI: PCC: Preserve shared memory signature in OpRegion handler
>=20
> Sudeep Holla <sudeep.holla@arm.com>
>     ACPI: PCC: Simplify PCC shared memory region handling
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf annotate-data: Resolve type DIEs in the debug file they came from
>=20
> Sudeep Holla <sudeep.holla@kernel.org>
>     ACPICA: Fix PCC OperationRegion command offsets
>=20
> Breno Leitao <leitao@debian.org>
>     ACPICA: Fix memory leak in acpi_ds_create_field()
>=20
> Xin Yin <yinxin.x@bytedance.com>
>     writeback: size foreign flushes by target wb dirty pages
>=20
> Jeff Johnson <jeff.johnson@oss.qualcomm.com>
>     wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_eve=
nt()
>=20
> Qingfang Deng <qingfang.deng@linux.dev>
>     mtd: block: prevent reclaim I/O during request processing
>=20
> Jiebin Sun <jiebin.sun@intel.com>
>     perf c2c: Fix documented default coalesce fields
>=20
> Muzaffer Kadir <muzafferkadir@mainlining.org>
>     dt-bindings: vendor-prefixes: Add General Mobile
>=20
> Abel Vesa <abel.vesa@oss.qualcomm.com>
>     arm64: dts: qcom: x1e80100-qcp: Mark the EC reset gpio as reserved
>=20
> Abel Vesa <abel.vesa@oss.qualcomm.com>
>     arm64: dts: qcom: x1e80100-yoga-slim7x: Mark the EC reset gpio as res=
erved
>=20
> Shrikanth Hegde <sshegde@linux.ibm.com>
>     powerpc/ftrace: Don't restore r13 during ftrace_regs_caller
>=20
> Rob Herring (Arm) <robh@kernel.org>
>     dt-bindings: arm: mediatek: Fix MT6779 audsys compatible
>=20
> Pengpeng Hou <hppiscas@163.com>
>     iio: accel: bma220: publish the SPI driver ACPI alias
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8188: mt8188-afe-pcm: Handle runtime resume errors
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8188: mt8188-afe-clk: Handle clock enable errors
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8188: mt8188-afe-clk: Propagate regmap update errors
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8188: mt8188-afe-clk: Handle tuner clock enable err=
ors
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt5665: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt5660: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt5659: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt5616: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt1318: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt1308: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt1305: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt1016: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: rt1011: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: nau8540: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: es8316: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: ak4642: return cache sync errors from resume
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     ASoC: adau17x1: return cache sync errors from resume
>=20
> Slavin Liu <bolin.liu@seu.edu.cn>
>     ASoC: fsl_asrc: check the second front-end DMA channel
>=20
> Pu Lehui <pulehui@huawei.com>
>     bpf: Adjust bpf_func to account for CFI offset in bpf_jit_free on ris=
cv
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     NFS: use TCP for MOUNT when xprtsec=3D selects TLS
>=20
> Thomas Falcon <thomas.falcon@intel.com>
>     perf mem: Fix size tracking for mem_lvl's in perf_script__meminfo_scn=
printf()
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_asrc: use regmap_write_bits to update clock source registers
>=20
> Dmitrii Tulnov <tulnov.dl@gmail.com>
>     kconfig: warn about malformed KCONFIG_PROBABILITY values
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     mfd: da9150: Balance IRQ wake on teardown
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock
>=20
> Eric Anderson <ejona86@gmail.com>
>     mfd: rk8xx: Register poweroff handler in atomic phase
>=20
> Jiale Yao <yaojiale02@163.com>
>     ext2: drain in-flight DIO before buffered write fallback
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     iommufd: Fix iommufd_hw_capabilities reference in kernel-doc
>=20
> Hui Su <sh_def@163.com>
>     bpftool: Fix CPU IDs in per-CPU map output
>=20
> Danish Khateeb <danishkhateeb03@gmail.com>
>     tools/nolibc: fix WIFSIGNALED() for status 0
>=20
> Esteban Urrutia <esteuwu@proton.me>
>     clk: qcom: alpha-pll: Check Lucid Ole PLL status before configuring
>=20
> Esteban Urrutia <esteuwu@proton.me>
>     clk: qcom: dispcc-sm8450: Fix disp_cc_mdss_mdp_clk_src ops
>=20
> Vincent Jardin <vjardin@free.fr>
>     dt-bindings: vendor-prefixes: add Free Mobile
>=20
> Linus Walleij <linusw@kernel.org>
>     ARM: dts: ux500: Convert HREF audio to audio-graph-card2
>=20
> Zongmin Zhou <zhouzongmin@kylinos.cn>
>     serial: sifive: fix off-by-one in console port bounds check
>=20
> Malathi A <malathi.a2000@gmail.com>
>     serial: 8250_uniphier: Use devm_clk_get_enabled()
>=20
> Uwe Kleine-K=C3=B6nig (The Capable Hub) <u.kleine-koenig@baylibre.com>
>     serial: txx9: Drop noop probe function and dangerous remove callback
>=20
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     serial: Switch back to struct platform_driver::remove()
>=20
> Dmitry Sinyavin <sinyavin@gmail.com>
>     serial: msm: select PM_OPP
>=20
> Ginger Li <ginger.jzllee@gmail.com>
>     media: i2c: ov5648: Fix a data race on state->streaming
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Don't search beyond the first data mark
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Revisit delays
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Check drive ready bit
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Deduplicate polling loops
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Remove redundant RELAX actions
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Convert to blocking queue
>=20
> Christoph Hellwig <hch@lst.de>
>     block: remove BLK_MQ_F_SHOULD_MERGE
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Fix buffer overflow
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Don't use the mark register to read data
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Check error register during sector read
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Simplify return value initialization
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Check for CRC errors
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Handle FIFO timeout error
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Add track zero recalibration delay
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Recalibrate when drive is probed
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Don't start motor until medium is present
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Enable clock divider only where appropriate
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Refactor SWIM setup
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Configure parameter memory
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Perform ISM/IWM mode switching according to specs
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Don't disable drive after every sector
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Enable the drive when probing
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Select appropriate drive once only
>=20
> Finn Thain <fthain@linux-m68k.org>
>     swim: Assert strobe with stable outputs
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/mlx5: Guard steering anchor resource destruction on create error
>=20
> Jiale Yao <yaojiale02@163.com>
>     crypto: ccp - kill v5 IRQ tasklet during teardown
>=20
> Jiale Yao <yaojiale02@163.com>
>     crypto: ccp - kill v3 IRQ tasklet during teardown
>=20
> Weili Qian <qianweili@huawei.com>
>     crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in=
 ECDH
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     crypto: starfive - propagate clock and reset errors
>=20
> Jiawen Liu <1298662399@qq.com>
>     crypto: starfive - handle clock enable failures
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     hwrng: starfive - propagate clock and reset errors
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     RDMA/cxgb4: Fix skb reference leak in rx_pkt()
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
>=20
> Kim Wooseok <5mghybrid@khu.ac.kr>
>     wifi: rtl8xxxu: free RX skb when URB submission fails
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ASoC: amd: acp3x-es83xx: Switch to use acpi_bus_get_primary_device()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ASoC: amd: acp-es8336: Switch to use acpi_bus_get_primary_device()
>=20
> Pei Xiao <xiaopei01@kylinos.cn>
>     ata: pata_parport: fix parport attach idr_alloc for
>=20
> Jeremy Bongio <jbongio@google.com>
>     RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
>=20
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     arm64: dts: ti: k3-am62-verdin: fix main_gpio0/main_gpio1 line names =
size
>=20
> Jisheng Zhang <jszhang@kernel.org>
>     regulator: mp886x: fix pontential division by zero
>=20
> Jisheng Zhang <jszhang@kernel.org>
>     regulator: mp886x: check get_voltage_sel() return value
>=20
> Dmitry Antipov <dmantipov@yandex.ru>
>     leds: flash: Prevent using uninitialized variable in flash_fault_show=
()
>=20
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf annotate-data: Show the sample count in the data-type browser
>=20
> Cong Nguyen <congnt264@gmail.com>
>     leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on las=
t write failure
>=20
> Ian Rogers <irogers@google.com>
>     perf build: Check the version of the compiler that is used
>=20
> Chen Pei <cp0613@linux.alibaba.com>
>     perf test: Fix a leaked map reference in the arch dwarf unwind tests
>=20
> Haibo Chen <haibo.chen@nxp.com>
>     leds: pca9532: Check i2c_smbus_read_byte_data() return value
>=20
> Miles Krause <mileskrause5200@gmail.com>
>     leds: lp8860: Fix device_node leak in lp8860_probe()
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     md/raid5: give the io_unit slab caches per-array names
>=20
> Arnd Bergmann <arnd@arndb.de>
>     KMSAN: fix memset() when using fortify-source, again
>=20
> Andrea Parri <parri.andrea@gmail.com>
>     pstore: reject persistent RAM zones too small for the buffer header
>=20
> Andrea Parri <parri.andrea@gmail.com>
>     pstore: don't leave an ERR_PTR in the ramoops zone pointer
>=20
> Leon Hwang <leon.hwang@linux.dev>
>     bpftool: Compute map size of light skeletons at runtime
>=20
> Leon Hwang <leon.hwang@linux.dev>
>     bpftool: Generate skeleton for global percpu data
>=20
> WanLi Niu <niuwl1@chinatelecom.cn>
>     bpftool: Make skeleton C++ compatible with explicit casts
>=20
> Jiayuan Chen <mrpre@163.com>
>     bpftool: Using the right format specifiers
>=20
> Neil Armstrong <neil.armstrong@linaro.org>
>     dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
>=20
> Pengpeng Hou <hppiscas@163.com>
>     pmdomain: imx: Propagate SCU provider registration failures
>=20
> Xiang Mei <xmei5@asu.edu>
>     fs/ntfs3: validate $SDH entry size in ntfs_insert_security
>=20
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea
>=20
> Zhan Xusheng <zhanxusheng1024@gmail.com>
>     fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()
>=20
> Xiang Mei (Microsoft) <xmei5@asu.edu>
>     fs/ntfs3: check INDEX_ROOT resident size before use in ntfs_read_mft()
>=20
> Andrew Gaylard <ag@ffroot.co.za>
>     pinctrl: fix PINCTRL_SPPCTL=3Dm
>=20
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf, lsm: Reject writes into the BPF LSM program context
>=20
> Slavin Liu <bolin.liu@seu.edu.cn>
>     clk: starfive: jh7110: reject oscillator lookup errors
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     clk: versatile: clk-icst: Fix node reference leak in of_syscon_icst_s=
etup()
>=20
> Triet Hoang <triet.hoang.dev@gmail.com>
>     clk: raspberrypi: Handle cpufreq device registration failure
>=20
> Karl Asseily <karl@asseily.com>
>     dt-bindings: vendor-prefixes: add ESS Technology
>=20
> Alejandro Lucero <alucerop@amd.com>
>     ACPI: HMAT: preserve hmat_adist_nb notifier block
>=20
> Felix Gu <ustc.gu@gmail.com>
>     spi: mxic: fix ps_clk leak in runtime resume
>=20
> Christian Loehle <christian.loehle@arm.com>
>     ACPI: CPPC: Validate the _CPC package header
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_C=
ONTEXT
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/restrack: Don't set RESTRACK_DD mark after a failed xa_insert()
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device=
()
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     interconnect: qcom: use 64-bit SMD RPM bus votes
>=20
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     interconnect: qcom: icc-rpm: Handle icc_link_create() failures
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     interconnect: exynos: Remove the PM QoS request on unbind
>=20
> Slavin Liu <bolin.liu@seu.edu.cn>
>     crypto: atmel-sha - reject initialization without a device
>=20
> Ahsan Atta <ahsan.atta@intel.com>
>     crypto: qat - fix active_devs leak on crypto alg registration failure
>=20
> Guixin Liu <kanie@linux.alibaba.com>
>     cxl/port: Fix uninitialized coordinates reported for RCDs
>=20
> Guixin Liu <kanie@linux.alibaba.com>
>     cxl/pci: Skip reset detection for DVSEC emulated decoders
>=20
> Julian Braha <julianbraha@gmail.com>
>     kconfig: fix extra output from savedefconfig on out-of-range defaults
>=20
> Felix Gu <ustc.gu@gmail.com>
>     PCI: dra7xx: Fix clock enable leak on probe failure
>=20
> vladimir.oltean@nxp.com <vladimir.oltean@nxp.com>
>     PCI: dra7xx: Remove device links to PHY
>=20
> Longlong Xia <xialonglong@kylinos.cn>
>     rcu: fix shrink budget underflow in lazy_rcu_shrink_scan
>=20
> Joel Fernandes <joelagnelf@nvidia.com>
>     rcu/nocb: Remove unnecessary WakeOvfIsDeferred wake path
>=20
> Frederic Weisbecker <frederic@kernel.org>
>     Revert "rcu/nocb: Fix rcuog wake-up from offline softirq"
>=20
> Mingpei CAO <caomingpei@gmail.com>
>     libbpf: Reject local struct_ops bitfields before data access
>=20
> Nikolay Borisov <nik.borisov@suse.com>
>     ata: sata_dwc_460ex: Don't enable interrupt if libATA core registrati=
on fails
>=20
> Hari Mishal <harimishal1@gmail.com>
>     drm/amdgpu/atom: bound the VBIOS date, part number, version and build=
 getters
>=20
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amdgpu: bounds check ATOM IIO table parsing
>=20
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amdgpu: Print full vbios info
>=20
> Mario Limonciello (AMD) <superm1@kernel.org>
>     drm/amd: Add correct prefix for VBIOS message
>=20
> Lijo Lazar <lijo.lazar@amd.com>
>     drm/amdgpu: Add vbios build number interface
>=20
> Hari Mishal <harimishal1@gmail.com>
>     drm/amd/pm: bound SCLK FCW range entries to the table size
>=20
> Pengpeng Hou <hppiscas@163.com>
>     clk: milbeaut: Return divider update timeouts
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     clk: si521xx: correct the SI52147 OF output enable map
>=20
> Zizhi Wo <wozizhi@huawei.com>
>     md/raid5: reject a per-device size smaller than one chunk
>=20
> Zhihao Cheng <chengzhihao1@huawei.com>
>     md/raid5: setup_conf: Fix null-ptr-def in error handling path
>=20
> Chen Cheng <chencheng@fnnas.com>
>     md/raid5: reject raid4/5 arrays with too few disks
>=20
> Yogesh Gaur <yogeshgaur.83@gmail.com>
>     md/raid5: don't BUG() on an inconsistent reshape state from the super=
block
>=20
> J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     md: reject v0.90 arrays with too many devices
>=20
> Zizhi Wo <wozizhi@huawei.com>
>     md/raid10: fix missing wakeup in wait_barrier_nolock
>=20
> Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
>     staging: iio: adc: ad7816: Fix DMA safety issues in SPI transfers
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp
>=20
> =C8=98tefan Ghe=C8=9Bu <stefanghetu9@gmail.com>
>     ASoC: SOF: imx: Prevent stack OOB read in DSP panic dump
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the S=
TM32MP257 default
>=20
> Stephane Danieau <stephane.danieau@foss.st.com>
>     pinctrl: stm32: Allow compile as module for stm32mp257
>=20
> Antonio Borneo <antonio.borneo@foss.st.com>
>     pinctrl: stm32: Declare stm32_pmx_get_mode() as static
>=20
> Alison Schofield <alison.schofield@intel.com>
>     cxl/hdm: Make switch decoder target parsing endian-safe
>=20
> Dave Jiang <dave.jiang@intel.com>
>     cxl: Add a cached copy of target_map to cxl_decoder
>=20
> Alison Schofield <alison.schofield@intel.com>
>     cxl/hdm: Reject switch decoder interleave ways that overflow targets
>=20
> Slavin Liu <bolin.liu@seu.edu.cn>
>     ACPI: tables: handle failed initrd override mappings
>=20
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock
>=20
> Sarthak Sharma <sarthak.sharma@arm.com>
>     mm/gup_test: report actual pinned bytes
>=20
> Sarthak Sharma <sarthak.sharma@arm.com>
>     mm/gup_test: safely calculate GUP batch size
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     mm/gup_test: reject wrapped user ranges
>=20
> Weiming Shi <bestswngs@gmail.com>
>     ntfs3: fix out-of-bounds read in ntfs_read_mft()
>=20
> Luka Gejak <luka.gejak@linux.dev>
>     wifi: rtw88: sdio: zero the padding added to a TX transfer
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
>=20
> Rosen Penev <rosenp@gmail.com>
>     dmaengine: mv_xor: kill tasklet on channel add error path
>=20
> Yonghao Zhang <hyz3367@gmail.com>
>     remoteproc: core: Set trace buffer name for diagnostics
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     block: Fix the thaw_bdev reference in bdev_freeze() kernel-doc
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     media: i2c: ar0521: remove duplicate media entity cleanup
>=20
> Li RongQing <lirongqing@baidu.com>
>     RDMA/uverbs: Make CQ handle mandatory for WQ creation
>=20
> Nicolas Morey <nmorey@suse.com>
>     RDMA/rxe: Use validated num_sge in local buffer
>=20
> Miles Krause <mileskrause5200@gmail.com>
>     memory: emif: fix device_node reference leak on np_ddr
>=20
> Gregory CLEMENT <gregory.clement@bootlin.com>
>     phy: cadence: Sierra: Do not modify register when getting parent clock
>=20
> Haotian Zhang <vulab@iscas.ac.cn>
>     phy: hisilicon: hi3670: Fix OF node and device reference leaks
>=20
> Linkai Gong <gonglinkai@kylinos.cn>
>     firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
>=20
> Jianan Huang <jnhuang95@gmail.com>
>     f2fs: quota: fix stale lock holder on remount failure
>=20
> J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>     wifi: wfx: fix use-after-free of the cooling work on device removal
>=20
> Takahiro Kuwano <takahiro.kuwano@infineon.com>
>     mtd: spi-nor: spansion: Remove s25fs256s0
>=20
> Julius Bairaktaris <julius@bairaktaris.de>
>     wifi: mac80211: don't reset the TXQ scheduling round number
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc
>=20
> Fuad Tabba <fuad.tabba@linux.dev>
>     arm64: pi: Run the source checker on the libfdt objects under C=3D2
>=20
> Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
>     microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
>=20
> Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
>     microblaze: uaccess: Zero out destination on failed get_user()
>=20
> Linkai Gong <gonglinkai@kylinos.cn>
>     pinctrl: amd: add timeout to irq-enable readback
>=20
> Mario Limonciello (AMD) <superm1@kernel.org>
>     pinctrl: amd: Don't access irq_data's hwirq member directly
>=20
> Mario Limonciello (AMD) <superm1@kernel.org>
>     pinctrl: amd: Add PM debugging message for turning on/off wakes
>=20
> Weiming Shi <bestswngs@gmail.com>
>     fs/ntfs3: zero frame pages on read error
>=20
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     ntfs: Do not kmap page cache pages for compression
>=20
> Baolin Liu <liubaolin@kylinos.cn>
>     fs/ntfs3: update ctime only on successful setxattr
>=20
> Weiming Shi <bestswngs@gmail.com>
>     fs/ntfs3: take run_lock when freeing offs_folio in ni_decompress_file
>=20
> Mahe Tardy <mahe.tardy@gmail.com>
>     libbpf: fix log level propagation for light skeleton loaders
>=20
> Tony Ambardar <tony.ambardar@gmail.com>
>     libbpf: Support opening bpf objects of either endianness
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_=
optimum_mode() kernel-doc
>=20
> Ian Rogers <irogers@google.com>
>     perf header: Fix potential memory corruption in cpu_cache_level__read
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: video: Fix backlight unregistration ordering
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: fan: Fix memory leak due to leftover devm_kcalloc() argument
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     ALSA: control: Fix virtual master creation reference in kernel-doc
>=20
> Michael S. Tsirkin <mst@redhat.com>
>     virtio_pci_modern: move avq cleanup from reset to del_vqs
>=20
> Michael S. Tsirkin <mst@redhat.com>
>     virtio: synchronize callbacks after device reset
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     gfs2: Fix the return value in gfs2_get_link() kernel-doc
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     spi: Fix the return value in spi_new_ancillary_device() kernel-doc
>=20
> Pengpeng Hou <hppiscas@163.com>
>     clk: s2mps11: Propagate OF provider registration failures
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     clk: rs9: Add clock index range check to rs9_of_clk_get()
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     clk: mediatek: reset: Fix device registration kernel-doc
>=20
> Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
>     x86/svm: Avoid sign extension of SVM_EVTINJ_VALID in 64-bit expressio=
ns
>=20
> Nora Schiffer <nora.schiffer@ew.tq-group.com>
>     ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints
>=20
> Sanghyun Park <sanghyun.park.cnu@gmail.com>
>     bpf: Fix program BTF use-after-free in sleepable programs
>=20
> Justin Yeh <justin.yeh@mediatek.com>
>     HID: i2c-hid: Unfollow the panel on shutdown
>=20
> Marek Vasut <marex@nabladev.com>
>     ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_=
b4_pins_a
>=20
> Brian Norris <briannorris@chromium.org>
>     PM: runtime: Only queue an idle check for RPM-linked suppliers
>=20
> Xueqin Luo <luoxueqin@kylinos.cn>
>     cpuidle: teo: Do not return a disabled idle state
>=20
> Alain Volmat <alain.volmat@foss.st.com>
>     ARM: dts: stm32: add LTDC / DCMIPP access controller for STM32MP135
>=20
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>     ARM: dts: stm32: lxa-tac: change stdout-path baud rate from 9600 to 1=
15200
>=20
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>     ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 1=
15200
>=20
> Xueqin Luo <luoxueqin@kylinos.cn>
>     cpuidle: menu: Do not return a disabled idle state
>=20
> Christian Loehle <christian.loehle@arm.com>
>     cpuidle: menu: Remove single state handling
>=20
> Breno Leitao <leitao@debian.org>
>     cpuidle: menu: Remove incorrect unlikely() annotation
>=20
> Takashi Sakamoto <o-takashi@sakamocchi.jp>
>     firewire: core: remove unused link field in fw_packet structure
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kern=
el-doc
>=20
> Sumeet Pawnikar <sumeet4linux@gmail.com>
>     thermal: gov_power_allocator: Fix NULL pointer dereference in update_=
tz()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: glue: Fix up and adjust acpi_unbind_one()
>=20
> Jan Kara <jack@suse.cz>
>     gfs2: Fix journaled truncate range end offset
>=20
> Jiawen Liu <1298662399@qq.com>
>     memory: exynos5422-dmc: handle clock enable failures
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     crypto: lskcipher - preserve state across unaligned chunks
>=20
> Linmao Li <lilinmao@kylinos.cn>
>     crypto: mxs-dcp - handle zero-length skcipher requests
>=20
> Ahsan Atta <ahsan.atta@intel.com>
>     crypto: qat - release instance on DH fallback allocation failure
>=20
> Ahsan Atta <ahsan.atta@intel.com>
>     crypto: qat - avoid OOB read when stripping RSA leading zeros
>=20
> Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
>     crypto: amlogic - Fix DMA memory leak in cipher error path
>=20
> Eric Dumazet <edumazet@google.com>
>     ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup
>=20
> Eric Dumazet <edumazet@google.com>
>     sit: fix UAF in ipip6_tunnel_del_prl()
>=20
> Luca Weiss <luca.weiss@fairphone.com>
>     arm64: dts: qcom: sm7225-fairphone-fp4: Disable PMK8350 PON
>=20
> Linus Walleij <linusw@kernel.org>
>     regulator: ab8500: Propagate mode enable read errors
>=20
> Linus Walleij <linusw@kernel.org>
>     regulator: ab8500: Test dedicated enable bits only
>=20
> Linus Walleij <linusw@kernel.org>
>     regulator: ab8500: Treat cut 1.0 VAUX3 as fixed
>=20
> Linus Walleij <linusw@kernel.org>
>     regulator: ab8500: Handle AB8505 VINTCORE selector 7
>=20
> Linus Walleij <linusw@kernel.org>
>     regulator: ab8500: Add AB8505 VAUX3 3.05 V setting
>=20
> Babanpreet Singh <bbnpreetsingh@gmail.com>
>     regulator: ab8500: Remove stale expand_register kernel-doc entry
>=20
> Linus Walleij <linusw@kernel.org>
>     regulator: ab8500: Fix AB8505 VANA voltage selectors
>=20
> Koichiro Den <den@valinux.co.jp>
>     PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan
>=20
> Jia Wang <wangjia@ultrarisc.com>
>     dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position
>=20
> Jia Wang <wangjia@ultrarisc.com>
>     dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access
>=20
> Jia Wang <wangjia@ultrarisc.com>
>     dmaengine: dw-axi-dmac: Fix AXI burst length encoding
>=20
> Rosen Penev <rosenp@gmail.com>
>     dmaengine: fsl_raid: zero CF descriptor pool allocations
>=20
> Keisuke Tsukuda <catnyaaan@outlook.com>
>     usb: gadget: f_mass_storage: ignore class requests while inactive
>=20
> Keisuke Tsukuda <catnyaaan@outlook.com>
>     usb: gadget: composite: avoid warning on aborted delayed status
>=20
> Roland Dreier <rolanddreier@rivian.com>
>     firmware: arm_scmi: Don't reuse raw xfers with async_done still armed
>=20
> Roland Dreier <rolanddreier@rivian.com>
>     firmware: arm_scmi: Protect xfer->async_done with xfer->lock
>=20
> Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
>     dmaengine: sprd: use clk_bulk API to fix clock imbalance
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     usb: musb: da8xx: depopulate OF children on probe failure
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     usb: musb: da8xx: depopulate OF children on remove
>=20
> Arka Mondal <arka@arkamondal.net>
>     usb-storage: alauda: fix out-of-bounds zone index
>=20
> Arka Mondal <arka@arkamondal.net>
>     usb-storage: alauda: check the return value of alauda_read_map()
>=20
> Arka Mondal <arka@arkamondal.net>
>     usb-storage: alauda: do not do DMA from the stack
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     USB: pci-quirks: Release EHCI device reference
>=20
> Jiangong.Han <jiangong.han@windriver.com>
>     USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init=
() fails
>=20
> Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
>     usb: image: microtek: stop SG processing after transfer errors
>=20
> Junxian Huang <huangjunxian6@hisilicon.com>
>     RDMA/hns: Fix GID capacity loss in 64K system
>=20
> Junxian Huang <huangjunxian6@hisilicon.com>
>     RDMA/hns: Limit gmv_entry_num to avoid memory waste
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     PCI: xgene: Use managed clock for PCIe controller
>=20
> Shakeel Butt <shakeel.butt@linux.dev>
>     kernfs: fix up the unlocked attribute reads on the creation paths
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     efi/libstub: Fix efi_set_event_at() parameter documentation
>=20
> Salah Triki <salah.triki@gmail.com>
>     iio: imu: adis16400: Check return value of spi_setup()
>=20
> Matti Vaittinen <mazziesaccount@gmail.com>
>     iio: accel: kionix-kx022a: Fix IPOL macro name
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix NULL pointer dereference on PCI error recovery
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: zero out diagnostic buffer status memory
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix buffer overflow in the BSG target device map
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds phy array access on link change
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds read of event data
>=20
> Ranjan Kumar <ranjan.kumar@broadcom.com>
>     scsi: mpi3mr: Rename log data save helper to reflect threaded/BH cont=
ext
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix device loss during enclosure reboot due to zero lin=
k speed
>=20
> Ranjan Kumar <ranjan.kumar@broadcom.com>
>     scsi: mpi3mr: Event processing debug improvement
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix target device reference leak in device removal hand=
shake
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds sense buffer access
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds reply frame access
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix buffer overflow when caching log data
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix target device reference leak in BSG task management
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix I/O block counter leak on admin request post failure
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
>=20
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>     scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy
>=20
> Linmao Li <lilinmao@kylinos.cn>
>     power: supply: bq2515x: Propagate charge-enable read errors
>=20
> Ryan Brue <ryanbrue.dev@gmail.com>
>     power: supply: bq24190_charger: use the wake irq API
>=20
> Peng Fan <peng.fan@nxp.com>
>     PM: sleep: wakeirq: Introduce device-managed variant of dev_pm_set_wa=
ke_irq()
>=20
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     PM: wakeup: implement devm_device_init_wakeup() helper
>=20
> hpp.iscas <hppiscas@163.com>
>     power: supply: mm8013: Publish the OF module alias
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     power: supply: mp2629: Use the full batt_impedance_compensation name =
in the ABI document
>=20
> Willem de Bruijn <willemb@google.com>
>     selftests: net: csum: filter packets by source address and port
>=20
> Sean Anderson <sean.anderson@linux.dev>
>     selftests: net: csum: Clean up recv_verify_packet_ipv6
>=20
> Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
>     wifi: ath12k: Free allocated external IRQs on request_irq() failure
>=20
> Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
>     wifi: ath12k: Free allocated CE IRQs on request_irq() failure
>=20
> Nicolas Escande <nico.escande@gmail.com>
>     wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()
>=20
> Mikhail Lobanov <m.lobanov@rosalinux.ru>
>     wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: utils: Adjust message printing macros for ACPI objects
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: scan: Stop calling acpi_bus_init_power() early
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: PCI: Introduce acpi_dev_get_pci_dev()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: PM: Drop parent state update from acpi_device_get_power()
>=20
> Ian Gallagher <cdine@cdine.org>
>     ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Ea=
rly 2020) RZ09-0310
>=20
> Vinod Koul <vkoul@kernel.org>
>     dmaengine: zynqmp_dma: drop redundant label
>=20
> Srinivas Neeli <srinivas.neeli@amd.com>
>     dmaengine: xilinx_dma: Move descriptors to done list based on complet=
ion bit
>=20
> Srinivas Neeli <srinivas.neeli@amd.com>
>     dmaengine: xilinx_dma: Fix MCDMA descriptor fields based on DMA direc=
tion
>=20
> Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
>     dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API
>=20
> Golla Nagendra <nagendra.golla@amd.com>
>     dmaengine: zynqmp_dma: Fix chan probe/remove error handling
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     dmaengine: img-mdc: Fix runtime PM usage counter leak
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     dmaengine: mediatek: hsdma: fix runtime PM leak on init failure
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     dmaengine: at_hdmac: Fix use-after-free by proper tasklet cleanup
>=20
> Hongling Zeng <zenghongling@kylinos.cn>
>     dmaengine: sun6i-dma: Fix use-after-free in error handling paths
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
>=20
> Aaron Tomlin <atomlin@atomlin.com>
>     perf trace: Add upper bound checks for augmented BTF struct printing
>=20
> Aaron Tomlin <atomlin@atomlin.com>
>     perf trace: Enhance BTF type formatting to symbolise kernel function =
pointers
>=20
> Mark Brown <broonie@kernel.org>
>     perf bpf: Fix up build failure due to change of btf_vlen() return type
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf btf: Make the sigtrap test helper to find a member by name widel=
y available
>=20
> Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>     EDAC/i10nm: Fix Granite Rapids ADXL MC mapping
>=20
> Tianyi Chen <hi@tychen.cc>
>     selftests/sched_ext: Handle CPU hotplug write failures
>=20
> Manush Prajwal <manushprajwal555@gmail.com>
>     pwm: lp3943: fix NULL pointer dereference for an unconfigured channel
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt6797: fix wrong unwind order and error code in enab=
le_clock
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8186: Fix MCK error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8186: Fix APLL enable error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8186: Fix AFE clock error handling
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8186: Fix clock handling in mux disable path
>=20
> bui duc phuc <phucduc.bui@gmail.com>
>     ASoC: mediatek: mt8186: Fix APLL mux setting error handling
>=20
> Bert Karwatzki <spasswolf@web.de>
>     mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()
>=20
> Chen-Yu Tsai <wenst@chromium.org>
>     pwm: mtk-disp: Fix period readback
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     virtio_ccw: always take irq_lock in the classic interrupt handler
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     virtio_ccw: fix synchronize_cbs() after interrupt fallback
>=20
> Pengpeng Hou <hppiscas@163.com>
>     ASoC: es8326: report resume restore errors
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     irqchip/gic-v3-its: Don't WARN on LPI free allocation failure
>=20
> Linkai Gong <gonglinkai@kylinos.cn>
>     drivers/base/node: fix UAF on device_register() failure
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     gpio: crystalcove: add missing MODULE_ALIAS()
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/irdma: Preserve fast-registration IOVA on 32-bit
>=20
> Mark Amirkan <markdamirkan@gmail.com>
>     perf evsel: Validate RAW sample before byte swapping
>=20
> Mark Amirkan <markdamirkan@gmail.com>
>     perf evsel: Validate branch stack before byte swapping
>=20
> Aaron Tomlin <atomlin@atomlin.com>
>     perf trace: Fix error checking in btf_struct_scnprintf()
>=20
> Marcel Hofmann <marcel.hofmann@ingenics-digital.com>
>     remoteproc: imx_rproc: Allow mappings ending at region boundary
>=20
> Felix Gu <ustc.gu@gmail.com>
>     spi: mtk-nor: fix runtime PM usage count leak in probe error path
>=20
> Dave Jiang <dave.jiang@intel.com>
>     efi/cper: Read only validated fields in cper_mem_err_pack()
>=20
> Dave Jiang <dave.jiang@intel.com>
>     ACPI: APEI: GHES: Bound CXL event record copy to the firmware section=
 length
>=20
> Dave Jiang <dave.jiang@intel.com>
>     ACPI: extlog: Validate elog record length before walking sections
>=20
> Dave Jiang <dave.jiang@intel.com>
>     efi/cper: Reject an error status block length that wraps a u32
>=20
> Dave Jiang <dave.jiang@intel.com>
>     efi/cper: Reject CPER records with an out-of-range error_data_length
>=20
> Jisheng Zhang <jszhang@kernel.org>
>     regulator: mp886x: fix vsel_mask
>=20
> Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@bootlin.com>
>     selftests/bpf: make cmdline_contains stricter
>=20
> Eduard Zingerman <eddyz87@gmail.com>
>     selftests/bpf: More precise cpu_mitigations state detection
>=20
> Jared McArthur <j-mcarthur@ti.com>
>     arm64: dts: ti: k3-j722s-evm: Switch audio codec clock from audio_ref=
clk1 to external clock
>=20
> Chintan Vankar <c-vankar@ti.com>
>     arm64: dts: ti: k3-j722s-evm: Add bootph-all property to enable Ether=
net boot
>=20
> Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
>     arm64: dts: ti: j722s-evm: Add MUX to control CSI2RX
>=20
> Udit Kumar <u-kumar1@ti.com>
>     arm64: dts: ti: k3-j722s-evm: Enable PMIC
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     memory: brcmstb_dpfe: validate firmware section sizes
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     irqchip/riscv-imsic: Use GENMASK for base address masks
>=20
> Julius Bairaktaris <julius@bairaktaris.de>
>     wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
>=20
> Fabrice Derepas <fabrice.derepas@canonical.com>
>     crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     hwrng: cctrng - Fix runtime PM usage counter leak
>=20
> J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>     wifi: wfx: fix possible device hang during init
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup
>=20
> Bert Karwatzki <spasswolf@web.de>
>     wifi: check if socket flags are valid
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: free SKBTX_WIFI_STATUS skb tx_flags flag
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: drop encap offload frames with a tainted key
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: don't send encap offload frames unencrypted
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix key selection for encap offload frames
>=20
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix unauthorised port check for encap offload
>=20
> Paul Dolan <paul.dolan.dev@gmail.com>
>     selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test
>=20
> Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
>     wifi: ath11k: fix sporadic WLAN initialization failures
>=20
> Julius Bairaktaris <julius@bairaktaris.de>
>     wifi: ath11k: disable interrupts during firmware crash recovery
>=20
> Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
>     clk: Use the generic OF phandle parsing in only one place
>=20
> Chengchang Tang <tangchengchang@huawei.com>
>     RDMA/hns: Fix missing CQE when UD QP use different SL
>=20
> Rosen Penev <rosenp@gmail.com>
>     dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
>=20
> Rosen Penev <rosenp@gmail.com>
>     dmaengine: fsl_raid: don't invoke client callback under desc_lock
>=20
> Koichiro Den <den@valinux.co.jp>
>     PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming
>=20
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>     bpftool: Set BPF_F_XDP_DEV_BOUND_ONLY flag non-destructively
>=20
> Ionut Nechita <ionut.nechita@windriver.com>
>     x86/crash: Reserve elfcorehdr for CONFIG_NR_CPUS, not CONFIG_NR_CPUS_=
DEFAULT
>=20
> Richard Zhu <hongxing.zhu@nxp.com>
>     arm64: dts: imx95: Avoid 32-bit PCIe window System RAM overlap
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     remoteproc: imx_dsp: Acquire runtime PM before adding carveouts
>=20
> Peng Fan <peng.fan@nxp.com>
>     remoteproc: imx_dsp_rproc: Drop extra space
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     remoteproc: imx_dsp_rproc: Add support of recovery and coredump proce=
ss
>=20
> Alexander Aring <aahringo@redhat.com>
>     dlm: fix variable key length lookup
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     dlm: fix buffer overflow from negative len in dlm_search_rsb_tree
>=20
> Danila Chernetsov <listdansp@mail.ru>
>     dlm: fix NULL pointer dereference in dlm_dump_rsb_name()
>=20
> Danila Chernetsov <listdansp@mail.ru>
>     dlm: validate lock modes in recovery messages
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     fuse: fall back to copy_splice_read() on FOPEN_DIRECT_IO
>=20
> Tao Cui <cuitao@kylinos.cn>
>     sched_ext/scx_flatcg: Make cgv_node_less() wraparound-safe
>=20
> Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
>     wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfi=
gured
>=20
> Chris Morgan <macromorgan@hotmail.com>
>     arm64: dts: rockchip: Correct Device Orientation on Gameforce Ace
>=20
> Boris Faure <boris@fau.re>
>     soundwire: intel: initialise quirk_mask before reading it
>=20
> J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>     microblaze: prevent ptrace writes to MSR and pt_mode
>=20
> Alexander A. Klimov <grandmaster@al2klimov.de>
>     microblaze: CCF: fix refcount leak
>=20
> Jerome Brunet <jbrunet@baylibre.com>
>     clk: fix self-consuming provider module pinning
>=20
> Orgad Shaneh <orgads@gmail.com>
>     staging: octeon: schedule the TX cleanup tasklet every 1024th packet
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     staging: rtl8723bs: disable SDIO function on block size failure
>=20
> Ethan Tidmore <ethantidmore06@gmail.com>
>     staging: rtl8723bs: remove unused private debug counters
>=20
> Michael Straube <straube.linux@gmail.com>
>     staging: rtl8723bs: move rtw_recv_indicatepkt to rtw_recv.c
>=20
> Michael Straube <straube.linux@gmail.com>
>     staging: rtl8723bs: remove wrapper rtw_init_recv_timer
>=20
> Michael Straube <straube.linux@gmail.com>
>     staging: rtl8723bs: remove return from void function
>=20
> Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
>     staging: rtl8723bs: change remaining printk to proper api
>=20
> Rob Barnes <robbarnes@google.com>
>     platform/chrome: cros_ec_proto: Fix deferred response
>=20
> Hongyan Xu <getshell@seu.edu.cn>
>     soc: qcom: apr: clean up failed service registrations
>=20
> Felix Gu <ustc.gu@gmail.com>
>     spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     pwm: renesas-tpu: Fix runtime PM reference leak
>=20
> David Heidelberg <david@ixit.cz>
>     ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos
>=20
> Cai Xinchen <caixinchen1@huawei.com>
>     lsm: don't call security_backing_file_free() multiple times
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     remoteproc: xlnx: Initialize mailbox work before requesting channels
>=20
> Shujath Mohd <shujath@outlook.in>
>     arm64: dts: qcom: sdm845-sony-xperia-tama: Fix Bluetooth UART pinctrl
>=20
> Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
>     remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_sta=
rt()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Validate unwinding sizes against record payload
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Validate sym string NUL-termination in code load
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Validate debug entries on native (non-swap) path
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Use dirname() return value in jit_open()
>=20
> Hrishikesh Suresh <hrishikesh123s@gmail.com>
>     perf: replace strcpy() with strncpy() in util/jitdump.c
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Free event in jit_repipe_code_move()
>=20
> Ian Rogers <irogers@google.com>
>     perf sample: Make user_regs and intr_regs optional
>=20
> Ian Rogers <irogers@google.com>
>     perf python: Constify variables and parameters
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Fix funlockfile on unlocked stream in jit_open() error =
path
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Check snprintf return before computing header size
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Bounds-check debug entry byte-swap loop
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Prevent integer underflow in debug info size calculation
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Validate code_size against total_size in code load
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Fix debug_data and unwinding_data leaks
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf jitdump: Fix extended header read that always fails
>=20
> Breno Leitao <leitao@debian.org>
>     kexec_file: stop the top-down search before it underflows
>=20
> Rosen Penev <rosenp@gmail.com>
>     ARM: dts: helios4: fix spi1 location
>=20
> Rosen Penev <rosenp@gmail.com>
>     ARM: dts: helios4: fix vbus-supply for USB2 PHY
>=20
> Rosen Penev <rosenp@gmail.com>
>     ARM: dts: armada-388-helios4: fix vmmc property name
>=20
> Rosen Penev <rosenp@gmail.com>
>     ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
>=20
> Rosen Penev <rosenp@gmail.com>
>     ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
>=20
> Rosen Penev <rosenp@gmail.com>
>     ARM: dts: helios4: fix lm75 supply name
>=20
> Pei Xiao <xiaopei01@kylinos.cn>
>     ata: pata_parport: Fix use-after-free in new_device_store
>=20
> Matti Vaittinen <mazziesaccount@gmail.com>
>     iio: pressure: rohm-bm1390: Fix AVE_NUM initialization
>=20
> Salah Triki <salah.triki@gmail.com>
>     iio: temperature: tmp117: fix calibbias cache update on I2C write fai=
lure
>=20
> Esben Haabendal <esben@geanix.com>
>     dt-bindings: iio: light: ltr501: Add missing ltr303 compatible
>=20
> Esben Haabendal <esben@geanix.com>
>     dt-bindings: iio: light: ltr501: Sort compatible enum array
>=20
> Adi Nata <adinata.softwareengineer@gmail.com>
>     iio: humidity: hts221: report available values via read_avail()
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     spi: sh-msiof: propagate setup runtime-PM errors
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     spi: sh-msiof: SITMDR1/SIRMDR1 bitfield conversion
>=20
> Chandradhar Kumar <chandradhar.2003@gmail.com>
>     regulator: fixed: reject incompatible platform devices
>=20
> Yuan Chen <chenyuan_fl@163.com>
>     bpftool: Fix spurious batch file read error
>=20
> Tapio Reijonen <tapio.reijonen@vaisala.com>
>     gpio: pcf857x: implement get_direction()
>=20
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>     gpio: pcf857x: use new GPIO line value setter callbacks
>=20
> Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
>     drm/panthor: Take reqs_lock in soft_reset for clearing pending_reqs
>=20
> Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@bootlin.com>
>     selftests/bpf: Allocate a larger timeout for connection
>=20
> Darren Carreras <carrerasdarren@gmail.com>
>     libbpf: Avoid overflow in BTF.ext bounds check
>=20
> Tony Ambardar <tony.ambardar@gmail.com>
>     libbpf: Support BTF.ext loading and output in either endianness
>=20
> Tony Ambardar <tony.ambardar@gmail.com>
>     libbpf: Improve log message formatting
>=20
> Marek Vasut <marek.vasut+renesas@mailbox.org>
>     drm: of: Fix drm_of_get_data_lanes_count_ep() return value documentat=
ion
>=20
> Andreas Kemnade <andreas@kemnade.info>
>     drm/omap: dsi: avoid sending bta sync all the time in writes
>=20
> Tejun Heo <tj@kernel.org>
>     bpf: sched_ext: Mark ops argument container pointer fields as trusted
>=20
> Song Liu <song@kernel.org>
>     bpf: Mark dentry->d_inode as trusted_or_null
>=20
> Adri=C3=A1n Larumbe <adrian.larumbe@collabora.com>
>     drm/panfrost: Prevent division by 0
>=20
> Hao-Qun Huang <alvinhuang0603@gmail.com>
>     accel/qaic: reject BO sizes that overflow page count
>=20
> Raveendra Talabattula <raveendra.talabattula@arm.com>
>     drm/komeda: Fix bits parsing of GLB_CORE_ID
>=20
> Su Hui <suhui@nfschina.com>
>     fs/stat.c: avoid harmless garbage value problem in vfs_statx_path()
>=20
> Borislav Petkov (AMD) <bp@alien8.de>
>     x86/microcode/AMD: Move the no-revision fixup to get_patch_level()
>=20
> Daejun Park <daejun7.park@samsung.com>
>     xfs: add a flag to convert unwritten extents without allocating blocks
>=20
> Heiner Kallweit <hkallweit1@gmail.com>
>     r8169: align RTL8125/RTL8126 PHY config with vendor driver
>=20
> Pei Xiao <xiaopei01@kylinos.cn>
>     comedi: dt2811: fix shift-out-of-bounds in IRQ check
>=20
> Yang Zi <2959243019@qq.com>
>     comedi: addi_apci_3xxx: fix subdevice count underallocation
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: flowtable: ensure sufficient headroom in xmit path
>=20
> Amir Goldstein <amir73il@gmail.com>
>     ovl: inherit FMODE_NONOTIFY when reading directory layers
>=20
> Mike Rapoport (Microsoft) <rppt@kernel.org>
>     mm/cma: accept memory of CMA areas reserved at a fixed address
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/shmem: fix accounting of swapin-error markers
>=20
> Roman Li <Roman.Li@amd.com>
>     drm/amd/display: Reset DET of HUBPs without a plane before outstandin=
g updates
>=20
> Ilya Bakoulin <Ilya.Bakoulin@amd.com>
>     drm/amd/display: Minimize wait for pending updates
>=20
> Yingjie Wang <1075151112@qq.com>
>     nvmet: reject keep-alive timeouts that would overflow
>=20
> Jouni H=C3=B6gander <jouni.hogander@intel.com>
>     drm/i915/display: Add enabled pipe planes into state for selective fe=
tch
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/shmem: make shmem_file() check the file's inode
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     hdlcdrv: close the hardware driver once, and only if it was opened
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: disconnect sockets under their lock when a neighbour goes away
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: clear the other half of a through route a new call takes over
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: give loopback answers LCIs that calls cannot be given
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: refuse an empty message when the Q bit is included
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: keep a socket unbound when connect() fails to autobind it
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: check the length of Restart Request and Diagnostic frames
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: change the loopback nodes under the neighbour list lock too
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: hold RTNL while a route is added or deleted
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: walk the neighbour list under its lock when a device goes down
>=20
> Jesse Zhang <Jesse.Zhang@amd.com>
>     drm/amdkfd: use the queue's process info for the WPTR BO eviction fen=
ce
>=20
> Lang Yu <lang.yu@amd.com>
>     drm/amdkfd: Map wptr BO to GART unconditionally
>=20
> Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
>     ASoC: qcom: q6apm: clear g_apm on driver removal
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     fork: take mmap_lock before copying mm_struct
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/rmap: handle device-exclusive entries in folio_referenced_one()
>=20
> Josef Bacik <josef@toxicpanda.com>
>     mm/filemap: read mapping->a_ops->free_folio under i_lock
>=20
> Cong Zhang <cong.zhang@oss.qualcomm.com>
>     virtio_blk: use synchronous quiesce in virtblk_freeze_priv()
>=20
> Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
>     apparmor: fix query_data() output overlapping the lookup key
>=20
> Gregory Price <gourry@gourry.net>
>     mm/userfaultfd: compare exact registration modes before skipping
>=20
> Ian Bridges <icb@fastmail.org>
>     ksmbd: let the owner read and change the DACL when no ACE names it
>=20
> YouYou Yu <youyouyu@amazon.com>
>     quota: initialize dquot cache before mounting rootfs
>=20
> Shubham Antil <shubham@octane.security>
>     vhost-scsi: zero misaligned I/O bounce pages
>=20
> Mike Christie <michael.christie@oracle.com>
>     vhost-scsi: Reduce mem use by moving upages to per queue
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
>=20
> Josef Bacik <josef@toxicpanda.com>
>     mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
>=20
> Jouni H=C3=B6gander <jouni.hogander@intel.com>
>     drm/i915/psr: Clear selective fetch area when duplicating plane state
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/vma: don't leak the charge for stack growth
>=20
> Daejun Park <daejun7.park@samsung.com>
>     nvme: unregister when pr_register() is given a zero new key
>=20
> Guixin Liu <kanie@linux.alibaba.com>
>     nvme: tuning pr code by using defined structs and macros
>=20
> Jesse Zhang <Jesse.Zhang@amd.com>
>     drm/amdgpu: don't walk the CS chunks when allocating them failed
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (tmp108) Fix initial conversion delay and wait until ready
>=20
> Frank Li <Frank.Li@nxp.com>
>     hwmon: (tmp108) Add helper function tmp108_common_probe() to prepare =
I3C support
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     fbdev: kyro: Release WC setup on registration failure
>=20
> Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
>     fbdev: kyro: Use devm_ioremap_wc() for screen mem
>=20
> Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
>     fbdev: kyro: Use devm_ioremap() for mmio registers
>=20
> Chris Mason <mason@kernel.org>
>     mm/huge_memory: fix truncate racing with PMD zapping
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm: fix address wraparound when scanning large folio PTEs
>=20
> Aditya Sharma <adi.sharma@zohomail.in>
>     mm/memory: update stale locking comments for fault handlers
>=20
> Jinliang Zheng <alexjlzheng@gmail.com>
>     mm: fix outdated incorrect code comments for handle_mm_fault()
>=20
> Li Zhe <lizhe.67@bytedance.com>
>     mm/hugetlb: fix mremap deadlock when PMD sharing is possible
>=20
> Chengfeng Ye <nicoyip.dev@gmail.com>
>     l2tp: snapshot sequencing state when building transmit headers
>=20
> Fuad Tabba <fuad.tabba@linux.dev>
>     KVM: arm64: vgic-its: Don't map an LPI from more than one event
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: target: Fix LUN/device R/W and total command stats
>=20
> Yu Zhang <yuz08559@gmail.com>
>     scsi: target: Fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: target: Move I/O path stats to per CPU
>=20
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>     mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
>=20
> Sasha Levin <sashal@kernel.org>
>     Revert "x86/mm/pat: Fix effective RW computation in lookup_address_in=
_pgd_attr()"
>=20
> Sasha Levin <sashal@kernel.org>
>     Revert "x86/mm/pat: Use pr_warn() for early W^X warnings"
>=20
> Jann Horn <jannh@google.com>
>     cipso: stop modifying live ip_options_rcu
>=20
> Ian Bridges <icb@fastmail.org>
>     ksmbd: do not read past the DACL in the access denied debug message
>=20
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     hwmon: chipcap2: synchronize ready IRQ state
>=20
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     hwmon: chipcap2: serialize access to the alarm indicators
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (chipcap2) Drop unnecessary include files
>=20
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     hwmon: (chipcap2) Switch to guard() for mutext handling
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ocfs2: validate move extents against a stable EOF
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: raid56: do not verify the content if there is no data checksum
>=20
> Kevin Wang <kevin.wang@amd.com>
>     drm/amd/pm: populate unique ID for smu 13.0.7
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (coretemp) Set nr_cores only after core_data allocation succee=
ds
>=20
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: Signal PQ EOTF in FreeSync infopacket for DP HDR
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     drm/msm/hdmi: Handle msm_hdmi_power_on() errors during .atomic_pre_en=
able()
>=20
> Eva Kurchatova <eva.kurchatova@virtuozzo.com>
>     hugetlbfs: enforce F_SEAL_EXEC in setattr
>=20
> Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>     drm/amd/display: set allow_freesync before validating a new stream
>=20
> Leo Liu <leo.liu@amd.com>
>     drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce=
/jpeg
>=20
> Johannes Weiner <hannes@cmpxchg.org>
>     mm: page_alloc: do not give all non-blocking requests reserve access
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/mremap: recheck PUDs under the page table lock
>=20
> Josef Bacik <josef@toxicpanda.com>
>     mm/mremap: fix moving PUD leaves
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     hwmon: (sht15) Stop deferred work before releasing its resources
>=20
> Pan Chuang <panchuang@vivo.com>
>     hwmon: (sht15) Remove redundant dev_err()
>=20
> Lance Yang <lance.yang@linux.dev>
>     khugepaged: fix readahead lock inversion in collapse_file()
>=20
> Will Deacon <will@kernel.org>
>     tools: linux/types.h: Add 128-bit integer types for arm64 UAPI struct=
ures
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcm: Prevent O_APPEND open on OSS streams
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcm: Optimize cpu_latency_qos_*() calls
>=20
> Vincent Mailhol <mailhol@kernel.org>
>     can: dev: can_dropped_invalid_skb: drop CAN XL frames on non-CAN XL d=
evices
>=20
> Matt Turner <mattst88@gmail.com>
>     alpha: select SYSCTL_EXCEPTION_TRACE
>=20
> Yufan Chen <ericterminal@gmail.com>
>     io_uring/eventfd: reset deferred signal state
>=20
> Eric Dumazet <edumazet@kernel.org>
>     inet: frags: bound the wmem charge of the socket completing a reassem=
bly
>=20
> Ciro Pedrini <ciro.pedrini@gmail.com>
>     platform/x86: hp-wmi: Add OMEN board 8A17 thermal profile support
>=20
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     platform/x86: hp-wmi: Order DMI board name arrays
>=20
> Chengfeng Ye <nicoyip.dev@gmail.com>
>     mm/ksm: mark migration stores with WRITE_ONCE()
>=20
> Georgia Garcia <georgia.garcia@canonical.com>
>     apparmor: fix profile leak when a policy load fails
>=20
> Jesse Zhang <Jesse.Zhang@amd.com>
>     drm/amdgpu: drop the gang leader reference when freeing gang jobs
>=20
> Prike Liang <Prike.Liang@amd.com>
>     drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
>=20
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>     mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
>=20
> Chao Yu <chao@kernel.org>
>     f2fs: fix to fetch ino via ino_of_node() under cache lock
>=20
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>     mm/vma: update VMA iterator state on error in new VMA merge
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/memory-tiers: unregister empty tiers outside memory_tier_lock
>=20
> Amir Goldstein <amir73il@gmail.com>
>     ovl: inherit FMODE_NONOTIFY when opening directory realfiles
>=20
> Darong Lu <zzyy19904204639@163.com>
>     libceph: initialize CRUSH choose argument weights
>=20
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     hwmon: chipcap2: disable device after hwmon teardown
>=20
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     hwmon: chipcap2: fix IRQ teardown ordering
>=20
> Chao Yu <chao@kernel.org>
>     f2fs: fix to update superblock crc in sanity_check_area_boundary()
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/userfaultfd: wake waiters when registration modes are removed
>=20
> Christian Brauner <brauner@kernel.org>
>     backing-file: enforce append-only and immutable backing inodes
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/userfaultfd: write-lock the VMA before waking waiters when unregis=
tering
>=20
> Linlin Yang <yanglinlin@kylinos.cn>
>     wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_=
hif2()
>=20
> Christian Brauner <brauner@kernel.org>
>     proc: don't let an entry below /proc/<pid>/net be a mountpoint
>=20
> Ali Ahmet Memi=C5=9F <aliamemis@disroot.org>
>     platform/x86: ideapad-laptop: Evaluate ACPI methods exclusively
>=20
> Ali Ahmet Memi=C5=9F <aliamemis@disroot.org>
>     ACPI: utils: Add exclusive AML evaluation helpers
>=20
> Eklavya Singh <eklavyasingh2106@gmail.com>
>     ocfs2/heartbeat: serialize concurrent writes to a region's dev attrib=
ute
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     ocfs2/cluster: hold a reference on the heartbeat thread
>=20
> guolingxing <guolingxing@tju.edu.cn>
>     btrfs: prevent deleting the wrong subvolume by ID
>=20
> William Palacek <William.Palacek@amd.com>
>     drm/amdkfd: Validate the control stack of a restored queue
>=20
> Rik van Riel <riel@surriel.com>
>     mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
>=20
> Yao Yiqi <yaoyiqi3@huawei.com>
>     fbcon: Rebuild rotated font buffer on font change
>=20
> Priyank Rathod <rathodpriyank@google.com>
>     PCI/AER: Fix memory leak in aer_recover_work_func() when pci_dev is m=
issing
>=20
> Vernon Yang <yanglincheng@kylinos.cn>
>     selftests/mm: include kselftest.h in vm_util.h
>=20
> Ian Bridges <icb@fastmail.org>
>     ksmbd: enforce the read-only share flag when creating a stream
>=20
> David Hildenbrand (Arm) <david@kernel.org>
>     mm/ksm: fix use of a freed anon_vma at swap-in
>=20
> Ian Bridges <icb@fastmail.org>
>     ksmbd: revert fsids on durable reconnect and replay failure
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     9p/xen: drain response work after unbinding IRQ
>=20
> Josef Bacik <josef@toxicpanda.com>
>     mm/hugetlb: fix endless write fault on a leftover uffd bit
>=20
> Eric Dumazet <edumazet@kernel.org>
>     inet: frags: limit the truesize of a reassembly queue
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: nSVM: Check validity of vmcs01 save area copied from SMRAM on RSM
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  .gitignore                                         |    1 -
>  Documentation/ABI/testing/sysfs-bus-pci            |   14 +-
>  Documentation/ABI/testing/sysfs-class-power-mp2629 |    2 +-
>  Documentation/admin-guide/LSM/LoadPin.rst          |   10 +-
>  Documentation/admin-guide/LSM/ipe.rst              |    4 +-
>  .../bindings/arm/mediatek/mediatek,audsys.yaml     |    2 +-
>  .../bindings/clock/mediatek,apmixedsys.yaml        |    2 +-
>  .../bindings/clock/mediatek,topckgen.yaml          |    2 +-
>  .../devicetree/bindings/display/msm/hdmi.yaml      |    4 +-
>  .../devicetree/bindings/dma/stericsson,dma40.yaml  |   14 +
>  .../bindings/iio/light/liteon,ltr501.yaml          |    3 +-
>  .../media/allwinner,sun4i-a10-video-engine.yaml    |   21 +-
>  .../power/supply/stericsson,ab8500-charger.yaml    |   76 +-
>  .../devicetree/bindings/vendor-prefixes.yaml       |   22 +
>  Documentation/sound/designs/midi-2.0.rst           |    7 +
>  Documentation/trace/histogram.rst                  |    3 +
>  Makefile                                           |    4 +-
>  arch/alpha/Kconfig                                 |    1 +
>  arch/alpha/mm/fault.c                              |   29 +
>  arch/arc/Makefile                                  |    9 +-
>  arch/arc/lib/Makefile                              |    8 +
>  arch/arm/boot/dts/gemini/gemini.dtsi               |    2 +-
>  .../boot/dts/marvell/armada-385-clearfog-gtr.dtsi  |    2 +-
>  arch/arm/boot/dts/marvell/armada-388-helios4.dts   |   23 +-
>  arch/arm/boot/dts/marvell/armada-395-gp.dts        |    1 -
>  arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi          |   40 +-
>  arch/arm/boot/dts/qcom/qcom-msm8974.dtsi           |   30 +-
>  arch/arm/boot/dts/st/ste-ab8500.dtsi               |    6 -
>  arch/arm/boot/dts/st/ste-ab8505.dtsi               |   23 +-
>  arch/arm/boot/dts/st/ste-dbx5x0.dtsi               |    5 -
>  arch/arm/boot/dts/st/ste-href-ab8500.dtsi          |  104 ++
>  arch/arm/boot/dts/st/ste-href-ab8505.dtsi          |  118 +-
>  arch/arm/boot/dts/st/stm32mp135.dtsi               |   44 +-
>  arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts       |    2 +-
>  arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi      |    2 +-
>  arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi    |    2 +
>  arch/arm/include/asm/domain.h                      |   17 -
>  arch/arm/include/asm/memory.h                      |    4 +-
>  arch/arm/include/asm/pgtable-2level-hwdef.h        |    1 -
>  arch/arm/include/asm/pgtable-2level.h              |    7 -
>  arch/arm/include/asm/sparsemem.h                   |    4 +
>  arch/arm/kernel/efi.c                              |   13 +
>  arch/arm/mach-mvebu/Kconfig                        |    4 +-
>  arch/arm/mach-versatile/platsmp-vexpress.c         |    4 +-
>  arch/arm/mach-versatile/v2m.c                      |    4 +-
>  arch/arm/mm/Kconfig                                |    7 -
>  arch/arm/mm/alignment.c                            |   10 +-
>  arch/arm/mm/dma-mapping.c                          |    5 +-
>  arch/arm/mm/ioremap.c                              |   53 +-
>  arch/arm/mm/mmu.c                                  |   76 +-
>  arch/arm64/Kconfig.platforms                       |    1 -
>  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |    4 +-
>  arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |    9 +
>  .../boot/dts/amlogic/meson-sm1-odroid-hc4.dts      |    4 +-
>  arch/arm64/boot/dts/freescale/imx8dxl-evk.dts      |   14 +-
>  arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |   26 +-
>  arch/arm64/boot/dts/freescale/imx8ulp-evk.dts      |    4 +-
>  arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts  |    4 +-
>  arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts    |    4 +-
>  arch/arm64/boot/dts/freescale/imx95.dtsi           |    4 +-
>  arch/arm64/boot/dts/mediatek/mt8173.dtsi           |    2 +-
>  arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi         |    8 +-
>  arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi     |   13 +-
>  .../boot/dts/qcom/sdm845-sony-xperia-tama.dtsi     |    2 +
>  arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |    4 +
>  arch/arm64/boot/dts/qcom/sm8150.dtsi               |    2 +-
>  .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |    1 +
>  arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |    1 +
>  arch/arm64/boot/dts/rockchip/rk3328.dtsi           |    2 +-
>  arch/arm64/boot/dts/rockchip/rk3399-firefly.dts    |   32 +-
>  arch/arm64/boot/dts/rockchip/rk3566-base.dtsi      |   39 +
>  arch/arm64/boot/dts/rockchip/rk3566.dtsi           |  118 +-
>  arch/arm64/boot/dts/rockchip/rk3568.dtsi           |  117 +-
>  .../dts/rockchip/{rk356x.dtsi =3D> rk356x-base.dtsi} |   82 --
>  .../boot/dts/rockchip/rk3588s-gameforce-ace.dts    |    7 +-
>  arch/arm64/boot/dts/st/stm32mp231.dtsi             | 1213 ++++++++++++++=
++++++
>  arch/arm64/boot/dts/st/stm32mp233.dtsi             |   94 ++
>  arch/arm64/boot/dts/st/stm32mp235.dtsi             |   16 +
>  arch/arm64/boot/dts/st/stm32mp23xc.dtsi            |    8 +
>  arch/arm64/boot/dts/st/stm32mp23xf.dtsi            |    8 +
>  arch/arm64/boot/dts/st/stm32mp251.dtsi             |    2 +-
>  arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   41 +-
>  arch/arm64/boot/dts/ti/k3-j722s-evm.dts            |  124 +-
>  arch/arm64/kernel/pi/Makefile                      |    1 +
>  arch/arm64/kvm/vgic/vgic-its.c                     |   37 +-
>  arch/m68k/apollo/dn_ints.c                         |    6 +
>  arch/m68k/mac/config.c                             |   31 +-
>  arch/microblaze/Makefile                           |    6 +-
>  arch/microblaze/include/asm/uaccess.h              |    3 +-
>  arch/microblaze/kernel/cpu/cpuinfo.c               |    1 +
>  arch/microblaze/kernel/ptrace.c                    |    3 +
>  arch/mips/Makefile                                 |   22 +-
>  arch/mips/cavium-octeon/dma-octeon.c               |    2 +-
>  arch/nios2/kernel/nios2_ksyms.c                    |    1 +
>  arch/powerpc/kernel/trace/ftrace_entry.S           |    6 +
>  arch/riscv/include/asm/insn.h                      |    2 +-
>  arch/riscv/net/bpf_jit_comp64.c                    |   14 +-
>  arch/riscv/net/bpf_jit_core.c                      |    1 +
>  arch/s390/kernel/ptrace.c                          |    9 +-
>  arch/s390/kernel/uprobes.c                         |    2 +-
>  arch/sh/Kconfig                                    |    1 +
>  arch/sh/boards/board-sh7785lcr.c                   |    2 +-
>  arch/sh/configs/migor_defconfig                    |    2 +-
>  arch/sh/configs/sdk7786_defconfig                  |    2 +-
>  arch/sh/configs/shx3_defconfig                     |    2 +-
>  arch/sh/include/asm/uaccess_32.h                   |    8 +-
>  arch/um/drivers/ubd_kern.c                         |    1 -
>  arch/x86/boot/compressed/efi_mixed.S               |   16 +-
>  arch/x86/include/asm/efi.h                         |    3 +
>  arch/x86/include/asm/svm.h                         |    4 +-
>  arch/x86/kernel/cpu/microcode/amd.c                |   12 +-
>  arch/x86/kernel/crash.c                            |    6 +-
>  arch/x86/kvm/svm/nested.c                          |   23 +-
>  arch/x86/kvm/svm/svm.c                             |    2 +
>  arch/x86/kvm/svm/svm.h                             |    2 +
>  arch/x86/mm/pat/set_memory.c                       |   23 +-
>  arch/x86/platform/efi/efi.c                        |   29 -
>  arch/x86/platform/efi/efi_64.c                     |   42 -
>  arch/x86/platform/pvh/enlighten.c                  |    2 +
>  arch/x86/power/hibernate.c                         |   51 +-
>  block/bdev.c                                       |   12 +-
>  block/bfq-iosched.c                                |    4 +-
>  block/blk-cgroup.c                                 |   19 +-
>  block/blk-cgroup.h                                 |    6 +-
>  block/blk-flush.c                                  |    8 +-
>  block/blk-iocost.c                                 |  311 +++--
>  block/blk-iolatency.c                              |    3 +-
>  block/blk-map.c                                    |    1 +
>  block/blk-mq-debugfs.c                             |    1 -
>  block/blk-mq-sched.c                               |    3 +-
>  block/blk-mq.c                                     |   42 +-
>  block/blk-rq-qos.c                                 |   18 +-
>  block/blk-throttle.c                               |   91 +-
>  block/blk-timeout.c                                |    3 +-
>  block/blk.h                                        |   14 +
>  block/fops.c                                       |   12 +-
>  block/partitions/mac.c                             |    4 +-
>  crypto/asymmetric_keys/verify_pefile.c             |    5 +
>  crypto/lskcipher.c                                 |    6 +-
>  crypto/tcrypt.c                                    |  182 +--
>  drivers/accel/qaic/qaic_data.c                     |    8 +-
>  drivers/acpi/acpi_extlog.c                         |    9 +
>  drivers/acpi/acpi_pcc.c                            |   29 +-
>  drivers/acpi/acpi_video.c                          |   12 +-
>  drivers/acpi/acpica/dsfield.c                      |    3 +-
>  drivers/acpi/acpica/exfield.c                      |   11 +-
>  drivers/acpi/acpica/nsxfname.c                     |    1 +
>  drivers/acpi/apei/ghes.c                           |   16 +-
>  drivers/acpi/button.c                              |   12 +
>  drivers/acpi/cppc_acpi.c                           |   22 +-
>  drivers/acpi/device_pm.c                           |   77 +-
>  drivers/acpi/fan_core.c                            |    9 +-
>  drivers/acpi/glue.c                                |   10 +-
>  drivers/acpi/numa/hmat.c                           |    2 +-
>  drivers/acpi/pci_link.c                            |    1 +
>  drivers/acpi/pci_root.c                            |   22 +-
>  drivers/acpi/scan.c                                |   40 +-
>  drivers/acpi/tables.c                              |    3 +
>  drivers/acpi/utils.c                               |   41 +
>  drivers/ata/libahci.c                              |   15 +
>  drivers/ata/libata-core.c                          |   12 +
>  drivers/ata/libata-scsi.c                          |    2 +-
>  drivers/ata/pata_parport/pata_parport.c            |    9 +-
>  drivers/ata/sata_dwc_460ex.c                       |    5 +-
>  drivers/base/node.c                                |   17 +-
>  drivers/base/power/runtime.c                       |    6 +-
>  drivers/base/power/wakeirq.c                       |   26 +
>  drivers/block/amiflop.c                            |    1 -
>  drivers/block/aoe/aoeblk.c                         |    1 -
>  drivers/block/ataflop.c                            |    1 -
>  drivers/block/drbd/drbd_main.c                     |    1 +
>  drivers/block/drbd/drbd_receiver.c                 |    2 +
>  drivers/block/floppy.c                             |   11 +-
>  drivers/block/loop.c                               |    3 +-
>  drivers/block/mtip32xx/mtip32xx.c                  |    1 -
>  drivers/block/nbd.c                                |    3 +-
>  drivers/block/null_blk/main.c                      |    2 -
>  drivers/block/ps3disk.c                            |    3 +-
>  drivers/block/rbd.c                                |    1 -
>  drivers/block/rnbd/rnbd-clt.c                      |    3 +-
>  drivers/block/rnbd/rnbd-srv-sysfs.c                |   28 +-
>  drivers/block/rnbd/rnbd-srv.c                      |   36 +-
>  drivers/block/sunvdc.c                             |    2 +-
>  drivers/block/swim.c                               |  287 ++---
>  drivers/block/swim3.c                              |   11 +-
>  drivers/block/swim_asm.S                           |  136 +--
>  drivers/block/ublk_drv.c                           |    1 -
>  drivers/block/virtio_blk.c                         |    3 +-
>  drivers/block/xen-blkback/blkback.c                |    7 +
>  drivers/block/xen-blkfront.c                       |    1 -
>  drivers/block/z2ram.c                              |    1 -
>  drivers/bluetooth/btintel.c                        |    6 +-
>  drivers/bluetooth/btmtk.c                          |   88 +-
>  drivers/bluetooth/btmtksdio.c                      |   13 +-
>  drivers/bluetooth/btusb.c                          |   19 +-
>  drivers/bluetooth/virtio_bt.c                      |    4 +-
>  drivers/bus/arm-cci.c                              |    6 +-
>  drivers/cdrom/gdrom.c                              |    2 +-
>  drivers/char/hw_random/cctrng.c                    |    7 +-
>  drivers/char/hw_random/intel-rng.c                 |    5 +-
>  drivers/char/hw_random/jh7110-trng.c               |   39 +-
>  drivers/char/scx200_gpio.c                         |    8 +-
>  drivers/clk/bcm/clk-raspberrypi.c                  |    2 +
>  drivers/clk/clk-cdce925.c                          |    9 +-
>  drivers/clk/clk-lmk04832.c                         |    3 +
>  drivers/clk/clk-milbeaut.c                         |   10 +-
>  drivers/clk/clk-renesas-pcie.c                     |    5 +
>  drivers/clk/clk-s2mps11.c                          |   12 +-
>  drivers/clk/clk-si521xx.c                          |    2 +-
>  drivers/clk/clk-si5351.c                           |   20 +-
>  drivers/clk/clk.c                                  |   51 +-
>  drivers/clk/clk.h                                  |    5 +-
>  drivers/clk/clkdev.c                               |    4 +-
>  drivers/clk/imx/clk-composite-93.c                 |   11 +-
>  drivers/clk/mediatek/reset.h                       |    6 +-
>  drivers/clk/qcom/clk-alpha-pll.c                   |    9 +
>  drivers/clk/qcom/clk-rcg2.c                        |   35 +-
>  drivers/clk/qcom/dispcc-sm8450.c                   |    2 +-
>  drivers/clk/qcom/gcc-x1e80100.c                    |    6 +-
>  drivers/clk/qcom/mmcc-msm8960.c                    |    3 +-
>  drivers/clk/qcom/mmcc-msm8996.c                    |    4 +-
>  drivers/clk/qcom/mmcc-sdm660.c                     |    2 +-
>  drivers/clk/starfive/clk-starfive-jh7110-sys.c     |    3 +
>  drivers/clk/ti/adpll.c                             |    1 +
>  drivers/clk/versatile/clk-icst.c                   |    4 +
>  drivers/clocksource/clksrc-dbx500-prcmu.c          |    2 +
>  drivers/clocksource/timer-mediatek.c               |    4 +-
>  drivers/comedi/drivers/addi_apci_3xxx.c            |    2 +-
>  drivers/comedi/drivers/comedi_parport.c            |    3 +-
>  drivers/comedi/drivers/dmm32at.c                   |    3 +-
>  drivers/comedi/drivers/dt2811.c                    |    2 +-
>  drivers/comedi/drivers/dt2814.c                    |    3 +-
>  drivers/comedi/drivers/ni_atmio16d.c               |    4 +-
>  drivers/comedi/drivers/pcmmio.c                    |    3 +-
>  drivers/comedi/drivers/pcmuio.c                    |    5 +-
>  drivers/cpufreq/amd-pstate.c                       |   18 +-
>  drivers/cpufreq/qcom-cpufreq-hw.c                  |    3 +
>  drivers/cpufreq/sparc-us2e-cpufreq.c               |   11 +-
>  drivers/cpufreq/sti-cpufreq.c                      |    4 +-
>  drivers/cpufreq/tegra194-cpufreq.c                 |    2 +-
>  drivers/cpuidle/governors/menu.c                   |    8 +-
>  drivers/cpuidle/governors/teo.c                    |   11 +
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c        |   25 +-
>  drivers/crypto/atmel-aes.c                         |    2 +
>  drivers/crypto/atmel-sha.c                         |   17 +
>  drivers/crypto/ccp/ccp-dev-v3.c                    |    4 +
>  drivers/crypto/ccp/ccp-dev-v5.c                    |    4 +
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    2 -
>  drivers/crypto/intel/qat/qat_common/adf_init.c     |   24 +-
>  drivers/crypto/intel/qat/qat_common/adf_isr.c      |   15 +-
>  drivers/crypto/intel/qat/qat_common/qat_algs.c     |   15 +-
>  .../crypto/intel/qat/qat_common/qat_asym_algs.c    |   38 +-
>  drivers/crypto/mxs-dcp.c                           |    3 +
>  drivers/crypto/starfive/jh7110-cryp.c              |   20 +-
>  drivers/crypto/talitos.c                           |   93 +-
>  drivers/crypto/talitos.h                           |    5 +-
>  drivers/cxl/acpi.c                                 |    7 +-
>  drivers/cxl/core/hdm.c                             |   57 +-
>  drivers/cxl/core/pci.c                             |    9 +
>  drivers/cxl/core/port.c                            |   28 +-
>  drivers/cxl/core/region.c                          |    4 +-
>  drivers/cxl/cxl.h                                  |   10 +-
>  drivers/dax/bus.c                                  |    8 +-
>  drivers/dma/at_hdmac.c                             |   28 +-
>  drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   37 +-
>  drivers/dma/dw-axi-dmac/dw-axi-dmac.h              |    5 +-
>  drivers/dma/fsl_raid.c                             |   32 +-
>  drivers/dma/img-mdc-dma.c                          |    2 +-
>  drivers/dma/ioat/init.c                            |   18 +-
>  drivers/dma/mediatek/mtk-hsdma.c                   |   26 +-
>  drivers/dma/mv_xor.c                               |    1 +
>  drivers/dma/plx_dma.c                              |   10 +-
>  drivers/dma/sprd-dma.c                             |   45 +-
>  drivers/dma/ste_dma40.c                            |  434 ++++---
>  drivers/dma/ste_dma40_ll.h                         |    2 -
>  drivers/dma/sun6i-dma.c                            |   31 +-
>  drivers/dma/xilinx/xilinx_dma.c                    |   37 +-
>  drivers/dma/xilinx/zynqmp_dma.c                    |   29 +-
>  drivers/edac/i10nm_base.c                          |    1 +
>  drivers/firmware/arm_scmi/common.h                 |   22 +
>  drivers/firmware/arm_scmi/driver.c                 |   38 +-
>  drivers/firmware/arm_scmi/protocols.h              |    9 +-
>  drivers/firmware/arm_scmi/raw_mode.c               |   29 +-
>  drivers/firmware/cirrus/cs_dsp.c                   |    2 +
>  drivers/firmware/efi/cper.c                        |   51 +-
>  drivers/firmware/efi/efi.c                         |    3 -
>  drivers/firmware/efi/libstub/efi-stub-entry.c      |    4 +-
>  drivers/firmware/efi/libstub/efi-stub-helper.c     |   10 +-
>  drivers/firmware/efi/libstub/efi-stub.c            |   30 +-
>  drivers/firmware/efi/libstub/efistub.h             |   22 +-
>  drivers/firmware/efi/libstub/fdt.c                 |    6 +-
>  drivers/firmware/efi/libstub/file.c                |    8 +-
>  drivers/firmware/efi/libstub/gop.c                 |   58 +-
>  drivers/firmware/efi/libstub/kaslr.c               |    6 +-
>  drivers/firmware/efi/libstub/mem.c                 |   22 +-
>  drivers/firmware/efi/libstub/pci.c                 |   38 +-
>  drivers/firmware/efi/libstub/random.c              |    8 +-
>  drivers/firmware/efi/libstub/randomalloc.c         |    4 +-
>  drivers/firmware/efi/libstub/relocate.c            |   10 +-
>  drivers/firmware/efi/libstub/riscv-stub.c          |    7 +-
>  drivers/firmware/efi/libstub/riscv.c               |    2 +-
>  drivers/firmware/efi/libstub/tpm.c                 |    8 +-
>  drivers/firmware/efi/libstub/unaccepted_memory.c   |    2 +-
>  drivers/firmware/efi/libstub/x86-stub.c            |  210 +---
>  drivers/firmware/imx/imx-dsp.c                     |    6 +-
>  drivers/firmware/qcom/qcom_tzmem.c                 |    2 +-
>  drivers/gpio/gpio-crystalcove.c                    |    1 +
>  drivers/gpio/gpio-pcf857x.c                        |   33 +-
>  drivers/gpu/buddy.c                                |    1 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |    8 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |    3 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |    8 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   35 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |    5 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   48 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   19 +-
>  drivers/gpu/drm/amd/amdgpu/atom.c                  |  105 +-
>  drivers/gpu/drm/amd/amdgpu/atom.h                  |    5 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |    6 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |    6 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |    6 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |    6 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |    6 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c           |    6 +-
>  drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c           |    6 +-
>  drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |    4 +-
>  drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c              |    4 +-
>  drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c              |    4 +-
>  drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |    4 +-
>  drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |    4 +-
>  drivers/gpu/drm/amd/amdgpu/vce_v2_0.c              |    6 +-
>  drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |    6 +-
>  drivers/gpu/drm/amd/amdgpu/vce_v4_0.c              |    6 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |    9 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |    8 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |    8 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |    8 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |    6 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |    6 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |    6 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |    6 +-
>  drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            |   10 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |    3 +
>  drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |    3 +
>  drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |    3 +
>  drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    |    3 +
>  .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   48 +-
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   20 +-
>  .../drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h    |   38 +-
>  drivers/gpu/drm/amd/display/dc/core/dc.c           |    9 +-
>  .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |   32 +
>  drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h |    3 +
>  .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |    3 +
>  .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |   20 +
>  .../gpu/drm/arm/display/include/malidp_product.h   |   10 +-
>  drivers/gpu/drm/drm_of.c                           |    8 +-
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c           |    2 +-
>  drivers/gpu/drm/i915/display/intel_atomic_plane.c  |    1 +
>  drivers/gpu/drm/i915/display/intel_display.c       |   12 +
>  drivers/gpu/drm/i915/display/intel_psr.c           |   49 +-
>  drivers/gpu/drm/imx/lcdc/imx-lcdc.c                |    3 +-
>  drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |    6 +-
>  drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |    2 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |  102 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h      |   10 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |    2 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   10 +-
>  .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |    4 +-
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c           |    9 -
>  drivers/gpu/drm/msm/dp/dp_ctrl.c                   |    3 +
>  drivers/gpu/drm/msm/dp/dp_debug.c                  |    1 +
>  drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |   30 +-
>  drivers/gpu/drm/msm/msm_io_utils.c                 |    6 +-
>  drivers/gpu/drm/omapdrm/dss/dsi.c                  |   63 +-
>  drivers/gpu/drm/panfrost/panfrost_devfreq.c        |    2 +-
>  drivers/gpu/drm/panfrost/panfrost_mmu.c            |   11 +-
>  drivers/gpu/drm/panthor/panthor_gpu.c              |    5 +-
>  drivers/gpu/drm/tegra/submit.c                     |   12 +-
>  drivers/hid/hid-logitech-hidpp.c                   |    1 +
>  drivers/hid/i2c-hid/i2c-hid-core.c                 |   11 +-
>  drivers/hid/wacom_wac.c                            |   14 +-
>  drivers/hv/vmbus_drv.c                             |    8 +-
>  drivers/hwmon/chipcap2.c                           |  260 +++--
>  drivers/hwmon/coretemp.c                           |   19 +-
>  drivers/hwmon/sht15.c                              |   26 +-
>  drivers/hwmon/tmp108.c                             |   65 +-
>  drivers/iio/accel/bma220_spi.c                     |    3 +-
>  drivers/iio/accel/kionix-kx022a.h                  |    2 +-
>  drivers/iio/dac/ad5758.c                           |    8 +-
>  drivers/iio/humidity/hts221_core.c                 |  106 +-
>  drivers/iio/imu/adis16400.c                        |    5 +-
>  drivers/iio/pressure/rohm-bm1390.c                 |    4 +-
>  drivers/iio/temperature/tmp117.c                   |    9 +-
>  drivers/infiniband/core/device.c                   |    2 +-
>  drivers/infiniband/core/lag.c                      |   14 +-
>  drivers/infiniband/core/mad.c                      |    2 +
>  drivers/infiniband/core/mad_rmpp.c                 |    7 +-
>  drivers/infiniband/core/nldev.c                    |    5 +-
>  drivers/infiniband/core/restrack.c                 |    3 +-
>  drivers/infiniband/core/sysfs.c                    |    9 +-
>  drivers/infiniband/core/uverbs_std_types_device.c  |    1 +
>  drivers/infiniband/core/uverbs_std_types_wq.c      |    2 +-
>  drivers/infiniband/core/verbs.c                    |    3 +-
>  drivers/infiniband/hw/bnxt_re/hw_counters.c        |    6 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   58 +-
>  drivers/infiniband/hw/bnxt_re/qplib_res.c          |    9 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c           |    2 +-
>  drivers/infiniband/hw/cxgb4/cm.c                   |    5 +-
>  drivers/infiniband/hw/cxgb4/provider.c             |    5 +
>  drivers/infiniband/hw/efa/efa_com.c                |   28 +-
>  drivers/infiniband/hw/erdma/erdma_main.c           |    4 +-
>  drivers/infiniband/hw/erdma/erdma_verbs.c          |   16 +-
>  drivers/infiniband/hw/hfi1/sdma.c                  |    3 +
>  drivers/infiniband/hw/hfi1/verbs.c                 |    4 +
>  drivers/infiniband/hw/hns/hns_roce_cq.c            |    1 +
>  drivers/infiniband/hw/hns/hns_roce_device.h        |    1 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   55 +-
>  drivers/infiniband/hw/irdma/ctrl.c                 |    8 +-
>  drivers/infiniband/hw/irdma/pble.c                 |    8 +-
>  drivers/infiniband/hw/irdma/type.h                 |    4 +-
>  drivers/infiniband/hw/irdma/verbs.c                |   13 +-
>  drivers/infiniband/hw/mlx4/main.c                  |    4 +
>  drivers/infiniband/hw/mlx5/cq.c                    |   24 +-
>  drivers/infiniband/hw/mlx5/fs.c                    |    4 +-
>  drivers/infiniband/hw/mlx5/main.c                  |    2 +
>  drivers/infiniband/hw/mlx5/mlx5_ib.h               |    2 +
>  drivers/infiniband/hw/mlx5/odp.c                   |    2 +-
>  drivers/infiniband/hw/mlx5/qp.c                    |    8 +-
>  drivers/infiniband/hw/mlx5/qpc.c                   |    8 +-
>  drivers/infiniband/hw/mlx5/srq.c                   |    3 +-
>  drivers/infiniband/hw/mlx5/wr.c                    |    1 +
>  drivers/infiniband/hw/usnic/usnic_debugfs.c        |    2 +-
>  drivers/infiniband/sw/rdmavt/qp.c                  |    2 +-
>  drivers/infiniband/sw/rxe/rxe_loc.h                |    8 +-
>  drivers/infiniband/sw/rxe/rxe_mr.c                 |   12 +-
>  drivers/infiniband/sw/rxe/rxe_mw.c                 |    3 +
>  drivers/infiniband/sw/rxe/rxe_net.c                |   70 +-
>  drivers/infiniband/sw/rxe/rxe_qp.c                 |   10 +
>  drivers/infiniband/sw/rxe/rxe_recv.c               |    9 +-
>  drivers/infiniband/sw/rxe/rxe_req.c                |   11 +-
>  drivers/infiniband/sw/rxe/rxe_resp.c               |   23 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.h              |    1 +
>  drivers/infiniband/sw/siw/siw_main.c               |    5 +-
>  drivers/infiniband/sw/siw/siw_qp_tx.c              |   20 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c          |    7 +
>  drivers/infiniband/ulp/isert/ib_isert.c            |    2 +-
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   32 +-
>  drivers/infiniband/ulp/srp/ib_srp.c                |    2 +-
>  drivers/interconnect/qcom/icc-rpm.c                |   11 +-
>  drivers/interconnect/qcom/icc-rpm.h                |    4 +-
>  drivers/interconnect/qcom/smd-rpm.c                |    8 +-
>  drivers/interconnect/samsung/exynos.c              |    1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c   |    4 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |    6 +
>  drivers/iommu/intel/dmar.c                         |   70 +-
>  drivers/irqchip/irq-gic-common.c                   |    2 +-
>  drivers/irqchip/irq-gic-v3-its.c                   |  156 ++-
>  drivers/irqchip/irq-gic-v3.c                       |   15 +-
>  drivers/irqchip/irq-gic.c                          |    4 +-
>  drivers/irqchip/irq-riscv-imsic-state.c            |   21 +-
>  drivers/leds/led-class-flash.c                     |    2 +-
>  drivers/leds/leds-lm3692x.c                        |    4 +-
>  drivers/leds/leds-lp8860.c                         |    5 +-
>  drivers/leds/leds-pca9532.c                        |    9 +-
>  drivers/mailbox/arm_mhuv2.c                        |    9 +-
>  drivers/mailbox/pcc.c                              |    5 +-
>  drivers/mailbox/qcom-cpucp-mbox.c                  |   37 +-
>  drivers/mailbox/qcom-ipcc.c                        |    1 -
>  drivers/mailbox/ti-msgmgr.c                        |   12 +-
>  drivers/md/dm-rq.c                                 |    2 +-
>  drivers/md/dm-snap.c                               |   18 +-
>  drivers/md/md.c                                    |   30 +-
>  drivers/md/raid10.c                                |    3 +-
>  drivers/md/raid5-cache.c                           |   14 +-
>  drivers/md/raid5-ppl.c                             |   12 +-
>  drivers/md/raid5.c                                 |   65 +-
>  drivers/media/i2c/ar0521.c                         |    1 -
>  drivers/media/i2c/ov5648.c                         |    4 +-
>  drivers/media/platform/qcom/venus/hfi_msgs.c       |    3 +
>  drivers/memory/brcmstb_dpfe.c                      |   17 +-
>  drivers/memory/emif.c                              |    3 +
>  drivers/memory/samsung/exynos5422-dmc.c            |   11 +-
>  drivers/memstick/core/ms_block.c                   |    3 +-
>  drivers/memstick/core/mspro_block.c                |    3 +-
>  drivers/mfd/da9150-core.c                          |    8 +-
>  drivers/mfd/intel_quark_i2c_gpio.c                 |   52 +-
>  drivers/mfd/rk8xx-core.c                           |    2 +-
>  drivers/misc/enclosure.c                           |    3 +-
>  drivers/misc/nsm.c                                 |    7 +-
>  drivers/mmc/core/queue.c                           |    2 +-
>  drivers/mtd/mtd_blkdevs.c                          |    7 +-
>  drivers/mtd/nand/raw/pl35x-nand-controller.c       |    1 +
>  drivers/mtd/spi-nor/spansion.c                     |    7 -
>  drivers/mtd/ubi/block.c                            |    2 +-
>  drivers/net/amt.c                                  |    8 +-
>  drivers/net/can/dev/skb.c                          |    2 +-
>  drivers/net/dsa/mv88e6xxx/chip.c                   |    8 +-
>  drivers/net/ethernet/alacritech/slicoss.c          |    2 +-
>  .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |    2 +-
>  drivers/net/ethernet/broadcom/asp2/bcmasp.c        |  121 +-
>  drivers/net/ethernet/broadcom/asp2/bcmasp.h        |    4 -
>  drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   32 +-
>  drivers/net/ethernet/broadcom/bgmac.c              |   51 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |    3 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    1 +
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  406 ++++---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.h     |    3 +
>  drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   80 +-
>  drivers/net/ethernet/broadcom/tg3.c                |    6 +
>  drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   12 +-
>  drivers/net/ethernet/ibm/ibmveth.c                 |   41 +-
>  drivers/net/ethernet/intel/ice/ice_lib.c           |    4 +
>  drivers/net/ethernet/intel/ice/ice_ptp.c           |   49 +-
>  drivers/net/ethernet/intel/ice/ice_ptp.h           |    6 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |    4 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |    2 +
>  drivers/net/ethernet/mellanox/mlx4/intf.c          |   15 +-
>  .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |    3 +
>  .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |    4 +
>  .../mlx5/core/steering/hws/mlx5hws_pat_arg.c       |    4 +-
>  drivers/net/ethernet/microchip/fdma/fdma_api.c     |   45 +-
>  drivers/net/ethernet/microchip/fdma/fdma_api.h     |   20 +-
>  .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   17 +-
>  .../net/ethernet/microchip/lan966x/lan966x_mac.c   |    4 +-
>  .../net/ethernet/microchip/lan966x/lan966x_main.c  |   19 +-
>  .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |   10 +-
>  .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |   58 +-
>  .../net/ethernet/microchip/sparx5/sparx5_main.c    |    7 +-
>  .../net/ethernet/microchip/sparx5/sparx5_main.h    |    2 +
>  .../net/ethernet/microchip/sparx5/sparx5_packet.c  |   15 +-
>  .../net/ethernet/microchip/sparx5/sparx5_psfp.c    |   10 +-
>  drivers/net/ethernet/netronome/nfp/flower/main.h   |    2 +
>  .../ethernet/netronome/nfp/flower/tunnel_conf.c    |   24 +-
>  .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |    1 +
>  drivers/net/ethernet/pensando/ionic/ionic_main.c   |   13 +-
>  drivers/net/ethernet/qlogic/qede/qede_filter.c     |    2 +-
>  drivers/net/ethernet/realtek/r8169_phy_config.c    |    6 +-
>  drivers/net/ethernet/stmicro/stmmac/common.h       |    4 +-
>  drivers/net/ethernet/stmicro/stmmac/descs.h        |    6 +-
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |    2 +-
>  drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |   25 +-
>  drivers/net/ethernet/stmicro/stmmac/hwif.h         |    6 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   10 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   39 -
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   66 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |    2 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   86 +-
>  drivers/net/gtp.c                                  |   51 +-
>  drivers/net/hamradio/hdlcdrv.c                     |    5 +-
>  drivers/net/loopback.c                             |    8 +-
>  drivers/net/macsec.c                               |    5 +
>  drivers/net/phy/Kconfig                            |    5 +-
>  drivers/net/phy/Makefile                           |    2 +-
>  drivers/net/phy/marvell.c                          |   97 +-
>  drivers/net/phy/qcom/qca83xx.c                     |   58 +
>  drivers/net/phy/realtek/Kconfig                    |    5 +
>  drivers/net/phy/realtek/Makefile                   |    3 +
>  .../net/phy/{realtek.c =3D> realtek/realtek_main.c}  |  197 +++-
>  drivers/net/ppp/pppoe.c                            |    3 +
>  drivers/net/team/team_core.c                       |   11 +
>  drivers/net/tun.c                                  |   10 +
>  drivers/net/usb/cdc_mbim.c                         |    5 +-
>  drivers/net/usb/cdc_ncm.c                          |    7 +-
>  drivers/net/usb/lan78xx.c                          |    9 +-
>  drivers/net/usb/usbnet.c                           |   32 +-
>  drivers/net/veth.c                                 |    7 +-
>  drivers/net/virtio_net.c                           |   12 +-
>  drivers/net/wireless/ath/ath10k/htt_tx.c           |   12 +-
>  drivers/net/wireless/ath/ath11k/Kconfig            |    3 +
>  drivers/net/wireless/ath/ath11k/ahb.c              |    1 +
>  drivers/net/wireless/ath/ath11k/ce.c               |    2 +-
>  drivers/net/wireless/ath/ath11k/core.c             |   13 +-
>  drivers/net/wireless/ath/ath11k/dp_rx.c            |   19 +-
>  drivers/net/wireless/ath/ath11k/mac.c              |   33 +-
>  drivers/net/wireless/ath/ath11k/mac.h              |    2 +-
>  drivers/net/wireless/ath/ath11k/wmi.c              |    9 +
>  .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |    2 +-
>  drivers/net/wireless/ath/ath12k/mac.c              |   21 +-
>  drivers/net/wireless/ath/ath12k/pci.c              |   55 +-
>  drivers/net/wireless/ath/ath6kl/cfg80211.c         |    2 -
>  drivers/net/wireless/ath/carl9170/debug.c          |    5 +-
>  drivers/net/wireless/ath/wil6210/txrx.h            |    4 +-
>  drivers/net/wireless/broadcom/b43/debugfs.c        |    2 +-
>  drivers/net/wireless/broadcom/b43legacy/debugfs.c  |    2 +-
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   10 +-
>  drivers/net/wireless/marvell/mwifiex/fw.h          |    6 +
>  drivers/net/wireless/marvell/mwifiex/init.c        |    1 +
>  drivers/net/wireless/marvell/mwifiex/main.c        |    4 +-
>  drivers/net/wireless/marvell/mwifiex/main.h        |    1 +
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    3 +-
>  drivers/net/wireless/mediatek/mt76/mac80211.c      |   11 +-
>  drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   18 +-
>  drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   13 +
>  drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |   17 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   11 +-
>  .../net/wireless/mediatek/mt76/mt7915/coredump.c   |    7 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    6 +
>  drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    7 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    2 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   47 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    2 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    5 +
>  .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |    4 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   50 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |    2 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |    5 +
>  .../net/wireless/mediatek/mt76/mt7925/pci_mac.c    |    6 +-
>  drivers/net/wireless/mediatek/mt76/mt792x.h        |    2 +
>  drivers/net/wireless/mediatek/mt76/mt792x_mac.c    |    6 +-
>  .../net/wireless/mediatek/mt76/mt7996/coredump.c   |    7 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/init.c   |    6 +
>  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   46 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/pci.c    |    9 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |    8 +-
>  drivers/net/wireless/mediatek/mt76/tx.c            |    7 +-
>  drivers/net/wireless/mediatek/mt76/usb.c           |   16 +-
>  drivers/net/wireless/realtek/rtl8xxxu/core.c       |   16 +-
>  drivers/net/wireless/realtek/rtw88/debug.c         |    5 +
>  drivers/net/wireless/realtek/rtw88/sdio.c          |   12 +
>  drivers/net/wireless/silabs/wfx/bh.c               |    6 +-
>  drivers/net/wireless/silabs/wfx/bus_sdio.c         |    1 +
>  drivers/net/wireless/silabs/wfx/main.c             |   36 +-
>  drivers/nvdimm/pmem.c                              |    6 +-
>  drivers/nvme/host/apple.c                          |    1 -
>  drivers/nvme/host/core.c                           |    1 -
>  drivers/nvme/host/fabrics.c                        |   30 +-
>  drivers/nvme/host/ioctl.c                          |    2 +-
>  drivers/nvme/host/pr.c                             |  130 ++-
>  drivers/nvme/host/tcp.c                            |   10 +-
>  drivers/nvme/target/admin-cmd.c                    |    7 +-
>  drivers/nvme/target/configfs.c                     |   24 +-
>  drivers/nvme/target/core.c                         |   23 +-
>  drivers/nvme/target/fabrics-cmd-auth.c             |    9 +-
>  drivers/nvme/target/fabrics-cmd.c                  |    3 +-
>  drivers/nvme/target/fc.c                           |   15 +-
>  drivers/nvme/target/io-cmd-bdev.c                  |   29 +-
>  drivers/nvme/target/loop.c                         |    2 -
>  drivers/nvme/target/nvmet.h                        |    8 +
>  drivers/nvme/target/rdma.c                         |   26 +-
>  drivers/nvme/target/tcp.c                          |    7 +-
>  drivers/nvme/target/zns.c                          |   12 +-
>  drivers/nvmem/layouts/onie-tlv.c                   |    1 +
>  drivers/nvmem/layouts/sl28vpd.c                    |    1 +
>  drivers/opp/of.c                                   |    2 +-
>  drivers/pci/controller/dwc/pci-dra7xx.c            |   22 +-
>  drivers/pci/controller/dwc/pcie-qcom.c             |   90 +-
>  drivers/pci/controller/pci-aardvark.c              |   31 +-
>  drivers/pci/controller/pci-xgene.c                 |   11 +-
>  drivers/pci/endpoint/functions/pci-epf-vntb.c      |    8 +-
>  drivers/pci/iov.c                                  |   25 -
>  drivers/pci/p2pdma.c                               |   10 +-
>  drivers/pci/pci-label.c                            |   92 +-
>  drivers/pci/pci.h                                  |    4 -
>  drivers/pci/pcie/aer.c                             |   25 +-
>  drivers/pci/probe.c                                |   15 +-
>  drivers/pci/quirks.c                               |    2 +-
>  drivers/pci/xen-pcifront.c                         |    5 +-
>  drivers/perf/cxl_pmu.c                             |  100 +-
>  drivers/perf/dwc_pcie_pmu.c                        |   11 +-
>  drivers/perf/marvell_cn10k_tad_pmu.c               |    1 +
>  drivers/phy/cadence/phy-cadence-sierra.c           |   11 +-
>  drivers/phy/freescale/phy-fsl-samsung-hdmi.c       |  581 ++++++----
>  drivers/phy/hisilicon/phy-hi3670-pcie.c            |    4 +-
>  drivers/phy/rockchip/phy-rockchip-usbdp.c          |  287 +++--
>  drivers/pinctrl/mediatek/pinctrl-mt7629.c          |    2 +-
>  drivers/pinctrl/nuvoton/pinctrl-ma35.c             |    8 +-
>  drivers/pinctrl/pinctrl-amd.c                      |   47 +-
>  drivers/pinctrl/sprd/pinctrl-sprd.c                |    3 +
>  drivers/pinctrl/stm32/Kconfig                      |    6 +-
>  drivers/pinctrl/stm32/pinctrl-stm32.c              |   16 +-
>  drivers/pinctrl/stm32/pinctrl-stm32.h              |   18 +-
>  drivers/pinctrl/stm32/pinctrl-stm32mp257.c         |   11 +-
>  drivers/pinctrl/sunplus/Kconfig                    |    8 +-
>  drivers/platform/chrome/cros_ec_proto.c            |   32 +-
>  drivers/platform/chrome/cros_ec_proto_test.c       |  158 ++-
>  drivers/platform/chrome/cros_ec_typec.c            |   10 +
>  drivers/platform/cznic/turris-omnia-mcu-gpio.c     |   31 +-
>  drivers/platform/olpc/olpc-ec.c                    |    2 +-
>  drivers/platform/x86/amd/pmc/pmc.c                 |    9 +-
>  drivers/platform/x86/asus-wmi.c                    |   32 +
>  drivers/platform/x86/gpd-pocket-fan.c              |    9 +-
>  .../platform/x86/hp/hp-bioscfg/int-attributes.c    |    7 +-
>  .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |    2 +-
>  .../platform/x86/hp/hp-bioscfg/spmobj-attributes.c |    7 +
>  drivers/platform/x86/hp/hp-wmi.c                   |   24 +-
>  drivers/platform/x86/ibm_rtl.c                     |    8 +-
>  drivers/platform/x86/ideapad-laptop.c              |   12 +-
>  drivers/platform/x86/intel/telemetry/core.c        |    4 +
>  drivers/platform/x86/msi-ec.c                      |    9 +
>  drivers/pmdomain/imx/scu-pd.c                      |   10 +-
>  drivers/power/supply/ab8500_bmdata.c               |    2 +-
>  drivers/power/supply/ab8500_btemp.c                |   28 +-
>  drivers/power/supply/ab8500_chargalg.c             |    9 +-
>  drivers/power/supply/ab8500_charger.c              |  402 ++++++-
>  drivers/power/supply/ab8500_fg.c                   |   27 +-
>  drivers/power/supply/bq24190_charger.c             |   53 +-
>  drivers/power/supply/bq2515x_charger.c             |   15 +-
>  drivers/power/supply/generic-adc-battery.c         |    3 +
>  drivers/power/supply/gpio-charger.c                |    5 +-
>  drivers/power/supply/mm8013.c                      |    1 +
>  drivers/power/supply/qcom_battmgr.c                |   26 +-
>  drivers/pwm/pwm-lp3943.c                           |    3 +
>  drivers/pwm/pwm-mtk-disp.c                         |    4 +-
>  drivers/pwm/pwm-renesas-tpu.c                      |   23 +-
>  drivers/regulator/ab8500.c                         |  159 ++-
>  drivers/regulator/fixed.c                          |    4 +
>  drivers/regulator/irq_helpers.c                    |   38 +-
>  drivers/regulator/mp886x.c                         |   13 +-
>  drivers/regulator/qcom-rpmh-regulator.c            |    2 +-
>  drivers/remoteproc/imx_dsp_rproc.c                 |   58 +-
>  drivers/remoteproc/imx_rproc.c                     |   18 +-
>  drivers/remoteproc/qcom_q6v5_adsp.c                |    2 +-
>  drivers/remoteproc/remoteproc_core.c               |    3 +
>  drivers/remoteproc/xlnx_r5_remoteproc.c            |    8 +-
>  drivers/rpmsg/mtk_rpmsg.c                          |    1 +
>  drivers/rpmsg/virtio_rpmsg_bus.c                   |  118 +-
>  drivers/rtc/Kconfig                                |   21 +
>  drivers/rtc/class.c                                |    8 +-
>  drivers/rtc/rtc-abx80x.c                           |   58 +-
>  drivers/rtc/rtc-bd70528.c                          |    5 +
>  drivers/rtc/rtc-ds1685.c                           |   20 +-
>  drivers/rtc/rtc-ftrtc010.c                         |   85 +-
>  drivers/rtc/rtc-mpfs.c                             |    4 +-
>  drivers/rtc/rtc-s35390a.c                          |  147 ++-
>  drivers/s390/block/dasd_genhd.c                    |    1 -
>  drivers/s390/block/scm_blk.c                       |    1 -
>  drivers/s390/virtio/virtio_ccw.c                   |    6 +-
>  drivers/scsi/ch.c                                  |    2 +-
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c        |    4 +-
>  drivers/scsi/device_handler/scsi_dh_rdac.c         |   10 +-
>  drivers/scsi/elx/libefc/efclib.c                   |    2 +
>  drivers/scsi/hisi_sas/hisi_sas.h                   |    3 +
>  drivers/scsi/hisi_sas/hisi_sas_main.c              |   43 +
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    4 +
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |    4 +
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   13 +-
>  drivers/scsi/libsas/sas_expander.c                 |    5 +-
>  drivers/scsi/libsas/sas_task.c                     |    2 +-
>  drivers/scsi/mpi3mr/mpi3mr.h                       |    2 +-
>  drivers/scsi/mpi3mr/mpi3mr_app.c                   |   47 +-
>  drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   17 +-
>  drivers/scsi/mpi3mr/mpi3mr_os.c                    |  161 ++-
>  drivers/scsi/mpi3mr/mpi3mr_transport.c             |   18 +-
>  drivers/scsi/pm8001/pm8001_defs.h                  |   98 ++
>  drivers/scsi/pm8001/pm8001_hwi.c                   |    2 +-
>  drivers/scsi/pm8001/pm8001_hwi.h                   |    4 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c                   |    2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.h                   |  100 +-
>  drivers/scsi/scsi_debug.c                          |  415 ++++++-
>  drivers/scsi/scsi_lib.c                            |    7 +-
>  drivers/scsi/scsi_lib_test.c                       |   25 +-
>  drivers/scsi/scsi_scan.c                           |    8 +-
>  drivers/scsi/scsi_transport_spi.c                  |    2 +-
>  drivers/scsi/sd.c                                  |   20 +-
>  drivers/scsi/ses.c                                 |    8 +-
>  drivers/scsi/st.c                                  |   75 ++
>  drivers/soc/qcom/apr.c                             |   50 +-
>  drivers/soc/qcom/pmic_glink.c                      |   69 +-
>  drivers/soc/qcom/pmic_pdcharger_ulog.c             |    2 +-
>  drivers/soc/tegra/flowctrl.c                       |    7 +-
>  drivers/soundwire/intel_auxdevice.c                |    2 +-
>  drivers/spi/spi-bcm63xx-hsspi.c                    |    1 +
>  drivers/spi/spi-fsl-spi.c                          |   22 +-
>  drivers/spi/spi-mtk-nor.c                          |    1 +
>  drivers/spi/spi-mxic.c                             |    8 +-
>  drivers/spi/spi-omap2-mcspi.c                      |  242 ++--
>  drivers/spi/spi-rspi.c                             |   49 +-
>  drivers/spi/spi-sh-msiof.c                         |   50 +-
>  drivers/spi/spi-sun4i.c                            |   56 +-
>  drivers/spi/spi-tegra114.c                         |   49 +
>  drivers/spi/spi.c                                  |    2 +-
>  drivers/spmi/spmi-pmic-arb.c                       |    2 +-
>  drivers/staging/iio/adc/ad7816.c                   |   33 +-
>  drivers/staging/octeon/ethernet-tx.c               |    2 +-
>  drivers/staging/rtl8723bs/core/rtw_mlme.c          |   13 -
>  drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |    9 +-
>  drivers/staging/rtl8723bs/core/rtw_pwrctrl.c       |    6 +-
>  drivers/staging/rtl8723bs/core/rtw_recv.c          |   53 +-
>  drivers/staging/rtl8723bs/core/rtw_sta_mgt.c       |    4 +-
>  drivers/staging/rtl8723bs/hal/hal_com.c            |   20 +-
>  drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c  |   16 +-
>  drivers/staging/rtl8723bs/hal/sdio_halinit.c       |    8 +-
>  drivers/staging/rtl8723bs/include/drv_types.h      |   41 -
>  drivers/staging/rtl8723bs/include/recv_osdep.h     |    4 -
>  drivers/staging/rtl8723bs/os_dep/os_intfs.c        |   21 +-
>  drivers/staging/rtl8723bs/os_dep/recv_linux.c      |   44 -
>  drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |   45 +-
>  drivers/staging/sm750fb/sm750.c                    |   10 +-
>  drivers/target/target_core_device.c                |   87 +-
>  drivers/target/target_core_stat.c                  |   69 +-
>  drivers/target/target_core_tpg.c                   |   10 +-
>  drivers/thermal/gov_power_allocator.c              |    7 +-
>  drivers/thermal/sprd_thermal.c                     |    6 +
>  drivers/thermal/thermal_trace.h                    |    4 +-
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c        |   10 +-
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |    4 +
>  drivers/tty/serial/8250/8250_aspeed_vuart.c        |    2 +-
>  drivers/tty/serial/8250/8250_bcm2835aux.c          |    2 +-
>  drivers/tty/serial/8250/8250_bcm7271.c             |    2 +-
>  drivers/tty/serial/8250/8250_dw.c                  |    2 +-
>  drivers/tty/serial/8250/8250_em.c                  |    2 +-
>  drivers/tty/serial/8250/8250_fsl.c                 |    2 +-
>  drivers/tty/serial/8250/8250_ingenic.c             |    2 +-
>  drivers/tty/serial/8250/8250_ioc3.c                |    2 +-
>  drivers/tty/serial/8250/8250_lpc18xx.c             |    2 +-
>  drivers/tty/serial/8250/8250_mtk.c                 |    2 +-
>  drivers/tty/serial/8250/8250_of.c                  |    2 +-
>  drivers/tty/serial/8250/8250_omap.c                |    2 +-
>  drivers/tty/serial/8250/8250_platform.c            |    2 +-
>  drivers/tty/serial/8250/8250_pxa.c                 |    2 +-
>  drivers/tty/serial/8250/8250_tegra.c               |    2 +-
>  drivers/tty/serial/8250/8250_uniphier.c            |   12 +-
>  drivers/tty/serial/Kconfig                         |    1 +
>  drivers/tty/serial/altera_jtaguart.c               |    2 +-
>  drivers/tty/serial/altera_uart.c                   |    2 +-
>  drivers/tty/serial/amba-pl011.c                    |    2 +-
>  drivers/tty/serial/ar933x_uart.c                   |    2 +-
>  drivers/tty/serial/atmel_serial.c                  |    2 +-
>  drivers/tty/serial/bcm63xx_uart.c                  |    2 +-
>  drivers/tty/serial/clps711x.c                      |    2 +-
>  drivers/tty/serial/cpm_uart.c                      |    2 +-
>  drivers/tty/serial/digicolor-usart.c               |    2 +-
>  drivers/tty/serial/esp32_acm.c                     |    2 +-
>  drivers/tty/serial/esp32_uart.c                    |    2 +-
>  drivers/tty/serial/fsl_linflexuart.c               |    2 +-
>  drivers/tty/serial/fsl_lpuart.c                    |    2 +-
>  drivers/tty/serial/imx.c                           |    2 +-
>  drivers/tty/serial/lantiq.c                        |    2 +-
>  drivers/tty/serial/liteuart.c                      |    2 +-
>  drivers/tty/serial/lpc32xx_hs.c                    |    2 +-
>  drivers/tty/serial/ma35d1_serial.c                 |    4 +-
>  drivers/tty/serial/max310x.c                       |  185 ++-
>  drivers/tty/serial/mcf.c                           |    2 +-
>  drivers/tty/serial/meson_uart.c                    |    2 +-
>  drivers/tty/serial/milbeaut_usio.c                 |    2 +-
>  drivers/tty/serial/mpc52xx_uart.c                  |    2 +-
>  drivers/tty/serial/msm_serial.c                    |    2 +-
>  drivers/tty/serial/mxs-auart.c                     |    2 +-
>  drivers/tty/serial/omap-serial.c                   |    2 +-
>  drivers/tty/serial/owl-uart.c                      |    2 +-
>  drivers/tty/serial/pic32_uart.c                    |    2 +-
>  drivers/tty/serial/pmac_zilog.c                    |    3 +-
>  drivers/tty/serial/qcom_geni_serial.c              |    2 +-
>  drivers/tty/serial/rda-uart.c                      |    2 +-
>  drivers/tty/serial/sa1100.c                        |    2 +-
>  drivers/tty/serial/samsung_tty.c                   |    2 +-
>  drivers/tty/serial/sccnxp.c                        |    2 +-
>  drivers/tty/serial/serial-tegra.c                  |    2 +-
>  drivers/tty/serial/serial_txx9.c                   |   55 +-
>  drivers/tty/serial/sh-sci.c                        |    2 +-
>  drivers/tty/serial/sifive.c                        |    4 +-
>  drivers/tty/serial/sprd_serial.c                   |    2 +-
>  drivers/tty/serial/st-asc.c                        |    2 +-
>  drivers/tty/serial/stm32-usart.c                   |    2 +-
>  drivers/tty/serial/sunhv.c                         |    2 +-
>  drivers/tty/serial/sunplus-uart.c                  |    2 +-
>  drivers/tty/serial/sunsab.c                        |    2 +-
>  drivers/tty/serial/sunsu.c                         |    2 +-
>  drivers/tty/serial/sunzilog.c                      |    2 +-
>  drivers/tty/serial/tegra-tcu.c                     |    2 +-
>  drivers/tty/serial/timbuart.c                      |    2 +-
>  drivers/tty/serial/uartlite.c                      |    2 +-
>  drivers/tty/serial/ucc_uart.c                      |    2 +-
>  drivers/tty/serial/xilinx_uartps.c                 |    2 +-
>  drivers/ufs/core/ufshcd.c                          |   14 +-
>  drivers/ufs/host/ufs-mediatek.c                    |   16 +-
>  drivers/usb/gadget/composite.c                     |    2 +-
>  drivers/usb/gadget/function/f_mass_storage.c       |    7 +-
>  drivers/usb/gadget/udc/dummy_hcd.c                 |    4 +-
>  drivers/usb/host/pci-quirks.c                      |    1 +
>  drivers/usb/host/xhci-dbgtty.c                     |    2 +
>  drivers/usb/image/microtek.c                       |    1 +
>  drivers/usb/mon/mon_main.c                         |    3 +
>  drivers/usb/musb/da8xx.c                           |    8 +-
>  drivers/usb/storage/alauda.c                       |   95 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |    9 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |    9 +-
>  drivers/vfio/cdx/main.c                            |   10 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |   10 +-
>  drivers/vfio/pci/vfio_pci_core.c                   |    1 +
>  drivers/vfio/platform/vfio_platform_common.c       |   10 +-
>  drivers/vhost/scsi.c                               |   31 +-
>  drivers/vhost/vringh.c                             |    4 +-
>  drivers/video/fbdev/core/fbcon.c                   |   57 +
>  drivers/video/fbdev/gxt4500.c                      |    1 +
>  drivers/video/fbdev/kyro/fbdev.c                   |   19 +-
>  drivers/virtio/virtio.c                            |    2 +
>  drivers/virtio/virtio_pci_modern.c                 |   12 +-
>  fs/backing-file.c                                  |   28 +
>  fs/btrfs/accessors.c                               |  123 +-
>  fs/btrfs/accessors.h                               |   37 -
>  fs/btrfs/block-group.c                             |    6 +-
>  fs/btrfs/ctree.c                                   |   51 +-
>  fs/btrfs/ctree.h                                   |    2 +-
>  fs/btrfs/defrag.c                                  |    2 +-
>  fs/btrfs/disk-io.c                                 |    6 +-
>  fs/btrfs/extent-io-tree.h                          |    7 -
>  fs/btrfs/extent-tree.c                             |    3 +-
>  fs/btrfs/free-space-cache.c                        |   10 +
>  fs/btrfs/inode.c                                   |   74 +-
>  fs/btrfs/ioctl.c                                   |   11 +
>  fs/btrfs/messages.c                                |    5 +-
>  fs/btrfs/qgroup.c                                  |    4 +-
>  fs/btrfs/raid56.c                                  |   11 +-
>  fs/btrfs/relocation.c                              |    3 -
>  fs/btrfs/tests/inode-tests.c                       |   12 +-
>  fs/btrfs/tree-mod-log.c                            |   13 +-
>  fs/btrfs/verity.c                                  |   31 +-
>  fs/btrfs/zoned.c                                   |    8 +-
>  fs/ceph/addr.c                                     |  102 +-
>  fs/ceph/inode.c                                    |    2 +-
>  fs/ceph/mds_client.c                               |    2 +
>  fs/ceph/mds_client.h                               |    3 +
>  fs/ceph/super.c                                    |   29 +-
>  fs/ceph/super.h                                    |    1 -
>  fs/dcache.c                                        |    2 +
>  fs/debugfs/file.c                                  |   81 +-
>  fs/dlm/config.c                                    |   30 +-
>  fs/dlm/dlm_internal.h                              |    5 +
>  fs/dlm/lock.c                                      |   18 +-
>  fs/dlm/lock.h                                      |    4 +-
>  fs/eventpoll.c                                     |   18 +-
>  fs/ext2/file.c                                     |    7 +
>  fs/f2fs/node.c                                     |    4 +-
>  fs/f2fs/super.c                                    |   33 +-
>  fs/fs-writeback.c                                  |   17 +-
>  fs/fs_pin.c                                        |   15 +-
>  fs/fuse/file.c                                     |    5 +-
>  fs/gfs2/bmap.c                                     |    2 +-
>  fs/gfs2/inode.c                                    |    2 +-
>  fs/hfs/btree.c                                     |    7 +-
>  fs/hfsplus/btree.c                                 |    7 +-
>  fs/hugetlbfs/inode.c                               |    6 +
>  fs/isofs/dir.c                                     |    4 +-
>  fs/isofs/isofs.h                                   |   11 +-
>  fs/isofs/joliet.c                                  |   27 +-
>  fs/isofs/namei.c                                   |    3 +-
>  fs/kernfs/dir.c                                    |   12 +-
>  fs/kernfs/symlink.c                                |   17 +-
>  fs/minix/inode.c                                   |   16 +
>  fs/minix/minix.h                                   |    9 +
>  fs/minix/namei.c                                   |   27 +-
>  fs/netfs/internal.h                                |   32 +-
>  fs/nfs/dir.c                                       |   13 +-
>  fs/nfs/filelayout/filelayout.c                     |    5 +-
>  fs/nfs/flexfilelayout/flexfilelayout.c             |   81 +-
>  fs/nfs/fs_context.c                                |    1 +
>  fs/nfs/internal.h                                  |   31 +
>  fs/nfs/nfs3proc.c                                  |    8 +
>  fs/nfs/nfs4client.c                                |    7 +-
>  fs/nfs/nfs4proc.c                                  |    5 +
>  fs/nfs/nfs4xdr.c                                   |    3 +-
>  fs/nfs/pnfs.c                                      |   12 +-
>  fs/nfs/proc.c                                      |    8 +
>  fs/nilfs2/namei.c                                  |    8 +-
>  fs/nilfs2/recovery.c                               |   17 +
>  fs/ntfs3/attrib.c                                  |   10 +-
>  fs/ntfs3/file.c                                    |   35 +-
>  fs/ntfs3/frecord.c                                 |  180 +--
>  fs/ntfs3/fsntfs.c                                  |  130 +--
>  fs/ntfs3/inode.c                                   |   13 +-
>  fs/ntfs3/ntfs_fs.h                                 |   20 +-
>  fs/ntfs3/xattr.c                                   |    8 +-
>  fs/ocfs2/cluster/heartbeat.c                       |   52 +-
>  fs/ocfs2/cluster/tcp.c                             |    8 +-
>  fs/ocfs2/dlmglue.c                                 |   29 +-
>  fs/ocfs2/dlmglue.h                                 |    5 +-
>  fs/ocfs2/export.c                                  |   10 +-
>  fs/ocfs2/inode.c                                   |    5 +-
>  fs/ocfs2/move_extents.c                            |   62 +-
>  fs/ocfs2/namei.c                                   |    6 +-
>  fs/ocfs2/quota_local.c                             |   24 +
>  fs/ocfs2/xattr.c                                   |  266 ++++-
>  fs/ocfs2/xattr.h                                   |   12 +-
>  fs/overlayfs/readdir.c                             |   41 +-
>  fs/overlayfs/util.c                                |    2 +-
>  fs/proc/generic.c                                  |    4 +
>  fs/proc/kcore.c                                    |    8 +-
>  fs/pstore/ram.c                                    |    1 +
>  fs/pstore/ram_core.c                               |    6 +
>  fs/quota/dquot.c                                   |   10 +-
>  fs/smb/client/cifspdu.h                            |   95 +-
>  fs/smb/client/smb2ops.c                            |    8 +-
>  fs/smb/client/smb2pdu.c                            |   14 +-
>  fs/smb/client/smb2pdu.h                            |   69 --
>  fs/smb/common/smb2pdu.h                            |  230 +++-
>  fs/smb/server/Kconfig                              |    1 +
>  fs/smb/server/oplock.c                             |    8 +-
>  fs/smb/server/smb2ops.c                            |    6 +-
>  fs/smb/server/smb2pdu.c                            |  192 ++--
>  fs/smb/server/smb2pdu.h                            |   58 -
>  fs/smb/server/smb_common.c                         |    4 +-
>  fs/smb/server/smb_common.h                         |   75 +-
>  fs/smb/server/smbacl.c                             |   41 +-
>  fs/smb/server/vfs_cache.c                          |   15 +-
>  fs/splice.c                                        |   43 +-
>  fs/stat.c                                          |    4 +-
>  fs/userfaultfd.c                                   |   12 +-
>  fs/xattr.c                                         |    2 +-
>  fs/xfs/libxfs/xfs_bmap.c                           |   14 +-
>  fs/xfs/libxfs/xfs_bmap.h                           |   10 +-
>  include/acpi/acpi_bus.h                            |    9 +-
>  include/acpi/acpi_drivers.h                        |    9 +-
>  include/kvm/arm_vgic.h                             |    1 +
>  include/linux/acpi.h                               |   24 +-
>  include/linux/blk-mq.h                             |    7 +-
>  include/linux/bpf.h                                |    9 +-
>  include/linux/clk-provider.h                       |   22 +-
>  include/linux/efi.h                                |   21 +-
>  include/linux/etherdevice.h                        |   28 +
>  include/linux/firewire.h                           |    1 -
>  include/linux/fortify-string.h                     |    2 -
>  include/linux/if_bridge.h                          |   77 +-
>  include/linux/mfd/da9150/core.h                    |    1 +
>  include/linux/mm.h                                 |   53 +-
>  include/linux/mm_types.h                           |   13 +-
>  include/linux/mmap_lock.h                          |   16 +
>  include/linux/mtd/spinand.h                        |    2 +-
>  include/linux/pm_wakeirq.h                         |    6 +
>  include/linux/pm_wakeup.h                          |   17 +
>  include/linux/quotaops.h                           |    5 +
>  include/linux/shmem_fs.h                           |   15 +-
>  include/linux/skbuff.h                             |   90 +-
>  include/linux/slab.h                               |   60 +-
>  include/linux/soc/ti/k3-ringacc.h                  |   31 +-
>  include/linux/sunrpc/svc_rdma.h                    |    2 +-
>  include/linux/userfaultfd_k.h                      |    8 +
>  include/linux/wait.h                               |    6 +-
>  include/linux/watch_queue.h                        |    6 +-
>  include/net/bluetooth/bluetooth.h                  |    4 +-
>  include/net/bluetooth/hci_sync.h                   |    1 +
>  include/net/bluetooth/l2cap.h                      |    3 +-
>  include/net/cfg80211.h                             |   12 +-
>  include/net/cipso_ipv4.h                           |   11 +-
>  include/net/inet_frag.h                            |    9 +
>  include/net/ip.h                                   |    2 +-
>  include/net/ip_vs.h                                |   50 +-
>  include/net/netfilter/nf_conntrack_seqadj.h        |    1 +
>  include/net/netlabel.h                             |   11 +-
>  include/net/seg6_hmac.h                            |    3 +-
>  include/net/sock.h                                 |    8 +-
>  include/net/switchdev.h                            |    1 +
>  include/scsi/libsas.h                              |    8 +
>  include/scsi/scsi_cmnd.h                           |    7 +
>  include/scsi/scsi_common.h                         |   31 +-
>  include/scsi/scsi_device.h                         |   37 +-
>  include/scsi/scsi_proto.h                          |   65 +-
>  include/scsi/scsi_sense.h                          |  950 +++++++++++++++
>  include/sound/control.h                            |    4 +-
>  include/sound/core.h                               |   25 +-
>  include/sound/pcm.h                                |    2 +
>  include/sound/pcm_oss.h                            |    1 +
>  include/sound/soc-component.h                      |    2 +-
>  include/sound/ump.h                                |    6 +
>  include/target/target_core_base.h                  |   20 +-
>  include/trace/events/iocost.h                      |    7 +-
>  include/trace/events/power.h                       |    3 +
>  include/uapi/linux/firewire-cdev.h                 |    4 +-
>  include/uapi/linux/iommufd.h                       |    2 +-
>  include/uapi/sound/asequencer.h                    |   12 +-
>  include/ufs/ufshcd.h                               |    8 +
>  init/main.c                                        |    8 +-
>  io_uring/eventfd.c                                 |    1 +
>  kernel/bpf/bpf_iter.c                              |   24 +-
>  kernel/bpf/bpf_lsm.c                               |    4 +-
>  kernel/bpf/btf.c                                   |   27 +-
>  kernel/bpf/core.c                                  |   54 +-
>  kernel/bpf/helpers.c                               |    1 +
>  kernel/bpf/offload.c                               |   25 +-
>  kernel/bpf/syscall.c                               |  144 ++-
>  kernel/bpf/task_iter.c                             |    6 +-
>  kernel/bpf/verifier.c                              |   42 +-
>  kernel/cgroup/cpuset.c                             |   45 +-
>  kernel/debug/kdb/kdb_io.c                          |    1 -
>  kernel/debug/kdb/kdb_main.c                        |    6 +-
>  kernel/debug/kdb/kdb_private.h                     |    3 +-
>  kernel/fork.c                                      |   44 +-
>  kernel/kcov.c                                      |   35 +-
>  kernel/kexec_file.c                                |    4 +-
>  kernel/module/tracking.c                           |    2 +-
>  kernel/nsproxy.c                                   |    2 +-
>  kernel/profile.c                                   |    2 +-
>  kernel/rcu/rcutorture.c                            |    2 +-
>  kernel/rcu/tree.c                                  |    2 +-
>  kernel/rcu/tree.h                                  |    3 +-
>  kernel/rcu/tree_nocb.h                             |   60 +-
>  kernel/reboot.c                                    |    4 +-
>  kernel/resource_kunit.c                            |    3 +
>  kernel/signal.c                                    |    5 +-
>  kernel/time/timeconv.c                             |    6 +-
>  kernel/time/timer.c                                |    2 +
>  kernel/trace/bpf_trace.c                           |   80 +-
>  kernel/trace/trace_btf.c                           |    3 +
>  kernel/trace/trace_events_hist.c                   |   25 +-
>  kernel/ucount.c                                    |    7 +-
>  kernel/watch_queue.c                               |    2 +-
>  lib/Kconfig.debug                                  |    1 -
>  lib/bitmap-str.c                                   |   24 +-
>  lib/decompress_unlz4.c                             |    4 +
>  lib/kobject.c                                      |    2 +-
>  lib/maple_tree.c                                   |   65 +-
>  lib/test_hmm.c                                     |    2 +
>  mm/cma.c                                           |    2 +
>  mm/damon/reclaim.c                                 |    4 +-
>  mm/filemap.c                                       |   31 +-
>  mm/gup_test.c                                      |   17 +-
>  mm/huge_memory.c                                   |   11 +-
>  mm/hugetlb.c                                       |   55 +-
>  mm/internal.h                                      |    4 +-
>  mm/khugepaged.c                                    |   51 +-
>  mm/ksm.c                                           |   40 +-
>  mm/madvise.c                                       |    4 +
>  mm/memcontrol.c                                    |    2 +
>  mm/memory-tiers.c                                  |   29 +-
>  mm/memory.c                                        |  106 +-
>  mm/memory_hotplug.c                                |    6 +-
>  mm/mmap.c                                          |    3 +-
>  mm/mmap_lock.c                                     |   39 +
>  mm/mremap.c                                        |   32 +-
>  mm/oom_kill.c                                      |   22 +-
>  mm/page_alloc.c                                    |    4 +-
>  mm/rmap.c                                          |   20 +-
>  mm/shmem.c                                         |   40 +-
>  mm/slab_common.c                                   |   18 +-
>  mm/truncate.c                                      |    7 +-
>  mm/userfaultfd.c                                   |   14 +-
>  mm/util.c                                          |   13 +
>  mm/vma.c                                           |   68 +-
>  net/9p/trans_xen.c                                 |    4 +-
>  net/bluetooth/6lowpan.c                            |    3 +-
>  net/bluetooth/hci_core.c                           |    4 +-
>  net/bluetooth/hci_event.c                          |   58 +-
>  net/bluetooth/hci_sync.c                           |   47 +-
>  net/bluetooth/iso.c                                |    3 +
>  net/bluetooth/l2cap_core.c                         |   24 +
>  net/bluetooth/mgmt.c                               |  115 +-
>  net/bluetooth/msft.c                               |    6 +
>  net/bpf/test_run.c                                 |  171 ++-
>  net/bridge/br_mdb.c                                |   16 +-
>  net/bridge/br_multicast.c                          |   14 +-
>  net/bridge/br_netlink.c                            |    2 +-
>  net/bridge/br_private.h                            |   12 +
>  net/bridge/br_stp.c                                |    4 +-
>  net/bridge/br_stp_bpdu.c                           |    2 +-
>  net/bridge/br_switchdev.c                          |   23 +-
>  net/bridge/br_vlan.c                               |    7 +-
>  net/bridge/br_vlan_options.c                       |    2 +-
>  net/ceph/messenger_v1.c                            |    8 +-
>  net/ceph/osdmap.c                                  |    2 +-
>  net/core/bpf_sk_storage.c                          |    7 +
>  net/core/dev.c                                     |   20 +-
>  net/core/filter.c                                  |   58 +-
>  net/core/gro.c                                     |    5 +-
>  net/core/lwtunnel.c                                |    6 +
>  net/core/selftests.c                               |    2 +-
>  net/core/skbuff.c                                  |   11 +-
>  net/core/sock.c                                    |    1 +
>  net/dcb/dcbnl.c                                    |    2 +
>  net/devlink/region.c                               |    5 +
>  net/ipv4/cipso_ipv4.c                              |   16 +-
>  net/ipv4/devinet.c                                 |   35 +-
>  net/ipv4/gre_offload.c                             |    2 +-
>  net/ipv4/inet_fragment.c                           |   66 +-
>  net/ipv4/ip_fragment.c                             |   13 +-
>  net/ipv4/ip_output.c                               |   15 +-
>  net/ipv4/ip_tunnel.c                               |   14 +-
>  net/ipv4/ipmr.c                                    |    5 +
>  net/ipv4/tcp.c                                     |   14 +-
>  net/ipv4/tcp_bic.c                                 |   14 +-
>  net/ipv4/tcp_cubic.c                               |   14 +-
>  net/ipv4/tcp_hybla.c                               |   16 +-
>  net/ipv4/tcp_ipv4.c                                |   10 +-
>  net/ipv4/tcp_metrics.c                             |   20 +-
>  net/ipv4/tcp_offload.c                             |   12 +-
>  net/ipv6/calipso.c                                 |    6 +-
>  net/ipv6/exthdrs.c                                 |    2 +-
>  net/ipv6/netfilter/nf_conntrack_reasm.c            |   15 +-
>  net/ipv6/reassembly.c                              |   13 +-
>  net/ipv6/route.c                                   |   20 +-
>  net/ipv6/seg6_hmac.c                               |    5 +-
>  net/ipv6/seg6_local.c                              |    6 +-
>  net/ipv6/sit.c                                     |    4 +-
>  net/l2tp/l2tp_core.c                               |   51 +-
>  net/l2tp/l2tp_core.h                               |    6 +-
>  net/l2tp/l2tp_debugfs.c                            |    4 +-
>  net/l2tp/l2tp_netlink.c                            |   11 +-
>  net/l2tp/l2tp_ppp.c                                |    8 +-
>  net/mac80211/cfg.c                                 |   49 +-
>  net/mac80211/debugfs.c                             |    2 +-
>  net/mac80211/ieee80211_i.h                         |    3 +-
>  net/mac80211/main.c                                |    2 +
>  net/mac80211/mesh.c                                |    3 +-
>  net/mac80211/mesh_pathtbl.c                        |   17 +-
>  net/mac80211/rx.c                                  |    1 +
>  net/mac80211/tx.c                                  |  223 ++--
>  net/mctp/route.c                                   |   10 +-
>  net/mptcp/options.c                                |    9 +-
>  net/netfilter/ipvs/ip_vs_conn.c                    |    8 +-
>  net/netfilter/ipvs/ip_vs_ctl.c                     |   38 +-
>  net/netfilter/ipvs/ip_vs_dh.c                      |   16 +-
>  net/netfilter/ipvs/ip_vs_fo.c                      |    2 +-
>  net/netfilter/ipvs/ip_vs_lblc.c                    |    4 +-
>  net/netfilter/ipvs/ip_vs_lblcr.c                   |    8 +-
>  net/netfilter/ipvs/ip_vs_lc.c                      |    2 +-
>  net/netfilter/ipvs/ip_vs_mh.c                      |    2 +-
>  net/netfilter/ipvs/ip_vs_nq.c                      |    2 +-
>  net/netfilter/ipvs/ip_vs_ovf.c                     |    2 +-
>  net/netfilter/ipvs/ip_vs_rr.c                      |    2 +-
>  net/netfilter/ipvs/ip_vs_sed.c                     |    4 +-
>  net/netfilter/ipvs/ip_vs_sh.c                      |    2 +-
>  net/netfilter/ipvs/ip_vs_sync.c                    |   23 +-
>  net/netfilter/ipvs/ip_vs_twos.c                    |    4 +-
>  net/netfilter/ipvs/ip_vs_wlc.c                     |    4 +-
>  net/netfilter/ipvs/ip_vs_wrr.c                     |    2 +-
>  net/netfilter/nf_conntrack_core.c                  |    5 +
>  net/netfilter/nf_conntrack_seqadj.c                |   17 +
>  net/netfilter/nf_flow_table_ip.c                   |   30 +-
>  net/netfilter/nf_synproxy_core.c                   |    4 +-
>  net/netfilter/nft_compat.c                         |   15 +
>  net/netfilter/xt_dccp.c                            |    2 +-
>  net/netlabel/netlabel_kapi.c                       |   24 +-
>  net/netlink/af_netlink.c                           |   12 +-
>  net/openvswitch/actions.c                          |    9 +
>  net/openvswitch/vport-internal_dev.c               |    8 +-
>  net/rds/af_rds.c                                   |   29 +-
>  net/rds/bind.c                                     |    4 +-
>  net/rds/ib_sysctl.c                                |    2 +-
>  net/rds/rdma_transport.c                           |    3 +
>  net/rds/rds.h                                      |    3 +
>  net/rds/recv.c                                     |   11 +-
>  net/rds/send.c                                     |    9 +-
>  net/rds/sysctl.c                                   |    2 +-
>  net/rds/tcp.c                                      |    5 +-
>  net/rose/af_rose.c                                 |   56 +-
>  net/rose/rose_link.c                               |    7 +-
>  net/rose/rose_loopback.c                           |    7 +-
>  net/rose/rose_route.c                              |   65 +-
>  net/rxrpc/rxperf.c                                 |   12 -
>  net/sched/act_api.c                                |   24 +-
>  net/sched/sch_etf.c                                |    1 +
>  net/sched/sch_gred.c                               |   16 +-
>  net/sched/sch_taprio.c                             |    6 +-
>  net/sctp/ipv6.c                                    |    6 +-
>  net/sctp/sm_make_chunk.c                           |   24 +-
>  net/sctp/sm_statefuns.c                            |    2 +-
>  net/smc/smc_pnet.c                                 |   29 +-
>  net/sunrpc/xprtsock.c                              |   34 +-
>  net/switchdev/switchdev.c                          |    2 +-
>  net/tipc/bearer.c                                  |    4 +
>  net/tipc/node.c                                    |    2 +-
>  net/tls/tls_device.c                               |   21 +-
>  net/tls/tls_main.c                                 |    4 +-
>  net/wireless/nl80211.c                             |    6 +-
>  net/wireless/reg.c                                 |   41 +-
>  net/wireless/sme.c                                 |   38 +-
>  scripts/Makefile.vmlinux_o                         |    2 +-
>  scripts/checkkconfigsymbols.py                     |    2 +-
>  scripts/checkpatch.pl                              |    2 +
>  scripts/clang-tools/run-clang-tools.py             |    1 +
>  scripts/gdb/linux/radixtree.py                     |  203 +++-
>  scripts/gdb/linux/stackdepot.py                    |    2 +-
>  scripts/kconfig/conf.c                             |   19 +-
>  scripts/kconfig/symbol.c                           |   39 +-
>  scripts/kconfig/tests/conftest.py                  |    9 +-
>  .../kconfig/tests/randconfig_probability/Kconfig   |   12 +
>  .../tests/randconfig_probability/__init__.py       |  130 +++
>  scripts/kconfig/tests/savedefconfig_range/Kconfig  |   60 +
>  .../kconfig/tests/savedefconfig_range/__init__.py  |    8 +
>  scripts/kconfig/tests/savedefconfig_range/config   |    7 +
>  .../tests/savedefconfig_range/expected_defconfig   |    0
>  scripts/make_fit.py                                |    3 +-
>  security/apparmor/apparmorfs.c                     |   21 +-
>  security/apparmor/domain.c                         |    9 +-
>  security/apparmor/file.c                           |   23 +-
>  security/apparmor/include/file.h                   |    5 +-
>  security/apparmor/include/lib.h                    |    1 +
>  security/apparmor/include/match.h                  |   19 +-
>  security/apparmor/include/policy.h                 |   27 +-
>  security/apparmor/label.c                          |   14 +-
>  security/apparmor/lib.c                            |   23 +
>  security/apparmor/lsm.c                            |   19 +
>  security/apparmor/match.c                          |  158 ++-
>  security/apparmor/net.c                            |    1 +
>  security/apparmor/policy.c                         |    3 +
>  security/apparmor/policy_compat.c                  |    6 +-
>  security/apparmor/policy_ns.c                      |    6 +-
>  security/apparmor/policy_unpack.c                  |   57 +-
>  security/integrity/ima/ima_template.c              |    5 +
>  security/ipe/audit.c                               |    8 -
>  security/security.c                                |    3 +-
>  security/selinux/netlabel.c                        |    5 +-
>  security/smack/smack_lsm.c                         |   14 +-
>  sound/core/control.c                               |   12 +-
>  sound/core/control_compat.c                        |   21 +-
>  sound/core/control_led.c                           |   74 +-
>  sound/core/ctljack.c                               |    1 +
>  sound/core/info.c                                  |    3 +-
>  sound/core/init.c                                  |   33 +-
>  sound/core/jack.c                                  |   11 +-
>  sound/core/misc.c                                  |   27 +
>  sound/core/oss/mixer_oss.c                         |   36 +-
>  sound/core/oss/pcm_oss.c                           |   12 +
>  sound/core/pcm.c                                   |   13 +-
>  sound/core/pcm_compat.c                            |    4 +-
>  sound/core/pcm_lib.c                               |   16 +-
>  sound/core/pcm_local.h                             |    6 +
>  sound/core/pcm_native.c                            |  122 +-
>  sound/core/rawmidi.c                               |    3 +
>  sound/core/seq/seq_clientmgr.c                     |   12 +-
>  sound/core/seq/seq_compat.c                        |   15 +-
>  sound/core/seq/seq_system.c                        |    9 +-
>  sound/core/seq/seq_system.h                        |   31 +-
>  sound/core/seq/seq_ump_client.c                    |   45 +-
>  sound/core/timer.c                                 |    1 +
>  sound/core/ump.c                                   |   80 +-
>  sound/core/vmaster.c                               |   10 +-
>  sound/drivers/aloop.c                              |   17 +-
>  sound/drivers/pcmtest.c                            |   28 +-
>  sound/hda/hdac_bus.c                               |    9 +-
>  sound/pci/hda/hda_codec.c                          |    2 +-
>  sound/pci/hda/hda_controller.h                     |    4 -
>  sound/pci/hda/hda_intel.c                          |   91 +-
>  sound/pci/hda/hda_jack.c                           |    9 +-
>  sound/pci/oxygen/oxygen.c                          |   12 +-
>  sound/pci/oxygen/oxygen_mixer.c                    |   60 +-
>  sound/pci/oxygen/oxygen_pcm.c                      |   54 +-
>  sound/pci/oxygen/xonar_cs43xx.c                    |    3 +-
>  sound/pci/oxygen/xonar_dg_mixer.c                  |   33 +-
>  sound/pci/oxygen/xonar_pcm179x.c                   |   18 +-
>  sound/pci/oxygen/xonar_wm87x6.c                    |   31 +-
>  sound/pci/via82xx.c                                |   11 +-
>  sound/sh/aica.c                                    |    2 +-
>  sound/soc/amd/acp-es8336.c                         |    5 +-
>  sound/soc/amd/acp/acp-platform.c                   |    2 +-
>  sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c      |   14 +-
>  sound/soc/amd/ps/ps-pdm-dma.c                      |    2 +-
>  sound/soc/amd/ps/ps-sdw-dma.c                      |    2 +-
>  sound/soc/amd/raven/acp3x-pcm-dma.c                |    4 +-
>  sound/soc/amd/renoir/acp3x-pdm-dma.c               |    2 +-
>  sound/soc/amd/vangogh/acp5x-pcm-dma.c              |    2 +-
>  sound/soc/amd/yc/acp6x-pdm-dma.c                   |    2 +-
>  sound/soc/atmel/atmel-i2s.c                        |   43 +-
>  sound/soc/atmel/atmel-pcm-pdc.c                    |    2 +
>  sound/soc/codecs/adau17x1.c                        |    4 +-
>  sound/soc/codecs/ak4642.c                          |    3 +-
>  sound/soc/codecs/cs42l56.c                         |    1 -
>  sound/soc/codecs/da732x.c                          |    2 +-
>  sound/soc/codecs/es8316.c                          |    4 +-
>  sound/soc/codecs/es8326.c                          |   26 +-
>  sound/soc/codecs/mt6359-accdet.c                   |   50 +-
>  sound/soc/codecs/nau8540.c                         |    4 +-
>  sound/soc/codecs/rt1011.c                          |    4 +-
>  sound/soc/codecs/rt1016.c                          |    4 +-
>  sound/soc/codecs/rt1305.c                          |    4 +-
>  sound/soc/codecs/rt1308.c                          |    4 +-
>  sound/soc/codecs/rt1318.c                          |    3 +-
>  sound/soc/codecs/rt5616.c                          |    3 +-
>  sound/soc/codecs/rt5659.c                          |   10 +-
>  sound/soc/codecs/rt5660.c                          |    4 +-
>  sound/soc/codecs/rt5665.c                          |    4 +-
>  sound/soc/codecs/rt5682-sdw.c                      |    3 +-
>  sound/soc/codecs/rt711-sdca-sdw.c                  |    6 +-
>  sound/soc/codecs/rt711-sdw.c                       |    8 +-
>  sound/soc/codecs/rt712-sdca-sdw.c                  |    6 +-
>  sound/soc/codecs/rt712-sdca.c                      |    5 +-
>  sound/soc/codecs/rt722-sdca-sdw.c                  |    6 +-
>  sound/soc/codecs/sta32x.c                          |   20 +-
>  sound/soc/codecs/sta350.c                          |   20 +-
>  sound/soc/codecs/tlv320adc3xxx.c                   |    2 +-
>  sound/soc/codecs/tlv320aic32x4-clk.c               |   68 +-
>  sound/soc/codecs/tlv320aic32x4-i2c.c               |   21 +-
>  sound/soc/codecs/tlv320aic32x4-spi.c               |   25 +-
>  sound/soc/codecs/tlv320aic32x4.c                   |  273 ++---
>  sound/soc/codecs/tlv320aic32x4.h                   |    6 +-
>  sound/soc/codecs/wcd-mbhc-v2.c                     |    8 +-
>  sound/soc/codecs/wcd937x.c                         |   44 +-
>  sound/soc/codecs/wm5100.c                          |    2 +-
>  sound/soc/codecs/wm8510.c                          |    2 +-
>  sound/soc/codecs/wm8737.c                          |    8 +-
>  sound/soc/codecs/wm8750.c                          |    2 +-
>  sound/soc/codecs/wm8955.c                          |    2 +-
>  sound/soc/codecs/wm8983.c                          |    2 +-
>  sound/soc/codecs/wm8985.c                          |    2 +-
>  sound/soc/codecs/wm8990.c                          |   10 +-
>  sound/soc/codecs/wm8991.c                          |   10 +-
>  sound/soc/codecs/wm8994.c                          |  159 +--
>  sound/soc/codecs/wm8994.h                          |    2 +
>  sound/soc/codecs/wm_hubs.c                         |    2 +-
>  sound/soc/codecs/wsa883x.c                         |    8 +-
>  sound/soc/codecs/wsa884x.c                         |    8 +-
>  sound/soc/dwc/dwc-i2s.c                            |    6 +-
>  sound/soc/fsl/fsl_asrc.c                           |    8 +-
>  sound/soc/fsl/fsl_asrc_dma.c                       |    5 +
>  sound/soc/fsl/imx-pcm-rpmsg.c                      |    2 +-
>  sound/soc/intel/atom/sst-atom-controls.c           |   38 +-
>  sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   36 +-
>  sound/soc/intel/avs/pcm.c                          |    2 +
>  sound/soc/intel/avs/utils.c                        |    6 +-
>  sound/soc/mediatek/common/mtk-afe-fe-dai.c         |    8 +-
>  sound/soc/mediatek/common/mtk-soundcard-driver.c   |   23 +-
>  sound/soc/mediatek/mt2701/mt2701-cs42448.c         |   20 +-
>  sound/soc/mediatek/mt2701/mt2701-wm8960.c          |    6 +-
>  sound/soc/mediatek/mt6797/mt6797-afe-clk.c         |   14 +-
>  sound/soc/mediatek/mt6797/mt6797-mt6351.c          |   24 +-
>  sound/soc/mediatek/mt7986/mt7986-wm8960.c          |    6 +-
>  sound/soc/mediatek/mt8173/mt8173-max98090.c        |    6 +-
>  sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |    6 +-
>  sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |   10 +-
>  sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   10 +-
>  sound/soc/mediatek/mt8183/mt8183-afe-clk.c         |   22 +-
>  sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |   34 +-
>  .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |   34 +-
>  sound/soc/mediatek/mt8186/mt8186-afe-clk.c         |   95 +-
>  sound/soc/mediatek/mt8186/mt8186-mt6366.c          |   86 +-
>  sound/soc/mediatek/mt8188/mt8188-afe-clk.c         |  104 +-
>  sound/soc/mediatek/mt8188/mt8188-afe-pcm.c         |   24 +-
>  sound/soc/mediatek/mt8188/mt8188-mt6359.c          |   61 +-
>  sound/soc/mediatek/mt8192/mt8192-afe-clk.c         |  139 ++-
>  sound/soc/mediatek/mt8192/mt8192-afe-gpio.c        |   90 +-
>  sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |    6 +-
>  sound/soc/mediatek/mt8192/mt8192-dai-adda.c        |   44 +-
>  sound/soc/mediatek/mt8192/mt8192-dai-i2s.c         |   20 +-
>  sound/soc/mediatek/mt8192/mt8192-dai-tdm.c         |   18 +-
>  .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |  115 +-
>  sound/soc/mediatek/mt8195/mt8195-afe-clk.c         |   77 +-
>  sound/soc/mediatek/mt8195/mt8195-afe-pcm.c         |  102 +-
>  sound/soc/mediatek/mt8195/mt8195-dai-etdm.c        |   99 +-
>  sound/soc/mediatek/mt8195/mt8195-mt6359.c          |   60 +-
>  sound/soc/mediatek/mt8365/mt8365-afe-pcm.c         |    7 +-
>  sound/soc/mediatek/mt8365/mt8365-dai-i2s.c         |    2 +-
>  sound/soc/mediatek/mt8365/mt8365-mt6357.c          |   14 +-
>  sound/soc/qcom/qdsp6/q6apm.c                       |    1 +
>  sound/soc/qcom/sdm845.c                            |   26 +-
>  sound/soc/rockchip/rk3288_hdmi_analog.c            |   48 +-
>  sound/soc/rockchip/rockchip_i2s.c                  |    4 +-
>  sound/soc/samsung/midas_wm1811.c                   |   14 +-
>  sound/soc/soc-ac97.c                               |    4 +-
>  sound/soc/soc-card-test.c                          |    7 +-
>  sound/soc/soc-component.c                          |    2 +-
>  sound/soc/soc-link.c                               |   10 +-
>  sound/soc/soc-ops.c                                |   10 +-
>  sound/soc/soc-topology-test.c                      |    8 +-
>  sound/soc/sof/imx/imx-common.c                     |    1 +
>  sound/soc/xilinx/xlnx_formatter_pcm.c              |   18 +-
>  sound/usb/6fire/control.c                          |    7 +
>  sound/usb/caiaq/device.c                           |    9 +-
>  sound/usb/caiaq/device.h                           |    6 +-
>  sound/usb/caiaq/input.c                            |   29 +-
>  sound/usb/caiaq/midi.c                             |    2 +
>  sound/usb/line6/capture.c                          |    3 +-
>  sound/usb/line6/pcm.c                              |    8 +-
>  sound/usb/mixer.c                                  |  151 ++-
>  sound/usb/mixer.h                                  |    6 +-
>  sound/usb/mixer_quirks.c                           |    2 +-
>  sound/usb/mixer_us16x08.c                          |   19 +-
>  sound/usb/quirks-table.h                           |    2 +
>  sound/usb/usx2y/us122l.c                           |    2 +-
>  sound/virtio/virtio_pcm.h                          |    2 +
>  sound/virtio/virtio_pcm_msg.c                      |   19 +
>  sound/virtio/virtio_pcm_ops.c                      |    1 +
>  tools/bpf/bpftool/common.c                         |   40 +
>  tools/bpf/bpftool/gen.c                            |   91 +-
>  tools/bpf/bpftool/link.c                           |   18 +-
>  tools/bpf/bpftool/main.c                           |   24 +-
>  tools/bpf/bpftool/main.h                           |    1 +
>  tools/bpf/bpftool/map.c                            |  101 +-
>  tools/bpf/bpftool/prog.c                           |    2 +-
>  tools/bpf/bpftool/tracelog.c                       |    2 +-
>  tools/cgroup/iocost_monitor.py                     |    7 +-
>  tools/cgroup/memcg_shrinker.py                     |    2 +-
>  tools/hv/vmbus_bufring.c                           |    6 -
>  tools/include/linux/types.h                        |    5 +
>  tools/include/nolibc/stdlib.h                      |    8 +-
>  tools/include/nolibc/types.h                       |    2 +-
>  tools/lib/bpf/btf.c                                |  300 +++--
>  tools/lib/bpf/btf.h                                |    3 +
>  tools/lib/bpf/btf_dump.c                           |    2 +-
>  tools/lib/bpf/btf_relocate.c                       |    2 +-
>  tools/lib/bpf/libbpf.c                             |   67 +-
>  tools/lib/bpf/libbpf.map                           |    2 +
>  tools/lib/bpf/libbpf_internal.h                    |   39 +
>  tools/lib/bpf/relo_core.c                          |    2 +-
>  tools/lib/bpf/skel_internal.h                      |   64 +-
>  tools/lib/perf/mmap.c                              |    2 +-
>  tools/perf/Documentation/perf-c2c.txt              |    2 +-
>  tools/perf/Makefile.perf                           |    2 +-
>  tools/perf/arch/arm/tests/dwarf-unwind.c           |    3 +-
>  tools/perf/arch/arm/util/unwind-libdw.c            |    2 +-
>  tools/perf/arch/arm64/tests/dwarf-unwind.c         |    3 +-
>  tools/perf/arch/arm64/util/unwind-libdw.c          |    2 +-
>  tools/perf/arch/csky/util/unwind-libdw.c           |    2 +-
>  tools/perf/arch/loongarch/util/unwind-libdw.c      |    2 +-
>  tools/perf/arch/powerpc/tests/dwarf-unwind.c       |    3 +-
>  tools/perf/arch/powerpc/util/unwind-libdw.c        |    2 +-
>  tools/perf/arch/riscv/util/unwind-libdw.c          |    2 +-
>  tools/perf/arch/s390/util/unwind-libdw.c           |    2 +-
>  tools/perf/arch/x86/tests/dwarf-unwind.c           |    2 +-
>  tools/perf/arch/x86/util/unwind-libdw.c            |    2 +-
>  tools/perf/builtin-buildid-list.c                  |    5 +-
>  tools/perf/builtin-c2c.c                           |   16 +-
>  tools/perf/builtin-kallsyms.c                      |   21 +-
>  tools/perf/builtin-record.c                        |    4 +-
>  tools/perf/builtin-script.c                        |   10 +-
>  tools/perf/builtin-top.c                           |    8 +-
>  tools/perf/builtin-trace.c                         |  149 ++-
>  .../arch/x86/sierraforest/uncore-cache.json        |    5 +
>  .../arch/x86/sierraforest/uncore-interconnect.json |    2 +
>  .../arch/x86/skylakex/uncore-interconnect.json     |    6 +
>  .../arch/x86/snowridgex/uncore-cache.json          |   68 ++
>  .../arch/x86/snowridgex/uncore-interconnect.json   |   10 +
>  tools/perf/tests/builtin-test.c                    |   15 +-
>  tools/perf/tests/code-reading.c                    |   30 +-
>  tools/perf/tests/dlfilter-test.c                   |   51 +-
>  tools/perf/tests/dwarf-unwind.c                    |   53 +-
>  tools/perf/tests/mmap-basic.c                      |    3 +
>  tools/perf/tests/mmap-thread-lookup.c              |    6 +-
>  tools/perf/tests/openat-syscall-tp-fields.c        |    4 +-
>  tools/perf/tests/parse-no-sample-id-all.c          |    6 +-
>  tools/perf/tests/perf-record.c                     |    2 +
>  tools/perf/tests/perf-time-to-tsc.c                |    2 +
>  tools/perf/tests/sample-parsing.c                  |  167 ++-
>  tools/perf/tests/sigtrap.c                         |   20 +-
>  tools/perf/tests/sw-clock.c                        |    3 +
>  tools/perf/tests/switch-tracking.c                 |   14 +-
>  tools/perf/tests/symbols.c                         |  104 +-
>  tools/perf/ui/browsers/annotate-data.c             |    2 +-
>  tools/perf/ui/tui/setup.c                          |    2 +-
>  tools/perf/util/Build                              |    4 +-
>  tools/perf/util/annotate-data.c                    |   21 +-
>  tools/perf/util/arm-spe.c                          |   24 +-
>  .../perf/util/arm64-frame-pointer-unwind-support.c |   29 +-
>  tools/perf/util/auxtrace.c                         |   15 +-
>  tools/perf/util/bpf-filter.c                       |   30 +-
>  tools/perf/util/bpf-utils.h                        |    5 +
>  tools/perf/util/btf.c                              |   27 +
>  tools/perf/util/btf.h                              |   10 +
>  tools/perf/util/cs-etm.c                           |   60 +-
>  tools/perf/util/debug.c                            |   77 +-
>  tools/perf/util/debug.h                            |    1 +
>  tools/perf/util/env.c                              |    1 +
>  tools/perf/util/evsel.c                            |   41 +-
>  tools/perf/util/header.c                           |   18 +-
>  tools/perf/util/intel-bts.c                        |    4 +-
>  tools/perf/util/intel-pt.c                         |  136 ++-
>  tools/perf/util/jitdump.c                          |  139 ++-
>  tools/perf/util/machine.c                          |   63 +-
>  tools/perf/util/machine.h                          |    5 +-
>  tools/perf/util/mem-events.c                       |    2 +-
>  tools/perf/util/mmap.c                             |    3 +-
>  tools/perf/util/print_insn.h                       |    1 +
>  tools/perf/util/probe-event.c                      |    5 +-
>  tools/perf/util/python.c                           |   65 +-
>  tools/perf/util/s390-cpumsf.c                      |    6 +-
>  tools/perf/util/sample.c                           |   43 +
>  tools/perf/util/sample.h                           |    9 +-
>  .../util/scripting-engines/trace-event-python.c    |   29 +-
>  tools/perf/util/session.c                          |   94 +-
>  tools/perf/util/symbol.c                           |    4 +
>  tools/perf/util/synthetic-events.c                 |   24 +-
>  tools/perf/util/thread_map.c                       |   26 +
>  tools/perf/util/thread_map.h                       |    1 +
>  tools/perf/util/unwind-libdw.c                     |    9 +-
>  tools/perf/util/unwind-libunwind-local.c           |   12 +-
>  .../x86_energy_perf_policy.c                       |   18 +-
>  tools/sched_ext/scx_flatcg.bpf.c                   |    2 +-
>  tools/testing/cxl/test/cxl.c                       |    8 +-
>  tools/testing/selftests/Makefile                   |    4 +-
>  tools/testing/selftests/alsa/mixer-test.c          |    2 +
>  tools/testing/selftests/alsa/test-pcmtest-driver.c |   27 +-
>  tools/testing/selftests/arm64/signal/Makefile      |    4 +-
>  tools/testing/selftests/bpf/network_helpers.c      |   46 +-
>  .../bpf/prog_tests/cgroup_hierarchical_stats.c     |    4 +-
>  tools/testing/selftests/bpf/prog_tests/empty_skb.c |   59 +-
>  tools/testing/selftests/bpf/prog_tests/missed.c    |    8 +-
>  .../bpf/prog_tests/prog_tests_framework.c          |   10 +-
>  tools/testing/selftests/bpf/prog_tests/sockopt.c   |    4 +-
>  .../testing/selftests/bpf/prog_tests/test_tunnel.c |   13 +-
>  .../selftests/bpf/prog_tests/uprobe_multi_test.c   |    4 +-
>  .../testing/selftests/bpf/progs/cpumask_success.c  |    6 +
>  tools/testing/selftests/bpf/progs/empty_skb.c      |    7 +
>  .../selftests/bpf/progs/verifier_vfs_accept.c      |   18 +
>  .../selftests/bpf/progs/verifier_vfs_reject.c      |   15 +
>  tools/testing/selftests/bpf/unpriv_helpers.c       |  101 +-
>  tools/testing/selftests/breakpoints/Makefile       |    4 +-
>  tools/testing/selftests/cgroup/test_core.c         |   51 +-
>  tools/testing/selftests/cgroup/test_cpu.c          |    7 +-
>  tools/testing/selftests/cgroup/test_cpuset.c       |    7 +-
>  tools/testing/selftests/cgroup/test_freezer.c      |    7 +-
>  tools/testing/selftests/cgroup/test_kill.c         |    7 +-
>  tools/testing/selftests/cgroup/test_kmem.c         |    7 +-
>  tools/testing/selftests/cgroup/test_memcontrol.c   |    7 +-
>  tools/testing/selftests/cgroup/test_pids.c         |    2 +-
>  tools/testing/selftests/cgroup/test_zswap.c        |  238 +++-
>  .../selftests/clone3/clone3_clear_sighand.c        |    6 +-
>  .../filesystems/epoll/epoll_wakeup_test.c          |   32 +-
>  tools/testing/selftests/ftrace/ftracetest          |    2 +-
>  tools/testing/selftests/ipc/Makefile               |    8 +-
>  tools/testing/selftests/mm/vm_util.h               |    1 +
>  tools/testing/selftests/net/lib/csum.c             |   67 +-
>  .../selftests/net/netfilter/conntrack_vrf.sh       |   25 +-
>  tools/testing/selftests/net/tcp_mmap.c             |    6 +-
>  tools/testing/selftests/net/txtimestamp.c          |   23 +-
>  tools/testing/selftests/prctl/Makefile             |    4 +-
>  tools/testing/selftests/sched_ext/hotplug.c        |   34 +-
>  tools/testing/selftests/sparc64/Makefile           |    4 +-
>  .../selftests/thermal/intel/power_floor/Makefile   |   12 +-
>  .../selftests/thermal/intel/workload_hint/Makefile |   12 +-
>  .../testing/selftests/timers/clocksource-switch.c  |   23 +-
>  tools/thermal/tmon/tmon.c                          |    2 +-
>  usr/gen_init_cpio.c                                |    1 +
>  1611 files changed, 24531 insertions(+), 11234 deletions(-)
>=20
>=20

--=20

--YDVmP5dpcfwy1+l6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCav3cEAAKCRAw5/Bqldv6
8hNqAJwPHG4dU/WgBoj563Ly328EpT1gzgCfXmxJlE6eK39vYsWYSkpRF+eQk4o=
=THKz
-----END PGP SIGNATURE-----

--YDVmP5dpcfwy1+l6--
