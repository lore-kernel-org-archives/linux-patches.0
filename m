Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B09EDDB1;
	Thu, 13 Jun 2024 11:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278639; cv=none; b=Bx/qMp3XKdol14gFQlVOWOnbSDrl8xHJ6/C7U7jlWyDuoe5an4BjHRdMxEL10+kVbQvzOFSaCVQ1LCqQDJ5+ppXhR/UGt7BNHrUQgI5IYesHyxJ9qb0pFZsfcQx3AfXaqweYTSkioH1+Q4dU4jXFAP9SJiawDyXqtny4ibGzAFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278639; c=relaxed/simple;
	bh=30/WuED1w6pfWgDO2mRQXKfYRimkXBL3C2jecCZ0eVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rcp3SgcEcBj0jQARMnmktHvtR6xc13YAfHQaB4EUrriuIZqSG/OZrt6RNjBRpYQCAficJbeDYmxzTwZd3K77Xx7/25npiPRNgFf+Qc2/lYX3oNdOKSAeK3g95E4/MvyeWXsWfr+sx8HZ9jVrELjMpM796y7vz0ktM7btjFwVL1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLKsNDNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLKsNDNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D5EC2BBFC;
	Thu, 13 Jun 2024 11:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278639;
	bh=30/WuED1w6pfWgDO2mRQXKfYRimkXBL3C2jecCZ0eVk=;
	h=From:To:Cc:Subject:Date:From;
	b=uLKsNDNPUul994puWuZ6AD9auque+nrTZhDxrNHHcFWPOzmIgPWem/e2YqME6jFFu
	 wAwuwmhxh/6VdBcfmRIwoqmhceHgsEHmv8d7QDwhA6OdEdR/+LQ4W35zlmxcCoZYQx
	 3gI4gP2yXWhB1wq8OV6qnCZNP2qliqRRYuNyGO2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 4.19 000/213] 4.19.316-rc1 review
Date: Thu, 13 Jun 2024 13:30:48 +0200
Message-ID: <20240613113227.969123070@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.316-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.316-rc1
X-KernelTest-Deadline: 2024-06-15T11:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.316 release.
There are 213 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.316-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.316-rc1

Sergey Shtylyov <s.shtylyov@omp.ru>
    nfs: fix undefined behavior in nfs_block_bits()

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix crash in AP internal function modify_bitmap()

Baokun Li <libaokun1@huawei.com>
    ext4: fix mb_cache_entry's e_refcnt leak in ext4_xattr_block_cache_find()

Mike Gilbert <floppym@gentoo.org>
    sparc: move struct termio to asm/termios.h

Eric Dumazet <edumazet@google.com>
    net: fix __dst_negative_advice() race

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-specifiers rather than memset() for padding in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Merge identical case statements in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix console handling when editing and tab-completing commands

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-strings rather than '\0' injection in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix buffer overflow during tab-complete

Sam Ravnborg <sam@ravnborg.org>
    sparc64: Fix number of online CPUs

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-S CPU support

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net/9p: fix uninit-value in p9_client_rpc()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: discard table flag update with pending basechain deletion

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject new basechain after table flag update

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: do not compare internal table flags on updates

Ignat Korchagin <ignat@cloudflare.com>
    netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: set dormant flag on hook register failure

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: skip end interval element from gc

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate NFPROTO_* family

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip dead set elements in netlink dump

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: mark newset as dead on transaction abort

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: relax superfluous check on set updates

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: report EOPNOTSUPP on missing set feature

Florian Westphal <fw@strlen.de>
    netfilter: nftables: exthdr: fix 4-byte stack OOB write

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_dynset: fix timeouts later than 23 days

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (for 4.19)

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disable toggling dormant table state more than once

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix table flag updates

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: update table flags from the commit phase

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: double hook unregistration in netns path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: unregister flowtable hooks on netns exit

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix memleak when more than 255 elements expired

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: defer gc run if previous batch is still pending

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: GC transaction race with abort path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: GC transaction race with netns dismantle

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: remove busy mark and gc batch API

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: adapt set backend to use GC transaction API

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: GC transaction API to avoid race with control plane

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: don't skip expired elements during walk

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: fix overlap expiration walk

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: fix null deref on element insertion

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: Switch to node list walk for overlap detection

Phil Sutter <phil@nwl.cc>
    netfilter: nft_set_rbtree: Add missing expired checks

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: allow loose matching of closing element in interval

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: drop map element references from preparation phase

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: rename set element data activation/deactivation functions

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: pass context to nft_set_destroy()

