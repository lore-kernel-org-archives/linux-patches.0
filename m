Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063618;
	b=HnkmQwqlw9Dd0RDclOwFMdPzhCvdun99lu8bHgFFgR/DxBCSHRsyUwSxYViaOm+/VNK7
	 0TM24H4r5s1JcHTP9IY8htf2tjKFDzDY9LBpK7hOc/DSG1hfRa0AOYMs1TDkQZ2pnbLQL
	 EeK1+TTm5VQzvC8XEM95Qj9PqbgdiPFWjkWSbbWYd1IFr+qxOyxLCKiVbKV3dggx/fXBY
	 F0L1uCl2bUH4vSvxXxuxeeLlnwVMT9cYEKvgtsTdWt4Qb091qaTyks/eu3dOe2fKShvnV
	 gD3FFn+rT0wABcFLDtdTfiwbxT1U9flCOD2WniwD47DFvlU+FsDkyOvG3132GOn7vjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fx129RlOmHSTufruCZG1EylyBFbstFKckSocW/tAoBA=;
	b=1ZhpD3fwBiv9rglc0GlvKvg8hnoxwlDeyaTZIrUsxP46i6QYt+KJ6Kp6mclfHF4hmmkI
	 Hk4G9W/y8bfCl1LVS1ThmJ5U7d9Qd7NNH6FMCFQWVlNz/arIOoDx0+6NYu8GWqVVQSa/3
	 S8ysb7tCBo5/oa/ZREXGIM9JkbeoHpQB+KWzroaWjCQdRbw+k7y7BOjGOIZexmTAxCzep
	 cLjvke+KZj1N/f2qddXGU8aXC+Qx/PFkzOTih7OTfiQchWBBW+lq1T6/SsXy6Z5YZvU9f
	 QbLH0ScmeHrJ0gBhtEA5k+KOpEIHJhsZuSDcNMITiJggapMBJbDuDd2cFhV/egXtv4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddZOVfyE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87942606EE9F;
	Sat,  7 Nov 2026 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddZOVfyE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7201F0089F;
	Sat,  7 Nov 2026 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063618;
	bh=Fx129RlOmHSTufruCZG1EylyBFbstFKckSocW/tAoBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddZOVfyEzZ0ZnVQ9hVbSBqbPENChk2gJgy0ZiWNBMBCiPZ1nKIREkoTYHcwFttwEG
	 6oOKfkT76/yjmJrL59i+4OTm5w/dBQ4bTNpSQ8I3cFH+ABiZLSKIFE+Roli9ax6jg3
	 grn44u/0P84VYWiqnm1XzdZT/mUDQU8WyMYxnc9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 739/869] ocfs2: snapshot the dentry name while tracing file release
Date: Sat,  7 Nov 2026 08:57:01 -0500
Message-ID: <20261107134917.878332254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

[ Upstream commit 5898987d4a92b70ae73fd8355cc3a388b4dfa4e6 ]

ocfs2_file_release() passes the live dentry name and length to a trace
event while holding oi->ip_lock. This lock protects the open count and
delays RCU reclamation of external names, but it does not serialize name
changes during rename. The dentry can switch between inline and external
names, and a separately loaded length can describe a different name.

The ocfs2__file_ops event sizes and copies its __string separately.
A concurrently rewritten inline name need not remain consistent between
those operations. External names can also be selected at this call site;
the existing spinlock critical section protects their allocation lifetime,
while a snapshot additionally pairs a stable name with its length.

Take a name snapshot before acquiring oi->ip_lock and release it after
dropping the lock. Keep the trace call and open-count argument inside
the original critical section. Cache the event-enabled check so the
snapshot stays paired even if tracing is toggled meanwhile.

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-2@gmail.com
Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a0df92a23498a..f4c36ce1678d0 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -140,18 +140,26 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 static int ocfs2_file_release(struct inode *inode, struct file *file)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct dentry *dentry = file->f_path.dentry;
+	struct name_snapshot name;
+	bool trace_enabled = trace_ocfs2_file_release_enabled();
+
+	if (trace_enabled)
+		take_dentry_name_snapshot(&name, dentry);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
 		oi->ip_flags &= ~OCFS2_INODE_OPEN_DIRECT;
 
-	trace_ocfs2_file_release(inode, file, file->f_path.dentry,
-				 oi->ip_blkno,
-				 file->f_path.dentry->d_name.len,
-				 file->f_path.dentry->d_name.name,
-				 oi->ip_open_count);
+	if (trace_enabled)
+		trace_ocfs2_file_release(inode, file, dentry,
+					 oi->ip_blkno, name.name.len,
+					 name.name.name, oi->ip_open_count);
 	spin_unlock(&oi->ip_lock);
 
+	if (trace_enabled)
+		release_dentry_name_snapshot(&name);
+
 	ocfs2_free_file_private(inode, file);
 
 	return 0;
-- 
2.53.0



