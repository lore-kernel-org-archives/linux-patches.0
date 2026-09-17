Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FE050256E;
	Thu, 17 Sep 2026 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667309; cv=none; b=OGKO2CmClE7ohQGtpuXrVZoImJutoJNKkQxOZK8XWcaN/Et2KBo9pyR2XYiFKrkfq0xBmN+ZTaVA9qpkeFfNoi2KJq338uLixztgIG/s5aaXlPjPydMLUm7phUocVujpB1zXN1S1dctxn50RdsgmtqoiEuCfhicjl5zjzWjyQ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667309; c=relaxed/simple;
	bh=tiZ9Oqjje30sYdLFbwj35WZ5z0vyfJGMulXpd5cwrsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2/6atdBYwZnMl0HNiunINGSbZk2pCuKsdhYXM3eyUdPmC9yhsPPEGTn5vbWLMMfJffaxlwkBJQCZABkx4lup5vLaihvf7Yeb1TVbxmlbol9IRRJiJrVmfnuYD6r9MvIprP8sO1j5rXrntYPO3Y9WkFgjv47kwTxjCe02Tc7u1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gojSxty3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gojSxty3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16C81F000FF;
	Thu, 17 Sep 2026 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667307;
	bh=doy0V54WuqgPU6ET/yRm1PM6t0zp5keJVQ4KZ2/YxN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gojSxty3ukv0rLusEmXAxBiVhuSISKg+ORxfcKGD4NtOwoOpZfvDTUt7RDfaCVvNs
	 m6OtkumGHXAXVCB+GzV7yKHxuRQF0rcBA0e2IfYqtLVpdvkmfVV28QDb6t+E50IEh8
	 6i4qfDf8qBU2FRct6Jqkw9vVs49uol0EuiDVtleU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0011/1102] pinctrl: renesas: rzg2l: Handle RZ/V2H(P) IOLH configuration in PM cache
Date: Thu, 17 Sep 2026 15:59:14 +0100
Message-ID: <20260917151539.706448294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit d0fc9f8eb2ce55eb00dbfdc0f19c844df5aee5b8 ]

Include PIN_CFG_IOLH_RZV2H in the IOLH capability checks when saving
and restoring pin configuration registers.

On RZ/V2H(P), RZ/V2N, and RZ/G3E, the IOLH configuration is defined by
the PIN_CFG_IOLH_RZV2H capability.  The previous implementation did not
account for this, causing the IOLH registers to be skipped during PM
save/restore.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260413182456.811543-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 6fd79907f17e9..585d6ae7aac59 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2898,7 +2898,8 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 		}
 
 		/* And apply them in a single shot. */
-		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B | PIN_CFG_IOLH_C));
+		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B |
+				      PIN_CFG_IOLH_C | PIN_CFG_IOLH_RZV2H));
 		has_ien = !!(caps & PIN_CFG_IEN);
 		pincnt = hweight8(FIELD_GET(RZG2L_SINGLE_PIN_BITS_MASK, cfg));
 
-- 
2.53.0