Cai Xinchen <caixinchen1@huawei.com>
    fbdev: savage: Handle err return when savagefb_check_var failed

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-core: hold videodev_lock until dev reg, finishes

Nathan Chancellor <nathan@kernel.org>
    media: mxl5xx: Move xpt structures off stack

Yang Xiwen <forbidden405@outlook.com>
    arm64: dts: hi3798cv200: fix the size of GICR

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix the TX power of RTL8192CU, RTL8723AU

Yu Kuai <yukuai3@huawei.com>
    md/raid5: fix deadlock that raid5d() wait for itself to clear MD_SB_CHANGE_PENDING

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: tegra: Correct Tegra132 I2C alias

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_legacy: make legacy_exit() work again

Qingfang DENG <qingfang.deng@siflower.com.cn>
    neighbour: fix unaligned access to pneigh_entry

Daniel Borkmann <daniel@iogearbox.net>
    vxlan: Fix regression when dropping packets due to invalid src addresses

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free of timer for log writer thread

Jorge Ramirez-Ortiz <jorge@foundries.io>
    mmc: core: Do not force a retune before RPMB switch

Carlos Llamas <cmllamas@google.com>
    binder: fix max_thread type inconsistency

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix loop termination condition in gss_free_in_token_pages()

Dongli Zhang <dongli.zhang@oracle.com>
    genirq/cpuhotplug, x86/vector: Prevent vector leak during CPU offline

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Set lower bound of start tick time

Yue Haibing <yuehaibing@huawei.com>
    ipvlan: Dont Use skb->sk in ipvlan_process_v{4,6}_outbound

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix comparison to constant symbols, 'm', 'n'

Xiaolei Wang <xiaolei.wang@windriver.com>
    net:fec: Add fec_enet_deinit()

Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
    net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM

Andre Edich <andre.edich@microchip.com>
    smsc95xx: use usbnet->driver_priv

Andre Edich <andre.edich@microchip.com>
    smsc95xx: remove redundant function arguments

Roded Zats <rzats@paloaltonetworks.com>
    enic: Validate length of nl attributes in enic_set_vf_port

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    dma-buf/sw-sync: don't enable IRQ from sync_print_obj()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix ns enable/disable possible hang

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Don't mark message DMA mapped when no transfer in it is

Eric Dumazet <edumazet@google.com>
    netfilter: nfnetlink_queue: acquire rcu_read_lock() in instance_destroy_rcu()

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    nfc: nci: Fix kcov check in nci_rx_work()

Wei Fang <wei.fang@nxp.com>
    net: fec: avoid lock evasion when reading pps_enable

Jiri Pirko <jiri@nvidia.com>
    virtio: delete vq in vp_find_vqs_msix() when request_irq() fails

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    arm64: asm-bug: Add .align 2 to the end of __BUG_ENTRY

Aaron Conole <aconole@redhat.com>
    openvswitch: Set the skbuff pkt_type for proper pmtud support.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix shift-out-of-bounds in dctcp_update_alpha().

Sagi Grimberg <sagi@grimberg.me>
    params: lift param_set_uint_minmax to common code

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix memleak in seg6_hmac_init_algo

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix uninit-value in nci_rx_work

Masahiro Yamada <masahiroy@kernel.org>
    x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-api: add locking in cec_release()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-adap: always cancel work in cec_transmit_msg_fh

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for __switch_mm

Shrikanth Hegde <sshegde@linux.ibm.com>
    powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp

Dan Carpenter <dan.carpenter@linaro.org>
    media: stk1160: fix bounds checking in stk1160_copy_video()

Roberto Sassu <roberto.sassu@huawei.com>
    um: Add winch to winch_handlers before registering winch IRQ

Duoming Zhou <duoming@zju.edu.cn>
    um: Fix return value in ubd_init()

Jeykumar Sankaran <jsanka@codeaurora.org>
    drm/msm/dpu: use kms stored hw mdp block

Fenglin Wu <quic_fenglinw@quicinc.com>
    Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation

Arnd Bergmann <arnd@arndb.de>
    Input: ims-pcu - fix printf string overflow

Ian Rogers <irogers@google.com>
    libsubcmd: Fix parse-options memory leak

Wolfram Sang <wsa+renesas@sang-engineering.com>
    serial: sh-sci: protect invalidating RXDMA on shutdown

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Extract sci_dma_rx_chan_invalidate()

