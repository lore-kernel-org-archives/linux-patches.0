Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25254334DB
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784742256; cv=none; b=iCKyuU1LPBpvmM6SckaDxt73C8fba1dg+t2UsEeNFKGQXK2x4T9snwg72Pmp8G8G01gmlAvRu5PZBBE1OlOYdSg+UUNGXrCQbmE+ENZe7/T+j1VuLkyzsxQEzOTpBmTxzSZ4BJcpcku8nO6RhP/g/klmXr//HVcCOaLnj3IA7WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784742256; c=relaxed/simple;
	bh=nFdLOwmvptKK7jcYGuLGDbpwdM9A9bfqJzQIWwQEhaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgVA7xkZIdl45FFvxuGF2cAgFOIurIi9AX4s8tVZCypbI7cL0WE4u8Pxgw+fDhOXwfYxNTfXBxOgrHWKkotwd6KhdZsWHW4GwK8pJfZQTcEjHSzQMOAIoezqyn0MIlxrgv0a8/DpxDfVedorb7yY/wg19K1Wdlu3iv/6Jrp8A/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=f8e5oiuq; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="f8e5oiuq"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7D50011A4E7;
	Wed, 22 Jul 2026 19:43:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784742233;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=o+9+4v0VC9sEeI8/DqN4WqzY710l5RLxHYH3cwXdz3I=;
	b=f8e5oiuq5ZQ3XtZ2p5qA3kcSpeIec/zLBKGXzav1eq1l4s2Q4yEJiJnl+Xu5Sg10azM+8W
	34Roh9lRMGw0aJmqD8R9bJmNImzMnRGYvKbX1myPVS8US9J2gMnMRIkUcGPA6WKWET7q1i
	Yeo0tutNp31BG1NLZZQa037Bc5BykNr1QiEuRh5cKBtEZ+VHq03xWmXV2DIP/jQe5k4u/Q
	noPSlFg1HiFe/QQiJAStl11dL5BHIwPowwmI0BmTcNukoo15R1wn2NT+7P5fbG78JEf721
	oqyAeEF0Gd59Gv1ZQ3LaXNm3sfpFWb933tOMH9L229uX7vdF5YVL+00CFPKeAA==
Date: Wed, 22 Jul 2026 19:43:48 +0200
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
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
Message-ID: <amEBVPth_BoI0ByL@duo.ucw.cz>
References: <20260721152446.065700225@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0R9vQlqvrpDs/ix/"
Content-Disposition: inline
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--0R9vQlqvrpDs/ix/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

