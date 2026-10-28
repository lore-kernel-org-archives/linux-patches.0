Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213414;
	b=MUOAfjSebN+DuGl9NzlyP6EQEqaHJxlkDKqco6A5QOUaqMlAx4nPgmyQwXzHeDi5kFbb
	 6aufPtLG2lImnkcF3ciLxVuG3fa+zN4q56OoNF/Eox1hQcdFBOhyoH158hAPNcHzqo3wB
	 VUVM3Z6DpcwYRZz5fWgI2Q2Q0x4G2FPJC5tP5Vf9fvoP0/Et0lRetJtPAQvygo162mxPn
	 YL0UJFUUBIpyoMuCXSlTPBP+xJnQFFfDFEuAnd5eeL+NQlcva6InLoItgJwW6BH1hT++A
	 UG/O9v3fizlA325gFIpjfKn11DHxIA1KtIfJsi1M6kYoYBHjCOlznEQB2NthgdayZSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhV8ZhRBlHLhmquwd1lUSYQDaIaBnjr1TCFOAKZEPI4=;
	b=esU69W8V3pDleCYg4lGL5KBhsYicyu47WOWaAJLejdRTMqzLuv1K/rL9xpJ77DexRcPR
	 7d2CBpLbFKgRe0FG9Z0fTGw5/GWfgKyTZmiUy/ttMEC1iFyYSA2H0iKGBWg0nqhSvFlkI
	 oHVbIrMuUR+k51OONsPoX05kTyxilFzDbsOIJkgyRCeE2vsyK6oEXRJbc2JbUR8n79y7/
	 BCKUsaz3XOZurww7qVsNUOijG5YECBZpXFHZt0o6kv2uL3nypdArJcEz9MUE41HWi0SUe
	 tWTn8alZVaAbJrAg0uuoFUGbyc9qFIriFeNvJY+e25onqJpBetqY0Sj87zv89p64Kbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbqvhFBg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2DB606A31A;
	Wed, 28 Oct 2026 18:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MbqvhFBg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2945E1F01825;
	Wed, 28 Oct 2026 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213413;
	bh=zhV8ZhRBlHLhmquwd1lUSYQDaIaBnjr1TCFOAKZEPI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbqvhFBgk3yQS5++PRQVWV8WU1sDAyZJTBwAsBRN4mSQe8FFSomtv/0D4mD3K9Cof
	 k+7Yjoh0zrhEF3bFdpNiC/pJ0H1UG/mLnoUtE2eI5zsfPPLausyMwcut4ei9HEXloS
	 2tKq9UGeXEtPAWAXrkee4Pb6M5Mf6UEHXfQljO0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomas.winkler@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0498/1887] mtd: Clean refcounting with MTD_PARTITIONED_MASTER
Date: Wed, 28 Oct 2026 17:43:14 +0100
Message-ID: <20261028170510.621969547@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 264725e35fbc3b67e053a405e022393a6017e6da upstream.

The logic is way too convoluted, let's clean the kref_get/put section to
clarify what this block does when using CONFIG_MTD_PARTITIONED_MASTER:
- Iterate through all the parent mtd devices
- Grab a reference over them all but the master
- Only grab the master whith CONFIG_MTD_PARTITIONED_MASTER
Same logic must apply in the put path, otherwise it would be broken.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Fixes: 19bfa9ebebb5 ("mtd: use refcount to prevent corruption")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/linux-mtd/20230731090903.770277-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1221,14 +1221,15 @@ int __get_mtd_device(struct mtd_info *mt
 		return -ENODEV;
 	}
 
-	kref_get(&mtd->refcnt);
-
-	while (mtd->parent) {
-		if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER) || mtd->parent != master)
-			kref_get(&mtd->parent->refcnt);
+	while (mtd) {
+		if (mtd != master)
+			kref_get(&mtd->refcnt);
 		mtd = mtd->parent;
 	}
 
+	if (IS_ENABLED(CONFIG_MTD_PARTITIONED_MASTER))
+		kref_get(&master->refcnt);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__get_mtd_device);
@@ -1312,10 +1313,12 @@ void __put_mtd_device(struct mtd_info *m
 {
 	struct mtd_info *master = mtd_get_master(mtd);
 
-	while (mtd != master) {
+	while (mtd) {
+		/* kref_put() can relese mtd, so keep a reference mtd->parent */
 		struct mtd_info *parent = mtd->parent;
 
-		kref_put(&mtd->refcnt, mtd_device_release);
+		if (mtd != master)
+			kref_put(&mtd->refcnt, mtd_device_release);
 		mtd = parent;
 	}
 


