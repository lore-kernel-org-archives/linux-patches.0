Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B875340A57;
	Wed, 20 May 2026 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300131; cv=none; b=EwZc7LQmT8UBDkn7AJInZYCQI8v/mRBWFZ3ToVW2aPeKzmIh/k2hfsqwrf3nGPBocnhC8R/7PGeBjkvyVxhYpt4fz0V3d3pBHLpEOYR8hrCTUnYwpJHAM6r2qA+8C9RnCFvOaUmk4pEEp25R2ujCqARSigwBq6OOHC9KTq31FxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300131; c=relaxed/simple;
	bh=iPyzu1I8lpa6sb/OLjM9iOnqVKS6dYZ09xEK8huwxTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2Aw7nNPRObQwNtBXrvkAeYrgLisGGWbxVxRIswNOe1xNUn875+B81vbi+uM7VTQq/QDbIrY05/XDTyZkwVxH3wYMvrHJT2hv3+l8iH+pjFR3zeANyoR/kLe5rE+xl2FFHrF1/kS4w80pwa966BU1XFp2Gn4gy0FGIWXWO5paoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7J+BEwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7J+BEwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212C61F000E9;
	Wed, 20 May 2026 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300129;
	bh=dumrn0rOxUBb5gu8Ee3ESjYOb62Ebzw2UhbLwBkfIb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7J+BEwH+199Gp8KGhJWbA+usW8yQfN+/veHypGD/4OjwPVgheQFyrRWirxURFjDL
	 hsH5TBGmJV8/k/L8m5IAaoP+vrb4uls20QIH9VTtPcBifOBt4tk6Xfl5vDkr9GZADE
	 sPCX/tnFPGlRfRJYsf298I1pSC8JDdE9CiIJG6nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/666] wifi: rtw89: phy: fix uninitialized variable access in rtw89_phy_cfo_set_crystal_cap()
Date: Wed, 20 May 2026 18:14:29 +0200
Message-ID: <20260520162112.492166703@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit 047cddf88c611e616d49a00311d4722e46286234 ]

In the rtw89_phy_cfo_set_crystal_cap() function, for chips other than
RTL8852A/RTL8851B, the values read by rtw89_mac_read_xtal_si() are
stored into the local variables sc_xi_val and sc_xo_val. If either
read fails, these variables remain uninitialized, they are later
used to update cfo->crystal_cap and in debug print statements. This
can lead to undefined behavior.

Fix the issue by initializing sc_xi_val and sc_xo_val to zero,
like is implemented in vendor driver.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8379fa611536 ("rtw89: 8852c: add write/read crystal function in CFO tracking")
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260323140613.1615574-1-a.velichayshiy@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index b473e02ecd9e7..d544077ec2989 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3893,7 +3893,7 @@ static void rtw89_phy_cfo_set_crystal_cap(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_cfo_tracking_info *cfo = &rtwdev->cfo_tracking;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
-	u8 sc_xi_val, sc_xo_val;
+	u8 sc_xi_val = 0, sc_xo_val = 0;
 
 	if (!force && cfo->crystal_cap == crystal_cap)
 		return;
-- 
2.53.0



