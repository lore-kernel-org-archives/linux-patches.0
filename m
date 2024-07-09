Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE55156238;
	Tue,  9 Jul 2024 11:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524107; cv=none; b=ql/1E0g3e38jC7/hOPVT3xZ5wFhBGhcDwFD5E/f6Qd4lWjYL5WzqXuqH0t9/btyTDpCG5H52zplsCJtIaf0A9i54hd9+A1yeg8Z8wFz9/pIo6XiEKL4zBvtJo7WoINSiK2fakPTwqlMcDuhut6AUe1hJuw9hiqThPCsQC9DMA9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524107; c=relaxed/simple;
	bh=xW+WAKkCUssFOOcSGR6DTpjp3AbdEIxU9dRpayKcIDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEHtpZtgN6ztvCTFSmF9FhQ+ipbHwiJBVNDvp/+++070HDuBVqciYqDfY+Z+OplCsDMuLQ1cNlvQ3Fh75OVUj3ZSZatKHRzICC6iIlfV5W5YE2ZGnvSRagloQam27G5MzaQ3FrDbID3FR0n+HnV1YM6y4cW4Pmijan8St8+N1WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOiBO9qH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOiBO9qH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E50C4AF0A;
	Tue,  9 Jul 2024 11:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524107;
	bh=xW+WAKkCUssFOOcSGR6DTpjp3AbdEIxU9dRpayKcIDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOiBO9qHmWROvXfw7BtJzd0B6yfFuTIOeGf0F99pTv0qkKYUUr3syyybEiepu/1B9
	 HR8pWGGM3uSpT/0z3fd0N085tfiB3DFawx1zox09Xlg1VznjmjSgRfEeGox4DATYDT
	 tMHGh776e5BuxQty6r4ZSgKDfF6v+RQeLTe9iRcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 073/197] s390/pkey: Use kfree_sensitive() to fix Coccinelle warnings
Date: Tue,  9 Jul 2024 13:08:47 +0200
Message-ID: <20240709110711.793278307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jules Irenge <jbi.octave@gmail.com>

[ Upstream commit 22e6824622e8a8889df0f8fc4ed5aea0e702a694 ]

Replace memzero_explicit() and kfree() with kfree_sensitive() to fix
warnings reported by Coccinelle:

WARNING opportunity for kfree_sensitive/kvfree_sensitive (line 1506)
WARNING opportunity for kfree_sensitive/kvfree_sensitive (line 1643)
WARNING opportunity for kfree_sensitive/kvfree_sensitive (line 1770)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Link: https://lore.kernel.org/r/ZjqZkNi_JUJu73Rg@octinomon.home
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index dccf664a3d957..933894065623e 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1503,8 +1503,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_keyblob2pkey(kkey, ktp.keylen, ktp.protkey.protkey,
 				       &ktp.protkey.len, &ktp.protkey.type);
 		pr_debug("%s pkey_keyblob2pkey()=%d\n", __func__, rc);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc)
 			break;
 		if (copy_to_user(utp, &ktp, sizeof(ktp)))
@@ -1640,8 +1639,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 					&ktp.protkey.type);
 		pr_debug("%s pkey_keyblob2pkey2()=%d\n", __func__, rc);
 		kfree(apqns);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc)
 			break;
 		if (copy_to_user(utp, &ktp, sizeof(ktp)))
@@ -1767,8 +1765,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 					protkey, &protkeylen, &ktp.pkeytype);
 		pr_debug("%s pkey_keyblob2pkey3()=%d\n", __func__, rc);
 		kfree(apqns);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc) {
 			kfree(protkey);
 			break;
-- 
2.43.0



