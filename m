Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3E74BCAA3;
	Sat, 28 Feb 2026 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301358; cv=none; b=e/SYhsw/4fqWY2TFN9gP4SMdJhAJozDTiL+NddthLdZXboOfraAKnkvCKbYP608m12X19SRFcupg3PVpiAvj2ObpWf4+Qzht/vvIaTogExDu5Kf5D+yVEdOEHMdLbrNwdVoJd8wmZ8eKtXakYAxBljBV1eQAwAT4+r2FC80DyGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301358; c=relaxed/simple;
	bh=sERlK4cG0sQy2fgQwMEdNxFqpS9791B3HJ5q/wS0nV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsK109BfH+KzPKZYbafayVlgwiv6QzZXFPCAt2LGDpHV6X9/9M+2Ry+RhiLSFAXUt2Ov8Lkqq5MYHDNHTV4UFiyPzDSPubfLAFiZycfeDHlcD1iVQls3rltqEEzc6P5Sk14ZOcZ6Riq8STBSyejGdlnqnLqLRU+1CjQot95StEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4rE7QIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4rE7QIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54036C19423;
	Sat, 28 Feb 2026 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301358;
	bh=sERlK4cG0sQy2fgQwMEdNxFqpS9791B3HJ5q/wS0nV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4rE7QIJ3m4hFaCsDYRZ8yrzbo9psnfYXNUL1cmVCS5K3+HeExtTxNnrf5ztJdN/i
	 CkyP3HklnLsiVaU/6NMQTdctpkYSEe2qS2zDbFER/XpUv2nUf3YNb9mKHz+Nkw6FL9
	 jMMgqjTV29bt1gwGYxsyYK6uosD53ggQm3eOnsgMumJoGD5/zsp48yhbYUe0v3dE69
	 BUQrsKcCiztJ01RDEwSOJe8Fs7+YPOJetc0Xtd3XjvUO8uXMD8igUo5zq0zoM8k4do
	 Wpwh2X+Yvxb3KKnml+nE+9BF0sGGwCTfW6o6r7sgURLkJn19drs8cuLOKQSJs9py/r
	 NI/+poRzt3rdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Janne Grunau <j@jannau.net>,
	stable@vger.kernel.org,
	Stephen Boyd <sboyd@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 546/752] clk: clk-apple-nco: Add "apple,t8103-nco" compatible
Date: Sat, 28 Feb 2026 12:44:17 -0500
Message-ID: <20260228174750.1542406-546-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

[ Upstream commit ef9b3b4dbe767e4ac642a88dc0507927ac545047 ]

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,nco" anymore [1]. Use
"apple,t8103-nco" as base compatible as it is the SoC the driver and
bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Fixes: 6641057d5dba ("clk: clk-apple-nco: Add driver for Apple NCO")
Cc: stable@vger.kernel.org
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-apple-nco.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-apple-nco.c b/drivers/clk/clk-apple-nco.c
index d3ced4a0f029e..434c067968bbc 100644
--- a/drivers/clk/clk-apple-nco.c
+++ b/drivers/clk/clk-apple-nco.c
@@ -320,6 +320,7 @@ static int applnco_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id applnco_ids[] = {
+	{ .compatible = "apple,t8103-nco" },
 	{ .compatible = "apple,nco" },
 	{ }
 };
-- 
2.51.0

