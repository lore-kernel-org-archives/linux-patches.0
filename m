Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829655;
	b=UkniVl2jDvtj4BNyJ4FYui634om8d2S3mGk6Tn7pcbc41NbBxDUg3g01QseVUru6zG87
	 IK5d+yEvoah6Xu/TX22OlFX/zcC0rDQzCxzAtNY7CqZ2VIfT/ONkTPGWOG/cLaQYWA8GT
	 efWYIi3U9rT1uH4/n5Kj5c4/oll7MNfXLjLYdi+Q3fwxz75kX9rH7IyrV6FM4gwIZc7y8
	 HxWTh95xCJ9lUdc3gQfEvIgWzFHVV59MZpDzapAujALr3b17h8NnEqXDCd1BZ2Zv1YS4B
	 m2gfDtXAbKTlZkKhmBT13q0cqi3uFSS/S4iDNbjPWQtvCUlpw/jLPQqKoNlJn2/uqwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R3W0O23KDPcMRA3+klcwaiCb72oO0URXnS+WI79VeJI=;
	b=nn9C9OJu9D4PeswgqD69cxR1vCc8xd+hW5uvTRMBhStNogn5KqmXPsOuw+PHDSVy2jIA
	 dEDj9oGNI2c/DO6yKVloS7jbJ8jc1wOG5iDxuMRiJZfLf70ztTPW+O0lJVo6T1aU3OBVK
	 UfkXZqNi271fZBC4QZbjJAtyWZo5KE3wYCodLQHvC0t83GWTcPQo9kHu5j47+2hX5nyA7
	 g6DGyn2woHJHJqeMhO46O0CnbjWV9Hcj7f7laDHrpxq2f3hg5ax43PpCX3W66nVKRvdax
	 YtQvKwUsThMC7wjweQVfuiazplUfSySEUy46SXf2hyrafLVUDNMkeWUy50LIdQP4SaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJDadaiM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24430606AC15;
	Wed,  4 Nov 2026 22:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJDadaiM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB0C1F00A18;
	Wed,  4 Nov 2026 22:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829655;
	bh=R3W0O23KDPcMRA3+klcwaiCb72oO0URXnS+WI79VeJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJDadaiMU2qA8zresdLliokRcJA3pSJbjbSUBYSRfaSdupA5cLM/8Ye7XKHvXrNqL
	 gkc3VnUWKfcZ1NM3aEP0WJocABU9QK7/IJK31lxHxldzb5HUEpAv53/aTyFwLTSovT
	 0HvIYSG8JYv60m5wN2IhhONm89RMtoM03LwUXvo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0258/1005] exfat: write moved entry before removing source
Date: Wed,  4 Nov 2026 15:59:51 -0500
Message-ID: <20261104211051.097101215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 896fcc93574fd511ee04a4110e8ea59d6d8d43d7 ]

exfat_move_file() removes the old directory entry before the new entry
has been written.  If writing the new entry fails, rename returns an
error after the source entry has already been marked deleted.

Write the new entry first, then remove the old entry and update the
cached inode location.  This keeps the source entry intact if creating
the destination entry fails.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 6b544df0a03a6..06bed867b46ad 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1156,11 +1156,6 @@ static int exfat_move_file(struct inode *parent_inode,
 	exfat_init_ext_entry(&new_es, num_new_entries, p_uniname,
 			     &mov_es, num_extra_entries);
 
-	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE, false);
-
-	ei->dir = newdir;
-	ei->entry = newentry;
-
 	ret = exfat_put_dentry_set(&new_es, IS_DIRSYNC(parent_inode));
 	if (ret) {
 		/* Best-effort delete to avoid duplicate entries */
@@ -1174,6 +1169,11 @@ static int exfat_move_file(struct inode *parent_inode,
 		goto put_mov_es;
 	}
 
+	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE, false);
+
+	ei->dir = newdir;
+	ei->entry = newentry;
+
 	return exfat_put_dentry_set(&mov_es, IS_DIRSYNC(parent_inode));
 
 put_mov_es:
-- 
2.53.0



