Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD7833EAFB;
	Mon, 18 Aug 2025 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525797; cv=none; b=N3IaAj0rCnfZc/r/rtv3KzbF8GrmfjTHhqYXiwDHobu4qvsmnouZtK/3JMhjhDUIVrS4CSQBHhdmBzj3b+aM1rDCbBtjKt1BmmNgDiegKjU9aW7GlulKi0/gZYWgLmG9mT/Pa7s1XU2HSdAqtV6LLxCsWrzyy67odJb3mZB6ShM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525797; c=relaxed/simple;
	bh=dV0+H/kyLZNQmpUd6XS2XjGD675gDe3vk77xwRie34U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEt+X46SX/qbaNL653rYOfQ9RDc/Dtq2MqZ2QHWFjSErUXqE73dmc95Ac2XB4eR3zCLvbdTNAZEnKxtSUiqyi+U1nikRXr8d6JiaJtKFCZR9QmfGM6pE1qjlM6usjHUrnw9cOtUeAnuNDEciGmiZdt+WEkhrDxCXlt7xW2tuyPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrck1OwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrck1OwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE05C2BCC6;
	Mon, 18 Aug 2025 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525796;
	bh=dV0+H/kyLZNQmpUd6XS2XjGD675gDe3vk77xwRie34U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrck1OwGlEwyL3tgybjV1KGCADIaJlvVFuaYFSaIJj//0og37a6Yk2HVjM1xSIqtp
	 bH/coahYJ0fwvAwKGjXoCNY/HbGwNpB/tZa4KrK+F4q6elEnF8HU4i/wHLqEjpGXMI
	 6Swk+Jz4jb9wCF+cb9b0noADdeGntDUefovcE/Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 342/570] drm: renesas: rz-du: mipi_dsi: Add min check for VCLK range
Date: Mon, 18 Aug 2025 14:45:29 +0200
Message-ID: <20250818124519.035279239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index dc6ab012cdb6..6aca10920c8e 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
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



