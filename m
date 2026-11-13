Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591436;
	b=K24T4TKmJ3PglU+k09zVskPOINARSLTTG3guvLoewG+3oHSA6j9KRoJuq3D9om2gvzJE
	 7MwJKQCgFewSAlDEbvfs9Ac9580Y07BypJvr0DfTzG1N4rn9VKJikqWN6wZ8n6gSz9bUn
	 F0Y3ZkXTK5uYBNCpjzzE6h1wXY1+mS52eutFmbkruUF0hYdZbxRkA8VFQcr6U6aiNwf7N
	 /c62PLe3H0Kyh59NYox1woxLJcayKbG92ff6KfPCPqn7jUpFLuNQQmhJoX3hHr+wJG+DE
	 DP3Y/1kZN1nRXHCUKPNPi5J+4kbOyboBxLwKDZxMXhGsiBZkLcjz2E+JI6zrOwr0QGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XVrvlQu3rc6LlbY37EWzACD9ZMbL92KFZsvoCj3IsY4=;
	b=Kw/q+24DDI9O4OGNL/YxZLINBpn5gGDa3PKF7ogMlvCq1ex0pWFFCdncMwbieseDZpHA
	 31wNuG5spTBDwv0x5bQZRyAJfuJw/FhpWA9gaNJUNhXrD6qMT5RqVLlaTaAQGzrCIs2gG
	 g6hlqTToieYa7c2+KJ+OdV9bpVfi/K5Ua4KJ6T3GdAvfVnGKRbLEAGQ1JF4KP9P86b3CT
	 kSwZj7cn0k323QUrEsZ4pTJo5WIsAluXXHHUXXer9XuJZhXDyLv35NvYDnEnmAyEpi2FV
	 j3TxcAtLBUakx6IlNdQh1Jq/QcXYmrFIQQEHS92HjxWUju5D5tDrgWECK83ttVVrPWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oD78eP5F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F5607B5B1;
	Fri, 13 Nov 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oD78eP5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B4D1F000C4;
	Fri, 13 Nov 2026 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591435;
	bh=XVrvlQu3rc6LlbY37EWzACD9ZMbL92KFZsvoCj3IsY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oD78eP5FRscYkssZ0gIZH3fEUgFIfx3nDLCgQIuw7N7JL2kL6OLMJ5PrnqYUzD/rO
	 yhJlLpsG6TBx/Van689r39GLFEPbrACB/j8HWSfEVE8iEXHF/KvM3fcOwNJ6I+bCEN
	 jdQKeduDwM3l4/1TVrtYF/rWN04PI7nLY8VjGnZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 528/670] f2fs: return -EIO for a lost inode block after cp_error
Date: Fri, 13 Nov 2026 10:51:32 -0500
Message-ID: <20261113153829.812886780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8a11623dbf1ef..963adcf00e910 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -785,8 +785,20 @@ int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
 	if (!npage[0]) {
 		npage[0] = f2fs_get_node_page(sbi, nids[0]);
-		if (IS_ERR(npage[0]))
-			return PTR_ERR(npage[0]);
+		if (IS_ERR(npage[0])) {
+			err = PTR_ERR(npage[0]);
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
 	}
 
 	/* if inline_data is set, should not report any block indices */
-- 
2.53.0



