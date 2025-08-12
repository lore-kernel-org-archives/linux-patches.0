Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7092F83CB;
	Tue, 12 Aug 2025 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020242; cv=none; b=r5c/vHezlitS027AMWwUvcNVnfbORR/LXYWVCIDYvpkCLHCy9cZ1eGttNlk2pK/n5iZksSCyjrMPmikidhqLKccarRcpRE/6+IyeecfBgCJGIfygYIt6hfDY7Rd4aHxCpdiWpyN8MeMfhRbzjYxE1UqA64qob9qWaFZUCggqLfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020242; c=relaxed/simple;
	bh=3VgTp6HSQMThG9jLFd4iC3ZJv2VEjMG0iJXBRKulCj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRJolDa8i2U5ZjYQYVzYek9RwLk1F9SB0NIPfqijBrXRoLul7HsFNGAq5M0aOjiHT9V1qS52ZA6JKYhULVvlDtnro/1G1Up/WECnGb/0RbaEgGbXAoh+rKV7uIOzepAFZB5frgorAZeXVdK0XcucbvvvQaIOLJu03iVDnDUoRMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmdIE1sc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmdIE1sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0033EC4CEF0;
	Tue, 12 Aug 2025 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020242;
	bh=3VgTp6HSQMThG9jLFd4iC3ZJv2VEjMG0iJXBRKulCj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmdIE1scFhRF2YNEWm+sFMcYZSHTSP2cQHNlq2/4mqQwCfhn9tWPXj8m7+oiLYjCS
	 2qDa2HK15KET95oyHqfqZbcjdhE52Kv4lQispO4ODModsN5wZFyrBxlx+5BY0YlL3Z
	 I8n1Pdyhj3TTH7gigu2k4MNd7IYEywUdWIgLvKxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/253] interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node
Date: Tue, 12 Aug 2025 19:26:32 +0200
Message-ID: <20250812172948.871641649@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xilin Wu <sophon@radxa.com>

[ Upstream commit 886a94f008dd1a1702ee66dd035c266f70fd9e90 ]

This allows adding interconnect paths for PCIe 1 in device tree later.

Fixes: 46bdcac533cc ("interconnect: qcom: Add SC7280 interconnect provider driver")
Signed-off-by: Xilin Wu <sophon@radxa.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250613-sc7280-icc-pcie1-fix-v1-1-0b09813e3b09@radxa.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc7280.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc7280.c b/drivers/interconnect/qcom/sc7280.c
index 3c39edd21b6ca..79794d8fd711f 100644
--- a/drivers/interconnect/qcom/sc7280.c
+++ b/drivers/interconnect/qcom/sc7280.c
@@ -164,6 +164,7 @@ static struct qcom_icc_node xm_pcie3_1 = {
 	.id = SC7280_MASTER_PCIE_1,
 	.channels = 1,
 	.buswidth = 8,
+	.num_links = 1,
 	.links = { SC7280_SLAVE_ANOC_PCIE_GEM_NOC },
 };
 
-- 
2.39.5



