Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C00A26B09D;
	Thu, 13 Feb 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458736; cv=none; b=NZsl+S0YAwFaxspXRpWLoLnhDyjUt0+f8Xy8tYjfeSRbSSbdVs1A9YTzoDBd3yp7xbXDAeiat7X1pYS16t4EKgVvIICJbTHvj3Lr9upQQof+2uyvrn2ecweMuvVcqNE8Zi5UzDfQSWUHev6lKCMNYbheecYUS+pv801l7fp4o7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458736; c=relaxed/simple;
	bh=/lKYNp5rxiglYPl44Q32rg+JilVtrz+UN5ilMpXbRNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y53tOlM/V2cOZ9PjPhCQh3t3sgn/TYc7/o28CvaDKgmGGesr6kyXh8eINLM7uaSziVeUKtqhtdtOu43A04VGlO5lc5pF3W83eEtGh4z6eovG+K02Lz6VtEIkRITVyNQWtJW9s0Nu5Ft2Ts9D5LzNcS1ItujFRMZf978QwPJFWzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+FwzN35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+FwzN35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7BBC4CED1;
	Thu, 13 Feb 2025 14:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458735;
	bh=/lKYNp5rxiglYPl44Q32rg+JilVtrz+UN5ilMpXbRNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+FwzN35XEr3Td9PARPrVtykHEpuY3X2r8SXbbp1u8R07f8rec7W9twd63qtKWo44
	 wXOtV3LZ03/lFSovVp6gDnevBidFrN2d7Bp/KR7bb8r3/nfROydVDszYLeml9Uau4X
	 +Zr39CgQJl0EHF0ZviTkL324p9ZuJxscXHALnOoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 062/443] wifi: rtw88: add __packed attribute to efuse layout struct
Date: Thu, 13 Feb 2025 15:23:47 +0100
Message-ID: <20250213142443.013846860@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 0daa521a1c8c29ffbefe6530f0d276e74e2749d0 ]

The layout struct of efuse should not do address alignment by compiler.
Otherwise it leads unexpected layout and size for certain arch suc as arm.
In x86-64, the results are identical before and after this patch.

