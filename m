Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062556;
	b=TFj8npe7CXlCV+B9h0PxIlV7t7DcCp2lgYO/YPRHinq+XacrRe9Ld3m6XDdL1ybAfTTu
	 epZZzx3nd+wNf3lJcHFYVTF2eI7XXTUqbh+PQ5jEJWt5hMX0yqxBH4POgBpWcxao8H8nl
	 r+w5bRKJL0jo7vWm77YFxxcHpagHIuYmjz6FttKIBfb71Io32RQTQkJ9DS5Ac49z3ROLa
	 OBVcG1FIxe8iiygmi2lwq5sRwq7/rd+TZAojxOEC3+Ynp+SbrVOsjge576j1RSZlGMT6T
	 aP86d0PbLFNH+yu/hh0+YDEK9ZXWutKCDa3ljHCpX790o4cOvbJ7oZ5Od1t73964tsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5F2VFIVPN3YxdpRWQyBXDylD1yy1/iRagEkV81zgyU=;
	b=ybHkSen57nkEx2xIh6c/xHjnV7zHnKrhC5yZy7nhXwPgHUFjLXXKa3FC1iasdqdaNIHV
	 8H8NuKD1klu47g+frdQFwZZ7uPyEZTwzcA8oANgy2oOiO4Wi5uakBTAT8vzKyfAR0PD3b
	 KxxIr91Wj7gowPBc+xSfnZoiPJdvEVi63GGNWy4utLU6Q2BnFBGtLBOwWJp1gtNCe5n2/
	 62tiAgCDqVkR43VeJRA7NZeeoEDEVd7WTN6Pwvq1SOfgk4c/YggvLeIENnMyYDnnCBJcI
	 8d4OuIuWv07E058vETgHIVoz9o2zXKn+PXf0HoiH1lmUUyyUPpxsc5cEctH9J3MLOIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iV14GUXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2A5606A645;
	Sat,  7 Nov 2026 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iV14GUXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E8A1F008A1;
	Sat,  7 Nov 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062555;
	bh=T5F2VFIVPN3YxdpRWQyBXDylD1yy1/iRagEkV81zgyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iV14GUXYgEodQr+CIG/twa//YcRJMnHb6VJlpqq84MnSA3iFmCbrh6UvwGh58nc0Q
	 BTCXXjI6aB1sqUAs+g0RJapL2rBGRLsiTAqLvKw/kGLIeCMIjnuRMdQ0pkyimzHMOI
	 Hwu5RFtNt6aNYfcQ+yCtidvVj2dGhRkCkFrr3ZM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1404/1536] writeback: reset dirtied_when when switching wbs
Date: Sat,  7 Nov 2026 08:57:00 -0500
Message-ID: <20261107135037.259202493@linuxfoundation.org>
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
index 48ac4f58605e7..925fc4a42c67d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -455,12 +455,12 @@ static bool inode_do_switch_wbs(struct inode *inode,
 		if (inode->i_state & I_DIRTY_ALL) {
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
index 19211eb49a8c0..67b57ce46b203 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -719,7 +719,9 @@ struct inode {
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



