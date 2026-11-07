Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063849;
	b=VSqswZg23XH5V2wmPU/oty7Q/zYCkzv0Og3iYy0EtYdua999TTK7hX1cCMXgb8CKsmm2
	 AhOOtCWabHTIQSVwlIxZqxrQ4vlPAS/JcSJRrcavCzTUtdWwaImP9Yj2QrsCa/ammELQG
	 6rZvSBybj9rq1r2LsAob6G2s1lqQWTieWnBquoypA1ylwXWYUuuZqk5yjTr497LkAI0mu
	 ilaB9KJyH+M3D9FTJtgClmxca+8T9SSTVebIciNT6g8ZSFpdz51WZfYR80DR6ACOuONer
	 8x9YkwZxDaWyztgW+GFUVIFsl53OdGrzs7Ep50/H4cB+LG6gR+AAvHr+yUf2hvxGgIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=izGtJixodxoMTAyPYjConP8lZ+SUd7KYRboWDz1ouSw=;
	b=Ge8xDi4fAMyijd870uuKvfOuWuDvoZWDw698QvcnBv4vb0ihckPnJxDRXQs3CyWBJs3b
	 XvHqgrIJiifNYZHf+7P5CrTIbZ5ZKxm+il+m7x70vkXd7gmwqSe/Msi6gzyudHKyF13ge
	 8DdM7Jn6o2R+Qg2OAI6si4NOiOh+dbQfFLjewq9SIx+puKaVFg89WBOF5vGZKd3EIkoxm
	 0uzZCecdy3sFGGpLtzDLXCbRsVVfcvZnjoB2ZY0aihGkqnW5ysqcmhxaSQu0WbVNi+WU+
	 CfrjiUmquA+OMI33pA8fl5BclQ+1rwEjeigRgcl9lt1RAG+JWlJDMtDdWTr8gaVkgEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK0GdXIR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1F5606C009;
	Sat,  7 Nov 2026 15:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK0GdXIR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B571F0089F;
	Sat,  7 Nov 2026 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063848;
	bh=izGtJixodxoMTAyPYjConP8lZ+SUd7KYRboWDz1ouSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LK0GdXIRSDJpw5NZxO0HRnE9fK56yUudwwmbQoNeV12Ai16f36ywHVeHWnDiJNgaB
	 5R1ur1LLfnaenFZGDMrWYBjVuu0pMyU/c2gCN5aWj+YtuNBsqvdP87d6RFSH71vDis
	 l/w3MwTM9cC9UiFuEVmLWInmJkk+C4qhEXpqNOY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0059/1257] wifi: rtw89: cap firmware section_num before parsing
Date: Sat,  7 Nov 2026 08:39:15 -0500
Message-ID: <20261107134941.032287194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 0099c5c03e7a6..b2991bc93f852 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -156,8 +156,24 @@ static int rtw89_fw_hdr_parser_v0(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
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
 	info->idmem_share_mode = le32_get_bits(fw_hdr->w7, FW_HDR_W7_IDMEM_SHARE_MODE);
 
@@ -455,9 +471,25 @@ static int rtw89_fw_hdr_parser_v1(struct rtw89_dev *rtwdev, const u8 *fw, u32 le
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
 	info->idmem_share_mode = le32_get_bits(fw_hdr->w7, FW_HDR_V1_W7_IDMEM_SHARE_MODE);
 
-- 
2.53.0



