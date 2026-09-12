Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611EC3EFD02;
	Sat, 12 Sep 2026 07:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197408; cv=none; b=cWrkzrvunUxR7k/0EP0XxKyLB1avWk0NxmXT0iEoIjoTJ31geXjjx/QddWIDxEBlMMbVTJIwwblKOAGHsEH5uGj/JK1Oi9vcs5JNLMi9+42pc0iVEC7BEO92rimtpJ8fcWG/B0iRuxRp2AFRSYDrs/4l2Qa+L4EdGySvSUuwQrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197408; c=relaxed/simple;
	bh=DIm7Ba4UzDD3im9+zI/tUbrPzxZzMIIX+WS/G8LRwAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJw2kdfhaCq0LNIbzWNssiUVNF4sReClAHHeZsX7LZNwGVLsUH0IrEdg/u6KIpyA3Lm/say22N+4FqGE/1No4vSfxb2Aiew4S7lMKEgY0wm2sPnuATC6OV750X7bQqsiiOs+SCxlpxSMUXTPNxGv1nL5056zWNAFd+MD7PnMcSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+FjoOo5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+FjoOo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4ED1F000FF;
	Sat, 12 Sep 2026 07:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197407;
	bh=ytkPyWqVUR9MTr/URpw6Om8u9Y1R9RjyylBwqfrKNlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+FjoOo5o9VYKAj3v0M9I6j3jCl/luuxSt/OkwGeCf5mEvxW3KV3AuFFUfdv4Ssp6
	 zMYBWVsMOxyaENTN4qf+7YCfWat9MvhVMbcHXwkkXti+g+2Tl9zBqH1n8ZxY4WeS5t
	 ZIhbSyo8OO1sND/p/TH/TLUUBogfyDI8tNpIV/0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0167/1815] wifi: rtw89: debug: fix off by on in rtw89_ppdu_str()
Date: Sat, 12 Sep 2026 08:31:57 +0200
Message-ID: <20260912065652.927556096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 1908534deb53a018580309be84a4f7dcc9cb1af3 ]

This > comparison should be >= to avoid an out of bounds access.

Fixes: 419ed7f4a053 ("wifi: rtw89: debug: extend bb_info with TX status and PER")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/aia25i0ds3B6QF6c@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 8f5af873e09f5..5786120602ab0 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -4348,7 +4348,7 @@ static const char *rtw89_ppdu_str(struct rtw89_dev *rtwdev, u8 type, u8 subtype)
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	const struct rtw89_ppdu_info *ppdu_info;
 
-	if (type > ARRAY_SIZE(rtw89_ppdu_infos))
+	if (type >= ARRAY_SIZE(rtw89_ppdu_infos))
 		return "RSVD";
 
 	ppdu_info = &rtw89_ppdu_infos[type];
-- 
2.53.0



