Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370013AE1BD;
	Wed, 30 Sep 2026 17:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790848; cv=none; b=NgLuacg24599feHW8PmPNr4qnWBHfGNLigvEyJCfaf0/fGcYZhHrqTCt5gM5ixUyLS1U6yqGOFfC8BkDiWPqkRxp6ttIiFcGajjHPwk5+oFwZIdo+6g/RuFL4sevXoVCRVpmMtPtyW+vMUu7BoGXqgU4ttBAUhNIZyFkRUQ0i/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790848; c=relaxed/simple;
	bh=W3pm/78LsnNW2jdTnYT8kDvkwv4p83KSKpSA31Nb3d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCisvsG/zk35j0SR69vq5mnDpN7Q1efD7Ki2UsqbzepbLGOlp5pKa7t5YJc73tD/S3PFeISoJhUfv5MLlhAsgn9Ruc5EyIfpcMZDBkwrtpBwdVdHlynvz6eNP2i+mMq//GrGaaqUcCLK/ashNt5185R0BfFe8w5Yh8ZCYX4C7zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MENcWRQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MENcWRQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809141F000FF;
	Wed, 30 Sep 2026 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790847;
	bh=HP0HhlsN7z8i+eqnEreVpYIVmbn4Xf6uZcm/rZ8Bd/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MENcWRQlBkirlIxTsJBKpSaJB3uOwanqzdm30xvDjeyUO9daSipHOve9/Uh/6D0vq
	 aloCqMXvr2fIxz/9jNa3L9FuG9qzeDHeUH4XI187lxySe5Zr6jLax4oBmOPfnFlSKf
	 O5Utqa25YtNRYYUeG3hfd8OSKloapylk9KvZ8TI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/752] mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC
Date: Wed, 30 Sep 2026 17:19:25 +0200
Message-ID: <20260930152400.224250538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 6bd8478f412e2..f7acd22ec0479 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -231,6 +231,7 @@ static const struct renesas_sdhi_of_data_with_quirks of_rcar_gen3_compatible = {
 static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774b1", .data = &of_r8a77965_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7796", .data = &of_rcar_gen3_compatible, },
-- 
2.53.0



