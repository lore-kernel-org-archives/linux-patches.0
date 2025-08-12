Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD17961FFE;
	Tue, 12 Aug 2025 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023573; cv=none; b=CWMOTG/EcVdlgqlpH+o9UMHGO+8ds52UsTaeKfEDb9SxrybLpIaTwzhgYT7atkJkWng5xSZ6HWgjaiXXH1Cv3cXJbqtgmpHLurtoW74/WgFRuE/FCDiR9RfeTK87LPIWGFQhPr6w4sinEIlr1ecgOCo1QHBmGorJUMdfPhN0f0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023573; c=relaxed/simple;
	bh=k7mHwNv5KPMdfnqOWqkPcuezkh7xaeXRPuSFS8xirIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz87C5m0GsIHwh9525XlX+T4S5FBBl6YXZlB6Re8ZWw9OW3R3Hqq6KzcM7dtM1/RcVNnrUSz4TSNzAMl4ppjWRTgiE/29ZFg7hIt5OTT9Ak8ANTFlBfOFRcvb/2XUcuVXCJgK2lhiPWge+iQoRsg5Ry/LkQMCI7SlAm/HWnzCWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2DM6hVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2DM6hVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED841C4CEF0;
	Tue, 12 Aug 2025 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023573;
	bh=k7mHwNv5KPMdfnqOWqkPcuezkh7xaeXRPuSFS8xirIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2DM6hVjUor6JsQZGnlNF80CkgLbr7ygXo2s5K06a60z+3vK7ciZlZ8liE56yxtMy
	 jQFPxuerGSnyw/J1yUwyiCqLVcMpdrXR/9B9O3dgQa3Sr5t7B0e699buNzNTRzLBPv
	 6MOh5PhjjJep9gBNlqzYM/Snz1Z/VBDKpQ0Rj5LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 119/627] interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg
Date: Tue, 12 Aug 2025 19:26:54 +0200
Message-ID: <20250812173423.852331289@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 02ee375506dceb7d32007821a2bff31504d64b99 ]

The qnm_a1noc_cfg declaration didn't include .num_links definition, fix
it.

Fixes: f29dabda7917 ("interconnect: qcom: Add SC8280XP interconnect provider")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250704-rework-icc-v2-1-875fac996ef5@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8280xp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8280xp.c b/drivers/interconnect/qcom/sc8280xp.c
index 0270f6c64481..c646cdf8a19b 100644
--- a/drivers/interconnect/qcom/sc8280xp.c
+++ b/drivers/interconnect/qcom/sc8280xp.c
@@ -48,6 +48,7 @@ static struct qcom_icc_node qnm_a1noc_cfg = {
 	.id = SC8280XP_MASTER_A1NOC_CFG,
 	.channels = 1,
 	.buswidth = 4,
+	.num_links = 1,
 	.links = { SC8280XP_SLAVE_SERVICE_A1NOC },
 };
 
-- 
2.39.5



