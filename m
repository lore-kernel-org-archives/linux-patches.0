Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031422;
	b=LYk3pXk0P4Z+7Tfw3n+6861iYbWOs/yYrA095WGXtg5h4cEzmOKO6oKiBUhdGLwzcJ/4
	 EIb8Tshl7/S9tZIMLIW5pc/b60YCLL0gDeTw04PlhZabiJvN0ZpIj/rVKulIWqsaMPi2y
	 faLk6mPe8ncZ1hAAXE9F59zRQQ+zU/iiHqtFbePdlyrmLjcrGJ4AeHyqOtyK+PzTzq1Ao
	 rWq6QDR6I+wTZjtn8yN5PGuLDRVXojrleEA3wWTjCbQ1t1uwQoqM8vVlJzkOHGMGUFpjC
	 c5HPhwlKh7rFw+0fxN5ml1JdnHUuSOMX9VA3LeFMEu4iyV/3Lho9fPEL6LUB3JS9ScQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZmN6Z0ciP3XHNzRxqudMDwUyhebR2f9pcUKy1bcx9Ok=;
	b=KwRt2jyISLhsRuikYU2F7TO+mOyfFX6EG506HFB1VPbvAY0CN8xOu2ikiImbnO5kwtip
	 irpHjq+/zboH0lQz7yVkZ0Fp3U4YEG86QDMbJJV9jc/DssB82NffpUF/y9ClZfZszR8M2
	 /lqMGgeC2QlK1I6Ke9FOVUB47K0FQaZMOu4/FGyO58FSDsuiR4k4ofTi78PPfCf7Q+IIm
	 qvC5NeQN4qSBA3SPKETskd0q/XhpqwO2OBbQflCldu1TwMldeRuZvhpF4kjegRr4sXiq3
	 p0ERDoBs7j5GT3cp/QZ8kecrm5sadsxwu4OIiglLgCOasZnlcew5GS2BQ33/dSVnXxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrYndVKl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCF1606A325;
	Wed, 18 Nov 2026 19:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrYndVKl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB04E1F000C4;
	Wed, 18 Nov 2026 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031422;
	bh=ZmN6Z0ciP3XHNzRxqudMDwUyhebR2f9pcUKy1bcx9Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrYndVKlWaVNPO0YhmT9NkTfPsRk886eX0dqp/BvvoyF4I6uqN6cmQmnGwlGGAXOA
	 9UZMKpZ8Y+gOf4zLIDubAD7WVTf17d55ZW022AAAYyt+r/0ntQn6VjJptB8UXsU1uV
	 eoR0gf/S+UzPUQTIKT2QZFU2udxZzSUJX68BJsv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1051/1756] ALSA: timer: Pin the module for userspace timer controllers
Date: Wed, 18 Nov 2026 15:52:58 +0100
Message-ID: <20261118150052.052852672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f84055d3e53f..7d7e3c58fdb17 100644
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



