Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11937FF6A;
	Thu, 20 Aug 2026 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239108; cv=none; b=FiXe5oUgJ3xVtJYNFdlZK0h971bNYDnRwpx2YD01eCzkBDBE0CkXtArLy1y2P5f3dv0pLpsfAyFicOqpYQRKhrRwCRg5wL59t2TdkzFtRkK+E5reTW4yQJXY09/Qia7librrg2lBla+a4///LVcxrin5mjvMnSSYKlN6txtdzlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239108; c=relaxed/simple;
	bh=l2MIl3xT7mzOkNJpc/tetIdoXb0bS9SlP1BY9nw1zvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z44c8dDku4xpJ6jSXTH6RdmV+eVXzb+SwBCSxQZTTAHgR4PGs5e3qZ3ZtnQURymInb4PHaxfzrNLLamwS2OTyq+bzKW0qID1NN/fKt/yoasiWYs34BW9AMTTCX3ZcT+PJkj1PnN97xSA02oRa04uMA/q+9/TZgp6dSFcmAHupaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXc9dYee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXc9dYee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871BA1F000E9;
	Thu, 20 Aug 2026 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239107;
	bh=V4vxsIz/Um4DBanUKiSlsIZl5Je7/vnK45ADyyWa3JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXc9dYeemM6GaNDh1O5G999qUv4PdAZ/dBgHkD2s0uPLwFCKiOJeQ42iuibMd82Ny
	 5+2C956nwcAmR6nq/eWQBghOUvwcmodYk6oTLR4q3D8OUbnywxbjymAcatTL2KLUp9
	 2LSwZO/raDa2WfJ4UawCu+tTAnY49Jdu4LXQRw3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vincent Mailhol <mailhol@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/217] can: rcar_canfd: Invert reset assert order
Date: Thu, 20 Aug 2026 16:55:19 +0200
Message-ID: <20260820145242.299347166@linuxfoundation.org>
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

[ Upstream commit 41c13eaf39932fc79aa1ac245a9b97090fe23d5e ]

The two resets are asserted during cleanup in the same order as they
were deasserted during probe.  Invert the order to restore symmetry.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251124102837.106973-2-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: bef9004c5b91 ("can: rcar_canfd: change the initializing flow for clocks and resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -2202,8 +2202,8 @@ fail_mode:
 fail_clk:
 	clk_disable_unprepare(gpriv->clkp);
 fail_reset:
-	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
+	reset_control_assert(gpriv->rstc1);
 fail_dev:
 	return err;
 }
@@ -2224,8 +2224,8 @@ static void rcar_canfd_remove(struct pla
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
 	clk_disable_unprepare(gpriv->clkp);
-	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
+	reset_control_assert(gpriv->rstc1);
 }
 
 static int __maybe_unused rcar_canfd_suspend(struct device *dev)


