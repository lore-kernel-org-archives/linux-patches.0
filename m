Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C803420465;
	Sat, 12 Sep 2026 09:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207053; cv=none; b=dN+ZvptlBQ5CEocyC42mEH/XaMBlJLPxVoZMoDhc8alx8Wom0ov8xZOn4aEVG7PV19v1ImAg231Dm8je88+v0YB0a9cZhnoAwuLYYBgYunhUnZN5hSJ+HbtwjP5c5fBw0y5HmoONq5bJOTRdvjtI0Ole4PvHqPHx65wIVChMNlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207053; c=relaxed/simple;
	bh=hY9k4TZT/yRTVTzORHOI3mB1Yt+peQhuxagryeb9opk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQhYtP7GGMByZ8z5V99BOP4VgOBs080zmr6HJ2dNvxXDT/YgojWjKYNCsEYSi3ZIiLdq9I0v0cLK5Om4yCFzhKUJLpRDXYcre9IkTOFM4Bkh/GTxW9/m7Zk2adCOff8dNbMMUJDtQGxkV5L6qmG2h41bCA+88D/6o0OG8aBW3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UGTs/DC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UGTs/DC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2601F000FF;
	Sat, 12 Sep 2026 09:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207051;
	bh=bnipUPcJS/BRrrOpwzS7zKH7HJYzz0foLq2e+S13aPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UGTs/DCgTsTT/3m82e8Yw2tL1ayfbhfows0FE49NsouW6mUVwlXkqvhmS1RO+Vn7
	 kl0ky5dInGQhD8upn/H5byl0DeU8prjKkJupBsnqUAj2A4nFldEFUu8dXYN7+Yk/PO
	 QH7gxG0EZIdIf8BiH6uNOD3E2OMYTYNaKmLlfQnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0334/1518] wifi: rtw89: fw: parse firmware element of DIAG_MAC
Date: Sat, 12 Sep 2026 08:41:43 +0200
Message-ID: <20260912065631.026144092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit de19cc7def5a9c646264a1e7a2a183a3baad112f ]

The firmware element ID 28 is a set of rules to diagnose if MAC get
abnormal. The latter patch will use these rules via debugfs to know
the status.

The element contains rules with their textual messages shown as below:

   +------------------------------------+
   |                                    |
   |                +-----------+       |
   |                | rule_size |-------|----------+
   +----------------+-----------+-------+ --       |
   |             rule[0]                |   \      |
   |             rule[1]                |   |  <---+
   |                :                   |   /
   +------------------------------------+ --
   | msg[0]      msg[1]                 |  each msg has variable length
   |        msg[2]    msg[3] ...        |  (with address align 2)
   | ...                                |
   +------------------------------------+

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251111022452.28093-3-pkshih@realtek.com
Stable-dep-of: 9bf6bd6ed5ac ("wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   | 15 +++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h   |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index d3531630a7023..3998a53b4ee90 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4705,6 +4705,7 @@ struct rtw89_fw_elm_info {
 	struct rtw89_phy_rfk_log_fmt *rfk_log_fmt;
 	const struct rtw89_regd_data *regd;
 	const struct rtw89_fw_element_hdr *afe;
+	const struct rtw89_fw_element_hdr *diag_mac;
 };
 
 enum rtw89_fw_mss_dev_type {
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 81cd3ea2c3b69..4191fbbc2161c 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -1299,6 +1299,18 @@ int rtw89_build_afe_pwr_seq_from_elm(struct rtw89_dev *rtwdev,
 	return 0;
 }
 
+static
+int rtw89_recognize_diag_mac_from_elm(struct rtw89_dev *rtwdev,
+				      const struct rtw89_fw_element_hdr *elm,
+				      const union rtw89_fw_element_arg arg)
+{
+	struct rtw89_fw_elm_info *elm_info = &rtwdev->fw.elm_info;
+
+	elm_info->diag_mac = elm;
+
+	return 0;
+}
+
 static const struct rtw89_fw_element_handler __fw_element_handlers[] = {
 	[RTW89_FW_ELEMENT_ID_BBMCU0] = {__rtw89_fw_recognize_from_elm,
 					{ .fw_type = RTW89_FW_BBMCU0 }, NULL},
@@ -1387,6 +1399,9 @@ static const struct rtw89_fw_element_handler __fw_element_handlers[] = {
 	[RTW89_FW_ELEMENT_ID_AFE_PWR_SEQ] = {
 		rtw89_build_afe_pwr_seq_from_elm, {}, "AFE",
 	},
+	[RTW89_FW_ELEMENT_ID_DIAG_MAC] = {
+		rtw89_recognize_diag_mac_from_elm, {}, NULL,
+	},
 };
 
 int rtw89_fw_recognize_elements(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 7c3cb6d85ca5d..98078a3ef89e6 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -3989,6 +3989,7 @@ enum rtw89_fw_element_id {
 	RTW89_FW_ELEMENT_ID_TXPWR_DA_LMT_RU_5GHZ = 25,
 	RTW89_FW_ELEMENT_ID_TXPWR_DA_LMT_RU_6GHZ = 26,
 	RTW89_FW_ELEMENT_ID_AFE_PWR_SEQ = 27,
+	RTW89_FW_ELEMENT_ID_DIAG_MAC = 28,
 
 	RTW89_FW_ELEMENT_ID_NUM,
 };
@@ -4166,6 +4167,11 @@ struct rtw89_fw_element_hdr {
 				__le32 val;
 			} __packed infos[];
 		} __packed afe;
+		struct {
+			__le32 rule_size;
+			u8 rsvd[4];
+			u8 rules_and_msgs[];
+		} __packed diag_mac;
 		struct __rtw89_fw_txpwr_element txpwr;
 		struct __rtw89_fw_regd_element regd;
 	} __packed u;
-- 
2.53.0



