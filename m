Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061135;
	b=H5IScwRAuye7vGqHITYSeFR1de3MPwt0FZs0FBHUPoPV6ZIByN8u0sPynTMPeLEXCBf1
	 yTOX+q34ydUBnYMGN3UwVS54JjkFclir2+aVHeNaPhG7UQ95Mh61nwcOMQY6gwCdAQmDT
	 LtvgxRgDM3T5wG14ZD/Q/qMfHXt9Cil8qWXzWVSsfe5f4J9lkycKw0RPuc1zx4Sn5xlpb
	 ZOTTpyn/oEsaQOb5BiW5iYfy1avYsAxGGIqNR6yok8UVkit6QyN8mBdp4fNNJYRzlypdm
	 U3Lp2v8CZhDgZAUPxVqrU+pzpn43CLcL2YeXov7vmZ6sQhy4rvAPtuv/yQ2eREPVCVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C1QH2QTIYcL6houoiPnns3oWzdNCuPl6rOXLfQcnz2I=;
	b=XgS/RG+BoaFZ9QqlEqY5qrc5xbPXDyrnmvJp8UYeBaRcThqxhUnt3vvLamwzMvGbICGj
	 J+eSodeHq7yFMATnbwL6ce4HV2T5GPo0jtJNTVnEztLOoXD7pOpZW9fo3VdWkVp9BXVdk
	 Hi4qbkzzEGL/xP3InN8K+5wZU4k1Ew50tKECJOrhjCurww0VsN3TRWrhyI7/ZIwvlHA1q
	 lkZs6iTpV4FGCIqddJUs2PWqrKVONu+cyBb09BSh1pfJsKPdIV6bfrNkA7U+ElKM3MeLh
	 3LI0cxi3g5CJoliCxWo2rzHwS9GYR/8AKlhUm1KYD+r8tRIqsiJ7xRyd5TnJFUmg49g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pY9fNADx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6CA606A332;
	Sat,  7 Nov 2026 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pY9fNADx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307021F0089F;
	Sat,  7 Nov 2026 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061135;
	bh=C1QH2QTIYcL6houoiPnns3oWzdNCuPl6rOXLfQcnz2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pY9fNADxYJD2bKToWLdF6uPewC0il/3uOR/iH9yifrzcP99GixL3+0zsiPXJwfoTe
	 wRn3qb2GQBeB5rO2VXo4vLfjQcapBY7p/OaZmZZA0N2zB4dTdozfoMAVHNxY+iKybL
	 22YuUEN1vqqIaYFG+wr1Ph1HWwY+6bz497OMjSw4=
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
Subject: [PATCH 6.12 0444/1536] ocfs2: publish the filecheck owner before adding sysfs attributes
Date: Sat,  7 Nov 2026 08:41:00 -0500
Message-ID: <20261107135010.015215094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -179,17 +179,20 @@ int ocfs2_filecheck_create_sysfs(struct
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
 


