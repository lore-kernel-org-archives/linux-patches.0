Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7954A50B417;
	Thu, 17 Sep 2026 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667726; cv=none; b=EKQDbEPbk+4YTYCIPc0pRqJO0yEI0cNbwfVKHLBcjCcIg2S8NS7sGAuhG1DV8hXOSMNarv5+kzvuKrHmPw6/QMyPhezsj7HtfPW2Au+Og4gZJEeisGKsiEQ3Yzlx3uE/eH6be89Xqah+D6r0eo9mvcQ8ORlxgm5eePoNne7DBIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667726; c=relaxed/simple;
	bh=SYjBg/LSu8mZB8SiP//64d74RQ+wVjYchRyqXCxRiYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy1PCoxIuPAK6zipPI1HDTxSfvUyZPrPe8yHe2mY6ireI6XFuDHo19UkjkmGjD8/JdJjLLubcf8VW1RdtNGvsg9M8ELMhZ+qAj2rzCU9hJ+4YrA6iAvzO/Jlp7jjD0W1Ls0jK/j+8kB6W6FFk4UUdH/18Pk78Jh3iqym9nNRClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jE14is2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jE14is2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EFF1F0089B;
	Thu, 17 Sep 2026 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667724;
	bh=EW9uo1zikGTF2NVca/g0i7BH94kyeEsgcLV7mFBK24U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jE14is2vHbmCO4k1lJRUiDHNjCqMhwtGsoo5u9/kBUlZoPogx/TQJHcakZugf5Ta+
	 hRA4J30gyJO8f24kTX4UkQnnj4FOt9Acn/Kc12MtNLPa7qMjwgamrAE/S6C4LVwocP
	 l2BJ+ddKWOyBp7I7kuHTjrJKbyFOjU5EpAat7B+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0188/1102] mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC
Date: Thu, 17 Sep 2026 16:02:11 +0100
Message-ID: <20260917151544.283978996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 2a145af4f8ae7..5ef84a36b2f75 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -278,6 +278,7 @@ static const struct renesas_sdhi_of_data_with_quirks of_rza2_compatible = {
 static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774b1", .data = &of_r8a77965_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
-- 
2.53.0



