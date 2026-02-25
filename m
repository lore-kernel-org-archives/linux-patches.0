Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689F9279DB3;
	Wed, 25 Feb 2026 01:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983927; cv=none; b=ma6dJRa8kF0Vet2ltqWC6ZusmSWR7y2LuugMDZgnhpnpiVD2aGM72H76ucEAPzWA4G3JEYaCa31oqhMK5lFqjcBaWTF5stCez4h/EdfhUV92LVm75zReg/6BynqkNKNfkX7IAMrjdCULf9MFBrF8gSo9utSIcXVWsZgKoHov56o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983927; c=relaxed/simple;
	bh=ZwaZ39MqiMn7QcRMcpe8gM9azp6y/DtoiDviMmLog3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jrv9m6XF+GKggb9eki4paBa/unY95VV7xwbgyq1OuysCUWuHGTv/hORpdjsXrlxIBKOOZmK32iBqA+RKaJHLqfajxhUOtFqOupX7xhyOrPRLF71IyEJtRxJ003FWF8E+6x2cPieubH4rWpcRDIoGXxEjd0YQqLnre4sE1y13cGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aznqtK6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aznqtK6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257E4C116D0;
	Wed, 25 Feb 2026 01:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983927;
	bh=ZwaZ39MqiMn7QcRMcpe8gM9azp6y/DtoiDviMmLog3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aznqtK6ypFubRjFlAAY93wVAdtPhL5MlT9roKOKoCD2+UP+0U989FFrjKX6ZxQY9x
	 uNfgQH9WkJd8oGhnJuiJBznhI4yGk5kJzkUM8ZIrxrkq7RlkrDEzeRifk28mz96Oah
	 NrVbr/gE8kMWMPfJtxdweArQerwBAaAQ+x+uy9jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Chandana Ballary Kuntumalla <quic_mkuntuma@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/641] drm/msm/dp: Update msm_dp_controller IDs for sa8775p
Date: Tue, 24 Feb 2026 17:18:40 -0800
Message-ID: <20260225012353.694302316@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mani Chandana Ballary Kuntumalla <quic_mkuntuma@quicinc.com>

[ Upstream commit 1338e8ae4084e55c0359a79e617b2ae183d01579 ]

The Qualcomm SA8775P platform comes with 2 DisplayPort controllers
for each mdss. Update controller id for DPTX0 and DPTX1 of mdss1.

Fixes: dcb380d19e58 ("drm/msm/dp: Add DisplayPort controller for SA8775P")
Signed-off-by: Mani Chandana Ballary Kuntumalla <quic_mkuntuma@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/690234/
Link: https://lore.kernel.org/r/20251125105622.1755651-2-quic_mkuntuma@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index d87d47cc7ec3e..f247aad553975 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -133,8 +133,8 @@ struct msm_dp_desc {
 static const struct msm_dp_desc msm_dp_desc_sa8775p[] = {
 	{ .io_start = 0x0af54000, .id = MSM_DP_CONTROLLER_0, .wide_bus_supported = true },
 	{ .io_start = 0x0af5c000, .id = MSM_DP_CONTROLLER_1, .wide_bus_supported = true },
-	{ .io_start = 0x22154000, .id = MSM_DP_CONTROLLER_2, .wide_bus_supported = true },
-	{ .io_start = 0x2215c000, .id = MSM_DP_CONTROLLER_3, .wide_bus_supported = true },
+	{ .io_start = 0x22154000, .id = MSM_DP_CONTROLLER_0, .wide_bus_supported = true },
+	{ .io_start = 0x2215c000, .id = MSM_DP_CONTROLLER_1, .wide_bus_supported = true },
 	{}
 };
 
-- 
2.51.0



