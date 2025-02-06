Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB85F1624E0
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738862294; cv=none; b=jcX05MHTW3zk413BaC4tqvMyhBSKFYhrKJvkF3PYm7CoO3lhoN9B0coc/UyJrRQVVw4qDnymA6JwTKxRMt2gWes2PW4NHwVNHjmaB0PD/OrEl6eGGP8AEbNkeom+rF9vukguIeUjTgWTSIjhV4me2I16AWUnYdQct+Pcf3AL83U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738862294; c=relaxed/simple;
	bh=Ztt1OMEMs7J2X/W9TAQwsOuGeknP0/fAC6nwiSCDVBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hE3pPgPI1Si/AG8n71a9pV/4wSIkq0IVBRX7nFPjd77hIT+TMG5DtBE2MgQpMPR5YAWazd2izmemN7mI1Y39wE251qFnJvwoM+2lu3tuivynQ8H9p6ILKta76HSBDN6tJCEVdFkB2TLfbb26igmo91amwso70crhjnlWbHq8QeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lS7mel/I; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lS7mel/I"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2f9bd7c480eso2136572a91.1
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 09:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738862289; x=1739467089; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L84NWqjVHNOYxRiQabFSeQiVuqqIHXE6Rct+8dUjnYs=;
        b=lS7mel/IVUZcJZwePYyZZGJGvz4rAF96sVqTeczqRI8bl891UpUb09KcjP9MJziX9u
         f/+2nDigGwRwgLFJQPL3+tgmtPwX1sJIXpKpfCxwhL9pqShb3OMxiWpmpIVQY2rYe4W3
         ANeIAitA5ENWPLastME5M9UbS5nLDH2JLY19g4/VMFrBALUW95+pPhDkYmAQjGbH9P4V
         9M+kOJJx8fouBt/R4uMxL7u8DijNxCEYW3HNN9KNUCd6xfeJOmtI41ytv1P3vW+ErX4d
         L3i6/Mhk6+Gc0mzcBcNHnIOxV8zMtSlDUV///3ohZUfG7ydRSN1F7+UrHfKmnQSAXgZP
         Fs7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738862289; x=1739467089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L84NWqjVHNOYxRiQabFSeQiVuqqIHXE6Rct+8dUjnYs=;
        b=TU94JoF5RdMmm+hlcD8U+pIV2BM2c9UuED5dQL9aFeNXN0CFK1/PbsmidJx7WaGZuY
         i9mEbTuNxkuvwg+DbFa7j3FZfit7I24+yBV9P5LB4JXTw4c1Y8WIGrDY1hQuxKY079Yf
         FvL8tK4Up3ldnM33erFU7gfwk+Z+74QPkafZRi7Mbz+G7UTy6QAOcCTOuoMowDJgXuQx
         Sbver1xfSHsQRHTfi+8WWzbz+oGdm55Zxm/CU36rpTpWBVlAnP4VjzNCJyJXf+wqVdK4
         2eooiDqrj43bGqk/ogZK+ZbuQo0CNmM4UR+n//b+VF1xFJQomZ5Z/N+GY/DIZE2+CvXh
         PeuA==
X-Forwarded-Encrypted: i=1; AJvYcCVG9qwMNfcYkbq6YrGThrpZ2OdLgCo+qjUxwT3P+i2Ng/OI+pL2j9V4Atr39eeSErxZ+jSRsUI+@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxntw1559Hww2fcSF4vcMHJmN4T5KRXwfEOnJQSuawxXERZToo
	cJFjVNAcO8++TTNTZm8RGGmzxWR0ZrlB8zRcK43SCk4paBXi5zdG1dObk22IcUT09IJuSSaQ7/U
	BOnBsX74up99gM6Uy1JBlG9TsTb4=
X-Gm-Gg: ASbGnctTTtIvpxOvGwe5+A9iY8eMvbrElx+55D3txCjdMzAMDiSkRlJwmLcscVqdVif
	qFxtd8BFYlYhfFkq5ABWwP9NRe4nZFZ2rFRgZXHSm8ZRwmQG+Tkt9Nj5qVHKWRSCsP6rP5/Yl2r
	C52Gk2SzWJQx0=