>=20
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.97=
-rc1.gz
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
>     Linux 6.12.97-rc1
>=20
> Michael Petlan <mpetlan@redhat.com>
>     perf build-id: Fix off-by-one bug when printing kernel/module build-id
>=20
> Ivan Vecera <ivecera@redhat.com>
>     dpll: fix NULL pointer dereference in dpll_msg_add_pin_ref_sync()
>=20
> Stig Hornang <stig@hornang.me>
>     Bluetooth: L2CAP: fix tx ident leak for commands without a response
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: 6lowpan: Fix using chan->conn as indication to no remote n=
etdev
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: L2CAP: Fix regressions caused by reusing ident
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     perf synthetic-events: Fix stale build ID in module MMAP2 records
>=20
> Guenter Roeck <linux@roeck-us.net>
>     crypto: ccp - Fix leaking the same page twice
>=20
> Mohammad Heib <mheib@redhat.com>
>     ice: drop udp_tunnel_get_rx_info() call from ndo_open()
>=20
> Mohammad Heib <mheib@redhat.com>
>     i40e: drop udp_tunnel_get_rx_info() call from i40e_open()
>=20
> Ian Rogers <irogers@google.com>
>     perf build-id: Ensure snprintf string is empty when size is 0
>=20
> Borislav Petkov (AMD) <bp@alien8.de>
>     crypto: ccp - Always pass in an error pointer to __sev_platform_shutd=
own_locked()
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_sync: Fix attempting to send HCI_Disconnect to BIS han=
dle
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_core: Remove check of BDADDR_ANY in hci_conn_hash_look=
up_big_state
>=20
> Paolo Abeni <pabeni@redhat.com>
>     udp_tunnel: fix deadlock in udp_tunnel_nic_set_port_priv()
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     crypto: ccp - Fix SNP panic notifier unregistration
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     crypto: ccp - Fix dereferencing uninitialized error pointer
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     crypto: ccp - Fix __sev_snp_shutdown_locked
>=20
> Arnaldo Carvalho de Melo <acme@kernel.org>
>     perf libunwind arm64: Fix missing close parens in an if statement
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix afs_dynroot_readdir() to not use the RCU read lock
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix afs_atcell_get_link() to check if ws_cell is unset first
>=20
> Easwar Hariharan <eahariha@linux.microsoft.com>
>     jiffies: Cast to unsigned long in secs_to_jiffies() conversion
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>     net: airoha: Fix channel configuration for ETS Qdisc
>=20
> James Clark <james.clark@linaro.org>
>     perf arm-spe: Use old behavior when opening old SPE files
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     rtnetlink: Make per-netns RTNL dereference helpers to macro.
>=20
> Gil Portnoy <dddhkts1@gmail.com>
>     ksmbd: fix durable reconnect double-bind race in ksmbd_reopen_durable=
_fd
>=20
> Thomas Richter <tmricht@linux.ibm.com>
>     perf callchain: Handle multiple address spaces
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     seqlock: fix scoped_seqlock_read kernel-doc
>=20
> Ian Rogers <irogers@google.com>
>     perf inject: With --convert-callchain ignore the dummy event for dwar=
f stacks
>=20
> Dust Li <dust.li@linux.alibaba.com>
>     dibs: loopback: validate offset and size in move_data()
>=20
> Sandipan Das <sandipan.das@amd.com>
>     perf/x86/amd/brs: Fix kernel address leakage
>=20
> Matt Bobrowski <mattbobrowski@google.com>
>     bpf: Reject BPF_MAP_TYPE_INODE_STORAGE creation if BPF LSM is uniniti=
alized
>=20
> Marc Zyngier <maz@kernel.org>
>     KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax=
_perms()
>=20
> Oliver Upton <oupton@kernel.org>
>     KVM: arm64: Ensure level is always initialized when relaxing perms
>=20
> Marc Zyngier <maz@kernel.org>
>     KVM: Move kvm_io_bus_get_dev() locking responsibilities to callers
>=20
> SeongJae Park <sj@kernel.org>
>     mm/damon/core: always put unsuccessfully committed target pids
>=20
> Amir Goldstein <amir73il@gmail.com>
>     selftests/fs/statmount: build with tools include dir
>=20
> Eric Biggers <ebiggers@kernel.org>
>     fscrypt: Replace mk_users keyring with simple list
>=20
> Eric Biggers <ebiggers@kernel.org>
>     fscrypt: Fix key setup in edge case with multiple data unit sizes
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     slab: recognize @GFP parameter as optional in kernel-doc
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     default_gfp(): avoid using the "newfangled" __VA_OPT__ trick
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     add default_gfp() helper macro and use it in the new *alloc_obj() hel=
pers
>=20
> Kees Cook <kees@kernel.org>
>     slab: Introduce kmalloc_flex() and family
>=20
> Kees Cook <kees@kernel.org>
>     slab: Introduce kmalloc_obj() and family
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: fix incorrect buffered IO fallback for append direct writes
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: fix false IO failure after falling back to buffered write
>=20
> Rochan Avlur <rochan.avlur@gmail.com>
>     exfat: preserve benign secondary entries during rename and move
>=20
> Chi Zhiling <chizhiling@kylinos.cn>
>     exfat: fix incorrect directory checksum after rename to shorter name
>=20
> Yuezhang Mo <Yuezhang.Mo@sony.com>
>     exfat: move exfat_chain_set() out of __exfat_resolve_path()
>=20
> Yuezhang Mo <Yuezhang.Mo@sony.com>
>     exfat: add exfat_get_dentry_set_by_ei() helper
>=20
> Yuezhang Mo <Yuezhang.Mo@sony.com>
>     exfat: rename argument name for exfat_move_file and exfat_rename_file
>=20
> Yuezhang Mo <Yuezhang.Mo@sony.com>
>     exfat: remove unnecessary read entry in __exfat_rename()
>=20
> Ahsan Atta <ahsan.atta@intel.com>
>     crypto: qat - fix restarting state leak on allocation failure
>=20
> Tycho Andersen (AMD) <tycho@kernel.org>
>     crypto: ccp - Do not initialize SNP for ioctl(SNP_CONFIG)
>=20
> Tom Lendacky <thomas.lendacky@amd.com>
>     crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     crypto: ccp - Move SEV/SNP Platform initialization to KVM
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     crypto: ccp - Register SNP panic notifier only if SNP is enabled
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     crypto: ccp - Reset TMR size at SNP Shutdown
>=20
> Ashish Kalra <ashish.kalra@amd.com>
>     crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: check and set EXTENT_DELALLOC_NEW before clearing EXTENT_DELAL=
LOC
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: remove the COW fixup mechanism
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: remove folio parameter from ordered io related functions
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: replace for_each_set_bit() with for_each_set_bitmap()
>=20
> Qu Wenruo <wqu@suse.com>
>     btrfs: concentrate the error handling of submit_one_sector()
>=20
> Neill Kapron <nkapron@google.com>
>     usb: gadget: f_fs: Tie read_buffer lifetime to ffs_epfile
>=20
> Thorsten Blum <thorsten.blum@linux.dev>
>     crypto: atmel-sha204a - fail on hwrng registration error in probe path
>=20
> Tyler Baker <tyler.baker@oss.qualcomm.com>
>     usb: gadget: f_fs: initialize reset_work at allocation time
>=20
> Thorsten Blum <thorsten.blum@linux.dev>
>     crypto: atmel-sha204a - drop hwrng quality reduction for ATSHA204A
>=20
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>
>     crypto: atmel - Drop explicit initialization of struct i2c_device_id:=
:driver_data to 0
>=20
> Mauricio Faria de Oliveira <mfo@igalia.com>
>     usb: atm: ueagle-atm: wait for pre-firmware load in .disconnect()
>=20
> Johan Hovold <johan@kernel.org>
>     USB: iowarrior: fix use-after-free on disconnect race
>=20
> Oliver Neukum <oneukum@suse.com>
>     usb: iowarrior: remove inherent race with minor number
>=20
> Vlad Poenaru <vlad.wing@gmail.com>
>     bpf: Allow LPM map access from sleepable BPF programs
>=20
> Andrii Nakryiko <andrii@kernel.org>
>     bpf: Consistently use bpf_rcu_lock_held() everywhere
>=20
> Luis Gerhorst <luis.gerhorst@fau.de>
>     bpf, arm64, powerpc: Add bpf_jit_bypass_spec_v1/v4()
>=20
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>     bpf: Convert lpm_trie.c to rqspinlock
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     hfs/hfsplus: fix u32 overflow in check_and_correct_requested_length
>=20
> Viacheslav Dubeyko <slava@dubeyko.com>
>     hfs/hfsplus: prevent getting negative values of offset/length
>=20
> Oleg Makarenko <oleg@makarenk.ooo>
>     HID: pidff: Use correct effect type in effect update
>=20
> Tomasz Paku=C5=82a <tomasz.pakula.oficjalny@gmail.com>
>     HID: pidff: Rework pidff_upload_effect
>=20
> Tomasz Paku=C5=82a <tomasz.pakula.oficjalny@gmail.com>
>     HID: pidff: Add missing spaces
>=20
> Tomasz Paku=C5=82a <tomasz.pakula.oficjalny@gmail.com>
>     HID: pidff: Fix missing blank lines after declarations
>=20
> Manish Khadka <maskmemanish@gmail.com>
>     HID: appleir: fix UAF on pending key_up_timer in remove()
>=20
> Thomas Gleixner <tglx@linutronix.de>
>     treewide: Switch/rename to timer_delete[_sync]()
>=20
> Jann Horn <jannh@google.com>
>     proc: protect ptrace_may_access() with exec_update_lock (part 1)
>=20
> Oleg Nesterov <oleg@redhat.com>
>     seqlock: Change do_task_stat() to use scoped_seqlock_read()
>=20
> Peter Zijlstra <peterz@infradead.org>
>     seqlock: Introduce scoped_seqlock_read()
>=20
> Trung Nguyen <trungnh@cystack.net>
>     HID: multitouch: fix out-of-bounds bit access on mt_io_flags
>=20
> Angela Czubak <aczubak@google.com>
>     HID: add haptics page defines
>=20
> Zide Chen <zide.chen@intel.com>
>     perf/x86/intel/uncore: Defer ADL global PMON enable to enable_box()
>=20
> Jann Horn <jannh@google.com>
>     proc: protect ptrace_may_access() with exec_update_lock (FD links)
>=20
> Christoph Hellwig <hch@lst.de>
>     proc: rename proc_setattr to proc_nochmod_setattr
>=20
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: track the connection owning a byte-range lock
>=20
> DaeMyung Kang <charsyam@gmail.com>
>     ksmbd: centralize ksmbd_conn final release to plug transport leak
>=20
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: use opener credentials for FSCTL mutations
>=20
> Davide Ornaghi <d.ornaghi97@gmail.com>
>     ksmbd: fix path resolution in ksmbd_vfs_kern_path_create
>=20
> Jori Koolstra <jkoolstra@xs4all.nl>
>     vfs: make LAST_XXX private to fs/namei.c
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     smb: client: resolve SWN tcon from live registrations
>=20
> Markus Elfring <elfring@users.sourceforge.net>
>     smb: client: Improve unlocking of a mutex in cifs_get_swn_reg()
>=20
> Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
>     mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless =
host
>=20
> Siwei Zhang <oss@fourdim.xyz>
>     Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_new_connection_cb()
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: 6lowpan: fix cyclic locking warning on netdev unregister
>=20
> Siwei Zhang <oss@fourdim.xyz>
>     Bluetooth: hci_conn: Fix null ptr deref in hci_abort_conn()
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: separate CIS_LINK and BIS_LINK link types
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_core: Enable buffer flow control for SCO/eSCO
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     Bluetooth: L2CAP: cancel pending_rx_work before taking conn->lock
>=20
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: L2CAP: Fix not tracking outstanding TX ident
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: ebtables: zero chainstack array
>=20
> Qianfeng Rong <rongqianfeng@vivo.com>
>     netfilter: ebtables: Use vmalloc_array() to improve code
>=20
> Xiaolei Wang <xiaolei.wang@windriver.com>
>     media: nxp: imx8-isi: Fix use-after-free on remove
>=20
> Frank Li <Frank.Li@nxp.com>
>     media: nxp: imx8-isi: use devm_pm_runtime_enable() to simplify code
>=20
> Michael Wigham <michael@wigham.net>
>     io_uring/rw: preserve partial result for iopoll
>=20
> Jens Axboe <axboe@kernel.dk>
>     io_uring/rw: ensure reissue path is correctly handled for IOPOLL
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     gpio: sch: use raw_spinlock_t in the irq startup path
>=20
> Marco Elver <elver@google.com>
>     Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref
>=20
> Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>     crypto: qat - fix VF2PF work teardown race in adf_disable_sriov()
>=20
> Alexandru Hossu <hossu.alexandru@gmail.com>
>     staging: rtl8723bs: fix OOB reads in rtw_get_sec_ie(), rtw_get_wapi_i=
e(), and rtw_get_wps_attr()
>=20
> Nikolay Kulikov <nikolayof23@gmail.com>
>     staging: rtl8723bs: fix spaces around binary operators
>=20
> William Hansen-Baird <william.hansen.baird@gmail.com>
>     staging: rtl8723bs: core: move constants to right side in comparison
>=20
> Marco Nenciarini <mnencia@kcore.it>
>     PCI: Skip Resizable BAR restore on read error
>=20
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     PCI: Move Resizable BAR code to rebar.c
>=20
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     PCI: Fix restoring BARs on BAR resize rollback path
>=20
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     PCI: Free saved list without holding pci_bus_sem
>=20
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     PCI: Prevent resource tree corruption when BAR resize fails
>=20
> Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>     PCI: Use pbus_select_window() during BAR resize
>=20
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>     PCI: mediatek: Fix IRQ domain leak when port fails to enable
>=20
> Christian Marangi <ansuelsmth@gmail.com>
>     PCI: mediatek: Use generic MACRO for TPVPERL delay
>=20
> Christian Marangi <ansuelsmth@gmail.com>
>     PCI: mediatek: Convert bool to single quirks entry and bitmap
>=20
> Nam Cao <namcao@linutronix.de>
>     PCI: mediatek: Switch to msi_create_parent_irq_domain()
>=20
> Jiri Slaby (SUSE) <jirislaby@kernel.org>
>     PCI: controller: Use dev_fwnode() instead of of_fwnode_handle()
>=20
> Mahesh Vaidya <mahesh.vaidya@altera.com>
>     PCI: altera: Fix resource leaks on probe failure
>=20
> Alex Williamson <alex.williamson@nvidia.com>
>     vfio/mlx5: Fix racy bitfields and tighten struct layout
>=20
> Geoffrey D. Bennett <g@b4.vu>
>     ALSA: scarlett2: Update offsets for 2i2 Gen 4 firmware 2417
>=20
> Geoffrey D. Bennett <g@b4.vu>
>     ALSA: scarlett2: Allow selecting config_set by firmware version
>=20
> C=C3=A1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ALSA: hda/cs35l41: Fix firmware load work teardown
>=20
> Zhao Dongdong <zhaodongdong@kylinos.cn>
>     ALSA: aoa: check snd_ctl_new1() return value
>=20
> Biren Pandya <birenpandya@gmail.com>
>     iio: pressure: mpl115: fix runtime PM leak on read error
>=20
> Sakari Ailus <sakari.ailus@linux.intel.com>
>     iio: pressure: Remove redundant pm_runtime_mark_last_busy() calls
>=20
> Samuel Moelius <samuel.moelius@trailofbits.com>
>     iio: adc: ad7380: select REGMAP
>=20
> Zhang Lixu <lixu.zhang@intel.com>
>     iio: hid-sensor-rotation: Fix stale or zero output when reading raw v=
alues
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: NFIT: core: Fix possible deadlock and missing notifications
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: NFIT: core: Use devm_acpi_install_notify_handler()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: bus: Introduce devm_acpi_install_notify_handler()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: driver: Check ACPI_COMPANION() against NULL during probe
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI: NFIT: core: Fix acpi_nfit_init() error cleanup
>=20
> Haoze Xie <royenheart@gmail.com>
>     rust: block: fix GenDisk cleanup paths
>=20
> Sergey Shtylyov <s.shtylyov@auroraos.dev>
>     mmc: sdhci-of-dwcmshc: check bus clock enable result in the probe() m=
ethod
>=20
> Ao Sun <ao.sun@transsion.com>
>     mmc: block: fix RPMB device unregister ordering
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     mtd: rawnand: lpc32xx_slc: fail DMA transfer on completion timeout
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     mtd: rawnand: lpc32xx_mlc: fail DMA transfers on timeout
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     mtd: rawnand: fsl_ifc: return errors for failed page reads
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     mmc: vub300: defer reset until cmd_mutex is unlocked
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     mtd: mchp23k256: use SPI match data for chip caps
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     mtd: onenand: samsung: report DMA completion timeouts
>=20
> Rafael Beims <rafael.beims@toradex.com>
>     wifi: mwifiex: fix permanently busy scans after multiple roam iterati=
ons
>=20
> Zhiling Zou <roxy520tt@gmail.com>
>     wifi: mac80211: free ack status frame on TX header build failure
>=20
> Junrui Luo <moonafterrain@outlook.com>
>     powerpc/spufs: fix out-of-bounds access in spufs_mem_mmap_access()
>=20
> Zhao Dongdong <zhaodongdong@kylinos.cn>
>     reset: sunxi: fix memory region leak on ioremap failure
>=20
> Robby Cai <robby.cai@nxp.com>
>     reset: imx7: Correct polarity of MIPI CSI resets on i.MX8MQ
>=20
> Florian Westphal <fw@strlen.de>
>     ipvs: reload ip header after head reallocation
>=20
> Julian Anastasov <ja@ssi.bg>
>     ipvs: fix more places with wrong ipv6 transport offsets
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     memstick: ms_block: reject a card that reports too many blocks
>=20
> James Raphael Tiovalen <jamestiotio@gmail.com>
>     macsec: fix promiscuity refcount leak in macsec_dev_open()
>=20
> Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>     llc: fix SAP refcount leak when creating incoming sockets
>=20
> Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
>     Bluetooth: btrtl: validate firmware patch bounds
>=20
> Asim Viladi Oglu Manizada <manizada@pm.me>
>     net: openvswitch: reject oversized nested action attrs
>=20
> Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
>     regulator: ltc3676: Fix incorrect IRQSTAT bit offsets
>=20
> Dawei Feng <dawei.feng@seu.edu.cn>
>     wifi: mac80211: fix memory leak in ieee80211_register_hw()
>=20
> Rafael Beims <rafael.beims@toradex.com>
>     wifi: mwifiex: fix roaming to different channel in host_mlme mode
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     wifi: rt2x00: avoid full teardown before work setup in probe
>=20
> Thorsten Blum <thorsten.blum@linux.dev>
>     powerpc/pseries: fix memory leak on krealloc failure in papr_init
>=20
> Thomas Huth <thuth@redhat.com>
>     selftests/landlock: Fix screwed up pointers in the scoped_signal_test
>=20
> Thomas Huth <thuth@redhat.com>
>     selftests/landlock: Skip scoped_signal subtest with MSG_OOB if not av=
ailable
>=20
> Peng Fan <peng.fan@nxp.com>
>     pmdomain: imx: Fix i.MX8MP VC8000E power up sequence
>=20
> Peng Fan <peng.fan@nxp.com>
>     pmdomain: imx: Fix i.MX8MP power notifier
>=20
> Farhad Alemi <farhad.alemi@berkeley.edu>
>     cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
>=20
> Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>     s390/mm: Fix type mismatch in get_align_mask().
>=20
> Crystal Wood <crwood@redhat.com>
>     tracing/osnoise: Call synchronize_rcu() when unregistering
>=20
> Tao Liu <ltao@redhat.com>
>     riscv: Prevent NULL pointer dereference in machine_kexec_prepare()
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     drbd: reject data replies with an out-of-range payload size
>=20
> TJ Adams <tadamsjr@google.com>
>     ata: libata-core: Skip HPA resize for locked drives
>=20
> Jinjie Ruan <ruanjinjie@huawei.com>
>     arm64: smp: Fix hot-unplug tearing by forcing unregistration
>=20
> Daehyeon Ko <4ncienth@gmail.com>
>     macsec: don't read an unset MAC header in macsec_encrypt()
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     ipvs: reset full ip_vs_seq structs in ip_vs_conn_new
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     ipvs: use parsed transport offset in SCTP state lookup
>=20
> Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>     llc: fix SAP refcount leak in llc_ui_autobind()
>=20
> Nirmoy Das <nirmoyd@nvidia.com>
>     selftests: net: make busywait timeout clock portable
>=20
> Yousef Alhouseen <alhouseenyousef@gmail.com>
>     mac802154: remove interfaces with RCU list deletion
>=20
> Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>     s390/monwriter: Reject buffer reuse with different data length
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     irqchip/irq-riscv-imsic-early: Fix fwnode leak on state setup failure
>=20
> Zi Yan <ziy@nvidia.com>
>     mm/compaction: handle free_pages_prepare() properly in compaction_fre=
e()
>=20
> Martin Kaiser <martin@kaiser.cx>
>     riscv: probes: save original sp in rethook trampoline
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     hwmon: (asus_atk0110) Check package count before accessing element
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     net: wwan: iosm: bound device offsets in the MUX downlink decoder
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     ata: pata_pxa: Fix DMA channel leak on probe error
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     orangefs: keep the readdir entry size 64-bit in fill_from_part()
>=20
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
>     tracing/probes: Fix double addition of offset for @+FOFFSET
>=20
> Joshua Crofts <joshua.crofts1@gmail.com>
>     hwmon: (max1619) add missing 'select REGMAP' to Kconfig
>=20
> David Lee <david.lee@trailofbits.com>
>     fhandle: reject detached mounts in capable_wrt_mount()
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     net/sched: sch_taprio: Replace direct dequeue call with peek and qdis=
c_dequeue_peeked
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     net/sched: sch_multiq: Replace direct dequeue call with peek and qdis=
c_dequeue_peeked
>=20
> Andrea Righi <arighi@nvidia.com>
>     net: lan743x: Initialize eth_syslock spinlock before use
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     fsl/fman: Free init resources on KeyGen failure in fman_init()
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     hwmon: (occ) unregister sysfs devices outside occ lock
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     net: liquidio: fix BAR resource leak on PF number failure
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     hwmon: (w83793) remove vrm sysfs file on probe failure
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     hwmon: (w83627hf) remove VID sysfs files on error and remove
>=20
> Conor Dooley <conor.dooley@microchip.com>
>     rtc: mpfs: fix counter upload completion condition
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     bnx2x: fix potential memory leak in bnx2x_alloc_mem_bp()
>=20
> Sabrina Dubroca <sd@queasysnail.net>
>     espintcp: use sk_msg_free_partial to fix partial send
>=20
> Hongchen Zhang <zhanghongchen@loongson.cn>
>     LoongArch: Fix missing dirty page tracking in {pte,pmd}_wrprotect()
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: clean untagged VLAN on netdev registration failure
>=20
> Miguel Ojeda <ojeda@kernel.org>
>     rust: block: `allow(deprecated)` for `fetch_update` for Rust >=3D 1.9=
9.0
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: ensure minimal ethernet header on TX
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: retrieve ethhdr after potential skb realloc on RX
>=20
> Heiko Carstens <hca@linux.ibm.com>
>     s390: Revert support for DCACHE_WORD_ACCESS
>=20
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net/sched: sch_teql: move rcu_read_lock()/spin_lock() from _bh varian=
ts
>=20
> Daniel Gibson <daniel@gibson.sh>
>     platform/x86/amd/pmc: Avoid logging "(null)" for DMI values
>=20
> Shitalkumar Gandhi <shital.gandhi45@gmail.com>
>     ieee802154: ca8210: fix pointer truncation in kfifo on 64-bit
>=20
> Shitalkumar Gandhi <shital.gandhi45@gmail.com>
>     ieee802154: ca8210: fix cas_ctl leak on spi_async failure
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ieee802154: allow legacy LLSEC ADD/DEL ops to pass strict validation
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ieee802154: admin-gate legacy LLSEC dump operations
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     octeontx2-af: Free BPID bitmap on setup failure
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     net: ip6_gre: require CAP_NET_ADMIN in the device netns for changelink
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     net: ipip: require CAP_NET_ADMIN in the device netns for changelink
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     net: ip_vti: require CAP_NET_ADMIN in the device netns for changelink
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     net: ip6_vti: require CAP_NET_ADMIN in the device netns for changelink
>=20
> Dawei Feng <dawei.feng@seu.edu.cn>
>     net: ena: clean up XDP TX queues when regular TX setup fails
>=20
> Zihan Xi <xizh2024@lzu.edu.cn>
>     net/sched: act_ct: preserve tc_skb_cb across defragmentation
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     net: ixp4xx_hss: fix duplicate HDLC netdev allocation
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     net: wwan: t7xx: destroy DMA pool on CLDMA late init failure
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     net: sit: require CAP_NET_ADMIN in the device netns for changelink
>=20
> Andreas Kemnade <andreas@kemnade.info>
>     gpios: palmas: add .get_direction() op
>=20
> Paul Louvel <paul.louvel@bootlin.com>
>     gpio-f7188x: Add support for NCT6126D version B
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     gpio: tegra: do not call pinctrl for GPIO direction
>=20
> Bradley Morgan <include@grrlz.net>
>     cpu: hotplug: Bound hotplug states sysfs output
>=20
> Bradley Morgan <include@grrlz.net>
>     cpu: hotplug: Preserve per instance callback errors
>=20
> Cao Ruichuang <create0818@163.com>
>     selftests/ftrace: Drop invalid top-level local in test_ownership
>=20
> Zhan Xusheng <zhanxusheng1024@gmail.com>
>     posix-cpu-timers: Use u64 multiplication in update_rlimit_cpu()
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     tracing/user_events: Fix use-after-free in user_event_mm_dup()
>=20
> Doruk Tan Ozturk <doruk@0sec.ai>
>     net/mlx5e: macsec: fix use-after-free of metadata_dst on RX SC delete
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - fix type confusion in CDC union descriptor parsing
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - fix race condition in reset_device sysfs callback
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - fix potential infinite loop in CDC union descriptor =
parsing
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - fix out-of-bounds read in ims_pcu_irq() debug logging
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - fix firmware leak in async update
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - fix DMA mapping violation in line setup
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - add response length checks
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - validate control endpoint type
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - release data interface on disconnect
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - only expose sysfs attributes on control interface
>=20
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Input: ims-pcu - fix use-after-free and double-free in disconnect
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     scsi: elx: efct: Fix I/O leak on unsupported additional CDB
>=20
> WenTao Liang <vulab@iscas.ac.cn>
>     scsi: elx: efct: Fix refcount leak in efct_hw_io_abort()
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     scsi: target: core: Fix iSCSI ISID use-after-free in REGISTER AND MOVE
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     scsi: target: Bound PR-OUT TransportID parsing to the received buffer
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     scsi: xen: scsiback: Free unsubmitted command instead of double-putti=
ng it
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     scsi: xen: scsiback: Free the command tag on the TMR submit-failure p=
ath
>=20
> Xu Rao <raoxu@uniontech.com>
>     scsi: sg: Report request-table problems when any status is set
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path
>=20
> Jhonraushan <raushan.jhon@gmail.com>
>     accel/ivpu: Reject firmware log with size smaller than header
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-verity: make error counter atomic
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-verity: increase sprintf buffer size
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-verity: fix a possible NULL pointer dereference
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-verity: avoid double increment of &use_bh_wq_enabled
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-integrity: don't increment hash_offset twice
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-integrity: fix a bug if the bio is out of limits
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm_early_create: fix freeing used table on dm_resume failure
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-stats: fix merge accounting
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-stats: fix dm_jiffies_to_msec64
>=20
> Benjamin Marzinski <bmarzins@redhat.com>
>     dm-log: fix a bitset_size overflow on 32bit machines
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-ioctl: fix a possible overflow in list_version_get_info
>=20
> Mikulas Patocka <mpatocka@redhat.com>
>     dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     dm era: fix out-of-bounds memory access for non-zero start sector
>=20
> Ming-Hung Tsai <mtsai@redhat.com>
>     dm thin metadata: fix metadata snapshot consistency on commit failure
>=20
> Genjian Zhang <zhanggenjian@kylinos.cn>
>     dm thin metadata: fix superblock refcount leak on snapshot shadow fai=
lure
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     net: sparx5: unregister blocking notifier on init failure
>=20
> Mike Waychison <mike@waychison.com>
>     block: fix race in blk_time_get_ns() returning 0
>=20
> Jiri Olsa <jolsa@kernel.org>
>     bpf: Add missing access_ok call to copy_user_syms
>=20
> Jann Horn <jannh@google.com>
>     bpf,fork: wipe ->bpf_storage before bailouts that access it
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: bcm: add missing rcu list annotations and operations
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: bcm: fix lockless bound/ifindex race and silent RX_SETUP failure
>=20
> Lee Jones <lee@kernel.org>
>     can: bcm: defer rx_op deallocation to workqueue to fix thrtimer UAF
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: isotp: use unconditional synchronize_rcu() in isotp_release()
>=20
> Fan Wu <fanwu01@zju.edu.cn>
>     can: esd_usb: kill anchored URBs before freeing netdevs
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     netdev-genl: report NAPI thread PID in the caller's pid namespace
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     nvmet-rdma: handle inline data with a nonzero offset
>=20
> Benjamin Coddington <ben.coddington@hammerspace.com>
>     NFS: Charge unstable writes by request size, not folio size
>=20
> Weiming Shi <bestswngs@gmail.com>
>     sctp: validate STALE_COOKIE cause length before reading staleness
>=20
> Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>     spi: uniphier: Fix completion initialization order before devm_reques=
t_irq()
>=20
> Wang Yan <wangyan01@kylinos.cn>
>     time: Fix off-by-one in compat settimeofday() usec validation
>=20
> Jaewon Yang <yong010301@gmail.com>
>     tpm: Make the TPM character devices non-seekable
>=20
> Thorsten Blum <thorsten.blum@linux.dev>
>     tpm: fix event_size output in tpm1_binary_bios_measurements_show
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     xfrm: xfrm_interface: require CAP_NET_ADMIN in the device netns for c=
hangelink
>=20
> Sanman Pradhan <psanman@juniper.net>
>     xfrm: use compat translator only for u64 alignment mismatch
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     xen/gntdev: fix error handling in ioctl
>=20
> Paul Greenwalt <paul.greenwalt@intel.com>
>     ice: fix ice_init_link() error return preventing probe
>=20
> Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>     i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()
>=20
> Roman Vivchar <rva333@protonmail.com>
>     i2c: mediatek: fix WRRD for SoCs without auto_restart option
>=20
> Joshua Crofts <joshua.crofts1@gmail.com>
>     hwmon: (max6697) add missing 'select REGMAP_I2C' to Kconfig
>=20
> Joshua Crofts <joshua.crofts1@gmail.com>
>     hwmon: (ltc2992) add missing 'select REGMAP_I2C' to Kconfig
>=20
> Ibrahim Hashimov <security@auditcode.ai>
>     ksmbd: fix integer overflow in set_file_allocation_info()
>=20
> Fredric Cover <fredric.cover.lkernel@gmail.com>
>     smb: client: use kvzalloc() for megabyte buffer in simple fallocate
>=20
> Holger Dengler <dengler@linux.ibm.com>
>     pkey: Move keytype check from pkey api to handler
>=20
> Daniel Gibson <daniel@gibson.sh>
>     platform/x86/amd/pmc: Don't log during intermediate wakeups
>=20
> Daniel Gibson <daniel@gibson.sh>
>     platform/x86/amd/pmc: Add delay_suspend module parameter
>=20
> Daniel Gibson <daniel@gibson.sh>
>     platform/x86/amd/pmc: Delay suspend for some Lenovo Laptops
>=20
> Daniel Gibson <daniel@gibson.sh>
>     platform/x86/amd/pmc: Check for intermediate wakeup in function
>=20
> Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
>     platform/x86: dell-laptop: fix missing cleanups in init error path
>=20
> Frank Li <Frank.Li@nxp.com>
>     dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_I=
NT_MASK
>=20
> Kartik Rajput <kkartik@nvidia.com>
>     dmaengine: tegra: Fix burst size calculation
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     tpm: tpm2-sessions: wait for async KPP completion in tpm_buf_append_s=
alt
>=20
> Jarkko Sakkinen <jarkko@kernel.org>
>     tpm: tpm_tis_spi: Use wait_woken() in wait_for_tmp_stat()
>=20
> Bhargav Joshi <j.bhargav.u@gmail.com>
>     irqchip/crossbar: Use correct index in crossbar_domain_free()
>=20
> Yiyang Chen <cyyzero16@gmail.com>
>     taskstats: retain dead thread stats in TGID queries
>=20
> Florian Fuchs <fuchsfl@gmail.com>
>     mtd: maps: vmu-flash: fix NULL pointer dereference in initialization
>=20
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: rawnand: Pause continuous reads at block boundaries
>=20
> Takahiro Kuwano <takahiro.kuwano@infineon.com>
>     mtd: spi-nor: spansion: use die erase for multi-die devices only
>=20
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: spi-nor: swp: Improve locking user experience
>=20
> Holger Dengler <dengler@linux.ibm.com>
>     s390/pkey: Check length in pkey_pckmo handler implementation
>=20
> Holger Dengler <dengler@linux.ibm.com>
>     s390/pkey: Check length in PKEY_VERIFYPROTK ioctl
>=20
> Sebastian Alba Vives <sebasjosue84@gmail.com>
>     fpga: microchip-spi: fix zero header_size OOB read in mpf_ops_parse_h=
eader()
>=20
> Maoyi Xie <maoyixie.tju@gmail.com>
>     net: thunderbolt: Fix frags[] overflow by bounding frame_count
>=20
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>     bus: mhi: ep: Protect mhi_ep_handle_syserr() in the error path
>=20
> Sebastian Alba Vives <sebasjosue84@gmail.com>
>     fpga: dfl: add bounds check in dfh_get_param_size()
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ocfs2: reject non-inline dinodes with i_size and zero i_clusters
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ocfs2: reject dinodes whose i_rdev disagrees with the file type
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ocfs2: reject dinodes with non-canonical i_mode type
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
>=20
> Ian Bridges <icb@fastmail.org>
>     ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits
>=20
> Kyle Zeng <kylebot@openai.com>
>     ocfs2: avoid moving extents to occupied clusters
>=20
> Arseniy Krasnov <avkrasnov@rulkc.org>
>     mtd: rawnand: fix condition in 'nand_select_target()'
>=20
> Vasiliy Kovalev <kovalev@altlinux.org>
>     net/9p: fix infinite loop in p9_client_rpc on fatal signal
>=20
> Bastien Curutchet <bastien.curutchet@bootlin.com>
>     mtd: rawnand: pl353: fix probe resource allocation
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     ocfs2: use kzalloc for quota recovery bitmap allocation
>=20
> Ionut Nechita <ionut.nechita@windriver.com>
>     scsi: sas: Skip opt_sectors when DMA reports no real optimization hint
>=20
> Martin Wilck <martin.wilck@suse.com>
>     scsi: smartpqi: Use shost_to_hba() in pqi_scan_finished()
>=20
> Breno Leitao <leitao@debian.org>
>     9p: skip nlink update in cacheless mode to fix WARN_ON
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     mtd: slram: remove failed entries from the device list
>=20
> Karl Mehltretter <kmehltretter@gmail.com>
>     kcov: use WRITE_ONCE() for selftest mode stores
>=20
> Muchun Song <muchun.song@linux.dev>
>     mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
>=20
> Krzysztof Wilczy=C5=84ski <kwilczynski@kernel.org>
>     proc: only bump parent nlink when registering directories
>=20
> Kiryl Shutsemau (Meta) <kas@kernel.org>
>     fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
>=20
> Kiryl Shutsemau (Meta) <kas@kernel.org>
>     fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()
>=20
> SeongJae Park <sj@kernel.org>
>     mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
>=20
> SeongJae Park <sj@kernel.org>
>     mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs=
()
>=20
> Zishun Yi <vulab@iscas.ac.cn>
>     riscv: cacheinfo: Fix node reference leak in populate_cache_leaves
>=20
> Aaron Tomlin <atomlin@atomlin.com>
>     mips: sched: Fix CPUMASK_OFFSTACK memory corruption
>=20
> Bryam Vargas <hexlabsecurity@proton.me>
>     selftests/landlock: Test SCOPE_SIGNAL on the SIGIO/fowner pgid path
>=20
> WenTao Liang <vulab@iscas.ac.cn>
>     power: supply: charger-manager: fix refcount leak in is_full_charged()
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     ntfs3: fix out-of-bounds read in decompress_lznt
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ntfs3: validate split-point offset in indx_insert_into_buffer
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ntfs3: bound to_move in indx_insert_into_root before hdr_insert_head
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     ntfs3: cap RESTART_TABLE free-chain walker at rt->used
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     fs/ntfs3: bound NTFS_DE view.data_off in UpdateRecordData{Root,Alloca=
tion}
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     fs/ntfs3: add depth limit to indx_find_buffer to prevent stack overfl=
ow
>=20
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: validate lcns_follow in log_replay conversion
>=20
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: bound attr_off in UpdateResidentValue against data_off
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     fs/ntfs3: bound copy_lcns dp->page_lcns[] index in analysis pass
>=20
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: bound DeleteIndexEntryAllocation memmove length
>=20
> Zhan Xusheng <zhanxusheng1024@gmail.com>
>     fs/ntfs3: fix syncing wrong inode on DIRSYNC cross-directory rename
>=20
> SeongJae Park <sj@kernel.org>
>     mm/damon/core: make charge_addr_from aware of end-address exclusivity
>=20
> Muchun Song <muchun.song@linux.dev>
>     mm/memory_hotplug: fix incorrect altmap passing in error path
>=20
> Ma Ke <make24@iscas.ac.cn>
>     power: supply: cpcap-battery: Fix missing nvmem_device_put() causing =
reference leak
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: DEC: Ensure 32-bit stack location for o32 prom_printf()
>=20
> Johan Hovold <johan@kernel.org>
>     MIPS: ip22-gio: fix device reference leak in probe
>=20
> Johan Hovold <johan@kernel.org>
>     MIPS: ip22-gio: fix kfree() of static object
>=20
> Johan Hovold <johan@kernel.org>
>     MIPS: ip22-gio: fix gio device memory leak
>=20
> Wasim Nazir <wasim.nazir@oss.qualcomm.com>
>     remoteproc: qcom: Fix leak when custom dump_segments addition fails
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     SUNRPC: Bound-check xdr_buf_to_bvec() stores before writing
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     lockd: Plug nlm_file refcount leak on cached nlm_do_fopen() failure
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     lockd: Plug nlm_file leak when nlm_do_fopen() fails
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     sunrpc: wait for in-flight TLS handshake callback when cancel loses r=
ace
>=20
> Chris Mason <clm@meta.com>
>     sunrpc: pin svc_xprt across the asynchronous TLS handshake callback
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     nvdimm/btt: Free arenas on btt_init() error paths
>=20
> Junrui Luo <moonafterrain@outlook.com>
>     jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: SCO: hold sk properly in sco_conn_ready
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: SCO: fix sleeping under spinlock in sco_conn_ready
>=20
> Beno=C3=AEt Sevens <bsevens@google.com>
>     HID: playstation: validate num_touch_reports in DualShock 4 reports
>=20
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>     mfd: tps6586x: Fix OF node refcount
>=20
> Shyam Prasad N <sprasad@microsoft.com>
>     cifs: invalidate cfid on unlink/rename/rmdir
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: tt: prevent TVLV OOB check overflow
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: mcast: avoid OOB read of num_dests header
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: frag: fix primary_if leak on failed linearization
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: frag: free unfragmentable packet
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: fix VLAN priority offset
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: tt: avoid request storms during pending request
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: dat: fix tie-break for candidate selection
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: dat: ensure accessible eth_hdr proto field
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: bla: reacquire gw address after skb realloc
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: dat: acquire ARP hw source only after skb realloc
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: access unicast_ttvn skb->data only after skb realloc
>=20
> Sven Eckelmann <sven@narfation.org>
>     batman-adv: gw: acquire ethernet header only after skb realloc
>=20
> Sumanth Korikkar <sumanthk@linux.ibm.com>
>     s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_even=
t_init()
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     cpufreq: intel_pstate: Set non-turbo capacity to HWP_GUARANTEED_PERF()
>=20
> Sandipan Das <sandipan.das@amd.com>
>     perf/x86/amd/lbr: Fix kernel address leakage
>=20
> Thorsten Blum <thorsten.blum@linux.dev>
>     x86/boot: Reject too long acpi_rsdp=3D values
>=20
> Thorsten Blum <thorsten.blum@linux.dev>
>     x86/boot: Validate console=3Duart8250 baud rate to fix early boot hang
>=20
> Ali Ahmet MEMIS <dev@unknownbbqr.xyz>
>     tools/power/x86/intel-speed-select: Harden daemon pidfile open
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     mfd: sm501: Fix reference leak on failed device registration
>=20
> Armin Wolf <W_Armin@gmx.de>
>     leds: uleds: Fix potential buffer overread
>=20
> Ondrej Mosnacek <omosnace@redhat.com>
>     selinux: fix incorrect execmem checks on overlayfs
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     selinux: avoid sk_socket dereference in selinux_sctp_bind_connect()
>=20
> Stephen Smalley <stephen.smalley.work@gmail.com>
>     selinux: check connect-related permissions on TCP Fast Open
>=20
> Wang Jun <1742789905@qq.com>
>     soc: fsl: qe: panic on ioremap() failure in qe_reset()
>=20
> Siddharth Vadapalli <s-vadapalli@ti.com>
>     soc: ti: k3-ringacc: Fix access mode for k3_ringacc_ring_pop_tail_io/=
proxy
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     gpu: host1x: Fix device reference leak in host1x_device_parse_dt() er=
ror path
>=20
> Xiang Mei (Microsoft) <xmei5@asu.edu>
>     netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()
>=20
> Wyatt Feng <bronzed_45_vested@icloud.com>
>     netfilter: xt_nat: reject unsupported target families
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     netfilter: ecache: fix inverted time_after() check
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     netfilter: nf_conncount: fix zone comparison in tuple dedup
>=20
> Xiang Mei <xmei5@asu.edu>
>     netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6=
 defrag
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nf_nat_sip: reload possible stale data pointer
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nft_set_pipapo: don't leak bad clone into future transacti=
on
>=20
> Haoze Xie <royenheart@gmail.com>
>     netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst
>=20
> Wyatt Feng <bronzed_45_vested@icloud.com>
>     netfilter: xt_cluster: reject template conntracks in hash match
>=20
> David Carlier <devnexen@gmail.com>
>     netfilter: nfnl_cthelper: apply per-class values when updating polici=
es
>=20
> Muhammad Bilal <meatuni001@gmail.com>
>     netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: qcom: q6apm: fix NULL pointer dereference in graph_callback
>=20
> C=C3=A1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ASoC: mediatek: mt8183: Release reserved memory on cleanup
>=20
> C=C3=A1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ASoC: mediatek: mt8192: Release reserved memory on cleanup
>=20
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: ipc3-control: Validate size in snd_sof_update_control
>=20
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: ipc3-control: Fix heap overflow in bytes_ext put/get
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: nvidia: fix potential memory leak in nvidiafb_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: vesafb: fix memory leak in vesafb_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: s3fb: fix potential memory leak in s3_pci_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: i740fb: fix potential memory leak in i740fb_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: efifb: fix memory leak in efifb_probe()
>=20
> Li RongQing <lirongqing@baidu.com>
>     fbdev: sm712: Fix operator precedence in big_swap macro
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: hecubafb: fix potential memory leak in hecubafb_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: broadsheetfb: fix potential memory leak in broadsheetfb_probe()
>=20
> Abdun Nihaal <nihaal@cse.iitm.ac.in>
>     fbdev: metronomefb: fix potential memory leak in metronomefb_probe()
>=20
> Weiming Shi <bestswngs@gmail.com>
>     KVM: arm64: nv: Fix SPSR_EL2 restore in kvm_hyp_handle_mops()
>=20
> Oliver Upton <oupton@kernel.org>
>     KVM: arm64: nv: Drop bogus WARN for write to ZCR_EL2
>=20
> Sean Christopherson <seanjc@google.com>
>     KVM: x86: Ignore pending PV EOI if the vCPU has since disabled PV EOIs
>=20
> Atish Patra <atishp@meta.com>
>     KVM: SEV: Do not allow intra-host migration/mirroring of SNP VMs
>=20
> Matthew Rosato <mjrosato@linux.ibm.com>
>     KVM: s390: pci: Fix handling of AIF enable without AISB
>=20
> Hyunwoo Kim <imv4bel@gmail.com>
>     KVM: arm64: vgic: Check the interrupt is still ours before migrating =
it
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     KVM: s390: pci: Fix GISC refcount leak on AIF enable failure
>=20
> Qiang Ma <maqianga@uniontech.com>
>     LoongArch: KVM: Return full old CSR value from kvm_emu_xchg_csr()
>=20
> Bibo Mao <maobibo@loongson.cn>
>     LoongArch: KVM: Fix FPU register width with user access API
>=20
> Qiang Ma <maqianga@uniontech.com>
>     LoongArch: KVM: Check the return values for put_user()
>=20
> Bibo Mao <maobibo@loongson.cn>
>     LoongArch: KVM: Check irq validity in kvm_vcpu_ioctl_interrupt()
>=20
> David Jander <david@protonic.nl>
>     ARM: dts: stm32: stm32mp15x-mecio1-io: Move expander gpio-line-names =
to board files
>=20
> David Jander <david@protonic.nl>
>     ARM: dts: stm32: stm32mp15x-mecio1-io: Fix expander gpio line typo
>=20
> David Jander <david@protonic.nl>
>     ARM: dts: stm32: stm32mp15x-mecio1-io: Move gpio-line-names to board =
files
>=20
> David Jander <david@protonic.nl>
>     ARM: dts: stm32: stm32mp15x-mecio1-io: Fix GPIO names typo
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     arm64: dts: imx8ulp-evk: Correct Type-C int GPIO flags
>=20
> David Jander <david@protonic.nl>
>     ARM: dts: stm32: stm32mp15x-mecio1-io: Enable internal ADC reference
>=20
> Judith Mendez <jm@ti.com>
>     arm64: dts: ti: k3-am62a7-sk: Add bootph-all tag to vqmmc
>=20
> David Jander <david@protonic.nl>
>     ARM: dts: stm32: stm32mp15x-mecio1-io: Move divergent mecio1 ADC chan=
nels to board files
>=20
> David Jander <david@protonic.nl>
>     ARM: dts: stm32: stm32mp15x-mecio1-io: Fix ADC sampling times
>=20
> Nickolay Goppen <setotau@mainlining.org>
>     arm64: dts: qcom: sdm630: describe adsp_mem region properly
>=20
> Mark Rutland <mark.rutland@arm.com>
>     arm64: fpsimd: Fix type mismatch in sve_{save,load}_state()
>=20
> Yong Wang <edragain@163.com>
>     net: ife: require ETH_HLEN to be pullable in ife_decode()
>=20
> Zhengchuan Liang <zcliangcn@gmail.com>
>     net: atm: reject out-of-range traffic classes in QoS validation
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     net: qrtr: fix 32-bit integer overflow in qrtr_endpoint_post()
>=20
> C=C3=A1ssio Gabriel <cassiogabrielcontato@gmail.com>
>     ASoC: SOF: topology: validate vendor array size before parsing
>=20
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: ipc3-control: Fix TOCTOU in bytes_put and bytes_get
>=20
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: ipc3-control: Use overflow checks in control_update size c=
alc
>=20
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: ipc4-control: Fix TOCTOU in sof_ipc4_bytes_put
>=20
> Zhang Tianci <zhangtianci.1997@bytedance.com>
>     vduse: Fix race in vduse_dev_msg_sync and vduse_dev_read_iter
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     mlxsw: fix refcount leak in mlxsw_sp_vrs_lpm_tree_replace()
>=20
> Wentao Liang <vulab@iscas.ac.cn>
>     mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     smb: client: fix overflow in passthrough ioctl bounds check
>=20
> Anas Khan <anxkhn28@gmail.com>
>     drm/xe: remove duplicate <kunit/test-bug.h> include
>=20
> Harman Kalra <hkalra@marvell.com>
>     octeontx2-af: fix VF bringup affecting PF promiscuous state
>=20
> Li RongQing <lirongqing@baidu.com>
>     net/mlx5: Fix L3 tunnel entropy refcount leak
>=20
> Wang Yan <wangyan01@kylinos.cn>
>     selftests/net: fix EVP_MD_CTX leak in tcp_mmap
>=20
> Timur Tabi <ttabi@nvidia.com>
>     regulator: core: regulator_lock_two() should test for EDEADLK not EDE=
ADLOCK
>=20
> Cao Guanghui <caoguanghui@kylinos.cn>
>     dm era: fix NULL pointer dereference in metadata_open()
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     SUNRPC: pin upper rpc_clnt across the TLS connect_worker
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     SUNRPC: release lower rpc_clnt if killed waiting for XPRT_LOCKED
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     cifs: validate DFS referral string offsets
>=20
> Rongguang Wei <weirongguang@kylinos.cn>
>     s390/zcrypt: Remove the empty file
>=20
> Julian Anastasov <ja@ssi.bg>
>     ipvs: ensure inner headers in ICMP errors are in headroom
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     ipvs: fix PMTU for GUE/GRE tunnel ICMP errors
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     ipvs: use parsed transport offset in TCP state lookup
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     ipvs: pass parsed transport offset to state handlers
>=20
> Tamaki Yanagawa <ty@000ty.net>
>     netfilter: nft_lookup: fix catchall element handling with inverted lo=
okups
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv6: mcast: Fix potential UAF in MLD delayed work
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     ipv6: mcast: Replace locking comments with lockdep annotations.
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv4: igmp: Fix potential UAF in igmp_gq_start_timer()
>=20
> Rosen Penev <rosenp@gmail.com>
>     gpio: mvebu: free generic chips on unbind
>=20
> Sandipan Das <sandipan.das@amd.com>
>     perf/x86/amd/core: Avoid enabling BRS from the SVM reload path
>=20
> Suman Ghosh <sumang@marvell.com>
>     octeontx2-pf: check DMAC extraction support before filtering
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     net/sched: cake: reject overhead values that underflow length
>=20
> Ma=C3=ADra Canal <mcanal@igalia.com>
>     drm/v3d: Reject invalid indirect BO handle in indirect CSD setup
>=20
> Enrico Pozzobon <enrico.pozzobon@dissecto.com>
>     net: usb: lan78xx: disable VLAN filter in promiscuous mode
>=20
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: usb: lan78xx: move functions to avoid forward definitions
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     net/tls: Consume empty data records in tls_sw_read_sock()
>=20
> Hui Wang <hui.wang@canonical.com>
>     ring-buffer: Fix event length with forced 8-byte alignment
>=20
> Weiming Shi <bestswngs@gmail.com>
>     Bluetooth: bpa10x: avoid OOB read of revision string in bpa10x_setup()
>=20
> Pauli Virtanen <pav@iki.fi>
>     Bluetooth: ISO: exclude RFU bits from ISO_SDU_Length
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: MGMT: Fix adv monitor add failure cleanup
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     Bluetooth: 6lowpan: hold L2CAP conn across debugfs control
>=20
> Eric Dumazet <edumazet@google.com>
>     amt: fix size calculation in amt_get_size()
>=20
> Xiang Mei <xmei5@asu.edu>
>     net/smc: fix UAF in smc_cdc_rx_handler() by pinning the socket
>=20
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net/sched: act_pedit: fix TOCTOU heap OOB write in tc offload
>=20
> Xiang Mei <xmei5@asu.edu>
>     net: qualcomm: rmnet: validate MAP frame length before ingress parsing
>=20
> Shigeru Yoshida <syoshida@redhat.com>
>     qede: fix off-by-one in BD ring consumption on build_skb failure
>=20
> Jens Emil Schulz =C3=98stergaard <jensemil.schulzostergaard@microchip.com>
>     net: microchip: vcap: fix races on the shared Super VCAP block
>=20
> Feng Liu <feliu@nvidia.com>
>     net/mlx5e: Fix HV VHCA stats agent registration race
>=20
> Feng Liu <feliu@nvidia.com>
>     net/mlx5e: Fix HV VHCA stats zero-sized buffer allocation
>=20
> Shay Drory <shayd@nvidia.com>
>     net/mlx5: LAG, MPESW, Fix missing complete() on devcom error
>=20
> Wyatt Feng <bronzed_45_vested@icloud.com>
>     netfilter: xt_connmark: reject invalid shift parameters
>=20
> Zhixing Chen <running910@gmail.com>
>     netfilter: ip6tables: mark malformed IPv6 extension headers for hotdr=
op
>=20
> Feng Wu <wufengwufengwufeng@gmail.com>
>     netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
>=20
> Wyatt Feng <bronzed_45_vested@icloud.com>
>     netfilter: xt_u32: reject invalid shift counts
>=20
> Qihang <q.h.hack.winter@gmail.com>
>     gue: validate REMCSUM private option length
>=20
> Xiang Mei <xmei5@asu.edu>
>     net: usb: net1080: validate packet_len before pad-byte access in rx_f=
ixup
>=20
> Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
>     selftests/hid: Cover hid_bpf_get_data() size overflow
>=20
> Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
>     selftests/hid: Load only requested struct_ops maps
>=20
> Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
>     HID: bpf: Fix hid_bpf_get_data() range check
>=20
> Anshuman Khandual <anshuman.khandual@arm.com>
>     arm64/mm: Optimize TLB flush in unmap_hotplug_[pmd|pud]_range()
>=20
> Lee Jones <lee@kernel.org>
>     HID: core: Fix OOB read in hid_get_report for numbered reports
>=20
> Georgiy Osokin <g.osokin@auroraos.dev>
>     HID: picolcd: prevent NULL pointer dereference in picolcd_send_and_wa=
it()
>=20
> Karuna Ramkumar <rkaruna@google.com>
>     ata: libata-scsi: limit simulated SCSI command copy to response length
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     ata: sata_gemini: unwind clocks on IDE pinctrl errors
>=20
> David Howells <dhowells@redhat.com>
>     cifs: Fix missing credit release on failure in cifs_issue_read()
>=20
> David Howells <dhowells@redhat.com>
>     netfs: Drop the error arg from netfs_read_subreq_terminated()
>=20
> Michal Wajdeczko <michal.wajdeczko@intel.com>
>     drm/xe/pf: Don't attempt to process FAST_REQ or EVENT relays
>=20
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe/hw_engine: Fix double-free of managed BO in error path
>=20
> Francois Dugast <francois.dugast@intel.com>
>     drm/xe/pt: Fix NULL pointer dereference in xe_pt_zap_ptes_entry()
>=20
> David Howells <dhowells@redhat.com>
>     netfs: Fix writeback error handling
>=20
> Amir Goldstein <amir73il@gmail.com>
>     ovl: fix comment about locking order
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     minix: avoid overflow in bitmap block count calculation
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix unchecked-length string display in debug statement
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix the volume AFS_VOLUME_RM_TREE is set on
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix vllist leak
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix missing NULL pointer check in afs_break_some_callbacks()
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix callback service message parsers to pass through -EAGAIN
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix misplaced inc of net->cells_outstanding
>=20
> David Howells <dhowells@redhat.com>
>     afs: Change dynroot to create contents on demand
>=20
> David Howells <dhowells@redhat.com>
>     afs: Remove the "autocell" mount option
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix afs_atcell_get_link() to handle RCU pathwalk
>=20
> David Howells <dhowells@redhat.com>
>     afs: Make /afs/@cell and /afs/.@cell symlinks
>=20
> David Howells <dhowells@redhat.com>
>     afs: Add rootcell checks
>=20
> David Howells <dhowells@redhat.com>
>     afs: Make /afs/.<cell> as well as /afs/<cell> mountpoints
>=20
> Li RongQing <lirongqing@baidu.com>
>     afs: Remove erroneous seq |=3D 1 in volume lookup loop
>=20
> Zilin Guan <zilin@seu.edu.cn>
>     afs: use kvfree() to free memory allocated by kvcalloc()
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix double netfs initialisation in afs_root_iget()
>=20
> Dan Carpenter <error27@gmail.com>
>     afs: Fix error code in afs_extract_vl_addrs()
>=20
> Christian Brauner <brauner@kernel.org>
>     fs: refuse O_TMPFILE creation with an unmapped fsuid or fsgid
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     net/sched: hhf: clear heavy-hitter state on reset
>=20
> Viacheslav Bocharov <v@baodeep.com>
>     pinctrl: meson: restore non-sleeping GPIO access
>=20
> Vladimir Zapolskiy <vz@kernel.org>
>     gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
>=20
> Gil Portnoy <dddhkts1@gmail.com>
>     ksmbd: fix use-after-free of fp->owner.name in durable handle owner c=
heck
>=20
> Haofeng Li <lihaofeng@kylinos.cn>
>     ksmbd: reject undersized DACLs before parsing ACEs
>=20
> Sechang Lim <rhkrqnwk98@gmail.com>
>     net/sched: act_bpf: use rcu_dereference_bh() to read the filter
>=20
> Gleb Markov <markov.gi@npc-ksb.ru>
>     cxgb4: Fix decode strings dump for T6 adapters
>=20
> Longjun Tang <tanglongjun@kylinos.cn>
>     virtio_net: disable cb when NAPI is busy-polled
>=20
> Qingshuang Fu <fuqingshuang@kylinos.cn>
>     irqchip/ts4800: Fix missing chained handler cleanup on remove
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     irqchip/gic-v3-its: Fix OF node reference leak
>=20
> Martin Kaiser <martin@kaiser.cx>
>     tracing: eprobe: read the complete FILTER_PTR_STRING pointer
>=20
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
>     tracing/events: Fix to check the simple_tsk_fn creation
>=20
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Interrupt group start/resumption if group_bind_locked() =
fails
>=20
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Fix a leak when a group is evicted before the tiler OOM =
is serviced
>=20
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Don't overrule pending immediate ticks in sched_resume_t=
ick()
>=20
> Boris Brezillon <boris.brezillon@collabora.com>
>     drm/panthor: Fix potential invalid pointer deref in group_process_til=
er_oom()
>=20
> Ido Schimmel <idosch@nvidia.com>
>     bridge: stp: Fix a potential use-after-free when deleting a bridge
>=20
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net/sched: sch_teql: Introduce slaves_lock to avoid race condition an=
d UAF
>=20
> Rosen Penev <rosenp@gmail.com>
>     net: gianfar: dispose irq mappings on probe failure and device removal
>=20
> Petr Wozniak <petr.wozniak@gmail.com>
>     net: phy: sfp: free mii_bus in sfp_i2c_mdiobus_destroy
>=20
> Xiang Mei <xmei5@asu.edu>
>     usbnet: gl620a: fix out-of-bounds read in genelink_rx_fixup()
>=20
> Pengfei Zhang <zhangfeionline@gmail.com>
>     ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (aspeed-g6-pwm-tach) Guard fan RPM calculation against divide-=
by-zero
>=20
> Guenter Roeck <linux@roeck-us.net>
>     hwmon: (pmbus) Fix passing events to regulator core
>=20
> Matti Vaittinen <mazziesaccount@gmail.com>
>     hwmon: adm1275: Prevent reading uninitialized stack
>=20
> Luca Weiss <luca.weiss@fairphone.com>
>     ASoC: codecs: lpass-va-macro: Fix LPASS Codec Version for SC7280
>=20
> Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
>     ASoC: codecs: lpass-va-macro: add SM6115 compatible
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: DEC: Ensure RTC platform device deregistration upon failure
>=20
> Yousef Alhouseen <alhouseenyousef@gmail.com>
>     sctp: fix SCTP_RESET_STREAMS stream list length limit
>=20
> Wei Fang <wei.fang@nxp.com>
>     net: enetc: check the number of BDs needed for xdp_frame
>=20
> Matvey Kovalev <matvey.kovalev@ispras.ru>
>     qede: fix out-of-bounds check for cqe->len_list[]
>=20
> Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
>     seg6: validate SRH length before reading fixed fields
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     gpio: htc-egpio: use managed gpiochip registration
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     gpio: mvebu: fail probe if gpiochip registration fails
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     spi: sh-msiof: abort transfers when reset times out
>=20
> Martin Kaiser <martin@kaiser.cx>
>     tracing: probes: fix typo in a log message
>=20
> Shuaisong Yang <yangshuaisong@h-partners.com>
>     net: hns3: differentiate autoneg default values between copper and fi=
ber
>=20
> Shuaisong Yang <yangshuaisong@h-partners.com>
>     net: hns3: fix permanent link down deadlock after reset
>=20
> Shuaisong Yang <yangshuaisong@h-partners.com>
>     net: hns3: refactor MAC autoneg and speed configuration
>=20
> Shuaisong Yang <yangshuaisong@h-partners.com>
>     net: hns3: unify copper port ksettings configuration path
>=20
> Peiyang Wang <wangpeiyang1@huawei.com>
>     net: hns3: clear hns alarm: comparison of integer expressions of diff=
erent signedness
>=20
> Jijie Shao <shaojijie@huawei.com>
>     net: hns3: use hns3_get_ops() helper to reduce the unnecessary middle=
 layer conversion
