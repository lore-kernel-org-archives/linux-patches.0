Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501172472A6;
	Tue, 11 Nov 2025 01:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825210; cv=none; b=JsFJWlp9w57+SEC8FKZxT72zPVunlRA4wFZgEQjB3pG1Qej8V7Y+3A9ZaOByceFATANvVeSkNSjINid8HxpP76aPReQJzpIVb97ZFxjgn7Xf3A+4/VpG/x3QztEXpTQa9IGuTMloNtVPWGsjWHQ8V1XM2z8LfDj/oLJ55WvNRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825210; c=relaxed/simple;
	bh=vlLtZ39QUIOWUrAXspNPfu97SKFrBYbjt21cZS+YxSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgX0v18DtNe9lShpcbGapFtIorxahyTES9BVTVb2lAthkiNPFczFVIyu6yAj2Fc3tIBuOnQTAC/XT7Q9ll7q87GTahnF3yjtA92FLPaQEmZ07JulW4AzTLqQbiAClYXHpMBcsRjduCg/e4MTL6QllXRMWuwkryL7L0oW8YH7gdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWRp/B67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWRp/B67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FB5C19421;
	Tue, 11 Nov 2025 01:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825210;
	bh=vlLtZ39QUIOWUrAXspNPfu97SKFrBYbjt21cZS+YxSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWRp/B67KEbFW4C8VJg6S/yhggXqXFLYIljOqBEOr5SZ7Etu73qcYLjxN1bX7wo3i
	 z1gcreaY5gzpm2pAQhzlE+02RnAA1Wwn628QB9DiqO739BU3e7Bz2pcVWu8bOgYSrP
	 V4zPVRY58ABtj+NlXTHdJw4CpeJaBcGNm0eZS9Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 705/849] clk: at91: sam9x7: Add peripheral clock id for pmecc
Date: Tue, 11 Nov 2025 09:44:35 +0900
Message-ID: <20251111004553.479073346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>

[ Upstream commit 94a1274100e397a27361ae53ace37be6da42a079 ]

Add pmecc instance id in peripheral clock description.

Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
Link: https://lore.kernel.org/r/20250909103817.49334-1-balamanikandan.gunasundar@microchip.com
[claudiu.beznea@tuxon.dev: use tabs instead of spaces]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x7.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/at91/sam9x7.c b/drivers/clk/at91/sam9x7.c
index 7322220418b45..89868a0aeaba9 100644
--- a/drivers/clk/at91/sam9x7.c
+++ b/drivers/clk/at91/sam9x7.c
@@ -408,6 +408,7 @@ static const struct {
 	{ .n = "pioD_clk",	.id = 44, },
 	{ .n = "tcb1_clk",	.id = 45, },
 	{ .n = "dbgu_clk",	.id = 47, },
+	{ .n = "pmecc_clk",	.id = 48, },
 	/*
 	 * mpddr_clk feeds DDR controller and is enabled by bootloader thus we
 	 * need to keep it enabled in case there is no Linux consumer for it.
-- 
2.51.0



