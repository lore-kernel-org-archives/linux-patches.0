Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061955;
	b=AjvVnRIsa6MNK3Lz9fI1uhwYCtOrglJebyFFpYmP3tAyfQUB1GOa/AooKDpu29xod3FA
	 HBb5h5cpe1UawE1VOlauJakgqUAFPzHVokXOTNN4f1wybjK/vVBPlOoIzDbpWejjWrKmh
	 R0aHDVepRXMnoODx5GYeTXxxnfaWCz8RLnGcS7FiVR8xFWH+soGnxUaQVO3fQKZxC1AJ+
	 OUwVbYVK6IMRpEtYMIMB3lOUG73sAJuYFFYCFRlnATHnMBNNHg7m+ko5CpF9RPLvY8Xwn
	 2OXcrvMcnWK0sW+4bda9xupHHMJjCKLOX++f8c1I6Q3VE5+Mn4vp9JxdfXVnRexQ83Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TOcKJ9RLcYjRGLiW2G0+XpsBHqeJ2IdztoI6K297hFY=;
	b=unsGBpSeCaqH/AshkPiaiPxOHNq5oAEl8L7vCQkuyuFgAsQ4c1Hk45bnZ9bUZO0vxqFz
	 WFmYdBsJBQ5kgMh3H9ST+A3c+MYVTo5d9h0ZF40Y1rsouLQS9+SMcrJ5TBh9auCPwOylz
	 /e25TAmQuj6C2NTEJyS8R2ATJEKVIDUkJkXvRgFvipSfz9BnmkUlsyKiU/4F84sg420sd
	 Ov8k8P4tswYwpw7jvYUSVARkvvEAhABwq5+pLoMHSI7XOZglwMzrlwgefYDOizReZ7kcP
	 lYNRw46Y86JhGo5KicS9TCNOBUXqAC0dd4ttEVZGmLsdhxFHf+lYPNqyyBv7klVwaVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtN6yHJL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D227606A32E;
	Sat,  7 Nov 2026 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtN6yHJL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071DC1F0089F;
	Sat,  7 Nov 2026 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061955;
	bh=TOcKJ9RLcYjRGLiW2G0+XpsBHqeJ2IdztoI6K297hFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtN6yHJLExZrC2lJlw2z6n0vYzZkiG0ctGLNBdgF4O0e63vZoSEFKPttZoE8YQ4N0
	 uJOLjQ3nfKjxzisWo8G4/ajDrZtWSZZgbym61PDQx++Z7nHlsg28E0awvHaRxjDQS4
	 ywN7ubQj7P6Ta6Zmv5aGAWKT93rIAkGK/D/r2isU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0914/1536] wifi: rtw89: cap firmware section_num before parsing
Date: Sat,  7 Nov 2026 08:48:50 -0500
Message-ID: <20261107135023.307565607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c11e871fa484a..ef23616f71121 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -146,8 +146,24 @@ static int rtw89_fw_hdr_parser_v0(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
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
@@ -407,9 +423,25 @@ static int rtw89_fw_hdr_parser_v1(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
 	int ret;
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



