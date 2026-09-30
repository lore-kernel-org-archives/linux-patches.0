Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D9F4FB9C6;
	Wed, 30 Sep 2026 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784352; cv=none; b=iCG4z6qw5jTfzSfbpZt82KYLNH1IFdkhhscvanyx8WnOTRjVlY+Bw66bTOqFDAgbVJ1dcXmSp0uZmTdQhdk7eTG/8WbC7e77SfkfDdBn8eOL/4llKL3kbFLOf9fvuRxdDEl+idnFK/SpNHbkl6BrtefLrTEW9aVtNMPTKHkFG2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784352; c=relaxed/simple;
	bh=h/j0kQzuvfD1aBKl833FeG9O7LzSDtWooI7Ty8Tc7Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmqNevw1Fz8XPWl1JpogDwilJQn0xr0C05JNotkApCFCRZEGOCF9M57J3hV+BhcDxo7o59bUJzkH5Gj25ST3gTXSKSCSKnWJgwnZKvW9kgM/CGhIgdnJ3DSA0EvJt54dfNqp2fvTHuNplV94Wz1nMU8Zmp4hSTpxi8IEZem7+S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5NOeUBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5NOeUBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E831F00893;
	Wed, 30 Sep 2026 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784349;
	bh=T6izrYRbr0HTFDqsuyFSbVujfIw2WHl1oqQvfod7AQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5NOeUBWpxq6Q5C7tknoOing8AxErFi2qX6Ih5qcqU15kIF2j0W5O5a12Vo3OmuvD
	 WzMAAyhiBh2PQLXXJ9Hy05r7/3vR4rz+wQE15+egt0O94js1czLSa0JBb4ltQmiMYu
	 K7ilsVu6jNJF6s0kVlUzJdX9UGpYEMF5LI8PxdVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/982] mmc: renesas_sdhi: Add OF entry for RZ/G2E SoC
Date: Wed, 30 Sep 2026 17:14:21 +0200
Message-ID: <20260930152419.501411274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit ebf7f2198ac4817bd2929cf83c697cefa8bf36a9 ]

The RZ/G2E (R8A774C0) SoC was previously handled via the generic
"renesas,rcar-gen3-sdhi" fallback compatible string. However, because
the SDHI IP on RZ/G2E is identical with the R-Car E3 (R8A77990), it
requires the specific quirks and configuration defined in
`of_r8a77990_compatible` rather than the generic Gen3 data.

Add the explicit "renesas,sdhi-r8a774c0" match entry to map it correctly.
Note that the DT binding file renesas,sdhi.yaml does not need an update
as the entry for this SoC is already present.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 20118b3c428c9..e05ac6475899d 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -270,6 +270,7 @@ static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774b1", .data = &of_r8a77965_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774c0", .data = &of_r8a77990_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
-- 
2.53.0



