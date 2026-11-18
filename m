Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045758;
	b=odg4/I3ynZdyPm+6GPgOdDxAF2VvGbz0XlNcGG6pJLnP4A4YxGBqpRPrbrtQmS/DyYQQ
	 FSiM5WaE9TQjauq2PYhsd30BGKWYa9M4ZbQ8u0y3aT1UIsEY1mp4ptZtrzeHudbEwWqfL
	 lBTpk5pzFuCb5NFH/oEfAbcoO6+3h5ZC4FK7sw39cI84bkIeA/t/rhKu+C5TqRPuKiqBD
	 Z2yum5gILkLsSbV3lGaE/FDT81wwNarGN3FfNgVXM2tWBDqtD+/vUWhlq5engaaopxRCG
	 xJfVSCo75ltcVP6VZaXWFQoGbtrtHE53gqjsbJX3ITfI7Y8aABqr0Men/SHsXb5gE2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vG4Cm0BqKfKQ7kpIoE6CgqZHt2XQ609gUvI9GqR0zXM=;
	b=ziH8Y8Cp8ImcCGuIAVs0L6tlvOkB7fESln3lpIv4va6kvIUEnR+PNWlkbIZaOWWeuDxE
	 9f77JV7zS+gG8KMPW3S7idJ5FU79dIaAQbhXdBYyE/62kWex65tBOraK/NR4FJ/6f6Vgp
	 zeUzvX86Vdi6cFL0WjzfVG+h49R5v13uuTkNL2Y6eQwHd1cYkileXigyZslWJhHRM/cn3
	 1sDME/xIQhujqpmLbrHnk6C8pChUFtNmWNWYDf7KhNrPP2wQ5xIF+hZByR7LTn1/z4gK9
	 6x1EiTYZ46rT5Saw7EidS6yI86a1MyNJ25Eg54/cA+y8AfkO4VapaKhrb1VAVl2RDmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/tlv138";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD4E606A32C;
	Wed, 18 Nov 2026 23:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/tlv138
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9952E1F000C6;
	Wed, 18 Nov 2026 23:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045758;
	bh=vG4Cm0BqKfKQ7kpIoE6CgqZHt2XQ609gUvI9GqR0zXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/tlv138AQRhNmsAeycZ4hd9rOI1/z7/akqvcR+jFSR8QJ9PYN4ppGPJaA2sGk8Ro
	 NCSOFJTJiM5OZ2ucjGOdvvIwuqbi4ckkxQ0yQFIhqfEt+Wu1GiOYzoD27Ku7eFJyXF
	 0vw2U3/syPF0bDFzexrwm/ZouOTNop2lTqgnTQjU=
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
Subject: [PATCH 6.1 1039/2857] ocfs2: snapshot the dentry name while tracing file release
Date: Wed, 18 Nov 2026 15:34:33 +0100
Message-ID: <20261118150239.007788663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 571d7d34965bb..b6074d6ef0908 100644
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



