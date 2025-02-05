Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E412D1547D8;
	Wed,  5 Feb 2025 14:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764603; cv=none; b=Z3Gryp+Ply/unuyeCMGorhBVG6/J1VyhOiEoFmbYONI1BFthw+cKDbbQbDESGQQqYiJCugVO54DLXzRZxGIrYin0y0aPzrTirhxyUc33IAxI4PKEjDqf1FklZnJvzumRhGZ3tTmh7sIdjBosMyfusQEc16TTmmr35NQCMMPJNm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764603; c=relaxed/simple;
	bh=aVQhynL/0cVoTYXFe1AftmS1N5o0bLo7ZFT7unJ0tj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsKE922UlXCtpKpP0K2sbBYegLNvK79gYJM74m80Agf/BEGEge47aY/HLc1U+LPpYHgIxJ/vC+Fwc+j5mcbHvmYBjycPYDH4tqxczJoF+wQBelWLEgCQuW8nHFmxUcKRKPVGu34EC8OeESYwpSxamD/C85M95SsyG/6SqL3QhpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1rN6T2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1rN6T2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DB8C4CED1;
	Wed,  5 Feb 2025 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764602;
	bh=aVQhynL/0cVoTYXFe1AftmS1N5o0bLo7ZFT7unJ0tj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1rN6T2Z14t0/VaB5xCqA6lcY/CPOrESmi2g5d/JillSZplKDF710niCtwvNdmGMq
	 1Wr2diptt63M7p9b2kwIzjSDvYSh4TJO++uMD/97CEr4e+zXAvX+boR+L54HAe4cqu
	 156H+R0ZNeKEaWSnVkxzNObgxMzmu6lHP3OtPBQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 094/623] clk: mmp: pxa1908-apbcp: Fix a NULL vs IS_ERR() check
Date: Wed,  5 Feb 2025 14:37:16 +0100
Message-ID: <20250205134459.821058709@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3acea81be689b77b3ceac6ff345ff0366734d967 ]

The devm_kzalloc() function doesn't return error pointers, it returns
NULL on error.  Update the check to match.

Fixes: a89233dbd4df ("clk: mmp: Add Marvell PXA1908 APBCP driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/6155067d-aed5-4799-9e14-6dff7be1cb3a@stanley.mountain
Acked-by: Duje Mihanović <duje.mihanovic@skole.hr>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-pxa1908-apbcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mmp/clk-pxa1908-apbcp.c b/drivers/clk/mmp/clk-pxa1908-apbcp.c
index 08f3845cbb1be..f638d7e89b472 100644
--- a/drivers/clk/mmp/clk-pxa1908-apbcp.c
+++ b/drivers/clk/mmp/clk-pxa1908-apbcp.c
@@ -48,8 +48,8 @@ static int pxa1908_apbcp_probe(struct platform_device *pdev)
 	struct pxa1908_clk_unit *pxa_unit;
 
 	pxa_unit = devm_kzalloc(&pdev->dev, sizeof(*pxa_unit), GFP_KERNEL);
-	if (IS_ERR(pxa_unit))
-		return PTR_ERR(pxa_unit);
+	if (!pxa_unit)
+		return -ENOMEM;
 
 	pxa_unit->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pxa_unit->base))
-- 
2.39.5