Also adjust bit-field to prevent over adjacent byte to avoid warning:
  rtw88/rtw8822b.h:66:1: note: offset of packed bit-field `res2` has changed in GCC 4.4
   66 | } __packed;
      | ^

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412120131.qk0x6OhE-lkp@intel.com/
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241212054203.135046-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.h     | 4 ++--
 drivers/net/wireless/realtek/rtw88/rtw8723x.h | 8 ++++----
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 9 +++++----
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 9 +++++----
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 9 +++++----
 5 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index cd09fb6f7b8b3..65c7acea41aff 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -510,12 +510,12 @@ struct rtw_5g_txpwr_idx {
 	struct rtw_5g_vht_ns_pwr_idx_diff vht_2s_diff;
 	struct rtw_5g_vht_ns_pwr_idx_diff vht_3s_diff;
 	struct rtw_5g_vht_ns_pwr_idx_diff vht_4s_diff;
-};
+} __packed;
 
 struct rtw_txpwr_idx {
 	struct rtw_2g_txpwr_idx pwr_idx_2g;
 	struct rtw_5g_txpwr_idx pwr_idx_5g;
-};
+} __packed;
 
 struct rtw_channel_params {
 	u8 center_chan;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723x.h b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
index e93bfce994bf8..a99af527c92cf 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723x.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723x.h
@@ -47,7 +47,7 @@ struct rtw8723xe_efuse {
 	u8 device_id[2];
 	u8 sub_vendor_id[2];
 	u8 sub_device_id[2];
-};
+} __packed;
 
 struct rtw8723xu_efuse {
 	u8 res4[48];                    /* 0xd0 */
@@ -56,12 +56,12 @@ struct rtw8723xu_efuse {
 	u8 usb_option;                  /* 0x104 */
 	u8 res5[2];			/* 0x105 */
 	u8 mac_addr[ETH_ALEN];          /* 0x107 */
-};
+} __packed;
 
 struct rtw8723xs_efuse {
 	u8 res4[0x4a];			/* 0xd0 */
 	u8 mac_addr[ETH_ALEN];		/* 0x11a */
-};
+} __packed;
 
 struct rtw8723x_efuse {
 	__le16 rtl_id;
@@ -96,7 +96,7 @@ struct rtw8723x_efuse {
 		struct rtw8723xu_efuse u;
 		struct rtw8723xs_efuse s;
 	};
-};
+} __packed;
 
 #define RTW8723X_IQK_ADDA_REG_NUM	16
 #define RTW8723X_IQK_MAC8_REG_NUM	3
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 7a33ebd612eda..954e93c8020d8 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -27,7 +27,7 @@ struct rtw8821cu_efuse {
 	u8 res11[0xcf];
 	u8 package_type;		/* 0x1fb */
 	u8 res12[0x4];
-};
+} __packed;
 
 struct rtw8821ce_efuse {
 	u8 mac_addr[ETH_ALEN];		/* 0xd0 */
@@ -47,7 +47,8 @@ struct rtw8821ce_efuse {
 	u8 ltr_en:1;
 	u8 res1:2;
 	u8 obff:2;
-	u8 res2:3;
+	u8 res2_1:1;
+	u8 res2_2:2;
 	u8 obff_cap:2;
 	u8 res3:4;
 	u8 res4[3];
@@ -63,7 +64,7 @@ struct rtw8821ce_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8821cs_efuse {
 	u8 res4[0x4a];			/* 0xd0 */
@@ -101,7 +102,7 @@ struct rtw8821c_efuse {
 		struct rtw8821cu_efuse u;
 		struct rtw8821cs_efuse s;
 	};
-};
+} __packed;
 
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 0514958fb57c3..9fca9ba67c90f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -27,7 +27,7 @@ struct rtw8822bu_efuse {
 	u8 res11[0xcf];
 	u8 package_type;		/* 0x1fb */
 	u8 res12[0x4];
-};
+} __packed;
 
 struct rtw8822be_efuse {
 	u8 mac_addr[ETH_ALEN];		/* 0xd0 */
@@ -47,7 +47,8 @@ struct rtw8822be_efuse {
 	u8 ltr_en:1;
 	u8 res1:2;
 	u8 obff:2;
-	u8 res2:3;
+	u8 res2_1:1;
+	u8 res2_2:2;
 	u8 obff_cap:2;
 	u8 res3:4;
 	u8 res4[3];
@@ -63,7 +64,7 @@ struct rtw8822be_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8822bs_efuse {
 	u8 res4[0x4a];			/* 0xd0 */
@@ -103,7 +104,7 @@ struct rtw8822b_efuse {
 		struct rtw8822bu_efuse u;
 		struct rtw8822bs_efuse s;
 	};
-};
+} __packed;
 
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index e2b383d633cd2..fc62b67a15f21 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -14,7 +14,7 @@ struct rtw8822cu_efuse {
 	u8 res1[3];
 	u8 mac_addr[ETH_ALEN];		/* 0x157 */
 	u8 res2[0x3d];
-};
+} __packed;
 
 struct rtw8822cs_efuse {
 	u8 res0[0x4a];			/* 0x120 */
@@ -39,7 +39,8 @@ struct rtw8822ce_efuse {
 	u8 ltr_en:1;
 	u8 res1:2;
 	u8 obff:2;
-	u8 res2:3;
+	u8 res2_1:1;
+	u8 res2_2:2;
 	u8 obff_cap:2;
 	u8 res3:4;
 	u8 class_code[3];
@@ -55,7 +56,7 @@ struct rtw8822ce_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8822c_efuse {
 	__le16 rtl_id;
@@ -102,7 +103,7 @@ struct rtw8822c_efuse {
 		struct rtw8822cu_efuse u;
 		struct rtw8822cs_efuse s;
 	};
-};
+} __packed;
 
 enum rtw8822c_dpk_agc_phase {
 	RTW_DPK_GAIN_CHECK,
-- 
2.39.5



