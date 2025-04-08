Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4947E267F6C;
	Tue,  8 Apr 2025 11:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110361; cv=none; b=HAaqmiK+MGrQ0pBe4vJp/QJ+9rKtFlQe4g/5160ra+A5awnmR36jVwmrSE4TboAztn1w280vj6yY3uhrAyB59rRieQwPWQBkeTa0WBcNW45BERUAxY0cnRCFeMPwnkhrDKZ6UWblXpIK7DNeAA/YYIpCjW+FwTHxo2E+AFrEVUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110361; c=relaxed/simple;
	bh=VDgPDM1mdONIYJwtnjfJr8Anf4xlknYva0+9HHyuGUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZ+e/Jb/gmwTpa8Ug0lAPHaJ7K/Qz+Pl5f946AQRJBfGklxVtqn4XxbwskjYiDrZFuy1ug/M/Ei3v8Csn4xKnb3IvGIeAW3qe3XcHwIUCvwTWpYqllJNJGZQEVQtIFfgvhCOGSgWWo20AQG0PwaFTs9g121Tq22hs+sAqKqNMH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNYZK40c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNYZK40c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF753C4CEE5;
	Tue,  8 Apr 2025 11:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110361;
	bh=VDgPDM1mdONIYJwtnjfJr8Anf4xlknYva0+9HHyuGUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNYZK40cNHX9H+eQdVxkXKWBiQOyBg/gMeZ2KuxQyHYEyp2XYcGo1JO468CIuB7Sb
	 p5m7hQss3iNS7wZA/xYt3q31Ie4PgEbQBEs0odDCnOUTUPRfweTcfcJ6zMIN26u3WQ
	 E3vjMfUB47SrgDG49uiUd8lsIz3PBY/9vmD0oFQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Gary Wang <gary.c.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 034/731] EDAC/ie31200: Fix the DIMM size mask for several SoCs
Date: Tue,  8 Apr 2025 12:38:51 +0200
Message-ID: <20250408104915.065907895@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 3427befbbca6b19fe0e37f91d66ce5221de70bf1 ]

The DIMM size mask for {Sky, Kaby, Coffee} Lake is not bits{7:0},
but bits{5:0}. Fix it.

Fixes: 953dee9bbd24 ("EDAC, ie31200_edac: Add Skylake support")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Gary Wang <gary.c.wang@intel.com>
Link: https://lore.kernel.org/r/20250310011411.31685-3-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ie31200_edac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index c3d34d1fc9ad7..da4008c22f0d3 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -165,6 +165,7 @@
 #define IE31200_MAD_DIMM_0_OFFSET		0x5004
 #define IE31200_MAD_DIMM_0_OFFSET_SKL		0x500C
 #define IE31200_MAD_DIMM_SIZE			GENMASK_ULL(7, 0)
+#define IE31200_MAD_DIMM_SIZE_SKL		GENMASK_ULL(5, 0)
 #define IE31200_MAD_DIMM_A_RANK			BIT(17)
 #define IE31200_MAD_DIMM_A_RANK_SHIFT		17
 #define IE31200_MAD_DIMM_A_RANK_SKL		BIT(10)
@@ -378,7 +379,7 @@ static void __iomem *ie31200_map_mchbar(struct pci_dev *pdev)
 static void __skl_populate_dimm_info(struct dimm_data *dd, u32 addr_decode,
 				     int chan)
 {
-	dd->size = (addr_decode >> (chan << 4)) & IE31200_MAD_DIMM_SIZE;
+	dd->size = (addr_decode >> (chan << 4)) & IE31200_MAD_DIMM_SIZE_SKL;
 	dd->dual_rank = (addr_decode & (IE31200_MAD_DIMM_A_RANK_SKL << (chan << 4))) ? 1 : 0;
 	dd->x16_width = ((addr_decode & (IE31200_MAD_DIMM_A_WIDTH_SKL << (chan << 4))) >>
 				(IE31200_MAD_DIMM_A_WIDTH_SKL_SHIFT + (chan << 4)));
-- 
2.39.5



