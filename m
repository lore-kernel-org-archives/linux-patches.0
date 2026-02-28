Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE45340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301073; cv=none; b=TkIth12RubBgmTf+gZsG4wUek7cWaSUAvUBvROyIxM/iTSca9kFgMdWva34AtTRRCzJW9N/8quI/19HBbeAnueXpE51QRMSNqCyCSe0BBBekV3kYVH+aiGc2nNP5jDV1kN+5EO4DLV0k+ve6OEIa8XcMOIpu4IGn6rbGPE08SFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301073; c=relaxed/simple;
	bh=cPVK0TWIcGIHlHv1wT+b9K68csugq+4rHgrP3wgMpjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyxA5XDsFUz5MPQDUFx+PHHtMpK3f4XZkKNBWCMvmRxxMQ9kpkikLPPjpj0Mx4skk/hfomhIbj3B+SONuuJgD3H1jP+gOI5Rz4g09HqQwFkQE3pmbTthwt8O0GqRnpTeReW9FvDgCHxP+OqJp3MfzLHEkuBROJdOXIm/AJnTbTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXaCj+sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXaCj+sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80062C19424;
	Sat, 28 Feb 2026 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301073;
	bh=cPVK0TWIcGIHlHv1wT+b9K68csugq+4rHgrP3wgMpjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXaCj+sIUoMkrdGiwOrgQkUDps9TfzwasWF6JLn+BuQUPxHnDFPVypdnwhFxvlCHc
	 9iVKMYrU8OFlu/L7fVyiHQ6kWFye4hsugsYoJ81o3EEl2Mv403b/dkygzFVHCAxmXF
	 0qGQjqdMxAg01a2vHmRdhuhLQMOfbD/WhsUAi9N20W7Z30iVKYEDkKyWmuRwuu7tdz
	 8nWhLHULXrikcSrdbpguo6NrPbiUcY2jdnBkIDXYpyn3yaflMLBPI0mErHbhgkk9Tn
	 ghIg03rhhniEvtmRJR4S3hWFkMlcZWtsGTJeAveNSwGwXPTiKqRPyBcOuYpfLENiNB
	 uAo0VNwS0ZJpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/752] wifi: rtw89: ser: enable error IMR after recovering from L1
Date: Sat, 28 Feb 2026 12:38:49 -0500
Message-ID: <20260228174750.1542406-218-sashal@kernel.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit f4de946bdb379f543e3a599f8f048d741ad4a58e ]

After recovering from L1, explicitly enable error IMR to ensure next
L1 SER (system error recovery) can work normally.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251223030651.480633-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c    |  1 +
 drivers/net/wireless/realtek/rtw89/mac.h    |  1 +
 drivers/net/wireless/realtek/rtw89/mac_be.c |  1 +
 drivers/net/wireless/realtek/rtw89/ser.c    | 10 ++++++++++
 4 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index fd11b8fb3c899..2de75d22c97f2 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -7016,6 +7016,7 @@ const struct rtw89_mac_gen_def rtw89_mac_gen_ax = {
 	.check_mac_en = rtw89_mac_check_mac_en_ax,
 	.sys_init = sys_init_ax,
 	.trx_init = trx_init_ax,
+	.err_imr_ctrl = err_imr_ctrl_ax,
 	.hci_func_en = rtw89_mac_hci_func_en_ax,
 	.dmac_func_pre_en = rtw89_mac_dmac_func_pre_en_ax,
 	.dle_func_en = dle_func_en_ax,
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 25fe5e5c8a979..51e37c183a35e 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -999,6 +999,7 @@ struct rtw89_mac_gen_def {
 			    enum rtw89_mac_hwmod_sel sel);
 	int (*sys_init)(struct rtw89_dev *rtwdev);
 	int (*trx_init)(struct rtw89_dev *rtwdev);
+	void (*err_imr_ctrl)(struct rtw89_dev *rtwdev, bool en);
 	void (*hci_func_en)(struct rtw89_dev *rtwdev);
 	void (*dmac_func_pre_en)(struct rtw89_dev *rtwdev);
 	void (*dle_func_en)(struct rtw89_dev *rtwdev, bool enable);
diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index ef69672b6862e..e33297220f8b5 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -2594,6 +2594,7 @@ const struct rtw89_mac_gen_def rtw89_mac_gen_be = {
 	.check_mac_en = rtw89_mac_check_mac_en_be,
 	.sys_init = sys_init_be,
 	.trx_init = trx_init_be,
+	.err_imr_ctrl = err_imr_ctrl_be,
 	.hci_func_en = rtw89_mac_hci_func_en_be,
 	.dmac_func_pre_en = rtw89_mac_dmac_func_pre_en_be,
 	.dle_func_en = dle_func_en_be,
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index f99e179f7ff9f..7fdc69578da31 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -431,6 +431,14 @@ static void hal_send_m4_event(struct rtw89_ser *ser)
 	rtw89_mac_set_err_status(rtwdev, MAC_AX_ERR_L1_RCVY_EN);
 }
 
+static void hal_enable_err_imr(struct rtw89_ser *ser)
+{
+	struct rtw89_dev *rtwdev = container_of(ser, struct rtw89_dev, ser);
+	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
+
+	mac->err_imr_ctrl(rtwdev, true);
+}
+
 /* state handler */
 static void ser_idle_st_hdl(struct rtw89_ser *ser, u8 evt)
 {
@@ -552,6 +560,8 @@ static void ser_do_hci_st_hdl(struct rtw89_ser *ser, u8 evt)
 		break;
 
 	case SER_EV_MAC_RESET_DONE:
+		hal_enable_err_imr(ser);
+
 		ser_state_goto(ser, SER_IDLE_ST);
 		break;
 
-- 
2.51.0

