Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015589;
	b=1FI/5Bm32fYn9LME0sVtVjQoes43l94Tzy20cV/f3Wh2HN1ZE94xmEADD8KNFL1ggymS
	 PoYsTNlrHCQhzIYKelV51kyJC1+qITbsZcxCtZ8bTSRwUDlwU0xxb5VDKuQZFlx/fE7DH
	 G93+l5QZg2tDqr+KylMfYC7QAMo/AYmgLHXWZSQyAxdnUVcR+ZUYdxqlWt62NkOWQJeJO
	 X5B99VTZem3kcL7Q/csJh5Q1SvwuXg3f2p0wtsl4EIS94AUTTsEIVHcycPsPxjXo+FyEP
	 He2no6D53C/96DG6R/sVVj8CfOpx/cbec7GHLe4dxkERAuBryzsoHSA3jje6KAR6FeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t+3vVG4Ae08S4saNATkzYTBgyUgNQTRLN0uCNqZdsyI=;
	b=JwCeZ+6efiS2Xe84mJ1B5gIpKNQ9TnGMJd43ItMITmpJpnmL+ANHobgLFeZuB4JQ22a9
	 LYiPdXAe9iLEziURABRs5MYxqQ8kVJEWp0GlxhINnXUvB9rcLYrsxyg2d2MMbgEPVUoMn
	 DSwHp7g+KE+/6BIOI3GZntf8rfaYBETthrTwj3ku56zVaYnCy3t2PszaXpMsPxJISY30g
	 3szsSJUoXGvi9mBCIXi60izsoyITNENZvAFkG3I71UtmOfqtn4iMpOl/6f4AOsn4jBzla
	 xVb6DufsuG1G7pHV5he4x6QkJDlEkxaVkicpRal3C441q1IfJKzvvy5jSUQFT181JiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXn0VnBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90D8606A31C;
	Wed, 18 Nov 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXn0VnBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228BD1F000C4;
	Wed, 18 Nov 2026 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015589;
	bh=t+3vVG4Ae08S4saNATkzYTBgyUgNQTRLN0uCNqZdsyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXn0VnBpJ4dno5SAKd4CQM7vr3xRH9qj2IjwG2TOvVtKYzfU2PIVC4YWQps4a9ceO
	 x02KrQA05v3oswCDbGrI8WP33+NHgtVkKM7U6JE22QnS7nMEAvDiJ+qO4VtTZBc4+T
	 tRa90Ylu1Q1OXme59ABRHbJzwHZAFRFVBDQQsbu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0227/2651] mtd: rawnand: sunxi: reserve a full user-data word for BBM
Date: Wed, 18 Nov 2026 15:24:27 +0100
Message-ID: <20261118150256.037749246@linuxfoundation.org>
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

[ Upstream commit bde8fd880d84627072c224729c818306c4b30d58 ]

H6/H616 protected user-data lengths are encoded in four-byte units,
but ECC maximization reserves only the two bad block marker bytes. A
strength leaving fewer than four bytes therefore selects a zero-byte
first user-data section.

The OOB layout then subtracts the two marker bytes from that unsigned
zero length, and the controller has no protected user-data word in which
to store the marker.

Reserve one complete user-data word while maximizing ECC, reject
configurations which produce no ECC sectors or a shorter first section,
and make the OOB iterator bounds-safe.

Fixes: 54dcd6aa69db ("mtd: rawnand: sunxi: introduce maximize variable user data length")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 5c4c027071a07..88503a45fe81a 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1991,7 +1991,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	struct nand_chip *nand = mtd_to_nand(mtd);
 	struct nand_ecc_ctrl *ecc = &nand->ecc;
 	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
-	unsigned int user_data_sz = sunxi_nfc_user_data_sz(sunxi_nand, section);
+	unsigned int user_data_sz;
 
 	/*
 	 * The controller does not provide access to OOB bytes
@@ -2000,6 +2000,8 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	if (section >= ecc->steps)
 		return -ERANGE;
 
+	user_data_sz = sunxi_nfc_user_data_sz(sunxi_nand, section);
+
 	/*
 	 * The first 2 bytes are used for BB markers, hence we
 	 * only have user_data_sz - 2 bytes available in the first user data
@@ -2007,7 +2009,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	 */
 	if (section == 0) {
 		oobregion->offset = 2;
-		oobregion->length = user_data_sz - 2;
+		oobregion->length = user_data_sz > 2 ? user_data_sz - 2 : 0;
 
 		return 0;
 	}
@@ -2041,6 +2043,9 @@ static int sunxi_nfc_maximize_user_data(struct nand_chip *nand, uint32_t oobsize
 	int remaining_bytes = oobsize - (ecc_bytes * nsectors);
 	int i, step;
 
+	if (nsectors <= 0)
+		return -EINVAL;
+
 	sunxi_nand->user_data_bytes = devm_kzalloc(nfc->dev, nsectors,
 						   GFP_KERNEL);
 	if (!sunxi_nand->user_data_bytes)
@@ -2056,6 +2061,8 @@ static int sunxi_nfc_maximize_user_data(struct nand_chip *nand, uint32_t oobsize
 		if (sunxi_nand->user_data_bytes[step] == 0)
 			break;
 	}
+	if (sunxi_nand->user_data_bytes[0] < USER_DATA_SZ)
+		return -EINVAL;
 
 	return 0;
 }
@@ -2106,10 +2113,10 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 			bytes -= total_user_data_sz;
 		} else {
 			/*
-			 * remove at least the BBM size before computing the
-			 * max ECC
+			 * User-data lengths are encoded in four-byte units. Reserve
+			 * the first word because it contains the two BBM bytes.
 			 */
-			bytes -= 2;
+			bytes -= USER_DATA_SZ;
 		}
 
 		/*
-- 
2.53.0