Chao Yu <chao@kernel.org>
    f2fs: fix to release node block count in error path of f2fs_new_node_page()

Sahitya Tummala <stummala@codeaurora.org>
    f2fs: add error prints for debugging mount failure

Randy Dunlap <rdunlap@infradead.org>
    extcon: max8997: select IRQ_DOMAIN instead of depending on it

Huai-Yuan Liu <qq810974084@gmail.com>
    ppdev: Add an error check in register_device

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ppdev: Remove usage of the deprecated ida_simple_xx() API

Dan Carpenter <dan.carpenter@linaro.org>
    stm class: Fix a double free in stm_register_device()

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Clear uac pointer when freed.

Michal Simek <michal.simek@amd.com>
    microblaze: Remove early printk call from cpuinfo-static.c

Michal Simek <michal.simek@amd.com>
    microblaze: Remove gcc flag for non existing early_printk.c file

Arnd Bergmann <arnd@arndb.de>
    greybus: arche-ctrl: move device table to its right location

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Fix bitwise types

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Update uart_driver_registered on driver removal

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Lock port->lock when calling uart_handle_cts_change()

Arnd Bergmann <arnd@arndb.de>
    firmware: dmi-id: add a release callback function

Chen Ni <nichen@iscas.ac.cn>
    dmaengine: idma64: Add check for dma_set_max_seg_size

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Get rid of duplicate --group option item

Martin Liška <mliska@suse.cz>
    perf annotate: Add --demangle and --demangle-kernel

Rui Miguel Silva <rmfrfs@gmail.com>
    greybus: lights: check return of get_channel_from_mode

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf probe: Add missing libgen.h header needed for using basename()

Vitalii Bursov <vitaly@bursov.com>
    sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Don't set SD_BALANCE_WAKE on cpuset domain relax

Eric Dumazet <edumazet@google.com>
    af_packet: do not call packet_read_pending() from tpacket_destruct_skb()

Eric Dumazet <edumazet@google.com>
    netrom: fix possible dead-lock in nr_rt_ioctl()

Leon Romanovsky <leonro@nvidia.com>
    RDMA/IPoIB: Fix format truncation compilation errors

Edward Liaw <edliaw@google.com>
    selftests/kcmp: remove unused open mode

Gautam Menghani <gautammenghani201@gmail.com>
    selftests/kcmp: Make the test output consistent and clear

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix gss_free_in_token_pages()

Jan Kara <jack@suse.cz>
    ext4: avoid excessive credit estimate in ext4_tmpfile()

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Fix PUSH instruction in x86 instruction decoder opcode map

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Use complete parentheses in macros

Steven Rostedt <rostedt@goodmis.org>
    ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value

Huai-Yuan Liu <qq810974084@gmail.com>
    drm/arm/malidp: fix a possible null pointer dereference

Randy Dunlap <rdunlap@infradead.org>
    fbdev: sh7760fb: allow modular build

Ricardo Ribalda <ribalda@chromium.org>
    media: radio-shark2: Avoid led_names truncations

Aleksandr Burakov <a.burakov@rosalinux.ru>
    media: ngene: Add dvb_ca_en50221_init return value check

Arnd Bergmann <arnd@arndb.de>
    fbdev: sisfb: hide unused variables

Arnd Bergmann <arnd@arndb.de>
    powerpc/fsl-soc: hide unused const variable

Justin Green <greenjustin@chromium.org>
    drm/mediatek: Add 0 size check to mtk_drm_gem_obj

Arnd Bergmann <arnd@arndb.de>
    fbdev: shmobile: fix snprintf truncation

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    mtd: rawnand: hynix: fixed typo

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix potential index out of bounds in color transformation function

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix invalid unregister error path

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix incorrect unregister order

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: add missing seg6_local_exit

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix overwriting ct original tuple for ICMPv6

Eric Dumazet <edumazet@google.com>
    net: usb: smsc95xx: stop lying about skb->truesize

Breno Leitao <leitao@debian.org>
    af_unix: Fix data races in unix_release_sock/unix_stream_sendmsg

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Locking fixes

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix reboot hang on Mac IIci

Finn Thain <fthain@telegraphics.com.au>
    m68k/mac: Use '030 reset method on SE/30

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Fix spinlock race in kernel thread creation

Eric Dumazet <edumazet@google.com>
    net: usb: sr9700: stop lying about skb->truesize

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwl8k: initialize cmd->addr[] properly

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: qedf: Ensure the copied buf is NUL terminated

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: bfa: Ensure the copied buf is NUL terminated

