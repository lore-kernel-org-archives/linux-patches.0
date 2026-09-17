Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDF24B7A30;
	Thu, 17 Sep 2026 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664116; cv=none; b=pDy/LRn0HeOPYF8eBA2pgXkB4TTquKLgYhbt4FJJgaRc/s+NVJWuPkNHvI6xnbIkZ7MN2xdJ2cDRSuoWH5MWQzebC8ThdvE37TvJJimNQyR3Umv3J7Fl36r1Ugadcv3zl7DGxdj2teZYnxR1Cl3+xwg7NTdBv1RItmMNURmo4hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664116; c=relaxed/simple;
	bh=CvEQxHAXu+FSR6Mhuby8XbFKm40/iWwo7ciFMuvpmUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn9xBRrrtuwHfVA9mDa0VVNrfXJUg+O6Bn2OAZ/ExU9qG9UEJR2P6XCZ69Lesg8ymEZq85fs0l78I8simSQFQ9x1DMO6GK1b3+9gOAg5Kp3TYYlVMxA9bKQaixvuoVdQMrquzHL6z9geGN5r60D1a8JB4KR2X9gogcsqHwlzexo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aH18XUee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aH18XUee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB161F000FF;
	Thu, 17 Sep 2026 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664114;
	bh=oJhtjkHVy5P+UDVzl7qnKMcIurDfvlBE4UcCW9aM7ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aH18XUeekEvipfv3MUovKwvQngb5mcDdTRIxNAb5Tg1xoj9Eei8KyJ/727M0brJZl
	 acY/eqxIEQHPiJWP6d4qCx4xfmFH00pm6c8Yaga0LFQpZeum6F3tZWRLQt6qJqr5U1
	 E5AiweKYzXIGn/MLVDuiuIMHiZ77A/+3ZZfe+3OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0265/1250] mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC
Date: Thu, 17 Sep 2026 16:01:00 +0100
Message-ID: <20260917151559.329824315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 5ce500d31a1625d8fe7ede950201b8df076bdd48 ]

The RZ/G2N (R8A774B1) SoC was previously handled via the generic
"renesas,rcar-gen3-sdhi" fallback compatible string. However, because
the SDHI IP on RZ/G2N is identical with the R-Car M3-N (R8A77965), it
requires the specific quirks and configuration defined in
`of_r8a77965_compatible` rather than the generic Gen3 data.

Add the explicit "renesas,sdhi-r8a774b1" match entry to map it correctly.
Note that the DT binding file renesas,sdhi.yaml does not need an update
as the entry for this SoC is already present.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 6816d491b0bf0..8bc1c3209edb0 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -279,6 +279,7 @@ static const struct renesas_sdhi_of_data_with_quirks of_rza2_compatible = {
 static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774b1", .data = &of_r8a77965_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
-- 
2.53.0



