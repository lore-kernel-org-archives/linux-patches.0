Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9329C38F930;
	Tue, 16 Jun 2026 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629773; cv=none; b=Kg+chR9XGQP+blKZgRZCsy3gel2xPqveGUbon9MuRevArlFprgl7O5SMo/FKnm+FnH87P56761XQq+82YNPhLLdwGfJLWe9iRIrNCpvikP4Nd8QBSRmhmtWSzMLbVPVqr9uvg1W7uCvV6b08jAClNTzLqLh6p2zvsolxRB/0a/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629773; c=relaxed/simple;
	bh=xOVUvbKhYB/zgWNOaFXH52OWafFNiH7dHlztSzmJ9rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tbpitcym4Ap9U+e8WYA6WJ+Bw7kM1GxgTbY7xzuOMN25ITX9ouxU/ZmFuB4qP9U8L2COGtN3lUxWc7ck1p1eVSrc2/yX54fUKFrbY+ARxs3HVAvAMOxk+UAuFL2YXKmYWh4PWKJS/RHJkqkHtZeEzWu+wkY1rJ+pyTZPeTc1y7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buoFIqDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buoFIqDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EBE1F000E9;
	Tue, 16 Jun 2026 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629772;
	bh=a6WXkRzfU2weOLOk/9B43I74VFbJiifMpXH3w3krKTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buoFIqDlIxmcfpZXbWiViv+GMYYWryWpcFzA4EIwwcMYfkFLji4ET9xOPRTQuqij5
	 mVs8cA/b/ih8Hnhw+yxb8bEal/D0nviN7ZCPQBIfVJsnjUAMab2R71pQLoIQJTNpAa
	 kWUkbZIQ/QYTahg2la3z4jVh7nm1rMPZ2zzOk4+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 350/452] mmc: renesas_sdhi: Add OF entry for RZ/G2H SoC
Date: Tue, 16 Jun 2026 20:29:37 +0530
Message-ID: <20260616145135.593699951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit f48ee49726ee4ab545fd2dc644f169c0809b19b3 upstream.

The RZ/G2H (R8A774E1) SoC was previously handled via the generic
"renesas,rcar-gen3-sdhi" fallback compatible string. However, because
the SDHI IP on RZ/G2H is identical with the R-Car H3-N (R8A77951), it
requires the specific quirks and configuration defined in
`of_r8a7795_compatible` rather than the generic Gen3 data.

Add the explicit "renesas,sdhi-r8a774e1" match entry to map it correctly.
Note that the DT binding file renesas,sdhi.yaml does not need an update
as the entry for this SoC is already present.

Fixes: 31941342888d ("arm64: dts: renesas: r8a774e1: Add SDHI nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -277,6 +277,7 @@ static const struct renesas_sdhi_of_data
 static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77965", .data = &of_r8a77965_compatible, },


