Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29A83195F9;
	Thu, 15 Jan 2026 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496742; cv=none; b=UzuYWYWvZ5WpG5Je8mAYG+xJzRE37riHfnCjlKW6Y3ENV025pMWSBRUkDwJwPdLoU44CMzaUH9STcWaSRw77IWY3OeF5ou+FM3nRHfgBRP6i/t69fNEXJmxItnvYcg6LBTVKVlkfyk3kNK93Vs5+W3WYpiY/ptS+ZOcf8h2HleI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496742; c=relaxed/simple;
	bh=JgmpXDJhKzgtF6IgReCGuYHwm18rBAHHk/1QOhGvCiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V30liKeN4E/GJqpX8Gv+IQZO2ga9y7QQmLo9xIk5xj75dEuwkTbsjOOyTWXf44CXebXQlNkKLuG1U5nvgE/iziJS0OQdmiq9Lb+97213SmxRQ0/L50cbo2O1p9TB0uQ6gY+bRmOG0b4Ktzxhh8oQjl4bUX4hA14LetR5B4nxCL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YW2IyLjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YW2IyLjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204F8C19423;
	Thu, 15 Jan 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496742;
	bh=JgmpXDJhKzgtF6IgReCGuYHwm18rBAHHk/1QOhGvCiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YW2IyLjYnU2T93n6wYkl+gc0d/CSV1zdaBfv00heffPD50R3ALeauFEwf/m3yvYcb
	 BtNbvq1a0+3MlDkfiRR+X3SG7+vEmfx6AQe+ItCMGYRlEM4/ij5WhkWiAneM0VGRhg
	 xtBV69r/O0dOVPsg7RKAnSXyhkljw/5DKHoUCnb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Hughes <marcus.hughes@betterinternet.ltd>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/119] net: sfp: extend Potron XGSPON quirk to cover additional EEPROM variant
Date: Thu, 15 Jan 2026 17:48:37 +0100
Message-ID: <20260115164155.634677965@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Marcus Hughes <marcus.hughes@betterinternet.ltd>

[ Upstream commit 71cfa7c893a05d09e7dc14713b27a8309fd4a2db ]

Some Potron SFP+ XGSPON ONU sticks are shipped with different EEPROM
vendor ID and vendor name strings, but are otherwise functionally
identical to the existing "Potron SFP+ XGSPON ONU Stick" handled by
sfp_quirk_potron().

These modules, including units distributed under the "Better Internet"
branding, use the same UART pin assignment and require the same
TX_FAULT/LOS behaviour and boot delay. Re-use the existing Potron
quirk for this EEPROM variant.

Signed-off-by: Marcus Hughes <marcus.hughes@betterinternet.ltd>
Link: https://patch.msgid.link/20251207210355.333451-1-marcus.hughes@betterinternet.ltd
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index f1827a1bd7a59..964aad00dc87c 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -491,6 +491,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
 		  sfp_fixup_nokia),
 
+	SFP_QUIRK_F("BIDB", "X-ONU-SFPP", sfp_fixup_potron),
+
 	// FLYPRO SFP-10GT-CS-30M uses Rollball protocol to talk to the PHY.
 	SFP_QUIRK_F("FLYPRO", "SFP-10GT-CS-30M", sfp_fixup_rollball),
 
-- 
2.51.0



