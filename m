Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038121;
	b=RcZQPUNLM/C97nKdgywBtRBclXbgQwV3+eWWGQVvEvz76FQTzDKEHlALI8KffgH5BU84
	 vyChsiXKm8ZMQBinHiTWSs21qH/8csbt/53ht421kGDzpTZAOflA5cr74sCILiridyP2q
	 oieX844+MRxCcYwyFuNRJjUHmYVFMUjrNEUzUKipo278U/oRZcJ8kMAY2ouCMtzzWj/oF
	 LQ/K5/jjhx1kRkFTkUC2gcI6AczWWJ2Ps5MEAna0BMqdmliVIW4QUeWD+bEhJ+wOZMT1i
	 ecUiD606mMXPWxeh5c7cAimr1eYAUHR4LaBeSEFBaV1S70XdeeLcvTCKdfJsvdVjFww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nN/nL8O7HVQyh0oRiNMaNHsFrV/k18epf1GyY70zupY=;
	b=cawFRSihb2NP74n6BE/OwzJ0t5tzXkeTLnODIdKiOWfYXIVyA7e3rZu82gud1yfgB6S+
	 qX1yUosyg2NgT/Q3S65wlpIZj6O/WJOx+fdUQFRo07aVezlcv4rCmsKBMrmI54kNUxut0
	 EzHuYgK1tQC9WL5p49SS8BGklEeHSSI+jE80SpZ0BHQS8JphLvlNCsGV1yv2z+tn1ndpr
	 yVUnKQL1NoVKi0TuTAkAqaEgHS9tGo0JlPGs5sFU18jNZ6PaGp6t8E3WAIAR5bh78StDC
	 NrL7V3cth9xiQwD5va5AWJvofT3UifHkoEi3EuwN5rbFZztpFLNOZWIpBmMBp/W8Z3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXPW5yrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407F0606A320;
	Wed, 18 Nov 2026 21:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXPW5yrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DD21F000C4;
	Wed, 18 Nov 2026 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038121;
	bh=nN/nL8O7HVQyh0oRiNMaNHsFrV/k18epf1GyY70zupY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXPW5yrhxHTJsaeD+tz62I7U8HK/lcFAF2rJYi9+t5ls3T2oJYjVoBVGKyqDjoB/0
	 bPKplgwq0Um7cDyDDoo7BT8grlSnaorImS6j5xBlgrHyPDLmJ7qEptYOnQiawS6Q4g
	 Z3MsXuUmKtXXyHRiT68spwv3MVvUqPmUi5KIpPv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1606/3318] wifi: rtw89: fw: consider checksum length of security data
Date: Wed, 18 Nov 2026 15:37:08 +0100
Message-ID: <20261118150409.361865142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit dedf78efd2885048ca36bc17fbd4e1c0af33f2ad ]

The newer firmware file provides security data with checksum, so we need to
consider the length. Otherwise it will fail to validate total firmware
length resulting in failed to probe.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240204012627.9647-2-pkshih@realtek.com
Stable-dep-of: 273b0a8be083 ("wifi: rtw89: cap firmware section_num before parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 3 +++
 drivers/net/wireless/realtek/rtw89/fw.h | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 48ed0e5dbed8f..fab124dac2408 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -169,6 +169,7 @@ static int rtw89_fw_hdr_parser_v1(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
 	u32 i;
 
 	info->section_num = le32_get_bits(fw_hdr->w6, FW_HDR_V1_W6_SEC_NUM);
+	info->dsp_checksum = le32_get_bits(fw_hdr->w6, FW_HDR_V1_W6_DSP_CHKSUM);
 	base_hdr_len = struct_size(fw_hdr, sections, info->section_num);
 	info->dynamic_hdr_en = le32_get_bits(fw_hdr->w7, FW_HDR_V1_W7_DYN_HDR);
 
@@ -197,6 +198,8 @@ static int rtw89_fw_hdr_parser_v1(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
 			section_info->mssc =
 				le32_get_bits(section->w2, FWSECTION_HDR_V1_W2_MSSC);
 			mssc_len += section_info->mssc * FWDL_SECURITY_SIGLEN;
+			if (info->dsp_checksum)
+				mssc_len += section_info->mssc * FWDL_SECURITY_CHKSUM_LEN;
 		} else {
 			section_info->mssc = 0;
 		}
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index bc6a9ea9352e0..1264330b26279 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -225,6 +225,7 @@ struct rtw89_fw_bin_info {
 	u32 hdr_len;
 	bool dynamic_hdr_en;
 	u32 dynamic_hdr_len;
+	bool dsp_checksum;
 	struct rtw89_fw_hdr_section_info section_info[FWDL_SECTION_MAX_NUM];
 };
 
@@ -421,6 +422,7 @@ static inline void RTW89_SET_EDCA_PARAM(void *cmd, u32 val)
 
 #define FWDL_SECURITY_SECTION_TYPE 9
 #define FWDL_SECURITY_SIGLEN 512
+#define FWDL_SECURITY_CHKSUM_LEN 8
 
 struct rtw89_fw_dynhdr_sec {
 	__le32 w0;
@@ -523,6 +525,7 @@ struct rtw89_fw_hdr_v1 {
 #define FW_HDR_V1_W5_YEAR GENMASK(15, 0)
 #define FW_HDR_V1_W5_HDR_SIZE GENMASK(31, 16)
 #define FW_HDR_V1_W6_SEC_NUM GENMASK(15, 8)
+#define FW_HDR_V1_W6_DSP_CHKSUM BIT(24)
 #define FW_HDR_V1_W7_DYN_HDR BIT(16)
 
 static inline void SET_FW_HDR_PART_SIZE(void *fwhdr, u32 val)
-- 
2.53.0



