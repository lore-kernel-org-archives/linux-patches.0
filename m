Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A34432B116;
	Thu, 30 Jul 2026 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424351; cv=none; b=HI9m66uEE5U1x3ZCrHnoJo4bwtrXfIjQ3A63xKBIumetf6u6esXMSQdDGs/Bjo6vOWtAW2pEnOprWshHThHXAIhuAjieuh6joUu1DXg0thyLkRyl9fnIviHAbsAudAvsVA6b1PMUSxA6X9WaHhj8Sym0jGyHic3xAQZjhETGB4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424351; c=relaxed/simple;
	bh=HADG+iT/e5ugPsuKEi09UfnE+0P8LY3hjQjZjuMx2Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0fXXlPB0H0Qp7O7FJpOt0U286lWdsmna3IMflbvGlywsBrKPRbgYsBQGQ9BmsldU3NPwDr5xrZZzOA94uykItCC6JZ8Xb2oiQhXOnkbepirdpOMuHZCDI3LuXazdYhFkkzvGT61n/kbmv5Ypic0wG2CQVzJLdznFScLxj4lDyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZGwYr4v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZGwYr4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D524D1F000E9;
	Thu, 30 Jul 2026 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424350;
	bh=eHyCb+D2Pw9jErGFe9J9gb8/SlSd1bbHpi0/iLGqKMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZGwYr4vMngzrlEw3Di3MxEAWkaXWyylnGMxL13FnJhhzMQfv3n8iHk0gI60KA2s7
	 GZQD8Djt0l8WVNalS0soUTLgxacVS9w1OdK0XTwxPDRyBB9ijLmpoqBjrcdGodcRb7
	 3/POz8Bd5YNShXwQR1Z1uTTTUbYxWFsXlWzF5o34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 6.18 318/675] drm: renesas: rzg2l_mipi_dsi: Increase reset deassertion delay
Date: Thu, 30 Jul 2026 16:10:48 +0200
Message-ID: <20260730141451.886068547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -272,7 +272,7 @@ static int rzg2l_mipi_dsi_dphy_init(stru
 	if (ret < 0)
 		return ret;
 
-	udelay(1);
+	fsleep(1000);
 
 	return 0;
 }


