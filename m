Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065208;
	b=Q+pwoksq53NFSX8t5xhnWz8M7spsjHombIhvDzATzWEigBEENDpgNFs242PFpTXFpoK5
	 6Lf5BTeMEumw2iEjTkxcYW5XbgTGnDKzTr4iM4FCXOXPDaBDIZ64ULzqm+aqXUzL5x+hU
	 PZhpd02ZwEU3rwnAlAsrF6GDDEHqw1nSXNTr+CWax7QM0BQyBoedsO89il2LZM40RoAhZ
	 3pjNqi3UB/QSdoTkWpjEsWVq/uXuFQaBnxVjLF772IdIgFDFJnuJ42AFglR+fCTn9JZPl
	 kjIHiRqiN0hOGQtlRRIVW7g4UCc5LqINuGVkAJ/KOfQ9fG5RONxNdjctnTMUtgVJNNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sIriHDtCEJNV3ruR8lPbp1mB+mwffC+DXNkhpXsfvW0=;
	b=JC8rWXZXVUmj2kxs3b9OtoUSOvjyS8nl8QkQnfH7iKOguNjQXAwE+fghHLyx+efbI81L
	 0VdzAM6jtuaBastOPguEOrbooSfHmkQJnWXxwBGuw+AuPQrQPc9u7x8zROynXQauyxZWO
	 je7Eb2zyMdwFgLw71R9FCZeJZbqVP4Yf+ogPOyU2N7dMAh+0sh5dqtWKljF5Zuo+N8CBy
	 f1tYlz+1sGzZoE27d7Fn8svvcTtc4bUOUd7YSL2xCiSq9bEeNvTBXuDuWjB2fzLw5nS6d
	 bVLn+eaJH/MEK7BgrASjQdh6JmVYb8AQVTYmZvcdpOXRU4S+paUgMAcFn+nM+pjrufw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pmehUgAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D693D606A335;
	Sat,  7 Nov 2026 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pmehUgAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8437F1F0089F;
	Sat,  7 Nov 2026 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065207;
	bh=sIriHDtCEJNV3ruR8lPbp1mB+mwffC+DXNkhpXsfvW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pmehUgAG2vTbutaWBWmf7jtFJKNOPhFZdcmy9bzbhJAjJXhFRXobIxQewEJTpXg1L
	 Cw2VJ6G4fQbyDGci6fmjWLq17vPnIxbV7Duicc+GZgB47aPGPzT7kcmWHsu2aMZdSf
	 33328e6Hn8hn9aTPRjF/AcvCKy0pKrh93p9RflXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1004/1257] writeback: reset dirtied_when when switching wbs
Date: Sat,  7 Nov 2026 08:55:00 -0500
Message-ID: <20261107135007.076043643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 13b9a606dd0a6cf9bac12894c97b9546d22a7425 ]

When switching a dirty inode to another wb, inode_do_switch_wbs() puts
it at the newest end of the target b_dirty list instead of searching
for its sorted position. This requires updating dirtied_when, which
move_expired_inodes() uses to decide where to stop scanning.

However, the switch updates dirtied_time_when instead. This leaves
b_dirty out of order and can make the scan stop before reaching older
inodes. It also resets the lazytime expiration timestamp, potentially
delaying timestamp writeback.

Update dirtied_when instead, preserving both the constant-time insertion
and the lazytime expiration timestamp. Correct the field name in the
comment and document the distinction between the two inode timestamps.

Fixes: 9a6ebbdbd412 ("writeback: Avoid excessively long inode switching times")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-2-sunjunchao@bytedance.com
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c  | 6 +++---
 include/linux/fs.h | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ea3eb40bf828e..430cf3da58805 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -468,12 +468,12 @@ static bool inode_do_switch_wbs(struct inode *inode,
 		if (inode_state_read(inode) & I_DIRTY_ALL) {
 			/*
 			 * We need to keep b_dirty list sorted by
-			 * dirtied_time_when. However properly sorting the
+			 * dirtied_when. However properly sorting the
 			 * inode in the list gets too expensive when switching
 			 * many inodes. So just attach inode at the end of the
-			 * dirty list and clobber the dirtied_time_when.
+			 * dirty list and clobber the dirtied_when.
 			 */
-			inode->dirtied_time_when = jiffies;
+			inode->dirtied_when = jiffies;
 			inode_io_list_move_locked(inode, new_wb,
 						  &new_wb->b_dirty);
 		} else {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index deb411e866617..f155984f5bd04 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -815,7 +815,9 @@ struct inode {
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
-	unsigned long		dirtied_when;	/* jiffies of first dirtying */
+	/* Timestamp for writeback list ordering and age checks (jiffies). */
+	unsigned long		dirtied_when;
+	/* Start time for deciding when lazytime updates need writeback (jiffies). */
 	unsigned long		dirtied_time_when;
 
 	struct hlist_node	i_hash;
-- 
2.53.0