Guenter Roeck <linux@roeck-us.net>
    Revert "sh: Handle calling csum_partial with misaligned data"

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: ar5523: enable proper endpoint verification

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: carl9170: add a proper sanity check for endpoints

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"

Finn Thain <fthain@telegraphics.com.au>
    macintosh/via-macii, macintosh/adb-iop: Clean up whitespace

Finn Thain <fthain@telegraphics.com.au>
    macintosh/via-macii: Remove BUG_ON assertions

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: populate board data for WCN3990

Su Hui <suhui@nfschina.com>
    wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()

Ard Biesheuvel <ardb@kernel.org>
    x86/purgatory: Switch to the position-independent small code model

Yuri Karpov <YKarpov@ispras.ru>
    scsi: hpsa: Fix allocation size for Scsi_Host private data

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix the failure of adding phy with zero-address to port

Arnd Bergmann <arnd@arndb.de>
    ACPI: disable -Wstringop-truncation

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/alpine-msi: Fix off-by-one in allocation error path

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling interrupts

Christoph Hellwig <hch@lst.de>
    scsi: ufs: add a low-level __ufshcd_issue_tm_cmd helper

Christoph Hellwig <hch@lst.de>
    scsi: ufs: cleanup struct utp_task_req_desc

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing reset bit

Arnd Bergmann <arnd@arndb.de>
    qed: avoid truncating work queue length

Guixiong Wei <weiguixiong@bytedance.com>
    x86/boot: Ignore relocations in .notes sections in walk_relocs() too

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: poll service ready message before failing

NeilBrown <neilb@suse.de>
    nfsd: drop st_mutex before calling move_to_close_lru()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    HSI: omap_ssi_port: Convert to platform remove callback returning void

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    HSI: omap_ssi_core: Convert to platform remove callback returning void

Tzung-Bi Shih <tzungbi@kernel.org>
    power: supply: cros_usbpd: provide ID table for avoiding fallback match

Yu Kuai <yukuai3@huawei.com>
    md: fix resync softlockup when bitmap size is less than array size

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix missing mutex_destroy() at module removal

Ilya Denisyev <dev@elkcl.ru>
    jffs2: prevent xattr node from overflowing the eraseblock

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: fix tracepoint subchannel type field

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp - drop platform ifdef checks

Nathan Chancellor <natechancellor@gmail.com>
    crypto: ccp - Remove forward declaration

Al Viro <viro@zeniv.linux.org.uk>
    parisc: add missing export of __cmpxchg_u8()

Arnd Bergmann <arnd@arndb.de>
    nilfs2: fix out-of-range warning

Brian Kubisiak <brian@kubisiak.com>
    ecryptfs: Fix buffer size for tag 66 packet

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    firmware: raspberrypi: Use correct device for DMA mappings

Aleksandr Mishin <amishin@t-argos.ru>
    crypto: bcm - Fix pointer arithmetic

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: da7219-aad: fix usage of device_get_named_child_node()

Derek Fang <derek.fang@realtek.com>
    ASoC: dt-bindings: rt5645: add cbj sleeve gpio property

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5645: Fix the electric noise due to the CBJ contacts floating

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Set color_mgmt_changed to true on unsuspend

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FN920C04 compositions

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix possible out-of-bounds in gsm0_receive()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential hang in nilfs_detach_log_writer()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix unexpected freezing of nilfs_segctor_sync()

Thorsten Blum <thorsten.blum@toblux.com>
    net: smc91x: Fix m68k kernel compilation for ColdFire CPU

Petr Pavlu <petr.pavlu@suse.com>
    ring-buffer: Fix a race between readers and resize checks

Dan Carpenter <dan.carpenter@linaro.org>
    speakup: Fix sizeof() vs ARRAY_SIZE() bug

Daniel J Blueman <daniel@quora.org>
    x86/tsc: Trust initial offset in architectural TSC-adjust MSRs


-------------

