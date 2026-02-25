Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A24F1D5ABA;
	Wed, 25 Feb 2026 01:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983091; cv=none; b=uOWGDjC9hfniy6O+A1NwcmrcArFgNSElhQBybYY4rFyOjY2qrzJSpD91FxppZB7bt8CZPHRwffFEwO4sHv+Wh+wPPE2u6Hpt+cfxZIQAW1U10ZZ0IPjbUgG4BZ0L7FDRyqwpJlO7JOKKDX0WUTotqqxJMqUlcoVSZd0IwuQ7NNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983091; c=relaxed/simple;
	bh=yxPLs1e3t+UuXsQeteK/Nb3+4qi08zgxOuCqVRVDsMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt40TVK5itdHehVrPKj2n95bQK7JTEcS32/OuyKdwcEw3ZTX2Lp99NdIi+CXvDUIA5RC+0IGLkZqNp5xn9ouaw2GDPskJezeE/6pHjEHfrVocy26WZWUiGg5OfDnEVz1GnbfjeFwma2Jj2k2YCiE+ats+3S1uKZ69ZgLQguTq84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQWo6Gak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQWo6Gak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29D8C116D0;
	Wed, 25 Feb 2026 01:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983091;
	bh=yxPLs1e3t+UuXsQeteK/Nb3+4qi08zgxOuCqVRVDsMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQWo6GakYdbm1NzmXYbITbYR8PJ0n2fTaikRTydYke85KBk26iAAb52YpUttmwtU0
	 fnvFYiGERenOSOZwpnwbkSfyfKNL7ieI0+u/MK1FSHMexNa46OJmkV9YWUiNMll0sk
	 XrAzgauXbTbigwcofhvds1czIbVt1CnfhjZrUgnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Chandana Ballary Kuntumalla <quic_mkuntuma@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 250/781] drm/msm/dp: Update msm_dp_controller IDs for sa8775p
Date: Tue, 24 Feb 2026 17:15:59 -0800
Message-ID: <20260225012405.840993463@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9bd9cd5c1e03c..a082f4d3ebe27 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -141,8 +141,8 @@ static const struct msm_dp_desc msm_dp_desc_glymur[] = {
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



