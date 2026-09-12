Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8650346A08;
	Sat, 12 Sep 2026 07:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199688; cv=none; b=DwYQB7paXWP869aiOjUscSfRKdjtLi0GzxbxRbf1CDC2rRThDAFzCkdGVCN9QvNjb2eyqKjenVraKfD59tudpRSRx0ySwoVIQOexPq+GK6mIvLqEykzEQC95iumUhxw+g3vh19kzVLCAzGIUBCVpSRKTmBoJd+F2COdBr7JSg60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199688; c=relaxed/simple;
	bh=23McRYePBDP0VdlF8jiAsI3JLs4oAdLNErZghEkHgaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haRexwQfjJKG3lsuqjObNwgN8pimZ2O8PK6mveXpCbSRQPXvJtoTpAVZ6YdSzD2NQu4anANXhiPnYWQG1p/JH+gxgoiK1KY2gZ2WIxLLEFb5+7YRqa1UWl4lkxEIW3uoBl/5PaTrELDYh6X0zlC7y7f8MAfJchLgldJyyyHYYiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JltxBqIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JltxBqIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F381F000FF;
	Sat, 12 Sep 2026 07:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199687;
	bh=YS1zpt2GKdRGhlScfkALEBTOVwxHx39TAYV2g2APTuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JltxBqIyQ20l0dM08HL6jFWlwmLlq4rymOK4AlkcPiHjwIIeWaLW/m6G59llwJDIG
	 X4/up54uTRIiep4HqmC8pm0MtKm+JFdPcIfnZg+m2DQ2nPjA43zo53S1ujqvig3IgD
	 sG56K5u+uCeDmQYz2Xm8ZixKYjtzfIZ8rgBYTIDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0634/1815] ASoC: spacemit: rename clock inputs to match binding
Date: Sat, 12 Sep 2026 08:39:44 +0200
Message-ID: <20260912065703.762872575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 4c69d04958ec87163ba826e2506babab37192e4b ]

The driver requests the per-controller SSPA bus and functional clocks
as "sspa_bus" and "sspa", but the device tree binding (spacemit,k1-i2s)
specifies them as "bus" and "func". As a result, any DT written against
the published binding fails to probe.

There are currently no in-tree DT users referencing these names, so
rename the clock inputs in the driver to match the binding rather than
changing the binding. While at it, rename the matching struct member
sspa_clk to func_clk for consistency with the new clock-names.

Fixes: fce217449075 ("ASoC: spacemit: add i2s support for K1 SoC")
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Link: https://patch.msgid.link/20260721-kx-i2s-dts-v1-1-d22cb6cfaab5@linux.spacemit.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/spacemit/k1_i2s.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/spacemit/k1_i2s.c b/sound/soc/spacemit/k1_i2s.c
index 8871fc15b29cc..4247d8d3a6370 100644
--- a/sound/soc/spacemit/k1_i2s.c
+++ b/sound/soc/spacemit/k1_i2s.c
@@ -52,7 +52,7 @@ struct spacemit_i2s_dev {
 
 	struct clk *sysclk;
 	struct clk *bclk;
-	struct clk *sspa_clk;
+	struct clk *func_clk;
 	struct clk *sysclk_div;
 	struct clk *c_sysclk;
 	struct clk *c_bclk;
@@ -221,7 +221,7 @@ static int spacemit_i2s_hw_params(struct snd_pcm_substream *substream,
 	if (ret)
 		return ret;
 
-	return clk_set_rate(i2s->sspa_clk, bclk_rate);
+	return clk_set_rate(i2s->func_clk, bclk_rate);
 }
 
 static int spacemit_i2s_set_sysclk(struct snd_soc_dai *cpu_dai, int clk_id,
@@ -445,14 +445,14 @@ static int spacemit_i2s_probe(struct platform_device *pdev)
 	if (IS_ERR(i2s->bclk))
 		return dev_err_probe(i2s->dev, PTR_ERR(i2s->bclk), "failed to enable bit clock\n");
 
-	clk = devm_clk_get_enabled(i2s->dev, "sspa_bus");
+	clk = devm_clk_get_enabled(i2s->dev, "bus");
 	if (IS_ERR(clk))
-		return dev_err_probe(i2s->dev, PTR_ERR(clk), "failed to enable sspa_bus clock\n");
+		return dev_err_probe(i2s->dev, PTR_ERR(clk), "failed to enable bus clock\n");
 
-	i2s->sspa_clk = devm_clk_get_enabled(i2s->dev, "sspa");
-	if (IS_ERR(i2s->sspa_clk))
-		return dev_err_probe(i2s->dev, PTR_ERR(i2s->sspa_clk),
-				     "failed to enable sspa clock\n");
+	i2s->func_clk = devm_clk_get_enabled(i2s->dev, "func");
+	if (IS_ERR(i2s->func_clk))
+		return dev_err_probe(i2s->dev, PTR_ERR(i2s->func_clk),
+				     "failed to enable func clock\n");
 
 	i2s->sysclk_div = devm_clk_get_optional_enabled(i2s->dev, "sysclk_div");
 	if (IS_ERR(i2s->sysclk_div))
-- 
2.53.0



