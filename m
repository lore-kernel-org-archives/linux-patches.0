Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4035A433AD;
	Thu, 17 Sep 2026 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660910; cv=none; b=ODqZtPY4zC4y9F0JApmo5yU84KqS7W1B7LefaVWLvXDYH1C8upN1HsCyh8dgPWIoiOC/R2Qtp2jAfnlzq5hYKwmFKaosaTpaIkiTy0qHiHG8nGmDHCHoAvAKBpWER42/b1OQfWCGG8c2nZsQwXSiRLO2vUTF/qUW7tkTg5wPrrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660910; c=relaxed/simple;
	bh=mI7Mo/t2FhrZFNs4UTDD8JYgmKU3dnlHlzKEqjnU+R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOd3ExUFzHlCQLb1TK75nqdZGB+d1VI2p+zNGUzBbIykU8od9FfsM9FFSjmQlzDRCB9ak15hnuAwueZV7zpjregpAAXzLfKXDXIaLv1FKUrDZCcKl7AVziTdbbQMvL7fL064GzaoGj8UwrBx+0iWWKJkrFHgSwgpXBTaDb4K16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmArxbig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmArxbig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2551F000FF;
	Thu, 17 Sep 2026 16:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660909;
	bh=ct/yZ0XGViPFnlLJM0SXFo7CrU+qc//KID09yzokKoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmArxbigdVGujrE0NH0py5EaFPPJNQHRli6BgkN0OFOFCCdq5OaYSbRy3V9gNZf2J
	 +iSzVlAzYUVUcFetNZGITk13BTb5Ybd+vBpEvc5m+g3qXqbSx5kUgvBektgj5chbkg
	 a6jJo0DEriTvPPWFkVZWLy9o4uATJXo/nFbGa5B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0019/1250] pinctrl: renesas: rzg2l: Handle RZ/V2H(P) IOLH configuration in PM cache
Date: Thu, 17 Sep 2026 15:56:54 +0100
Message-ID: <20260917151552.450586671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index e8cc83029db33..ab8d64a14dd0a 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -3094,7 +3094,8 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 		}
 
 		/* And apply them in a single shot. */
-		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B | PIN_CFG_IOLH_C));
+		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B |
+				      PIN_CFG_IOLH_C | PIN_CFG_IOLH_RZV2H));
 		has_ien = !!(caps & PIN_CFG_IEN);
 		pincnt = hweight8(FIELD_GET(RZG2L_SINGLE_PIN_BITS_MASK, cfg));
 
-- 
2.53.0



