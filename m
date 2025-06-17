Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526222ED174;
	Tue, 17 Jun 2025 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176554; cv=none; b=IEKT1fiSVSXl5uXfd3TP4nP3SGOMHwCemCLiy1BL53SdM1yqxQSVXuUDA2vJG8bL9nFEoZ07qNekojpkGmenF+cjZDQHTOYYf1n1kCchQEsZRqk9/CrCjjFSWRgwAT1zbZQvyVd2EfsXyk1edL/RJbG/sdDIAkWRpXnMNDxVIxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176554; c=relaxed/simple;
	bh=tIpZ/oHctfF5yoUT6z1JFek8UCJAws173kirL3U4/wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRwcSxoUEwlbVvOcKkTgjWpd5/jY7CW89MYBwYHUiYwn/acpLpSKYfi8iRaUDcXUZD/TGS0o/oDPt/6K9f9sDteMm1NsHNLjbOnUORsmfzx/pX3MXc0XoBTZP66NXbVSi+vmm8QUyDtYgOCCko1pyZ+c+PU0qE+3aGdkpjm6LSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3vf6Rpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3vf6Rpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36BBC4CEE3;
	Tue, 17 Jun 2025 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176554;
	bh=tIpZ/oHctfF5yoUT6z1JFek8UCJAws173kirL3U4/wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3vf6Rpf+myr5BJ4uWHb1s69XQ6AjSdhwGRPZd3mb0dwErhn63z/nkO2N/aXcCMH+
	 0wTr4Fdd+ItPGG7+zGdK8gWK0yh5O4SGQGhwo4viKlZbpHJF56NzJH3CSnYOtnSKMh
	 pJvEUuAGbNArvhOHhIsmzvY/J/VvidEMVem+X69I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 201/780] wifi: rtw88: do not ignore hardware read error during DPK
Date: Tue, 17 Jun 2025 17:18:29 +0200
Message-ID: <20250617152459.651134479@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e53e0db177ef..8937a7b656edb 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3951,7 +3951,8 @@ static void rtw8822c_dpk_cal_coef1(struct rtw_dev *rtwdev)
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001148);
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001149);
 
-	check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55);
+	if (!check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55))
+		rtw_warn(rtwdev, "DPK stuck, performance may be suboptimal");
 
 	rtw_write8(rtwdev, 0x1b10, 0x0);
 	rtw_write32_mask(rtwdev, REG_NCTL0, BIT_SUBPAGE, 0x0000000c);
-- 
2.39.5



