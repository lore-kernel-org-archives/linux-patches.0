Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2294279792;
	Wed, 30 Jul 2025 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868622; cv=none; b=ILvNP8PtGKTrwc5Gml2icWaS/9oBcJw7kMEBA2Jslx5tGQmNaEuzJfGtaqHLHtEcnL2PCQz5+BWblfwdBVnWQJV28rTrLAYgf7dkj7VWEeR+VkR15YCdTzkMzTM5TYbWMwU4x0qNIrANOxVCid4U5MENVjCJkOjZTnhPSPYVNv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868622; c=relaxed/simple;
	bh=+GTjaESE2GUIdaZOgWVBdD2QhMPvT0ioQZk7EnSQHa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBat7tBT0JABdz58zA08ibqKMuWIvsFv9r/9FAFJvozCgpNLh/sstlRFvZtK5pZldnn8RxBNB3Kp9nh08kpQ5uCRJfYOGx5OKVCbZwUm+KHR0Dd7HBcY0n8MZSW01+KCl5ZtyiBoHzDwe2PEgrZ/WGoT9VGt8a7VhRy5tdCs8uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p13igeP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p13igeP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1590C4CEE7;
	Wed, 30 Jul 2025 09:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868622;
	bh=+GTjaESE2GUIdaZOgWVBdD2QhMPvT0ioQZk7EnSQHa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p13igeP1IWy5gZ30RbpjeUQ8VbnGriyQhjPgY4qLIFpd8ww8w22G1KbFhhazwlLd3
	 tnCrD92uCJFjLD7I6msXK4jfu/tujpF7RZ9qlehCr9mlfmoeJ2tRDd2xBJBASi3BQz
	 PaWEMuWd+iM5VJ/LsLxKmpEdfQmiBMfQfpGkilJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/117] interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node
Date: Wed, 30 Jul 2025 11:34:37 +0200
Message-ID: <20250730093233.915655025@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 167971f8e8bec..fdb02a87e3124 100644
--- a/drivers/interconnect/qcom/sc7280.c
+++ b/drivers/interconnect/qcom/sc7280.c
@@ -238,6 +238,7 @@ static struct qcom_icc_node xm_pcie3_1 = {
 	.id = SC7280_MASTER_PCIE_1,
 	.channels = 1,
 	.buswidth = 8,
+	.num_links = 1,
 	.links = { SC7280_SLAVE_ANOC_PCIE_GEM_NOC },
 };
 
-- 
2.39.5



