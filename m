Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4503334F27B;
	Thu, 20 Aug 2026 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239111; cv=none; b=Hpk726boDLqq6ysSzSm6au73ACqPyAauxUgfHVrmVB1YTiEWoL0EB+JvSLjraOH0AyEo9x+bzXOicGydbajaO1IUYgbmGfMeYQnv/kFzbw0/5p3K6VYMnwy/3tXDLO2CjR3e30xqPSeJSj0vx7sMscvIg+tRIyuIQ5wo+1J56rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239111; c=relaxed/simple;
	bh=fBt3r/CFwwPd2ue92x2vsgkNLmFXVzUH7kWYlWBUBzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWnUd7YI1jmCPAZwkPraXamfX6dmzbHp1gHrXimpN6B3ue0Ld8ZKpUmwEq74Jf1KyJEe65wnTnaNPgzlEpuI5wK4oIE7z17rwJfcRv1QbAbqc1m7rNh8F74fvWQrZuOKuJnyFPgPv3HBmZx/bE8r+DemEhK67AibWBv42ZdLlxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mb5lEUC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mb5lEUC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC2D1F000E9;
	Thu, 20 Aug 2026 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239109;
	bh=6cD90Q+nA4Sx6nGnMIB9lZBVQVefinuqmCQOMFfKAjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb5lEUC46T50zxZtk3dE3iViryPvvH1FVrMt3z1Pioop/JleXB7VZMfX8Ux1kDbsA
	 ZC9voLTuWjW3q3dIZkMmvsp9K9z8N1mwRbL/nGTuYlijz2Ds4RDeN9tR1V32fToy03
	 CFCacMcYtaG8m735Mr0RVV7qi8uXgVkVSnVxGcuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vincent Mailhol <mailhol@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/217] can: rcar_canfd: Invert global vs. channel teardown
Date: Thu, 20 Aug 2026 16:55:20 +0200
Message-ID: <20260820145242.328623173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 790ec4c453890f1221ea595674a1206bbee41dc4 ]

Global state is initialized and torn down before per-channel state.
Invert the order to restore symmetry.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251124102837.106973-3-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: bef9004c5b91 ("can: rcar_canfd: change the initializing flow for clocks and resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -2213,14 +2213,14 @@ static void rcar_canfd_remove(struct pla
 	struct rcar_canfd_global *gpriv = platform_get_drvdata(pdev);
 	u32 ch;
 
-	rcar_canfd_reset_controller(gpriv);
-	rcar_canfd_disable_global_interrupts(gpriv);
-
 	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_disable_channel_interrupts(gpriv->ch[ch]);
 		rcar_canfd_channel_remove(gpriv, ch);
 	}
 
+	rcar_canfd_disable_global_interrupts(gpriv);
+	rcar_canfd_reset_controller(gpriv);
+
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
 	clk_disable_unprepare(gpriv->clkp);


