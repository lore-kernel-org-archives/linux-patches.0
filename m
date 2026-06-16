Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C14346AF1B;
	Tue, 16 Jun 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634264; cv=none; b=PLEnfio+DJYoKqOEQD2ghNr+oQrxo4vFYT/+Xh9r65qc6XxUfPzcVJWwmrXiCfU2KA2xFFJflwv5xARprua+nOt8QBk4Gd7qAq5zAIGGl8xmXRsR9bePgSy0HkuQBBHquq+emcvZ5ubnkkZeTPwbe98C+6pJ2ZLMfgv9OkxJs8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634264; c=relaxed/simple;
	bh=cf/92yuffpGojz05p1pe4/wMczQwalnB5Lz9/XUqoFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nnz3+VNLoiyYGH7+JBQCrcmicZqJlnT37p9negsYxVaKxg2q3IIvk7W0Xle462Hjz9eZYwR9kkcZBIgFcTyE92gvMHP80heZp+kTfox6yLxQwvSkk3c6hiD6Oq09pVEM0Jfel2I0y3boX+w2EVUMBH8PksZnnQfc0ZbvX6M5UBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmNH9VfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmNH9VfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846521F000E9;
	Tue, 16 Jun 2026 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634263;
	bh=ZIUmRDxzl7LaCCMHXLreiT227SMIhq6IkSf1vsA6GsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmNH9VfMvQDI/FZUS/cFRnF5QRyDqwEhU3sfoYwftAsvQgvpSArIV4e5bZ6sxNM0w
	 NC86qVsG86R+HYc7RLpGrmibtoGULSMah2FxuM5mgwKNIlK28t3WUf7RdbTY2CXcTm
	 gVGmOHl8sy5m8eF/NRYzKpkgG8Bz1MgfkTeYtVZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 233/411] mmc: renesas_sdhi: Add OF entry for RZ/G2H SoC
Date: Tue, 16 Jun 2026 20:27:51 +0530
Message-ID: <20260616145113.218914401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -231,6 +231,7 @@ static const struct renesas_sdhi_of_data
 static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7796", .data = &of_rcar_gen3_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },


