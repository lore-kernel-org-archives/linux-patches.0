Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0440963F;
	Thu, 30 Jul 2026 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422209; cv=none; b=BoD+s1HoVJh6Ww8Z0cHBVBdlm6y3uu+9LYYty9+4IULfIDZvYZ7HxefdZrdagOrnEcAsNSyha0qAiQ8MEpI9jmDC9n4B33h4XCq2n7Ef02KV9DkXMUpbvgjzjCkQhotnAReixXL5Bo2yTtn8/kTGnwTcpubMNYQSqaAKaFPUpAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422209; c=relaxed/simple;
	bh=dfYX5OwP485otFWSejc5o+sY5PIgaUgelt9FSzsMQSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCgF60ZQhW5Zu07EpGUAfUef83jMR/Q5j+RIG9IgKqzbZxUoEH2KXS5TMbdmVTfLMxSjk3jRevSPBFN/Lyqf8tYq2cPJzkRTITaNFY1E7JX2+r1jU/GnmHHXWZwNTCapwu5zN78YYOeyHeTMJdmOHkdi11ZoND/KktZl9+yEN6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UB9ZDY4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UB9ZDY4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4391F000E9;
	Thu, 30 Jul 2026 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422208;
	bh=Q0fT3IOopQDHYoebTNj61/l2QO6GKaW+ZMoUIA/x8c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UB9ZDY4I6qPez3grs8os+20YEtkAXU1GXYHA7lC5y4w8DBBRBfKa8F97YEGyc5tNs
	 rFEQn9b0v8sJU5uuiBbD+7GDziVQcQPbno6au4Fgn0b+0uu+n7wUPULbZWZ9W1qbO7
	 WyFIJxNHjI5++rbyd69OEIwsuycDL1Ar+kCmRNJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 7.1 359/744] drm: renesas: rzg2l_mipi_dsi: Increase reset deassertion delay
Date: Thu, 30 Jul 2026 16:10:32 +0200
Message-ID: <20260730141451.916604240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 7cbba8a8ba0219a267844d3116dbc77cecb4fcf8 upstream.

The RZ/G2L hardware manual (Rev. 1.50, May 2025), Section 34.4.2.1,
requires waiting at least 1 msec after deasserting the CMN_RSTB signal
before the DSI-Tx module is ready. Increase the delay from 1 usec to
1 msec by replacing udelay(1) with fsleep(1000) for RZ/G2L SoCs.

Fixes: 7a043f978ed1 ("drm: rcar-du: Add RZ/G2L DSI driver")
Cc: stable@vger.kernel.org
Reviewed-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260330104450.128512-3-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -528,7 +528,7 @@ static int rzg2l_mipi_dsi_dphy_init(stru
 	if (ret < 0)
 		return ret;
 
-	udelay(1);
+	fsleep(1000);
 
 	return 0;
 }


