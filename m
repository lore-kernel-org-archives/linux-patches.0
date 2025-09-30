Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8751EE02F;
	Tue, 30 Sep 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244524; cv=none; b=Y1Mm4M2TpcGlSSKxCUwcjeW2OkCSrnw+uXXq4GKjAoNwDuPEAMnczYlZEI3s68wqe5+bd0z6M0f07X2gVlhD4iwAhZl/zUmWr1j3EyfDPuVmbeg43R1GvATPg8sXvjSBRpLLGhk0/r1QFiBg3KIx2PaIwgQUuhFLIKTZm4IGTiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244524; c=relaxed/simple;
	bh=oZIHfvlOtEjIHBUfePXny7msNNJ1IDeM0b5tj+xyBH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbNKwKiJn4ANR6Ok5ToE0jmP43/322PCZQvkRFbTL2qrNzCFmeS4ZdiZ4N5MJU3tNnJ/P/q7c0Zoar4Ie2cbWz9z8EhajtVsw7KLJ0bGbDFUlfbVaEdyGSxCP0FUmjWzlPZVcqiGuqs1QKrP4cqISDfLzY5TgBY7NDY54VpgTJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCryxWKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCryxWKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C60DC4CEF0;
	Tue, 30 Sep 2025 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244524;
	bh=oZIHfvlOtEjIHBUfePXny7msNNJ1IDeM0b5tj+xyBH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCryxWKK2BnsgxmCbI+JuEe5rY4Yy3bZA4VywTFgkX8YSREZrk2Q40l9DO5kEgvJc
	 CVspaPWH3+BNusGxOOhn01xlzpBtPNxGYjNFxA7FXRrz4OS/W5h6HDYKn5P3UgVQ3t
	 qEJuej/qBbKQmb0L1fmYxP4w5htoMapZsm+seAok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 034/143] net: sfp: add quirk for FLYPRO copper SFP+ module
Date: Tue, 30 Sep 2025 16:45:58 +0200
Message-ID: <20250930143832.602316552@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit ddbf0e78a8b20ec18d314d31336a0230fdc9b394 ]

Add quirk for a copper SFP that identifies itself as "FLYPRO"
"SFP-10GT-CS-30M". It uses RollBall protocol to talk to the PHY.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20250831105910.3174-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 5347c95d1e772..4cd1d6c51dc2a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -492,6 +492,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
 		  sfp_fixup_nokia),
 
+	// FLYPRO SFP-10GT-CS-30M uses Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("FLYPRO", "SFP-10GT-CS-30M", sfp_fixup_rollball),
+
 	// Fiberstore SFP-10G-T doesn't identify as copper, uses the Rollball
 	// protocol to talk to the PHY and needs 4 sec wait before probing the
 	// PHY.
-- 
2.51.0



