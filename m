Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829596;
	b=O1TTYixC9IIfY9VtxGzfYkbWYL2xn4uti62Kr9dLu7PLswcDmPdFzPcWUNzXKAzmX+h/
	 ZF8CkVi2gzxICDb0UAKYfkkGrEFAZBj5q8CKgNFl50dHJV8iQgrCUtl+qMvCNm9Fjz9nt
	 0K/6Rg8ExCCmCn1oOMwPuZD09rPeKjpLE3G/ZrEUswMtRiDfB0KCvLExpS6pUNZmHenjt
	 HSYSYVlqYjFiqDucSERCBhI1SWRzXfuCNZKiKDqR2EJ79ah+T+yWTRTOSXkj05DJgxjUz
	 qlIFgLg+m7Ikoe+SVUUbaeA6Dzm4BZkBhkEdczwypN+honNPR7uzERgszDC9G0qtHrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvfNQ5FTDVkjwgoQok7EkLoscfbfeF82B21ENE/pyB0=;
	b=CDku9/lonxFs1erCAcd7YqOJetylB9kYJbzLBNV7Pf+HmsOPHcciUObBCEa9nBPoM4h4
	 OFSGFY18vBPQJ4zKbUAGqgVeI8OXcAEWfWnPPWid0bgTZvcYT1PQljLvsnu6jRNCTc9eg
	 WHohC93A/SdKEvidZw+xoK+fDS0HdmhmkQV6pk9PKW7h28Oi/zOz7GA3QFPEfBCQdpMY7
	 6L0Uxdru/CS/PgPoJ+0+vQnQm7vvAxvE40FbZkouaotU+gFE2U5KWOpReF+x6QGgPdMSp
	 /tT+7reClIijPCBsGg3BVGzNiP2FQGAOr7yUnV4WVPvDKF7Jgy+v+J989NBrSsHCypQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNJfWET8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D99606B2D2;
	Wed,  4 Nov 2026 21:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNJfWET8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E0A1F0093A;
	Wed,  4 Nov 2026 21:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829596;
	bh=rvfNQ5FTDVkjwgoQok7EkLoscfbfeF82B21ENE/pyB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNJfWET8/ZdC7TGurfnQhf1RzZq3xlV3LVVHgPexKka5A44y6rrpRGvB2LkzsvzkU
	 rMojU/V7omSdb9yqYxaqe5YSUN4NtAv77OEUsLa6BsFZJ+danJkEeNAGIAW7ibh0WP
	 qpd5tkkqeDMIMWo1M9gqUays6cl4fNpQeZIYjxLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0218/1005] net: sfp: add quirk for HORACO copper SFP+ module
Date: Wed,  4 Nov 2026 15:59:11 -0500
Message-ID: <20261104211049.923766082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 1bb028baab541900d3603d4f93c1c0fb5aba5401 ]

Add quirk for a copper SFP+ module that identifies itself as "OEM"
"HC-10GE-113C". It uses RollBall protocol to talk to the PHY.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260719100158.874882-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index af43530ffb2c3..195468bde2f29 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -576,6 +576,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_F("YV", "SFP+ONU-XGSPON", sfp_fixup_potron),
 
+	// HORACO HC-10GE-113C uses Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("OEM", "HC-10GE-113C", sfp_fixup_rollball),
+
 	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
 	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
 
-- 
2.53.0



