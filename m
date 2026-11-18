Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057708;
	b=w6IPluVHm6A6BDmuIQtluuJWe474VAYushw8XSxE6oAhUl4TUJhU7k9NlCSic/qOhLYF
	 ZebXN4XQWe38eCsbw7DH2EQVJXYUtrunoKCb5kWOvDuMjuxiZynoI3+NRV6ectu4lheCj
	 NnWyb5t0zuWuuzRkkrZCe41KZYvb5ATbAIk3yWZYRRLaDGj71VKJl6ubt1TZ9fRdQWzsN
	 qo54JZd7UfcJmK7sQYMG1FuVJzc/2EIEMsybiDadZq3HjXayesnWITjZXD4bli6diDesg
	 8xLppLm+fwHzCGOYwNpUE6dcDIAZ9MBJosy/gAQufq2cMnFcYwGDPLEq4ICc0JQZcMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XJ3nsxZQuPxH+DKbuVCbESAVbehISLGKOpl5YpgMDdU=;
	b=CZ4I9O2axwaiq1CpjRxPYo3k5U/DWnIserg5ucr8hgtO9tF69GxR/E5fmtFkSazNAYGb
	 5IAAhcj3EFfxW5l1bbVKzce6YFQSjvIy10SSkHvTf3WgAOOO3J2/S4yMSNGnuLmsq0WQW
	 5kB24vEalPw5q+mQXCalbo+1q4yHRyQ5Jo62PaYnKCV7JWgVhQKiMtKZQQs7VLOkf4RLN
	 PzBfdWOL+THLkhdDtAsn/WmG1vnKr/stz8MQcHkM9PhanVFGOhu7Mdhn7fVdOccMkESLh
	 HVEtBVvvqdWI9NZMSA9ezDss2rYQ5kUdJG1Sz4g0YYraYNyPIuuEhHZkK24ns7eYGdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzsqXuBB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3E8606A337;
	Thu, 19 Nov 2026 03:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzsqXuBB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6941F1F000C5;
	Thu, 19 Nov 2026 03:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057707;
	bh=XJ3nsxZQuPxH+DKbuVCbESAVbehISLGKOpl5YpgMDdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzsqXuBBbpjZ+eEJezRr5wUPgtebqDQccnuFIVpxbhRQ8ccBjOGDgnNnYFufNnIRY
	 m8OCRGh0GLylu5UKBmbihaSMAzj3Xwd0JyDUb1Vv9xTumhaBgdU9EIOQnczdxMC446
	 QSr61EpAcxqNX+KwvizgbeJgClf4QsUBg6makxwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Gang He <ghe@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 5.10 0219/1848] ocfs2: publish the filecheck owner before adding sysfs attributes
Date: Wed, 18 Nov 2026 15:37:37 +0100
Message-ID: <20261118145921.166903415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

commit e062baf5680845705d21df415c8f0751c96b0792 upstream.

ocfs2_filecheck_create_sysfs() initializes the filecheck allocation before
calling kobject_init_and_add(), but assigns entry->fs_fcheck only after
that call returns.  The default attribute group can already be visible
while registration is in progress.  A concurrent read can therefore enter
ocfs2_filecheck_attr_show() with a NULL fs_fcheck and try to lock its
fc_lock.

Assign the initialized owner before adding the kobject, so every activated
attribute has valid state.  Clear the pointer when addition fails,
preserving the existing teardown guard and error cleanup.

A controlled probe-instrumented test kernel with the original OCFS2
registration ordering produced this Oops during a concurrent sysfs read:

  KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
  RIP: 0010:kasan_byte_accessible+0x15/0x30
  Call Trace:
   <TASK>
   __kasan_check_byte+0x13/0x50
   lock_acquire+0x113/0x300
   _raw_spin_lock+0x31/0x40
   ocfs2_filecheck_attr_show+0x138/0x5f0
   ocfs2_filecheck_show+0x5d/0x90
   sysfs_kf_seq_show+0x1d3/0x360
   seq_read_iter+0x480/0x1110
   kernfs_fop_read_iter+0x419/0x5a0
   vfs_read+0x7d2/0xc20
   ksys_read+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in:

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0086-v4-1b3a3c5fd05c1fb41df9@gmail.com
Fixes: 5f483c4abb50 ("ocfs2: add kobject for online file check")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Gang He <ghe@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/filecheck.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -180,17 +180,20 @@ int ocfs2_filecheck_create_sysfs(struct
 	fcheck->fc_size = 0;
 	fcheck->fc_done = 0;
 
+	/* Publish the initialized owner before activating its sysfs callbacks. */
+	entry->fs_fcheck = fcheck;
 	entry->fs_kobj.kset = osb->osb_dev_kset;
 	init_completion(&entry->fs_kobj_unregister);
 	ret = kobject_init_and_add(&entry->fs_kobj, &ocfs2_ktype_filecheck,
 					NULL, "filecheck");
 	if (ret) {
+		/* Mount failure still calls ocfs2_filecheck_remove_sysfs(). */
+		entry->fs_fcheck = NULL;
 		kobject_put(&entry->fs_kobj);
 		kfree(fcheck);
 		return ret;
 	}
 
-	entry->fs_fcheck = fcheck;
 	return 0;
 }
 


