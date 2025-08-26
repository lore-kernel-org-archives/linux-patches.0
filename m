Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04426770FE;
	Tue, 26 Aug 2025 12:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213059; cv=none; b=WWDrRlGKdWcJmUbtXUmPhSZeo1gdA6dv5VxUtpmFbu0vqfnB4YZHmA1AVwwM9TfaVYAfDnmEwzmb7KqtpiTifB/9g5cvNhYq3duU3lA8LL67L19uly5KIulhSPZmno1zegZq6HzvZLHHGVskzDZFjkbLkZ7xCHMBUdiYvqVmeVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213059; c=relaxed/simple;
	bh=3MZhzA+WnUAYAkVjj5Ye0FUc7Hg5l5qhBixpAHiAH5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7B4dimBcz19W0+AAv6ccRWa9C6hyRRdCoiNMnWXz3EIfIfPlnXsqyzls7yE84/Ud42OUXGFOi9vovyVFEhFCSFf+otVIl8LTV6Mv2b/PeP6E8MyHKXxivbuLU4Us+uyg+XggTaNAns5PnP5MXzIsoTJFbzSKIXGIdD+pGPue+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKbWY3Bh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKbWY3Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAB7C4CEF1;
	Tue, 26 Aug 2025 12:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213058;
	bh=3MZhzA+WnUAYAkVjj5Ye0FUc7Hg5l5qhBixpAHiAH5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKbWY3Bh54yl+BQ6SaA69ArjXKcSH08yloUACv0rNLCRCLq+19xETYIEXnH98xGEw
	 cmgEJgMGvueQStjUgsl6niMmR4oR3FIGVHgLAZ7nvRrrsJH445VDwt4mhjky3CYTKk
	 tR1nhmsABEaiaj7FkcQX0cUNovnidXMrYInzZ7hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/587] drm: renesas: rz-du: mipi_dsi: Add min check for VCLK range
Date: Tue, 26 Aug 2025 13:05:55 +0200
Message-ID: <20250826110958.178429212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit e37a95d01d5acce211da8446fefbd8684c67f516 ]

The VCLK range for Renesas RZ/G2L SoC is 5.803 MHz to 148.5 MHz. Add a
minimum clock check in the mode_valid callback to ensure that the clock
value does not fall below the valid range.

Co-developed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20250609225630.502888-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/renesas/rcar-du/rzg2l_mipi_dsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/renesas/rcar-du/rzg2l_mipi_dsi.c b/drivers/gpu/drm/renesas/rcar-du/rzg2l_mipi_dsi.c
index 10febea473cd..6cec796dd463 100644
--- a/drivers/gpu/drm/renesas/rcar-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rcar-du/rzg2l_mipi_dsi.c
@@ -585,6 +585,9 @@ rzg2l_mipi_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	if (mode->clock > 148500)
 		return MODE_CLOCK_HIGH;
 
+	if (mode->clock < 5803)
+		return MODE_CLOCK_LOW;
+
 	return MODE_OK;
 }
 
-- 
2.39.5



