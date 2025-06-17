Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B3C2ECD33;
	Tue, 17 Jun 2025 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175469; cv=none; b=c7EdPlUCUqOZHo1ROz/jWqdLevzs2IngTWRY4d2/h5e6kNVXCBgp4LJEfcheEQEHnqj/Q+uq8bgB8Pp9A1E2kYkvPkzKzdXJV5c+JUH2fuOVZypMpwTX+4jGtALjqf3LZdOdltbFGr6RtxYabLEzw3iwXqYllh2zhh9+xfiOHMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175469; c=relaxed/simple;
	bh=O85oZodD3t918pFqSQZkL+wWFi0vMAxA2kim8wqcl0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crimYVmWsSUfUaeB0GHZDKFHBF/TJCygJiKG5UOooMGbzQJkB/RQoC7D6VKYuVyy7qdQaWdC+p6HbqMUf4ycVPnpBSF2qlgATBoyxo4GDXq3yWMHWe0rJ0g+BfZkhmtTFsizt+8ENAWPTONEq3SMZpxsRixPj7nJn5ssQ1uzaf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHWMK6Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHWMK6Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA4FC4CEF0;
	Tue, 17 Jun 2025 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175469;
	bh=O85oZodD3t918pFqSQZkL+wWFi0vMAxA2kim8wqcl0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHWMK6KpqtuAt9vQJGxXQWps8Z4pnXVkNIVIINOSxpG9O4/rR2WHAxnyHxWYgrnWG
	 yWjGluMVVoMLGYtEQ8VS/SGmRCKlUNB1TLywg4CKDIfhNGzqESKyafn37/dsylotFI
	 2pJ3rVg89e5NHnKMWWUVX+P78ccAG2qh3COKat7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/512] wifi: rtw88: do not ignore hardware read error during DPK
Date: Tue, 17 Jun 2025 17:21:35 +0200
Message-ID: <20250617152424.820470997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 20d3c19bd8f9b498173c198eadf54580c8caa336 ]

In 'rtw8822c_dpk_cal_coef1()', do not ignore error returned
by 'check_hw_ready()' but issue a warning to denote possible
DPK issue. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5227c2ee453d ("rtw88: 8822c: add SW DPK support")
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250415090720.194048-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 1dbe1cdbc3fd4..3157cd834233d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3993,7 +3993,8 @@ static void rtw8822c_dpk_cal_coef1(struct rtw_dev *rtwdev)
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001148);
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001149);
 
-	check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55);
+	if (!check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55))
+		rtw_warn(rtwdev, "DPK stuck, performance may be suboptimal");
 
 	rtw_write8(rtwdev, 0x1b10, 0x0);
 	rtw_write32_mask(rtwdev, REG_NCTL0, BIT_SUBPAGE, 0x0000000c);
-- 
2.39.5



