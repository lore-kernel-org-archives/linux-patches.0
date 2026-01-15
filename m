Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5943B530C;
	Thu, 15 Jan 2026 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496350; cv=none; b=qQMGdix68GFKL8Wxje184iokUt4o//3qGE9ijW525CZ9k0y+16X5XDHKQvJE6fiDscNUb4gMfjJJCQYp3NpcLbs34J1I5otroVKn93O6I8p8P8TyroYoDeHDE92PANAV4BNWmP31BmH2Fs8s2yKGK+GP/6P1rnT/e2Ok0INrOE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496350; c=relaxed/simple;
	bh=5N7hzLipx6MIaoKmwTPThg/xrA4oY3ptfAMjptjnJOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0DURlYy7NE+GHk5q+lKXd7Bh5x3uTpG/MZ8nD9iOJtsxUMQcBsmYZUs7UH/ihNDNSQ6QnGGsAmgaeeqFgCaf7DzJUohi4ZtgsXufgA1UTcsQe+A+KSfH1Oqaf0hb+Dmp13T7g304PVDGr/M/WoDTNVsExaEiw6NdXw3Ah34Wlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smdDQoEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smdDQoEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88BFC116D0;
	Thu, 15 Jan 2026 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496350;
	bh=5N7hzLipx6MIaoKmwTPThg/xrA4oY3ptfAMjptjnJOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smdDQoEhQYXJsb8Ik0kaTP0cixNLXko3DEaoklMqJqsRMnvRQ2/9Z/8Z13J7LqdUI
	 9KUbU4MA6rAoavSMJsiShcKktqKiSU/+jdgkn0P/aIy2q1jsXP3aX0IN/UZ4Fg+dfy
	 h4wPqGR5b6xuZWHUSlv/HY9phh4TiRsFwFPqLqoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Hughes <marcus.hughes@betterinternet.ltd>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/181] net: sfp: extend Potron XGSPON quirk to cover additional EEPROM variant
Date: Thu, 15 Jan 2026 17:48:22 +0100
Message-ID: <20260115164208.271634671@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6b4dd906b804f..84bef5099dda6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -497,6 +497,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
 		  sfp_fixup_nokia),
 
+	SFP_QUIRK_F("BIDB", "X-ONU-SFPP", sfp_fixup_potron),
+
 	// FLYPRO SFP-10GT-CS-30M uses Rollball protocol to talk to the PHY.
 	SFP_QUIRK_F("FLYPRO", "SFP-10GT-CS-30M", sfp_fixup_rollball),
 
-- 
2.51.0



