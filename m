Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015592;
	b=DlGCHKZk89vwfpeh8BAcxDPjYugyEbMmJhK7FMizG+0SbbiC7hY/ByxzJmBLx16vMRuU
	 +r7qNn+zRhZjgbpEhwm2/HjiO1V5olQk4+yHLpWEFs5OBzd/PKMfb7jkAzsVZdPa9JvJY
	 wQXnV+sndJoCb47H1EQconXgVaVkPnF/5WWS6J1n+SZDUZlxLPxT10rug2GKvOTnLvoVX
	 PRlqZDYEHLR73zSv07KSd/BruxNh1qBwSJmxfnVdv3Rw6G8cGGUUzbtdR2mlnlHevBsh9
	 u9OUoNuEePlGMamFeD2c/veJgfx8tTPJ5XE6aevmR7QAQ4Q246zYt3M2DJNIIq7TvuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xi7oomV8ngr20tsSVBLvhE8NlyWOcQLTBqix3BLsaJU=;
	b=ijvo5EyrF87tt1MvGlnxRiwtqDALR3tiEGl6hSIVoLfAoAFv74tA6g431IY8vGCG6uzK
	 YeN0/YQCRw0slZK7AT3rmmN/PU6F13mnTm9Slm2dfR7bm/TrMfV9iA9qwOfe8+7a7X565
	 WZsOiDFTThwtf+0fYiqNJHBVG6BapaOOlMtkhgSwFg/oeNj3afqHMfFxOFgyCz2EFZkbc
	 FXkllsaM1ee1rAd9JXT6f3ATVt0Z9FN0dURlygSdhyZ8ndjCsgSlT/p9gbfQwK/Nt/W2i
	 1C36mshlMQXNL0PTV7f91i2Oc7pnw/kQFxABtF2BeWTwP4xko/PZ9RlfF8EtU+1nrIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvSTXu1Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC229606A31C;
	Wed, 18 Nov 2026 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvSTXu1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1C11F000C4;
	Wed, 18 Nov 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015592;
	bh=xi7oomV8ngr20tsSVBLvhE8NlyWOcQLTBqix3BLsaJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvSTXu1QotT/I5ogEkE58h2kcIMbnd6jZXNh46rM2djzhhwfMf3Utlr87V/YhhPoH
	 7eMGIB7tBNqtJ0YRNDE4PouoBzbQe1CPMTP99pxSLk866XAkJ7TfRTKDml7iEbOkdt
	 sZ07YoFnPxUQuA/vCPk8e4ujOd+ybDCClFrP7QZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0228/2651] mtd: rawnand: sunxi: use a stack buffer for BBM randomization
Date: Wed, 18 Nov 2026 15:24:28 +0100
Message-ID: <20261118150256.074373502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit a8596bb7148136b9e83980900d508d0ef86507ef ]

Variable protected user-data lengths replaced the original four-byte
stack buffer with a heap allocation before compensating the bad block
marker. The allocation is unchecked, and a zero length returns
ZERO_SIZE_PTR which sunxi_nfc_randomize_bbm() dereferences.

The controller supports at most 32 protected user-data bytes per ECC
step, so use a zero-initialized buffer of that bounded size. This
removes the allocation failure path and keeps zero-sized invalid layouts
from dereferencing ZERO_SIZE_PTR.

Fixes: 54dcd6aa69db ("mtd: rawnand: sunxi: introduce maximize variable user data length")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 88503a45fe81a..f41feebe42571 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -222,6 +222,7 @@
  * USER_DATA_LEN registers.
  */
 #define USER_DATA_SZ 4
+#define SUNXI_NFC_MAX_USER_DATA_SZ 32
 
 /**
  * struct sunxi_nand_chip_sel - stores information related to NAND Chip Select
@@ -1003,11 +1004,10 @@ static void sunxi_nfc_hw_ecc_set_prot_oob_bytes(struct nand_chip *nand,
 	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
 	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
 	unsigned int user_data_sz = sunxi_nfc_user_data_sz(sunxi_nand, step);
-	u8 *user_data = NULL;
+	u8 user_data[SUNXI_NFC_MAX_USER_DATA_SZ] = {};
 
 	/* Randomize the Bad Block Marker. */
 	if (bbm && (nand->options & NAND_NEED_SCRAMBLING)) {
-		user_data = kmalloc(user_data_sz, GFP_KERNEL);
 		memcpy(user_data, oob, user_data_sz);
 		sunxi_nfc_randomize_bbm(nand, page, user_data);
 		oob = user_data;
@@ -1040,7 +1040,6 @@ static void sunxi_nfc_hw_ecc_set_prot_oob_bytes(struct nand_chip *nand,
 		}
 	}
 
-	kfree(user_data);
 }
 
 static void sunxi_nfc_hw_ecc_update_stats(struct nand_chip *nand,
-- 
2.53.0



