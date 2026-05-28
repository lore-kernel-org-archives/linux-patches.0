Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467E033CE8A;
	Thu, 28 May 2026 20:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999030; cv=none; b=nkpUCx6BSGrMnrIwVKXyyFlh/+nyZWAx2YJ255cB5F0IEaQ11X0tiylXQ9zfrx0CeoIHiqYl/X4340q6ioGgjK5y1oMjz4/WTDOGVvh5UuemFoSoXnxTBwS+lJcYgrmtQxWE6RDkUmvvFjwihP9acQa9m8BJVCeUA2QiSj87l5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999030; c=relaxed/simple;
	bh=5+bCqJL9/0iQTCpUJW5drFekRG61UuUDxE4ovglApuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAtfvcihT0o4xC/0bBrC9o+mj1NvDK2gUQPLl0lK5thRGTCbptE0NpTiyvvekkdNaGkYDvkea8W8vwq23pSACqdpsTmiUOaObiyWHZacLZyBzAEr/59d6J6cG0e/Ka1gnf2C+hCCttWbJAuB8w9gM/ia77oItVojMtGmgXixisI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EGijhcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EGijhcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0B71F000E9;
	Thu, 28 May 2026 20:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999029;
	bh=TW/nn3aj6/O8UVS5tQyoWGb8n+aMtkF4dVZayg6u8mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EGijhcSTyTkWAu6Dj3S+Ctjtua/mQINLe9gkGx/F3HWZFFtVY2JSEoPRnbGciGJ7
	 W4sbzhIgBugs4PA4F0JH7R7tLsuHFGcw4zoS28N71x/xr/Q6Dw8P7AI6uX4Us969qT
	 dwvHwYxnYubqGD4dwQ9iVe/vsLyssCPtyR9I0lO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Xiangxu Yin <xiangxu.yin@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 382/461] phy: qcom: qmp-usbc: Fix out-of-bounds array access in dp swing config
Date: Thu, 28 May 2026 21:48:31 +0200
Message-ID: <20260528194658.513342776@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiangxu Yin <xiangxu.yin@oss.qualcomm.com>

[ Upstream commit ea17fc4d7dc2ba6459b1a318962960520201baf1 ]

swing_tbl and pre_emphasis_tbl are 4x4 arrays (valid indices 0-3), but
the boundary check uses "> 4" instead of ">= 4", allowing index 4 to
cause an out-of-bounds access.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 81791c45c8e0 ("phy: qcom: qmp-usbc: Add QCS615 USB/DP PHY config and DP mode support")
Signed-off-by: Xiangxu Yin <xiangxu.yin@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260227-master-v1-1-8d91b9407fdb@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usbc.c b/drivers/phy/qualcomm/phy-qcom-qmp-usbc.c
index 14feb77789b3e..0dd7000614f44 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usbc.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usbc.c
@@ -794,7 +794,7 @@ static int qmp_v2_configure_dp_swing(struct qmp_usbc *qmp)
 		p_level = max(p_level, dp_opts->pre[i]);
 	}
 
-	if (v_level > 4 || p_level > 4) {
+	if (v_level >= 4 || p_level >= 4) {
 		dev_err(qmp->dev, "Invalid v(%d) | p(%d) level)\n",
 			v_level, p_level);
 		return -EINVAL;
-- 
2.53.0



