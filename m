Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAE937D13B;
	Mon, 13 Apr 2026 20:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113401; cv=none; b=fzNLOhyvobqAvmHzgfPYzzwPmKMWnMADkr1vBZa9lYt8j3n6V0/CBZ7oZ0uEgHz/176CEIgpIH5auldiBnfv/37FZE4+L72W4FRXMOWl9/FijOVE7gHP55qauXN+ERbrJ2pkpLu6Z9D336c4l4chraaHIsz+CEmHCyU0LY0V0l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113401; c=relaxed/simple;
	bh=HAhJ6BGidEeC2sux3Pg+VOjE9gR0YpOZeEhKSv2dmmo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DzRJSzzXpcmUyIQWShuu+yzGnFunXIUGce2KGtfJ+KEbuCvi7q5R5UKAYVDoAuB6BR8I0VAkO/CXYv2or1yWQ13/M/FdcBwd7OiF6PRho3ucWCyIhQRGxka31vyVx9RacraVcKJ2oX0HxbTQ9dw+z8Jv2UXuDx9zmdLvYpFze90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCOEH-004n0E-1F;
	Mon, 13 Apr 2026 20:49:56 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCOEF-00000002jXV-04C6;
	Mon, 13 Apr 2026 22:49:55 +0200
Message-ID: <f7fa93cd2c1f040e9fcd44b395c286a9c7129095.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 472/491] drm: Fix use-after-free on framebuffers
 and property blobs when calling drm_dev_unplug
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Thomas =?ISO-8859-1?Q?Hellstr=F6m?=
	 <thomas.hellstrom@linux.intel.com>, Maarten Lankhorst <dev@lankhorst.se>, 
 Sasha Levin <sashal@kernel.org>
Date: Mon, 13 Apr 2026 22:49:50 +0200
In-Reply-To: <20260413155836.716796044@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155836.716796044@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/+clQxeSxgK7+1iq42G/"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-/+clQxeSxgK7+1iq42G/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Maarten Lankhorst <dev@lankhorst.se>
>=20
> [ Upstream commit 6bee098b91417654703e17eb5c1822c6dfd0c01d ]

This has already been reverted upstream (commit 45ebe43ea00d), so please
drop it from all queues.

Ben.

