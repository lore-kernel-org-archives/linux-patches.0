Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065373;
	b=t4XLU2UmMwOOKPfLu7ZLFlwHXF+o+0KFN7yKSJAcWfo7T42pTL5JSmZ1L0TetF0JxWX+
	 xK94fZ7ez1cKgRJ5/O0oX5xNBvToyl2F4F3HjClfAr6AKCbh+WNT0oLKq5vKtY9oW77ZL
	 LLKak5vZG4diIsWxBEgofzZho2fPmFGefN2gaHlrZKZGU/hlyZRTT5TI+auMdPlxuo0ku
	 8wUjcwB2oznRuq1nPZHWrha4PENicvPKB3eetPBGv9zJ7dvmHY4r1mCbm9pLjohtYfz5N
	 B6f/2Rmh+YWbYjcpEmu+jKXeT4qGb/cl8ywKl1VkIVoQu4K7Hok2y4LypvTDe3vyLJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fu/0E2EfElhQ/Idc7RhQfX1vyGQG0kt7xPOsfM7EXvk=;
	b=PmDvDZ5zrMGSq42DAkICAr9J/s06TinIGzUNSeTIagxKf18wS+ksiHMNLUYS/LiWGYxQ
	 89Dt2fnUed+fYTFMFYwYCB7TeLFbUKYEBlc9w6WhZBTMV9c2jkSbTHkc1CxkRzJaWkYn5
	 zdf+OG/ESVjL2mnVIBQ/4LbUQsSbVj+vBEuI/Swp8EXjQWvpJUvUazQi2aokNfBrb5yF9
	 HUNlYyVwS3e2TZuFoznJh3CRfj/84IhvZXfHolVsg+zwBUp8r63ALNFsBB1R3hJaHIXSB
	 UsG6vC2r8nZtpeL3WYV/C1nXU3wn7mtZFyjvt/CA1NEPGJ2QJJsnyI3ZSrVWW6eWSlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3n9Zyax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763B7606A331;
	Sat,  7 Nov 2026 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3n9Zyax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2236B1F0089F;
	Sat,  7 Nov 2026 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065373;
	bh=Fu/0E2EfElhQ/Idc7RhQfX1vyGQG0kt7xPOsfM7EXvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3n9ZyaxbdqAR5DsWCyLaw2/y9mv09gKxg9+TzbS702JZMyGSEE7EUAGNlWAqlkbV
	 r9QbVBcECJMht2m217D5OAqI88AeEaAaks1qLjCbhMM3kx5dF/v1o29lcSS1df9sCI
	 S0/6MBt1zq5q6CwANIJvjTDhZzezuiKrqa+yffT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Alberto Garcia <berto@igalia.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1103/1257] ext4: reject encrypted inodes when block size > page size
Date: Sat,  7 Nov 2026 08:56:39 -0500
Message-ID: <20261107135009.727232083@linuxfoundation.org>
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

From: Alberto Garcia <berto@igalia.com>

[ Upstream commit a5e894bc87b76fd980075892ba77e6bdeeb5e4d0 ]

Encryption is not supported when a filesystem's block size is larger
than the page size. ext4_check_large_folio() refuses to mount a
filesystem like that if the "encrypt" feature is already enabled, and
ext4_set_context() refuses to create encrypted inodes if the feature
is enabled after mounting.

However, a corrupted or hand-crafted filesystem can still have
encrypted inodes even if the "encrypt" feature is not set, and those
inodes can be unlocked if they're using v1 policies.

Check this in __ext4_iget() and reject them as corrupted.

Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities when BS > PS")
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Alberto Garcia <berto@igalia.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/aeb8efa8beb72721fb4b13cffe6eb22c795ec33f.1790343958.git.berto@igalia.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fb0548b3355c5..6697c33d3aa33 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5671,6 +5671,12 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
+	if (IS_ENCRYPTED(inode) && sb->s_blocksize > PAGE_SIZE) {
+		ext4_error_inode(inode, function, line, 0,
+				 "encrypted inode with block size larger than page size");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 
 	ext4_set_inode_mapping_order(inode);
 
-- 
2.53.0



