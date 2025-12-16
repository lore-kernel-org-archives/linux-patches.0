Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5763E34AB1D;
	Tue, 16 Dec 2025 11:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885222; cv=none; b=a9yW+UN9+3XqndejZhCOIzs4M/vRrqeKdVGzQAOoKf/cghOc+lHK/vDrtdfR/fZSGwQFYsejf2i5PbHB1IVE3rNWJGhWjx/CGew/wmEitmBG4yPzeyqVyBtlprxFl/dd81p/nzF0cAA84Iie1j/qch5/Jr5EBvDHTJL9Zi0Aq9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885222; c=relaxed/simple;
	bh=tgz+ZEXnE8rV3gXfKAzcKoQUtvltPl5zZ0UDoXsnw/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOctmDyusjieqN3BEg1Y1bwH1U6W0qj7ZNvU+gaRlg9WtLud4Ihj43Do9HWIHW5QuF4PAfPv0tNX87n0h6bLQfz3uze6DABDvbMazJ0+4uxhDEpSCQthSup786ugKv3ikBQZR0MdjADhkSHMaBFkb8xvJi3lcnBZjh4Ss3I1OGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sBiRMBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sBiRMBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97D7C4CEF1;
	Tue, 16 Dec 2025 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885222;
	bh=tgz+ZEXnE8rV3gXfKAzcKoQUtvltPl5zZ0UDoXsnw/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sBiRMBQ+9eQ2YPuy0QfgLpL4qv1polGSQTW7iob/6lIqiHhv/3mngr5XPj/F9FYS
	 L0AtDOGoHeK8aLcvRQkfqwD4HHu5y9nZBzIu5sM8tIfpMYeq1MBColKfjY8LX0lkdv
	 lh4BJRLSHrjZQoIyKKpO8wYynE7xjdOme2C3IDmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luo Jie <quic_luoj@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 075/507] clk: qcom: gcc-ipq5424: Correct the icc_first_node_id
Date: Tue, 16 Dec 2025 12:08:36 +0100
Message-ID: <20251216111348.259118717@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Jie <quic_luoj@quicinc.com>

[ Upstream commit 464ce94531f5a62ce29081a9d3c70eb4d525f443 ]

Update to use the expected icc_first_node_id for registering the icc
clocks, ensuring correct association of clocks with interconnect nodes.

Fixes: 170f3d2c065e ("clk: qcom: ipq5424: Use icc-clk for enabling NoC related clocks")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
Link: https://lore.kernel.org/r/20251014-qcom_ipq5424_nsscc-v7-1-081f4956be02@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5424.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq5424.c b/drivers/clk/qcom/gcc-ipq5424.c
index 3d42f3d85c7a9..71afa1b86b723 100644
--- a/drivers/clk/qcom/gcc-ipq5424.c
+++ b/drivers/clk/qcom/gcc-ipq5424.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (c) 2018,2020 The Linux Foundation. All rights reserved.
- * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/clk-provider.h>
@@ -3284,6 +3284,7 @@ static const struct qcom_cc_desc gcc_ipq5424_desc = {
 	.num_clk_hws = ARRAY_SIZE(gcc_ipq5424_hws),
 	.icc_hws = icc_ipq5424_hws,
 	.num_icc_hws = ARRAY_SIZE(icc_ipq5424_hws),
+	.icc_first_node_id = IPQ_APPS_ID,
 };
 
 static int gcc_ipq5424_probe(struct platform_device *pdev)
-- 
2.51.0



