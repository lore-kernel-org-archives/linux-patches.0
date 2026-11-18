Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036886;
	b=LfqCkb53WM3mcx/FU72claj1hWX2EitxIxOUSKVgqgRw+M1kGX/Cp/bbuo77WC3fgaiK
	 +fYNikisYSJO8L3lvimkSVtYoEC+goW2KLverVM8Lfd5Zw3PgfaY4DLoH0rGEFZx54bhf
	 g+oeXNrtWKJ862ktHtA49U2JWCqZ+upsAqximUPdBqvXG4sDTX6vD/90Wj76KSrtn29Zq
	 xnkBFKNYKxpvByXPva8ERS3vkDO5JKbC9kotDwwGKgDZ8hI4zMnAFD9RcbkRijgwcEn/g
	 U2mxAcd53tbYcFvuP8JmNwNg6ScI1/od1Ty5Y/y/jdaFbyEnpNJPVr3cfsmhFrErDLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nLzVChnSeWR2k7uJGzj5zcYJ6312cpeRKeNDYL/TS14=;
	b=kID4n7StnsJUdt6DkGJpIs0bkiBwF0SMxqu5EY3OWL6Afs+VyFX9vSJKqJc2NZFxUenX
	 Eh77JPl6nAsMwpn++u/NF7AnbnbK/OdcVSUz0ciuh35bEI2AAIw7lpzWyM6BaqIoYwUkE
	 tM16uZlEaOUH/zBf53msAqa9B+stE9dHb7y5Yxvfur43FH1052eCCliS2cuOo68/bvyuR
	 3inw8m7FutgRF+D1uFIglR6CO6ozExzHJf9IZZYK6QDbBNzMnLqHZ+eACXJisfiPGm3tu
	 kpvogWnIheeCPxe8il2Hs/Zzng7CeRr8zeR9FUIbXUuipeTp6feWKaKRuNVyFUTK0YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=beyxNrkt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3C7606A32C;
	Wed, 18 Nov 2026 21:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=beyxNrkt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C191F000C7;
	Wed, 18 Nov 2026 21:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036886;
	bh=nLzVChnSeWR2k7uJGzj5zcYJ6312cpeRKeNDYL/TS14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beyxNrktpNn4rm/Hik4Y/WCKhDuIVpaiQC8aMscvAQ7erwFm/3NJZKV1/1faAmoYc
	 0Yi4ry1KeNWkNZofDdwBsvqbuZsZTFsc7L+1E37apLa382ELXvvYG5MlRaHiP8qCGt
	 0bFuALzxVZ2Dy8O+bKfBO0d37hEoHT2ir8b0fi+o=
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
Subject: [PATCH 6.6 1218/3318] ocfs2: snapshot the dentry name while tracing file release
Date: Wed, 18 Nov 2026 15:30:40 +0100
Message-ID: <20261118150356.719839949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9923da367100a..850b5462dfbba 100644
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



