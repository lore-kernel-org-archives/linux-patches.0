Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026166;
	b=oOvX+S5UqgteJlkeiGNHg3Y0Iurl6DNTHs3hO/EcvebTlp+3zhMl9KGlq6aVuhNS97g4
	 2BXIypiPyFEwZDKq0dcYnQz/a8dqb3nlStUPjuGG9EADwMYB6Vc/oDSAZdg+fz1MF0cXy
	 eXfPuH9j3IAr10/gXJlm+vjCoCujU4mKvZ6p6rysenIwJnZr1lmSpsDp4qgabU3KBPlfU
	 Nzg0JaSK3WSXyTQXHTwgVZVUllXwUojQZbmjCUqAJmRTED4+PWQWHkD83s1vD5VrsU204
	 QAzN2JIrC/N3b5gx52L46RSz7I+LdiPa0Demn4M9iPasfT+/KrEmPacS1kDWqLtZPUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g1trKErYKcHKcdzl2CURyzFJ305Xr6TiXZZwZIE8GHA=;
	b=d+Cus6fDubE+WvK3/O8FdmcfF3bQ9+dom9qaAc8lqwut0Wd6WUYoOMChHyDa4FdJfFCE
	 VjAvQyWrTJ5ZyszhK6n3/0SPCGfYt/++hMdqJ0F4UvWMDV7swbzJ/oAcGFAt390Tgjjuq
	 /BRc8d7HZMRmlSUr87n2nd5MeVRkiqhcyDXcuoiVWPEW49+PaC4XG0n3nTRB7TXxK8FcD
	 lubf2smQmPVqSYytWWY6HeiAjWeIbVcz9+arOOz5COzefM7TtYUC8CVg+b7RBMyD5FX2p
	 xCdCX2c4GXwnGfFN1s579RjX6AJY9GWLnSXammeY48bH3Y9Qai1N5e3898PXslbnacA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXiGnZ91;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1C860A2622;
	Wed, 18 Nov 2026 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXiGnZ91
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C040E1F000C7;
	Wed, 18 Nov 2026 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026166;
	bh=g1trKErYKcHKcdzl2CURyzFJ305Xr6TiXZZwZIE8GHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXiGnZ91bk9xHfRv2wJejxHxajf3hbMV7zLZjH8K/UFFpHPZBtEsFspJmgH6IZefr
	 srpvTBuqG0ipWmZ6sdDpLlt7MpqdU6LDsp86rf+rpYoiZwIAGKwh9EFkGzRy8qZ7Nk
	 Vx0p1bGszlMiSgOXEprxBH4j3utOh00gVWf2aXPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1331/2151] ALSA: timer: Pin the module for userspace timer controllers
Date: Wed, 18 Nov 2026 15:51:06 +0100
Message-ID: <20261118150210.553842465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit f9e882ac8257bc55a8c99399e504e434d9e72eb9 ]

The static snd_utimer_ids IDA must remain live until a userspace timer
controller has returned its ID. However, snd_utimer_fops has no owner,
so anon_inode_getfd() does not take a reference to snd-timer for the
controller file.

With CONFIG_SND_TIMER=m and CONFIG_SND_UTIMER=y, userspace can create a
controller with SNDRV_TIMER_IOCTL_CREATE and close the native timer
file. If no timer instances or dependent modules retain snd-timer,
ordinary module unload can then overlap the controller's final release:

  Controller final release              Module unload
  snd_utimer_release()
    snd_utimer_free()
      snd_timer_free(): unlink provider
      snd_utimer_put_id()
        enter ida_free()
                                        delete_module()
                                          alsa_timer_exit()
                                          free_module(): free MOD_DATA
        access snd_utimer_ids.xa

The provider is already absent from snd_timer_free_all() when unload
runs. Neither register_mutex nor the IDA's lock keeps module storage
resident through the remaining IDA access. That access can therefore
use freed module data and fault while acquiring the XArray lock, as
shown in the Oops below.

Set snd_utimer_fops.owner to THIS_MODULE so anonymous-file creation
takes the existing module reference. The VFS drops it only after
snd_utimer_release() returns, keeping the IDA resident through
ida_free() and preventing ordinary unload during that interval.

Oops report as below:

    BUG: unable to handle page fault for address: fffffbfff80480af
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1a7ff6067 P4D 1a7ff6067 PUD 1a7ff2067 PMD 100ad6067 PTE 0
    Oops: Oops: 0000 [#1] SMP KASAN NOPTI
    CPU: 0 UID: 0 PID: 485 Comm: alsa-utimer-fix Tainted: G           O        7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Tainted: [O]=OOT_MODULE
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    RIP: 0010:kasan_byte_accessible+0x15/0x30
    Code: 00 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 48 b8 00 00 00 00 00 fc ff df 48 c1 ef 03 48 01 c7 <0f> b6 07 3c 07 0f 96 c0 e9 69 f1 2b ff 66 66 2e 0f 1f 84 00 00 00
    RSP: 0018:ffff88811a457c48 EFLAGS: 00010086
    RAX: dffffc0000000000 RBX: ffffffffc0240578 RCX: 0000000000000000
    RDX: 0000000000000000 RSI: ffffffff861f111c RDI: fffffbfff80480af
    RBP: ffffffffc0240578 R08: 0000000000000001 R09: 0000000000000000
    R10: ffffffff891cc057 R11: ffff88811531ba00 R12: ffffffff861f111c
    R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
    FS:  00007ff190ff7780(0000) GS:ffff8881fda2a000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: fffffbfff80480af CR3: 0000000116890003 CR4: 0000000000770ef0
    PKRU: 55555554
    Call Trace:
     <TASK>
     __kasan_check_byte+0x13/0x50
     lock_acquire+0x113/0x2f0
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ? lock_release+0xc8/0x280
     ? srso_alias_return_thunk+0x5/0xfbef5
     _raw_spin_lock_irqsave+0x3c/0x60
     ? ida_free+0xd4/0x2b0
     ida_free+0xd4/0x2b0
     ? __pfx_ida_free+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_locks_remove_file+0x10/0x10
     ? __fput+0x39f/0xa60
     ? fput_close_sync+0xff/0x200
     ? __pfx_fput_close_sync+0x10/0x10
     ? dnotify_flush+0x22/0x4b0
     ? __x64_sys_close+0x8c/0xf0
     ? do_syscall_64+0x115/0x6a0
     ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
     </TASK>
    Modules linked in: snd(O) [last unloaded: snd_timer(O)]
    CR2: fffffbfff80480af
    ---[ end trace 0000000000000000 ]---

Fixes: 37745918e0e7 ("ALSA: timer: Introduce virtual userspace-driven timers")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-pmb-98fb8f747fc7b8499fd4-v2-1c531f149a6d6c084f48@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 64bffc21295d4..37c298aa287c0 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -2101,6 +2101,7 @@ static long snd_utimer_ioctl(struct file *file, unsigned int ioctl, unsigned lon
 }
 
 static const struct file_operations snd_utimer_fops = {
+	.owner		=	THIS_MODULE,
 	.llseek		=	noop_llseek,
 	.release	=	snd_utimer_release,
 	.unlocked_ioctl	=	snd_utimer_ioctl,
-- 
2.53.0