> When trying to do a rather aggressive test of igt's "xe_module_load
> --r reload" with a full desktop environment and game running I noticed
> a few OOPSes when dereferencing freed pointers, related to
> framebuffers and property blobs after the compositor exits.
>=20
> Solve this by guarding the freeing in drm_file with drm_dev_enter/exit,
> and immediately put the references from struct drm_file objects during
> drm_dev_unplug().
>=20
> Related warnings for framebuffers on the subtest:
> [  739.713076] ------------[ cut here ]------------
>                WARN_ON(!list_empty(&dev->mode_config.fb_list))
> [  739.713079] WARNING: drivers/gpu/drm/drm_mode_config.c:584 at drm_mode=
_config_cleanup+0x30b/0x320 [drm], CPU#12: xe_module_load/13145
> ....
> [  739.713328] Call Trace:
> [  739.713330]  <TASK>
> [  739.713335]  ? intel_pmdemand_destroy_state+0x11/0x20 [xe]
> [  739.713574]  ? intel_atomic_global_obj_cleanup+0xe4/0x1a0 [xe]
> [  739.713794]  intel_display_driver_remove_noirq+0x51/0xb0 [xe]
> [  739.714041]  xe_display_fini_early+0x33/0x50 [xe]
> [  739.714284]  devm_action_release+0xf/0x20
> [  739.714294]  devres_release_all+0xad/0xf0
> [  739.714301]  device_unbind_cleanup+0x12/0xa0
> [  739.714305]  device_release_driver_internal+0x1b7/0x210
> [  739.714311]  device_driver_detach+0x14/0x20
> [  739.714315]  unbind_store+0xa6/0xb0
> [  739.714319]  drv_attr_store+0x21/0x30
> [  739.714322]  sysfs_kf_write+0x48/0x60
> [  739.714328]  kernfs_fop_write_iter+0x16b/0x240
> [  739.714333]  vfs_write+0x266/0x520
> [  739.714341]  ksys_write+0x72/0xe0
> [  739.714345]  __x64_sys_write+0x19/0x20
> [  739.714347]  x64_sys_call+0xa15/0xa30
> [  739.714355]  do_syscall_64+0xd8/0xab0
> [  739.714361]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
>=20
> and
>=20
> [  739.714459] ------------[ cut here ]------------
> [  739.714461] xe 0000:67:00.0: [drm] drm_WARN_ON(!list_empty(&fb->filp_h=
ead))
> [  739.714464] WARNING: drivers/gpu/drm/drm_framebuffer.c:833 at drm_fram=
ebuffer_free+0x6c/0x90 [drm], CPU#12: xe_module_load/13145
> [  739.714715] RIP: 0010:drm_framebuffer_free+0x7a/0x90 [drm]
> ...
> [  739.714869] Call Trace:
> [  739.714871]  <TASK>
> [  739.714876]  drm_mode_config_cleanup+0x26a/0x320 [drm]
> [  739.714998]  ? __drm_printfn_seq_file+0x20/0x20 [drm]
> [  739.715115]  ? drm_mode_config_cleanup+0x207/0x320 [drm]
> [  739.715235]  intel_display_driver_remove_noirq+0x51/0xb0 [xe]
> [  739.715576]  xe_display_fini_early+0x33/0x50 [xe]
> [  739.715821]  devm_action_release+0xf/0x20
> [  739.715828]  devres_release_all+0xad/0xf0
> [  739.715843]  device_unbind_cleanup+0x12/0xa0
> [  739.715850]  device_release_driver_internal+0x1b7/0x210
> [  739.715856]  device_driver_detach+0x14/0x20
> [  739.715860]  unbind_store+0xa6/0xb0
> [  739.715865]  drv_attr_store+0x21/0x30
> [  739.715868]  sysfs_kf_write+0x48/0x60
> [  739.715873]  kernfs_fop_write_iter+0x16b/0x240
> [  739.715878]  vfs_write+0x266/0x520
> [  739.715886]  ksys_write+0x72/0xe0
> [  739.715890]  __x64_sys_write+0x19/0x20
> [  739.715893]  x64_sys_call+0xa15/0xa30
> [  739.715900]  do_syscall_64+0xd8/0xab0
> [  739.715905]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
>=20
> and then finally file close blows up:
>=20
> [  743.186530] Oops: general protection fault, probably for non-canonical=
 address 0xdead000000000122: 0000 [#1] SMP
> [  743.186535] CPU: 3 UID: 1000 PID: 3453 Comm: kwin_wayland Tainted: G  =
      W           7.0.0-rc1-valkyria+ #110 PREEMPT_{RT,(lazy)}
> [  743.186537] Tainted: [W]=3DWARN
> [  743.186538] Hardware name: Gigabyte Technology Co., Ltd. X299 AORUS Ga=
ming 3/X299 AORUS Gaming 3-CF, BIOS F8n 12/06/2021
> [  743.186539] RIP: 0010:drm_framebuffer_cleanup+0x55/0xc0 [drm]
> [  743.186588] Code: d8 72 73 0f b6 42 05 ff c3 39 c3 72 e8 49 8d bd 50 0=
7 00 00 31 f6 e8 3a 80 d3 e1 49 8b 44 24 10 49 8d 7c 24 08 49 8b 54 24 08 <=
48> 3b 38 0f 85 95 7f 02 00 48 3b 7a 08 0f 85 8b 7f 02 00 48 89 42
> [  743.186589] RSP: 0018:ffffc900085e3cf8 EFLAGS: 00010202
> [  743.186591] RAX: dead000000000122 RBX: 0000000000000001 RCX: ffffffff8=
217ed03
> [  743.186592] RDX: dead000000000100 RSI: 0000000000000000 RDI: ffff88814=
675ba08
> [  743.186593] RBP: ffffc900085e3d10 R08: 0000000000000000 R09: 000000000=
0000000
> [  743.186593] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88814=
675ba00
> [  743.186594] R13: ffff88810d778000 R14: ffff888119f6dca0 R15: ffff88810=
c660bb0
> [  743.186595] FS:  00007ff377d21280(0000) GS:ffff888cec3f8000(0000) knlG=
S:0000000000000000
> [  743.186596] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  743.186596] CR2: 000055690b55e000 CR3: 0000000113586003 CR4: 000000000=
03706f0
> [  743.186597] Call Trace:
> [  743.186598]  <TASK>
> [  743.186603]  intel_user_framebuffer_destroy+0x12/0x90 [xe]
> [  743.186722]  drm_framebuffer_free+0x3a/0x90 [drm]
> [  743.186750]  ? trace_hardirqs_on+0x5f/0x120
> [  743.186754]  drm_mode_object_put+0x51/0x70 [drm]
> [  743.186786]  drm_fb_release+0x105/0x190 [drm]
> [  743.186812]  ? rt_mutex_slowunlock+0x3aa/0x410
> [  743.186817]  ? rt_spin_lock+0xea/0x1b0
> [  743.186819]  drm_file_free+0x1e0/0x2c0 [drm]
> [  743.186843]  drm_release_noglobal+0x91/0xf0 [drm]
> [  743.186865]  __fput+0x100/0x2e0
> [  743.186869]  fput_close_sync+0x40/0xa0
> [  743.186870]  __x64_sys_close+0x3e/0x80
> [  743.186873]  x64_sys_call+0xa07/0xa30
> [  743.186879]  do_syscall_64+0xd8/0xab0
> [  743.186881]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [  743.186882] RIP: 0033:0x7ff37e567732
> [  743.186884] Code: 08 0f 85 a1 38 ff ff 49 89 fb 48 89 f0 48 89 d7 48 8=
9 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <=
c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 55 bf 01 00
> [  743.186885] RSP: 002b:00007ffc818169a8 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000003
> [  743.186886] RAX: ffffffffffffffda RBX: 00007ffc81816a30 RCX: 00007ff37=
e567732
> [  743.186887] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000=
0000012
> [  743.186888] RBP: 00007ffc818169d0 R08: 0000000000000000 R09: 000000000=
0000000
> [  743.186889] R10: 0000000000000000 R11: 0000000000000246 R12: 000055d60=
a7996e0
> [  743.186889] R13: 00007ffc81816a90 R14: 00007ffc81816a90 R15: 000055d60=
a782a30
> [  743.186892]  </TASK>
> [  743.186893] Modules linked in: rfcomm snd_hrtimer xt_CHECKSUM xt_MASQU=
ERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_addrtype nft_comp=
at x_tables nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4=
 nf_tables overlay cfg80211 bnep mtd_intel_dg snd_hda_codec_intelhdmi mtd s=
