Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046647;
	b=sGqUWfbRWSTbv9YZs9ZoGe9TrEy5uuzokBH0n375agw+fiF7tP5RFIi7YZ8KEIoP9NR8
	 SRfCh8Xv6JNhOcR+Poxirvic8pbfjPXw2CpVM7DL38cdN65ExYTjLkw2eeLa5Iy2hW4PL
	 KZApnfb15DCSQye6TklRifkff4R+IEZT4qB9oXp2XE1+PfbJBGjC2eGBEtybBhCQGyAQ6
	 oFS0lnsnu/lCgmDUP27XHHOP2HC0w587SCJeCdv+rIXw1tfJZ9Ijg2jS90nGvqecMR6Fj
	 XD7jolyWKaPf/jtC6WvZOwOL1WKCIT1mqtkwXytfebmXjusuHtKfKBY+oRyyPNTEuUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uKrzWRVHLxUCJbWFa6A/pp+Y6mLdVGM32VGnnTYcjas=;
	b=YT2rJt2D/cl2kwg9JioVPnBwPrRh7G6tch9IR05xfhZtz2HveoCZ00pf6GYsv+C7Faen
	 1VTOlWGwppegcan/N3zwtmDlLgA+ubdn5Oon7/Gnnv8qegDtRae8NR/94387f3DwQEtcJ
	 Qm5fVSZJPUiTmq7+HO5/eWfHMzn51xZgKWrwVoLX9I11zbv2JK9bbqobeiUOJIXQ07V+X
	 mia+lsyq3UMjfUd+nTL7nkjq+v2LK3K0RN2rwkkun6H38uzTqd8XuJrgwUP5tPgaBg0NE
	 QR94C/M1k+W3eto9K89PdNioKkeM69cLnVykZdX+RH3sd9Xwhw2QtWQvklfWXDhXItg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWa9juMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B2B606A32A;
	Thu, 19 Nov 2026 00:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWa9juMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EB71F000C4;
	Thu, 19 Nov 2026 00:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046647;
	bh=uKrzWRVHLxUCJbWFa6A/pp+Y6mLdVGM32VGnnTYcjas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWa9juMcZuYdPtGFoZN9h14meyjqv9m7rSB1W99Xq/lnmm3U90Icrd+KYgrMMsII0
	 2J74WbJEHDmbkOsEiMAjZcd0VvhBeePOqkH+iD1WMDXxfiogKv3gwOD1w7GAqGJGjX
	 wAsfPkj5xYcK2q27YxXBqEz95jilQyek86QQ48wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1356/2857] wifi: rtw89: cap firmware section_num before parsing
Date: Wed, 18 Nov 2026 15:39:50 +0100
Message-ID: <20261118150250.231888557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted checks from separate v0/v1 parsers to the single parser using byte offsets and size constants. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 977aadfdf997f..0963b6785329c 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -91,9 +91,24 @@ static int rtw89_fw_hdr_parser(struct rtw89_dev *rtwdev, const u8 *fw, u32 len,
 	if (!info)
 		return -EINVAL;
 
+	if (len < RTW89_FW_HDR_SIZE) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
+
 	info->section_num = GET_FW_HDR_SEC_NUM(fw);
+	if (!info->section_num || info->section_num > FWDL_SECTION_MAX_NUM) {
+		rtw89_err(rtwdev, "[ERR]invalid fw section num %u\n",
+			  info->section_num);
+		return -EINVAL;
+	}
+
 	info->hdr_len = RTW89_FW_HDR_SIZE +
 			info->section_num * RTW89_FW_SECTION_HDR_SIZE;
+	if (info->hdr_len > len) {
+		rtw89_err(rtwdev, "[ERR]fw header truncated\n");
+		return -EINVAL;
+	}
 
 	bin = fw + info->hdr_len;
 
-- 
2.53.0