>=20
> Jijie Shao <shaojijie@huawei.com>
>     net: hns3: use hns3_get_ae_dev() helper to reduce the unnecessary mid=
dle layer conversion
>=20
> Jian Shen <shenjian15@huawei.com>
>     net: hns3: use string choices helper
>=20
> Rosen Penev <rosenp@gmail.com>
>     net: hisilicon: hns3: use ethtool string helpers
>=20
> Rob Herring (Arm) <robh@kernel.org>
>     dt-bindings: net: renesas,ether: Drop example "ethernet-phy-ieee802.3=
-c22" fallback
>=20
> Eric Dumazet <edumazet@google.com>
>     net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync
>=20
> Stanislav Fomichev <stfomichev@gmail.com>
>     udp_tunnel: remove rtnl_lock dependency
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_asrc_dma: fix eDMA maxburst misalignment with channel count
>=20
> Shitalkumar Gandhi <shital.gandhi45@gmail.com>
>     net: ethernet: sunplus: spl2sw: fix phy_node refcount leak in remove
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     net: sungem: fix probe error cleanup
>=20
> Yun Zhou <yun.zhou@windriver.com>
>     net: mvneta: re-enable percpu interrupt on resume
>=20
> Subbaraya Sundeep <sbhatta@marvell.com>
>     octeontx2-af: Validate NIX maximum LFs correctly
>=20
> David Yang <mmyangfl@gmail.com>
>     net: dsa: realtek: fix memory leak in rtl8366rb_setup_led()
>=20
> Haoxiang Li <haoxiang_li2024@163.com>
>     rtc: cmos: unregister HPET IRQ handler on probe failure
>=20
> Fredrik M Olsson <fredrik.m.olsson@axis.com>
>     rtc: ds1307: Fix off-by-one issue with wday for rx8130
>=20
> Huiwen He <hehuiwen@kylinos.cn>
>     smb/client: preserve errors from smb2_set_sparse()
>=20
> Li RongQing <lirongqing@baidu.com>
>     ACPI: processor_idle: Mark LPI enter functions as __cpuidle
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     thermal: testing: zone: Flush work items during cleanup
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     ipv6: fix missing notification for ignore_routes_with_linkdown
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     ipv6: Convert net.ipv6.conf.${DEV}.XXX sysctl to per-netns RTNL.
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     ipv6: Add __in6_dev_get_rtnl_net().
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     rtnetlink: Define rtnl_net_trylock().
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     rtnetlink: Add assertion helpers for per-netns RTNL.
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     rtnetlink: Add per-netns RTNL.
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     ipv6: fix error handling in disable_policy sysctl
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     ipv6: fix error handling in forwarding sysctl
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     ipv6: fix error handling in ignore_routes_with_linkdown sysctl
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     ipv6: fix error handling in disable_ipv6 sysctl
>=20
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net/sched: cls_api: Handle TC_ACT_CONSUMED in tcf_qevent_handle
>=20
> Eric Dumazet <edumazet@google.com>
>     veth: fix NAPI leak in XDP enable error path
>=20
> Aleksandrova Alyona <aga@itb.spb.ru>
>     net: dsa: sja1105: round up PTP perout pin duration
>=20
> Xiang Mei <xmei5@asu.edu>
>     net, bpf: check master for NULL in xdp_master_redirect()
>=20
> Krzysztof Wilczy=C5=84ski <kwilczynski@kernel.org>
>     alpha/PCI: Fix __pci_mmap_fits() overflow for zero-length BARs
>=20
> Krzysztof Wilczy=C5=84ski <kwilczynski@kernel.org>
>     alpha/PCI: Add security_locked_down() check to pci_mmap_resource()
>=20
> Koichiro Den <den@valinux.co.jp>
>     NTB: epf: Fix doorbell bitmask and IRQ vector handling
>=20
> Koichiro Den <den@valinux.co.jp>
>     NTB: epf: Report 0-based doorbell vector via ntb_db_event()
>=20
> Koichiro Den <den@valinux.co.jp>
>     NTB: epf: Make db_valid_mask cover only real doorbell bits
>=20
> Qingshuang Fu <fuqingshuang@kylinos.cn>
>     gpio: davinci: fix IRQ domain leak on devm_kzalloc failure
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nft_compat: ebtables emulation must reject non-bridge targ=
ets
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     netfilter: nft_synproxy: stop bypassing the priv->info snapshot
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: nf_conncount: prevent connlimit drops for early confirmed =
ct
>=20
> Mathias Krause <minipli@grsecurity.net>
>     netfilter: nf_nat: avoid invalid nat_net pointer use on failed nf_nat=
_init()
>=20
> Bradley Morgan <include@grrlz.net>
>     bpf: Disable xfrm_decode_session hook attachment
>=20
> Chen Cheng <chencheng@fnnas.com>
>     md/raid5: avoid R5_Overlap races while breaking stripe batches
>=20
> Chen Cheng <chencheng@fnnas.com>
>     md/raid5: use stripe state snapshot in break_stripe_batch_list()
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     ipv4: fib: Don't ignore error route in local/main tables.
>=20
> Jakub Kicinski <kuba@kernel.org>
>     eth: bnxt: improve the timing of stats
>=20
> Jakub Kicinski <kuba@kernel.org>
>     eth: bnxt: rename ring_err_stats -> ring_drv_stats
>=20
> Jakub Kicinski <kuba@kernel.org>
>     eth: bnxt: gather and report HW-GRO stats
>=20
> Rosen Penev <rosenp@gmail.com>
>     net: bnxt: use ethtool string helpers
>=20
> Xiang Mei <xmei5@asu.edu>
>     ipv6: Fix null-ptr-deref in fib6_nh_mtu_change().
>=20
> Gil Portnoy <dddhkts1@gmail.com>
>     ksmbd: fix use-after-free of conn->preauth_info in concurrent SMB2 NE=
GOTIATE
>=20
> Stepan Ionichev <sozdayvek@gmail.com>
>     rtc: msc313: fix NULL deref in shared IRQ handler at probe
>=20
> Mohamed Khalfella <mkhalfella@purestorage.com>
>     i40e: Fix i40e_debug() to use struct i40e_hw argument
>=20
> ZhaoJinming <zhaojinming@uniontech.com>
>     ice: dpll: fix memory leak in ice_dpll_init_info error paths
>=20
> ZhaoJinming <zhaojinming@uniontech.com>
>     ice: dpll: set pointers to NULL after kfree in ice_dpll_deinit_info
>=20
> Marcin Szycik <marcin.szycik@intel.com>
>     ice: call netif_keep_dst() once when entering switchdev mode
>=20
> Lukasz Czapnik <lukasz.czapnik@intel.com>
>     ice: fix AQ error code comparison in ice_set_pauseparam()
>=20
> Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
>     ice: fix FDIR CTRL VSI resource leak in ice_reset_all_vfs()
>=20
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>     PCI: endpoint: pci-epf-ntb: Add check to detect 'db_count' value of 0
>=20
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>     PCI: endpoint: pci-epf-vntb: Add check to detect 'db_count' value of 0
>=20
> Xiang Mei <xmei5@asu.edu>
>     drm/edid: fix OOB read in drm_parse_tiled_block()
>=20
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
>     power: sequencing: fix ABBA deadlock in pwrseq_device_unregister()
>=20
> Amery Hung <ameryhung@gmail.com>
>     bpf: Fix effective prog array index with BPF_F_PREORDER
>=20
> Avinash Duduskar <avinash.duduskar@gmail.com>
>     bpf: zero-initialize the fib lookup flow struct
>=20
> Yichong Chen <chenyichong@uniontech.com>
>     bpftool: Fix vmlinux BTF leak in cgroup commands
>=20
> Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
>     bpf: Fix stack slot index in nospec checks
>=20
> Ronan Dalton <ronan.dalton@alliedtelesis.co.nz>
>     rtc: ds1307: handle oscillator stop flag for ds1337/ds1339/ds3231
>=20
> Antoni Pokusinski <apokusinski01@gmail.com>
>     rtc: abx80x: fix the RTC_VL_CLR clearing all status flags
>=20
> Ioana Ciornei <ioana.ciornei@nxp.com>
>     dpaa2-switch: do not accept VLAN uppers while bridged
>=20
> Weiming Shi <bestswngs@gmail.com>
>     ipv6: ndisc: fix NULL deref in accept_untracked_na()
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     net/sched: act_ct: fix nf_connlabels leak on two error paths
>=20
> Geetha sowjanya <gakula@marvell.com>
>     octeontx2-pf: mcs: Fix mcs resources free on PF shutdown
>=20
> Subbaraya Sundeep <sbhatta@marvell.com>
>     octeontx2-pf: Clear stats of all resources when freeing resources
>=20
> Geetha sowjanya <gakula@marvell.com>
>     octeontx2-af: mcs: Fix unsupported secy stats read
>=20
> Wayen Yan <win847@gmail.com>
>     net: ethernet: mtk_ppe: Fix rhashtable leak in mtk_ppe_init error pat=
hs
>=20
> Weiming Shi <bestswngs@gmail.com>
>     tipc: fix use-after-free of the discoverer in tipc_disc_rcv()
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     net: marvell: prestera: initialize err in prestera_port_sfp_bind
>=20
> Aboorva Devarajan <aboorvad@linux.ibm.com>
>     selftests/mm: fix exclusive_cow test fork() handling
>=20
> Sayali Patil <sayalip@linux.ibm.com>
>     selftests/mm: allow PUD-level entries in compound testcase of hmm tes=
ts
>=20
> Sayali Patil <sayalip@linux.ibm.com>
>     selftests/mm: clarify alternate unmapping in compaction_test
>=20
> Sayali Patil <sayalip@linux.ibm.com>
>     selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
>=20
> Sayali Patil <sayalip@linux.ibm.com>
>     selftest/mm: register existing mapping with userfaultfd in hugetlb-mr=
emap
>=20
> Sayali Patil <sayalip@linux.ibm.com>
>     selftests/mm: restore default nr_hugepages value via exit trap in cha=
rge_reserved_hugetlb.sh
>=20
> Bhargav Joshi <j.bhargav.u@gmail.com>
>     irqchip/crossbar: Fix parent domain resource leak
>=20
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>     mailbox: imx: Forward the timeout/ error in imx_mu_generic_tx()
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nf_reject: skip iphdr options when looking for icmp header
>=20
> Jozsef Kadlecsik <kadlec@netfilter.org>
>     netfilter: ipset: make sure gc is properly stopped
>=20
> Jozsef Kadlecsik <kadlec@netfilter.org>
>     netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
>=20
> Jozsef Kadlecsik <kadlec@netfilter.org>
>     netfilter: ipset: Don't use test_bit() in lockless RCU readers in has=
h types
>=20
> Jozsef Kadlecsik <kadlec@netfilter.org>
>     netfilter: ipset: annotate "pos" for concurrent readers/writers
>=20
> Jozsef Kadlecsik <kadlec@netfilter.org>
>     netfilter: ipset: Fix data race between add and dump in all hash types
>=20
> Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>     md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on =
retry
>=20
> Robertus Diawan Chris <robertusdchris@gmail.com>
>     mac802154: Prevent overwrite return code in mac802154_perform_associa=
tion()
>=20
> Aleksandr Nogikh <nogikh@google.com>
>     ieee802154: fix kernel-infoleak in dgram_recvmsg()
>=20
> Ivan Abramov <i.abramov@mt-integration.ru>
>     ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
>=20
> Xu Rao <raoxu@uniontech.com>
>     ACPI: IPMI: Fix inverted interface check in ipmi_bmc_gone()
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     ACPI: resource: Amend kernel-doc style
>=20
> Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
>     thermal: intel: Fix dangling resources on thermal_throttle_online() f=
ailure
>=20
> Breno Leitao <leitao@debian.org>
>     arm64/hw_breakpoint: reject unaligned watchpoints that would truncate=
 BAS
