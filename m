Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590651;
	b=FS41S810gaFhUHjTHpmyv3RYuWMWE6nVwHsNNpcMaeWRPFcYxNyGv7U6BBINlUJDi8An
	 FgHiVA008CSmHhPvuFGczeRoduSmHtJG+CeOXWXDXjIPnhHrtKWanrKf2WDtAXqyQdjjO
	 bJ87M6eeTmI2HcHKlbKrdb/DsgZQqcuphr+UojTfFgDRQrJYCY9xn2LEKAcdFhVAMdgJD
	 zan1aALVotVESTlCMb5qLxcTJTQqCGtwb+f94vQx4nnFYzL1KhpVhWLHZZYcAXkjWEYi0
	 74a2SryGBa6RP9PGKpjsZbTfO14+mgTZeVQCwOd1B8KRXUZyBLjkbHEQ1eXsRti5+pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M7FJvo8V9GfMHuK5giqckpkuP29OkV49Ker7mv6Dmxo=;
	b=aliUw0oGL7/BEBrf+TOmwz1ACCwZUqgzP22XhslTqT+FahTGVUdFqRYRqKyvU8rBHMwt
	 /dhyHqCUlRtQ05sPxmb3EiNc3wWHDXSOz8tZz90TERHsJFNOrVFHeGjsK4KYzZ3mX7FuV
	 rgoFf9p9hNr/jEA72AG12vitIBj6Om9khEB1Jg+T5HUGdFt/AjW0s2QeiSxBnW5rqjhmS
	 R3CQ+KG+FYDZqLlcD38pzHt8qAhpDWKEcGsxVGRhyOINaJ9BQUfc3OnPSUn1QnlzxVx1J
	 38K6/fLB88pgNdwKwmqyQRWriWu6Xowuprez6WoBn3Xi56vz/XtsJfgyrQM7jejr6Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z33VK9px;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5C4606B20A;
	Fri, 13 Nov 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z33VK9px
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B991F000C6;
	Fri, 13 Nov 2026 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590650;
	bh=M7FJvo8V9GfMHuK5giqckpkuP29OkV49Ker7mv6Dmxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z33VK9pxEzVOZG/2kgZDa7EzQaMF+eOv38l3Mvu0SfgbE1ti18p1KLbWWNIP+Jjn5
	 ylxlJOLt8DnC+9BKHbp5ptqumMnPFf+QEvrTz8h2ycCpb6nC8V5Qy2WYanfvK/Jfb1
	 ssOHMfKFllm9bxwSj4H5PjdwrcL0iZvzPusfMg0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 571/686] f2fs: return -EIO for a lost inode block after cp_error
Date: Fri, 13 Nov 2026 10:51:44 -0500
Message-ID: <20261113153841.012883296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 53b12b63304b34a3850a901c4de3cc6ad08e0aee ]

After cp_error, dirty node caches are dropped without being written.
If such an inode was never written, its NAT entry is still NEW_ADDR,
and reading its inode block returns -ENOENT.

f2fs_get_dnode_of_data() passes that -ENOENT up, and callers take it
as a hole. Since the inode block is missing, the next offset can only
advance one block, so fiemap walks block by block up to maxbytes,
about 2^30 blocks, while holding the inode lock. It took hours in a
power-off recovery test after shutdown and blocked unlink and umount
on the file.

Return -EIO instead of -ENOENT when the inode block itself is missing
after cp_error or shutdown. A missing direct or indirect node is still
reported as -ENOENT.

Cc: stable@kernel.org
Fixes: 28607bf3aa6f ("f2fs: drop dirty node pages when cp is in error status")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted inode cache access to folio-based access using f2fs_get_inode_folio() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1b67184df3dd6..010f94963ea7d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -811,8 +811,20 @@ int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
 	if (!dn->inode_folio) {
 		nfolio[0] = f2fs_get_inode_folio(sbi, nids[0]);
-		if (IS_ERR(nfolio[0]))
-			return PTR_ERR(nfolio[0]);
+		if (IS_ERR(nfolio[0])) {
+			err = PTR_ERR(nfolio[0]);
+			/*
+			 * cp_error drops dirty node caches, so the inode block
+			 * of an inode that was never written reads as NEW_ADDR
+			 * and returns -ENOENT. It is not a hole; the inode is
+			 * gone. Callers treat -ENOENT as a hole and keep
+			 * looking block by block (e.g. fiemap up to maxbytes).
+			 */
+			if (err == -ENOENT && (f2fs_cp_error(sbi) ||
+					is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)))
+				err = -EIO;
+			return err;
+		}
 	} else {
 		nfolio[0] = dn->inode_folio;
 	}
-- 
2.53.0



