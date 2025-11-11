Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD670333443;
	Tue, 11 Nov 2025 01:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824558; cv=none; b=bI4u81GH6FcFivnI6Lc0JZ6nZVIHQiyBCb61bnYINvpKQdncJ59ZqNUulPCEM2zNtNjvyXeBM4VrqvF+sP1M4y4D/L8vBjjplw9JXvtv3J0EMbGHhcQOAQKYLrVsJKISeskqTaVq75dFC/ru2HF2z0Xsn/GENqNjfmvfQXVqrsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824558; c=relaxed/simple;
	bh=DyS3yffyA6stIZ9z8vyBlZw2hmz//Eg58O/3dPc8U1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWDiZhlBfnVJ9ZZ4pkBd4AELalXPtxCXHcWgkoVC4haK2lej1V9qYsC5jPGF3oEOB22XwDk6eNJ3GEitsib7vrryPttyBy6gJbe97bQzKBGTP5i1AYx44PxDLURJTWnXyn+ZXmVaYi8Bw4PirclZD62MTqR2t1WbgpCKvJY/TLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2Fii8MR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2Fii8MR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585F4C4CEF5;
	Tue, 11 Nov 2025 01:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824558;
	bh=DyS3yffyA6stIZ9z8vyBlZw2hmz//Eg58O/3dPc8U1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2Fii8MRggXn+ZMbn/DRhUin8Q2EYvB801QpQ0aLg81HxG33HQwagpqOFQ2ZtrMuu
	 xr4fvAHIdDk/+eKfBzKCVvb/pN2r1KDSTcVqeU7qg3Uj1xXyk66JbkbOdwFPPZMyug
	 ugW7LzV8joRMrcNBoWy5dVFNeAOu4757R5+ksSrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 469/565] clk: at91: sam9x7: Add peripheral clock id for pmecc
Date: Tue, 11 Nov 2025 09:45:25 +0900
Message-ID: <20251111004537.455608407@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index ffab32b047a01..740f52906f6b4 100644
--- a/drivers/clk/at91/sam9x7.c
+++ b/drivers/clk/at91/sam9x7.c
@@ -403,6 +403,7 @@ static const struct {
 	{ .n = "pioD_clk",	.id = 44, },
 	{ .n = "tcb1_clk",	.id = 45, },
 	{ .n = "dbgu_clk",	.id = 47, },
+	{ .n = "pmecc_clk",	.id = 48, },
 	/*
 	 * mpddr_clk feeds DDR controller and is enabled by bootloader thus we
 	 * need to keep it enabled in case there is no Linux consumer for it.
-- 
2.51.0



