Received: from email.studentenwerk.mhn.de (mailin.studentenwerk.mhn.de [141.84.225.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CEB367284
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 16:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.84.225.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782922947; cv=none; b=I3UoM6X3ECCSbP9Q7dfa4SOp4cnSEcS2If0NgEMOQqV4Q677gBNi/igW/F0yqAWuueo8WPnFWCrg0lmWaiVTVoWTcH7HLTXSmzer4EW4+r8jrDVkYos0lWigePkX4hsQpKceNZZvaUoIVXHDZUlNVY7m2taqJri6djIxrJ6G+7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782922947; c=relaxed/simple;
	bh=Jzm7Zuu+KJYAA/H1FDOsDsoBDLZ7bSVfnSX5GIW3Xxw=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=oMv8h7U+Hq10y/btYBEphhoVGTyo4fb5yNzICw8XQ8CHTiq9h2G1a0ZrteCy7lTDRmkArC6PWNvzYmfbRTp9UE1672AQ+mwEhz/nMhqLpCgrZkVMeXlRfoFPoW7N6LCwQ5KjvVUmONlD5NTuj2GkkF0W+rK6ZsJSoxA0p6MbdQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stwm.de; spf=pass smtp.mailfrom=stwm.de; dkim=pass (2048-bit key) header.d=stwm.de header.i=@stwm.de header.b=odsRq9Ll; arc=none smtp.client-ip=141.84.225.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stwm.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stwm.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stwm.de header.i=@stwm.de header.b="odsRq9Ll"
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
	by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4gr4q16ZpVzRhRJ;
	Wed, 01 Jul 2026 18:14:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
	t=1782922493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bmmkcu8n/kYtKurJkPZdynkvPyuDi/K9ABsRQryk1lI=;
	b=odsRq9LlUip6Cy+FAbHfkc/fKSFytwkKpzmW6Aw2uXzASwnHXBST/wTmDiR3QbG6hGaxLG
	+MTt+nBhKPnpPFhQmUb+zfg24WSVlQ+0zROAr52LA+6z9EIJvCGDnX3VnI1gsw/IrAvngO
	nZScDhs+lFQlAp4L7+7o+26BPLEcH/Zzr2MzVVKi72cd2ng21nmjnUS/lWtz7UJ+ZqeAxs
	dL28HUuadF3W2OOPJG65YWNZ7lCTOKIIQeL/FfZPqR4PTOyQTI9R7BM0K2MjPVafczugm9
	vMpa+yII0myGzGNXr7do/fNscFHJX9oDRnHJn60tN+b5k5+xEtHZfoKxFjXN4w==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 01 Jul 2026 18:14:53 +0200
From: Wolfgang Walter <linux@stwm.de>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>, Alexandr
 Alexandrov <alexandr.alexandrov@oracle.com>, Yang Erkun
 <yangerkun@huawei.com>, Chuck Lever <chuck.lever@oracle.com>
Subject: 6.18.37 has problems with nfs4 (server), 6.18.36 works
Message-ID: <6eccafaaaa60651ef091257c3439c46b@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studierendenwerk_M=C3=BCnchen_Oberbayern?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hello,

after upgrading to v6.18.37 our nfs-server had problems after about 1 
day. I do not dare to bisect it as caused a relative long downtime.

I would consider running av6.18.37 with

Revert "NFSD: Defer sub-object cleanup in export put callbacks"

reverted if this makes sense.

Of course I'm not sure if this was introduced wth 6.18.37 but we never 
saw that with earlier versions of v6.18.37.

Here is what it logged when ist started:

[77046.588449] R10: 00000000000c0000 R11: dc8c000000000000 R12: 
ffff8ae33e7ff630
[77046.588450] R13: ffff8ae49b33e14c R14: ffff8ae1b8008000 R15: 
ffff8ae49b33e138
[77046.588451] FS:  0000000000000000(0000) GS:ffff8ae7065cf000(0000) 
knlGS:0000000000000000
[77046.588453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[77046.588454] CR2: 0000000000000000 CR3: 00000011a3624002 CR4: 
00000000001726f0
[77046.588456] Call Trace:
[77046.588457]  <TASK>
[77046.588458]  ? __state_in_grace+0x2a/0xc0 [grace]
[77046.588461]  _raw_spin_lock+0x29/0x30
[77046.588464]  nfsd4_lock+0xbcd/0x1690 [nfsd]
[77046.588511]  nfsd4_proc_compound+0x325/0x680 [nfsd]
[77046.588553]  nfsd_dispatch+0xc6/0x210 [nfsd]
[77046.588598]  svc_process_common+0x4c3/0x6a0 [sunrpc]
[77046.588648]  ? __pfx_nfsd_dispatch+0x10/0x10 [nfsd]
[77046.588692]  svc_process+0x142/0x210 [sunrpc]
[77046.588737]  svc_recv+0x7e5/0x9b0 [sunrpc]
[77046.588782]  ? __pfx_nfsd+0x10/0x10 [nfsd]
[77046.588826]  nfsd+0x8f/0xf0 [nfsd]
[77046.588867]  kthread+0xfc/0x230
[77046.588870]  ? __pfx_kthread+0x10/0x10
[77046.588873]  ret_from_fork+0x231/0x260
[77046.588875]  ? __pfx_kthread+0x10/0x10
[77046.588878]  ret_from_fork_asm+0x1a/0x30
[77046.588881]  </TASK>
[77046.596608] watchdog: BUG: soft lockup - CPU#16 stuck for 75s! 
[kworker/u97:6:227618]
[77046.596612] Modules linked in: rpcsec_gss_krb5 msr 8021q garp stp llc 
mrp binfmt_misc intel_rapl_msr intel_rapl_common sb_edac 
x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_ssif kvm_intel kvm 
snd_pcm irqbypass polyval_clmulni snd_timer ghash_clmulni_intel rapl ast 
snd intel_cstate drm_client_lib vga16fb soundcore drm_shmem_helper 
intel_uncore drm_kms_helper vgastate pcspkr iTCO_wdt mei_me 
intel_pmc_bxt iTCO_vendor_support i2c_algo_bit mei watchdog ioatdma 
evdev joydev acpi_power_meter ipmi_si acpi_ipmi ipmi_devintf 
ipmi_msghandler button sg nfsd nfs_acl lockd chacha20poly1305 
auth_rpcgss aesni_intel grace cryptd nfs_localio drbd drm sunrpc fuse 
lru_cache loop efi_pstore configfs ip_tables x_tables autofs4 ext4 crc16 
mbcache jbd2 efivarfs raid10 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq raid0 linear dm_mod raid1 
hid_generic md_mod ses enclosure usbhid hid sd_mod ixgbe libie_fwlog 
xfrm_algo dca mdio_devres of_mdio ahci fixed_phy xhci_pci libahci 
fwnode_mdio mpt3sas ehci_pci
[77046.596647]  libphy raid_class xhci_hcd libata ehci_hcd mdio_bus 
scsi_transport_sas i2c_i801 usbcore ptp i2c_smbus lpc_ich scsi_mod 
pps_core usb_common mdio scsi_common wmi
[77046.596655] CPU: 16 UID: 0 PID: 227618 Comm: kworker/u97:6 Tainted: G 
      D      L      6.18.37-debian64.all+1.3 #1 PREEMPT(full)
[77046.596658] Tainted: [D]=DIE, [L]=SOFTLOCKUP
[77046.596658] Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 1.1a 
10/16/2015
[77046.596659] Workqueue: nfsd4 laundromat_main [nfsd]
[77046.596702] RIP: 0010:native_queued_spin_lock_slowpath+0x28d/0x2c0
[77046.596706] Code: 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 40 31 
4e 99 48 03 04 f5 80 f0 78 98 48 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 
08 <85> c0 74 f7 48 8b 32 48 85 f6 74 81 0f 18 0e e9 79 ff ff ff bf 01
[77046.596708] RSP: 0018:ffffd3abb77c3d70 EFLAGS: 00000246
[77046.596709] RAX: 0000000000000000 RBX: ffff8ae7072d80d0 RCX: 
ffff8ae7072d812c
[77046.596710] RDX: ffff8ae69fcb2140 RSI: 0000000000000003 RDI: 
ffff8ae7072d812c
[77046.596711] RBP: ffff8ae7072d812c R08: 0000000000440000 R09: 
ffff8ae7067cf000
[77046.596713] R10: 0000000000440000 R11: ffff8ae7072d81e8 R12: 
000000000000002f
[77046.596714] R13: ffffd3abb77c3e08 R14: ffff8ae7072d80b0 R15: 
ffff8ae7072d80c0
[77046.596715] FS:  0000000000000000(0000) GS:ffff8ae7067cf000(0000) 
knlGS:0000000000000000
[77046.596717] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[77046.596718] CR2: 00007f93e9a0e3d8 CR3: 00000011a3624005 CR4: 
00000000001726f0
[77046.596719] Call Trace:
[77046.596721]  <TASK>
[77046.596722]  _raw_spin_lock+0x29/0x30
[77046.596725]  laundromat_main+0x3c1/0x940 [nfsd]
[77046.596766]  process_one_work+0x18c/0x350
[77046.596770]  worker_thread+0x196/0x300
[77046.596772]  ? __pfx_worker_thread+0x10/0x10
[77046.596775]  kthread+0xfc/0x230
[77046.596778]  ? __pfx_kthread+0x10/0x10
[77046.596780]  ? __pfx_kthread+0x10/0x10
[77046.596783]  ret_from_fork+0x231/0x260
[77046.596786]  ? __pfx_kthread+0x10/0x10
[77046.596788]  ret_from_fork_asm+0x1a/0x30
[77046.596791]  </TASK>
[77047.256123] rcu: INFO: rcu_preempt self-detected stall on CPU
[77047.256431] rcu:     13-....: (83975 ticks this GP) 
idle=4dc4/1/0x4000000000000000 softirq=9553877/9553878 fqs=41109
[77047.256701] rcu:     (t=84006 jiffies g=22811861 q=552187 ncpus=24)
[77047.256973] CPU: 13 UID: 0 PID: 8887 Comm: nfsd Tainted: G      D     
  L      6.18.37-debian64.all+1.3 #1 PREEMPT(full)
[77047.256976] Tainted: [D]=DIE, [L]=SOFTLOCKUP



Regards
-- 
Wolfgang Walter
Studierendenwerk München Oberbayern
Anstalt des öffentlichen Rechts
