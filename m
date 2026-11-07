Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065189;
	b=Aoyxa6g39/KWrmQnBcEROboEl6JLqnT4EyarAatTZHLZVp+I8Mj6Zwv4Fneruks957sy
	 AvbMOQKRPX9NUQJxxmaIHIMUtzc5wazaNbxp3JovCNzQuKhDKjtPmP1vXV03LKoj4knoK
	 CDBCWzpm5SgIfN4YDkmkeVJt3dPEDskC9LxTExUVvM6FZi2uTaQflFGnWHCbOQXW2S0u3
	 n6ZO/If4SDyf8ztibTiVPMKIek/dECaVIxtMBOHHXhxKfOiDx0X6/Rc4+xb5oVz1mCViV
	 b7MP6skaFnHqndywgzKzqeMfBwSX/ColLsAzhNSGgUW9PGXu51MQa12Xd1CN5Mhc24A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cGpB+CfvhAxbzM2V7xUhdtuepvPNAOnmEUHZsnJ7IwY=;
	b=kOfcbztS4DWbowM8P0PzDx/nWeXUu4acMFNpl5YfhKZS7iGUBzOH6Td8IbN9jfd3XG3v
	 GgOHRmQwcOsAmNPdqzXF3qjHDJyk8CKQnOKqbYcItQC5MebmHc+d1OupzaynmOkTrACX1
	 cTVzYbVwTjh5RopGne53ZgqZ2/boxRpn6hDEJ+RdmigfaUy0Ml5r7rphhE5lNy6Mz4xFu
	 04bRl6gkEDlwuEug5Hoyi2ky+T4YrZi1vWtxzvcUBQzQbAKS8kWy+f1VUlvplMy6llLc6
	 yZyeCcSd7ZKw5+6QZntrLakYlwJi/r9KB2O0HEaIS52yMERukajxKOZ6Qjo31QjrAqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXRJjYgz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8055F606A33A;
	Sat,  7 Nov 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXRJjYgz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB81F008A1;
	Sat,  7 Nov 2026 15:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065189;
	bh=cGpB+CfvhAxbzM2V7xUhdtuepvPNAOnmEUHZsnJ7IwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXRJjYgzagdiY5IxScPPAxMl8o48+bHHTfaiyxubZvbWXXwVB/s0+jGHpphMHDrsJ
	 Gipfv71OXIpZl8hpTwwnbzVfgnTSnS1xQCmlJuNAJVdSewefK7ezlU9xbWgX3YL2iD
	 wzD3Y7xsQHt3sUi5G7d6RkRDlV8X2qXTZPThn4Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0992/1257] exfat: fix reading a directory whose FAT chain is longer than its size
Date: Sat,  7 Nov 2026 08:54:48 -0500
Message-ID: <20261107135006.763427852@linuxfoundation.org>
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

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit 8534eb11ac056dc2ca08007cf76d3ae7cbe42684 ]

Commit 08cf4a8181b4 ("exfat: use exfat_chain_advance helper") made the
directory code walk the clusters of a directory with
exfat_chain_advance().

However, exfat_chain_advance() returns -EIO once it has walked as many
clusters as the size of the directory says. The FAT chain of a directory
can be longer than that, because some cameras stop updating the size,
see commit 1e5654de0f51 ("exfat: handle wrong stream entry size in
exfat_readdir()"). As of now, opening such a directory fails with EIO as
soon as the chain is two clusters longer than the size. Reading a
directory that has a FAT chain after a seek past its end fails with EIO
too.

The issue can be reproduced with an image in which the size of a
directory with 200 files and 7 clusters is lowered to 2 clusters:

    mount -o loop exfat.img /mnt
    ls /mnt/d | wc -l

Before commit 08cf4a8181b4 ("exfat: use exfat_chain_advance helper"),
the result is:

    200

After that commit, ls fails with "Input/output error" and the result is:

    0

This patch will make exfat_chain_advance() follow the FAT to its end
when the directory has a FAT chain, as the code did before, and keep the
size check for a directory without one.

Fixes: 08cf4a8181b4 ("exfat: use exfat_chain_advance helper")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Reviewed-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/exfat_fs.h | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 249aa59288631..dd6734632bb23 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -679,19 +679,29 @@ static inline int exfat_chain_advance(struct super_block *sb,
 		struct exfat_chain *chain, unsigned int step)
 {
 	unsigned int clu = chain->dir;
+	unsigned int i;
 
-	if (unlikely(chain->size < step))
-		return -EIO;
+	if (chain->flags == ALLOC_NO_FAT_CHAIN) {
+		if (unlikely(chain->size < step))
+			return -EIO;
 
-	if (exfat_cluster_walk(sb, &clu, step, chain->flags))
-		return -EIO;
+		chain->size -= step;
+		chain->dir = chain->size ? clu + step : EXFAT_EOF_CLUSTER;
+		return 0;
+	}
 
-	chain->size -= step;
+	/*
+	 * Only the FAT tells where a chain of this kind ends. The size can be
+	 * smaller than the chain, see commit 1e5654de0f51 ("exfat: handle
+	 * wrong stream entry size in exfat_readdir()").
+	 */
+	for (i = 0; i < step && clu != EXFAT_EOF_CLUSTER; i++) {
+		if (exfat_get_next_cluster(sb, &clu))
+			return -EIO;
+	}
 
-	if (chain->size == 0 && chain->flags == ALLOC_NO_FAT_CHAIN)
-		chain->dir = EXFAT_EOF_CLUSTER;
-	else
-		chain->dir = clu;
+	chain->size -= min(chain->size, step);
+	chain->dir = clu;
 
 	return 0;
 }
-- 
2.53.0