>=20
> Cen Zhang <zzzccc427@gmail.com>
>     ALSA: usb-audio: Kill MIDI 2.0 URBs before freeing endpoints
>=20
> Yun Zhou <yun.zhou@windriver.com>
>     flow_dissector: check device type before reading ETH_ADDRS
>=20
> Cosmin Ratiu <cratiu@nvidia.com>
>     devlink: Fix parent ref leak in devl_rate_node_create()
>=20
> Ioana Ciornei <ioana.ciornei@nxp.com>
>     dpaa2-switch: fix VLAN upper check not rejecting bridge join
>=20
> Xiang Mei <xmei5@asu.edu>
>     virtio-net: fix len check in receive_big()
>=20
> Quang Nguyen <quang.nguyen.wx@renesas.com>
>     spi: rpc-if: Use correct device for hardware reinitialization on resu=
me
>=20
> Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
>     PCI: iproc: Restore .map_irq() for the platform bus driver
>=20
> Xin Long <lucien.xin@gmail.com>
>     sctp: hold socket lock when dumping endpoints in sctp_diag
>=20
> Jakub Kicinski <kuba@kernel.org>
>     net: psample: fix info leak in PSAMPLE_ATTR_DATA
>=20
> Ratheesh Kannoth <rkannoth@marvell.com>
>     octeontx2-pf: Fix leak of SQ timestamp buffer on teardown
>=20
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>     drm/amdgpu: initialize irq.lock spinlock earlier
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     drm/amdkfd: fix list_del corruption in kfd_criu_resume_svm
>=20
> Yunxiang Li <Yunxiang.Li@amd.com>
>     drm/amdkfd: Avoid double-unpin of DOORBELL/MMIO BOs on free
>=20
> Sen Wang <sen@ti.com>
>     ASoC: tlv320aic3x: restrict CLKDIV bypass Q values in dual-rate mode
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf cs-etm: Bounds-check CPU in cs_etm__get_queue()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf cs-etm: Require full global header in auxtrace_info size check
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf cs-etm: Validate num_cpu before metadata allocation
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf machine: Use snprintf() for guestmount path construction
>=20
> Eric Dumazet <edumazet@google.com>
>     xfrm: validate selector family and prefixlen during match
>=20
> Eric Dumazet <edumazet@google.com>
>     xfrm: annotate data-races around xfrm_policy_count[] and xfrm_policy_=
default[]
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     xfrm: Fix xfrm state cache insertion race
>=20
> Jisheng Zhang <jszhang@kernel.org>
>     spi: dw: fix wrong BAUDR setting after resume
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     drm/i915: clear CRTC color blob pointers after dropping refs
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     gpio: mlxbf3: fail probe if gpiochip registration fails
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf cs-etm: Reject CPU IDs that would overflow signed comparison
>=20
> Leo Yan <leo.yan@arm.com>
>     perf: Remove redundant kernel.h include
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf bpf: Bounds-check array offsets in bpil_offs_to_addr()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf bpf: Validate func_info_rec_size and sub_id in synthesize_bpf_pr=
og_name()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Use snprintf() for root_dir path construction
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Break infinite loop on zero-filled notes in sysfs__read=
_build_id()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Validate p_filesz before use in filename__read_build_id=
()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Fix bswap copy-paste error for 32-bit ELF p_filesz
>=20
> Ian Rogers <irogers@google.com>
>     perf maps: Add maps__mutate_mapping
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     sparc: led: avoid trimming a newline from empty writes
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: fix label can not be immediately before a declaration
>=20
> Adrian Hunter <adrian.hunter@intel.com>
>     i3c: master: Prevent reuse of dynamic address on device add failure
>=20
> Adrian Hunter <adrian.hunter@intel.com>
>     i3c: master: Make hot-join workqueue freezable to block hot-join duri=
ng suspend
>=20
> Marco Crivellari <marco.crivellari@suse.com>
>     i3c: master: add WQ_PERCPU to alloc_workqueue users
>=20
> Marco Crivellari <marco.crivellari@suse.com>
>     workqueue: Add new WQ_PERCPU flag
>=20
> Zygmunt Krynicki <me@zygoon.pl>
>     apparmor: put secmark label after secid lookup
>=20
> Zygmunt Krynicki <me@zygoon.pl>
>     apparmor: aa_getprocattr free procattr leak on format failure
>=20
> Georgia Garcia <georgia.garcia@canonical.com>
>     apparmor: remove or add symlinks to rawdata according to export_binary
>=20
> Maxime B=C3=A9lair <maxime.belair@canonical.com>
>     apparmor: fix potential UAF in aa_replace_profiles
>=20
> Ryan Lee <ryan.lee@canonical.com>
>     apparmor: grab ns lock and refresh when looking up changehat child pr=
ofiles
>=20
> John Johansen <john.johansen@canonical.com>
>     apparmor: fix rawdata_f_data implicit flex array
>=20
> Zygmunt Krynicki <me@zygoon.pl>
>     apparmor: aa_label_alloc use aa_label_free on alloc failure
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     apparmor: check label build before no_new_privs test
>=20
> Andrew Morton <akpm@linux-foundation.org>
>     security/apparmor/apparmorfs.c: conditionally compile get_loaddata_co=
mmon_ref()
>=20
> Yuanhe Shu <xiangzao@linux.alibaba.com>
>     Revert "PCI/MSI: Unmap MSI-X region on error"
>=20
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>     PCI: mediatek: Use actual physical address instead of virt_to_phys()
>=20
> Ryder Lee <ryder.lee@mediatek.com>
>     PCI: mediatek: Fix possible truncation in mtk_pcie_parse_port()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Add bounds checks to read_build_id() note iteration in =
minimal build
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Add bounds checks to elf_read_build_id() note iteration
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf bpf: Add NULL check for btf__type_by_id() in synthesize_bpf_prog=
_name()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     tools lib api: Fix mount_overload() snprintf truncation and toupper r=
ange
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     tools lib api: Fix filename__write_int() writing uninitialized stack =
data
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Use snprintf() in dso__read_running_kernel_build_id()
>=20
> Ian Rogers <irogers@google.com>
>     perf dso: Move build_id to dso_id
>=20
> Ian Rogers <irogers@google.com>
>     perf build-id: Change sprintf functions to snprintf
>=20
> Ian Rogers <irogers@google.com>
>     perf dso: Add support for reading the e_machine type for a dso
>=20
> Ian Rogers <irogers@google.com>
>     perf dso: Use lock annotations to fix asan deadlock
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Bounds-check descsz in sysfs__read_build_id() GNU fallb=
ack
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Fix thread__set_comm_from_proc() on empty comm file
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf intel-pt: Fix snprintf size tracking bug in insn decoder
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Bounds-check .gnu_debuglink section data
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf symbols: Fix signed overflow in sysfs__read_build_id() size check
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     tools lib api: Fix missing null termination in filename__read_int/ull=
()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf pmu: Fix perf_pmu__parse_scale/unit() OOB access on empty sysfs =
file
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf pmu: Fix pmu_id() heap underwrite on empty identifier file
>=20
> James Clark <james.clark@linaro.org>
>     perf cs-etm: Queue context packets for frontend
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Return sendctx slot after Send preparation failure
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Repost Receive buffers for malformed replies
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Sanitize the reply credit grant after parsing
>=20
> Chris Mason <clm@meta.com>
>     xprtrdma: Fix bcall rep leak and unbounded peek
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Resize reply buffers before reposting receives
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Document and assert reply-handler invariants
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Check frwr_wp_create() during connect
>=20
> Chris Mason <clm@meta.com>
>     xprtrdma: Initialize re_id before removal registration
>=20
> Chris Mason <clm@meta.com>
>     xprtrdma: Fix ep kref imbalance on ADDR_CHANGE
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf hists: Fix snprintf() in hists__scnprintf_title() UID filter path
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf bpf: Use scnprintf() in snprintf_hex() and synthesize_bpf_prog_n=
ame()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Fix idle-hist callchain display using wrong rb_first vari=
ant
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Bounds-check prio before test_bit() in timehist
>=20
> Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>     PCI: rcar-host: Remove unused LIST_HEAD(res)
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Use perf_env__get_cpu_topology() in machine__resolve()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Use scnprintf() in cpu_map__snprint() to prevent overflow
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Fix get_max_num() size_t underflow on empty sysfs file
>=20
> Jamie Nguyen <jamien@nvidia.com>
>     fs/ntfs3: resize log->one_page_buf when adopting on-disk page size
>=20
> Shuvam Pandey <shuvampandey1@gmail.com>
>     PCI: meson: Add missing remove callback
>=20
> Shuvam Pandey <shuvampandey1@gmail.com>
>     PCI: meson: Propagate devm_add_action_or_reset() failure
>=20
> Li RongQing <lirongqing@baidu.com>
>     PCI: mediatek: Fix operator precedence in PCIE_FTS_NUM_L0 macro
>=20
> Yang Erkun <yangerkun@huawei.com>
>     nfs: use nfsi->rwsem to protect traversal of the file lock list
>=20
> Mike Snitzer <snitzer@kernel.org>
>     NFSv4/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS in pg_get_mirror_count=
_write
>=20
> Mike Snitzer <snitzer@kernel.org>
>     NFSv4/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS on fatal DS connect er=
rors
>=20
> Clark Wang <xiaoning.wang@nxp.com>
>     nfs: keep PG_UPTODATE clear after read errors in page groups
>=20
> Dai Ngo <dai.ngo@oracle.com>
>     NFSv4/pnfs: defer return_range callbacks until after inode unlock
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Decouple req recycling from RPC completion
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Use sendctx DMA state for Send signaling
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Post receive buffers after RPC completion
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Close lost-wakeup race in xprt_rdma_alloc_slot
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     xprtrdma: Avoid 250 ms delay on backlog wakeup
>=20
> Sagi Grimberg <sagi@grimberg.me>
>     pNFS/filelayout: fix cheking if a layout is striped
>=20
> Phillip Varney <pbvarney@protonmail.com>
>     clk: qcom: a53: Corrected frequency multiplier for 1152MHz
>=20
> Nuno S=C3=A1 <nuno.sa@analog.com>
>     dmaengine: dma-axi-dmac: use DMA pool to manange DMA descriptor
>=20
> Nuno S=C3=A1 <nuno.sa@analog.com>
>     dmaengine: dma-axi-dmac: Properly free struct axi_dmac_desc
>=20
> Nuno S=C3=A1 <nuno.sa@analog.com>
>     dmaengine: Fix possible use after free
>=20
> Icenowy Zheng <zhengxingda@iscas.ac.cn>
>     dmaengine: qcom: gpi: set DMA_PRIVATE capability
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf timechart: Fix cpu2y() OOB read on untrusted CPU index
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf c2c: Fix use-after-free in he__get_c2c_hists() error path
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf stat: Introduce perf_env__get_cpu_topology() to guard NULL env->=
cpu
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf mmap: Fix NULL deref in aio cleanup on alloc failure
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Replace BUG_ON and add NULL checks in replay event helpers
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Use thread__put() in free_idle_threads()
>=20
> Namhyung Kim <namhyung@kernel.org>
>     perf sched: Fix thread leaks in 'perf sched timehist'
>=20
> Madadi Vineeth Reddy <vineethr@linux.ibm.com>
>     perf sched timehist: Add pre-migration wait time option
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Clean up idle_threads entry on init failure
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf c2c: Bounds-check CPU IDs in setup_nodes() topology loop
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf c2c: Bounds-check CPU and node IDs before bitmap and array access
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf stat: Bounds-check CPU index in topology aggregation callbacks
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf mmap: Guard cpu__get_node() return in aio_bind()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Fix register_pid() overflow, strcpy, and BUG_ON
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Add bounds check to cpu__get_node()
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Fix NULL dereference in latency_runtime_event
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Replace BUG_ON on invalid CPU with graceful skip
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf sched: Fix thread reference leak in latency_switch_event
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf tools: Guard test_bit from out-of-bounds sample CPU
>=20
> Rui Qi <qirui.001@bytedance.com>
>     perf: Fix off-by-one stack buffer overflow in kallsyms__parse()
>=20
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     dmaengine: imx-sdma: Refine spba bus searching in probe
>=20
> Xu Rao <raoxu@uniontech.com>
>     thunderbolt: debugfs: Fix margining error counter buffer leak
>=20
> Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
>     drm/amd/display: Add missing kdoc for ALLM parameters
>=20
> Jamie Nguyen <jamien@nvidia.com>
>     fs/ntfs3: fix mount failure on 64K page-size kernels
>=20
> Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
>     fs/ntfs3: add bounds check to run_get_highest_vcn()
>=20
> Rosen Penev <rosenp@gmail.com>
>     HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_=
counter
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     clk: at91: keep securam node alive while mapping it
>=20
> Aldo Conte <aldocontelk@gmail.com>
>     iio: tcs3472: power down chip on probe failure
>=20
> Sanjay Chitroda <sanjayembeddedse@gmail.com>
>     iio: accel: mma8452: handle I2C read error(s) in mma8452_read()
>=20
> Guilherme Ivo Bozi <guilherme.bozi@usp.br>
>     iio: adc: xilinx-ams: fix out-of-bounds channel lookup in event handl=
ing
>=20
> Joshua Crofts <joshua.crofts1@gmail.com>
>     iio: magnetometer: ak8975: fix potential kernel stack memory leak
>=20
> Joshua Crofts <joshua.crofts1@gmail.com>
>     iio: light: si1133: prevent race condition on timeout
>=20
> Joshua Crofts <joshua.crofts1@gmail.com>
>     iio: light: si1133: reset counter to prevent race condition
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf header: Sanity check HEADER_EVENT_DESC attr.size before swap
>=20
> Shawn Guo <shengchao.guo@oss.qualcomm.com>
>     PCI: qcom: Disable ASPM L0s for SA8775P
>=20
> James Kim <james010kim@gmail.com>
>     char: tlclk: fix use-after-free in tlclk_cleanup()
>=20
> Seungjin Bae <eeodqql09@gmail.com>
>     usb: host: max3421: Reject hub port requests for non-existent ports
>=20
> Seungjin Bae <eeodqql09@gmail.com>
>     usb: host: max3421: Fix shift-out-of-bounds in max3421_hub_control()
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     staging: most: video: avoid double free on video register failure
>=20
> Ian Rogers <irogers@google.com>
>     perf event: Fix size of synthesized sample with branch stacks
>=20
> Namhyung Kim <namhyung@kernel.org>
>     perf inject: Add --convert-callchain option
>=20
> Leo Yan <leo.yan@arm.com>
>     perf arm-spe: Add branch stack
>=20
> Graham Woodward <graham.woodward@arm.com>
>     perf arm-spe: Correctly set sample flags
>=20
> Graham Woodward <graham.woodward@arm.com>
>     perf arm-spe: Use ARM_SPE_OP_BRANCH_ERET when synthesizing branches
>=20
> Leo Yan <leo.yan@arm.com>
>     perf arm-spe: Use metadata to decide the data source feature
>=20
> Sergey Senozhatsky <senozhatsky@chromium.org>
>     mailbox: mtk-adsp: fix UAF during device teardown
>=20
> Jie Gan <jie.gan@oss.qualcomm.com>
>     coresight: Fix source not disabled on idr_alloc_u32 failure
>=20
> Mihai Sain <mihai.sain@microchip.com>
>     clk: at91: sam9x7: Fix gmac_gclk clock definition
>=20
> Leo Yan <leo.yan@arm.com>
>     perf pmu: Skip test on Arm64 when #slots is zero
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     phy: phy-can-transceiver: Check driver match and driver data against =
NULL
>=20
> Qiang Yu <qiang.yu@oss.qualcomm.com>
>     PCI: qcom: Set max OPP before DBI access during resume
>=20
> Sumit Kumar <sumit.kumar@oss.qualcomm.com>
>     bus: mhi: ep: Fix potential deadlock in mhi_ep_reset_worker()
>=20
> Hsiu Che Yu <yu.whisper.personal@gmail.com>
>     rust: alloc: fix assert in `Vec::reserve` doc test
>=20
> Rong Zhang <i@rong.moe>
>     PCI: loongson: Do not ignore downstream devices on external bridges
>=20
> Ian Rogers <irogers@google.com>
>     perf sched: Add missing mmap2 handler in timehist
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     platform/x86: xo15-ebook: Fix wakeup source and GPE handling
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     x86/platform/olpc: xo15: Drop wakeup source on driver removal
>=20
> Guixin Liu <kanie@linux.alibaba.com>
>     PCI: Check ROM header and data structure addr before accessing
>=20
> Guixin Liu <kanie@linux.alibaba.com>
>     PCI: Introduce named defines for PCI ROM
>=20
> Carlos Bilbao <carlos.bilbao@kernel.org>
>     PCI/ASPM: Don't reconfigure ASPM entering low-power state
>=20
> Leo Yan <leo.yan@arm.com>
>     coresight: etm4x: Correct TRCVMIDCCTLR1 save and restore
>=20
> Yingchao Deng <yingchao.deng@oss.qualcomm.com>
>     coresight: cti: Fix DT filter signals silently ignored
>=20
> Ian Rogers <irogers@google.com>
>     perf debuginfo: Fix libdw API contract violations
>=20
> Alexandru Hossu <hossu.alexandru@gmail.com>
>     staging: nvec: fix use-after-free in nvec_rx_completed()
>=20
> Mario Limonciello <mario.limonciello@amd.com>
>     gpiolib: acpi: Only trigger ActiveBoth interrupts on boot
>=20
> Nam Cao <namcao@linutronix.de>
>     eventpoll: Fix epoll_wait() report false negative
>=20
> Christian Brauner <brauner@kernel.org>
>     eventpoll: rename epi->next and txlist for clarity
>=20
> Christian Brauner <brauner@kernel.org>
>     eventpoll: wrap EP_UNACTIVE_PTR in typed sentinel helpers
>=20
> Christian Brauner <brauner@kernel.org>
>     eventpoll: extract ep_deliver_event() from ep_send_events()
>=20
> Christian Brauner <brauner@kernel.org>
>     eventpoll: split ep_insert() into alloc + register stages
>=20
> Christian Brauner <brauner@kernel.org>
>     eventpoll: rename attach_epitem() to ep_attach_file()
>=20
> Christian Brauner <brauner@kernel.org>
>     eventpoll: expand top-of-file overview / locking doc
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
>     net/9p: fix race condition on rdma->state in trans_rdma.c
>=20
> Aleksandr Nogikh <nogikh@google.com>
>     ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
>=20
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     mfd: cs42l43: Sanity check firmware size
>=20
> Matthew Bystrin <dev.mbstr@gmail.com>
>     mfd: rsmu: Fix page register setup
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     ksmbd: fix use-after-free in same_client_has_lease()
>=20
> Brett Creeley <brett.creeley@amd.com>
>     ionic: Fix check in ionic_get_link_ext_stats
>=20
> Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
>     dt-bindings: net: updated interrupt type to be active low, level trig=
gered
>=20
> Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
>     net: ethernet: oa_tc6: Remove FCS size in RX frame
>=20
> Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
>     net: ethernet: oa_tc6: mdiobus->parent initialized with NULL
>=20
> Wayen.Yan <win847@gmail.com>
>     net: airoha: Fix always-true condition in PPE1 queue reservation loop
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>     net: airoha: Add sched ETS offload support
>=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>     net: airoha: Introduce ndo_select_queue callback
>=20
> Eric Dumazet <edumazet@google.com>
>     tcp: ipv6: clamp default adverting MSS to avoid GSO_BY_FRAGS (0xFFFF)
>=20
> Eric Dumazet <edumazet@google.com>
>     tipc: fix UAF in tipc_l2_send_msg()
>=20
> Gui-Dong Han <hanguidong02@gmail.com>
>     KEYS: Use acquire when reading state in keyring search
>=20
> Aboorva Devarajan <aboorvad@linux.ibm.com>
>     powerpc/kexec: fix double get_cpu() imbalance in kexec_prepare_cpus
>=20
> Aboorva Devarajan <aboorvad@linux.ibm.com>
>     powerpc/powernv: fix preempt count leak in pnv_kexec_wait_secondaries=
_down
>=20
> Aboorva Devarajan <aboorvad@linux.ibm.com>
>     powerpc/perf: fix preempt count underflow in fsl_emb_pmu_del
>=20
> Yadan Fan <ydfan@suse.com>
>     MIPS: mm: Fix out-of-bounds write in maar_res_walk()
>=20
> Sechang Lim <rhkrqnwk98@gmail.com>
>     bpf, sockmap: fix integer overflow in bpf_msg_pop_data() bounds check
>=20
> Weiming Shi <bestswngs@gmail.com>
>     bpf, sockmap: reject overflowing copy + len in bpf_msg_push_data()
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     udf: fix nls leak on udf_fill_super() failure
>=20
> Leon Hwang <leon.hwang@linux.dev>
>     bpf: Fix bpf_get/setsockopt to tos for ipv4-mapped ipv6 socket
>=20
> Leo Yan <leo.yan@arm.com>
>     selftests/bpf: Initialize operation name before use
>=20
> Jiri Olsa <jolsa@kernel.org>
>     selftests/bpf: Fix typo in verify_umulti_link_info
>=20
> Huiwen He <hehuiwen@kylinos.cn>
>     smb/client: always return a value for FS_IOC_GETFLAGS
>=20
> Jian Zhang <zhangjian496@huawei.com>
>     cifs: remove all cifs files before kill super
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: nf_conncount: callers must hold rcu read lock
>=20
> Runyu Xiao <runyu.xiao@seu.edu.cn>
>     kcm: use WRITE_ONCE() when changing lower socket callbacks
>=20
> Ovidiu Panait <ovidiu.panait.rb@renesas.com>
>     net: bcmgenet: Use weighted round-robin TX DMA arbitration
>=20
> Matthieu Buffet <matthieu@buffet.re>
>     landlock: Fix unmarked concurrent access to socket family
>=20
> Grzegorz Nitka <grzegorz.nitka@intel.com>
>     dpll: balance create/delete notifications in __dpll_pin_(un)register
>=20
> Grzegorz Nitka <grzegorz.nitka@intel.com>
>     dpll: guard sync-pair removal on full pin unregister
>=20
> Grzegorz Nitka <grzegorz.nitka@intel.com>
>     dpll: emit per-dpll delete notifications in dpll_pin_on_pin_unregiste=
r()
>=20
> Grzegorz Nitka <grzegorz.nitka@intel.com>
>     dpll: send delete notification before unregister in on-pin rollback
>=20
> Grzegorz Nitka <grzegorz.nitka@intel.com>
>     dpll: fix stale iteration in dpll_pin_on_pin_unregister()
>=20
> Ivan Vecera <ivecera@redhat.com>
>     dpll: Enhance and consolidate reference counting logic
>=20
> Ivan Vecera <ivecera@redhat.com>
>     dpll: Support dynamic pin index allocation
>=20
> Petr Oros <poros@redhat.com>
>     dpll: Add notifier chain for dpll events
>=20
> Ivan Vecera <ivecera@redhat.com>
>     dpll: Allow associating dpll pin with a firmware node
>=20
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     dpll: add reference sync get/set
>=20
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     dpll: add reference-sync netlink attribute
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     net: wwan: t7xx: check skb_clone in control TX
>=20
> Wentao Guan <guanwentao@uniontech.com>
>     net: ethernet: mtk_wed: debugfs: correct index in wed_amsdu_show()
>=20
> Ratheesh Kannoth <rkannoth@marvell.com>
>     octeontx2-af: npc: Fix size of entry2cntr_map
>=20
> Dragos Tatulea <dtatulea@nvidia.com>
>     net/mlx5: Check max_macs devlink param value against max capability
>=20
> Sun Jian <sun.jian.kdev@gmail.com>
>     bpf: Run generic devmap egress prog on private skb
>=20
> Zhi-Jun You <hujy652@gmail.com>
>     net: ethernet: mtk_wed: fix loading WO firmware for MT7986
>=20
> Aditya Garg <gargaditya@linux.microsoft.com>
>     net: mana: guard TX wq object destroy with INVALID_MANA_HANDLE check
>=20
> Aditya Garg <gargaditya@linux.microsoft.com>
>     net: mana: initialize gdma queue id to INVALID_QUEUE_ID
>=20
> Victor Nogueira <victor@mojatatu.com>
>     net/sched: sch_codel: Do not call qdisc_tree_reduce_backlog during pe=
ek before restoring qlen
>=20
> Victor Nogueira <victor@mojatatu.com>
>     net/sched: sch_fq_codel: Do not call qdisc_tree_reduce_backlog during=
 peek before restoring qlen
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     handshake: Require admin permission for DONE command
>=20
> Lucas Tsai <lucas_tsai@richtek.com>
>     power: supply: core: fix supplied_from allocations
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     ASoC: adau1372: Clear PLL_EN on failed PLL lock without reset GPIO
>=20
> Lars P=C3=B6schel <lars.poeschel@edag.com>
>     spi: xilinx: use FIFO occupancy register to determine buffer size
>=20
> HanQuan <eilaimemedsnaimel@gmail.com>
>     ALSA: seq: Fix kernel heap address leak in bounce_error_event()
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: rng - Free default RNG on module exit
>=20
> Felix Gu <ustc.gu@gmail.com>
>     crypto: cavium/cpt - fix DMA cleanup using wrong loop index
>=20
> Felix Gu <ustc.gu@gmail.com>
>     crypto: marvell/octeontx - fix DMA cleanup using wrong loop index
>=20
> Dave Jiang <dave.jiang@intel.com>
>     cxl/test: Add check after kzalloc() memory in alloc_mock_res()
>=20
> Dave Jiang <dave.jiang@intel.com>
>     cxl/test: Unregister cxl_acpi in cxl_test_init() error path
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     tipc: reject inverted service ranges from peer bindings
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     tipc: prevent snt_unacked underflow on CONN_ACK
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     tipc: require net admin for TIPCv2 netlink mutators
>=20
> Victor Nogueira <victor@mojatatu.com>
>     net/sched: sch_hfsc: Don't make class passive twice
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     net: pfcp: allocate per-cpu tstats for PFCP netdevs
>=20
> Xin Long <lucien.xin@gmail.com>
>     sctp: validate embedded address parameter length
>=20
> Xiang Mei <xmei5@asu.edu>
>     bridge: cfm: reject invalid CCM interval at configuration time
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     net: fib_rules: Don't dump dying fib_rule in fib_rules_dump().
>=20
> Jamal Hadi Salim <jhs@mojatatu.com>
>     net/sched: cls_flow: Dont expose folded kernel pointers
>=20
> George Moussalem <george.moussalem@outlook.com>
>     net: dsa: qca8k: fix led devicename when using external mdio bus
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: tegra: tegra210_ahub: Validate written enum value
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: fsl: fsl_audmix: Validate written enum values
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ASoC: codecs: hdac_hdmi: Validate written enum value
>=20
> Leon Romanovsky <leon@kernel.org>
>     RDMA/mlx5: Release the HW=E2=80=91provided UAR index rather than the =
SW one
>=20
> Maher Sanalla <msanalla@nvidia.com>
>     RDMA/mlx5: Fix undefined shift of user RQ WQE size
>=20
> Patrisious Haddad <phaddad@nvidia.com>
>     RDMA/mlx5: Remove raw RSS QP restrack tracking
>=20
> Patrisious Haddad <phaddad@nvidia.com>
>     RDMA/mlx5: Remove DCT restrack tracking
>=20
> Maxwell Doose <m32285159@gmail.com>
>     fs: efs: remove unneeded debug prints
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     Bluetooth: vhci: validate devcoredump state before side effects
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     Bluetooth: hci: validate codec capability element length
>=20
> Zhao Dongdong <zhaodongdong@kylinos.cn>
>     Bluetooth: btmtk: fix URB leak in alloc_mtk_intr_urb error path
>=20
> Jordan Walters <jaggyaur@gmail.com>
>     Bluetooth: hci_core: Fix UAF in hci_unregister_dev()
>=20
> Weiming Shi <bestswngs@gmail.com>
>     Bluetooth: eir: Fix stack OOB write when prepending the Flags AD
>=20
> Zijun Hu <zijun.hu@oss.qualcomm.com>
>     Bluetooth: hci_qca: fix NULL pointer dereference in qca_dmp_hdr() for=
 non-serdev device
>=20
> Heiko Carstens <hca@linux.ibm.com>
>     s390/process: Fix kernel thread function pointer type
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs35l56: Fix possible uninitialized value in cs35l56_spi_system=
_reset()
>=20
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Tighten cgroup storage cookie checks for prog arrays
>=20
> Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>     vfio/qat: fix f_pos race in qat_vf_resume_write()
>=20
> Sergey Shtylyov <s.shtylyov@auroraos.dev>
>     of: cpu: add check in __of_find_n_match_cpu_property()
>=20
> Dave Jiang <dave.jiang@intel.com>
>     cxl/test: Zero out LSA backing memory to avoid leaking to user
>=20
> Dave Jiang <dave.jiang@intel.com>
>     cxl/test: Fix integer overflow in mock LSA bounds checks
>=20
> Yonghong Song <yonghong.song@linux.dev>
>     selftests/bpf: Fix bpf_iter/task_vma test
>=20
> Yun Zhou <yun.zhou@windriver.com>
>     ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
>=20
> Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
>     ext4: fix kernel BUG in ext4_write_inline_data_end
>=20
> Louis Scalbert <louis.scalbert@6wind.com>
>     bonding: 3ad: fix mux port state on oper down
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs35l56: Don't leave parent IRQ disabled if system_suspend fails
>=20
> Richard Fitzgerald <rf@opensource.cirrus.com>
>     ASoC: cs35l56: Fix missing calls to wm_adsp2_remove()
>=20
> Srujana Challa <schalla@marvell.com>
>     vdpa/octeon_ep: Fix PF->VF mailbox data address calculation
>=20
> longlong yan <yanlonglong@kylinos.cn>
>     tools/virtio: check mmap return value in vringh_test
>=20
> Qing Ming <a0yami@mailbox.org>
>     vhost/net: complete zerocopy ubufs only once
>=20
> Zhang Tianci <zhangtianci.1997@bytedance.com>
>     vduse: Requeue failed read to send_list head
>=20
> Filip Hejsek <filip.hejsek@gmail.com>
>     virtio_console: read size from config space during device init
>=20
> Qihang Tang <q.h.hack.winter@gmail.com>
>     vhost/vdpa: validate virtqueue index in mmap and fault paths
>=20
> Qihang Tang <q.h.hack.winter@gmail.com>
>     vduse: hold vduse_lock across IDR lookup in open path
>=20
> Val Packett <val@packett.cool>
>     ASoC: codecs: aw88261: fix incorrect masks for boost regs
>=20
> Ruoyu Wang <ruoyuw560@gmail.com>
>     spi: meson-spifc: fix runtime PM leak on remove
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: Handle layout stid in nfsd4_drop_revoked_stid()
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     IB/mlx4: Fill in the access_flags if IB_MR_REREG_ACCESS is not specif=
ied
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix deadlock cloning inline extent when using flushoncommit
>=20
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: zoned: don't account data relocation space-info in statfs free=
 space
