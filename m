Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FBB156C71;
	Thu, 13 Feb 2025 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458718; cv=none; b=P/O9jbAeFOSTGQBFiNEz7+M40ro8DWdJJ+m/eJqqGUHEs5ucagdxoauY5YfO215rYJ8j8X5utTRx4Nz3xst9pGoiLv/wiW3cPdOlKT/JgmHtDn+ML3KVoHnJCuD4GXOVsdaZxH0mcFEfnMS3FRk7OVfzQXw6mUL3NJhKgFhR5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458718; c=relaxed/simple;
	bh=Liv0rFxhnUrme89gNxM3WDt1rBc/T49ik6uivbK7QYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZruNv+qsVfmBg7KaZIMOdqoh1BWUeLYjUHRk6A+0/rNk3aH6U5LY2lNmkr73R0RJ9M13TLOUaX/J0KLq4L2aepNHO7hUh6hCG8RbnTZHHbiy1dM8/0rHHAO2Ri7Df1pkPqFrVn2DxhBDCPywCkgqfPBNjT9D+rOeVz/lGrZ1QYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xclu+zLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xclu+zLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B93C4CED1;
	Thu, 13 Feb 2025 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458718;
	bh=Liv0rFxhnUrme89gNxM3WDt1rBc/T49ik6uivbK7QYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xclu+zLbFgRwqAaLed6cHXUkCKguhb1n+bK4JrVM+EZyW8YP68uGCBHHzPhMiprJf
	 ZylT4LypYr7GJefl478i0SXOFrxQExLB+ly0reZrylNVa6h7snOmWaVBcX6cU4yrBS
	 08lc0S8HznD2KoR854KbuSLxHwfMYLJhmAJY69H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 058/443] mmc: sdhci-esdhc-imx: enable SDHCI_QUIRK_NO_LED quirk for S32G
Date: Thu, 13 Feb 2025 15:23:43 +0100
Message-ID: <20250213142442.862647943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>

[ Upstream commit 0202dfbdc5dea70e213205aa42ab49a1a08aad3a ]

Enable SDHCI_QUIRK_NO_LED quirk for S32G2/S32G3 variants as the controller
does not have a LED signal line.

Signed-off-by: Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Message-ID: <20241125083357.1041949-1-ciprianmarian.costea@oss.nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index d55d045ef2363..e23177ea9d916 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -304,6 +304,7 @@ static struct esdhc_soc_data usdhc_s32g2_data = {
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
 			| ESDHC_FLAG_SKIP_ERR004536 | ESDHC_FLAG_SKIP_CD_WAKE,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 
 static struct esdhc_soc_data usdhc_imx7ulp_data = {
-- 
2.39.5