Diffstat:

 Documentation/devicetree/bindings/sound/rt5645.txt |   6 +
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   2 +-
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts     |   4 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi           |   2 +-
 arch/arm64/include/asm/asm-bug.h                   |   1 +
 arch/arm64/kvm/guest.c                             |   1 +
 arch/m68k/kernel/entry.S                           |   4 +-
 arch/m68k/mac/misc.c                               |  46 +-
 arch/microblaze/kernel/Makefile                    |   1 -
 arch/microblaze/kernel/cpu/cpuinfo-static.c        |   2 +-
 arch/parisc/kernel/parisc_ksyms.c                  |   1 +
 arch/powerpc/include/asm/hvcall.h                  |   2 +-
 arch/powerpc/platforms/pseries/lpar.c              |   6 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |   6 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   2 +
 arch/sh/kernel/kprobes.c                           |   7 +-
 arch/sh/lib/checksum.S                             |  67 +--
 arch/sparc/include/asm/smp_64.h                    |   2 -
 arch/sparc/include/uapi/asm/termbits.h             |  10 -
 arch/sparc/include/uapi/asm/termios.h              |   9 +
 arch/sparc/kernel/prom_64.c                        |   4 +-
 arch/sparc/kernel/setup_64.c                       |   1 -
 arch/sparc/kernel/smp_64.c                         |  14 -
 arch/um/drivers/line.c                             |  14 +-
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/include/asm/mmu.h                          |   2 -
 arch/um/include/shared/skas/mm_id.h                |   2 +
 arch/x86/Kconfig.debug                             |   5 +-
 arch/x86/kernel/apic/vector.c                      |   9 +-
 arch/x86/kernel/tsc_sync.c                         |   6 +-
 arch/x86/lib/x86-opcode-map.txt                    |   2 +-
 arch/x86/purgatory/Makefile                        |   3 +-
 arch/x86/tools/relocs.c                            |   9 +
 drivers/acpi/acpica/Makefile                       |   1 +
 drivers/android/binder.c                           |   4 +-
 drivers/ata/pata_legacy.c                          |   8 +-
 drivers/block/null_blk_main.c                      |   3 +
 drivers/char/ppdev.c                               |  21 +-
 drivers/crypto/bcm/spu2.c                          |   2 +-
 drivers/crypto/ccp/sp-platform.c                   |  59 +--
 drivers/crypto/qat/qat_common/adf_aer.c            |  19 +-
 drivers/dma-buf/sync_debug.c                       |   4 +-
 drivers/dma/idma64.c                               |   4 +-
 drivers/extcon/Kconfig                             |   3 +-
 drivers/firmware/dmi-id.c                          |   7 +-
 drivers/firmware/raspberrypi.c                     |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |   5 +
 drivers/gpu/drm/arm/malidp_mw.c                    |   5 +-
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   3 +
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |  12 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   9 +-
 drivers/hsi/controllers/omap_ssi_core.c            |   6 +-
 drivers/hsi/controllers/omap_ssi_port.c            |   6 +-
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/hwtracing/stm/core.c                       |  11 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  12 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   8 +-
 drivers/input/misc/ims-pcu.c                       |   4 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   7 +-
 drivers/irqchip/irq-alpine-msi.c                   |   2 +-
 drivers/macintosh/adb-iop.c                        |  48 +-
 drivers/macintosh/via-macii.c                      | 338 ++++++-------
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/md/raid5.c                                 |  15 +-
 drivers/media/cec/cec-adap.c                       |   3 +-
 drivers/media/cec/cec-api.c                        |   3 +
 drivers/media/dvb-frontends/mxl5xx.c               |  22 +-
 drivers/media/pci/ngene/ngene-core.c               |   4 +-
 drivers/media/radio/radio-shark2.c                 |   2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |  20 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   3 +
 drivers/mmc/core/host.c                            |   3 +-
 drivers/mtd/nand/raw/nand_hynix.c                  |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |  12 +
 drivers/net/ethernet/cortina/gemini.c              |  12 +-
 drivers/net/ethernet/freescale/fec_main.c          |  10 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   9 +-
 drivers/net/ethernet/smsc/smc91x.h                 |   4 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/usb/smsc95xx.c                         | 120 +++--
 drivers/net/usb/sr9700.c                           |  10 +-
 drivers/net/vxlan.c                                |   4 -
 drivers/net/wireless/ath/ar5523/ar5523.c           |  14 +
 drivers/net/wireless/ath/ath10k/core.c             |   3 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   3 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  26 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  32 ++
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  26 +-
 drivers/nvme/target/configfs.c                     |   8 +
 drivers/power/supply/cros_usbpd-charger.c          |  11 +-
 drivers/s390/cio/trace.h                           |   2 +-
 drivers/s390/crypto/ap_bus.c                       |   2 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |   4 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |   3 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   2 +-
 drivers/scsi/ufs/ufs-qcom.h                        |  12 +-
 drivers/scsi/ufs/ufs.h                             |  30 --
 drivers/scsi/ufs/ufshcd.c                          | 185 +++----
 drivers/scsi/ufs/ufshci.h                          |  23 +-
 drivers/spi/spi.c                                  |   4 +
 drivers/staging/greybus/arche-apb-ctrl.c           |   1 +
 drivers/staging/greybus/arche-platform.c           |   9 +-
 drivers/staging/greybus/light.c                    |   8 +-
 drivers/staging/speakup/main.c                     |   2 +-
 drivers/tty/n_gsm.c                                |   8 +-
 drivers/tty/serial/max3100.c                       |  22 +-
 drivers/tty/serial/sh-sci.c                        |  24 +-
 drivers/usb/gadget/function/u_audio.c              |   2 +
 drivers/video/fbdev/Kconfig                        |   4 +-
 drivers/video/fbdev/savage/savagefb_driver.c       |   5 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   2 +-
 drivers/video/fbdev/sis/init301.c                  |   3 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 fs/ecryptfs/keystore.c                             |   4 +-
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/xattr.c                                    |   4 +-
 fs/f2fs/node.c                                     |   2 +-
 fs/f2fs/segment.c                                  |   6 +-
 fs/f2fs/super.c                                    |   4 +-
 fs/jffs2/xattr.c                                   |   3 +
 fs/nfs/internal.h                                  |   4 +-
 fs/nfsd/nfs4state.c                                |  11 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/nilfs2/segment.c                                |  63 ++-
 include/linux/moduleparam.h                        |   2 +
 include/net/dst_ops.h                              |   2 +-
 include/net/neighbour.h                            |   2 +-
 include/net/netfilter/nf_tables.h                  | 132 +++--
 include/net/sock.h                                 |  13 +-
 include/trace/events/asoc.h                        |   2 +
 include/uapi/linux/netfilter/nf_tables.h           |   1 +
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/debug/kdb/kdb_io.c                          |  99 ++--
 kernel/irq/cpuhotplug.c                            |  16 +-
 kernel/params.c                                    |  18 +
 kernel/sched/topology.c                            |   9 +-
 kernel/trace/ring_buffer.c                         |   9 +
 net/9p/client.c                                    |   2 +
 net/ipv4/route.c                                   |  22 +-
 net/ipv4/tcp_dctcp.c                               |  13 +-
 net/ipv6/route.c                                   |  29 +-
 net/ipv6/seg6.c                                    |   5 +-
 net/ipv6/seg6_hmac.c                               |  42 +-
 net/netfilter/nf_tables_api.c                      | 531 +++++++++++++++++----
 net/netfilter/nfnetlink_queue.c                    |   2 +
 net/netfilter/nft_chain_filter.c                   |   3 +
 net/netfilter/nft_compat.c                         |  32 ++
 net/netfilter/nft_dynset.c                         |  24 +-
 net/netfilter/nft_exthdr.c                         |  14 +-
 net/netfilter/nft_flow_offload.c                   |   5 +
 net/netfilter/nft_nat.c                            |   5 +
 net/netfilter/nft_rt.c                             |   5 +
 net/netfilter/nft_set_bitmap.c                     |   5 +-
 net/netfilter/nft_set_hash.c                       | 109 +++--
 net/netfilter/nft_set_rbtree.c                     | 391 ++++++++++++---
 net/netfilter/nft_socket.c                         |   5 +
 net/netfilter/nft_tproxy.c                         |   5 +
 net/netrom/nr_route.c                              |  19 +-
 net/nfc/nci/core.c                                 |  17 +-
 net/openvswitch/actions.c                          |   6 +
 net/openvswitch/flow.c                             |   3 +-
 net/packet/af_packet.c                             |   3 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  12 +-
 net/sunrpc/xprtsock.c                              |  18 -
 net/unix/af_unix.c                                 |   2 +-
 net/wireless/trace.h                               |   4 +-
 net/xfrm/xfrm_policy.c                             |  11 +-
 scripts/kconfig/symbol.c                           |   6 +-
 sound/core/timer.c                                 |  10 +
 sound/soc/codecs/da7219-aad.c                      |   6 +-
 sound/soc/codecs/rt5645.c                          |  25 +
 tools/lib/subcmd/parse-options.c                   |   8 +-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt      |   2 +-
 tools/perf/Documentation/perf-annotate.txt         |   7 +
 tools/perf/builtin-annotate.c                      |   6 +-
 tools/perf/util/probe-event.c                      |   1 +
 tools/testing/selftests/kcmp/kcmp_test.c           |   8 +-
 186 files changed, 2177 insertions(+), 1320 deletions(-)


