Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048406;
	b=gGPQHGzWKChtGgE1HRBfb20gfqKO5efq+4Xbd5XgQZAjS0bJUwp3FyKTrZbz56m5BeOh
	 2dMgF/hViEM8YRMRLdiklTyGbQMq0olz/+peH9TSdf5QFUWZ42PvCh4l9GNycW6wuEH62
	 J8pPL4NaD3tKmdIQKpelWXllFUaKs7rhwHj3ZLdD2+wr6RMCtn78Ek6bBvJDqIpkv6RXq
	 PJ8bG8WCsTXcf4NrKnr4H3mkUyiswAgq4tidfOTw4i2cHuQNdLPXD+IW2Y9eO0OAtia+k
	 tHj9MvH5+n3pgoDk16pDa6ryJ8LwK9yz0bX2N1ktbt3aZuC4gj6Rj1zXF0uR3A5osBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+eNN6S2et2cTnZVhhCBQh0YyfuXDBaQYPrIhvNeKV7I=;
	b=T+3pW5aWtFA3/KboU0G/uyGgfQjhpO5yE9dHXjpgoWRlRz2Fu9qfNi7LPz9XNi/IfFVe
	 i3sBxp+UK/WOZuAj1G3faUyiYBmgWh30jBFnPAjO4WkE5eqfNDzNRd/w9q9Mqm9Dh3NM4
	 8DKB2r/6HO1Q14lV5bWvgf1AQDfxRAfpKm+RjdvLB8lHBlbK9+gvFFxAsnDA/XbomEfCs
	 vUJOQ9uGg9UK0Ft5MAtFi2jQZHnA3s3r+9rdnZHMAVfQKdJs8R1Q55FSHpZZWtfrcvea3
	 XMLNBqH6p3Krb1BqJNp738d7tHNyEyXZMaa8CP1kxNJZab2uufch1XdNK6aeYxB3WtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2ANvVrW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C6E606A325;
	Thu, 19 Nov 2026 00:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2ANvVrW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF13C1F000C4;
	Thu, 19 Nov 2026 00:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048406;
	bh=+eNN6S2et2cTnZVhhCBQh0YyfuXDBaQYPrIhvNeKV7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2ANvVrWj5+dx1EjkJeZ/PdksTGGUouoVn2ejMYeunHOQudcNOiZbNM9cmUbHktEd
	 /E1EvCo3BQ0yEQD3KCBGT5xjOoXvAKHQpoRPf+6PKKpcNm5U+MoKqZY64CIo0ODUoE
	 OiCfgEl84kdjsVkGbPKrcxEXIW9Svrlem6rERt0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1982/2857] fs/ntfs3: validate $SDH entry size in ntfs_insert_security
Date: Wed, 18 Nov 2026 15:50:16 +0100
Message-ID: <20261118150312.747670431@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 5b76487f94dacc2884135ce9a7bda61ce7ffa209 ]

ntfs_insert_security() walks the $Secure::$SDH index and reads
e->sec_hdr.size for every entry returned by indx_find()/indx_find_sort().
Those only guarantee the NTFS_DE envelope (e->size), so a crafted $SDH
entry shorter than a full NTFS_DE_SDH at the tail of an index buffer makes
the read of e->sec_hdr.size run past the allocation. Triggerable by an
unprivileged setxattr(2) on a crafted NTFS image.

  BUG: KASAN: slab-out-of-bounds in ntfs_insert_security (fs/ntfs3/fsntfs.c:2148)
  Read of size 4 at addr ffff88800fa1de00 by task exploit/142
   ntfs_insert_security (fs/ntfs3/fsntfs.c:2148)
   ntfs_setxattr (fs/ntfs3/xattr.c:947)
   __vfs_setxattr (fs/xattr.c:223)
   __vfs_setxattr_noperm (fs/xattr.c:257)
   vfs_setxattr (fs/xattr.c:344)
   filename_setxattr (fs/xattr.c:690)
   path_setxattrat (fs/xattr.c:734)
   __x64_sys_setxattr (fs/xattr.c:764)
   [...]
  The buggy address is located 0 bytes to the right of
   allocated 512-byte region [ffff88800fa1dc00, ffff88800fa1de00)

Stop the scan when an entry is too small to hold a SECURITY_HDR.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 781a7f53f5ddb..0f73bb07c6dd5 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2127,6 +2127,9 @@ int ntfs_insert_security(struct ntfs_sb_info *sbi,
 		goto out;
 
 	while (e) {
+		if (le16_to_cpu(e->de.size) < SIZEOF_SDH_DIRENTRY)
+			break;
+
 		if (le32_to_cpu(e->sec_hdr.size) == new_sec_size) {
 			err = ntfs_read_run_nb(sbi, &ni->file.run,
 					       le64_to_cpu(e->sec_hdr.off),
-- 
2.53.0