X-Google-Smtp-Source: AGHT+IG7heTbzjVFxDUUjxQtrqRijoUG7ynxPAhZOMj8sm+zAWKGYhTHEuErcARvJYW9s47xftTt5XQ60N20NYLwBbs=
X-Received: by 2002:a17:90b:4b4a:b0:2ea:7cd5:4ad6 with SMTP id
 98e67ed59e1d1-2f9e0851384mr10111195a91.32.1738862287310; Thu, 06 Feb 2025
 09:18:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206160718.019272260@linuxfoundation.org>
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 6 Feb 2025 18:17:53 +0100
X-Gm-Features: AWEUYZkhAIT110tUfA3nBf3h-nbDukVFaF5igrF9gtPnDdQNk27POdZm9gwtxVE
Message-ID: <CADo9pHhqLiOv4FOSSq-AfYyD7txfoBwuGLkee=Aw5hzS4uBWqg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den tors 6 feb. 2025 kl 17:11 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Feb 2025 16:05:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
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
>     Linux 6.13.2-rc2
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: do proper folio cleanup when run_delalloc_nocow() failed
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: do proper folio cleanup when cow_file_range() failed
>
> Tiezhu Yang <yangtiezhu@loongson.cn>
>     LoongArch: Change 8 to 14 for LOONGARCH_MAX_{BRP,WRP}
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     pwm: Ensure callbacks exist before calling them
>
> Chen Ridong <chenridong@huawei.com>
>     memcg: fix soft lockup in the OOM process
>
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
>
> Aric Cyr <Aric.Cyr@amd.com>
>     drm/amd/display: Add hubp cache reset when powergating
>
> Nathan Chancellor <nathan@kernel.org>
>     s390: Add '-std=3Dgnu11' to decompressor and purgatory CFLAGS
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     ASoC: da7213: Initialize the mutex
>
> Kevin Brodsky <kevin.brodsky@arm.com>
>     selftests/mm: build with -O2
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: output the reason for open_ctree() failure
>
> Yu Kuai <yukuai3@huawei.com>
>     md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime
>
> Shivaprasad G Bhat <sbhat@linux.ibm.com>
>     powerpc/pseries/iommu: Don't unset window if it was never set
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     media: imx-jpeg: Fix potential error pointer dereference in detach_pm=
()
>
> Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
>     staging: media: max96712: fix kernel oops when removing module
>
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: restore invalid MSA timing check for freesync
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: gadget: f_tcm: Don't free command immediately
>
> Calvin Owens <calvin@wbinvd.org>
>     pps: Fix a use-after-free
>
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     media: uvcvideo: Fix double free in error path
>
> Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
>     remoteproc: core: Fix ida_free call while not allocated
>
> Patrisious Haddad <phaddad@nvidia.com>
>     RDMA/mlx5: Fix implicit ODP use after free
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: blackhole only if 1st SYN retrans w/o MPC is accepted
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: handle fastopen disconnect correctly
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
>     mptcp: pm: only set fullmesh for subflow endp
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: consolidate suboption status
>
> Abel Vesa <abel.vesa@linaro.org>
>     clk: qcom: gcc-x1e80100: Do not turn off usb_2 controller GDSC
>
> Kyle Tso <kyletso@google.com>
>     usb: typec: tcpci: Prevent Sink disconnection before vPpsShutdown in =
SPR PPS
>
> Jos Wang <joswang@lenovo.com>
>     usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RE=
SPONSE
>
> Ray Chi <raychi@google.com>
>     usb: dwc3: Skip resume if pm_runtime_set_active() fails
>
> Kyle Tso <kyletso@google.com>
>     usb: dwc3: core: Defer the probe until USB power supply ready
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     usb: dwc3-am62: Fix an OF node leak in phy_syscon_pll_refclk()
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: gadget: f_tcm: Fix Get/SetInterface return value
>
> Sean Rhodes <sean@starlabs.systems>
>     drivers/card_reader/rtsx_usb: Restore interrupt based detection
>
> Michal Pecio <michal.pecio@gmail.com>
>     usb: xhci: Fix NULL pointer dereference on certain command aborts
>
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>     net: usb: rtl8150: enable basic endpoint checking
>
> Lianqin Hu <hulianqin@vivo.com>
>     ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: don't shut down the filesystem for media failures beyond end of =
log
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: release the dquot buf outside of qli_lock
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: don't over-report free space or inodes in statvfs
>
> Long Li <leo.lilong@huawei.com>
>     xfs: fix mount hang during primary superblock recovery failure
>
> Christoph Hellwig <hch@lst.de>
>     xfs: check for dead buffers in xfs_buf_find_insert
>
> Ricardo B. Marliere <rbm@suse.com>
>     ktest.pl: Check kernelrelease return in get_version
>
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
>     selftests/ftrace: Fix to use remount when testing mount GID option
>
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>     selftests/rseq: Fix handling of glibc without rseq support
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: reject mismatching sum of field_len with set ke=
y length
>
> Chuck Lever <chuck.lever@oracle.com>
>     Revert "SUNRPC: Reduce thread wake-up rate when receiving large RPC m=
essages"
>
> Yu Kuai <yukuai3@huawei.com>
>     md/md-bitmap: move bitmap_{start, end}write to md upper layer
>
> Yu Kuai <yukuai3@huawei.com>
>     md/raid5: implement pers->bitmap_sector()
>
> Yu Kuai <yukuai3@huawei.com>
>     md: add a new callback pers->bitmap_sector()
>
> Yu Kuai <yukuai3@huawei.com>
>     md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
>
> Yu Kuai <yukuai3@huawei.com>
>     md/md-bitmap: factor behind write counters out from bitmap_{start/end=
}write()
>
> Daniel Lee <chullee@google.com>
>     f2fs: Introduce linear search for dentries
>
> Liam R. Howlett <Liam.Howlett@Oracle.com>
>     kernel: be more careful about dup_mmap() failures and uprobe register=
ing
>
> Masahiro Yamada <masahiroy@kernel.org>
>     kbuild: fix Clang LTO with CONFIG_OBJTOOL=3Dn
>
> Lin Yujun <linyujun809@huawei.com>
>     hexagon: Fix unbalanced spinlock in die()
>
> Willem de Bruijn <willemb@google.com>
>     hexagon: fix using plain integer as NULL pointer warning in cmpxchg
>
> Masahiro Yamada <masahiroy@kernel.org>
>     kconfig: fix memory leak in sym_warn_unmet_dep()
>
> Masahiro Yamada <masahiroy@kernel.org>
>     kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIS=
T
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     cifs: Fix getting and setting SACLs over SMB1
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     cifs: Validate EAs for WSL reparse points
>
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Fix forked child affinity regression
>
> Daniel Baluta <daniel.baluta@nxp.com>
>     ASoC: amd: acp: Fix possible deadlock
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/register: use atomic_read/write for sq_flags migration
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/msg_ring: don't leave potentially dangling ->tctx pointer
>
> Detlev Casanova <detlev.casanova@collabora.com>
>     ASoC: rockchip: i2s_tdm: Re-add the set_sysclk callback
>
> Palmer Dabbelt <palmer@rivosinc.com>
>     RISC-V: Mark riscv_v_init() as __init
>
> Torsten Hilbrich <torsten.hilbrich@secunet.com>
>     kbuild: Fix signing issue for external modules
>
> Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
>     tools/power turbostat: Fix PMT mmaped file size rounding
>
> Al Viro <viro@zeniv.linux.org.uk>
>     hostfs: fix string handling in __dentry_name()
>
> Masahiro Yamada <masahiroy@kernel.org>
>     genksyms: fix memory leak when the same symbol is read from *.symref =
file
>
> Masahiro Yamada <masahiroy@kernel.org>
>     genksyms: fix memory leak when the same symbol is added from source
>
> Eric Dumazet <edumazet@google.com>
>     net: hsr: fix fill_frame_info() regression vs VLAN packets
>
> Kory Maincent <kory.maincent@bootlin.com>
>     net: sh_eth: Fix missing rtnl lock in suspend/resume path
>
> Kory Maincent <kory.maincent@bootlin.com>
>     net: ravb: Fix missing rtnl lock in suspend/resume path
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>     net: xdp: Disallow attaching device-bound programs in generic mode
>
> Jon Maloy <jmaloy@redhat.com>
>     tcp: correct handling of extreme memory squeeze
>
> Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>     bgmac: reduce max frame size to support just MTU 1500
>
> Michal Luczaj <mhal@rbox.co>
>     vsock: Allow retrying on connect() failure
>
> Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
>     Bluetooth: btnxpuart: Fix glitches seen in dual A2DP streaming
>
> Douglas Anderson <dianders@chromium.org>
>     Bluetooth: btusb: mediatek: Add locks for usb_driver_claim_interface(=
)
>
> Namhyung Kim <namhyung@kernel.org>
>     perf test: Skip syscall enum test if no landlock syscall
>
> Howard Chu <howardchu95@gmail.com>
>     perf trace: Fix runtime error of index out of bounds
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/sclp: Initialize sclp subsystem via arch_cpu_finalize_init()
>
> Cosmin Ratiu <cratiu@nvidia.com>
>     bonding: Correctly support GSO ESP offload
>
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     net: stmmac: Limit FIFO size by hardware capability
>
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     net: stmmac: Limit the number of MTL queues to hardware capability
>
> Gal Pressman <gal@nvidia.com>
>     ethtool: Fix set RXNFC command with symmetric RSS hash
>
> Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
>     ptp: Properly handle compat ioctls
>
> Ian Rogers <irogers@google.com>
>     perf annotate: Use an array for the disassembler preference
>
> Chenyuan Yang <chenyuan0y@gmail.com>
>     net: davicom: fix UAF in dm9000_drv_remove
>
> Shigeru Yoshida <syoshida@redhat.com>
>     vxlan: Fix uninit-value in vxlan_vnifilter_dump()
>
> David Howells <dhowells@redhat.com>
>     rxrpc, afs: Fix peer hash locking vs RCU callback
>
> Jan Stancek <jstancek@redhat.com>
>     selftests: net/{lib,openvswitch}: extend CFLAGS to keep options from =
environment
>
> Jan Stancek <jstancek@redhat.com>
>     selftests: mptcp: extend CFLAGS to keep options from environment
>
> Jakub Kicinski <kuba@kernel.org>
>     net: page_pool: don't try to stash the napi id
>
> Jakub Kicinski <kuba@kernel.org>
>     tools: ynl: c: correct reverse decode of empty attrs
>
> Stanislav Fomichev <sdf@fomichev.me>
>     net/mlx5e: add missing cpu_to_node to kvzalloc_node in mlx5e_open_xdp=
redirect_sq
>
> Jakub Kicinski <kuba@kernel.org>
>     net: netdevsim: try to close UDP port harness races
>
> Eric Dumazet <edumazet@google.com>
>     net: rose: fix timer races against user threads
>
> Paul Fertser <fercerpav@gmail.com>
>     net/ncsi: use dev_set_mac_address() for Get MC MAC Address handling
>
> Vasily Gorbik <gor@linux.ibm.com>
>     s390/mm: Allow large pages for KASAN shadow mapping
>
> Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>     iavf: allow changing VLAN state without calling PF
>
> Mateusz Polchlopek <mateusz.polchlopek@intel.com>
>     ice: remove invalid parameter of equalizer
>
> Przemek Kitszel <przemyslaw.kitszel@intel.com>
>     ice: fix ice_parser_rt::bst_key array size
>
> Marco Leogrande <leogrande@google.com>
>     idpf: convert workqueues to unbound
>
> Manoj Vishwanathan <manojvishy@google.com>
>     idpf: Acquire the lock before accessing the xn->salt
>
> Emil Tantilov <emil.s.tantilov@intel.com>
>     idpf: fix transaction timeouts on reset
>
> Emil Tantilov <emil.s.tantilov@intel.com>
>     idpf: add read memory barrier when checking descriptor done bit
>
> Sebastian Sewior <bigeasy@linutronix.de>
>     xfrm: Don't disable preemption while looking up cache state.
>
> Howard Chu <howardchu95@gmail.com>
>     perf trace: Fix BPF loading failure (-E2BIG)
>
> Wentao Liang <vulab@iscas.ac.cn>
>     PM: hibernate: Add error handling for syscore_suspend()
>
> Eric Dumazet <edumazet@google.com>
>     ipmr: do not call mr_mfc_uses_dev() for unres entries
>
> Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
>     net: fec: implement TSO descriptor cleanup
>
> Dimitri Fedrau <dima.fedrau@gmail.com>
>     net: phy: marvell-88q2xxx: Fix temperature measurement with reset-gpi=
os
>
> Ahmad Fatoum <a.fatoum@pengutronix.de>
>     gpio: mxc: remove dead code after switch to DT-only
>
> Jian Shen <shenjian15@huawei.com>
>     net: hns3: fix oops when unload drivers paralleling
>
> Christian Marangi <ansuelsmth@gmail.com>
>     net: airoha: Fix wrong GDM4 register definition
>
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     regulator: core: Add missing newline character
>
> pangliyuan <pangliyuan1@huawei.com>
>     ubifs: skip dumping tnc tree when zroot is null
>
> Zhihao Cheng <chengzhihao1@huawei.com>
>     ubi: Revert "ubi: wl: Close down wear-leveling before nand is suspend=
ed"
>
> Ming Wang <wangming01@loongson.cn>
>     rtc: loongson: clear TOY_MATCH0_REG in loongson_rtc_isr()
>
> Oleksij Rempel <o.rempel@pengutronix.de>
>     rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     rtc: tps6594: Fix integer overflow on 32bit systems
>
> Alexandre Cassen <acassen@corp.free.fr>
>     xfrm: delete intermediate secpath entry in packet offload mode
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     dmaengine: ti: edma: fix OF node reference leaks in edma_driver
>
> Florian Westphal <fw@strlen.de>
>     xfrm: state: fix out-of-bounds read during lookup
>
> Jianbo Liu <jianbol@nvidia.com>
>     xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO
>
> Luo Yifan <luoyifan@cmss.chinamobile.com>
>     tools/bootconfig: Fix the wrong format specifier
>
> Huacai Chen <chenhuacai@kernel.org>
>     LoongArch: Fix warnings during S3 suspend
>
> Olga Kornievskaia <okorniev@redhat.com>
>     NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE
>
> Olga Kornievskaia <okorniev@redhat.com>
>     NFSv4.2: fix COPY_NOTIFY xdr buf size calculation
>
> Mike Snitzer <snitzer@kernel.org>
>     nfs: fix incorrect error handling in LOCALIO
>
> John Ogness <john.ogness@linutronix.de>
>     serial: 8250: Adjust the timeout for FIFO mode
>
> Jiri Slaby (SUSE) <jirislaby@kernel.org>
>     tty: mips_ejtag_fdc: fix one more u8 warning
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     driver core: class: Fix wild pointer dereferences in API class_dev_it=
er_next()
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     module: Don't fail module loading when setting ro_after_init section =
RO failed
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>     module: Extend the preempt disabled section in dereference_symbol_des=
criptor().
>
> Suren Baghdasaryan <surenb@google.com>
>     alloc_tag: avoid current->alloc_tag manipulations when profiling is d=
isabled
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: handle errors that nilfs_prepare_chunk() may return
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: protect access to buffers with no active references
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: do not force clear folio if buffer is referenced
>
> Su Yue <glass.su@suse.com>
>     ocfs2: mark dquot as inactive if failed to start trans while releasin=
g dquot
>
> Gao Xiang <xiang@kernel.org>
>     erofs: fix potential return value overflow of z_erofs_shrink_scan()
>
> Charles Han <hanchunchao@inspur.com>
>     firewire: test: Fix potential null dereference in firewire kunit test
>
> Guixin Liu <kanie@linux.alibaba.com>
>     scsi: mpi3mr: Fix possible crash when setting up bsg fails
>
> Guixin Liu <kanie@linux.alibaba.com>
>     scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
>
> Paul Menzel <pmenzel@molgen.mpg.de>
>     scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
>
> Daire McNamara <daire.mcnamara@microchip.com>
>     PCI: microchip: Set inbound address translation for coherent or non-c=
oherent mode
>
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>     PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test
>
> Mohamed Khalfella <khalfella@gmail.com>
>     PCI: endpoint: pci-epf-test: Set dma_chan_rx pointer to NULL on error
>
> Richard Zhu <hongxing.zhu@nxp.com>
>     PCI: dwc: Always stop link in the dw_pcie_suspend_noirq
>
> Krishna chaitanya chundru <quic_krichai@quicinc.com>
>     PCI: qcom: Update ICC and OPP values after Link Up event
>
> Richard Zhu <hongxing.zhu@nxp.com>
>     PCI: imx6: Add missing reference clock disable logic
>
> Richard Zhu <hongxing.zhu@nxp.com>
>     PCI: imx6: Deassert apps_reset in imx_pcie_deassert_core_reset()
>
> Richard Zhu <hongxing.zhu@nxp.com>
>     PCI: imx6: Skip controller_id generation logic for i.MX7D
>
> Frank Li <Frank.Li@nxp.com>
>     PCI: imx6: Configure PHY based on Root Complex or Endpoint mode
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     PCI: rockchip-ep: Fix error code in rockchip_pcie_ep_init_ob_mem()
>
> Damien Le Moal <dlemoal@kernel.org>
>     PCI: rockchip: Add missing fields descriptions for struct rockchip_pc=
ie_ep
>
> King Dix <kingdix10@qq.com>
>     PCI: rcar-ep: Fix incorrect variable used when calling devm_request_m=
em_region()
>
> Desnes Nunes <desnesn@redhat.com>
>     media: dvb-usb-v2: af9035: fix ISO C90 compilation error on af9035_i2=
c_master_xfer
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     watchdog: rti_wdt: Fix an OF node leak in rti_wdt_probe()
>
> Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
>     media: nxp: imx8-isi: fix v4l2-compliance test errors
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     mtd: hyperbus: hbmc-am654: fix an OF node reference leak
>
> david regan <dregan@broadcom.com>
>     mtd: rawnand: brcmnand: fix status read of brcmnand_waitfunc
>
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Propagate buf->error to userspace
>
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Fix deadlock during uvc_probe
>
> Jiasheng Jiang <jiashengjiangcool@gmail.com>
>     media: camif-core: Add check for clk_enable()
>
> Jiasheng Jiang <jiashengjiangcool@gmail.com>
>     media: mipi-csis: Add check for clk_enable()
>
> Dave Stevenson <dave.stevenson@raspberrypi.com>
>     media: i2c: ov9282: Correct the exposure offset
>
> Luca Weiss <luca.weiss@fairphone.com>
>     media: i2c: imx412: Add missing newline to prints
>
> Dave Stevenson <dave.stevenson@raspberrypi.com>
>     media: i2c: imx290: Register 0x3011 varies between imx327 and imx290
>
> Jiasheng Jiang <jiashengjiangcool@gmail.com>
>     media: marvell: Add check for clk_enable()
>
> Chen-Yu Tsai <wenst@chromium.org>
>     remoteproc: mtk_scp: Only populate devices for SCP cores
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()
>
> Chen Ni <nichen@iscas.ac.cn>
>     media: lmedm04: Handle errors for lme2510_int_read
>
> Oliver Neukum <oneukum@suse.com>
>     media: rc: iguanair: handle timeouts
>
> Dmytro Maluka <dmaluka@chromium.org>
>     of/fdt: Restore possibility to use both ACPI and FDT from bootloader
>
> Mark Brown <broonie@kernel.org>
>     spi: omap2-mcspi: Correctly handle devm_clk_get_optional() errors
>
> Michal Wilczynski <m.wilczynski@samsung.com>
>     mailbox: th1520: Fix memory corruption due to incorrect array size
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     mailbox: mpfs: fix copy and paste bug in probe
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     mailbox: th1520: Fix a NULL vs IS_ERR() bug
>
> Qasim Ijaz <qasdev00@gmail.com>
>     iommufd/iova_bitmap: Fix shift-out-of-bounds in iova_bitmap_offset_to=
_index()
>
> Suraj Sonawane <surajsonawane0215@gmail.com>
>     iommu: iommufd: fix WARNING in iommufd_device_unbind
>
> Zhu Yanjun <yanjun.zhu@linux.dev>
>     RDMA/rxe: Fix the warning "__rxe_cleanup+0x12c/0x170 [rdma_rxe]"
>
> Anumula Murali Mohan Reddy <anumula@chelsio.com>
>     RDMA/cxgb4: Notify rdma stack for IB_EVENT_QP_LAST_WQE_REACHED event
>
> Randy Dunlap <rdunlap@infradead.org>
>     efi: sysfb_efi: fix W=3D1 warnings when EFI is not set
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     of: reserved-memory: Do not make kmemleak ignore freed address
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     of: property: Avoiding using uninitialized variable @imaplen in parse=
_interrupt_map()
>
> Michael Guralnik <michaelgur@nvidia.com>
>     RDMA/mlx5: Fix indirect mkey ODP page count
>
> Pei Xiao <xiaopei01@kylinos.cn>
>     i3c: dw: Fix use-after-free in dw_i3c_master driver due to race condi=
tion
>
> Joel Stanley <joel@jms.id.au>
>     arm64: dts: qcom: x1e80100-romulus: Update firmware nodes
>
> Akhil R <akhilrajeev@nvidia.com>
>     arm64: tegra: Fix DMA ID for SPI2
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()
>
> Josua Mayer <josua@solid-run.com>
>     arm64: dts: ti: k3-am642-hummingboard-t: Convert overlay to board dts
>
> Siddharth Vadapalli <s-vadapalli@ti.com>
>     arm64: dts: ti: Makefile: Fix typo "k3-j7200-evm-pcie1-ep.dtbo"
>
> Michael Riesch <michael.riesch@wolfvision.net>
>     arm64: dts: rockchip: fix num-channels property of wolfvision pf5 mic
>
> Jagan Teki <jagan@edgeble.ai>
>     arm64: dts: rockchip: Fix PCIe3 handling for Edgeble-6TOPS Modules
>
> Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>     ARM: dts: mediatek: mt7623: fix IR nodename
>
> Josua Mayer <josua@solid-run.com>
>     arm64: dts: marvell: cn9131-cf-solidwan: fix cp1 comphy links
>
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>     arm64: dts: qcom: sm8250: Fix interrupt types of camss interrupts
>
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>     arm64: dts: qcom: sdm845: Fix interrupt types of camss interrupts
>
> Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>     arm64: dts: qcom: sc8280xp: Fix interrupt type of camss interrupts
>
> Val Packett <val@packett.cool>
>     arm64: dts: mediatek: add per-SoC compatibles for keypad nodes
>
> Jason-JH.Lin <jason-jh.lin@mediatek.com>
>     dts: arm64: mediatek: mt8195: Remove MT8183 compatible for OVL
>
> Jason-JH.Lin <jason-jh.lin@mediatek.com>
>     dts: arm64: mediatek: mt8188: Update OVL compatible from MT8183 to MT=
8195
>
> Frank Wunderlich <frank-w@public-files.de>
>     arm64: dts: mediatek: mt7988: Add missing clock-div property for i2c
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     firmware: qcom: scm: Cleanup global '__scm' on probe failures
>
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     arm64: dts: qcom: sc8280xp: Fix up remoteproc register space sizes
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     arm64: dts: qcom: sm8150-microsoft-surface-duo: fix typos in da7280 p=
roperties
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     arm64: dts: qcom: sc7180: fix psci power domain node names
>
> Alan Stern <stern@rowland.harvard.edu>
>     HID: core: Fix assumption that Resolution Multipliers must be in Logi=
cal Collections
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supp=
ly
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: remove disabled=
 ov7251 camera
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     arm64: dts: qcom: qcm6490-shift-otter: remove invalid orientation-swi=
tch
>
> Aaro Koskinen <aaro.koskinen@iki.fi>
>     ARM: omap1: Fix up the Retu IRQ on Nokia 770
>
> Junxian Huang <huangjunxian6@hisilicon.com>
>     RDMA/hns: Clean up the legacy CONFIG_INFINIBAND_HNS
>
> Li Zhijian <lizhijian@fujitsu.com>
>     RDMA/rtrs: Add missing deinit() call
>
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>     RDMA/bnxt_re: Fix to drop reference to the mmap entry in case of erro=
r
>
> Jonas Karlman <jonas@kwiboo.se>
>     arm64: dts: rockchip: Fix sdmmc access on rk3308-rock-s0 v1.1 boards
>
> Bryan Brattlof <bb@ti.com>
>     arm64: dts: ti: k3-am62a: Remove duplicate GICR reg
>
> Bryan Brattlof <bb@ti.com>
>     arm64: dts: ti: k3-am62: Remove duplicate GICR reg
>
> Cristian Birsan <cristian.birsan@microchip.com>
>     ARM: dts: microchip: sama5d27_wlsom1_ek: Add no-1-8-v property to sdm=
mc0 node
>
> Cristian Birsan <cristian.birsan@microchip.com>
>     ARM: dts: microchip: sama5d29_curiosity: Add no-1-8-v property to sdm=
mc0 node
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     arm64: dts: qcom: sm8650: Fix CDSP context banks unit addresses
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: x1e80100: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm8650: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm8550: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm8450: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm8350: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm8250: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm6375: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm6125: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sm4450: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sdx75: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: sc7280: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: qrb4210-rb2: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: q[dr]u1000: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: qcs404: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: msm8994: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: msm8939: correct sleep clock frequency
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     arm64: dts: qcom: msm8916: correct sleep clock frequency
>
> Luca Weiss <luca.weiss@fairphone.com>
>     arm64: dts: qcom: sm7225-fairphone-fp4: Drop extra qcom,msm-id value
>
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     arm64: dts: qcom: msm8994: Describe USB interrupts
>
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     arm64: dts: qcom: msm8996: Fix up USB3 interrupts
>
> Ross Burton <ross.burton@arm.com>
>     arm64: defconfig: remove obsolete CONFIG_SM_DISPCC_8650
>
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     arm64: dts: qcom: sa8775p: Use valid node names for GPI DMAs
>
> Maulik Shah <quic_mkshah@quicinc.com>
>     arm64: dts: qcom: sa8775p: Add CPUs to psci power domain
>
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>     arm64: dts: qcom: sa8775p: Use a SoC-specific compatible for GPI DMA
>
> Taniya Das <quic_tdas@quicinc.com>
>     arm64: dts: qcom: sa8775p: Update sleep_clk frequency
>
> Marek Vasut <marex@denx.de>
>     arm64: dts: qcom: msm8996-xiaomi-gemini: Fix LP5562 LED1 reg property
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage=
 settings
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     memory: tegra20-emc: fix an OF node reference bug in tegra_emc_find_n=
ode_by_ram_code()
>
> Marek Vasut <marex@denx.de>
>     ARM: dts: stm32: Swap USART3 and UART8 alias on STM32MP15xx DHCOM SoM
>
> Marek Vasut <marex@denx.de>
>     ARM: dts: stm32: Deduplicate serial aliases and chosen node for STM32=
MP15xx DHCOM SoM
>
> N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
>     arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie=
1
>
> Ma Ke <make_ruc2021@163.com>
>     RDMA/srp: Fix error handling in srp_add_port
>
> Hsin-Te Yuan <yuanhsinte@chromium.org>
>     arm64: dts: mediatek: mt8183: willow: Support second source touchscre=
en
>
> Hsin-Te Yuan <yuanhsinte@chromium.org>
>     arm64: dts: mediatek: mt8183: kenzo: Support second source touchscree=
n
>
> zhenwei pi <pizhenwei@bytedance.com>
>     RDMA/rxe: Fix mismatched max_msg_sz
>
> Mamta Shukla <mamta.shukla@leica-geosystems.com>
>     arm: dts: socfpga: use reset-name "stmmaceth-ocp" instead of "ahb"
>
> Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
>     ARM: dts: aspeed: yosemite4: correct the compatible string for max317=
90
>
> Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
>     ARM: dts: aspeed: yosemite4: Add required properties for IOE on fan b=
oards
>
> Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
>     ARM: dts: aspeed: yosemite4: correct the compatible string of adm1272
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8395-genio-1200-evk: Drop regulator-compatibl=
e property
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: medaitek: mt8395-nio-12l: Drop regulator-compatible prope=
rty
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8195-demo: Drop regulator-compatible property
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8195-cherry: Drop regulator-compatible proper=
ty
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8192-asurada: Drop regulator-compatible prope=
rty
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8173-elm: Drop regulator-compatible property
>
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8173-evb: Drop regulator-compatible property
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     rdma/cxgb4: Prevent potential integer overflow on 32bit
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     arm64: dts: renesas: rzg3s-smarc: Fix the debug serial alias
>
> Leon Romanovsky <leon@kernel.org>
>     RDMA/mlx4: Avoid false error about access to uninitialized gids array
>
> Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
>     ARM: dts: stm32: Fix IPCC EXTI declaration on stm32mp151
>
> Marek Vasut <marex@denx.de>
>     ARM: dts: stm32: Sort M24256E write-lockable page in DH STM32MP13xx D=
HCOR SoM DT
>
> Marek Vasut <marex@denx.de>
>     ARM: dts: stm32: Increase CPU core voltage on STM32MP13xx DHCOR SoM
>
> Val Packett <val@packett.cool>
>     arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A
>
> Val Packett <val@packett.cool>
>     arm64: dts: mediatek: mt8516: add i2c clock-div property
>
> Val Packett <val@packett.cool>
>     arm64: dts: mediatek: mt8516: fix wdt irq type
>
> Val Packett <val@packett.cool>
>     arm64: dts: mediatek: mt8516: fix GICv2 range
>
> Hsin-Yi Wang <hsinyi@chromium.org>
>     arm64: dts: mt8183: set DMIC one-wire mode on Damu
>
> N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
>     arm64: dts: mediatek: mt8186: Move wakeup to MTU3 to get working susp=
end
>
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     ARM: dts: imx7-tqma7: add missing vs-supply for LM75A (rev. 01xxx)
>
> Nicolas Ferre <nicolas.ferre@microchip.com>
>     ARM: at91: pm: change BU Power Switch to automatic mode
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     soc: atmel: fix device_node release in atmel_soc_device_init()
>
> Hou Tao <houtao1@huawei.com>
>     bpf: Cancel the running bpf_timer through kworker for PREEMPT_RT
>
> Pali Roh=C3=A1r <pali@kernel.org>
>     cifs: Use cifs_autodisable_serverino() for disabling CIFS_MOUNT_SERVE=
R_INUM in readdir.c
>
> Paulo Alcantara <pc@manguebit.com>
>     smb: client: fix oops due to unset link speed
>
> Herbert Xu <herbert@gondor.apana.org.au>
>     rhashtable: Fix rhashtable_try_insert test
>
> Chen Ridong <chenridong@huawei.com>
>     padata: avoid UAF for reorder_work
>
> Chen Ridong <chenridong@huawei.com>
>     padata: add pd get/put refcnt helper
>
> Chen Ridong <chenridong@huawei.com>
>     padata: fix UAF in padata_reorder
>
> Chun-Tse Shao <ctshao@google.com>
>     perf lock: Fix parse_lock_type which only retrieve one lock flag
>
> Vishal Chourasia <vishalc@linux.ibm.com>
>     tools: Sync if_xdp.h uapi tooling header
>
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek - Fixed headphone distorted sound on Acer Aspire A1=
15-31 laptop
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     iommu/amd: Fully decode all combinations of alloc_paging_flags
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     iommu/amd: Change amd_iommu_pgtable to use enum protection_domain_mod=
e
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     iommu/amd: Remove type argument from do_iommu_domain_alloc() and rela=
ted
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     iommu/amd: Remove dev =3D=3D NULL checks
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     iommu/amd: Remove domain_alloc()
>
> Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
>     iommu/amd: Remove unused amd_iommu_domain_update()
>
> Guo Ren <guoren@kernel.org>
>     iommu/riscv: Fixup compile warning
>
> Daniel Xu <dxu@dxuuu.xyz>
>     bpf: tcp: Mark bpf_load_hdr_opt() arg2 as read-write
>
> Pu Lehui <pulehui@huawei.com>
>     libbpf: Fix incorrect traversal end type ID when marking BTF_IS_EMBED=
DED
>
> Pu Lehui <pulehui@huawei.com>
>     libbpf: Fix return zero when elf_begin failed
>
> Pu Lehui <pulehui@huawei.com>
>     selftests/bpf: Fix btf leak on new btf alloc failure in btf_distill t=
est
>
> Tony Ambardar <tony.ambardar@gmail.com>
>     selftests/bpf: Fix undefined UINT_MAX in veristat.c
>
> Puranjay Mohan <puranjay@kernel.org>
>     bpf: Send signals asynchronously if !preemptible
>
> Simon Trimmer <simont@opensource.cirrus.com>
>     ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 83JX, 83MC and 83NM
>
> Simon Trimmer <simont@opensource.cirrus.com>
>     ASoC: Intel: sof_sdw: Fix DMI match for Lenovo 83LC
>
> Ian Rogers <irogers@google.com>
>     perf inject: Fix use without initialization of local variables
>
> Ian Rogers <irogers@google.com>
>     perf test stat: Avoid hybrid assumption when virtualized
>
> Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>     pinctrl: amd: Take suspend type into consideration which pins are non=
-wake
>
> Mingwei Zheng <zmw12306@gmail.com>
>     pinctrl: stm32: Add check for clk_enable()
>
> Jiachen Zhang <me@jcix.top>
>     perf report: Fix misleading help message about --demangle
>
> Cezary Rojewski <cezary.rojewski@intel.com>
>     ALSA: hda: Fix compilation of snd_hdac_adsp_xxx() helpers
>
> Arnaldo Carvalho de Melo <acme@kernel.org>
>     perf MANIFEST: Add arch/*/include/uapi/asm/bpf_perf_event.h to the pe=
rf tarball
>
> Namhyung Kim <namhyung@kernel.org>
>     perf symbol: Prefer non-label symbols with same address
>
> Amadeusz S=C5=82awi=C5=84ski <amadeuszx.slawinski@linux.intel.com>
>     ASoC: Intel: avs: Fix init-config parsing
>
> Cezary Rojewski <cezary.rojewski@intel.com>
>     ASoC: Intel: avs: Fix theoretical infinite loop
>
> Cezary Rojewski <cezary.rojewski@intel.com>
>     ASoC: Intel: avs: Fix the minimum firmware version numbers
>
> Cezary Rojewski <cezary.rojewski@intel.com>
>     ASoC: Intel: avs: Do not readq() u32 registers
>
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf namespaces: Fixup the nsinfo__in_pidns() return type, its bool
>
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf namespaces: Introduce nsinfo__set_in_pidns()
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     perf machine: Don't ignore _etext when not a text symbol
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     perf maps: Fix display of kernel symbols
>
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf top: Don't complain about lack of vmlinux when not resolving som=
e kernel samples
>
> Lu Baolu <baolu.lu@linux.intel.com>
>     iommu/vt-d: Draining PRQ in sva unbind path when FPD bit set
>
> Jiayuan Chen <mrpre@163.com>
>     selftests/bpf: Avoid generating untracked files when running bpf self=
tests
>
> Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
>     padata: fix sysfs store callback check
>
> Martin KaFai Lau <martin.lau@kernel.org>
>     bpf: Reject struct_ops registration that uses module ptr and the modu=
le btf_id is missing
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Make dependency on UMP clearer
>
> Pei Xiao <xiaopei01@kylinos.cn>
>     bpf: Use refcount_t instead of atomic_t for mmap_count
>
> Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
>     crypto: iaa - Fix IAA disabling that occurs when sync_mode is set to =
'async'
>
> James Clark <james.clark@linaro.org>
>     perf stat: Fix trailing comma when there is no metric unit
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()
>
> Wenkai Lin <linwenkai6@hisilicon.com>
>     crypto: hisilicon/sec2 - fix for aead invalid authsize
>
> Wenkai Lin <linwenkai6@hisilicon.com>
>     crypto: hisilicon/sec2 - fix for aead icv error
>
> Breno Leitao <leitao@debian.org>
>     rhashtable: Fix potential deadlock by moving schedule_work outside lo=
ck
>
> Martin KaFai Lau <martin.lau@kernel.org>
>     bpf: bpf_local_storage: Always use bpf_mem_alloc in PREEMPT_RT
>
> Ba Jing <bajing@cmss.chinamobile.com>
>     ktest.pl: Remove unused declarations in run_bisect_test function
>
> Mingwei Zheng <zmw12306@gmail.com>
>     pinctrl: nomadik: Add check for clk_enable()
>
> Levi Yun <yeoreum.yun@arm.com>
>     perf expr: Initialize is_test value in expr__ctx_new()
>
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     tools build: Remove the libunwind feature tests from the ones detecte=
d when test-all.o builds
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     ASoC: renesas: rz-ssi: Use only the proper amount of dividers
>
> Zhongqiu Han <quic_zhonhan@quicinc.com>
>     perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_p=
rog_info()
>
> Zhongqiu Han <quic_zhonhan@quicinc.com>
>     perf header: Fix one memory leakage in process_bpf_prog_info()
>
> Zhongqiu Han <quic_zhonhan@quicinc.com>
>     perf header: Fix one memory leakage in process_bpf_btf()
>
> Hans de Goede <hdegoede@redhat.com>
>     platform/x86: x86-android-tablets: Make variables only used locally s=
tatic
>
> Hans de Goede <hdegoede@redhat.com>
>     platform/x86: x86-android-tablets: Add missing __init to get_i2c_adap=
_by_*()
>
> Gaurav Jain <gaurav.jain@nxp.com>
>     crypto: caam - use JobR's space to access page 0 regs
>
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: api - Fix boot-up self-test race
>
> Chen Ridong <chenridong@huawei.com>
>     crypto: tegra - do not transfer req when tegra init fails
>
> Jason Gunthorpe <jgg@ziepe.ca>
>     iommu/arm-smmuv3: Update comments about ATS and bypass
>
> Saket Kumar Bhaskar <skb99@linux.ibm.com>
>     selftests/bpf: Fix fill_link_info selftest on powerpc
>
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     tools features: Don't check for libunwind devel files by default
>
> George Lander <lander@jagmn.com>
>     ASoC: sun4i-spdif: Add clock multiplier settings
>
> Bard Liao <yung-chuan.liao@linux.intel.com>
>     ASoC: Intel: sof_sdw: correct mach_params->dmic_num
>
> Quentin Monnet <qmo@kernel.org>
>     libbpf: Fix segfault due to libelf functions not setting errno
>
> Andrea Righi <arighi@nvidia.com>
>     sched_ext: Use the NUMA scheduling domain for NUMA optimizations
>
> Marco Leogrande <leogrande@google.com>
>     tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bi=
nd
>
> Takashi Iwai <tiwai@suse.de>
>     ASoC: wcd937x: Use *-y for Makefile
>
> Takashi Iwai <tiwai@suse.de>
>     ASoC: cs42l84: Use *-y for Makefile
>
> Takashi Iwai <tiwai@suse.de>
>     ASoC: SDCA: Use *-y for Makefile
>
> Takashi Iwai <tiwai@suse.de>
>     ASoC: mediatek: mt8365: Use *-y for Makefile
>
> Takashi Iwai <tiwai@suse.de>
>     ASoC: cs40l50: Use *-y for Makefile
>
> Andrii Nakryiko <andrii@kernel.org>
>     libbpf: don't adjust USDT semaphore address if .stapsdt.base addr is =
missing
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     pinctrl: samsung: Fix irq handling if an error occurs in exynos_irq_d=
emux_eint16_31()
>
> Pei Xiao <xiaopei01@kylinos.cn>
>     platform/x86: x86-android-tablets: make platform data be static
>
> Pei Xiao <xiaopei01@kylinos.cn>
>     platform/mellanox: mlxbf-pmc: incorrect type in assignment
>
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>     net/rose: prevent integer overflows in rose_setsockopt()
>
> Mahdi Arghavani <ma.arghavani@yahoo.com>
>     tcp_cubic: fix incorrect HyStart round start detection
>
> Roger Quadros <rogerq@kernel.org>
>     net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remov=
e_tx_chns()
>
> Xin Long <lucien.xin@gmail.com>
>     net: sched: refine software bypass handling in tc_run
>
> Florian Westphal <fw@strlen.de>
>     netfilter: nft_flow_offload: update tcp state flags under lock
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: fix set size with rbtree backend
>
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net: sched: Disallow replacing of child qdisc from one parent to anot=
her
>
> Antoine Tenart <atenart@kernel.org>
>     net: avoid race between device unregistration and ethnl ops
>
> Shinas Rasheed <srasheed@marvell.com>
>     octeon_ep_vf: remove firmware stats fetch in ndo_get_stats64
>
> Shinas Rasheed <srasheed@marvell.com>
>     octeon_ep: remove firmware stats fetch in ndo_get_stats64
>
> Maher Sanalla <msanalla@nvidia.com>
>     net/mlxfw: Drop hard coded max FW flash image size
>
> Liu Jian <liujian56@huawei.com>
>     net: let net.core.dev_weight always be non-zero
>
> Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>     selftests/landlock: Fix error message
>
> Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>     selftests/landlock: Fix build with non-default pthread linking
>
> Daniel Golle <daniel@makrotopia.org>
>     net: phy: realtek: always clear NBase-T lpa
>
> Daniel Golle <daniel@makrotopia.org>
>     net: phy: realtek: clear master_slave_state if link is down
>
> Daniel Golle <daniel@makrotopia.org>
>     net: phy: realtek: clear 1000Base-T lpa if link is down
>
> Mingwei Zheng <zmw12306@gmail.com>
>     pwm: stm32: Add check for clk_enable()
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     dev: Acquire netdev_rename_lock before restoring dev->name in dev_cha=
nge_name().
>
> Bo Gan <ganboing@gmail.com>
>     clk: analogbits: Fix incorrect calculation of vco rate delta
>
> Eric Dumazet <edumazet@google.com>
>     inet: ipmr: fix data-races
>
> Alexis Lothor=C3=A9 <alexis.lothore@bootlin.com>
>     wifi: wilc1000: unregister wiphy only after netdev registration
>
> Max Chou <max.chou@realtek.com>
>     Bluetooth: btrtl: check for NULL in btrtl_setup_realtek()
>
> Charles Han <hanchunchao@inspur.com>
>     Bluetooth: btbcm: Fix NULL deref in btbcm_get_board_name()
>
> Dmitry Antipov <dmantipov@yandex.ru>
>     wifi: cfg80211: adjust allocation of colocated AP data
>
> Dmitry V. Levin <ldv@strace.io>
>     selftests: harness: fix printing of mismatch values in __EXPECT()
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     selftests: timers: clocksource-switch: Adapt progress to kselftest fr=
amework
>
> Aditya Kumar Singh <quic_adisi@quicinc.com>
>     wifi: ath12k: fix key cache handling
>
> Gautham R. Shenoy <gautham.shenoy@amd.com>
>     cpufreq: ACPI: Fix max-frequency computation
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     i2c: designware: Actually make use of the I2C_DW_COMMON and I2C_DW sy=
mbol namespaces
>
> Peter Chiu <chui-hao.chiu@mediatek.com>
>     wifi: mt76: mt7996: fix ldpc setting
>
> Benjamin Lin <benjamin-jw.lin@mediatek.com>
>     wifi: mt76: mt7996: fix definition of tx descriptor
>
> Benjamin Lin <benjamin-jw.lin@mediatek.com>
>     wifi: mt76: mt7996: fix incorrect indexing of MIB FW event
>
> Howard Hsu <howard-yh.hsu@mediatek.com>
>     wifi: mt76: mt7996: fix HE Phy capability
>
> Howard Hsu <howard-yh.hsu@mediatek.com>
>     wifi: mt76: mt7996: fix the capability of reception of EHT MU PPDU
>
> Peter Chiu <chui-hao.chiu@mediatek.com>
>     wifi: mt76: mt7996: add max mpdu len capability
>
> Peter Chiu <chui-hao.chiu@mediatek.com>
>     wifi: mt76: mt7996: fix register mapping
>
> Peter Chiu <chui-hao.chiu@mediatek.com>
>     wifi: mt76: mt7915: fix register mapping
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7915: fix omac index assignment after hardware reset
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7915: firmware restart on devices with a second pcie li=
nk
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: only enable tx worker after setting the channel
>
> Felix Fietkau <nbd@nbd.name>
>     wifi: mt76: mt7996: fix rx filter setting for bfee functionality
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Properly handle responses for commands with event=
s
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Cleanup MLO settings post-disconnection
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Update mt7925_mcu_uni_[tx,rx]_ba for MLO
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Init secondary link PM state
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Update secondary link PS flow
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Update mt7925_unassign_vif_chanctx for per-link B=
SS
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Update mt792x_rx_get_wcid for per-link STA
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Update mt7925_mcu_sta_update for BC in ASSOC stat=
e
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: Enhance mt7925_mac_link_sta_add to support MLO
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Enhance mt7925_mac_link_bss_add to support MLO
>
> Leon Yen <leon.yen@mediatek.com>
>     wifi: mt76: mt7925: Fix CNM Timeout with Single Active Link in MLO
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: fix wrong parameter for related cmd of chan info
>
> allan.wang <allan.wang@mediatek.com>
>     wifi: mt76: mt7925: Fix incorrect WCID phy_idx assignment
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Fix incorrect WCID assignment for MLO
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: Fix incorrect MLD address in bss_mld_tlv for MLO =
support
>
> Sean Wang <sean.wang@mediatek.com>
>     wifi: mt76: connac: Extend mt76_connac_mcu_uni_add_dev for MLO
>
> xueqin Luo <luoxueqin@kylinos.cn>
>     wifi: mt76: mt7915: fix overflows seen when writing limit attributes
>
> xueqin Luo <luoxueqin@kylinos.cn>
>     wifi: mt76: mt7996: fix overflows seen when writing limit attributes
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: fix the invalid ip address for arp offload
>
> Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
>     wifi: mt76: mt7925: fix get wrong chip cap from incorrect pointer
>
> Eric-SY Chang <eric-sy.chang@mediatek.com>
>     wifi: mt76: mt7925: fix wrong band_idx setting when enable sniffer mo=
de
>
> Charles Han <hanchunchao@inspur.com>
>     wifi: mt76: mt7925: fix NULL deref check in mt7925_change_vif_links
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     wifi: mt76: mt7915: Fix an error handling path in mt7915_add_interfac=
e()
>
> Michael Lo <michael.lo@mediatek.com>
>     wifi: mt76: mt7921: fix using incorrect group cipher after disconnect=
ion.
>
> WangYuli <wangyuli@uniontech.com>
>     wifi: mt76: mt76u_vendor_request: Do not print error messages when -E=
PROTO
>
> Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>     landlock: Handle weird files
>
> Guangguan Wang <guangguan.wang@linux.alibaba.com>
>     net/smc: fix data error when recvmsg with MSG_PEEK flag
>
> Drew Fustini <dfustini@tenstorrent.com>
>     clk: thead: Fix cpu2vp_clk for TH1520 AP_SUBSYS clocks
>
> Drew Fustini <dfustini@tenstorrent.com>
>     clk: thead: Add CLK_IGNORE_UNUSED to fix TH1520 boot
>
> Drew Fustini <dfustini@tenstorrent.com>
>     clk: thead: Fix clk gate registration to pass flags
>
> Sergio Paracuellos <sergio.paracuellos@gmail.com>
>     clk: ralink: mtmips: remove duplicated 'xtal' clock for Ralink SoC RT=
3883
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: don't flush non-uploaded STAs
>
> Ilan Peer <ilan.peer@intel.com>
>     wifi: mac80211: Fix common size calculation for ML element
>
> Andy Strohman <andrew@andrewstrohman.com>
>     wifi: mac80211: fix tid removal during mesh forwarding
>
> Kees Cook <kees@kernel.org>
>     wifi: cfg80211: Move cfg80211_scan_req_add_chan() n_channels incremen=
t earlier
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: prohibit deactivating all links
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     wifi: iwlwifi: mvm: remove unneeded NULL pointer checks
>
> Daniel Gabay <daniel.gabay@intel.com>
>     wifi: iwlwifi: mvm: don't count mgmt frames as MPDU
>
> Miri Korenblit <miriam.rachel.korenblit@intel.com>
>     wifi: iwlwifi: mvm: avoid NULL pointer dereference
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: iwlwifi: fw: read STEP table from correct UEFI var
>
> Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
>     wifi: mt76: mt7915: Fix mesh scan on MT7916 DBDC
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     wifi: mt76: mt7925: fix off by one in mt7925_load_clc()
>
> Joel Stanley <joel@jms.id.au>
>     hwmon: Fix help text for aspeed-g6-pwm-tach
>
> Ping-Ke Shih <pkshih@realtek.com>
>     wifi: rtw89: fix race between cancel_hw_scan and hw_scan completion
>
> Zong-Zhe Yang <kevin_yang@realtek.com>
>     wifi: rtw89: mcc: consider time limits not divisible by 1024
>
> Chih-Kang Chang <gary.chang@realtek.com>
>     wifi: rtw89: avoid to init mgnt_entry list twice when WoWLAN failed
>
> Po-Hao Huang <phhuang@realtek.com>
>     wifi: rtw89: correct header conversion rule for MLO only
>
> Zong-Zhe Yang <kevin_yang@realtek.com>
>     wifi: rtw89: chan: fix soft lockup in rtw89_entity_recalc_mgnt_roles(=
)
>
> Zong-Zhe Yang <kevin_yang@realtek.com>
>     wifi: rtw89: fix proceeding MCC with wrong scanning state after seque=
nce changes
>
> Andreas Kemnade <andreas@kemnade.info>
>     wifi: wlcore: fix unbalanced pm_runtime calls
>
> Alexis Lothor=C3=A9 <alexis.lothore@bootlin.com>
>     wifi: wilc1000: unregister wiphy only if it has been registered
>
> Shayne Chen <shayne.chen@mediatek.com>
>     wifi: mt76: mt7996: fix invalid interface combinations
>
> Zichen Xie <zichenxie0106@gmail.com>
>     samples/landlock: Fix possible NULL dereference in parse_path()
>
> Rob Herring (Arm) <robh@kernel.org>
>     mfd: syscon: Fix race in device_node_get_regmap()
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     leds: cht-wcove: Use devm_led_classdev_register() to avoid memory lea=
k
>
> Terry Tritton <terry.tritton@linaro.org>
>     HID: fix generic desktop D-Pad controls
>
> Karol Przybylski <karprzy7@gmail.com>
>     HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding en=
dpoint check
>
> Amit Pundir <amit.pundir@linaro.org>
>     clk: qcom: gcc-sdm845: Do not use shared clk_ops for QUPs
>
> Sathishkumar Muruganandam <quic_murugana@quicinc.com>
>     wifi: ath12k: fix tx power, max reg power update to firmware
>
> Quan Nguyen <quan@os.amperecomputing.com>
>     ipmi: ssif_bmc: Fix new request loss when bmc ready for a response
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     OPP: OF: Fix an OF node leak in _opp_add_static_v2()
>
> Yevgeny Kliteynik <kliteyn@nvidia.com>
>     net/mlx5: HWS, fix definer's HWS_SET32 macro for negative offset
>
> Eric Dumazet <edumazet@google.com>
>     ax25: rcu protect dev->ax25_ptr
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     regulator: of: Implement the unwind path of of_regulator_match()
>
> Vasily Khoruzhick <anarsoul@gmail.com>
>     clk: sunxi-ng: a64: stop force-selecting PLL-MIPI as TCON0 parent
>
> Mario Limonciello <mario.limonciello@amd.com>
>     cpufreq/amd-pstate: Fix prefcore rankings
>
> Octavian Purdila <tavip@google.com>
>     team: prevent adding a device which is already a team device lower
>
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     clk: qcom: camcc-x1e80100: Set titan_top_gdsc as the parent GDSC of s=
ubordinate GDSCs
>
> Peng Fan <peng.fan@nxp.com>
>     clk: imx: Apply some clks only for i.MX93
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     arm64: dts: imx93: Use IMX93_CLK_SPDIF_IPG as SPDIF IPG clock
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     clk: imx93: Add IMX93_CLK_SPDIF_IPG clock
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     dt-bindings: clock: imx93: Add SPDIF IPG clk
>
> Marek Vasut <marex@denx.de>
>     clk: imx8mp: Fix clkout1/2 support
>
> Stefano Brivio <sbrivio@redhat.com>
>     udp: Deal with race between UDP socket address change and rehash
>
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>     cpufreq: qcom: Implement clk_ops::determine_rate() for qcom_cpufreq* =
clocks
>
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>     cpufreq: qcom: Fix qcom_cpufreq_hw_recalc_rate() to query LUT if LMh =
IRQ is not available
>
> Luca Ceresoli <luca.ceresoli@bootlin.com>
>     gpio: pca953x: log an error when failing to get the reset GPIO
>
> Lorenzo Bianconi <lorenzo@kernel.org>
>     net: airoha: Fix error path in airoha_probe()
>
> Eric Dumazet <edumazet@google.com>
>     ptr_ring: do not block hard interrupts in ptr_ring_resize_multiple()
>
> Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>     selftests: ktap_helpers: Fix uninitialized variable
>
> Sultan Alsawaf (unemployed) <sultan@kerneltoast.com>
>     cpufreq: schedutil: Fix superfluous updates caused by need_freq_updat=
e
>
> Mingwei Zheng <zmw12306@gmail.com>
>     pwm: stm32-lp: Add check for clk_enable()
>
> Eric Dumazet <edumazet@google.com>
>     inetpeer: do not get a refcount in inet_getpeer()
>
> Eric Dumazet <edumazet@google.com>
>     inetpeer: update inetpeer timestamp in inet_getpeer()
>
> Eric Dumazet <edumazet@google.com>
>     inetpeer: remove create argument of inet_getpeer()
>
> Eric Dumazet <edumazet@google.com>
>     inetpeer: remove create argument of inet_getpeer_v[46]()
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_p=
data()
>
> Matti Vaittinen <mazziesaccount@gmail.com>
>     dt-bindings: mfd: bd71815: Fix rsense and typos
>
> He Rongguang <herongguang@linux.alibaba.com>
>     cpupower: fix TSC MHz calculation
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     ACPI: fan: cleanup resources in the error path of .probe()
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     hwmon: (nct6775): Actually make use of the HWMON_NCT6775 symbol names=
pace
>
> Marcel Hamer <marcel.hamer@windriver.com>
>     wifi: brcmfmac: add missing header include for brcmf_dbg
>
> Aditya Kumar Singh <quic_adisi@quicinc.com>
>     wifi: ath12k: fix read pointer after free in ath12k_mac_assign_vif_to=
_vdev()
>
> Chen-Yu Tsai <wenst@chromium.org>
>     regulator: dt-bindings: mt6315: Drop regulator-compatible property
>
> Jiri Kosina <jikos@kernel.org>
>     HID: multitouch: fix support for Goodix PID 0x01e9
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: pci: wait for firmware loading before releasing memory
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: fix memory leaks and invalid access at probe error pat=
h
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: destroy workqueue at rtl_deinit_core
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: remove unused check_buddy_priv
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     dt-bindings: leds: class-multicolor: Fix path to color definitions
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     clk: fix an OF node reference leak in of_clk_get_parent_name()
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     dt-bindings: mmc: controller: clarify the address-cells description
>
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix handling of received connection abort
>
> Mingwei Zheng <zmw12306@gmail.com>
>     spi: zynq-qspi: Add check for clk_enable()
>
> Octavian Purdila <tavip@google.com>
>     net_sched: sch_sfq: don't allow 1 packet limit
>
> Song Yoong Siang <yoong.siang.song@intel.com>
>     selftests/bpf: Actuate tx_metadata_len in xdp_hw_metadata
>
> Zichen Xie <zichenxie0106@gmail.com>
>     wifi: cfg80211: tests: Fix potential NULL dereference in test_cfg8021=
1_parse_colocated_ap()
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     clk: mmp: pxa1908-apbc: Fix NULL vs IS_ERR() check
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     clk: mmp: pxa1908-apbcp: Fix a NULL vs IS_ERR() check
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     clk: mmp: pxa1908-mpmu: Fix a NULL vs IS_ERR() check
>
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>     clk: renesas: cpg-mssr: Fix 'soc' node handling in cpg_mssr_reserved_=
init()
>
> Barnab=C3=A1s Cz=C3=A9m=C3=A1n <barnabas.czeman@mainlining.org>
>     wifi: wcn36xx: fix channel survey memory allocation size
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: usb: fix workqueue leak when probe fails
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: fix init_sw_vars leak when probe fails
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: wait for firmware loading before releasing memory
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last=
 step
>
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     wifi: rtlwifi: do not complete firmware loading needlessly
>
> Colin Ian King <colin.i.king@gmail.com>
>     wifi: rtlwifi: rtl8821ae: phy: restore removed code to fix infinite l=
oop
>
> Balaji Pothunoori <quic_bpothuno@quicinc.com>
>     wifi: ath11k: Fix unexpected return buffer manager error for WCN6750/=
WCN6855
>
> Charles Han <hanchunchao@inspur.com>
>     ipmi: ipmb: Add check devm_kasprintf() returned value
>
> Thomas Gleixner <tglx@linutronix.de>
>     genirq: Make handle_enforce_irqctx() unconditionally available
>
> Jonathan Kim <jonathan.kim@amd.com>
>     drm/amdgpu: fix gpu recovery disable with per queue reset
>
> Jiang Liu <gerry@linux.alibaba.com>
>     drm/amdgpu: tear down ttm range manager for doorbell in amdgpu_ttm_fi=
ni()
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     drm/amdgpu: Fix shift type in amdgpu_debugfs_sdma_sched_mask_set()
>
> Hermes Wu <hermes.wu@ite.com.tw>
>     drm/bridge: it6505: Change definition of AUX_FIFO_MAX_SIZE
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/mdp4: correct LCDC regulator name
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm: don't clean up priv->kms prematurely
>
> Sui Jingfeng <sui.jingfeng@linux.dev>
>     drm/msm: Check return value of of_dma_configure()
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: link DSPP_2/_3 blocks on X1E80100
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: link DSPP_2/_3 blocks on SM8650
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: link DSPP_2/_3 blocks on SM8550
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: link DSPP_2/_3 blocks on SM8350
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: link DSPP_2/_3 blocks on SM8250
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: link DSPP_2/_3 blocks on SC8180X
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: link DSPP_2/_3 blocks on SM8150
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: provide DSPP and correct LM config for SDM670
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized
>
> Neil Armstrong <neil.armstrong@linaro.org>
>     OPP: add index check to assert to avoid buffer overflow in _read_freq=
()
>
> Karol Przybylski <karprzy7@gmail.com>
>     drm/amdgpu: Fix potential integer overflow in scheduler mask calculat=
ions
>
> Bokun Zhang <bokun.zhang@amd.com>
>     drm/amdgpu/vcn: reset fw_shared under SRIOV
>
> Min-Hua Chen <minhuadotchen@gmail.com>
>     drm/rockchip: vop2: include rockchip_drm_drv.h
>
> Andy Yan <andy.yan@rock-chips.com>
>     drm/rockchip: vop2: Add check for 32 bpp format for rk3588
>
> Andy Yan <andy.yan@rock-chips.com>
>     drm/rockchip: vop2: Check linear format for Cluster windows on rk3566=
/8
>
> Andy Yan <andy.yan@rock-chips.com>
>     drm/rockchip: vop2: Setup delay cycle for Esmart2/3
>
> Andy Yan <andy.yan@rock-chips.com>
>     drm/rockchip: vop2: Set AXI id for rk3588
>
> Derek Foreman <derek.foreman@collabora.com>
>     drm/connector: Allow clearing HDMI infoframes
>
> John Ogness <john.ogness@linutronix.de>
>     printk: Defer legacy printing when holding printk_cpu_sync
>
> Andy Yan <andy.yan@rock-chips.com>
>     drm/rockchip: vop2: Fix the windows switch between different layers
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
>     drm/msm/dpu: check dpu_plane_atomic_print_state() for valid sspp
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
>     drm/msm/dp: disable the opp table request even for dp_ctrl_off_link()
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
>     drm/msm/dp: dont call dp_catalog_ctrl_mainlink_ctrl in dp_ctrl_config=
ure_source_params()
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
>     drm/msm/dp: do not touch the MMSS_DP_INTF_CONFIG for tpg
>
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Preserve the result returned by panthor_fw_resume()
>
> Andy Yan <andy.yan@rock-chips.com>
>     drm/rockchip: vop2: Fix the mixer alpha setup for layer 0
>
> Andy Yan <andy.yan@rock-chips.com>
>     drm/rockchip: vop2: Fix cluster windows alpha ctrl regsiters offset
>
> Ivan Stepchenko <sid@itb.spb.ru>
>     drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_sm=
c_sclk_range_table
>
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>     drm/amd/pm: Fix an error handling path in vega10_enable_se_edc_force_=
stall_config()
>
> Sui Jingfeng <sui.jingfeng@linux.dev>
>     drm/etnaviv: Fix page property being used for non writecombine buffer=
s
>
> Rex Nie <rex.nie@jaguarmicro.com>
>     drm/msm/hdmi: simplify code in pll_get_integloop_gain
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     dt-bindings: display/msm: qcom,sa8775p-mdss: fix the example
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dp: fix msm_dp_utils_pack_sdp_header interface
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dp: set safe_to_exit_level before printing it
>
> Heiko Stuebner <heiko.stuebner@cherry.de>
>     drm/rockchip: vop2: fix rk3588 dp+dsi maxclk verification
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     drm/i915: Grab intel_display from the encoder to avoid potential oops=
ies
>
> Ma=C3=ADra Canal <mcanal@igalia.com>
>     drm/v3d: Fix performance counter source settings on V3D 7.x
>
> Chengming Zhou <chengming.zhou@linux.dev>
>     psi: Fix race when task wakes up before psi_sched_switch() adjusts fl=
ags
>
> K Prateek Nayak <kprateek.nayak@amd.com>
>     x86/topology: Use x86_sched_itmt_flags for PKG domain unconditionally
>
> Tianchen Ding <dtcccc@linux.alibaba.com>
>     sched: Fix race between yield_to() and try_to_wake_up()
>
> Peter Zijlstra <peterz@infradead.org>
>     sched/fair: Fix value reported by hot tasks pulled in /proc/schedstat
>
> Peter Zijlstra <peterz@infradead.org>
>     sched/fair: Untangle NEXT_BUDDY and pick_next_task()
>
> Yabin Cui <yabinc@google.com>
>     perf/core: Save raw sample data conditionally based on sample type
>
> John Garry <john.g.garry@oracle.com>
>     block: Ensure start sector is aligned for stacking atomic writes
>
> David Howells <dhowells@redhat.com>
>     afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call
>
> Jens Axboe <axboe@kernel.dk>
>     nvme: fix bogus kzalloc() return check in nvme_init_effects_log()
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     select: Fix unbalanced user_access_end()
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: subpage: fix the bitmap dump of the locked flags
>
> Randy Dunlap <rdunlap@infradead.org>
>     partitions: ldm: remove the initial kernel-doc notation
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: improve the warning and error message for btrfs_remove_qgroup(=
)
>
> Keisuke Nishimura <keisuke.nishimura@inria.fr>
>     nvme: Add error path for xa_store in nvme_init_effects
>
> Michael Ellerman <mpe@ellerman.id.au>
>     selftests/powerpc: Fix argument order to timer_sub()
>
> Gaurav Batra <gbatra@linux.ibm.com>
>     powerpc/pseries/iommu: IOMMU incorrectly marks MMIO range in DDW
>
> Keisuke Nishimura <keisuke.nishimura@inria.fr>
>     nvme: Add error check for xa_store in nvme_get_effects_log
>
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-tcp: Fix I/O queue cpu spreading for multiple controllers
>
> Christoph Hellwig <hch@lst.de>
>     block: fix queue freeze vs limits lock order in sysfs store methods
>
> Christoph Hellwig <hch@lst.de>
>     block: add a store_limit operations for sysfs entries
>
> Christoph Hellwig <hch@lst.de>
>     block: add a queue_limits_commit_update_frozen helper
>
> Christoph Hellwig <hch@lst.de>
>     block: don't update BLK_FEAT_POLL in __blk_mq_update_nr_hw_queues
>
> Christoph Hellwig <hch@lst.de>
>     block: check BLK_FEAT_POLL under q_usage_count
>
> Eugen Hristev <eugen.hristev@linaro.org>
>     pstore/blk: trivial typo fixes
>
> Yu Kuai <yukuai3@huawei.com>
>     nbd: don't allow reconnect after disconnect
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     ps3disk: Do not use dev->bounce_size before it is set
>
> Yang Erkun <yangerkun@huawei.com>
>     block: retry call probe after request_module in blk_request_module
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: prevent reg-wait speculations
>
> Christoph Hellwig <hch@lst.de>
>     block: copy back bounce buffer to user-space correctly in case of spl=
it
>
> Jinliang Zheng <alexjlzheng@gmail.com>
>     fs: fix proc_handler for sysctl_nr_open
>
> David Howells <dhowells@redhat.com>
>     afs: Fix cleanup of immediately failed async calls
>
> David Howells <dhowells@redhat.com>
>     afs: Fix directory format encoding struct
>
> David Howells <dhowells@redhat.com>
>     afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY
>
> Alexander Aring <aahringo@redhat.com>
>     dlm: fix srcu_read_lock() return type to int
>
> Alexander Aring <aahringo@redhat.com>
>     dlm: fix removal of rsb struct that is master and dir record
>
> Sourabh Jain <sourabhjain@linux.ibm.com>
>     powerpc/book3s64/hugetlb: Fix disabling hugetlb when fadump is active
>
> Kees Cook <kees@kernel.org>
>     coredump: Do not lock during 'comm' reporting
>
>
> -------------
>
> Diffstat:
>
>  .../bindings/display/msm/qcom,sa8775p-mdss.yaml    |   3 +-
>  .../bindings/leds/leds-class-multicolor.yaml       |   2 +-
>  .../devicetree/bindings/mfd/rohm,bd71815-pmic.yaml |  20 +--
>  .../devicetree/bindings/mmc/mmc-controller.yaml    |   2 +-
>  .../bindings/regulator/mt6315-regulator.yaml       |   6 -
>  Documentation/driver-api/crypto/iaa/iaa-crypto.rst |   9 +-
>  Makefile                                           |   4 +-
>  .../dts/aspeed/aspeed-bmc-facebook-yosemite4.dts   |  24 ++-
>  .../boot/dts/intel/socfpga/socfpga_arria10.dtsi    |   6 +-
>  arch/arm/boot/dts/mediatek/mt7623.dtsi             |   2 +-
>  .../boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts |   1 +
>  .../boot/dts/microchip/at91-sama5d29_curiosity.dts |   1 +
>  arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi          |   1 +
>  arch/arm/boot/dts/st/stm32mp13xx-dhcor-som.dtsi    |  16 +-
>  arch/arm/boot/dts/st/stm32mp151.dtsi               |   2 +-
>  arch/arm/boot/dts/st/stm32mp15xx-dhcom-drc02.dtsi  |  12 --
>  arch/arm/boot/dts/st/stm32mp15xx-dhcom-pdk2.dtsi   |  10 --
>  .../arm/boot/dts/st/stm32mp15xx-dhcom-picoitx.dtsi |  10 --
>  arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi    |   7 +
>  arch/arm/mach-at91/pm.c                            |  31 ++--
>  arch/arm/mach-omap1/board-nokia770.c               |   2 +-
>  arch/arm64/boot/dts/freescale/imx93.dtsi           |   2 +-
>  arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts |   4 +-
>  arch/arm64/boot/dts/mediatek/mt7988a.dtsi          |   3 +
>  arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi       |  29 +---
>  arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |  25 +--
>  .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |   4 +
>  .../dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts    |  15 ++
>  .../dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi  |  15 ++
>  .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |   2 -
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   3 +-
>  arch/arm64/boot/dts/mediatek/mt8186.dtsi           |   8 +-
>  arch/arm64/boot/dts/mediatek/mt8188.dtsi           |   2 +-
>  arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   3 -
>  arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |   2 -
>  arch/arm64/boot/dts/mediatek/mt8195-demo.dts       |   9 --
>  arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   5 +-
>  arch/arm64/boot/dts/mediatek/mt8365.dtsi           |   3 +-
>  .../boot/dts/mediatek/mt8395-genio-1200-evk.dts    |   2 -
>  .../boot/dts/mediatek/mt8395-radxa-nio-12l.dts     |   2 -
>  arch/arm64/boot/dts/mediatek/mt8516.dtsi           |  11 +-
>  arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   2 -
>  arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   2 +-
>  arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
>  arch/arm64/boot/dts/qcom/msm8939.dtsi              |   2 +-
>  arch/arm64/boot/dts/qcom/msm8994.dtsi              |  11 +-
>  arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts |   2 +-
>  arch/arm64/boot/dts/qcom/msm8996.dtsi              |   9 +-
>  arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts   |   2 -
>  arch/arm64/boot/dts/qcom/qcs404.dtsi               |   2 +-
>  arch/arm64/boot/dts/qcom/qcs8550-aim300.dtsi       |   2 +-
>  arch/arm64/boot/dts/qcom/qdu1000-idp.dts           |   2 +-
>  arch/arm64/boot/dts/qcom/qrb4210-rb2.dts           |   2 +-
>  arch/arm64/boot/dts/qcom/qru1000-idp.dts           |   2 +-
>  arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi         |   2 +-
>  arch/arm64/boot/dts/qcom/sa8775p.dtsi              |  32 +++-
>  .../arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi |   4 +-
>  .../dts/qcom/sc7180-trogdor-quackingstick.dtsi     |   1 +
>  arch/arm64/boot/dts/qcom/sc7180.dtsi               |  18 +--
>  arch/arm64/boot/dts/qcom/sc7280.dtsi               |   2 +-
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |  46 +++---
>  .../qcom/sdm845-db845c-navigation-mezzanine.dtso   |  42 -----
>  arch/arm64/boot/dts/qcom/sdm845.dtsi               |  20 +--
>  arch/arm64/boot/dts/qcom/sdx75.dtsi                |   2 +-
>  arch/arm64/boot/dts/qcom/sm4450.dtsi               |   2 +-
>  arch/arm64/boot/dts/qcom/sm6125.dtsi               |   2 +-
>  arch/arm64/boot/dts/qcom/sm6375.dtsi               |   2 +-
>  arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |   2 +-
>  .../boot/dts/qcom/sm8150-microsoft-surface-duo.dts |   4 +-
>  arch/arm64/boot/dts/qcom/sm8250.dtsi               |  30 ++--
>  arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
>  arch/arm64/boot/dts/qcom/sm8450.dtsi               |   2 +-
>  arch/arm64/boot/dts/qcom/sm8550-hdk.dts            |   2 +-
>  arch/arm64/boot/dts/qcom/sm8550-mtp.dts            |   2 +-
>  arch/arm64/boot/dts/qcom/sm8550-qrd.dts            |   2 +-
>  arch/arm64/boot/dts/qcom/sm8550-samsung-q5q.dts    |   2 +-
>  .../dts/qcom/sm8550-sony-xperia-yodo-pdx234.dts    |   2 +-
>  arch/arm64/boot/dts/qcom/sm8650-hdk.dts            |   2 +-
>  arch/arm64/boot/dts/qcom/sm8650-mtp.dts            |   2 +-
>  arch/arm64/boot/dts/qcom/sm8650-qrd.dts            |   2 +-
>  arch/arm64/boot/dts/qcom/sm8650.dtsi               |   6 +-
>  .../boot/dts/qcom/x1e80100-microsoft-romulus.dtsi  |   4 +-
>  arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   2 +-
>  arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi   |   5 -
>  arch/arm64/boot/dts/renesas/rzg3s-smarc.dtsi       |   7 +-
>  arch/arm64/boot/dts/rockchip/rk3308-rock-s0.dts    |  25 ++-
>  .../boot/dts/rockchip/rk3568-wolfvision-pf5.dts    |   2 +-
>  .../boot/dts/rockchip/rk3588-edgeble-neu6a-io.dtsi |  95 +++++++----
>  arch/arm64/boot/dts/ti/Makefile                    |   6 +-
>  arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   1 -
>  arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   1 -
>  ...-pcie.dtso =3D> k3-am642-hummingboard-t-pcie.dts} |  14 +-
>  ...-usb3.dtso =3D> k3-am642-hummingboard-t-usb3.dts} |  13 +-
>  arch/arm64/configs/defconfig                       |   1 -
>  arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
>  arch/hexagon/kernel/traps.c                        |   4 +-
>  arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
>  arch/loongarch/include/asm/loongarch.h             |  60 +++++++
>  arch/loongarch/kernel/hw_breakpoint.c              |  16 +-
>  arch/loongarch/power/platform.c                    |   2 +-
>  arch/powerpc/include/asm/hugetlb.h                 |   9 ++
>  arch/powerpc/kernel/iommu.c                        |   2 +-
>  arch/powerpc/platforms/pseries/iommu.c             |  12 +-
>  arch/riscv/kernel/vector.c                         |   2 +-
>  arch/s390/Kconfig                                  |   1 +
>  arch/s390/Makefile                                 |   2 +-
>  arch/s390/boot/vmem.c                              |  74 ++++++---
>  arch/s390/include/asm/sclp.h                       |   1 +
>  arch/s390/kernel/perf_cpum_cf.c                    |   2 +-
>  arch/s390/kernel/perf_pai_crypto.c                 |   2 +-
>  arch/s390/kernel/perf_pai_ext.c                    |   2 +-
>  arch/s390/kernel/setup.c                           |   5 +
>  arch/s390/purgatory/Makefile                       |   2 +-
>  arch/x86/events/amd/ibs.c                          |   2 +-
>  arch/x86/include/asm/kvm_host.h                    |   2 +-
>  arch/x86/kernel/smpboot.c                          |  11 +-
>  arch/x86/kvm/lapic.c                               |  11 +-
>  arch/x86/kvm/vmx/vmx.c                             |   2 +-
>  arch/x86/kvm/vmx/x86_ops.h                         |   2 +-
>  block/bio-integrity.c                              |  15 +-
>  block/blk-core.c                                   |  21 +--
>  block/blk-integrity.c                              |   4 +-
>  block/blk-mq.c                                     |  34 ++--
>  block/blk-mq.h                                     |   6 +
>  block/blk-settings.c                               |  31 +++-
>  block/blk-sysfs.c                                  | 137 ++++++++-------=
-
>  block/blk-zoned.c                                  |   7 +-
>  block/genhd.c                                      |  22 ++-
>  block/partitions/ldm.h                             |   2 +-
>  crypto/algapi.c                                    |   4 +-
>  drivers/acpi/acpica/achware.h                      |   2 -
>  drivers/acpi/fan_core.c                            |  10 +-
>  drivers/base/class.c                               |   9 +-
>  drivers/block/nbd.c                                |   1 +
>  drivers/block/ps3disk.c                            |   4 +-
>  drivers/block/virtio_blk.c                         |   4 +-
>  drivers/bluetooth/btbcm.c                          |   3 +
>  drivers/bluetooth/btnxpuart.c                      |   3 +-
>  drivers/bluetooth/btrtl.c                          |   4 +-
>  drivers/bluetooth/btusb.c                          |   7 +
>  drivers/char/ipmi/ipmb_dev_int.c                   |   3 +
>  drivers/char/ipmi/ssif_bmc.c                       |   5 +-
>  drivers/clk/analogbits/wrpll-cln28hpc.c            |   2 +-
>  drivers/clk/clk.c                                  |   4 +-
>  drivers/clk/imx/clk-imx8mp.c                       |   5 +-
>  drivers/clk/imx/clk-imx93.c                        |  32 ++--
>  drivers/clk/mmp/clk-pxa1908-apbc.c                 |   4 +-
>  drivers/clk/mmp/clk-pxa1908-apbcp.c                |   4 +-
>  drivers/clk/mmp/clk-pxa1908-mpmu.c                 |   4 +-
>  drivers/clk/qcom/camcc-x1e80100.c                  |   7 +
>  drivers/clk/qcom/gcc-sdm845.c                      |  32 ++--
>  drivers/clk/qcom/gcc-x1e80100.c                    |   2 +-
>  drivers/clk/ralink/clk-mtmips.c                    |   1 -
>  drivers/clk/renesas/renesas-cpg-mssr.c             |   2 +-
>  drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |  13 +-
>  drivers/clk/thead/clk-th1520-ap.c                  |  13 +-
>  drivers/cpufreq/acpi-cpufreq.c                     |  36 +++--
>  drivers/cpufreq/amd-pstate.c                       |   2 +-
>  drivers/cpufreq/qcom-cpufreq-hw.c                  |  34 ++--
>  drivers/crypto/caam/blob_gen.c                     |   3 +-
>  drivers/crypto/hisilicon/sec2/sec.h                |   3 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c         | 157 +++++++++------=
---
>  drivers/crypto/hisilicon/sec2/sec_crypto.h         |  11 --
>  drivers/crypto/intel/iaa/iaa_crypto_main.c         |   2 +-
>  drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c        |   3 +
>  drivers/crypto/tegra/tegra-se-aes.c                |   7 +-
>  drivers/crypto/tegra/tegra-se-hash.c               |   7 +-
>  drivers/dma/ti/edma.c                              |   3 +-
>  drivers/firewire/device-attribute-test.c           |   2 +
>  drivers/firmware/efi/sysfb_efi.c                   |   2 +-
>  drivers/firmware/qcom/qcom_scm.c                   |  42 +++--
>  drivers/gpio/gpio-mxc.c                            |   3 +-
>  drivers/gpio/gpio-pca953x.c                        |   3 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c  |   6 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   8 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c           |   4 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   1 +
>  drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   2 +
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
>  .../gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c   |   3 +
>  .../gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c |  10 +-
>  .../gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.h |   2 +
>  .../gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c |   1 +
>  .../drm/amd/display/dc/hubp/dcn201/dcn201_hubp.c   |   1 +
>  .../gpu/drm/amd/display/dc/hubp/dcn21/dcn21_hubp.c |   3 +
>  .../gpu/drm/amd/display/dc/hubp/dcn30/dcn30_hubp.c |   3 +
>  .../gpu/drm/amd/display/dc/hubp/dcn31/dcn31_hubp.c |   1 +
>  .../gpu/drm/amd/display/dc/hubp/dcn32/dcn32_hubp.c |   1 +
>  .../gpu/drm/amd/display/dc/hubp/dcn35/dcn35_hubp.c |   1 +
>  .../drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c   |   3 +-
>  .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |   2 +
>  .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |   2 +
>  drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h       |   2 +
>  .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   2 +
>  .../drm/amd/pm/powerplay/hwmgr/vega10_powertune.c  |   5 +-
>  drivers/gpu/drm/bridge/ite-it6505.c                |   2 +-
>  drivers/gpu/drm/display/drm_hdmi_state_helper.c    |   8 +
>  drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  16 +-
>  drivers/gpu/drm/i915/display/intel_crt.c           |  10 +-
>  drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   8 +-
>  .../drm/msm/disp/dpu1/catalog/dpu_10_0_sm8650.h    |   2 +
>  .../gpu/drm/msm/disp/dpu1/catalog/dpu_4_1_sdm670.h |  54 ++++++-
>  .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h |   2 +
>  .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |   2 +
>  .../gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h |   2 +
>  .../gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h |   2 +
>  .../gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h |   2 +
>  .../drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h   |   2 +
>  drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |  15 +-
>  drivers/gpu/drm/msm/disp/mdp4/mdp4_lcdc_encoder.c  |   2 +-
>  drivers/gpu/drm/msm/dp/dp_audio.c                  |   2 +-
>  drivers/gpu/drm/msm/dp/dp_catalog.c                |   1 -
>  drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +-
>  drivers/gpu/drm/msm/dp/dp_utils.c                  |  10 +-
>  drivers/gpu/drm/msm/dp/dp_utils.h                  |   2 +-
>  drivers/gpu/drm/msm/hdmi/hdmi_phy_8998.c           |   2 +-
>  drivers/gpu/drm/msm/msm_kms.c                      |   1 -
>  drivers/gpu/drm/panthor/panthor_device.c           |   4 +-
>  drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       | 115 ++++++++++---
>  drivers/gpu/drm/rockchip/rockchip_drm_vop2.h       |  10 ++
>  drivers/gpu/drm/rockchip/rockchip_vop2_reg.c       |  26 ++-
>  drivers/gpu/drm/v3d/v3d_debugfs.c                  |   4 +-
>  drivers/gpu/drm/v3d/v3d_perfmon.c                  |  15 +-
>  drivers/gpu/drm/v3d/v3d_regs.h                     |  29 ++--
>  drivers/hid/hid-core.c                             |   2 +
>  drivers/hid/hid-input.c                            |  37 ++---
>  drivers/hid/hid-multitouch.c                       |   2 +-
>  drivers/hid/hid-thrustmaster.c                     |   8 +
>  drivers/hwmon/Kconfig                              |   4 +-
>  drivers/hwmon/nct6775-core.c                       |   6 +-
>  drivers/i2c/busses/i2c-designware-common.c         |   5 +-
>  drivers/i2c/busses/i2c-designware-master.c         |   5 +-
>  drivers/i2c/busses/i2c-designware-slave.c          |   5 +-
>  drivers/i3c/master/dw-i3c-master.c                 |   1 +
>  drivers/infiniband/hw/Makefile                     |   2 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   7 +-
>  drivers/infiniband/hw/cxgb4/device.c               |   6 +-
>  drivers/infiniband/hw/cxgb4/qp.c                   |   8 +
>  drivers/infiniband/hw/hns/Kconfig                  |  20 +--
>  drivers/infiniband/hw/hns/Makefile                 |   9 +-
>  drivers/infiniband/hw/mlx4/main.c                  |   8 +-
>  drivers/infiniband/hw/mlx5/odp.c                   |  62 +++++---
>  drivers/infiniband/sw/rxe/rxe_param.h              |   2 +-
>  drivers/infiniband/sw/rxe/rxe_pool.c               |  11 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.c              |   5 +-
>  drivers/infiniband/ulp/rtrs/rtrs.c                 |   3 +
>  drivers/infiniband/ulp/srp/ib_srp.c                |   1 -
>  drivers/iommu/amd/amd_iommu.h                      |   5 +-
>  drivers/iommu/amd/init.c                           |  14 +-
>  drivers/iommu/amd/iommu.c                          | 132 +++++----------
>  drivers/iommu/amd/pasid.c                          |   3 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  17 +-
>  drivers/iommu/intel/pasid.c                        |  22 ++-
>  drivers/iommu/intel/pasid.h                        |   6 +
>  drivers/iommu/iommufd/iova_bitmap.c                |   2 +-
>  drivers/iommu/iommufd/main.c                       |   2 +-
>  drivers/iommu/riscv/iommu.c                        |   2 +-
>  drivers/leds/leds-cht-wcove.c                      |   6 +-
>  drivers/leds/leds-netxbig.c                        |   1 +
>  drivers/mailbox/mailbox-mpfs.c                     |   2 +-
>  drivers/mailbox/mailbox-th1520.c                   |   6 +-
>  drivers/md/md-bitmap.c                             |  79 +++++----
>  drivers/md/md-bitmap.h                             |   7 +-
>  drivers/md/md.c                                    |  34 ++++
>  drivers/md/md.h                                    |   5 +
>  drivers/md/raid1.c                                 |  34 +---
>  drivers/md/raid1.h                                 |   1 -
>  drivers/md/raid10.c                                |  26 +--
>  drivers/md/raid10.h                                |   1 -
>  drivers/md/raid5-cache.c                           |   4 -
>  drivers/md/raid5.c                                 | 111 ++++++-------
>  drivers/md/raid5.h                                 |   4 -
>  drivers/media/i2c/imx290.c                         |   3 +-
>  drivers/media/i2c/imx412.c                         |  42 ++---
>  drivers/media/i2c/ov9282.c                         |   2 +-
>  drivers/media/platform/marvell/mcam-core.c         |   7 +-
>  drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   7 +-
>  .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   3 +
>  .../media/platform/samsung/exynos4-is/mipi-csis.c  |  10 +-
>  .../media/platform/samsung/s3c-camif/camif-core.c  |  13 +-
>  drivers/media/rc/iguanair.c                        |   4 +-
>  drivers/media/usb/dvb-usb-v2/af9035.c              |  18 ++-
>  drivers/media/usb/dvb-usb-v2/lmedm04.c             |  12 +-
>  drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
>  drivers/media/usb/uvc/uvc_status.c                 |   4 +
>  drivers/memory/tegra/tegra20-emc.c                 |   8 +-
>  drivers/mfd/syscon.c                               |  19 +--
>  drivers/misc/cardreader/rtsx_usb.c                 |  15 ++
>  drivers/mtd/hyperbus/hbmc-am654.c                  |  19 ++-
>  drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   5 +
>  drivers/mtd/ubi/ubi.h                              |   2 -
>  drivers/mtd/ubi/wl.c                               |  21 ---
>  drivers/net/bonding/bond_main.c                    |  19 +--
>  drivers/net/ethernet/broadcom/bgmac.h              |   3 +-
>  drivers/net/ethernet/davicom/dm9000.c              |   3 +-
>  drivers/net/ethernet/freescale/fec_main.c          |  31 +++-
>  drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  15 ++
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +
>  drivers/net/ethernet/intel/iavf/iavf_main.c        |  19 ++-
>  drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   1 -
>  drivers/net/ethernet/intel/ice/ice_ethtool.c       |   1 -
>  drivers/net/ethernet/intel/ice/ice_ethtool.h       |   1 -
>  drivers/net/ethernet/intel/ice/ice_parser.h        |   6 +-
>  drivers/net/ethernet/intel/ice/ice_parser_rt.c     |  12 +-
>  drivers/net/ethernet/intel/idpf/idpf_controlq.c    |   6 +
>  drivers/net/ethernet/intel/idpf/idpf_main.c        |  15 +-
>  drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |  14 +-
>  .../net/ethernet/marvell/octeon_ep/octep_main.c    |  10 --
>  .../ethernet/marvell/octeon_ep_vf/octep_vf_main.c  |   8 -
>  drivers/net/ethernet/mediatek/airoha_eth.c         |  37 +++--
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
>  .../mellanox/mlx5/core/steering/hws/definer.c      |   2 +-
>  drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |   2 -
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   8 +-
>  drivers/net/ethernet/renesas/ravb_main.c           |  22 ++-
>  drivers/net/ethernet/renesas/sh_eth.c              |   4 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  30 ++++
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
>  drivers/net/netdevsim/netdevsim.h                  |   1 +
>  drivers/net/netdevsim/udp_tunnels.c                |  23 +--
>  drivers/net/phy/marvell-88q2xxx.c                  |  33 +++-
>  drivers/net/phy/realtek.c                          |  29 ++--
>  drivers/net/tap.c                                  |   6 +-
>  drivers/net/team/team_core.c                       |   7 +
>  drivers/net/tun.c                                  |   6 +-
>  drivers/net/usb/rtl8150.c                          |  22 +++
>  drivers/net/vxlan/vxlan_vnifilter.c                |   5 +
>  drivers/net/wireless/ath/ath11k/dp_rx.c            |   1 +
>  drivers/net/wireless/ath/ath11k/hal_rx.c           |   3 +-
>  drivers/net/wireless/ath/ath12k/mac.c              |  42 ++---
>  drivers/net/wireless/ath/wcn36xx/main.c            |   5 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   2 +
>  drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |  44 +++--
>  drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   9 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  18 ---
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   4 +-
>  drivers/net/wireless/mediatek/mt76/mac80211.c      |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   2 +-
>  .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   2 +-
>  .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   1 +
>  drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   7 +
>  drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   9 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   1 +
>  drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   1 +
>  drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   1 +
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   9 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   6 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/main.c   | 109 +++++++++----
>  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    | 142 +++++++++++----=
--
>  drivers/net/wireless/mediatek/mt76/mt7925/mcu.h    |   5 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |   2 +
>  drivers/net/wireless/mediatek/mt76/mt792x.h        |   7 +-
>  drivers/net/wireless/mediatek/mt76/mt792x_core.c   |   3 +-
>  drivers/net/wireless/mediatek/mt76/mt792x_mac.c    |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  20 +--
>  drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   5 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   3 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  47 ++++--
>  drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   2 +-
>  drivers/net/wireless/mediatek/mt76/usb.c           |   4 +-
>  drivers/net/wireless/microchip/wilc1000/netdev.c   |   2 -
>  drivers/net/wireless/microchip/wilc1000/sdio.c     |   9 +-
>  drivers/net/wireless/microchip/wilc1000/spi.c      |   9 +-
>  drivers/net/wireless/realtek/rtlwifi/base.c        |  13 +-
>  drivers/net/wireless/realtek/rtlwifi/base.h        |   1 -
>  drivers/net/wireless/realtek/rtlwifi/pci.c         |  61 ++-----
>  .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   7 +-
>  .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   4 +-
>  drivers/net/wireless/realtek/rtlwifi/usb.c         |  12 +-
>  drivers/net/wireless/realtek/rtlwifi/wifi.h        |  12 --
>  drivers/net/wireless/realtek/rtw89/chan.c          |  31 +++-
>  drivers/net/wireless/realtek/rtw89/chan.h          |   9 +-
>  drivers/net/wireless/realtek/rtw89/core.c          |  11 +-
>  drivers/net/wireless/realtek/rtw89/core.h          |   3 +
>  drivers/net/wireless/realtek/rtw89/fw.c            |  40 ++++-
>  drivers/net/wireless/realtek/rtw89/mac80211.c      |  12 +-
>  drivers/net/wireless/ti/wlcore/main.c              |  10 +-
>  drivers/nvme/host/core.c                           |  34 +++-
>  drivers/nvme/host/tcp.c                            |  70 ++++++--
>  drivers/of/fdt.c                                   |  10 +-
>  drivers/of/of_reserved_mem.c                       |   3 +-
>  drivers/of/property.c                              |   2 +-
>  drivers/opp/core.c                                 |  57 +++++--
>  drivers/opp/of.c                                   |   4 +-
>  drivers/pci/controller/dwc/pci-imx6.c              |  30 ++--
>  drivers/pci/controller/dwc/pcie-designware-host.c  |   1 +
>  drivers/pci/controller/dwc/pcie-qcom.c             |   2 +
>  drivers/pci/controller/pcie-rcar-ep.c              |   2 +-
>  drivers/pci/controller/pcie-rockchip-ep.c          |   5 +
>  drivers/pci/controller/plda/pcie-microchip-host.c  |  96 +++++++++++
>  drivers/pci/controller/plda/pcie-plda-host.c       |  17 +-
>  drivers/pci/controller/plda/pcie-plda.h            |   6 +-
>  drivers/pci/endpoint/functions/pci-epf-test.c      |   6 +-
>  drivers/pci/endpoint/pci-epc-core.c                |   2 +-
>  drivers/pinctrl/nomadik/pinctrl-nomadik.c          |  35 +++-
>  drivers/pinctrl/pinctrl-amd.c                      |  27 +++-
>  drivers/pinctrl/pinctrl-amd.h                      |   7 +-
>  drivers/pinctrl/samsung/pinctrl-exynos.c           |   3 +-
>  drivers/pinctrl/stm32/pinctrl-stm32.c              |  76 ++++-----
>  drivers/platform/mellanox/mlxbf-pmc.c              |   6 +-
>  drivers/platform/x86/x86-android-tablets/core.c    |   4 +-
>  drivers/platform/x86/x86-android-tablets/lenovo.c  |   4 +-
>  drivers/platform/x86/x86-android-tablets/other.c   |   4 +-
>  drivers/pps/clients/pps-gpio.c                     |   4 +-
>  drivers/pps/clients/pps-ktimer.c                   |   4 +-
>  drivers/pps/clients/pps-ldisc.c                    |   6 +-
>  drivers/pps/clients/pps_parport.c                  |   4 +-
>  drivers/pps/kapi.c                                 |  10 +-
>  drivers/pps/kc.c                                   |  10 +-
>  drivers/pps/pps.c                                  | 127 ++++++++-------
>  drivers/ptp/ptp_chardev.c                          |   4 +
>  drivers/ptp/ptp_ocp.c                              |   2 +-
>  drivers/pwm/core.c                                 |  13 +-
>  drivers/pwm/pwm-stm32-lp.c                         |   8 +-
>  drivers/pwm/pwm-stm32.c                            |   7 +-
>  drivers/regulator/core.c                           |   2 +-
>  drivers/regulator/of_regulator.c                   |  14 +-
>  drivers/remoteproc/mtk_scp.c                       |  12 +-
>  drivers/remoteproc/remoteproc_core.c               |  14 +-
>  drivers/rtc/rtc-loongson.c                         |  13 +-
>  drivers/rtc/rtc-pcf85063.c                         |  11 +-
>  drivers/rtc/rtc-tps6594.c                          |   2 +-
>  drivers/s390/char/sclp.c                           |  12 +-
>  drivers/scsi/mpi3mr/mpi3mr_app.c                   |   8 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c                |   3 +-
>  drivers/scsi/sd.c                                  |  17 +-
>  drivers/scsi/sr.c                                  |   5 +-
>  drivers/soc/atmel/soc.c                            |   2 +-
>  drivers/spi/spi-omap2-mcspi.c                      |  11 +-
>  drivers/spi/spi-zynq-qspi.c                        |  13 +-
>  drivers/staging/media/imx/imx-media-of.c           |   8 +-
>  drivers/staging/media/max96712/max96712.c          |   4 +-
>  drivers/tty/mips_ejtag_fdc.c                       |   4 +-
>  drivers/tty/serial/8250/8250_port.c                |  32 +++-
>  drivers/ufs/core/ufs_bsg.c                         |   1 +
>  drivers/usb/dwc3/core.c                            |  35 ++--
>  drivers/usb/dwc3/dwc3-am62.c                       |   1 +
>  drivers/usb/gadget/function/f_tcm.c                |  14 +-
>  drivers/usb/host/xhci-ring.c                       |   3 +-
>  drivers/usb/typec/tcpm/tcpci.c                     |  13 +-
>  drivers/usb/typec/tcpm/tcpm.c                      |  10 +-
>  drivers/video/fbdev/omap2/omapfb/dss/dss-of.c      |   1 +
>  drivers/watchdog/rti_wdt.c                         |   1 +
>  fs/afs/dir.c                                       |   7 +-
>  fs/afs/internal.h                                  |   9 ++
>  fs/afs/rxrpc.c                                     |  12 +-
>  fs/afs/xdr_fs.h                                    |   2 +-
>  fs/afs/yfsclient.c                                 |   5 +-
>  fs/btrfs/inode.c                                   | 160 ++++++++++++++-=
----
>  fs/btrfs/qgroup.c                                  |  21 ++-
>  fs/btrfs/subpage.c                                 |   6 +-
>  fs/btrfs/subpage.h                                 |  13 ++
>  fs/btrfs/super.c                                   |   2 +-
>  fs/dlm/lock.c                                      |  46 ++++--
>  fs/dlm/lowcomms.c                                  |   3 +-
>  fs/erofs/zdata.c                                   |   3 +-
>  fs/f2fs/dir.c                                      |  53 ++++--
>  fs/f2fs/f2fs.h                                     |   6 +-
>  fs/f2fs/inline.c                                   |   5 +-
>  fs/file_table.c                                    |   2 +-
>  fs/hostfs/hostfs_kern.c                            |  27 +---
>  fs/nfs/localio.c                                   |   4 +-
>  fs/nfs/nfs42proc.c                                 |   2 +-
>  fs/nfs/nfs42xdr.c                                  |   2 +
>  fs/nfs_common/common.c                             |  89 +++++++++--
>  fs/nilfs2/dir.c                                    |  13 +-
>  fs/nilfs2/namei.c                                  |  29 ++--
>  fs/nilfs2/nilfs.h                                  |   4 +-
>  fs/nilfs2/page.c                                   |  31 +++-
>  fs/nilfs2/segment.c                                |   4 +-
>  fs/ocfs2/quota_global.c                            |   5 +
>  fs/pstore/blk.c                                    |   4 +-
>  fs/select.c                                        |   4 +-
>  fs/smb/client/cifsacl.c                            |  25 +--
>  fs/smb/client/cifsproto.h                          |   2 +-
>  fs/smb/client/cifssmb.c                            |   4 +-
>  fs/smb/client/readdir.c                            |   2 +-
>  fs/smb/client/reparse.c                            |  22 ++-
>  fs/smb/client/smb2ops.c                            |   3 +-
>  fs/ubifs/debug.c                                   |  22 +--
>  fs/xfs/xfs_buf.c                                   |   3 +-
>  fs/xfs/xfs_buf_item_recover.c                      |  11 +-
>  fs/xfs/xfs_dquot.c                                 |  12 +-
>  fs/xfs/xfs_notify_failure.c                        | 121 +++++++++-----
>  fs/xfs/xfs_qm_bhv.c                                |  27 ++--
>  include/acpi/acpixf.h                              |   1 +
>  include/dt-bindings/clock/imx93-clock.h            |   1 +
>  include/linux/alloc_tag.h                          |  11 +-
>  include/linux/blkdev.h                             |  23 +--
>  include/linux/btf.h                                |   5 +
>  include/linux/coredump.h                           |   4 +-
>  include/linux/hid.h                                |   1 +
>  include/linux/ieee80211.h                          |  11 +-
>  include/linux/kallsyms.h                           |   2 +-
>  include/linux/mroute_base.h                        |   6 +-
>  include/linux/netdevice.h                          |   2 +-
>  include/linux/nfs_common.h                         |   3 +-
>  include/linux/perf_event.h                         |   6 +
>  include/linux/pps_kernel.h                         |   3 +-
>  include/linux/ptr_ring.h                           |  21 ++-
>  include/linux/pwm.h                                |  17 ++
>  include/linux/sched.h                              |   1 +
>  include/linux/skb_array.h                          |  17 +-
>  include/linux/usb/tcpm.h                           |   3 +-
>  include/net/ax25.h                                 |  10 +-
>  include/net/inetpeer.h                             |  12 +-
>  include/net/netfilter/nf_tables.h                  |   6 +
>  include/net/page_pool/types.h                      |   1 -
>  include/net/pkt_cls.h                              |  13 +-
>  include/net/sch_generic.h                          |   5 +-
>  include/net/xfrm.h                                 |  16 +-
>  include/sound/hdaudio_ext.h                        |  45 ------
>  include/trace/events/afs.h                         |   2 +
>  include/trace/events/rxrpc.h                       |  25 +++
>  io_uring/io_uring.c                                |   1 +
>  io_uring/msg_ring.c                                |   4 +-
>  io_uring/register.c                                |   2 +-
>  io_uring/uring_cmd.c                               |   2 +-
>  kernel/bpf/arena.c                                 |   8 +-
>  kernel/bpf/bpf_local_storage.c                     |   8 +-
>  kernel/bpf/bpf_struct_ops.c                        |  21 +++
>  kernel/bpf/btf.c                                   |   5 -
>  kernel/bpf/helpers.c                               |  18 ++-
>  kernel/events/core.c                               |  35 ++--
>  kernel/events/uprobes.c                            |   4 +
>  kernel/fork.c                                      |  17 +-
>  kernel/irq/internals.h                             |   9 +-
>  kernel/module/main.c                               |   7 +-
>  kernel/padata.c                                    |  45 ++++--
>  kernel/power/hibernate.c                           |   7 +-
>  kernel/printk/internal.h                           |   6 +
>  kernel/printk/printk.c                             |   5 +
>  kernel/printk/printk_safe.c                        |   7 +-
>  kernel/sched/core.c                                |   6 +-
>  kernel/sched/cpufreq_schedutil.c                   |   4 +-
>  kernel/sched/ext.c                                 | 114 +++++++++----
>  kernel/sched/fair.c                                |  21 ++-
>  kernel/sched/features.h                            |   9 ++
>  kernel/sched/stats.h                               |   4 +
>  kernel/sched/syscalls.c                            |   2 +-
>  kernel/trace/bpf_trace.c                           |  13 +-
>  lib/alloc_tag.c                                    |   2 +
>  lib/rhashtable.c                                   |  12 +-
>  mm/memcontrol.c                                    |   7 +-
>  mm/oom_kill.c                                      |   8 +-
>  net/ax25/af_ax25.c                                 |  12 +-
>  net/ax25/ax25_dev.c                                |   4 +-
>  net/ax25/ax25_ip.c                                 |   3 +-
>  net/ax25/ax25_out.c                                |  22 ++-
>  net/ax25/ax25_route.c                              |   2 +
>  net/core/dev.c                                     |  23 ++-
>  net/core/filter.c                                  |   2 +-
>  net/core/page_pool.c                               |   2 +
>  net/core/page_pool_priv.h                          |   2 +
>  net/core/page_pool_user.c                          |  15 +-
>  net/core/sysctl_net_core.c                         |   5 +-
>  net/ethtool/ioctl.c                                |   2 +-
>  net/ethtool/netlink.c                              |   2 +-
>  net/hsr/hsr_forward.c                              |   7 +-
>  net/ipv4/icmp.c                                    |   9 +-
>  net/ipv4/inetpeer.c                                |  31 +---
>  net/ipv4/ip_fragment.c                             |  15 +-
>  net/ipv4/ipmr.c                                    |  28 ++--
>  net/ipv4/ipmr_base.c                               |   9 +-
>  net/ipv4/route.c                                   |  17 +-
>  net/ipv4/tcp_cubic.c                               |   8 +-
>  net/ipv4/tcp_output.c                              |   9 +-
>  net/ipv4/udp.c                                     |  56 +++++++
>  net/ipv6/icmp.c                                    |   6 +-
>  net/ipv6/ip6_output.c                              |   6 +-
>  net/ipv6/ip6mr.c                                   |  28 ++--
>  net/ipv6/ndisc.c                                   |   8 +-
>  net/ipv6/udp.c                                     |  50 ++++++
>  net/mac80211/debugfs_netdev.c                      |   2 +-
>  net/mac80211/driver-ops.h                          |   3 +
>  net/mac80211/rx.c                                  |   1 +
>  net/mptcp/ctrl.c                                   |   4 +-
>  net/mptcp/options.c                                |  13 +-
>  net/mptcp/pm_netlink.c                             |   3 +-
>  net/mptcp/protocol.c                               |   4 +-
>  net/mptcp/protocol.h                               |  30 ++--
>  net/ncsi/ncsi-rsp.c                                |  18 +--
>  net/netfilter/nf_tables_api.c                      |  57 ++++++-
>  net/netfilter/nft_flow_offload.c                   |  16 +-
>  net/netfilter/nft_set_rbtree.c                     |  43 +++++
>  net/rose/af_rose.c                                 |  16 +-
>  net/rose/rose_timer.c                              |  15 ++
>  net/rxrpc/conn_event.c                             |  12 +-
>  net/rxrpc/peer_event.c                             |  16 +-
>  net/rxrpc/peer_object.c                            |  12 +-
>  net/sched/cls_api.c                                |  57 +++----
>  net/sched/cls_bpf.c                                |   2 +
>  net/sched/cls_flower.c                             |   2 +
>  net/sched/cls_matchall.c                           |   2 +
>  net/sched/cls_u32.c                                |   4 +
>  net/sched/sch_api.c                                |   4 +
>  net/sched/sch_generic.c                            |   4 +-
>  net/sched/sch_sfq.c                                |   4 +
>  net/smc/af_smc.c                                   |   2 +-
>  net/smc/smc_rx.c                                   |  37 +++--
>  net/smc/smc_rx.h                                   |   8 +-
>  net/sunrpc/svcsock.c                               |  12 +-
>  net/vmw_vsock/af_vsock.c                           |   5 +
>  net/wireless/scan.c                                |   7 +-
>  net/wireless/tests/scan.c                          |   2 +
>  net/xfrm/xfrm_replay.c                             |  10 +-
>  net/xfrm/xfrm_state.c                              |  93 ++++++++---
>  samples/landlock/sandboxer.c                       |   7 +
>  scripts/Makefile.build                             |   2 +
>  scripts/Makefile.lib                               |  10 +-
>  scripts/Makefile.modinst                           |   2 +-
>  scripts/genksyms/genksyms.c                        |  11 +-
>  scripts/genksyms/genksyms.h                        |   2 +-
>  scripts/genksyms/parse.y                           |  18 ++-
>  scripts/kconfig/confdata.c                         |   6 +-
>  scripts/kconfig/symbol.c                           |   1 +
>  security/landlock/fs.c                             |  11 +-
>  sound/core/seq/Kconfig                             |   4 +-
>  sound/pci/hda/patch_realtek.c                      |   1 +
>  sound/soc/amd/acp/acp-i2s.c                        |   1 +
>  sound/soc/codecs/Makefile                          |   8 +-
>  sound/soc/codecs/da7213.c                          |   2 +
>  sound/soc/intel/avs/apl.c                          |   3 +-
>  sound/soc/intel/avs/cnl.c                          |   1 +
>  sound/soc/intel/avs/core.c                         |  14 +-
>  sound/soc/intel/avs/loader.c                       |   2 +-
>  sound/soc/intel/avs/registers.h                    |  45 ++++++
>  sound/soc/intel/avs/skl.c                          |   1 +
>  sound/soc/intel/avs/topology.c                     |   4 +-
>  sound/soc/intel/boards/sof_sdw.c                   |  47 ++++--
>  sound/soc/mediatek/mt8365/Makefile                 |   2 +-
>  sound/soc/renesas/rz-ssi.c                         |   3 +-
>  sound/soc/rockchip/rockchip_i2s_tdm.c              |  31 +++-
>  sound/soc/sdca/Makefile                            |   2 +-
>  sound/soc/sunxi/sun4i-spdif.c                      |   7 +
>  sound/usb/quirks.c                                 |   2 +
>  tools/bootconfig/main.c                            |   4 +-
>  tools/build/Makefile.feature                       |   7 -
>  tools/build/feature/test-all.c                     |   5 -
>  tools/include/uapi/linux/if_xdp.h                  |   4 +-
>  tools/lib/bpf/btf.c                                |   1 +
>  tools/lib/bpf/btf_relocate.c                       |   2 +-
>  tools/lib/bpf/linker.c                             |  22 +--
>  tools/lib/bpf/usdt.c                               |   2 +-
>  tools/net/ynl/lib/ynl.c                            |   2 +-
>  tools/perf/MANIFEST                                |   1 +
>  tools/perf/Makefile.config                         |  83 ++++++----
>  tools/perf/builtin-inject.c                        |   8 +-
>  tools/perf/builtin-lock.c                          |  66 +++++---
>  tools/perf/builtin-report.c                        |   2 +-
>  tools/perf/builtin-top.c                           |   2 +-
>  tools/perf/builtin-trace.c                         |   6 +-
>  .../perf/tests/shell/lib/perf_json_output_lint.py  |  14 +-
>  tools/perf/tests/shell/stat.sh                     |   6 +-
>  tools/perf/tests/shell/trace_btf_enum.sh           |   8 +-
>  tools/perf/util/annotate.c                         |  76 ++++++++-
>  tools/perf/util/annotate.h                         |  15 +-
>  tools/perf/util/bpf-event.c                        |  10 +-
>  .../util/bpf_skel/augmented_raw_syscalls.bpf.c     |  11 +-
>  tools/perf/util/disasm.c                           |  83 ++--------
>  tools/perf/util/env.c                              |  13 +-
>  tools/perf/util/env.h                              |   4 +-
>  tools/perf/util/expr.c                             |   5 +-
>  tools/perf/util/header.c                           |   8 +-
>  tools/perf/util/machine.c                          |   2 +-
>  tools/perf/util/maps.c                             |   7 +-
>  tools/perf/util/namespaces.c                       |   7 +-
>  tools/perf/util/namespaces.h                       |   3 +-
>  tools/perf/util/stat-display.c                     | 177 +++++++++++----=
------
>  tools/perf/util/symbol.c                           |   9 +-
>  .../cpupower/utils/idle_monitor/mperf_monitor.c    |  15 +-
>  tools/power/x86/turbostat/turbostat.c              |  58 ++++++-
>  tools/testing/ktest/ktest.pl                       |   7 +-
>  tools/testing/selftests/bpf/Makefile               |   4 +-
>  .../testing/selftests/bpf/prog_tests/btf_distill.c |   4 +-
>  .../selftests/bpf/prog_tests/fill_link_info.c      |   4 +
>  .../selftests/bpf/progs/test_fill_link_info.c      |  13 +-
>  tools/testing/selftests/bpf/test_tc_tunnel.sh      |   1 +
>  tools/testing/selftests/bpf/veristat.c             |   1 +
>  tools/testing/selftests/bpf/xdp_hw_metadata.c      |   2 +-
>  .../drivers/net/netdevsim/udp_tunnel_nic.sh        |  16 +-
>  .../ftrace/test.d/00basic/mount_options.tc         |   8 +-
>  tools/testing/selftests/kselftest/ktap_helpers.sh  |   2 +-
>  tools/testing/selftests/kselftest_harness.h        |  24 +--
>  tools/testing/selftests/landlock/Makefile          |   4 +-
>  tools/testing/selftests/landlock/fs_test.c         |   3 +-
>  tools/testing/selftests/mm/Makefile                |   9 +-
>  tools/testing/selftests/net/lib/Makefile           |   2 +-
>  tools/testing/selftests/net/mptcp/Makefile         |   2 +-
>  tools/testing/selftests/net/openvswitch/Makefile   |   2 +-
>  .../selftests/powerpc/benchmarks/gettimeofday.c    |   2 +-
>  tools/testing/selftests/rseq/rseq.c                |  32 +++-
>  tools/testing/selftests/rseq/rseq.h                |   9 +-
>  .../testing/selftests/timers/clocksource-switch.c  |   6 +-
>  699 files changed, 5672 insertions(+), 3241 deletions(-)
>
>
>
