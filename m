Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F81253B73;
	Mon, 23 Jun 2025 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685570; cv=none; b=nppq0ZQj5B0kOv7hYgR3NldOwwZJ3Z3+srHz5L5NF0qoUHXc++oh1wOYK8oeAFm9Ti+3U3rfhaVX7iZxfDJoaHCve6YYbRFlBnrTb1Ldcw1spkPyNwS+/NjtPOnDNg/4n+GVwiK5o2+0IBsXTJcsuh2xrhcdZtpKYgBUmsX7D0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685570; c=relaxed/simple;
	bh=M+h2lYOxK8CISQfcEcM5EPovpV6+x3VDYeUEMWSyK5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCdRVeHS0JM4zW6A2Xkv8pnCu95SeFiFihSa8tAtmK1bDhdsWJaFheL+toNMx7iu/tHqAP6E+Nr+nBh4QOIcK7XnfNUvppdJrEg68INSjFn0HJT27ZfZdG7dfNEAiuSsW5E7ZS7keYBZjrqpapWaEacIs24GQ0FhZ/7gByVo7aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2i86E3Qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2i86E3Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88170C4CEEA;
	Mon, 23 Jun 2025 13:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685569;
	bh=M+h2lYOxK8CISQfcEcM5EPovpV6+x3VDYeUEMWSyK5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2i86E3QwZy/Lclt2EuhfZTuuIy5Cyhb5MOXjg3Ud38yt9EZ4msVlLmxWO88fsvwYA
	 Px8z5S7YxmrtPIkmuemQMe9RNOmr1ni6n7EmbZC8FubSzGbhbAManilO0FBRxxfR7+
	 5piJjFjiUbF27NtmB2qYo1+KVSXCoFA8onhYXgyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/411] wifi: rtw88: do not ignore hardware read error during DPK
Date: Mon, 23 Jun 2025 15:03:07 +0200
Message-ID: <20250623130634.297080515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b799655d08e15..96b7f2efeaaa9 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3946,7 +3946,8 @@ static void rtw8822c_dpk_cal_coef1(struct rtw_dev *rtwdev)
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001148);
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001149);
 
-	check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55);
+	if (!check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55))
+		rtw_warn(rtwdev, "DPK stuck, performance may be suboptimal");
 
 	rtw_write8(rtwdev, 0x1b10, 0x0);
 	rtw_write32_mask(rtwdev, REG_NCTL0, BIT_SUBPAGE, 0x0000000c);
-- 
2.39.5



