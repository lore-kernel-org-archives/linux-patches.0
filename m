Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213917;
	b=IhsO93iqZ8Ov1FIrK2fRxyMRkHriGQdMDqR+G+YjodiG3sJpm+egpLPkNuip2VE8e0ee
	 Noht3VlVQekuJybqpbJXOlskd8b/VZkl/A+8t0wwqShKWDObBpH7CkA7C77IAznawGK0h
	 Og2ObNXpui4D/z5xSVULCNg6idCNw+9pFmG7NbhsfXImeB49yESU97sM03FO7zV6+mvh+
	 4p6ThdDW6cWGHCd9jPlAAjkTjmtNYbgiGi/FTAEpgBLISCesumWsTK6n8mXrD91Hu4lrO
	 lfs25OVZ2/tk/+wND2a9TOH9D3gb+KGuIn070D3LgQDsxa1xTNepEk7gxAhogijXrug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=02jdzQGFNoH1WwNJYv05tiyOki9L7DxGlRG+jkpMX+Q=;
	b=bZ9pvdhGtF4EUYNV3jh8DLo5voe6PEh5lhwYV86u7zekdxV+mCVJtbE63Jmbrk6lwyZN
	 ubatVT0Da9CaWQiilnTP3IdSk7laXJWP4wnV/2WN8K3gP1lAICU6tYMzVHSCT7jmQvDvf
	 w5lSry/EqNlGGvUZi3xoU6Og+sNI00aSS82PTOYkVBMufRFrjOMEZjBnWAKoSSTfVsPQq
	 FNz+Rk7VsqxoT/cj/nYXelxpczeguxxkYAqFwGdeM6oWWSdvBd54XFdR6UyHiQBjbdrZA
	 4Qb1V1NSYUzgBGHUM0ObR8fXRZtWBMXfVWgO8ciL5Z+ghzngLGmupjxweHhJYIaap0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYGGMO+B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71031606A31A;
	Wed, 28 Oct 2026 18:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYGGMO+B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C244E1F01825;
	Wed, 28 Oct 2026 18:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213917;
	bh=02jdzQGFNoH1WwNJYv05tiyOki9L7DxGlRG+jkpMX+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYGGMO+BSHP9bBgqfef0nDhPUkBur8XyQUQr2Jjq7pXw/br/8xeaBA3QISacVHCsH
	 gDScG9Z2Uak29uG2gG6Ix/KcLO1dVdHxUMmKLmr4VUU+jfg9vQEgpOL1iP7LpvVXrE
	 uYWew2ttKGfFjGU7ENOf7fxgBP91KToMlTXpWC8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0622/1887] fs/ntfs3: Check folio pointer for NULL
Date: Wed, 28 Oct 2026 17:45:18 +0100
Message-ID: <20261028170513.564829392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1cd6c96219c429ebcfa8e79a865277376c563803 ]

It can be NULL if bmap is called.

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index b8ac0943e9325..e38f8fac1130b 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -580,13 +580,18 @@ static noinline int ntfs_get_block_vbo(struct inode *inode, u64 vbo,
 	}
 
 	if (is_resident(ni)) {
-		ni_lock(ni);
-		err = attr_data_read_resident(ni, page);
-		ni_unlock(ni);
-
-		if (!err)
-			set_buffer_uptodate(bh);
+		bh->b_blocknr = RESIDENT_LCN;
 		bh->b_size = block_size;
+		if (!page) {
+			err = 0;
+		} else {
+			ni_lock(ni);
+			err = attr_data_read_resident(ni, page);
+			ni_unlock(ni);
+
+			if (!err)
+				set_buffer_uptodate(bh);
+		}
 		return err;
 	}
 
-- 
2.53.0



