Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038152;
	b=gORjL5NRKRJDCY5AzmjTG7WhrcDEE/O0xNumoxmWCQlE5C7V9thIixHhFbj9RQMLYFvo
	 LLEA9GpzXK48dS6nqN9cmAsMvsFFc97N8t4dG33BDYyRQw8i1H+XgxRq03ijOhSoSCeYi
	 bAHmCggQOpvQmJBKTSF+6Pwan3gqRbJsXc6pQJ0hGoD7+s0KWty3qF5QNCRaGXXrlZ4o5
	 xfaX2ZwEmARMBEsxS73xoPpSxS3IppD9u8e+ErXxm3YAm444k6PAlqv1Wvogz6Qif1kYP
	 98VtCvb93U+Fz6srGi8xdnlHkWCLgKDb2UASwSvfGX7zSAAiv/jg8hQ+tsWCvFU7qqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhnWefR1ESYLmEAkYkOPdIKBVW6ypfeuMJjRAwCt/gE=;
	b=uvzMmnd4jOiZ40g8q0ZOZ3bE6V3hLzdnmi0a/BkFV6VRwPmG9eRCswFXinWMORyPSkwH
	 TQxSm70WGgmU6NrzQa364BEr3CP15HE1GRBskvA0brGwxfqp2n+zhrSXXxxQtvJlcgeMA
	 SuCGtukP82UUJHokc3wCfgq3EUDUGpTR4/5TEFN96Kx9J0BB7x334f8G1f/S1Sw1jLFtg
	 WZ6GRQhd/B7SQtQdKu6J1n6s7xnsbHAiwEvuisG4P/LPgoy+mJc+N0Rzxx93Q22GgxUU8
	 OBzZKELQYEMAysY62Z7fyMVAJ5z/B+EHdsnnfpMLwYMbS4h9tE5YqRFtRZMurLpw3Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wm2RN24K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D626F60A2612;
	Wed, 18 Nov 2026 21:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wm2RN24K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3793F1F000C4;
	Wed, 18 Nov 2026 21:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038152;
	bh=WhnWefR1ESYLmEAkYkOPdIKBVW6ypfeuMJjRAwCt/gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wm2RN24KrWYuq7bhm3zD4JrgTa6NWG3O7m9g8ecbsPgVZCmmcowodxpruGdXJlwBR
	 gmpPMU5O3F6EHAulliPBmQuKhnW/CqB4tHUBQzQtAAceRf7RxcdsQRqoZq770P2f4/
	 KVUHF5RvF98wlwjdmd4n9C95gquDscheFRd5eRv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1607/3318] wifi: rtw89: cap firmware section_num before parsing
Date: Wed, 18 Nov 2026 15:37:09 +0100
Message-ID: <20261118150409.392079784@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 273b0a8be083df6d0319ce62caa870e927f94a31 ]

rtw89_fw_bin_info.section_info has FWDL_SECTION_MAX_NUM (10) entries.
The v0/v1 header parsers take section_num from an 8-bit firmware field
(0..255) and write info->section_info[i] with no cap.
rtw89_fw_download_suit() keeps that object on the stack, so a crafted
firmware blob overflows the stack.

Reject a truncated header and a section table that does not fit in the
firmware image before reading fw_hdr->sections[i].

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Cc: stable@vger.kernel.org
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260825174438.63168-1-acharyalaxman8848@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 32 +++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index fab124dac2408..7a9c367350c9f 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -103,8 +103,24 @@ static int rtw89_fw_hdr_parser_v0(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
 	if (!info)
 		return -EINVAL;
 
+	if (len < sizeof(*fw_hdr)) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
+
 	info->section_num = le32_get_bits(fw_hdr->w6, FW_HDR_W6_SEC_NUM);
+	if (!info->section_num || info->section_num > FWDL_SECTION_MAX_NUM) {
+		rtw89_err(rtwdev, "[ERR]invalid fw section num %u\n",
+			  info->section_num);
+		return -EINVAL;
+	}
+
 	base_hdr_len = struct_size(fw_hdr, sections, info->section_num);
+	if (base_hdr_len > len) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
+
 	info->dynamic_hdr_en = le32_get_bits(fw_hdr->w7, FW_HDR_W7_DYN_HDR);
 
 	if (info->dynamic_hdr_en) {
@@ -168,9 +184,25 @@ static int rtw89_fw_hdr_parser_v1(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
 	u32 mssc_len = 0;
 	u32 i;
 
+	if (len < sizeof(*fw_hdr)) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
+
 	info->section_num = le32_get_bits(fw_hdr->w6, FW_HDR_V1_W6_SEC_NUM);
+	if (!info->section_num || info->section_num > FWDL_SECTION_MAX_NUM) {
+		rtw89_err(rtwdev, "[ERR]invalid fw section num %u\n",
+			  info->section_num);
+		return -EINVAL;
+	}
+
 	info->dsp_checksum = le32_get_bits(fw_hdr->w6, FW_HDR_V1_W6_DSP_CHKSUM);
 	base_hdr_len = struct_size(fw_hdr, sections, info->section_num);
+	if (base_hdr_len > len) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
+
 	info->dynamic_hdr_en = le32_get_bits(fw_hdr->w7, FW_HDR_V1_W7_DYN_HDR);
 
 	if (info->dynamic_hdr_en) {
-- 
2.53.0



