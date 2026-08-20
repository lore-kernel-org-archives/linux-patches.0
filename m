Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8E946C82A;
	Thu, 20 Aug 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248541; cv=none; b=ZEQrgWHtENGqOgAatWHhcJb+5/y615qcVDRigojKsGg2Ojw7x0fs/jsKsg0WGsWXpAoBkWoRoWfHq+R6CDb/0fViqRlmjL6rN0xFi6HGDrxaX4zmJQDGRKOJAtzajS7Jrg0oF3Hq5ZiWthWHQAqplMKYqM18LnfyHGZKIFNRTPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248541; c=relaxed/simple;
	bh=d7+Ss/gWpHWl9GzYMk14FOZ8nwM7pl3ltPik/tM/M8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHy0x63/A6YkmmPAWuwfCBjyT/w1vdGcIl6vBT8uNl7eAhtFPFTdH594mzLc3LhXd1JYumXVHCuJqQJGHSUDsVE98swt30tf44UNIFK50QIPovitEipQw5PfggbCO/edEfgdFpnlGu9dNWVowfZIC0G5MU8W6Fs5Jo5I5FpDSFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xn2Y0yGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xn2Y0yGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A611F000E9;
	Thu, 20 Aug 2026 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248540;
	bh=0rhqA0kIVOruBjqGcIib41NYAhkyF3okMMtq1e6gQPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xn2Y0yGFXL5QK7f7JS0WyHWkbrvZZ9d1//0w1fHoUROPdjd87VwhZTeoyV4CxVLTb
	 XqZT3z7KYgLerb33X76HeSdg1evoRTE+Ao5FP7hG2YQ6PKkFXis3RoqjVDbRmKjvuK
	 0FC1mWwrs1biUvH9/SNvHAlssxjPzA3gutlJmMYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vincent Mailhol <mailhol@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/303] can: rcar_canfd: Invert reset assert order
Date: Thu, 20 Aug 2026 16:56:38 +0200
Message-ID: <20260820145301.321136483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2035,8 +2035,8 @@ fail_mode:
 fail_clk:
 	clk_disable_unprepare(gpriv->clkp);
 fail_reset:
-	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
+	reset_control_assert(gpriv->rstc1);
 fail_dev:
 	return err;
 }
@@ -2057,8 +2057,8 @@ static int rcar_canfd_remove(struct plat
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
 	clk_disable_unprepare(gpriv->clkp);
-	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
+	reset_control_assert(gpriv->rstc1);
 
 	return 0;
 }


