Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566951D88D7;
	Tue, 27 May 2025 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366522; cv=none; b=gtUUzu16qWBouini48ojkFh1r8N6SDM86X6a/pgENl2umNL/tTDpqmsqvVgW8RlDaXs18JSfqygn5JFhNx9QgGRXz5lj7G1B7U/lPu0DLca7sNvmTrGTVQMiTTT+yfHKl7YC0fqmJlerTfxhu963r7SgPvCxakdk+wNF5Acfs8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366522; c=relaxed/simple;
	bh=JP8Og3t65sf7SkyAANizahVnnxlVwzOorpf5z7J4iRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAPco/HbMjfHrXBowBVFqhF4saVrGz53Y9FCcSCrTwARrxCuWCVkmo5txgnne56epylij3kTEb/vGAEV56Iq3r56ezgYBG503TyaZc4ipw/UcH0uDUstn7+apsG3F8LILw0/PZ4XGaesw6zv2o1eX2imRKitmrhTl4TW2mA0w+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rnf7qV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rnf7qV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CE3C4CEE9;
	Tue, 27 May 2025 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366522;
	bh=JP8Og3t65sf7SkyAANizahVnnxlVwzOorpf5z7J4iRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rnf7qV0BIv18gLTzi6gXqIrR4JfQhVpzX6OO6s6Z3AYaWSjftDHti8LNKnMPNT89
	 cgf3UYtR1UQjkP32pP7ky83SYxFN/0LBbclJYyLMd/8cVOqEASrt0ZZdbFNs3LqMWs
	 YZy1HDsm23ZRsa3jFiTFRMa+9scBCGl2jp9erzhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thippeswamy Havalige <thippeswamy.havalige@amd.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 096/783] PCI: xilinx-cpm: Add cpm_csr register mapping for CPM5_HOST1 variant
Date: Tue, 27 May 2025 18:18:13 +0200
Message-ID: <20250527162517.053537682@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thippeswamy Havalige <thippeswamy.havalige@amd.com>

[ Upstream commit 9e141923cf86b2e1c83d21b87fb4de3d14a20c99 ]

Update the CPM5 check to include CPM5_HOST1 variant. Previously, only
CPM5 was considered when mapping the "cpm_csr" register.

With this change, CPM5_HOST1 is also supported, ensuring proper
resource mapping for this variant.

Signed-off-by: Thippeswamy Havalige <thippeswamy.havalige@amd.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://lore.kernel.org/r/20250317124136.1317723-1-thippeswamy.havalige@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-cpm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-xilinx-cpm.c b/drivers/pci/controller/pcie-xilinx-cpm.c
index dc8ecdbee56c8..163d805673d6d 100644
--- a/drivers/pci/controller/pcie-xilinx-cpm.c
+++ b/drivers/pci/controller/pcie-xilinx-cpm.c
@@ -538,7 +538,8 @@ static int xilinx_cpm_pcie_parse_dt(struct xilinx_cpm_pcie *port,
 	if (IS_ERR(port->cfg))
 		return PTR_ERR(port->cfg);
 
-	if (port->variant->version == CPM5) {
+	if (port->variant->version == CPM5 ||
+	    port->variant->version == CPM5_HOST1) {
 		port->reg_base = devm_platform_ioremap_resource_byname(pdev,
 								    "cpm_csr");
 		if (IS_ERR(port->reg_base))
-- 
2.39.5



