Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580E74E5347;
	Thu, 17 Sep 2026 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664124; cv=none; b=KT0vOqRvZsjr+TrR31bIp7FrnaUC9QQ61X6IcdtZWokKMYHu0HpjMr9FfGUzuUwQHrIK+8SQ5G57/W1L2v67ahOwkBtuqSTuRatTqyHBXE2Xk0RSJpW7NKOlcemvK7ED6TbxR5TZfLN+A3c3GC/KRl6HLnTLUZ0t9nS6a3w6Teo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664124; c=relaxed/simple;
	bh=yRrzs0fV5MsaOLS4bUMJZTbnor1ICDqjDBOj3p3AluM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2niJ3gG1NNZXRT7fmcckiGsYPio3U0Sl90f9TOuL5SQ2WVdjHOeBPM+BM0g/YxqPjYn5ZYk1/NnvYlqFYzC4XrZIL0BgKglIMvteARosv2Vgur0++nKRcAz9HJGPXnZpeURyTmy+e+7WVepaHye9v8Gepv03rM9xmBWAx1PvOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTDW1E+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTDW1E+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF271F000FF;
	Thu, 17 Sep 2026 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664123;
	bh=kg7mpfvgZ0k+I8rlUaRBOPiL3kXsMoNZQ0t2EWnZ0ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTDW1E+mBuyetMdXK7S21OFLoI38RWFf6zQJl4Ton7od2/OF9u2ecGOE/H/3NeRcJ
	 NUh7yk1OXaThYtyOX2NhKOc3dw10qhg8/N//vYbP7Jo77fKzs1pEGdJ85ohkQJ5bTF
	 KuQMkIM1WDzZ0X5v3A0b08cMbe7o7+M+dWdBc5zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0268/1250] mmc: renesas_sdhi: Add OF entry for RZ/G2E SoC
Date: Thu, 17 Sep 2026 16:01:03 +0100
Message-ID: <20260917151559.406064529@linuxfoundation.org>
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
index 8bc1c3209edb0..6cca38e32b991 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -280,6 +280,7 @@ static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774b1", .data = &of_r8a77965_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774c0", .data = &of_r8a77990_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
-- 
2.53.0



