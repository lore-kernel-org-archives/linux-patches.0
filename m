Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91A147A0C2;
	Mon, 31 Aug 2026 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183348; cv=none; b=c5M7vx8xzHjbHyQI6ip5ZHWffrzSnfMUGu62fcvDR1ardOxuw0HPHFTysqFU3KlpZoPMoTEGoRsvgwUY7YyL3vbAQI+u3Cpd1x6NGwvwAl5RNaHRwqYPCRE0DBUKSolJxTGaRYyIZ+DuQ22pAs2Y4vxZPrXZfTZvsLFiSEoCBZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183348; c=relaxed/simple;
	bh=yBiRL63M3Rjo2T7VyeW5SWfmFuagqHFdM0/tII3hL+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=McT6A+ksOGesqa6OIsogs+lXguyZJPaIwF9mIYEHMDXJFR5pGAUsprmFx+E2Uny22fBa1o/ax0baMSDJmAVBl0+Ue3D9J0pdnkkDHZIrtau/u065Hs5BKQkmNIznWMOHcp510OMkNIgJ12pPn/bWm5Lu1yAhbdVz/H3WRsMzbOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDValOTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDValOTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767C01F000E9;
	Mon, 31 Aug 2026 13:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183347;
	bh=vjw+L5eEZuN3yDE6hMQ3rXWernU0q9YRTss9sm3D0GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDValOTurZrp+qdeKSIBml1ZhgKXzYZPGYYz+LFshMilGkPU4hzqGhPLteZ4F2AQV
	 MlQWxaIfiP4BRCGNkOKrKwAz8qm4wmpXWHsXGrzvndhtVQb8ByGG3xseD2yMNbGIyH
	 8YwxufSn/1HDQ1D6YzBysU+BrKgSK+uEmA9bcCKJQxPgaO0ze/iWhoJX86yVC5FTvh
	 oDDDWZCKSpWF0wl6faejUQFjIbWHWqN3T8kZvUT1hXOGLEKVT1tsnGORgjvw74GGY6
	 uxMc1adOF4SgFoMzBmzbBhIS6iAEhvZzReWhJM/Q2qddDP5gzSgmjxvrubMymsGE3a
	 kFv7WuUxHCvyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] soc/tegra: fuse: Register nvmem lookups at probe
Date: Mon, 31 Aug 2026 09:22:02 -0400
Message-ID: <20260831133314.4125787-94-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kartik Rajput <kkartik@nvidia.com>

[ Upstream commit 8a3571618c2e3f339b5b6fee5841143face58a2b ]

Register nvmem lookups in tegra_fuse_probe(), after the nvmem device has
been registered, since they can only be used after the nvmem device is
registered.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background check on `stable/linux-6.18.y` finished and matches the
earlier analysis:

- **Prerequisites present:** `71661c1c8c34d` (lookup helper),
  `972167c690801` (ACPI fuse support), `4a4193d9c6dde` (ACPI SoC
  cleanup)
- **Fix not present:** no “Register nvmem lookups at probe” commit in
  6.18.y

**Verdict for this tree (v6.18.44): YES** — small init-order fix for
ACPI Tegra fuse lookups; applies cleanly and corrects code already in
6.18.y.

 drivers/soc/tegra/fuse/fuse-tegra.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/tegra/fuse/fuse-tegra.c b/drivers/soc/tegra/fuse/fuse-tegra.c
index 74d2fedea71ca..972a63993e1db 100644
--- a/drivers/soc/tegra/fuse/fuse-tegra.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra.c
@@ -182,10 +182,6 @@ static int tegra_fuse_probe(struct platform_device *pdev)
 		}
 
 		fuse->soc->init(fuse);
-
-		err = tegra_fuse_add_lookups(fuse);
-		if (err)
-			return dev_err_probe(&pdev->dev, err, "failed to add FUSE lookups\n");
 	}
 
 	fuse->clk = devm_clk_get_optional(&pdev->dev, "fuse");
@@ -231,6 +227,10 @@ static int tegra_fuse_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	err = tegra_fuse_add_lookups(fuse);
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "failed to add FUSE lookups\n");
+
 	fuse->rst = devm_reset_control_get_optional(&pdev->dev, "fuse");
 	if (IS_ERR(fuse->rst))
 		return dev_err_probe(&pdev->dev, PTR_ERR(fuse->rst), "failed to get FUSE reset\n");
@@ -473,7 +473,7 @@ static int __init tegra_init_fuse(void)
 	const struct of_device_id *match;
 	struct device_node *np;
 	struct resource regs;
-	int err;
+	int err = 0;
 
 	tegra_init_apbmisc();
 
@@ -566,10 +566,6 @@ static int __init tegra_init_fuse(void)
 
 	tegra_fuse_print_sku_info(&tegra_sku_info);
 
-	err = tegra_fuse_add_lookups(fuse);
-	if (err)
-		pr_err("failed to add FUSE lookups\n");
-
 	return err;
 }
 early_initcall(tegra_init_fuse);
-- 
2.53.0

