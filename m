Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86CE355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301087; cv=none; b=XORekQouG76tOJgDMfZYHb/1n9xHf5MrhEiSlaqRfHET3GQB+FZoq2QemVfmB54/wcYFiA+c2wVgKNLZwwbbfkZoPBQkHwHtz6YSinqjwL+4xKNfVMAWMtpgTdST1IjPBSkj3kgtX6zMPuzm+gOPEvrHbezdfVLe2ads5sGjIro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301087; c=relaxed/simple;
	bh=516uH4ifNL/k6dYRkwoKsB4PZ75vOD6AfEOV0kcGgPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAq1GfIVq8/wSAI7OxPMVLXQexJ5Z14CoHSdnnXJNr/C/cpCv3jjVgi711SWUSFKU/ZP5XMszSekXZL4UA8PrtKaPQHeRqIh/ndplEDw/LejH0CpdKgD/W0FzdFNZs1b3swhrR4pwUvYnVmiWW+kzI6IWA+rr91PBNiuFoU8tFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoX4e6jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoX4e6jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A630C19425;
	Sat, 28 Feb 2026 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301087;
	bh=516uH4ifNL/k6dYRkwoKsB4PZ75vOD6AfEOV0kcGgPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoX4e6jqzdd8STTu7jF7iEQa1HTl3EjPVLZK4F29C/WP6AsYAX5BqOYDWbrWro3IU
	 fGnW6BytSl6KQme6IPPclOrUNzGUvEsEx4khnHq3tb2z7jm0ghRIlTqHJzIJ8apxvy
	 PW+yy1zi5+ewRWiJb1AAjYdBd/E7qLu01i0/71HtgUhCoDwTjtF5AP8Sn1ycHzZ277
	 ikhIPnUZi/3NaYDFVJfB8ZI93GT1yZ1P/rGpJrYWv23beb/DWc09nIgbPg/zZX2jns
	 /6f2wxBfPfBOuu2o4/FTJaX2BnQCiCHMtOuEnmgntr6cddxW/t6xElcz6Lzp9il/uc
	 H0OEXSJCo9YzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 237/752] wifi: rtw89: disable EHT protocol by chip capabilities
Date: Sat, 28 Feb 2026 12:39:08 -0500
Message-ID: <20260228174750.1542406-237-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 7fd36ffedeedc97c44a10249a3f12d471bb2dc26 ]

For certain chip models, EHT protocol is disabled, and driver must follow
the capabilities. Otherwise, chips become unusable.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260110022019.2254969-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 drivers/net/wireless/realtek/rtw89/core.h | 1 +
 drivers/net/wireless/realtek/rtw89/fw.h   | 4 ++++
 drivers/net/wireless/realtek/rtw89/mac.c  | 5 +++++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index ed6018f54f20a..018857d3569a8 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -5111,7 +5111,7 @@ static void rtw89_init_eht_cap(struct rtw89_dev *rtwdev,
 	u8 val, val_mcs13;
 	int sts = 8;
 
-	if (chip->chip_gen == RTW89_CHIP_AX)
+	if (chip->chip_gen == RTW89_CHIP_AX || hal->no_eht)
 		return;
 
 	if (hal->no_mcs_12_13)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 928c8c84c9644..c3839d49f4420 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4996,6 +4996,7 @@ struct rtw89_hal {
 	bool support_cckpd;
 	bool support_igi;
 	bool no_mcs_12_13;
+	bool no_eht;
 
 	atomic_t roc_chanctx_idx;
 	u8 roc_link_index;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index ddebf79720687..47e5cbec306d2 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -42,6 +42,10 @@ struct rtw89_c2hreg_phycap {
 #define RTW89_C2HREG_PHYCAP_W0_BW GENMASK(31, 24)
 #define RTW89_C2HREG_PHYCAP_W1_TX_NSS GENMASK(7, 0)
 #define RTW89_C2HREG_PHYCAP_W1_PROT GENMASK(15, 8)
+#define RTW89_C2HREG_PHYCAP_W1_PROT_11N 1
+#define RTW89_C2HREG_PHYCAP_W1_PROT_11AC 2
+#define RTW89_C2HREG_PHYCAP_W1_PROT_11AX 3
+#define RTW89_C2HREG_PHYCAP_W1_PROT_11BE 4
 #define RTW89_C2HREG_PHYCAP_W1_NIC GENMASK(23, 16)
 #define RTW89_C2HREG_PHYCAP_W1_WL_FUNC GENMASK(31, 24)
 #define RTW89_C2HREG_PHYCAP_W2_HW_TYPE GENMASK(7, 0)
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index df429bdef7956..71194ea68bcee 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -2999,6 +2999,7 @@ static int rtw89_mac_setup_phycap_part0(struct rtw89_dev *rtwdev)
 	struct rtw89_efuse *efuse = &rtwdev->efuse;
 	struct rtw89_mac_c2h_info c2h_info = {};
 	struct rtw89_hal *hal = &rtwdev->hal;
+	u8 protocol;
 	u8 tx_nss;
 	u8 rx_nss;
 	u8 tx_ant;
@@ -3046,6 +3047,10 @@ static int rtw89_mac_setup_phycap_part0(struct rtw89_dev *rtwdev)
 	rtw89_debug(rtwdev, RTW89_DBG_FW, "TX path diversity=%d\n", hal->tx_path_diversity);
 	rtw89_debug(rtwdev, RTW89_DBG_FW, "Antenna diversity=%d\n", hal->ant_diversity);
 
+	protocol = u32_get_bits(phycap->w1, RTW89_C2HREG_PHYCAP_W1_PROT);
+	if (protocol < RTW89_C2HREG_PHYCAP_W1_PROT_11BE)
+		hal->no_eht = true;
+
 	return 0;
 }
 
-- 
2.51.0

