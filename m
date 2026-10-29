Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.251.229.89
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793269480;
	b=igRm4ikNbFvrtCwfJW2JXvIor7YBZqz5O/dAWmK4ezQ5iQbePk9x8BaYgAGLeRVZjXKF
	 0MXLfdjmTGL86GV2ItpXnj5mCqaCtFnhBCho4SOM/EyipKyjNf4wHbETgJy+zzm0K3AY9
	 JVzIjkx3dCj97fynMiwBgeIGQrd/SVSoSbMvhMPWXxfOTWBjDE1f5fkFu0WQw5a90qtlj
	 o/SWr5aYzjccLyYwtnUz1MW5f7OeR0CiA9Hpb7ftHWmQesqDfz1xwwud04H/xZwZtpaaW
	 iAX6mbY2wgWM1ThCGnA01W+eyoMLtC26iO5mq3qfth2HSqlAVpmlBGXHrwGt4bgjWmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793269480;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Last-TLS-Session-Version;
	bh=zcVdylRoS56yhBpRgKF2JkzQZg39+p6/Di565qWUR1g=;
	b=KryojjHW8K6aSeqM/n4aNb1Livlvox7KjtJsG0U8qvbCEP2NorF+komy4TCJhKjW/Hq1
	 A3AaEuUqkUjkY1nawzGP0vbI+IHSK42QX5fCTOoODhHkyLIB2JUo3wholGQe2+y+P+LPI
	 7o92iq9Bq/rfWktwswhVY1NHG1QC7sS8BQqaEKir2B2xEVZ+1PfMYoOx0uiOr415MK/Do
	 qkKM1ERUh5mQnJ4AbckizWP1l0+u3BqjiDUrm8el/7+qHS7rcUOruZKwk0eaYeTTEeODR
	 G/w9nhzwC//Ac7OAOP5d3VkLBo3bgzMjONchAr1RYo+NQ19LC6kybxK6kMH3+ynF3WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nabladev.com;
	spf=pass smtp.mailfrom=nabladev.com;
	dkim=pass header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=S5AJ5U+2;
	arc=none smtp.remote-ip=178.251.229.89
Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46FD606A326
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 10:24:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A46FD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nabladev.com header.i=@nabladev.com header.a=rsa-sha256 header.s=dkim header.b=S5AJ5U+2
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 57BE510A971;
	Thu, 29 Oct 2026 11:24:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1793269473;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=zcVdylRoS56yhBpRgKF2JkzQZg39+p6/Di565qWUR1g=;
	b=S5AJ5U+2f9jDHpQWFvZGT44HMeo5fD8xU6nfWzDm3vDqDC/j72olMU47HhMgUqkPG+TASz
	krcXPuEFaePCrYDpVvaid+w0pI72MELgvtjlKNU0SLcEqiTBoej2sSi6TCrQStSQQXbm50
	jNj4corJesA6MuM87wbCAWKwalu6UQ+BBkLK8fP0h/vPTvGTEBYS6K1sPpah/dTlw1uznv
	SEg4f6XRjYUQrUtk8hDUyD1e+3o43O2wvrf8H1FL0lrFe1UOJ+Z3BZxXwicgPh6SrOSAqp
	easN2H7nzC7Iy0mKCk/+K4qsc00mRK7NrJPnrYFLSO4EW5JzXh6NfJL2U+U6BA==
Date: Thu, 29 Oct 2026 11:24:29 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	bernard.f6bvp@gmail.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Message-ID: <auMe3fAAMqYKZ-qf@duo.ucw.cz>
References: <20261028165947.349197979@linuxfoundation.org>
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
	protocol="application/pgp-signature"; boundary="19n+6H+Vu7scNikx"
Content-Disposition: inline
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--19n+6H+Vu7scNikx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

What is up with these?

They don't have usual "Commit upstream XXX" markings. They do have
commit ids in the sign-off area (which is a logical place), except
that those hashes don't exist in mainline.