>=20
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>     hwmon: (it87) Clamp negative values to zero in set_fan()
>=20
> David Laight <david.laight.linux@gmail.com>
>     fbdev: sm501fb: Fix buffer errors in OF binding code
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()
>=20
> Ryder Lee <ryder.lee@mediatek.com>
>     wifi: mt76: mt7996: fix potential tx_retries underflow
>=20
> Ryder Lee <ryder.lee@mediatek.com>
>     wifi: mt76: mt7925: fix potential tx_retries underflow
>=20
> Ryder Lee <ryder.lee@mediatek.com>
>     wifi: mt76: mt7921: fix potential tx_retries underflow
>=20
> Ryder Lee <ryder.lee@mediatek.com>
>     wifi: mt76: mt7915: fix potential tx_retries underflow
>=20
> Bjoern A. Zeeb <bz@FreeBSD.org>
>     wifi: mt76: fix argument to ieee80211_is_first_frag()
>=20
> Sean Wang <sean.wang@mediatek.com>
>     wifi: mt76: mt792x: skip MLD header rewrite for 802.3 encap TX
>=20
> Sean Wang <sean.wang@mediatek.com>
>     wifi: mt76: mt7925: keep TX BA state in the primary WCID
>=20
> Javier Tia <floss@jetm.me>
>     wifi: mt76: mt7925: fix stale pointer comparisons in change_vif_links
>=20
> Myeonghun Pak <mhun512@gmail.com>
>     wifi: mt76: mt7925: clean up DMA on probe failure
>=20
> Hongyan Xia <hongyan.xia@transsion.com>
>     sched/fair: Fix cpu_util runnable_avg arithmetic
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>     hwspinlock: qcom: avoid uninitialized struct members
>=20
> Hui Zhu <zhuhui@kylinos.cn>
>     vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
>=20
> Luca Leonardo Scorcia <l.scorcia@gmail.com>
>     pinctrl: mediatek: mt8167: Fix Schmitt trigger register offset of pin=
s 34-39
>=20
> Luca Leonardo Scorcia <l.scorcia@gmail.com>
>     pinctrl: mediatek: mt8516: Fix Schmitt trigger register offset of pin=
s 34-39
>=20
> Mike Christie <michael.christie@oracle.com>
>     scsi: target: Remove tcm_loop target reset handling
>=20
> David Disseldorp <ddiss@suse.de>
>     scsi: target: Fix hexadecimal CHAP_I handling
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     watchdog: unregister PM notifier on watchdog unregister
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     configfs: fix lockless traversals of ->s_children
>=20
> Dmitry Vyukov <dvyukov@google.com>
>     firmware_loader: Fix recursive lock in device_cache_fw_images()
>=20
> Aaron Ma <aaron.ma@canonical.com>
>     ASoC: amd: acp-sdw-sof: Bound DAI link iteration
>=20
> Felix Gu <ustc.gu@gmail.com>
>     spi: ep93xx: fix double-free of zeropage on DMA setup failure
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     IB/mlx5: Properly support implicit ODP rereg_mr
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     IB/mlx5: Don't take the rereg_mr fallback without a new translation
>=20
> Samuel Moelius <sam.moelius@trailofbits.com>
>     thermal: testing: reject missing command arguments
>=20
> Pengjie Zhang <zhangpengjie2@huawei.com>
>     cpufreq: Documentation: fix conservative governor freq_step descripti=
on
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     ACPI: IPMI: Fix message kref handling on dead device
>=20
> Kyle Zeng <kylebot@openai.com>
>     ALSA: seq: Clear variable event pointer on read
>=20
> Rui Qi <qirui.001@bytedance.com>
>     riscv: stacktrace: Remove bogus -0x4 offset in non-FP walk_stackframe
>=20
> Hui Wang <hui.wang@canonical.com>
>     riscv: cpu_ops: Change return value type of cpu_is_stopped() to bool
>=20
> HyeongJun An <sammiee5311@gmail.com>
>     ALSA: seq: Fix partial userptr event expansion
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     wifi: wcn36xx: fix OOB read from short trigger BA firmware response
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     wifi: wcn36xx: fix OOB read from firmware count in PRINT_REG_INFO ind=
ication
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     wifi: wcn36xx: fix heap overflow from oversized firmware HAL response
>=20
> Leon Hwang <leon.hwang@linux.dev>
>     bpf: Update transport_header when encapsulating UDP tunnel in lwt
>=20
> Leon Hwang <leon.hwang@linux.dev>
>     bpf: Check tail zero of bpf_prog_info
>=20
> Bernard Metzler <bernard.metzler@linux.dev>
>     RDMA/siw: Fix endpoint/socket association handling
>=20
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     arm64: dts: tqma8mpql-mba8mpxl: configure sai clock in audio codec as=
 well
