Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D3432274B;
	Mon, 18 Aug 2025 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523929; cv=none; b=Q9fcKTJ0yF8z5shpn0gEVHjQgD78TGrW8RTsH6+GcRHNeMfVIDAHn6zwRl8BdHeoR1uPr3Sa+KPHF1bIiU2Iu/SFOuIf71wtTqGCOwS6P+J6aLPKFhqXuM96fURYVsxx4t8DYmyGls5wJzMZrI5rH0u5yNS+k5fZHnTOD6JfZas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523929; c=relaxed/simple;
	bh=PAff590vJRw8ScjbHkCkmsAMKefD6vw0zUyjzOXRvU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7fNoWw5Rm703NQQlOIfncyFoOQryJfIjPRMRZw/Ofyb0DsdAppINxg+ILmg3KtAR27Yg2uu10wbvvCMzBpwDFOIcgyuYSMW4x4b91O/GsIMuK78KGBNmHTAuV+fEcJHmZzg4hDgxWinF18CmmA9rO/XN/JSfZ63m1/i0RuG7E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvveJjBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvveJjBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11360C4CEEB;
	Mon, 18 Aug 2025 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523928;
	bh=PAff590vJRw8ScjbHkCkmsAMKefD6vw0zUyjzOXRvU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvveJjBJcHDRRIeY2atdIlsuG3ob74mhR6MM+JwMw0ho/iHF4R7iFn19ZAGJdqsXO
	 xTLHkSH6cMVF1CRTUK8DzoEfPHel6nUPW7XLfOWit3ze6bcCCmWjAbTfF9pvd3ASdq
	 emfS5ThA/XiPigZY9C2Y5bPFJgryLwNmPuEfWoA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 315/515] drm: renesas: rz-du: mipi_dsi: Add min check for VCLK range
Date: Mon, 18 Aug 2025 14:45:01 +0200
Message-ID: <20250818124510.561007800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
index 4550c6d84796..ec8baecb9ba5 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -584,6 +584,9 @@ rzg2l_mipi_dsi_bridge_mode_valid(struct drm_bridge *bridge,
 	if (mode->clock > 148500)
 		return MODE_CLOCK_HIGH;
 
+	if (mode->clock < 5803)
+		return MODE_CLOCK_LOW;
+
 	return MODE_OK;
 }
 
-- 
2.39.5