Best regards,
								Pavel

    Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
   =20
    (cherry picked from commit 741a4863ad570889c75f7a8e404567d8f3e46335)
    Signed-off-by: Sasha Levin <sashal@kernel.org>



> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: purge rose_neigh->queue on final teardown
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     ax25: bound REJ-driven fast retransmits with the existing N2 counter
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: hold a reference on incoming sockets queued for accept()
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: don't warn on stray CALL_ACCEPTED/CLEAR_CONFIRMATION in state 3
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: use timer_shutdown_sync() for t0timer teardown
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: guard rose_transmit_link() against a NULL neighbour
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: keep the route needed for routing loop detection
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: don't free fd-owned sockets when reaping in the heartbeat
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: clear neighbour pointer in rose_kill_by_device()
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: release netdev ref and destroy orphaned incoming sockets
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: disconnect orphaned STATE_2 sockets when device is gone
>=20
> Bernard Pidoux <bernard.f6bvp@gmail.com>
>     rose: set SOCK_DESTROY in rose_kill_by_device() for prompt cleanup
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                           |   4 +-
>  arch/nios2/include/asm/checksum.h                  |   2 +-
>  arch/s390/mm/fault.c                               |  11 +-
>  arch/s390/pci/pci_sysfs.c                          |   3 +
>  arch/x86/hyperv/hv_init.c                          |   3 +-
>  arch/x86/kernel/kvm.c                              |  32 +-
>  arch/x86/kvm/mmu/mmu.c                             |   4 +-
>  arch/x86/kvm/vmx/nested.c                          |   4 +-
>  block/blk-zoned.c                                  |  37 +-
>  block/blk.h                                        |   4 +-
>  block/bsg-lib.c                                    |  13 +-
>  block/genhd.c                                      |   2 +-
>  crypto/asymmetric_keys/restrict.c                  |   8 +-
>  drivers/base/regmap/internal.h                     |   1 +
>  drivers/base/regmap/regcache-maple.c               |   9 +-
>  drivers/base/regmap/regcache.c                     |  18 +-
>  drivers/gpio/gpio-mxc.c                            |  69 ++--
>  drivers/gpio/gpiolib.c                             |   9 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   6 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  23 +-
>  drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |  25 +-
>  drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   2 +-
>  drivers/gpu/drm/drm_exec.c                         |  77 +++--
>  drivers/gpu/drm/i915/display/intel_dmc.c           |  21 +-
>  drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 +-
>  drivers/gpu/drm/xe/xe_exec.c                       |   7 +-
>  drivers/gpu/drm/xe/xe_vm.c                         |  31 +-
>  drivers/gpu/drm/xe/xe_vm.h                         |   2 +
>  drivers/hv/channel_mgmt.c                          |  12 +-
>  drivers/hv/connection.c                            |   1 -
>  drivers/hv/vmbus_drv.c                             |   1 -
>  drivers/i2c/busses/i2c-qcom-cci.c                  |   4 +-
>  drivers/i2c/busses/i2c-viai2c-wmt.c                |  22 +-
>  drivers/md/dm-cache-target.c                       |  59 ++--
>  drivers/md/dm-crypt.c                              |   3 +-
>  drivers/md/dm-ebs-target.c                         |   3 +-
>  drivers/md/dm-integrity.c                          |   6 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 +
>  drivers/net/wireless/intersil/p54/fwio.c           |  42 ++-
>  drivers/pci/pci.c                                  |  15 +-
>  drivers/pinctrl/pinctrl-amd.c                      |   9 +
>  drivers/pinctrl/qcom/pinctrl-ipq5018.c             |  10 +-
>  drivers/power/supply/ds2780_battery.c              |   2 +-
>  drivers/power/supply/generic-adc-battery.c         |   9 +-
>  drivers/s390/net/ctcm_mpc.c                        |   3 +-
>  drivers/scsi/libiscsi.c                            |  14 +-
>  drivers/scsi/libsas/sas_expander.c                 |  14 +-
>  drivers/scsi/mpi3mr/mpi3mr_app.c                   |   2 +-
>  drivers/scsi/scsi_transport_fc.c                   |   6 +-
>  drivers/scsi/scsi_transport_iscsi.c                |   2 +-
>  drivers/scsi/scsi_transport_sas.c                  |   6 +-
>  drivers/scsi/st.c                                  |  18 +-
>  drivers/scsi/xen-scsifront.c                       |   1 +
>  drivers/soc/tegra/fuse/tegra-apbmisc.c             |   2 +-
>  drivers/spi/spi-tegra114.c                         |   7 +
>  drivers/target/iscsi/iscsi_target_configfs.c       |  26 +-
>  drivers/ufs/core/ufs_bsg.c                         |   2 +-
>  fs/afs/internal.h                                  |   2 +
>  fs/afs/super.c                                     |   2 +-
>  fs/autofs/waitq.c                                  |  25 +-
>  fs/coredump.c                                      |  16 +-
>  fs/ext4/ext4.h                                     |   2 +
>  fs/ext4/extents_status.c                           |   7 +-
>  fs/ext4/extents_status.h                           |   1 +
>  fs/ext4/super.c                                    |  13 +-
>  fs/fat/dir.c                                       |  44 ++-
>  fs/fcntl.c                                         |   4 +-
>  fs/namei.c                                         |   3 +-
>  fs/notify/fanotify/fanotify_user.c                 |  25 +-
>  fs/notify/mark.c                                   |  11 +
>  fs/ntfs3/ntfs_fs.h                                 |   1 +
>  fs/ntfs3/super.c                                   |  29 +-
>  fs/ocfs2/dlm/dlmcommon.h                           |   2 +
>  fs/ocfs2/dlm/dlmdebug.c                            |   5 +-
>  fs/ocfs2/dlm/dlmrecovery.c                         |   2 +-
>  fs/open.c                                          |  23 +-
>  fs/pipe.c                                          |   6 +-
>  fs/smb/client/cifssmb.c                            |  13 +-
>  fs/smb/client/connect.c                            |  21 +-
>  fs/smb/client/smb2ops.c                            |   7 +-
>  fs/smb/server/smb2pdu.c                            |   5 +
>  fs/tracefs/event_inode.c                           |  16 +-
>  fs/unicode/utf8-core.c                             |  21 +-
>  fs/xfs/libxfs/xfs_sb.c                             |  17 +-
>  fs/xfs/xfs_fsmap.c                                 |   2 +-
>  fs/xfs/xfs_ioctl.c                                 |   2 +-
>  fs/xfs/xfs_iops.c                                  |   2 +-
>  include/drm/drm_exec.h                             |  15 +-
>  include/linux/bsg-lib.h                            |   3 +-
>  include/linux/cgroup-defs.h                        |   5 +-
>  include/linux/fs.h                                 |   6 +-
>  include/linux/fsnotify_backend.h                   |   1 +
>  include/linux/futex.h                              |  14 +-
>  include/linux/huge_mm.h                            |   2 +-
>  include/linux/io_uring_types.h                     |   3 +
>  include/linux/ipv6.h                               |  22 ++
>  include/linux/key-type.h                           |   1 +
>  include/linux/key.h                                |   5 +
>  include/linux/maple_tree.h                         |   4 +
>  include/linux/mm_types.h                           |   3 +
>  include/linux/power_supply.h                       |   6 +-
>  include/linux/sched.h                              |   2 +-
>  include/linux/sched/signal.h                       |  27 +-
>  include/linux/sched/user.h                         |   8 +-
>  include/linux/srcutiny.h                           |   4 -
>  include/linux/unicode.h                            |   1 +
>  include/net/af_vsock.h                             |   3 +
>  include/net/ax25.h                                 |   6 +
>  include/net/codel_impl.h                           |   1 +
>  include/net/ipv6.h                                 |   2 -
>  include/net/netfilter/nf_tables_ipv6.h             |   4 +-
>  include/net/netrom.h                               |  18 +-
>  include/net/rose.h                                 |  45 ++-
>  include/uapi/asm-generic/fcntl.h                   |   1 -
>  io_uring/cancel.c                                  |  29 +-
>  io_uring/cancel.h                                  |   2 +
>  io_uring/futex.c                                   |   7 +-
>  io_uring/io-wq.c                                   | 110 +++++-
>  io_uring/io-wq.h                                   |   4 +-
>  io_uring/io_uring.c                                | 167 +++++++--
>  io_uring/io_uring.h                                |  44 ++-
>  io_uring/kbuf.c                                    |   2 +-
>  io_uring/napi.c                                    |   4 +-
>  io_uring/net.c                                     |  26 +-
>  io_uring/poll.c                                    |  41 ++-
>  io_uring/rw.c                                      |  18 -
>  io_uring/sqpoll.c                                  |   7 +
>  io_uring/tctx.c                                    |   1 +
>  io_uring/timeout.c                                 |  91 +++--
>  io_uring/uring_cmd.c                               |   2 +-
>  io_uring/waitid.c                                  |  19 +-
>  kernel/cgroup/cgroup.c                             |   6 +-
>  kernel/events/core.c                               |  33 +-
>  kernel/exit.c                                      |   2 +-
>  kernel/fork.c                                      |  12 +-
>  kernel/futex/core.c                                |  47 +--
>  kernel/pid_namespace.c                             |   5 +-
>  kernel/printk/printk.c                             |   2 +-
>  kernel/ptrace.c                                    |   6 +
>  kernel/rcu/srcutiny.c                              |  19 +-
>  kernel/sched/ext.c                                 |  18 +-
>  kernel/signal.c                                    |   4 +
>  kernel/trace/ftrace.c                              |   4 +-
>  kernel/trace/ring_buffer.c                         |  13 +-
>  kernel/trace/trace.c                               |  13 +-
>  kernel/trace/trace_events_filter.c                 |  15 +-
>  kernel/trace/trace_events_hist.c                   |  52 +--
>  kernel/trace/trace_events_synth.c                  |  10 +
>  kernel/trace/trace_probe.c                         |   3 +-
>  kernel/trace/trace_synth.h                         |   1 +
>  kernel/watch_queue.c                               |  16 +-
>  kernel/workqueue.c                                 |  24 +-
>  mm/filemap.c                                       |   9 -
>  mm/huge_memory.c                                   |  81 +++--
>  mm/internal.h                                      |   6 +
>  mm/khugepaged.c                                    |   3 +
>  mm/pagewalk.c                                      |   6 +-
>  net/ax25/af_ax25.c                                 |  81 ++++-
>  net/ax25/ax25_ds_in.c                              |   2 +
>  net/ax25/ax25_in.c                                 |  55 ++-
>  net/ax25/ax25_out.c                                | 121 +++++--
>  net/ax25/ax25_std_in.c                             |  44 +++
>  net/ax25/ax25_subr.c                               |  44 ++-
>  net/bluetooth/l2cap_core.c                         |   7 +-
>  net/bluetooth/l2cap_sock.c                         |   2 +
>  net/bridge/br_multicast.c                          |  13 +-
>  net/bridge/br_netfilter_ipv6.c                     |   2 +-
>  net/bridge/netfilter/nf_conntrack_bridge.c         |   4 +-
>  net/core/page_pool.c                               |   3 +-
>  net/ipv4/fib_semantics.c                           |   2 +-
>  net/ipv4/tcp.c                                     |  18 +-
>  net/ipv4/tcp_cong.c                                |   4 +-
>  net/ipv4/tcp_dctcp.c                               |   4 +-
>  net/ipv4/tcp_minisocks.c                           |   2 +-
>  net/ipv4/tcp_output.c                              |   2 +-
>  net/ipv4/udp.c                                     |  11 +-
>  net/ipv6/calipso.c                                 |   6 +-
>  net/ipv6/ip6_input.c                               |   2 +-
>  net/ipv6/ip6_offload.c                             |   7 +-
>  net/ipv6/output_core.c                             |   7 +-
>  net/iucv/af_iucv.c                                 |  42 ++-
>  net/mac802154/ieee802154_i.h                       |   7 +-
>  net/mac802154/main.c                               |   1 +
>  net/mac802154/scan.c                               |  51 ++-
>  net/mptcp/protocol.c                               |  14 +-
>  net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
>  net/netfilter/nf_conntrack_ovs.c                   |   2 +-
>  net/netfilter/nf_log_syslog.c                      |   2 +-
>  net/netfilter/nft_byteorder.c                      |  51 ++-
>  net/netlink/af_netlink.c                           |  10 +-
>  net/netrom/af_netrom.c                             |  33 +-
>  net/netrom/nr_in.c                                 |  26 ++
>  net/netrom/nr_route.c                              | 383 +++++++++++----=
------
>  net/rds/rdma_transport.c                           |  38 +-
>  net/rose/af_rose.c                                 |  73 +++-
>  net/rose/rose_in.c                                 |  44 ++-
>  net/rose/rose_link.c                               |  47 +++
>  net/rose/rose_loopback.c                           |   2 +-
>  net/rose/rose_out.c                                |   1 +
>  net/rose/rose_route.c                              | 200 +++++++++--
>  net/rose/rose_timer.c                              |  87 ++++-
>  net/sched/act_api.c                                |  11 +-
>  net/sched/cls_flower.c                             |   5 +
>  net/sched/sch_cake.c                               |   2 +-
>  net/sctp/inqueue.c                                 |   6 +-
>  net/sctp/socket.c                                  |  33 +-
>  net/socket.c                                       |  54 ++-
>  net/tipc/node.c                                    |   2 +
>  net/vmw_vsock/af_vsock.c                           |  49 ++-
>  net/vmw_vsock/virtio_transport_common.c            |   9 +-
>  samples/pidfd/Makefile                             |   2 +-
>  security/keys/key.c                                |  13 +-
>  security/keys/keyctl.c                             |  15 +-
>  security/keys/keyring.c                            | 150 ++++----
>  security/keys/process_keys.c                       |   5 +-
>  security/keys/trusted-keys/trusted_tpm1.c          |   4 +-
>  security/keys/trusted-keys/trusted_tpm2.c          |   2 +-
>  sound/soc/codecs/cs42l52.c                         |   2 +-
>  sound/soc/codecs/cs42l56.c                         |   2 +-
>  sound/soc/codecs/max98371.c                        |   2 +-
>  sound/soc/codecs/nau8822.c                         |   4 +-
>  sound/soc/codecs/pcm3168a.c                        |   2 +-
>  sound/soc/codecs/wm8978.c                          |   4 +-
>  sound/soc/intel/avs/pcm.c                          |   2 +-
>  sound/soc/sof/ipc4-topology.c                      |  16 +-
>  sound/soc/stm/stm32_spdifrx.c                      |   2 +-
>  tools/gpio/Makefile                                |   6 +
>  tools/power/x86/turbostat/turbostat.c              |  11 +-
>  .../test.d/filter/event-filter-incomplete.tc       |  24 ++
>  229 files changed, 3065 insertions(+), 1216 deletions(-)
>=20
>=20

--=20

--19n+6H+Vu7scNikx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCauMe3QAKCRAw5/Bqldv6
8opFAJ9T/0o5lN1D4hBVzXky8JCtktBlOACdFSkMyO0Y/yJTQh+dalOp/VZ+4yw=
=G1bT
-----END PGP SIGNATURE-----

--19n+6H+Vu7scNikx--