nd_hda_codec_hdmi nls_utf8 mxm_wmi intel_wmi_thunderbolt gigabyte_wmi wmi_b=
mof xe drm_gpuvm drm_gpusvm_helper i2c_algo_bit drm_buddy drm_ttm_helper tt=
m video drm_suballoc_helper gpu_sched drm_client_lib drm_exec drm_display_h=
elper cec drm_kunit_helpers drm_kms_helper kunit x86_pkg_temp_thermal intel=
_powerclamp coretemp snd_hda_codec_alc882 snd_hda_codec_realtek_lib snd_hda=
_codec_generic snd_hda_intel snd_soc_avs snd_soc_hda_codec snd_hda_ext_core=
 snd_hda_codec snd_hwdep snd_hda_core snd_intel_dspcfg snd_soc_core snd_com=
press ac97_bus snd_pcm snd_seq snd_seq_device snd_timer i2c_i801 i2c_mux sn=
d i2c_smbus btusb btrtl btbcm btmtk btintel bluetooth ecdh_generic rfkill e=
cc mei_me mei ioatdma dca wmi nfsd drm i2c_dev fuse nfnetlink
> [  743.186938] ---[ end trace 0000000000000000 ]---
>=20
> And for property blobs:
>=20
> void drm_mode_config_cleanup(struct drm_device *dev)
> {
> ...
> 	list_for_each_entry_safe(blob, bt, &dev->mode_config.property_blob_list,
> 				 head_global) {
> 		drm_property_blob_put(blob);
> 	}
>=20
> Resulting in:
>=20
> [  371.072940] BUG: unable to handle page fault for address: 000001ffffff=
ffff
> [  371.072944] #PF: supervisor read access in kernel mode
> [  371.072945] #PF: error_code(0x0000) - not-present page
> [  371.072947] PGD 0 P4D 0
> [  371.072950] Oops: Oops: 0000 [#1] SMP
> [  371.072953] CPU: 0 UID: 1000 PID: 3693 Comm: kwin_wayland Not tainted =
7.0.0-rc1-valkyria+ #111 PREEMPT_{RT,(lazy)}
> [  371.072956] Hardware name: Gigabyte Technology Co., Ltd. X299 AORUS Ga=
ming 3/X299 AORUS Gaming 3-CF, BIOS F8n 12/06/2021
> [  371.072957] RIP: 0010:drm_property_destroy_user_blobs+0x3b/0x90 [drm]
> [  371.073019] Code: 00 00 48 83 ec 10 48 8b 86 30 01 00 00 48 39 c3 74 5=
9 48 89 c2 48 8d 48 c8 48 8b 00 4c 8d 60 c8 eb 04 4c 8d 60 c8 48 8b 71 40 <=
48> 39 16 0f 85 39 32 01 00 48 3b 50 08 0f 85 2f 32 01 00 48 89 70
> [  371.073021] RSP: 0018:ffffc90006a73de8 EFLAGS: 00010293
> [  371.073022] RAX: 000001ffffffffff RBX: ffff888118a1a930 RCX: ffff8881b=
92355c0
> [  371.073024] RDX: ffff8881b92355f8 RSI: 000001ffffffffff RDI: ffff88811=
8be4000
> [  371.073025] RBP: ffffc90006a73e08 R08: ffff8881009b7300 R09: ffff888ce=
cc5b000
> [  371.073026] R10: ffffc90006a73e90 R11: 0000000000000002 R12: 000001fff=
fffffc7
> [  371.073027] R13: ffff888118a1a980 R14: ffff88810b366d20 R15: ffff88811=
8a1a970
> [  371.073028] FS:  00007f1faccbb280(0000) GS:ffff888cec2db000(0000) knlG=
S:0000000000000000
> [  371.073029] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  371.073030] CR2: 000001ffffffffff CR3: 000000010655c001 CR4: 000000000=
03706f0
> [  371.073031] Call Trace:
> [  371.073033]  <TASK>
> [  371.073036]  drm_file_free+0x1df/0x2a0 [drm]
> [  371.073077]  drm_release_noglobal+0x7a/0xe0 [drm]
> [  371.073113]  __fput+0xe2/0x2b0
> [  371.073118]  fput_close_sync+0x40/0xa0
> [  371.073119]  __x64_sys_close+0x3e/0x80
> [  371.073122]  x64_sys_call+0xa07/0xa30
> [  371.073126]  do_syscall_64+0xc0/0x840
> [  371.073130]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [  371.073132] RIP: 0033:0x7f1fb3501732
> [  371.073133] Code: 08 0f 85 a1 38 ff ff 49 89 fb 48 89 f0 48 89 d7 48 8=
9 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <=
c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 55 bf 01 00
> [  371.073135] RSP: 002b:00007ffe8e6f0278 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000003
> [  371.073136] RAX: ffffffffffffffda RBX: 00007ffe8e6f0300 RCX: 00007f1fb=
3501732
> [  371.073137] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000=
0000012
> [  371.073138] RBP: 00007ffe8e6f02a0 R08: 0000000000000000 R09: 000000000=
0000000
> [  371.073139] R10: 0000000000000000 R11: 0000000000000246 R12: 00005585b=
a46eea0
> [  371.073140] R13: 00007ffe8e6f0360 R14: 00007ffe8e6f0360 R15: 00005585b=
a458a30
> [  371.073143]  </TASK>
> [  371.073144] Modules linked in: rfcomm snd_hrtimer xt_addrtype xt_CHECK=
SUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_comp=
at x_tables nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4=
 nf_tables overlay cfg80211 bnep snd_hda_codec_intelhdmi snd_hda_codec_hdmi=
 mtd_intel_dg mtd nls_utf8 wmi_bmof mxm_wmi gigabyte_wmi intel_wmi_thunderb=
olt xe drm_gpuvm drm_gpusvm_helper i2c_algo_bit drm_buddy drm_ttm_helper tt=
m video drm_suballoc_helper gpu_sched drm_client_lib drm_exec drm_display_h=
elper cec drm_kunit_helpers drm_kms_helper kunit x86_pkg_temp_thermal intel=
_powerclamp coretemp snd_hda_codec_alc882 snd_hda_codec_realtek_lib snd_hda=
_codec_generic snd_hda_intel snd_soc_avs snd_soc_hda_codec snd_hda_ext_core=
 snd_hda_codec snd_hwdep snd_hda_core snd_intel_dspcfg snd_soc_core snd_com=
press ac97_bus snd_pcm snd_seq snd_seq_device snd_timer i2c_i801 btusb i2c_=
mux i2c_smbus btrtl snd btbcm btmtk btintel bluetooth ecdh_generic rfkill e=
cc mei_me mei ioatdma dca wmi nfsd drm i2c_dev fuse nfnetlink
> [  371.073198] CR2: 000001ffffffffff
> [  371.073199] ---[ end trace 0000000000000000 ]---
>=20
> Add a guard around file close, and ensure the warnings from drm_mode_conf=
ig
> do not trigger. Fix those by allowing an open reference to the file descr=
iptor
> and cleaning up the file linked list entry in drm_mode_config_cleanup().
>=20
> Cc: <stable@vger.kernel.org> # v4.18+
> Fixes: bee330f3d672 ("drm: Use srcu to protect drm_device.unplugged")
> Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Link: https://patch.msgid.link/20260313151728.14990-4-dev@lankhorst.se
> Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
> [ adapted drm_dbg_printer(dev, DRM_UT_KMS, ...) call to older drm_debug_p=
rinter(...) API ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/drm_file.c        |    5 ++++-
>  drivers/gpu/drm/drm_mode_config.c |    9 ++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
>=20
> --- a/drivers/gpu/drm/drm_file.c
> +++ b/drivers/gpu/drm/drm_file.c
> @@ -248,6 +248,7 @@ static void drm_events_release(struct dr
>  void drm_file_free(struct drm_file *file)
>  {
>  	struct drm_device *dev;
> +	int idx;
> =20
>  	if (!file)
>  		return;
> @@ -271,9 +272,11 @@ void drm_file_free(struct drm_file *file
> =20
>  	drm_events_release(file);
> =20
> -	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> +	if (drm_core_check_feature(dev, DRIVER_MODESET) &&
> +	    drm_dev_enter(dev, &idx)) {
>  		drm_fb_release(file);
>  		drm_property_destroy_user_blobs(dev, file);
> +		drm_dev_exit(idx);
>  	}
> =20
>  	if (drm_core_check_feature(dev, DRIVER_SYNCOBJ))
> --- a/drivers/gpu/drm/drm_mode_config.c
> +++ b/drivers/gpu/drm/drm_mode_config.c
> @@ -543,10 +543,13 @@ void drm_mode_config_cleanup(struct drm_
>  	 */
>  	WARN_ON(!list_empty(&dev->mode_config.fb_list));
>  	list_for_each_entry_safe(fb, fbt, &dev->mode_config.fb_list, head) {
> -		struct drm_printer p =3D drm_debug_printer("[leaked fb]");
> +		if (list_empty(&fb->filp_head) || drm_framebuffer_read_refcount(fb) > =
1) {
> +			struct drm_printer p =3D drm_debug_printer("[leaked fb]");
> =20
> -		drm_printf(&p, "framebuffer[%u]:\n", fb->base.id);
> -		drm_framebuffer_print_info(&p, 1, fb);
> +			drm_printf(&p, "framebuffer[%u]:\n", fb->base.id);
> +			drm_framebuffer_print_info(&p, 1, fb);
> +		}
> +		list_del_init(&fb->filp_head);
>  		drm_framebuffer_free(&fb->base.refcount);
>  	}
> =20
>=20
>=20

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-/+clQxeSxgK7+1iq42G/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmndVu4ACgkQ57/I7JWG
EQlCzg/+IOZ6A5zTuCfSeLwKgeH6VBpdcqFRaX9q3VxPMqgTa6iAPpNZ4k4Vlht9
g1aveB6nEKKl5m6Er1lzis4jVtosRfAsx41EZ/WXL64PVcE98ZrgK96i8mjGm41H
4FPUONzPLaG1jMc9hrw3MTWg39R7fE8hYT2leiW3eA62C2L7Lr3gwe2fZjxLBYN5
J+75bmpkgHULvD6NZem0TUrGsqpq191WxUpUxVT1IT29ltftbx6NJfalL40I9BFh
LKjWgQSFwfbT7VpRRDpxchpOx8QMOqkL/7qvKgaptFmS84sn+o4vVPy9cXDb2Rg/
e8xkp6Az3/XNjQJNMpXqVMFuIFAqqLwwLpuHdWTuI5Ndd27iyos2F5+4Y5A8b21a
DhIuWzOXLhhbsYSp7ZeMtAH8kevvvJwLhHjuvJYsSTHXbUWYfPEB/w3Lg2YAW5Td
0cWCfjE8mhkfJy5/xuM7Pd0vUTGydR+FyoJN7sZ1kWAI5ju4w4RaohXWGigWI1Tc
vsKTCUcpy5y3i4AjBnwC9eTf6Bve7n3/4HL7bJYwn30WTuVif6+P0Y8hCwV5Hk0t
gHO55D043XcOdQb24U5L/P04lCOvUylHzEYpepEsma654qWgaf3OErQ/myk9VVAi
++YEOXegEMJklT9/8+Plq/wGlszXcotPNZzPqICp5NPV2+uimoA=
=6Gfq
-----END PGP SIGNATURE-----

--=-/+clQxeSxgK7+1iq42G/--
