Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB59148315;
	Tue, 25 Jun 2024 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308250; cv=none; b=pMP8IhBBpXa1Nw/VPk/crvBtqdk+vkqo6spJ/bp4pIxGHHimjLj5ZJ8ZrrK2GjoXHgWRChl3oIg7lHkdInLUTXCVRELopcxKCtPkF9hl6xA96WyHKESXs8jS5unBpJa/gow7IQEM6EEx5nRoqAV4x9Ap6GhdREI31FW9W4fh1jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308250; c=relaxed/simple;
	bh=BEfidN3F/P0gx8VHBmfszHa4UiiJ4LvvrIx8pphio1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ck93ntvhibksBwqtBiV7E4BEasjw20xWB+pllX3y/bb23zzu6OOAumjIxdGqxm5gYpgGWiL5BXPWCwLuLA/9kPDLowq3SDbSdgs2oAxBZMWwLFWALLJNRe3gdm8Ht8BKtqaYKBKCK+kBMYHGTa4coDsbfJQC2/E1YONJm6xtYws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyneXCSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyneXCSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84F6C32781;
	Tue, 25 Jun 2024 09:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308250;
	bh=BEfidN3F/P0gx8VHBmfszHa4UiiJ4LvvrIx8pphio1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyneXCSmoLXzkszBnyEGAiR7WsLnOiTsjSFKIae9HLXHcRNOsr1w3vAKLTpZqzNC7
	 JnG8JlK8ZzbAeOFty1KzJaLTw9g2X2coE14DklsV9QusLUKGcOyD6DKoDMm5wzyqtS
	 fc+LX6v4jH9VeEmw/GFlKr2N/c12OqqZLph2TrxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Josef Schlehofer <pepe.schlehofer@gmail.com>
Subject: [PATCH 6.9 030/250] net: sfp: add quirk for ATS SFP-GE-T 1000Base-TX module
Date: Tue, 25 Jun 2024 11:29:48 +0200
Message-ID: <20240625085549.212806154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 0805d67bc0ef95411228e802f31975cfb7555056 ]

Add quirk for ATS SFP-GE-T 1000Base-TX module.

This copper module comes with broken TX_FAULT indicator which must be
ignored for it to work.

Co-authored-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
[ rebased on top of net-next ]
Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://lore.kernel.org/r/20240423090025.29231-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 6e42d4034b520..52b71c7e78351 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -508,6 +508,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_F("Walsun", "HXSX-ATRC-1", sfp_fixup_fs_10gt),
 	SFP_QUIRK_F("Walsun", "HXSX-ATRI-1", sfp_fixup_fs_10gt),
 
+	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
+	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
+
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
 	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
-- 
2.43.0