>=20
> Richard Zhu <hongxing.zhu@nxp.com>
>     arm64: dts: imx95: Correct PCIe outbound address space configuration
>=20
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Initialize iwmr->access during MR registration
>=20
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Fix OOB read during CQ MR registration
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     IB/cm: Fix av cm device leak on an error path in cm_init_av_by_path()
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helpe=
r is pptp
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: conntrack: revert ct extension genid infrastructure
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: synproxy: fix unaligned memory access in timestamp adjustm=
ent
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: synproxy: adjust duplicate timestamp options
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: synproxy: drop packets if timestamp adjustment fails
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing he=
lper flags
>=20
> Fernando Fernandez Mancera <fmancera@suse.de>
>     netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
>=20
> Joseph Qi <joseph.qi@linux.alibaba.com>
>     ocfs2: fix race between ocfs2_control_install_private() and ocfs2_con=
trol_release()
>=20
> Zhang Cen <rollkingzzc@gmail.com>
>     ocfs2/dlm: require a ref for locking_state debugfs open
>=20
> Zhang Cen <rollkingzzc@gmail.com>
>     ocfs2: reject FITRIM ranges shorter than a cluster
>=20
> Dmitry Antipov <dmantipov@yandex.ru>
>     ocfs2: fix buffer head management in ocfs2_read_blocks()
>=20
> Zhang Cen <rollkingzzc@gmail.com>
>     ocfs2: rebase copied fsdlm LVB pointers in locking_state
>=20
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdkfd: always resume_all after suspend_all
>=20
> Antony Antony <antony.antony@secunet.com>
>     xfrm: fix NAT-related field inheritance in SA migration
>=20
> Sandipan Das <sandipan.das@amd.com>
>     perf/x86/amd/uncore: Use Node ID to identify DF and UMC domains
>=20
> Zide Chen <zide.chen@intel.com>
>     perf/x86/intel/uncore: Fix discovery unit lookup for multi-die systems
>=20
> Sandipan Das <sandipan.das@amd.com>
>     perf/x86/amd/core: Always use the NMI latency mitigation
>=20
> Michael S. Tsirkin <mst@redhat.com>
>     vhost: fix vhost_get_avail_idx for a non empty ring
>=20
> Woojin Ji <random6.xyz@gmail.com>
>     bpftool: Use libbpf error code for flow dissector query
>=20
> Yunxiang Li <Yunxiang.Li@amd.com>
>     drm/amdgpu: set sub_block_index for mca ras sub-blocks
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     configfs_lookup(): don't leave ->s_dentry dangling on failure
>=20
> Alexander Potapenko <glider@google.com>
>     lib/test_meminit: use && for bools
>=20
> Frederic Weisbecker <frederic@kernel.org>
>     tick/sched: Fix TOCTOU in nohz idle time fetch
>=20
> Nathan Chancellor <nathan@kernel.org>
>     driver core: Use system_percpu_wq instead of system_wq
>=20
> Guanyou.Chen <chenguanyou9338@gmail.com>
>     sched: restore timer_slack_ns when resetting RT policy on fork
>=20
> Danila Chernetsov <listdansp@mail.ru>
>     ext2: fix ignored return value of generic_write_sync()
>=20
> Sang-Heon Jeon <ekffu200098@gmail.com>
>     mm/fake-numa: fix under-allocation detection in uniform split
>=20
> Deepanshu Kartikey <kartikey406@gmail.com>
>     bpf: fix UAF by restoring RCU-delayed inode freeing in bpffs
>=20
> Chanwoo Lee <cw9316.lee@samsung.com>
>     scsi: ufs: Fix wrong value printed in unexpected UPIU response case
>=20
> Dan Carpenter <error27@gmail.com>
>     scsi: pm8001: Fix error code in non_fatal_log_show()
>=20
> Martin Wilck <martin.wilck@suse.com>
>     scsi: Revert "scsi: Fix sas_user_scan() to handle wildcard and multi-=
channel scans"
>=20
> Alison Schofield <alison.schofield@intel.com>
>     nvdimm/btt: Handle preemption in BTT lane acquisition
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     ARM: imx31: Fix IIM mapping leak in revision check
>=20
> Bart Van Assche <bvanassche@acm.org>
>     ata: libata: Fix ata_exec_internal()
>=20
> J. Neusch=C3=A4fer <j.ne@posteo.net>
>     HID: wiimote: Fix table layout and whitespace errors
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     ARM: imx3: Fix CCM node reference leak
>=20
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: Fix delegation reference leak in nfsd4_revoke_states
>=20
> John Madieu <john.madieu.xa@bp.renesas.com>
>     ASoC: rsnd: Fix RSND_SOC_MASK width to single nibble
>=20
> Zhang Yi <yi.zhang@huawei.com>
>     ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data write=
back
>=20
> Chen Cheng <chencheng@fnnas.com>
>     md/raid10: reset read_slot when reusing r10bio for discard
>=20
> Danilo Krummrich <dakr@kernel.org>
>     rpmsg: use generic driver_override infrastructure
>=20
> Danilo Krummrich <dakr@kernel.org>
>     Drivers: hv: vmbus: use generic driver_override infrastructure
>=20
> Danilo Krummrich <dakr@kernel.org>
>     cdx: use generic driver_override infrastructure
>=20
> Danilo Krummrich <dakr@kernel.org>
>     amba: use generic driver_override infrastructure
>=20
> Renjiang Han <renjiang.han@oss.qualcomm.com>
>     media: qcom: venus: relax encoder frame/blur step size on v6
>=20
> Renjiang Han <renjiang.han@oss.qualcomm.com>
>     media: qcom: venus: relax encoder frame/blur dimension steps on v4
>=20
> Renjiang Han <renjiang.han@oss.qualcomm.com>
>     media: qcom: venus: drop extra padding in NV12 raw size calculation
>=20
> Tristan Madani <tristmd@gmail.com>
>     RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path
>=20
> Tristan Madani <tristmd@gmail.com>
>     RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
>=20
> zhoumin <teczm@foxmail.com>
>     EDAC/{skx_common,skx}: Fix UBSAN shift-out-of-bounds in skx_get_dimm_=
info
>=20
> Jessica Zhang <jessica.zhang@oss.qualcomm.com>
>     drm/msm/dp: Fix the ISR_* enum values
>=20
> Jessica Zhang <jessica.zhang@oss.qualcomm.com>
>     drm/msm/dp: fix HPD state status bit shift value
>=20
> Andrea Righi <arighi@nvidia.com>
>     sched/deadline: Reject debugfs dl_server writes for offline CPUs
>=20
> Juri Lelli <juri.lelli@redhat.com>
>     sched/deadline: Always stop dl-server before changing parameters
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: tegra - Return ENOMEM when input buffer allocation fails for =
ccm
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: tegra - Fix dma_free_coherent size error
>=20
> Weili Qian <qianweili@huawei.com>
>     crypto: hisilicon/qm - disable error report before flr
>=20
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>     ocfs2: kill osb->system_file_mutex lock
>=20
> ZhengYuan Huang <gality369@gmail.com>
>     ocfs2: don't BUG_ON an invalid journal dinode
>=20
> Dan Carpenter <error27@gmail.com>
>     rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()
>=20
> Davidlohr Bueso <dave@stgolabs.net>
>     dax/kmem: account for partial discontiguous resource upon removal
>=20
> Carlos Llamas <cmllamas@google.com>
>     libbpf: Fix UAF in strset__add_str()
>=20
> Siddharth Nayyar <sidnayyar@google.com>
>     bpftool: Fix typo in struct_ops map FD generation for light skeleton
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     libbpf: Harden parse_vma_segs() path parsing
>=20
> Timur Tabi <ttabi@nvidia.com>
>     drm/nouveau/bios: specify correct display fuse register for Ampere an=
d Ada
>=20
> Mikko Perttunen <mperttunen@nvidia.com>
>     drm/tegra: Fix iommu_map_sgtable() return value check
>=20
> Mikko Perttunen <mperttunen@nvidia.com>
>     gpu: host1x: Fix iommu_map_sgtable() return value check
>=20
> Felix Gu <ustc.gu@gmail.com>
>     drm/tegra: dc: Fix device node reference leak in tegra_dc_has_output()
>=20
> Mikko Perttunen <mperttunen@nvidia.com>
>     gpu: host1x: Allow entries in BO caches to be freed
>=20
> Ion Agorria <ion@agorria.com>
>     drm/tegra: gr2d/gr3d: Contain PM in the gr*d_probe/gr*d_remove
>=20
> Svyatoslav Ryhel <clamor95@gmail.com>
>     drm/tegra: gr2d/gr3d: Initialize address register map before HOST1X c=
lient is registered
>=20
> Jiayuan Chen <jiayuan.chen@linux.dev>
>     net/sched: cls_bpf: prevent unbounded recursion in offload rollback
>=20
> Eric Dumazet <edumazet@google.com>
>     ipv6: guard against possible NULL deref in __in6_dev_stats_get()
>=20
> Breno Leitao <leitao@debian.org>
>     workqueue: drop spurious '*' from print_worker_info() fn declaration
>=20
> Nilay Shroff <nilay@linux.ibm.com>
>     nvme-multipath: fix flex array size in struct nvme_ns_head
>=20
> Geliang Tang <geliang@kernel.org>
>     nvmet-tcp: fix page fragment cache leak in error path
>=20
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     pinctrl: cs42l43: Fix polarity on debounce
>=20
> Joey Lu <a0987203069@gmail.com>
>     pinctrl: nuvoton: ma35d1: fix MFP register offset and pin table
>=20
> Zhang Cen <rollkingzzc@gmail.com>
>     ALSA: seq: midi: Serialize output teardown with event_input
>=20
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mtd: spi-nor: Drop duplicate Kconfig dependency
>=20
> Danilo Krummrich <dakr@kernel.org>
>     driver core: Guard deferred probe timeout extension with delayed_work=
_pending()
>=20
> Danilo Krummrich <dakr@kernel.org>
>     driver core: Fix missing jiffies conversion in deferred_probe_extend_=
timeout()
>=20
> Easwar Hariharan <eahariha@linux.microsoft.com>
>     jiffies: Define secs_to_jiffies()
>=20
> Rosen Penev <rosenp@gmail.com>
>     mips: n64: add __iomem for writel call
>=20
> Rosen Penev <rosenp@gmail.com>
>     mips: ralink: mt7621: add missing __iomem
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: DEC: Remove do_IRQ() call indirection
>=20
> Maciej W. Rozycki <macro@orcam.me.uk>
>     MIPS: Fix big-endian stack argument fetching in o32 wrapper
>=20
> Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
>     PM: sleep: Use complete() in device_pm_sleep_init()
>=20
> Tao Cui <cuitao@kylinos.cn>
>     RDMA/counter: Fix incorrect port index in rdma_counter_init() error c=
leanup
>=20
> Lianfa Weng <wenglianfa@huawei.com>
>     RDMA/hns: Fix log flood after cmd_mbox failure
>=20
> Lianfa Weng <wenglianfa@huawei.com>
>     RDMA/hns: Fix warning in poll cq direct mode
>=20
> Guangshuo Li <lgs201920130244@gmail.com>
>     IB/mlx4: Fix refcount leak in add_port() error path
>=20
> Zhu Yanjun <yanjun.zhu@linux.dev>
>     RDMA/rxe: Fix a use-after-free problem in rxe_mmap
>=20
> Jacob Moroni <jmoroni@google.com>
>     RDMA/irdma: Fix out-of-bounds write in irdma_copy_user_pgaddrs
>=20
> Samuel Holland <samuel@sholland.org>
>     bus: sunxi-rsb: Always check register address validity
>=20
> Shiraz Saleem <shirazsaleem@microsoft.com>
>     RDMA/mana_ib: Use ib_get_eth_speed for reporting port speed
>=20
> Ronaldo Nunez <rnunez@baylibre.com>
>     pwm: imx27: Fix variable truncation in .apply()
>=20
> Lifeng Zheng <zhenglifeng1@huawei.com>
>     cpufreq: conservative: Simplify frequency limit handling
>=20
> Pengjie Zhang <zhangpengjie2@huawei.com>
>     cpufreq: Documentation: fix sampling_down_factor range
>=20
> Saravana Kannan <saravanak@google.com>
>     Revert "treewide: Fix probing of devices in DT overlays"
>=20
> Zhang Yuwei <zhangyuwei20@huawei.com>
>     driver core: Use mod_delayed_work to prevent lost deferred probe work
>=20
> Stepan Ionichev <sozdayvek@gmail.com>
>     device property: fix fwnode reference leak in fwnode_graph_get_endpoi=
nt_by_id()
>=20
> Baokun Li <libaokun@linux.alibaba.com>
>     writeback: drop now-unnecessary rcu_barrier() in cgroup_writeback_umo=
unt()
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     tracing: Bound synthetic-field strings with seq_buf
>=20
> Harshal Dev <harshal.dev@oss.qualcomm.com>
>     arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node
>=20
> Harshal Dev <harshal.dev@oss.qualcomm.com>
>     arm64: dts: qcom: sm8450: Add power-domain and iface clk for ice node
>=20
> Harshal Dev <harshal.dev@oss.qualcomm.com>
>     arm64: dts: qcom: kodiak: Add power-domain and iface clk for ice node
>=20
> Harshal Dev <harshal.dev@oss.qualcomm.com>
>     arm64: dts: qcom: sc7180: Add power-domain and iface clk for ice node
>=20
> Geert Uytterhoeven <geert+renesas@glider.be>
>     firmware: arm_scmi: Fix OOB in scmi_power_name_get()
>=20
> Sven P=C3=BCschel <s.pueschel@pengutronix.de>
>     media: rockchip: rga: fix too small buffer size
>=20
> Eric Dumazet <edumazet@google.com>
>     net/sched: sch_drr: annotate data-races around cl->deficit
>=20
> Chen-Yu Tsai <wenst@chromium.org>
>     regulator: dt-bindings: mt6359: Drop regulator-name pattern restricti=
ons
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     bitops: use common function parameter names
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     sysfs: clamp show() return value in sysfs_kf_read()
>=20
> Sudeep Holla <sudeep.holla@kernel.org>
>     firmware: arm_scmi: Read sensor config as 32-bit value
>=20
> Jose A. Perez de Azpillaga <azpijr@gmail.com>
>     staging: media: atomisp: fix loop shadowing in ia_css_stream_destroy()
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     media: atomisp: gc2235: fix UAF and memory leak
>=20
> Zilin Guan <zilin@seu.edu.cn>
>     media: atomisp: Fix memory leak in atomisp_fixed_pattern_table()
>=20
> Kevin Brodsky <kevin.brodsky@arm.com>
>     selftests/mm: Fix resv_sz when parsing arm64 signal frame
>=20
> Roman Kvasnytskyi <roman@kvasnytskyi.net>
>     selftests/bpf: Reject unsupported -k option in vmtest.sh
>=20
> Liviu Dudau <liviu.dudau@arm.com>
>     drm/syncobj: Fix memory leak in drm_syncobj_find_fence()
>=20
> Junxian Huang <huangjunxian6@hisilicon.com>
>     RDMA/hns: Initialize seqfile before creating file
>=20
> Sara Venkatesh <sarajvenkatesh@gmail.com>
>     RDMA/srpt: fix integer overflow in immediate data length check
>=20
> Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
>     RDMA/mlx5: Fix devx subscribe-event unwind NULL dereference
>=20
> Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
>     RDMA/hns: Fix arithmetic overflow in calc_hem_config()
>=20
> Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
>     IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier
>=20
> Linmao Li <lilinmao@kylinos.cn>
>     ipv6: addrconf: bail out of dad_failure when state is no longer POSTD=
AD
>=20
> Eric Dumazet <edumazet@google.com>
>     net/sched: sch_htb: annotate data-races (I)
>=20
> Eric Dumazet <edumazet@google.com>
>     net/sched: sch_htb: do not change sch->flags in htb_dump()
>=20
> Qiang Ma <maqianga@uniontech.com>
>     spi: hisi-kunpeng: Use dev_err_probe() for host registration failure
>=20
> Sean Christopherson <seanjc@google.com>
>     crypto: ccp - Treat zero-length cert chain as query for blob lengths
>=20
> Eric Dumazet <edumazet@google.com>
>     net/sched: sch_hfsc: annotate data-races in hfsc_dump_class_stats()
>=20
> Stepan Ionichev <sozdayvek@gmail.com>
>     clk: scpi: Unregister child clock providers on remove
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     thermal: hwmon: Fix critical temperature attribute removal
>=20
> Pengpeng Hou <pengpeng@iscas.ac.cn>
>     evm: terminate and bound the evm_xattrs read buffer
>=20
> Lin He <helin52@huawei.com>
>     drm/hisilicon/hibmc: use clock to look up the PLL value
>=20
> Lin He <helin52@huawei.com>
>     drm/hisilicon/hibmc: move display contrl config to hibmc_probe()
>=20
> Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>     arm64: dts: qcom: sm8450: Fix ICE reg size
>=20
> Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>     arm64: dts: qcom: kodiak: Fix ICE reg size
>=20
> Cristian Marussi <cristian.marussi@arm.com>
>     clk: scmi: Fix clock rate rounding
>=20
> Hsiu Che Yu <yu.whisper.personal@gmail.com>
>     rust: alloc: fix `Vec::extend_with` SAFETY comment
>=20
> Chen-Yu Tsai <wenst@chromium.org>
>     arm64: dts: mediatek: mt8192-asurada: Move PCIe DMA bounce buffer to =
host
>=20
> Sean Christopherson <seanjc@google.com>
>     iommu/amd: Fix a stale comment about which legacy mode is user visible
>=20
> Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
>     media: qcom: camss: vfe: fix PIX subdev naming on VFE lite
>=20
> Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>     nilfs2: fix backing_dev_info reference leak
>=20
> Alexander Aring <aahringo@redhat.com>
>     dlm: fix add msg handle in send_queue ordered
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     ARM: multi_v7_defconfig: Correct QCOM_RPMH and QCOM_RPMHPD
>=20
> Weiming Shi <bestswngs@gmail.com>
>     crypto: asymmetric_keys - fix OOB read in pefile_digest_pe_contents
>=20
> Thorsten Blum <thorsten.blum@linux.dev>
>     crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
>=20
> Lothar Rubusch <l.rubusch@gmail.com>
>     crypto: atmel-sha204a - fix blocking and non-blocking rng logic
>=20
> Tycho Andersen (AMD) <tycho@kernel.org>
>     crypto: ccp - Fix snp_filter_reserved_mem_regions() off-by-one
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
>=20
> Peng Fan <peng.fan@nxp.com>
>     arm64: dts: imx8x-colibri: Correct SODIMM PAD settings
>=20
> Weixin Guo <2298701336@qq.com>
>     arm64: dts: rockchip: fix rk809 interrupt pin on rk3566-roc-pc
>=20
> Alice Ryhl <aliceryhl@google.com>
>     drm/gpuvm: take refcount on DRM device
>=20
> Felix Gu <ustc.gu@gmail.com>
>     pinctrl: sunxi: fix regulator leak in sunxi_pmx_request() error path
>=20
> Damian Muszynski <damian.muszynski@intel.com>
>     crypto: qat - fix heartbeat error injection
>=20
> Ashish Mhetre <amhetre@nvidia.com>
>     memory: tegra: Wire up system sleep PM ops
>=20
> Nas Chung <nas.chung@chipsnmedia.com>
>     media: v4l2-common: Add YUV24 format info
>=20
> Samuel Holland <samuel@sholland.org>
>     media: cedrus: Fix failure to clean up hardware on probe failure
>=20
> Felix Gu <ustc.gu@gmail.com>
>     watchdog: sprd_wdt: Remove redundant sprd_wdt_disable() on register f=
ailure
>=20
> Balakrishnan Sambath <balakrishnan.s@microchip.com>
>     watchdog: sama5d4_wdt: Fix WDDIS detection on SAM9X60 and SAMA7G5
>=20
> Yingjie Gao <gaoyingjie@uniontech.com>
>     watchdog: sp5100_tco: Use EFCH MMIO for newer Hygon FCH
>=20
> Jihed Chaibi <jihed.chaibi.dev@gmail.com>
>     ARM: dts: am335x-sl50: Fix audio bitclock and frame master endpoint
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     wifi: ath9k: fix OOB access from firmware tx status queue ID
>=20
> Prasanna Kumar T S M <ptsm@linux.microsoft.com>
>     soc: xilinx: Shutdown and free rx mailbox channel
>=20
> Xingjing Deng <micro6947@gmail.com>
>     kconfig: fix potential NULL pointer dereference in conf_askvalue
>=20
> Tristan Madani <tristan@talencesecurity.com>
>     wifi: rtw88: fix OOB read from firmware RX descriptor exceeding DMA b=
uffer
>=20
> Shin-Yi Lin <isaiah@realtek.com>
>     wifi: rtw89: Correct data type for scan index to avoid infinite loop
>=20
> Danilo Krummrich <dakr@kernel.org>
>     driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()
>=20
> Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
>     drm/amdkfd: Validate CRIU-restored IDs before idr_alloc
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     dt-bindings: pinctrl: nvidia,tegra234: Add missing required block
>=20
> Jon Hunter <jonathanh@nvidia.com>
>     arm64: tegra: Fix Tegra234 MGBE PTP clock
>=20
> Louis Kotze <loukot@gmail.com>
>     wifi: cfg80211: fix grammar in MLO group key error message
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     arm64: dts: qcom: sdm845-mezzanine: Fix camss ports unit_address_vs_r=
eg warning
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>     arm64: dts: qcom: sc8180x: Fix phy simple_bus_reg warning
>=20
> Diederik de Haas <diederik@cknow-tech.com>
>     arm64: dts: rockchip: Fix gmac0 reset pin for NanoPi R5S
>=20
> Baolin Liu <liubaolin@kylinos.cn>
>     Documentation: proc: fix section numbering in table of contents
>=20
> Gregory Bell <grbell@redhat.com>
>     selftests/bpf: Use local type for bpf_fou_encap in test_tunnel_kern
>=20
> Gregory Bell <grbell@redhat.com>
>     selftests/bpf: Use local type for flow_offload_tuple_rhash in xdp_flo=
wtable
>=20
> Yang Wang <kevinyang.wang@amd.com>
>     drm/amd/pm: remove trailing semicolon from AMDGPU_PM_POLICY_ATTR macro
>=20
> Aaron Tomlin <atomlin@atomlin.com>
>     libbpf: Report error when a negative kprobe offset is specified
>=20
> Yuho Choi <dbgh9129@gmail.com>
>     drm/radeon: fix memory leak in radeon_ring_restore() on lock failure
>=20
> Werner Kasselman <werner@verivus.ai>
>     drm/radeon: fix integer overflow in radeon_align_pitch()
>=20
> Werner Kasselman <werner@verivus.ai>
>     drm/amdgpu: fix integer overflow in amdgpu_gem_align_pitch()
>=20
> Jonathan Cavitt <jonathan.cavitt@intel.com>
>     drm/gpuvm: Do not prepare NULL objects
>=20
> Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
>     drm/tidss: Drop extra drm_mode_config_reset() call
>=20
> Thomas Zimmermann <tzimmermann@suse.de>
>     drm/rockchip: Test for imported buffers with drm_gem_is_imported()
>=20
> Chen Ni <nichen@iscas.ac.cn>
>     clocksource/drivers/sun5i: Handle error returns from devm_reset_contr=
ol_get_optional_exclusive()
>=20
> Ian Bridges <icb@fastmail.org>
>     fbcon: fix NULL pointer dereference for a console without vc_data
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix further netns teardown to cancel the preallocation charger
>=20
> Matvey Kovalev <matvey.kovalev@ispras.ru>
>     afs: fix NULL pointer dereference in afs_get_tree()
>=20
> David Howells <dhowells@redhat.com>
>     afs: Fix netns teardown to cancel the preallocation charger
>=20
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix leak of released call in recvmsg(MSG_PEEK)
>=20
> Jeffrey Altman <jaltman@auristor.com>
>     rxrpc: rxrpc_verify_data ensure rx_dec_buffer alloc
>=20
> Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>
>     serial: 8250_omap: clear rx_running on zero-length DMA completes
>=20
> Tapio Reijonen <tapio.reijonen@vaisala.com>
>     serial: max310x: implement gpio_chip::get_direction()
>=20
> Stephan Gerhold <stephan.gerhold@linaro.org>
>     serial: msm: Disable DMA for kernel console UART
>=20
> Guoniu Zhou <guoniu.zhou@oss.nxp.com>
>     dt-bindings: power: imx93: Add MIPI PHY power domain
>=20
> Chen-Yu Tsai <wens@kernel.org>
>     dt-bindings: media: sun4i-a10-video-engine: Add interconnect properti=
es
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Fix sequence number when no EOF
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Relax the constrains for interpolating the hw clock
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Do not add clock samples with small sof delta
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Fix dev_sof filtering in hw timestamp
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Fix buffer sequence in frame gaps
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Avoid partial metadata buffers
>=20
> Ricardo Ribalda <ribalda@chromium.org>
>     media: uvcvideo: Use hw timestaming if the clock buffer is full
>=20
> Su Hui <suhui@nfschina.com>
>     time/jiffies: Change register_refined_jiffies() to void __init
>=20
> Thomas Gleixner <tglx@kernel.org>
>     time/jiffies: Register jiffies clocksource before usage
>=20
> Eric Biggers <ebiggers@kernel.org>
>     crypto: hisi-trng - Remove crypto_rng interface
>=20
> Eric Biggers <ebiggers@kernel.org>
>     crypto: crypto4xx - Remove insecure and unused rng_alg
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: crypto4xx - Remove ahash-related code
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     af_unix: Drop all SCM attributes for SOCKMAP.
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     af_unix: Don't use skb_recv_datagram() in unix_stream_read_skb().
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     af_unix: Don't check SOCK_DEAD in unix_stream_read_skb().
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     af_unix: Don't hold unix_state_lock() in __unix_dgram_recvmsg().
>=20
> Alexander Mikhalitsyn <alexander@mihalicyn.com>
>     af_unix/scm: fix whitespace errors
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     af_unix: Set drop reason in unix_stream_read_skb().
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     af_unix: Set drop reason in manage_oob().
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     af_unix: Set drop reason in unix_release_sock().
>=20
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     net: dropreason: Gather SOCKET_ drop reasons.
>=20
> Stephen Dolan <sdolan@janestreet.com>
>     x86/mm: Fix check/use ordering in switch_mm_irqs_off()
>=20
> Vasant Hegde <vasant.hegde@amd.com>
>     iommu/amd: Use maximum PPR log buffer size when SNP is enabled on Fam=
ily 0x19
>=20
> Vasant Hegde <vasant.hegde@amd.com>
>     iommu/amd: Use maximum Event log buffer size when SNP is enabled on F=
amily 0x19
>=20
> Eric Biggers <ebiggers@kernel.org>
>     crypto: sun4i-ss - Remove insecure and unused rng_alg
>=20
> Jingguo Tan <tanjingguo@huawei.com>
>     vsock/virtio: bind uarg before filling zerocopy skb
>=20
> Stefano Garzarella <sgarzare@redhat.com>
>     vsock/virtio: fix zerocopy completion for multi-skb sends
>=20
> Sagi Grimberg <sagi@grimberg.me>
>     nvmet-tcp: Fix potential UAF when ddgst mismatch
>=20
> Shivam Kumar <kumar.shivam43666@gmail.com>
>     nvmet-tcp: check INIT_FAILED before nvmet_req_uninit in digest error =
path
>=20
> Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>     timekeeping: Register default clocksource before taking tk_core.lock
>=20
> Michael Bommarito <michael.bommarito@gmail.com>
>     iommu/vt-d: Clear Present bit before tearing down scalable-mode conte=
xt entry
>=20
> Lu Baolu <baolu.lu@linux.intel.com>
>     iommu/vt-d: Cleanup intel_context_flush_present()
>=20
> Yi Liu <yi.l.liu@intel.com>
>     iommu: Pass old domain to set_dev_pasid op
>=20
> Hyunwoo Kim <imv4bel@gmail.com>
>     KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
>=20
> Hyunwoo Kim <imv4bel@gmail.com>
>     KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU
>=20
> Muhammet Kaan KILIN=C3=87 <muhammetkaankilinc@gmail.com>
>     crypto: algif_skcipher - force synchronous processing
>=20
> Adam Li <adamli@os.amperecomputing.com>
>     sched/fair: Only update stats for allowed CPUs when looking for dst g=
roup
>=20
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     bpf: Prefer dirty packs for eBPF allocations
>=20
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     bpf: Prefer packs that won't trigger an IBPB flush on allocation
>=20
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     bpf: Skip redundant IBPB in pack allocator
>=20
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     bpf: Restrict JIT predictor flush to cBPF
>=20
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     x86/bugs: Enable IBPB flush on BPF JIT allocation
>=20
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     bpf: Support for hardening against JIT spraying
>=20
> Kuniyuki Iwashima <kuniyu@google.com>
>     tcp: Add preempt_{disable,enable}_nested() in reqsk_queue_hash_req().
>=20
> Lu Baolu <baolu.lu@linux.intel.com>
>     iommu/vt-d: Clear Present bit before tearing down context entry
>=20
> ChenXiaoSong <chenxiaosong@kylinos.cn>
>     smb/server: do not require delete access for non-replacing links
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/admin-guide/pm/cpufreq.rst           |   6 +-
>  Documentation/core-api/workqueue.rst               |   6 +
>  .../media/allwinner,sun4i-a10-video-engine.yaml    |  10 +
>  .../devicetree/bindings/net/microchip,lan8650.yaml |   2 +-
>  .../devicetree/bindings/net/renesas,ether.yaml     |   3 +-
>  .../pinctrl/nvidia,tegra234-pinmux-aon.yaml        |   4 +
>  .../bindings/pinctrl/nvidia,tegra234-pinmux.yaml   |   4 +
>  .../bindings/regulator/mt6359-regulator.yaml       |  43 --
>  Documentation/driver-api/dpll.rst                  |  25 +
>  Documentation/driver-api/nvdimm/btt.rst            |   5 +-
>  Documentation/driver-api/pci/pci.rst               |   3 +
>  Documentation/filesystems/proc.rst                 |  14 +-
>  Documentation/netlink/specs/dpll.yaml              |  19 +
>  Documentation/netlink/specs/handshake.yaml         |   1 +
>  Documentation/process/deprecated.rst               |  31 ++
>  Makefile                                           |   4 +-
>  arch/alpha/kernel/pci-sysfs.c                      |  13 +-
>  arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts      | 128 +++++
>  arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts      | 144 +++++
>  arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi     | 146 +----
>  arch/arm/boot/dts/ti/omap/am335x-sl50.dts          |   4 +-
>  arch/arm/configs/multi_v7_defconfig                |   4 +-
>  arch/arm/configs/sunxi_defconfig                   |   1 -
>  arch/arm/mach-imx/cpu-imx31.c                      |   9 +-
>  arch/arm/mach-imx/mm-imx3.c                        |   2 +
>  .../dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts    |   3 +
>  arch/arm64/boot/dts/freescale/imx8ulp-evk.dts      |   4 +-
>  arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi   |   4 +-
>  arch/arm64/boot/dts/freescale/imx95.dtsi           |  10 +-
>  arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   2 +-
>  arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   8 +-
>  arch/arm64/boot/dts/qcom/sc7180.dtsi               |   6 +-
>  arch/arm64/boot/dts/qcom/sc7280.dtsi               |   8 +-
>  arch/arm64/boot/dts/qcom/sc8180x.dtsi              |   2 +-
>  arch/arm64/boot/dts/qcom/sdm630.dtsi               |   9 +-
>  .../qcom/sdm845-db845c-navigation-mezzanine.dtso   |   5 +
>  arch/arm64/boot/dts/qcom/sm8450.dtsi               |   8 +-
>  arch/arm64/boot/dts/qcom/sm8650.dtsi               |   6 +-
>  arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts     |   2 +-
>  arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts |   6 +-
>  arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   2 +
>  arch/arm64/include/asm/kvm_hyp.h                   |   1 +
>  arch/arm64/kernel/entry-fpsimd.S                   |   8 +-
>  arch/arm64/kernel/hw_breakpoint.c                  |   9 +
>  arch/arm64/kernel/smp.c                            |  16 +-
>  arch/arm64/kvm/arm.c                               |   2 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  11 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  12 +
>  arch/arm64/kvm/hyp/pgtable.c                       |   3 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |   2 +
>  arch/arm64/kvm/vgic/vgic.c                         |  11 +-
>  arch/arm64/mm/mmu.c                                |  11 +-
>  arch/arm64/net/bpf_jit_comp.c                      |  25 +-
>  arch/loongarch/include/asm/pgtable.h               |   4 +
>  arch/loongarch/kvm/exit.c                          |   1 -
>  arch/loongarch/kvm/vcpu.c                          |  11 +-
>  arch/mips/dec/int-handler.S                        |   2 +-
>  arch/mips/dec/platform.c                           |   6 +-
>  arch/mips/dec/prom/init.c                          |   6 +-
>  arch/mips/dec/setup.c                              |   6 -
>  arch/mips/fw/lib/call_o32.S                        |   2 +-
>  arch/mips/include/asm/dec/prom.h                   |  15 +-
>  arch/mips/kernel/mips-mt-fpaff.c                   |  28 +-
>  arch/mips/mm/init.c                                |  12 +-
>  arch/mips/n64/init.c                               |   2 +-
>  arch/mips/ralink/mt7621.c                          |   2 +-
>  arch/mips/sgi-ip22/ip22-gio.c                      |   7 +-
>  arch/powerpc/kexec/core_64.c                       |   4 +-
>  arch/powerpc/net/bpf_jit_comp.c                    |   2 +-
>  arch/powerpc/net/bpf_jit_comp64.c                  |  21 +-
>  arch/powerpc/perf/core-fsl-emb.c                   |   3 +-
>  arch/powerpc/platforms/cell/spufs/file.c           |   6 +-
>  arch/powerpc/platforms/powernv/setup.c             |   3 +-
>  .../platforms/pseries/papr_platform_attributes.c   |   8 +-
>  arch/riscv/include/asm/cpu_ops.h                   |   2 +-
>  arch/riscv/kernel/cacheinfo.c                      |   2 +-
>  arch/riscv/kernel/cpu-hotplug.c                    |   4 +-
>  arch/riscv/kernel/cpu_ops_sbi.c                    |  11 +-
>  arch/riscv/kernel/machine_kexec.c                  |   3 +
>  arch/riscv/kernel/probes/rethook_trampoline.S      |   3 +
>  arch/riscv/kernel/stacktrace.c                     |   2 +-
>  arch/riscv/net/bpf_jit_comp64.c                    |   2 +-
>  arch/riscv/net/bpf_jit_core.c                      |   3 +-
>  arch/s390/Kconfig                                  |   1 -
>  arch/s390/include/asm/asm-extable.h                |   4 -
>  arch/s390/include/asm/word-at-a-time.h             |  22 -
>  arch/s390/kernel/perf_cpum_cf.c                    |   3 +
>  arch/s390/kernel/process.c                         |   2 +-
>  arch/s390/kvm/pci.c                                |  12 +-
>  arch/s390/mm/extable.c                             |  18 -
>  arch/s390/mm/mmap.c                                |   2 +-
>  arch/sparc/kernel/led.c                            |   2 +-
>  arch/x86/boot/compressed/acpi.c                    |   7 +-
>  arch/x86/boot/early_serial_console.c               |  11 +-
>  arch/x86/events/amd/brs.c                          |  10 +-
>  arch/x86/events/amd/core.c                         |  18 +-
>  arch/x86/events/amd/lbr.c                          |   3 +-
>  arch/x86/events/amd/uncore.c                       |   6 +-
>  arch/x86/events/intel/uncore_discovery.c           |   4 +-
>  arch/x86/events/intel/uncore_snb.c                 |   7 -
>  arch/x86/include/asm/nospec-branch.h               |   4 +
>  arch/x86/kernel/cpu/bugs.c                         |  50 +-
>  arch/x86/kvm/lapic.c                               |   8 +-
>  arch/x86/kvm/svm/sev.c                             |   6 +-
>  arch/x86/mm/tlb.c                                  |  16 +-
>  arch/x86/net/bpf_jit_comp.c                        |   5 +-
>  arch/x86/platform/olpc/olpc-xo15-sci.c             |   1 +
>  block/blk.h                                        |  13 +-
>  crypto/algif_skcipher.c                            |  75 +--
>  crypto/asymmetric_keys/verify_pefile.c             |   2 +
>  crypto/ecrdsa.c                                    |   2 +-
>  crypto/rng.c                                       |  11 +
>  drivers/accel/ivpu/ivpu_fw_log.c                   |   4 +
>  drivers/acpi/ac.c                                  |   6 +-
>  drivers/acpi/acpi_ipmi.c                           |   4 +-
>  drivers/acpi/acpi_pad.c                            |   6 +-
>  drivers/acpi/acpi_tad.c                            |   6 +-
>  drivers/acpi/bus.c                                 |  70 +++
>  drivers/acpi/nfit/core.c                           |  89 ++-
>  drivers/acpi/pfr_telemetry.c                       |   6 +-
>  drivers/acpi/pfr_update.c                          |   6 +-
>  drivers/acpi/processor_idle.c                      |   4 +-
>  drivers/acpi/resource.c                            |   6 +-
>  drivers/acpi/riscv/cpuidle.c                       |   2 +-
>  drivers/acpi/thermal.c                             |   2 +-
>  drivers/amba/bus.c                                 |  37 +-
>  drivers/ata/libata-core.c                          |  21 +-
>  drivers/ata/libata-scsi.c                          |   7 +-
>  drivers/ata/pata_pxa.c                             |   1 +
>  drivers/ata/sata_gemini.c                          |   2 +-
>  drivers/base/dd.c                                  |   7 +-
>  drivers/base/firmware_loader/main.c                |   3 +-
>  drivers/base/power/main.c                          |   6 +-
>  drivers/base/property.c                            |   4 +-
>  drivers/block/drbd/drbd_receiver.c                 |   5 +
>  drivers/bluetooth/bpa10x.c                         |   8 +-
>  drivers/bluetooth/btmtk.c                          |   4 +-
>  drivers/bluetooth/btrtl.c                          |   5 +-
>  drivers/bluetooth/hci_qca.c                        |   2 +-
>  drivers/bluetooth/hci_vhci.c                       |  10 +
>  drivers/bus/imx-weim.c                             |   6 -
>  drivers/bus/mhi/ep/main.c                          |   9 +-
>  drivers/bus/sunxi-rsb.c                            |   3 +
>  drivers/cdx/cdx.c                                  |  40 +-
>  drivers/char/tlclk.c                               |   4 +
>  drivers/char/tpm/eventlog/tpm1.c                   |   4 +-
>  drivers/char/tpm/tpm-dev.c                         |   2 +-
>  drivers/char/tpm/tpm2-sessions.c                   |  45 +-
>  drivers/char/tpm/tpm_tis_core.c                    |  35 +-
>  drivers/char/tpm/tpmrm-dev.c                       |   2 +-
>  drivers/char/virtio_console.c                      |  52 +-
>  drivers/clk/at91/pmc.c                             |   2 +-
>  drivers/clk/at91/sam9x7.c                          |  18 +-
>  drivers/clk/clk-scmi.c                             |   4 +-
>  drivers/clk/clk-scpi.c                             |   2 +-
>  drivers/clk/qcom/a53-pll.c                         |   2 +-
>  drivers/clocksource/timer-sun5i.c                  |   3 +
>  drivers/cpufreq/cpufreq_conservative.c             |  12 +-
>  drivers/cpufreq/intel_pstate.c                     |   6 +-
>  drivers/crypto/allwinner/Kconfig                   |   8 -
>  drivers/crypto/allwinner/sun4i-ss/Makefile         |   1 -
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c  |  36 --
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c  |  69 ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h       |  20 -
>  drivers/crypto/amcc/crypto4xx_alg.c                | 106 ----
>  drivers/crypto/amcc/crypto4xx_core.c               | 130 +----
>  drivers/crypto/amcc/crypto4xx_core.h               |  11 -
>  drivers/crypto/amcc/crypto4xx_reg_def.h            |  11 -
>  drivers/crypto/atmel-ecc.c                         |   2 +-
>  drivers/crypto/atmel-sha204a.c                     |  37 +-
>  drivers/crypto/cavium/cpt/cptvf_reqmanager.c       |   4 +-
>  drivers/crypto/ccp/sev-dev.c                       | 183 +++----
>  drivers/crypto/hisilicon/Kconfig                   |   1 -
>  drivers/crypto/hisilicon/qm.c                      |   4 +-
>  drivers/crypto/hisilicon/trng/trng.c               | 296 +---------
>  .../intel/qat/qat_common/adf_accel_devices.h       |   2 +
>  drivers/crypto/intel/qat/qat_common/adf_aer.c      |   7 +-
>  .../crypto/intel/qat/qat_common/adf_common_drv.h   |   3 +-
>  .../intel/qat/qat_common/adf_heartbeat_inject.c    |   6 +-
>  .../crypto/intel/qat/qat_common/adf_hw_arbiter.c   |  25 -
>  drivers/crypto/intel/qat/qat_common/adf_isr.c      |  39 ++
>  drivers/crypto/intel/qat/qat_common/adf_sriov.c    |  20 +-
>  drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c |   4 +-
>  drivers/crypto/tegra/tegra-se-aes.c                |  33 +-
>  drivers/dax/kmem.c                                 |   6 +
>  drivers/dma/dma-axi-dmac.c                         |  68 ++-
>  drivers/dma/dmaengine.c                            |   3 +-
>  drivers/dma/dw-edma/dw-edma-core.h                 |   2 +-
>  drivers/dma/dw-edma/dw-edma-v0-core.c              |   6 +
>  drivers/dma/imx-sdma.c                             |   4 +-
>  drivers/dma/qcom/gpi.c                             |   1 +
>  drivers/dma/tegra186-gpc-dma.c                     |   7 +
>  drivers/dpll/dpll_core.c                           | 283 +++++++++-
>  drivers/dpll/dpll_core.h                           |   8 +
>  drivers/dpll/dpll_netlink.c                        | 199 ++++++-
>  drivers/dpll/dpll_netlink.h                        |   2 +
>  drivers/dpll/dpll_nl.c                             |  10 +-
>  drivers/dpll/dpll_nl.h                             |   1 +
>  drivers/edac/skx_common.c                          |   3 +
>  drivers/firmware/arm_scmi/power.c                  |   6 +-
>  drivers/firmware/arm_scmi/sensors.c                |   2 +-
>  drivers/fpga/dfl.c                                 |   2 +
>  drivers/fpga/microchip-spi.c                       |   3 +
>  drivers/gpio/gpio-davinci.c                        |   4 +-
>  drivers/gpio/gpio-f7188x.c                         |   6 +-
>  drivers/gpio/gpio-htc-egpio.c                      |   6 +-
>  drivers/gpio/gpio-mlxbf3.c                         |   3 +-
>  drivers/gpio/gpio-mvebu.c                          |   6 +-
>  drivers/gpio/gpio-palmas.c                         |  19 +
>  drivers/gpio/gpio-sch.c                            |  32 +-
>  drivers/gpio/gpio-tegra.c                          |  18 +-
>  drivers/gpio/gpio-timberdale.c                     |   2 +-
>  drivers/gpio/gpiolib-acpi-core.c                   |  19 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  16 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  25 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   2 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_mca.c            |   3 +
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   3 +
>  .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  20 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   5 +
>  drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   1 +
>  .../amd/display/modules/info_packet/info_packet.c  |   2 +
>  drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   6 +-
>  drivers/gpu/drm/drm_edid.c                         |   8 +
>  drivers/gpu/drm/drm_gpuvm.c                        |   9 +-
>  drivers/gpu/drm/drm_syncobj.c                      |  10 +-
>  drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |  78 +--
>  drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |  11 +
>  drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c   |  22 -
>  drivers/gpu/drm/i915/display/intel_atomic.c        |   6 +
>  drivers/gpu/drm/i915/gt/intel_region_lmem.c        |   2 +-
>  drivers/gpu/drm/msm/dp/dp_display.c                |   4 +-
>  drivers/gpu/drm/msm/dp/dp_reg.h                    |   4 +-
>  .../gpu/drm/nouveau/nvkm/subdev/bios/shadowramin.c |   3 +-
>  drivers/gpu/drm/panthor/panthor_sched.c            |  25 +-
>  drivers/gpu/drm/radeon/radeon_gem.c                |  13 +-
>  drivers/gpu/drm/radeon/radeon_ring.c               |   4 +-
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |   2 +-
>  drivers/gpu/drm/tegra/dc.c                         |   4 +-
>  drivers/gpu/drm/tegra/gem.c                        |  22 +-
>  drivers/gpu/drm/tegra/gr2d.c                       |  19 +-
>  drivers/gpu/drm/tegra/gr3d.c                       |  19 +-
>  drivers/gpu/drm/tegra/submit.c                     |   3 +-
>  drivers/gpu/drm/tidss/tidss_kms.c                  |   2 -
>  drivers/gpu/drm/v3d/v3d_submit.c                   |   2 +
>  drivers/gpu/drm/xe/tests/xe_pci.c                  |   1 -
>  drivers/gpu/drm/xe/xe_guc_relay.c                  |  13 +-
>  drivers/gpu/drm/xe/xe_hw_engine.c                  |   4 +-
>  drivers/gpu/drm/xe/xe_pt.c                         |  12 +-
>  drivers/gpu/drm/xe/xe_vram.c                       |   2 +-
>  drivers/gpu/host1x/bus.c                           |  62 ++-
>  drivers/gpu/host1x/job.c                           |  10 +-
>  drivers/hid/bpf/hid_bpf_dispatch.c                 |   5 +-
>  drivers/hid/hid-appleir.c                          |  45 +-
>  drivers/hid/hid-core.c                             |   7 +
>  drivers/hid/hid-logitech-hidpp.c                   |   1 -
>  drivers/hid/hid-multitouch.c                       |  32 +-
>  drivers/hid/hid-picolcd_core.c                     |   3 +-
>  drivers/hid/hid-playstation.c                      |  12 +
>  drivers/hid/hid-wiimote-modules.c                  |  58 +-
>  drivers/hid/usbhid/hid-pidff.c                     | 258 +++++----
>  drivers/hv/vmbus_drv.c                             |  43 +-
>  drivers/hwmon/Kconfig                              |   3 +
>  drivers/hwmon/aspeed-g6-pwm-tach.c                 |   5 +-
>  drivers/hwmon/asus_atk0110.c                       |   3 +
>  drivers/hwmon/it87.c                               |   3 +
>  drivers/hwmon/occ/common.c                         |  34 +-
>  drivers/hwmon/occ/common.h                         |   1 +
>  drivers/hwmon/pmbus/adm1275.c                      |   2 +-
>  drivers/hwmon/pmbus/pmbus_core.c                   |  13 +-
>  drivers/hwmon/w83627hf.c                           |   4 +
>  drivers/hwmon/w83793.c                             |   1 +
>  drivers/hwspinlock/qcom_hwspinlock.c               |   5 +-
>  .../hwtracing/coresight/coresight-cti-platform.c   |   1 +
>  drivers/hwtracing/coresight/coresight-etm4x-core.c |   4 +-
>  drivers/hwtracing/coresight/coresight-sysfs.c      |   4 +-
>  drivers/i2c/busses/i2c-mlxbf.c                     |   4 +-
>  drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
>  drivers/i2c/i2c-core-of.c                          |   5 -
>  drivers/i3c/master.c                               |  21 +-
>  drivers/iio/accel/mma8452.c                        |   2 +
>  drivers/iio/adc/Kconfig                            |   1 +
>  drivers/iio/adc/xilinx-ams.c                       |   5 +
>  drivers/iio/light/si1133.c                         |  14 +-
>  drivers/iio/light/tcs3472.c                        |  38 +-
>  drivers/iio/magnetometer/ak8975.c                  |  14 +
>  drivers/iio/orientation/hid-sensor-rotation.c      |  40 +-
>  drivers/iio/pressure/bmp280-core.c                 |   5 -
>  drivers/iio/pressure/icp10100.c                    |   1 -
>  drivers/iio/pressure/mpl115.c                      |   6 +-
>  drivers/iio/pressure/zpa2326.c                     |   2 -
>  drivers/infiniband/core/cm.c                       |  13 +-
>  drivers/infiniband/core/counters.c                 |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_cq.c            |   6 +-
>  drivers/infiniband/hw/hns/hns_roce_debugfs.c       |  19 +-
>  drivers/infiniband/hw/hns/hns_roce_hem.c           |   8 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  18 +-
>  drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_mr.c            |   6 +-
>  drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
>  drivers/infiniband/hw/irdma/verbs.c                |  19 +-
>  drivers/infiniband/hw/irdma/verbs.h                |   1 -
>  drivers/infiniband/hw/mana/main.c                  |   3 +-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h               |   1 +
>  drivers/infiniband/hw/mlx4/mr.c                    |   9 +-
>  drivers/infiniband/hw/mlx4/sysfs.c                 |  45 +-
>  drivers/infiniband/hw/mlx5/devx.c                  |  30 +-
>  drivers/infiniband/hw/mlx5/main.c                  |  17 +-
>  drivers/infiniband/hw/mlx5/mr.c                    |  17 +-
>  drivers/infiniband/hw/mlx5/qp.c                    |  13 +-
>  drivers/infiniband/hw/mlx5/restrack.c              |   3 -
>  drivers/infiniband/sw/rxe/rxe_mmap.c               |  19 +-
>  drivers/infiniband/sw/rxe/rxe_resp.c               |  33 +-
>  drivers/infiniband/sw/siw/siw_cm.c                 |  30 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c              |   5 +-
>  drivers/input/misc/ims-pcu.c                       | 129 ++++-
>  drivers/iommu/amd/amd_iommu.h                      |   6 +-
>  drivers/iommu/amd/amd_iommu_types.h                |  32 +-
>  drivers/iommu/amd/init.c                           |  90 ++-
>  drivers/iommu/amd/iommu.c                          |   2 +-
>  drivers/iommu/amd/pasid.c                          |   3 +-
>  drivers/iommu/amd/ppr.c                            |  10 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   3 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   3 +-
>  drivers/iommu/intel/iommu.c                        |  14 +-
>  drivers/iommu/intel/iommu.h                        |  26 +-
>  drivers/iommu/intel/pasid.c                        |  50 +-
>  drivers/iommu/intel/svm.c                          |   3 +-
>  drivers/iommu/iommu.c                              |   3 +-
>  drivers/irqchip/irq-crossbar.c                     |  10 +-
>  drivers/irqchip/irq-gic-v3-its.c                   |   6 +-
>  drivers/irqchip/irq-riscv-imsic-early.c            |  15 +-
>  drivers/irqchip/irq-ts4800.c                       |  10 +
>  drivers/leds/uleds.c                               |   3 +-
>  drivers/mailbox/imx-mailbox.c                      |   3 +-
>  drivers/mailbox/mtk-adsp-mailbox.c                 |   9 +-
>  drivers/md/dm-bufio.c                              |   4 +-
>  drivers/md/dm-era-target.c                         |  10 +-
>  drivers/md/dm-integrity.c                          |  10 +-
>  drivers/md/dm-ioctl.c                              |   4 +-
>  drivers/md/dm-log.c                                |   3 +
>  drivers/md/dm-stats.c                              |  10 +-
>  drivers/md/dm-thin-metadata.c                      |  67 +--
>  drivers/md/dm-verity-loadpin.c                     |   2 +-
>  drivers/md/dm-verity-target.c                      |  16 +-
>  drivers/md/dm-verity.h                             |   2 +-
>  drivers/md/raid1.c                                 |   6 +
>  drivers/md/raid10.c                                |   1 +
>  drivers/md/raid5.c                                 |  55 +-
>  .../media/platform/nxp/imx8-isi/imx8-isi-core.c    |  18 +-
>  drivers/media/platform/qcom/camss/camss-vfe.c      |   2 +-
>  drivers/media/platform/qcom/venus/helpers.c        |   4 +-
>  .../media/platform/qcom/venus/hfi_platform_v4.c    |  20 +-
>  .../media/platform/qcom/venus/hfi_platform_v6.c    |  16 +-
>  drivers/media/platform/rockchip/rga/rga-hw.c       |   2 +-
>  drivers/media/platform/rockchip/rga/rga-hw.h       |   2 +-
>  drivers/media/usb/uvc/uvc_video.c                  | 179 +++---
>  drivers/media/v4l2-core/v4l2-common.c              |   1 +
>  drivers/memory/tegra/mc.c                          |  14 +
>  drivers/memstick/core/ms_block.c                   |   4 +
>  drivers/mfd/cs42l43.c                              |   2 +-
>  drivers/mfd/rsmu_i2c.c                             |   6 +-
>  drivers/mfd/rsmu_spi.c                             |   5 +-
>  drivers/mfd/sm501.c                                |   4 +-
>  drivers/mfd/tps6586x.c                             |   2 +-
>  drivers/mmc/core/block.c                           |   3 +-
>  drivers/mmc/host/sdhci-of-dwcmshc.c                |  14 +-
>  drivers/mmc/host/vub300.c                          |  26 +-
>  drivers/mtd/devices/mchp23k256.c                   |   2 +-
>  drivers/mtd/devices/slram.c                        |  22 +-
>  drivers/mtd/maps/vmu-flash.c                       |   1 +
>  drivers/mtd/nand/onenand/onenand_samsung.c         |   7 +-
>  drivers/mtd/nand/raw/fsl_ifc_nand.c                |   9 +-
>  drivers/mtd/nand/raw/lpc32xx_mlc.c                 |  12 +-
>  drivers/mtd/nand/raw/lpc32xx_slc.c                 |  12 +-
>  drivers/mtd/nand/raw/nand_base.c                   |  24 +-
>  drivers/mtd/nand/raw/pl35x-nand-controller.c       |   2 +-
>  drivers/mtd/spi-nor/Kconfig                        |   1 -
>  drivers/mtd/spi-nor/spansion.c                     |   4 +-
>  drivers/mtd/spi-nor/swp.c                          |  11 +-
>  drivers/net/amt.c                                  |   6 +-
>  drivers/net/bonding/bond_3ad.c                     |   1 +
>  drivers/net/can/usb/esd_usb.c                      |   5 +-
>  drivers/net/dsa/qca/qca8k-leds.c                   |   3 +-
>  drivers/net/dsa/realtek/rtl8366rb-leds.c           |   8 +-
>  drivers/net/dsa/sja1105/sja1105_ptp.c              |   2 +-
>  drivers/net/ethernet/amazon/ena/ena_netdev.c       |  23 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   3 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  83 ++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  19 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 134 +++--
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  23 +-
>  .../ethernet/cavium/liquidio/cn23xx_pf_device.c    |  18 +-
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   8 -
>  drivers/net/ethernet/emulex/benet/be_main.c        |   3 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  10 +-
>  drivers/net/ethernet/freescale/enetc/enetc.c       |   7 +
>  drivers/net/ethernet/freescale/fman/fman.c         |   4 +-
>  drivers/net/ethernet/freescale/gianfar.c           |  16 +-
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +-
>  .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c    |   2 +-
>  .../hns3/hns3_common/hclge_comm_tqp_stats.c        |  11 +-
>  .../hns3/hns3_common/hclge_comm_tqp_stats.h        |   2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  34 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  36 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 152 +++--
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  76 ++-
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 196 ++++---
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +-
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   2 +-
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   3 +-
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h |   2 +-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   8 +-
>  .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   2 +-
>  drivers/net/ethernet/intel/i40e/i40e_debug.h       |   2 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 -
>  drivers/net/ethernet/intel/ice/ice_common.c        |   1 -
>  drivers/net/ethernet/intel/ice/ice_dpll.c          |  20 +-
>  drivers/net/ethernet/intel/ice/ice_eswitch.c       |   4 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c       |  12 +-
>  drivers/net/ethernet/intel/ice/ice_main.c          |  20 +-
>  drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   2 +-
>  drivers/net/ethernet/marvell/mvneta.c              |   3 +
>  drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |   6 +-
>  .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   3 +-
>  .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  27 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  15 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  40 +-
>  .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |  10 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  44 +-
>  .../net/ethernet/marvell/prestera/prestera_main.c  |   2 +-
>  drivers/net/ethernet/mediatek/airoha_eth.c         | 231 +++++++-
>  drivers/net/ethernet/mediatek/mtk_ppe.c            |   4 +-
>  drivers/net/ethernet/mediatek/mtk_wed_debugfs.c    |   6 +-
>  drivers/net/ethernet/mediatek/mtk_wed_mcu.c        |   8 +-
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   3 +-
>  .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |  29 +-
>  .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  47 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
>  .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   7 +-
>  .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  |   8 +-
>  .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  |   6 +-
>  .../net/ethernet/mellanox/mlx5/core/lib/port_tun.c |   3 +-
>  drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   1 +
>  drivers/net/ethernet/microchip/lan743x_main.c      |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   5 +-
>  .../ethernet/microchip/sparx5/sparx5_switchdev.c   |   4 +-
>  .../ethernet/microchip/sparx5/sparx5_vcap_impl.c   |   5 +-
>  drivers/net/ethernet/microchip/vcap/vcap_api.c     |  72 +--
>  drivers/net/ethernet/microchip/vcap/vcap_api.h     |   3 +-
>  .../net/ethernet/microchip/vcap/vcap_api_debugfs.c |   8 +-
>  .../microchip/vcap/vcap_api_debugfs_kunit.c        |   3 +-
>  .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |   3 +-
>  .../net/ethernet/microchip/vcap/vcap_api_private.h |   3 +
>  drivers/net/ethernet/microsoft/mana/gdma_main.c    |   2 +
>  drivers/net/ethernet/microsoft/mana/mana_en.c      |   3 +-
>  .../net/ethernet/netronome/nfp/nfp_net_common.c    |   3 +-
>  drivers/net/ethernet/oa_tc6.c                      |  14 +-
>  .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  11 +-
>  drivers/net/ethernet/qlogic/qede/qede_filter.c     |   3 -
>  drivers/net/ethernet/qlogic/qede/qede_fp.c         |   9 +-
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   1 -
>  .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   5 +-
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |   1 +
>  .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |  78 +--
>  drivers/net/ethernet/sfc/ef10.c                    |   1 -
>  drivers/net/ethernet/sun/sungem.c                  |  13 +-
>  drivers/net/ethernet/sunplus/spl2sw_phy.c          |   6 +-
>  drivers/net/ieee802154/ca8210.c                    |   9 +-
>  drivers/net/macsec.c                               |   9 +-
>  drivers/net/netdevsim/udp_tunnels.c                |   4 -
>  drivers/net/pfcp.c                                 |   1 +
>  drivers/net/phy/sfp.c                              |   1 +
>  drivers/net/thunderbolt/main.c                     |   8 +-
>  drivers/net/usb/gl620a.c                           |   6 +-
>  drivers/net/usb/lan78xx.c                          | 318 +++++------
>  drivers/net/usb/net1080.c                          |   2 +-
>  drivers/net/veth.c                                 |   2 +
>  drivers/net/virtio_net.c                           |  12 +-
>  drivers/net/vxlan/vxlan_core.c                     |   8 +-
>  drivers/net/wan/ixp4xx_hss.c                       |   4 +-
>  drivers/net/wireless/ath/ath9k/xmit.c              |   5 +
>  drivers/net/wireless/ath/wcn36xx/smd.c             |  13 +
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +-
>  drivers/net/wireless/marvell/mwifiex/join.c        |   1 -
>  drivers/net/wireless/mediatek/mt76/mac80211.c      |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  10 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   5 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |  20 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |   4 +-
>  drivers/net/wireless/mediatek/mt76/mt792x_core.c   |   3 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   6 +-
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |  12 +-
>  drivers/net/wireless/realtek/rtw88/pci.c           |   5 +
>  drivers/net/wireless/realtek/rtw89/fw.c            |   2 +-
>  drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |  40 +-
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c             |   3 +
>  drivers/net/wwan/t7xx/t7xx_port_wwan.c             |   2 +
>  drivers/ntb/hw/epf/ntb_hw_epf.c                    |  81 ++-
>  drivers/nvdimm/btt.c                               |  14 +-
>  drivers/nvdimm/nd.h                                |  11 +-
>  drivers/nvdimm/region_devs.c                       |  66 +--
>  drivers/nvme/host/core.c                           |   2 +-
>  drivers/nvme/target/rdma.c                         |  18 +-
>  drivers/nvme/target/tcp.c                          |  11 +-
>  drivers/of/cpu.c                                   |   2 +-
>  drivers/of/dynamic.c                               |   1 -
>  drivers/of/platform.c                              |   5 -
>  drivers/pci/Makefile                               |   2 +-
>  drivers/pci/controller/Kconfig                     |   1 +
>  drivers/pci/controller/dwc/pci-meson.c             |  13 +-
>  drivers/pci/controller/dwc/pcie-designware-host.c  |   2 +-
>  drivers/pci/controller/dwc/pcie-qcom.c             |  43 +-
>  .../pci/controller/mobiveil/pcie-mobiveil-host.c   |   8 +-
>  drivers/pci/controller/pci-loongson.c              |  31 +-
>  drivers/pci/controller/pcie-altera-msi.c           |   2 +-
>  drivers/pci/controller/pcie-altera.c               |  31 +-
>  drivers/pci/controller/pcie-iproc-bcma.c           |   2 +-
>  drivers/pci/controller/pcie-iproc-platform.c       |   2 +-
>  drivers/pci/controller/pcie-iproc.c                |   1 -
>  drivers/pci/controller/pcie-iproc.h                |   2 -
>  drivers/pci/controller/pcie-mediatek-gen3.c        |   4 +-
>  drivers/pci/controller/pcie-mediatek.c             | 180 +++---
>  drivers/pci/controller/pcie-rcar-host.c            |   1 -
>  drivers/pci/controller/pcie-xilinx-dma-pl.c        |   2 +-
>  drivers/pci/controller/pcie-xilinx-nwl.c           |   2 +-
>  drivers/pci/controller/plda/pcie-plda-host.c       |   2 +-
>  drivers/pci/endpoint/functions/pci-epf-ntb.c       |  21 +-
>  drivers/pci/endpoint/functions/pci-epf-vntb.c      |   9 +-
>  drivers/pci/msi/msi.c                              |   4 +-
>  drivers/pci/pci-sysfs.c                            |  17 +-
>  drivers/pci/pci.c                                  | 137 -----
>  drivers/pci/pci.h                                  |   4 +
>  drivers/pci/rebar.c                                | 197 +++++++
>  drivers/pci/rom.c                                  | 149 ++++-
>  drivers/pci/setup-bus.c                            | 104 +++-
>  drivers/pci/setup-res.c                            |  53 --
>  drivers/phy/phy-can-transceiver.c                  |   3 +
>  drivers/pinctrl/cirrus/pinctrl-cs42l43.c           |   2 +-
>  drivers/pinctrl/mediatek/pinctrl-mt8167.c          |   2 +-
>  drivers/pinctrl/mediatek/pinctrl-mt8516.c          |   2 +-
>  drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
>  drivers/pinctrl/nuvoton/pinctrl-ma35.c             |   3 +-
>  drivers/pinctrl/nuvoton/pinctrl-ma35d1.c           | 470 +++++++++-------
>  drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   2 +-
>  drivers/platform/x86/amd/pmc/pmc-quirks.c          |  39 ++
>  drivers/platform/x86/amd/pmc/pmc.c                 |  83 ++-
>  drivers/platform/x86/amd/pmc/pmc.h                 |   2 +
>  drivers/platform/x86/dell/dell-laptop.c            |   5 +
>  drivers/platform/x86/xo15-ebook.c                  |   7 +-
>  drivers/pmdomain/imx/imx8m-blk-ctrl.c              |  46 +-
>  drivers/power/sequencing/core.c                    |   9 +-
>  drivers/power/supply/charger-manager.c             |   6 +-
>  drivers/power/supply/cpcap-battery.c               |  11 +-
>  drivers/power/supply/power_supply_core.c           |  11 +-
>  drivers/pwm/pwm-imx27.c                            |   8 +-
>  drivers/rapidio/devices/tsi721.c                   |   3 +-
>  drivers/regulator/core.c                           |   4 +-
>  drivers/regulator/ltc3676.c                        |  10 +-
>  drivers/remoteproc/qcom_common.c                   |  14 +-
>  drivers/reset/reset-imx7.c                         |   6 +
>  drivers/reset/reset-sunxi.c                        |   4 +-
>  drivers/rpmsg/qcom_glink_native.c                  |   2 -
>  drivers/rpmsg/rpmsg_core.c                         |  43 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c                   |   1 -
>  drivers/rtc/rtc-abx80x.c                           |   3 +-
>  drivers/rtc/rtc-cmos.c                             |   6 +
>  drivers/rtc/rtc-ds1307.c                           |  30 +-
>  drivers/rtc/rtc-mpfs.c                             |   2 +-
>  drivers/rtc/rtc-msc313.c                           |   4 +-
>  drivers/s390/char/monwriter.c                      |   3 +
>  drivers/s390/crypto/pkey_api.c                     |   8 +-
>  drivers/s390/crypto/pkey_pckmo.c                   |   4 +
>  drivers/s390/crypto/zcrypt_cex2a.c                 |   0
>  drivers/s390/crypto/zcrypt_cex2a.h                 |   0
>  drivers/s390/crypto/zcrypt_cex2c.c                 |   0
>  drivers/s390/crypto/zcrypt_cex2c.h                 |   0
>  drivers/scsi/elx/efct/efct_hw.c                    |   2 +
>  drivers/scsi/elx/efct/efct_unsol.c                 |   1 +
>  drivers/scsi/hpsa.c                                |   4 +
>  drivers/scsi/lpfc/lpfc_init.c                      |   3 +-
>  drivers/scsi/pm8001/pm8001_ctl.c                   |   5 +-
>  drivers/scsi/scsi_scan.c                           |   2 +-
>  drivers/scsi/scsi_transport_sas.c                  | 101 ++--
>  drivers/scsi/sg.c                                  |   7 +-
>  drivers/scsi/smartpqi/smartpqi_init.c              |   2 +-
>  drivers/soc/fsl/qe/qe.c                            |   3 +
>  drivers/soc/ti/k3-ringacc.c                        |   4 +-
>  drivers/soc/xilinx/zynqmp_power.c                  |   4 +-
>  drivers/spi/spi-dw.h                               |   1 +
>  drivers/spi/spi-ep93xx.c                           |   1 +
>  drivers/spi/spi-hisi-kunpeng.c                     |   6 +-
>  drivers/spi/spi-meson-spifc.c                      |   1 +
>  drivers/spi/spi-rpc-if.c                           |   6 +-
>  drivers/spi/spi-sh-msiof.c                         |  10 +-
>  drivers/spi/spi-uniphier.c                         |   4 +-
>  drivers/spi/spi-xilinx.c                           |  11 +-
>  drivers/spi/spi.c                                  |   5 -
>  drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |  29 +-
>  drivers/staging/media/atomisp/pci/atomisp_cmd.c    |   6 +-
>  drivers/staging/media/atomisp/pci/sh_css.c         |   8 +-
>  drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
>  drivers/staging/most/video/video.c                 |   7 +-
>  drivers/staging/nvec/nvec.c                        |   4 +-
>  drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |  93 ++--
>  drivers/staging/rtl8723bs/core/rtw_security.c      |   2 +-
>  drivers/target/iscsi/iscsi_target_auth.c           |   6 +-
>  drivers/target/loopback/tcm_loop.c                 |  64 ---
>  drivers/target/target_core_fabric_lib.c            |  89 ++-
>  drivers/target/target_core_internal.h              |   3 +-
>  drivers/target/target_core_pr.c                    |  12 +-
>  drivers/thermal/intel/therm_throt.c                |   7 +-
>  drivers/thermal/testing/command.c                  |  48 +-
>  drivers/thermal/testing/thermal_testing.h          |   8 +
>  drivers/thermal/testing/zone.c                     |   7 +-
>  drivers/thermal/thermal_hwmon.c                    |   5 +-
>  drivers/thunderbolt/debugfs.c                      |   8 +-
>  drivers/tty/serial/8250/8250_omap.c                |   3 +-
>  drivers/tty/serial/max310x.c                       |  12 +
>  drivers/tty/serial/msm_serial.c                    |   3 +-
>  drivers/ufs/core/ufshcd.c                          |   2 +-
>  drivers/usb/atm/ueagle-atm.c                       |  36 +-
>  drivers/usb/gadget/function/f_fs.c                 |   6 +-
>  drivers/usb/host/max3421-hcd.c                     |   8 +
>  drivers/usb/misc/iowarrior.c                       |  74 +--
>  drivers/vdpa/octeon_ep/octep_vdpa_main.c           |   7 +-
>  drivers/vdpa/vdpa_user/vduse_dev.c                 |  72 ++-
>  drivers/vfio/pci/mlx5/cmd.h                        |  15 +-
>  drivers/vfio/pci/qat/main.c                        |  18 +-
>  drivers/vhost/net.c                                |  15 +-
>  drivers/vhost/vdpa.c                               |  29 +-
>  drivers/vhost/vhost.c                              |  11 +-
>  drivers/video/fbdev/aty/radeon_base.c              |   1 +
>  drivers/video/fbdev/broadsheetfb.c                 |   8 +-
>  drivers/video/fbdev/carminefb.c                    |   1 +
>  drivers/video/fbdev/core/fbcon.c                   |   7 +-
>  drivers/video/fbdev/efifb.c                        |   1 +
>  drivers/video/fbdev/hecubafb.c                     |   6 +-
>  drivers/video/fbdev/i740fb.c                       |   1 +
>  drivers/video/fbdev/metronomefb.c                  |   8 +-
>  drivers/video/fbdev/nvidia/nvidia.c                |   1 +
>  drivers/video/fbdev/s3fb.c                         |   1 +
>  drivers/video/fbdev/sm501fb.c                      |  16 +-
>  drivers/video/fbdev/sm712.h                        |   2 +-
>  drivers/video/fbdev/tdfxfb.c                       |   1 +
>  drivers/video/fbdev/tridentfb.c                    |   1 +
>  drivers/video/fbdev/uvesafb.c                      |   4 +-
>  drivers/video/fbdev/vesafb.c                       |   1 +
>  drivers/watchdog/sama5d4_wdt.c                     |  48 +-
>  drivers/watchdog/sp5100_tco.c                      |   3 +-
>  drivers/watchdog/sprd_wdt.c                        |   5 +-
>  drivers/watchdog/watchdog_core.c                   |   3 +
>  drivers/xen/gntdev.c                               |   8 +-
>  drivers/xen/xen-scsiback.c                         |  30 +-
>  fs/9p/vfs_addr.c                                   |   3 +-
>  fs/9p/vfs_inode.c                                  |   9 +
>  fs/afs/callback.c                                  |   7 +-
>  fs/afs/cell.c                                      |  43 +-
>  fs/afs/cmservice.c                                 |   2 -
>  fs/afs/dir.c                                       |   5 +-
>  fs/afs/dynroot.c                                   | 509 ++++++++-------=
--
>  fs/afs/file.c                                      |  15 +-
>  fs/afs/fs_operation.c                              |   2 +-
>  fs/afs/inode.c                                     |   1 -
>  fs/afs/internal.h                                  |  12 +-
>  fs/afs/main.c                                      |   3 +
>  fs/afs/proc.c                                      |  10 +-
>  fs/afs/rxrpc.c                                     |  11 +-
>  fs/afs/super.c                                     |  16 +-
>  fs/afs/vl_list.c                                   |  10 +-
>  fs/afs/volume.c                                    |   2 +-
>  fs/btrfs/btrfs_inode.h                             |   3 +-
>  fs/btrfs/compression.c                             |   2 +-
>  fs/btrfs/direct-io.c                               |  69 ++-
>  fs/btrfs/disk-io.c                                 |  16 +-
>  fs/btrfs/extent-tree.c                             |   5 +-
>  fs/btrfs/extent_io.c                               | 106 ++--
>  fs/btrfs/file.c                                    |  27 +-
>  fs/btrfs/fs.h                                      |   7 -
>  fs/btrfs/inode.c                                   | 228 ++------
>  fs/btrfs/ordered-data.c                            |  41 +-
>  fs/btrfs/ordered-data.h                            |   8 +-
>  fs/btrfs/reflink.c                                 | 106 ++--
>  fs/btrfs/super.c                                   |   3 +-
>  fs/ceph/addr.c                                     |  13 +-
>  fs/configfs/dir.c                                  |  57 +-
>  fs/crypto/fscrypt_private.h                        |  87 +--
>  fs/crypto/inline_crypt.c                           |   8 +-
>  fs/crypto/keyring.c                                | 239 ++++----
>  fs/crypto/keysetup.c                               | 121 ++--
>  fs/dlm/midcomms.c                                  |   4 +-
>  fs/efs/file.c                                      |  21 +-
>  fs/eventpoll.c                                     | 609 ++++++++++++++-=
------
>  fs/exfat/dir.c                                     |  49 +-
>  fs/exfat/exfat_fs.h                                |   7 +-
>  fs/exfat/inode.c                                   |   2 +-
>  fs/exfat/namei.c                                   | 206 +++----
>  fs/ext2/file.c                                     |   9 +-
>  fs/ext4/inode.c                                    |   3 +-
>  fs/ext4/ioctl.c                                    |  15 +-
>  fs/fhandle.c                                       |   2 +-
>  fs/fs-writeback.c                                  |   5 -
>  fs/hfs/bfind.c                                     |   2 +-
>  fs/hfs/bnode.c                                     |  54 +-
>  fs/hfs/brec.c                                      |   2 +-
>  fs/hfs/btree.c                                     |   2 +-
>  fs/hfs/btree.h                                     |  71 +--
>  fs/hfs/hfs_fs.h                                    |  88 +--
>  fs/hfs/inode.c                                     |   3 +-
>  fs/hfsplus/bfind.c                                 |   2 +-
>  fs/hfsplus/bnode.c                                 |  60 +-
>  fs/hfsplus/brec.c                                  |   2 +-
>  fs/hfsplus/btree.c                                 |   2 +-
>  fs/hfsplus/hfsplus_fs.h                            |  40 +-
>  fs/jbd2/journal.c                                  |   2 +
>  fs/lockd/svcsubs.c                                 |   4 +-
>  fs/minix/minix.h                                   |   2 +-
>  fs/namei.c                                         |  24 +-
>  fs/netfs/buffered_read.c                           |  16 +-
>  fs/netfs/objects.c                                 |  15 +-
>  fs/netfs/read_collect.c                            |  47 +-
>  fs/netfs/write_issue.c                             |  11 +-
>  fs/nfs/callback_proc.c                             |   9 +-
>  fs/nfs/delegation.c                                |   9 +-
>  fs/nfs/filelayout/filelayout.c                     |   2 +
>  fs/nfs/flexfilelayout/flexfilelayout.c             |  29 +
>  fs/nfs/flexfilelayout/flexfilelayout.h             |  16 +
>  fs/nfs/fscache.c                                   |   6 +-
>  fs/nfs/fscache.h                                   |   3 +-
>  fs/nfs/internal.h                                  |  12 +-
>  fs/nfs/nfs4proc.c                                  |  22 +-
>  fs/nfs/pnfs.c                                      |   4 +-
>  fs/nfs/pnfs_nfs.c                                  |   2 +-
>  fs/nfs/read.c                                      |  25 +-
>  fs/nfs/write.c                                     |  14 +-
>  fs/nfsd/nfs4state.c                                |  16 +-
>  fs/nilfs2/super.c                                  |   2 -
>  fs/ntfs3/fslog.c                                   | 147 ++++-
>  fs/ntfs3/index.c                                   |  45 +-
>  fs/ntfs3/lznt.c                                    |   2 +-
>  fs/ntfs3/namei.c                                   |   2 +-
>  fs/ntfs3/ntfs_fs.h                                 |   3 +-
>  fs/ntfs3/run.c                                     |   9 +-
>  fs/ocfs2/alloc.c                                   |   2 +-
>  fs/ocfs2/aops.c                                    |  13 +-
>  fs/ocfs2/buffer_head_io.c                          |   7 +-
>  fs/ocfs2/dlm/dlmdebug.c                            |  16 +-
>  fs/ocfs2/dlmglue.c                                 |  17 +
>  fs/ocfs2/inode.c                                   | 150 ++++-
>  fs/ocfs2/journal.c                                 |  13 +-
>  fs/ocfs2/journal.h                                 |   3 +
>  fs/ocfs2/move_extents.c                            |   4 +-
>  fs/ocfs2/ocfs2.h                                   |   2 -
>  fs/ocfs2/quota_local.c                             |   2 +-
>  fs/ocfs2/stack_user.c                              |  10 +-
>  fs/ocfs2/super.c                                   |   2 -
>  fs/ocfs2/sysfile.c                                 |   9 +-
>  fs/orangefs/dir.c                                  |   7 +-
>  fs/overlayfs/inode.c                               |   4 +-
>  fs/proc/array.c                                    |  15 +-
>  fs/proc/base.c                                     | 184 +++----
>  fs/proc/fd.c                                       |  31 +-
>  fs/proc/generic.c                                  |   9 +-
>  fs/proc/internal.h                                 |   6 +-
>  fs/proc/namespaces.c                               |  16 +-
>  fs/proc/proc_net.c                                 |   2 +-
>  fs/proc/task_mmu.c                                 |  61 ++-
>  fs/smb/client/cifs_swn.c                           | 329 ++++++++---
>  fs/smb/client/cifssmb.c                            |  10 +-
>  fs/smb/client/connect.c                            |   3 +
>  fs/smb/client/file.c                               |   4 +-
>  fs/smb/client/inode.c                              |  30 +-
>  fs/smb/client/ioctl.c                              |  12 +-
>  fs/smb/client/misc.c                               |   8 +
>  fs/smb/client/smb2ops.c                            |  38 +-
>  fs/smb/client/smb2pdu.c                            |  10 +-
>  fs/smb/client/trace.h                              |   2 +
>  fs/smb/server/connection.c                         | 101 +++-
>  fs/smb/server/connection.h                         |   6 +
>  fs/smb/server/misc.c                               |  33 --
>  fs/smb/server/misc.h                               |   1 -
>  fs/smb/server/oplock.c                             |  13 +-
>  fs/smb/server/server.c                             |  12 +
>  fs/smb/server/smb2pdu.c                            |  53 +-
>  fs/smb/server/smbacl.c                             |   7 +-
>  fs/smb/server/vfs.c                                |  78 +--
>  fs/smb/server/vfs_cache.c                          | 114 +++-
>  fs/smb/server/vfs_cache.h                          |   1 +
>  fs/sysfs/file.c                                    |   4 +
>  fs/udf/super.c                                     |   2 +-
>  include/acpi/acpi_bus.h                            |   2 +
>  include/asm-generic/bitops/lock.h                  |  22 +-
>  include/dt-bindings/power/fsl,imx93-power.h        |   1 +
>  include/linux/amba/bus.h                           |   5 -
>  include/linux/bpf.h                                |  14 +-
>  include/linux/bpf_local_storage.h                  |   3 -
>  include/linux/bpf_lsm.h                            |   4 +
>  include/linux/cdx/cdx_bus.h                        |   4 -
>  include/linux/device.h                             |   5 +-
>  include/linux/dpll.h                               |  55 ++
>  include/linux/filter.h                             |  15 +-
>  include/linux/gfp.h                                |   4 +
>  include/linux/hid.h                                |  29 +
>  include/linux/host1x.h                             |   7 +
>  include/linux/hyperv.h                             |   5 -
>  include/linux/i3c/master.h                         |   2 +-
>  include/linux/inetdevice.h                         |   5 +
>  include/linux/iommu.h                              |   2 +-
>  include/linux/jiffies.h                            |  15 +-
>  include/linux/namei.h                              |   7 +-
>  include/linux/netfs.h                              |   7 +-
>  include/linux/nfs_page.h                           |   1 +
>  include/linux/nfs_xdr.h                            |   1 -
>  include/linux/pci.h                                |   4 +-
>  include/linux/rpmsg.h                              |   4 -
>  include/linux/rtnetlink.h                          |  63 ++-
>  include/linux/seqlock.h                            | 110 ++++
>  include/linux/slab.h                               | 100 ++++
>  include/linux/sunrpc/clnt.h                        |   1 +
>  include/linux/sunrpc/xprt.h                        |   2 +
>  include/linux/vmalloc.h                            |   4 +-
>  include/linux/workqueue.h                          |   1 +
>  include/net/addrconf.h                             |  15 +-
>  include/net/bluetooth/hci.h                        |  21 +-
>  include/net/bluetooth/hci_core.h                   |  49 +-
>  include/net/bluetooth/l2cap.h                      |  13 +-
>  include/net/dropreason-core.h                      |  21 +-
>  include/net/fib_rules.h                            |   5 +
>  include/net/gue.h                                  |   2 +-
>  include/net/ip_fib.h                               |   7 +-
>  include/net/ip_vs.h                                |   3 +-
>  include/net/net_namespace.h                        |   4 +
>  include/net/netfilter/nf_conntrack_extend.h        |  12 -
>  include/net/netfilter/nf_queue.h                   |   1 +
>  include/net/scm.h                                  |   4 +-
>  include/net/sctp/sctp.h                            |   3 +-
>  include/net/tc_act/tc_pedit.h                      |  18 +-
>  include/net/udp_tunnel.h                           |  86 ++-
>  include/net/xfrm.h                                 |  15 +-
>  include/trace/events/afs.h                         |   4 +
>  include/uapi/linux/bpf.h                           |   1 +
>  include/uapi/linux/dpll.h                          |   1 +
>  io_uring/rw.c                                      |  13 +-
>  kernel/bpf/bpf_inode_storage.c                     |   9 +
>  kernel/bpf/bpf_lsm.c                               |   3 +
>  kernel/bpf/cgroup.c                                | 108 ++--
>  kernel/bpf/core.c                                  |  85 ++-
>  kernel/bpf/devmap.c                                |  12 +
>  kernel/bpf/dispatcher.c                            |   2 +-
>  kernel/bpf/hashtab.c                               |  21 +-
>  kernel/bpf/helpers.c                               |  12 +-
>  kernel/bpf/inode.c                                 |  13 +-
>  kernel/bpf/lpm_trie.c                              |  11 +-
>  kernel/bpf/syscall.c                               |   5 +-
>  kernel/bpf/verifier.c                              |   3 +-
>  kernel/cgroup/cpuset.c                             |   7 +-
>  kernel/cpu.c                                       |  20 +-
>  kernel/fork.c                                      |   9 +-
>  kernel/kcov.c                                      |   4 +-
>  kernel/sched/core.c                                |   1 +
>  kernel/sched/debug.c                               |   9 +-
>  kernel/sched/fair.c                                |  25 +-
>  kernel/taskstats.c                                 |  62 ++-
>  kernel/time/jiffies.c                              |  16 +-
>  kernel/time/posix-cpu-timers.c                     |   2 +-
>  kernel/time/tick-sched.c                           |  11 +-
>  kernel/time/time.c                                 |   2 +-
>  kernel/time/timekeeping.c                          |   7 +-
>  kernel/trace/bpf_trace.c                           |  11 +-
>  kernel/trace/ring_buffer.c                         |   3 +-
>  kernel/trace/trace_eprobe.c                        |   2 +-
>  kernel/trace/trace_events_hist.c                   |  41 +-
>  kernel/trace/trace_events_user.c                   |  43 +-
>  kernel/trace/trace_osnoise.c                       |   4 +-
>  kernel/trace/trace_probe.c                         |   1 +
>  kernel/trace/trace_probe.h                         |   2 +-
>  kernel/workqueue.c                                 |   2 +-
>  lib/test_meminit.c                                 |   2 +-
>  mm/compaction.c                                    |   7 +-
>  mm/damon/core.c                                    |  51 +-
>  mm/damon/sysfs-schemes.c                           |  17 +-
>  mm/memory_hotplug.c                                |   2 +-
>  mm/mm_init.c                                       |  13 +-
>  mm/numa_emulation.c                                |  17 +-
>  mm/swap_cgroup.c                                   |   6 +
>  net/9p/client.c                                    |   2 +
>  net/9p/trans_rdma.c                                |  19 +-
>  net/Kconfig.debug                                  |  15 +
>  net/atm/common.c                                   |   2 +
>  net/batman-adv/distributed-arp-table.c             |  30 +-
>  net/batman-adv/fragmentation.c                     |   8 +-
>  net/batman-adv/gateway_client.c                    |   3 +-
>  net/batman-adv/main.c                              |  13 +-
>  net/batman-adv/multicast_forw.c                    |   7 +-
>  net/batman-adv/routing.c                           |   3 +-
>  net/batman-adv/soft-interface.c                    |  17 +-
>  net/batman-adv/soft-interface.h                    |   2 +
>  net/batman-adv/translation-table.c                 |   5 +-
>  net/bluetooth/6lowpan.c                            |  74 +--
>  net/bluetooth/eir.c                                |   8 +-
>  net/bluetooth/hci_codec.c                          |   2 +-
>  net/bluetooth/hci_conn.c                           |  62 +--
>  net/bluetooth/hci_core.c                           |  83 +--
>  net/bluetooth/hci_event.c                          |  28 +-
>  net/bluetooth/hci_sync.c                           | 179 +++++-
>  net/bluetooth/iso.c                                |   4 +-
>  net/bluetooth/l2cap_core.c                         | 206 +++++--
>  net/bluetooth/l2cap_sock.c                         | 103 ++--
>  net/bluetooth/mgmt.c                               |   5 +-
>  net/bluetooth/msft.c                               |   2 +-
>  net/bluetooth/sco.c                                |  62 ++-
>  net/bluetooth/smp.c                                |  27 +-
>  net/bridge/br_cfm.c                                |   6 +
>  net/bridge/br_cfm_netlink.c                        |   4 +-
>  net/bridge/br_if.c                                 |   3 +
>  net/bridge/br_stp.c                                |   3 +-
>  net/bridge/netfilter/ebtables.c                    |  13 +-
>  net/bridge/netfilter/nft_meta_bridge.c             |   4 +-
>  net/can/bcm.c                                      | 127 ++++-
>  net/can/isotp.c                                    |   9 +-
>  net/core/dev.c                                     |   2 +
>  net/core/fib_rules.c                               |   6 +-
>  net/core/filter.c                                  |  28 +-
>  net/core/flow_dissector.c                          |  12 +-
>  net/core/lwt_bpf.c                                 |  12 +
>  net/core/net_namespace.c                           |   6 +
>  net/core/netdev-genl.c                             |   4 +-
>  net/core/rtnetlink.c                               |  81 +++
>  net/devlink/rate.c                                 |  10 +-
>  net/handshake/genl.c                               |   2 +-
>  net/ieee802154/core.c                              |   2 +-
>  net/ieee802154/header_ops.c                        |   9 +-
>  net/ieee802154/ieee802154.h                        |  17 +
>  net/ieee802154/netlink.c                           |  36 +-
>  net/ife/ife.c                                      |   2 +-
>  net/ipv4/igmp.c                                    |  14 +-
>  net/ipv4/inet_connection_sock.c                    |   6 +
>  net/ipv4/ip_vti.c                                  |   3 +
>  net/ipv4/ipip.c                                    |   3 +
>  net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
>  net/ipv4/udp_tunnel_core.c                         |  16 +-
>  net/ipv4/udp_tunnel_nic.c                          |  80 ++-
>  net/ipv6/addrconf.c                                | 101 ++--
>  net/ipv6/ip6_fib.c                                 |  17 +-
>  net/ipv6/ip6_gre.c                                 |   6 +
>  net/ipv6/ip6_vti.c                                 |   3 +
>  net/ipv6/mcast.c                                   | 165 +++---
>  net/ipv6/ndisc.c                                   |   8 +-
>  net/ipv6/netfilter.c                               |   4 +-
>  net/ipv6/netfilter/ip6t_ah.c                       |   5 +
>  net/ipv6/netfilter/ip6t_hbh.c                      |   1 +
>  net/ipv6/netfilter/ip6t_rt.c                       |   3 +-
>  net/ipv6/netfilter/nf_conntrack_reasm.c            |   3 +-
>  net/ipv6/route.c                                   |   9 +-
>  net/ipv6/seg6.c                                    |   3 +
>  net/ipv6/sit.c                                     |   3 +
>  net/kcm/kcmsock.c                                  |   8 +-
>  net/llc/af_llc.c                                   |   1 +
>  net/llc/llc_conn.c                                 |   1 -
>  net/mac80211/main.c                                |   3 +-
>  net/mac80211/tx.c                                  |  17 +-
>  net/mac802154/iface.c                              |   2 +-
>  net/mac802154/scan.c                               |   1 +
>  net/netfilter/ipset/ip_set_core.c                  |   4 +-
>  net/netfilter/ipset/ip_set_hash_gen.h              |  69 ++-
>  net/netfilter/ipvs/ip_vs_app.c                     |  10 +-
>  net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
>  net/netfilter/ipvs/ip_vs_core.c                    |  36 +-
>  net/netfilter/ipvs/ip_vs_proto_sctp.c              |  18 +-
>  net/netfilter/ipvs/ip_vs_proto_tcp.c               |  11 +-
>  net/netfilter/ipvs/ip_vs_proto_udp.c               |   3 +-
>  net/netfilter/ipvs/ip_vs_xmit.c                    |   6 +-
>  net/netfilter/nf_conncount.c                       |  23 +-
>  net/netfilter/nf_conntrack_core.c                  |  83 +--
>  net/netfilter/nf_conntrack_ecache.c                |   2 +-
>  net/netfilter/nf_conntrack_extend.c                |  32 +-
>  net/netfilter/nf_conntrack_irc.c                   |   6 +-
>  net/netfilter/nf_conntrack_seqadj.c                |   2 +
>  net/netfilter/nf_nat_core.c                        |  10 +
>  net/netfilter/nf_nat_sip.c                         |  11 +
>  net/netfilter/nf_queue.c                           |  14 +
>  net/netfilter/nf_synproxy_core.c                   |  40 +-
>  net/netfilter/nfnetlink_cthelper.c                 |  24 +-
>  net/netfilter/nfnetlink_osf.c                      |   6 +-
>  net/netfilter/nfnetlink_queue.c                    |   3 +
>  net/netfilter/nft_compat.c                         |  24 +-
>  net/netfilter/nft_lookup.c                         |  10 +-
>  net/netfilter/nft_set_pipapo.c                     |  34 +-
>  net/netfilter/nft_set_pipapo.h                     |   8 +
>  net/netfilter/nft_synproxy.c                       |   9 +-
>  net/netfilter/xt_cluster.c                         |   2 +-
>  net/netfilter/xt_connmark.c                        |  14 +-
>  net/netfilter/xt_nat.c                             |   9 +
>  net/netfilter/xt_rateest.c                         |   2 +-
>  net/netfilter/xt_u32.c                             |  12 +-
>  net/openvswitch/conntrack.c                        |   2 +-
>  net/openvswitch/flow_netlink.c                     | 201 +++++--
>  net/psample/psample.c                              |   6 +-
>  net/qrtr/af_qrtr.c                                 |   2 +-
>  net/rxrpc/recvmsg.c                                |   5 +-
>  net/sched/act_api.c                                |  13 +-
>  net/sched/act_bpf.c                                |   2 +-
>  net/sched/act_ct.c                                 |  13 +-
>  net/sched/act_pedit.c                              |  13 +-
>  net/sched/cls_api.c                                |  25 +-
>  net/sched/cls_bpf.c                                |  10 +-
>  net/sched/cls_flow.c                               |  12 +-
>  net/sched/sch_cake.c                               |   5 +-
>  net/sched/sch_codel.c                              |  48 +-
>  net/sched/sch_drr.c                                |   8 +-
>  net/sched/sch_fq_codel.c                           |  41 +-
>  net/sched/sch_hfsc.c                               |  24 +-
>  net/sched/sch_hhf.c                                |  27 +
>  net/sched/sch_htb.c                                |  14 +-
>  net/sched/sch_multiq.c                             |   2 +-
>  net/sched/sch_taprio.c                             |   2 +-
>  net/sched/sch_teql.c                               | 126 +++--
>  net/sctp/diag.c                                    |  67 ++-
>  net/sctp/sm_make_chunk.c                           |  10 +-
>  net/sctp/sm_statefuns.c                            |  23 +-
>  net/sctp/socket.c                                  |  38 +-
>  net/smc/smc_cdc.c                                  |  15 +-
>  net/smc/smc_loopback.c                             |   5 +
>  net/sunrpc/clnt.c                                  |  19 +-
>  net/sunrpc/svcsock.c                               |  10 +
>  net/sunrpc/xdr.c                                   |  14 +-
>  net/sunrpc/xprt.c                                  |  16 +
>  net/sunrpc/xprtrdma/backchannel.c                  |   5 +-
>  net/sunrpc/xprtrdma/frwr_ops.c                     |   2 +-
>  net/sunrpc/xprtrdma/rpc_rdma.c                     | 171 ++++--
>  net/sunrpc/xprtrdma/transport.c                    |  85 ++-
>  net/sunrpc/xprtrdma/verbs.c                        | 126 ++++-
>  net/sunrpc/xprtrdma/xprt_rdma.h                    |   4 +-
>  net/sunrpc/xprtsock.c                              |  16 +-
>  net/tipc/bearer.c                                  |   1 +
>  net/tipc/core.c                                    |   5 +
>  net/tipc/discover.c                                |  14 +-
>  net/tipc/name_distr.c                              |  13 +-
>  net/tipc/netlink.c                                 |  12 +
>  net/tipc/socket.c                                  |   3 +
>  net/tls/tls_sw.c                                   |  11 +
>  net/unix/af_unix.c                                 |  94 ++--
>  net/vmw_vsock/virtio_transport_common.c            |  88 ++-
>  net/wireless/nl80211.c                             |   2 +-
>  net/xfrm/espintcp.c                                |  34 +-
>  net/xfrm/xfrm_interface_core.c                     |   3 +
>  net/xfrm/xfrm_policy.c                             |  27 +-
>  net/xfrm/xfrm_state.c                              |  26 +-
>  net/xfrm/xfrm_user.c                               |  20 +-
>  rust/kernel/alloc/kvec.rs                          |   4 +-
>  rust/kernel/block/mq/gen_disk.rs                   |  15 +-
>  rust/kernel/block/mq/request.rs                    |   2 +
>  samples/trace_events/trace-events-sample.c         |   4 +
>  scripts/kconfig/conf.c                             |   6 +-
>  security/apparmor/apparmorfs.c                     | 111 +++-
>  security/apparmor/domain.c                         |  58 +-
>  security/apparmor/include/apparmorfs.h             |  12 +
>  security/apparmor/label.c                          |   2 +-
>  security/apparmor/net.c                            |   1 +
>  security/apparmor/policy.c                         |  20 +-
>  security/apparmor/procattr.c                       |   2 +
>  security/bpf/hooks.c                               |   3 +
>  security/integrity/evm/evm_secfs.c                 |  16 +-
>  security/keys/keyring.c                            |   2 +-
>  security/landlock/net.c                            |  11 +-
>  security/selinux/hooks.c                           |  80 ++-
>  sound/aoa/fabrics/layout.c                         |   6 +
>  sound/core/init.c                                  |  11 +-
>  sound/core/seq/seq_clientmgr.c                     |  33 +-
>  sound/core/seq/seq_memory.c                        |   2 +-
>  sound/core/seq/seq_midi.c                          |  55 +-
>  sound/pci/hda/cs35l41_hda.c                        |  77 ++-
>  sound/pci/hda/cs35l41_hda.h                        |   5 +
>  sound/soc/amd/acp/acp-sdw-sof-mach.c               |   7 +-
>  sound/soc/codecs/adau1372.c                        |   5 +
>  sound/soc/codecs/aw88261.c                         |  12 +-
>  sound/soc/codecs/cs35l56-shared.c                  |   1 +
>  sound/soc/codecs/cs35l56.c                         |  14 +-
>  sound/soc/codecs/hdac_hdmi.c                       |   4 +-
>  sound/soc/codecs/lpass-va-macro.c                  |   8 +-
>  sound/soc/codecs/tlv320aic3x.c                     |  25 +-
>  sound/soc/fsl/fsl_asrc_dma.c                       |  20 +
>  sound/soc/fsl/fsl_audmix.c                         |   6 +
>  sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  11 +
>  sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |   9 +
>  sound/soc/qcom/qdsp6/q6apm.c                       |   8 +
>  sound/soc/sh/rcar/rsnd.h                           |   2 +-
>  sound/soc/sof/ipc3-control.c                       |  79 ++-
>  sound/soc/sof/ipc4-control.c                       |  11 +-
>  sound/soc/sof/topology.c                           |   5 +-
>  sound/soc/tegra/tegra210_ahub.c                    |   4 +-
>  sound/usb/midi2.c                                  |   5 +
>  sound/usb/mixer_scarlett2.c                        | 201 ++++++-
>  tools/bpf/bpftool/cgroup.c                         |  14 +-
>  tools/bpf/bpftool/gen.c                            |   2 +-
>  tools/bpf/bpftool/net.c                            |   4 +-
>  tools/include/uapi/linux/bpf.h                     |   1 +
>  tools/include/uapi/linux/mount.h                   | 235 ++++++++
>  tools/include/uapi/linux/nsfs.h                    |  45 ++
>  tools/lib/api/fs/fs.c                              |  19 +-
>  tools/lib/bpf/libbpf.c                             |   9 +-
>  tools/lib/bpf/strset.c                             |  62 ++-
>  tools/lib/bpf/usdt.c                               |  16 +-
>  tools/lib/symbol/kallsyms.c                        |   5 +-
>  tools/perf/Documentation/perf-inject.txt           |   5 +
>  tools/perf/Documentation/perf-sched.txt            |   8 +
>  tools/perf/arch/arm64/util/header.c                |   1 -
>  tools/perf/arch/common.c                           |   4 +-
>  tools/perf/bench/inject-buildid.c                  |   9 +-
>  tools/perf/builtin-annotate.c                      |   3 +-
>  tools/perf/builtin-buildid-cache.c                 |  12 +-
>  tools/perf/builtin-buildid-list.c                  |  10 +-
>  tools/perf/builtin-c2c.c                           |  24 +-
>  tools/perf/builtin-diff.c                          |   3 +-
>  tools/perf/builtin-inject.c                        | 197 ++++++-
>  tools/perf/builtin-report.c                        |  14 +-
>  tools/perf/builtin-sched.c                         | 261 ++++++---
>  tools/perf/builtin-script.c                        |   1 +
>  tools/perf/builtin-stat.c                          |  50 +-
>  tools/perf/include/perf/perf_dlfilter.h            |   2 +-
>  tools/perf/tests/dlfilter-test.c                   |   8 +-
>  tools/perf/tests/dso-data.c                        |   4 +-
>  tools/perf/tests/pmu-events.c                      |  24 +-
>  tools/perf/tests/sample-parsing.c                  |   5 +-
>  tools/perf/tests/sdt.c                             |   2 +-
>  tools/perf/tests/symbols.c                         |   4 +-
>  tools/perf/util/arm-spe.c                          | 221 +++++++-
>  tools/perf/util/bpf-event.c                        |  18 +-
>  tools/perf/util/bpf-utils.c                        |  16 +
>  tools/perf/util/build-id.c                         |  40 +-
>  tools/perf/util/build-id.h                         |   6 +-
>  tools/perf/util/cpumap.c                           |  28 +-
>  tools/perf/util/cs-etm-base.c                      |   4 +-
>  tools/perf/util/cs-etm-decoder/cs-etm-decoder.c    |  21 +-
>  tools/perf/util/cs-etm.c                           | 311 +++++++----
>  tools/perf/util/cs-etm.h                           |   8 +-
>  tools/perf/util/debuginfo.c                        |   9 +-
>  tools/perf/util/disasm.c                           |   2 +-
>  tools/perf/util/dso.c                              | 276 +++++++---
>  tools/perf/util/dso.h                              |  93 ++--
>  tools/perf/util/dsos.c                             |  20 +-
>  tools/perf/util/env.h                              |  14 +
>  tools/perf/util/event.c                            |  17 +-
>  tools/perf/util/event.h                            |   1 +
>  tools/perf/util/header.c                           |  56 +-
>  tools/perf/util/hist.c                             |   7 +-
>  tools/perf/util/intel-bts.c                        |   3 +-
>  .../util/intel-pt-decoder/intel-pt-insn-decoder.c  |  11 +-
>  tools/perf/util/intel-pt.c                         |  27 +-
>  tools/perf/util/machine.c                          |  70 +--
>  tools/perf/util/map.c                              |  15 +-
>  tools/perf/util/map.h                              |   5 +-
>  tools/perf/util/maps.c                             | 156 ++++--
>  tools/perf/util/maps.h                             |   3 +
>  tools/perf/util/mmap.c                             |  18 +-
>  tools/perf/util/pmu.c                              |  10 +-
>  tools/perf/util/probe-event.c                      |   4 +-
>  tools/perf/util/probe-file.c                       |   4 +-
>  tools/perf/util/probe-finder.c                     |   2 +-
>  .../util/scripting-engines/trace-event-python.c    |   7 +-
>  tools/perf/util/sort.c                             |  27 +-
>  tools/perf/util/svghelper.c                        |  10 +-
>  tools/perf/util/symbol-elf.c                       | 116 ++--
>  tools/perf/util/symbol-minimal.c                   |  16 +-
>  tools/perf/util/symbol.c                           |  21 +-
>  tools/perf/util/synthetic-events.c                 |  48 +-
>  tools/perf/util/synthetic-events.h                 |   6 +-
>  tools/perf/util/thread.c                           |   5 +
>  tools/perf/util/unwind-libunwind-local.c           |  16 +-
>  tools/power/x86/intel-speed-select/isst-daemon.c   |   9 +-
>  tools/testing/cxl/test/cxl.c                       |  10 +-
>  tools/testing/cxl/test/mem.c                       |   6 +-
>  .../selftests/bpf/prog_tests/fill_link_info.c      |   2 +-
>  .../selftests/bpf/prog_tests/verifier_log.c        |   1 +
>  .../selftests/bpf/progs/bpf_iter_task_vmas.c       |   2 +-
>  .../testing/selftests/bpf/progs/test_tunnel_kern.c |  13 +-
>  tools/testing/selftests/bpf/progs/xdp_flowtable.c  |   7 +-
>  tools/testing/selftests/bpf/vmtest.sh              |   2 +-
>  .../selftests/filesystems/statmount/Makefile       |   3 +-
>  .../selftests/filesystems/statmount/statmount.h    |  36 ++
>  .../ftrace/test.d/00basic/test_ownership.tc        |   2 +-
>  tools/testing/selftests/hid/Makefile               |   2 +-
>  tools/testing/selftests/hid/hid_bpf.c              |  36 +-
>  tools/testing/selftests/hid/progs/hid.c            |  15 +
>  .../selftests/landlock/scoped_signal_test.c        | 237 +++++++-
>  .../selftests/mm/charge_reserved_hugetlb.sh        |   3 +-
>  tools/testing/selftests/mm/compaction_test.c       |   3 +
>  tools/testing/selftests/mm/hmm-tests.c             |  63 ++-
>  tools/testing/selftests/mm/hugepage-mremap.c       |  32 +-
>  tools/testing/selftests/mm/pkey-arm64.h            |   3 +-
>  tools/testing/selftests/net/lib.sh                 |  25 +-
>  tools/testing/selftests/net/tcp_mmap.c             |   4 +
>  tools/virtio/vringh_test.c                         |   5 +
>  virt/kvm/kvm_main.c                                |  16 +-
>  1201 files changed, 17287 insertions(+), 9232 deletions(-)
>=20
>=20

--=20

--0R9vQlqvrpDs/ix/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamEBVAAKCRAw5/Bqldv6
8ojuAJ0a5xxtRSZg/3yrncGoxWgYul7N0ACfd70O5nqXOfOLUycnREe3NuxTllA=
=0HkD
-----END PGP SIGNATURE-----

--0R9vQlqvrpDs/ix/--
