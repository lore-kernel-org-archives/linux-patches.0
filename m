Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C77D3438B7;
	Thu, 30 Jul 2026 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425959; cv=none; b=BYgY76ckFjaWbWf6njYWZ0yEZlqZDPrukinN6G/1IKdaGPa4Pl3oz10w4YjSxhwM+QrHbUtlgMYpEHxKy60JD+k2XZdApiDVkOHKDV9p2zuuVAyu0/RtCUFGuUFC8t8TCQQNRQ52+y4gdHHFP2aPbNM1pdUk+i64kOZqH5Fa1cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425959; c=relaxed/simple;
	bh=+ve9j6TdnOtlPatzNu/t9xcUovWseak9aGqYXcrbqck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQPU9+uH9sm49hKjfVcWbkB3WYdMl7h2I0r7CeH9BdJ8oWBUuX16ZyrfRHeRARNr0DbK+YThcpvnyIBUzHOwLC1ucEKu8FSraPGWSs71Gkc6bclyeLWFqLQbECpHml+yeEd2bNr8ihUkotIp2slLRId/jtz5cZwALkSY7lAU6tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr7d+rQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr7d+rQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6366D1F000E9;
	Thu, 30 Jul 2026 15:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425957;
	bh=G3m9SQ4ba71ZjZOnwoW5S7bC+LzuuNKmVGsyzIMLMU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rr7d+rQ5Zwr3Ink/4aSn1V4t9kW60/sNDG9G0bjqFU1KTGzNUwx4zd9Qs2OimpTzL
	 FIal8ef6QOP+9yNBgmh+WTF6rdVTdNPIcpachpYMN0PhFhjfTBpOEizMARgE8SHMoJ
	 2AEDUSoByOe24uvj0vql9LnkUrUFAJkjL+McBNi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 6.12 251/602] drm: renesas: rzg2l_mipi_dsi: Increase reset deassertion delay
Date: Thu, 30 Jul 2026 16:10:43 +0200
Message-ID: <20260730141441.245526526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -238,7 +238,7 @@ static int rzg2l_mipi_dsi_dphy_init(stru
 	if (ret < 0)
 		return ret;
 
-	udelay(1);
+	fsleep(1000);
 
 	return 0;
 }


