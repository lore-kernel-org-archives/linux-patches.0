Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06CF379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301703; cv=none; b=KkMd51fDXsDwHEAHn1Ff7umvmJWXKBL3Da6uONTMXbydf5hoPYaPBh8YmtxZ7/sYhkWjsmyNSR3TOxo5ZFuwtPgcoGkBL2CgtwDaNSZVm9x0ccSBMeQveGJIigpyVmjfnz7fkDjZzeIfy/82UEFF+AvaIIomZMZj4htVbKKOFEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301703; c=relaxed/simple;
	bh=IAyaIrmZRX/59J2rgd7t3OgHBf/TvXFbw2T3imScbzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmaFNIpN59wYeQKKQgzNp/GBqFJjmIWaRlrQYPE8ijdW6f2ecMcX781Hva/VsfhYLaagxbSghl938R4YwHcUNifxmsWMFzM3osCO+xuzaFeW2rIV5vuids65PROQ+5w+2tHynjihj/ffyzJ5dEsUdGYEI9G2NSV+kVabyS4AKCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vF/SHY4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vF/SHY4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0084C116D0;
	Sat, 28 Feb 2026 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301703;
	bh=IAyaIrmZRX/59J2rgd7t3OgHBf/TvXFbw2T3imScbzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF/SHY4RTGz2/grPYBcP9bk4J02mYiu5vXCTTSeOSnX/O/EtWpSJwCvm8RXrJpZvO
	 I4sFDwWqjxMHGNEMFQILcO2lEvokvMVk12sn2LZYh8A3NpdXxI10Wlt1aH+y4MJYhz
	 0GzzUo9qODGdMWPVbAnkeGmz7V01zWmjNsjJ+0UmuHb6kdtULVrRVxG9V5utV+yJT4
	 8qimbx4xpXxSLu+BRWx+z95hJJWVVtOBLms0I3EXCLCWxqit9iSgGOb8FamsQkq4dH
	 HTZYian1zay+FlLFmOLX7sfZqDw/7aZy3s7zHMIRQzwBC+N4+1+2TRHhAqCPpyO0YW
	 WXeBFaMAdXWqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/385] clk: qcom: Return correct error code in qcom_cc_probe_by_index()
Date: Sat, 28 Feb 2026 12:55:19 -0500
Message-ID: <20260228180011.1568201-97-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1e07ebe744fb522983bd52a4a6148601675330c7 ]

When devm_platform_ioremap_resource() fails, it returns various
error codes. Returning a hardcoded -ENOMEM masks the actual
failure reason.

Use PTR_ERR() to propagate the actual error code returned by
devm_platform_ioremap_resource() instead of -ENOMEM.

Fixes: 75e0a1e30191 ("clk: qcom: define probe by index API as common API")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251217041338.2432-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index cab2dbb7a8d49..e1a83ec481509 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -375,7 +375,7 @@ int qcom_cc_probe_by_index(struct platform_device *pdev, int index,
 
 	base = devm_platform_ioremap_resource(pdev, index);
 	if (IS_ERR(base))
-		return -ENOMEM;
+		return PTR_ERR(base);
 
 	regmap = devm_regmap_init_mmio(&pdev->dev, base, desc->config);
 	if (IS_ERR(regmap))
-- 
2.51.0

