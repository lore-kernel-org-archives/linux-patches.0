Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845C4228C99;
	Mon,  2 Jun 2025 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873764; cv=none; b=XYgkaDXDqwnkVh6S+3LmBJX2wbETCQChJIqVs85eCwDuWk1nKgLoEmTKYSgE/I9FrbW7GsA1Dj4MvCZXkvfXlw1OjRvaeYqLp3LdG27y6RH38Rutz8yQDiLbD2FQr+NuAaHs0AH3J6PRbLdq3knT+1DhM+8lFRDBTpBkjPVRC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873764; c=relaxed/simple;
	bh=kPDCqhcEmmqln6GtZCYZQIG2OBQAOVwAWH5GPBHfEKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5YCHMeIk8nMo6Em8J8ExNf3U6SY21pvvftut9/UPMmoTUe2CcoxH7kn6PIAf3Luy0/OZ2DKD+5bdigaxZjh6/b9ApMmp5/E9tKZ7bpxplQzyqsnntE3vhX2JaP/OVtEY8cj+LpmA7jadH2klU16S7aOx1HVlLVcn+QJdbKrCsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGvLRaIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGvLRaIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99889C4CEF6;
	Mon,  2 Jun 2025 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873764;
	bh=kPDCqhcEmmqln6GtZCYZQIG2OBQAOVwAWH5GPBHfEKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGvLRaIXXYFFC1l/IJ3hsHNyQER8lXubsIQlQgI01cltUcCkNhtVrOIIh5gzHeB7B
	 rCTdbbTpbTNuX0xiv43hMHt0qM/GRzMmzvoTie8IalApfkqkN4eTIv4BQ0JNfZs/q6
	 4J+IKWNtY1dJlcsApLizKnyb+6zYvxahEJvp1sGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/444] pmdomain: imx: gpcv2: use proper helper for property detection
Date: Mon,  2 Jun 2025 15:44:37 +0200
Message-ID: <20250602134349.554781279@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 6568cb40e73163fa25e2779f7234b169b2e1a32e ]

Starting with commit c141ecc3cecd7 ("of: Warn when of_property_read_bool()
is used on non-boolean properties"), probing the gpcv2 device on i.MX8M
SoCs leads to warnings when LOCKDEP is enabled.

Fix this by checking property presence with of_property_present as
intended.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20250218-gpcv2-of-property-present-v1-1-3bb1a9789654@pengutronix.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/gpcv2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/imx/gpcv2.c b/drivers/pmdomain/imx/gpcv2.c
index 13fce2b134f60..84d68c805cac8 100644
--- a/drivers/pmdomain/imx/gpcv2.c
+++ b/drivers/pmdomain/imx/gpcv2.c
@@ -1350,7 +1350,7 @@ static int imx_pgc_domain_probe(struct platform_device *pdev)
 	}
 
 	if (IS_ENABLED(CONFIG_LOCKDEP) &&
-	    of_property_read_bool(domain->dev->of_node, "power-domains"))
+	    of_property_present(domain->dev->of_node, "power-domains"))
 		lockdep_set_subclass(&domain->genpd.mlock, 1);
 
 	ret = of_genpd_add_provider_simple(domain->dev->of_node,
-- 
2.39.5



