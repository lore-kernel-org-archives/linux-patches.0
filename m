Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD082AF07;
	Mon, 28 Oct 2024 06:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098229; cv=none; b=tv0iN5xXfJ00XoptHqjJra1OlWqCtPPeeQcvAV/0wymfZfQ/c6UdHDunXf3H2MBjurXtSA+5xdGHsCrTz4RPuIiVwDGytnWibzrmjmdcLnTrFt/ATs99vvvkWxr66xXBe3A8OewY2Wjl0pav4jnNxraUbZMJhabGXs1hfEhq+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098229; c=relaxed/simple;
	bh=3KSWnYTZwrCvx6je2pXlztvawPYGzY79ISf4xmmnfHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/G8jg/Vg+y0np+mv6YNJ8W40TNsPJT5n4L5mcCMC0yN82v3AajCuarv8s4svUaptK4X5WsvDppfp5eFPlD1nZ+Drl+xUhrjM+MAxUdroPbxYuH90fSqTjvijMrOD9BGvDmaUJx3+fWg96ri8jDNLRD717d0uWiCpHefoGiKXPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JG4hEarz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JG4hEarz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C630C4CEC3;
	Mon, 28 Oct 2024 06:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098229;
	bh=3KSWnYTZwrCvx6je2pXlztvawPYGzY79ISf4xmmnfHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JG4hEarzrkirUhxeL+s3SasevL3IzMoVw/enNF3CopNLMl8F8O/j8sA+I33LmnuSX
	 MJf4zgyLVeUAKE4wgSVN20OjOkVJO3XrHkvqyS0vs6Fr/BYyaqAIQSA8mSrQqzcxSV
	 fGa2kYgeLQDMaIDBqo25LT/CS8apfkbuI55RRMOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 133/261] drm/xe/mcr: Use Xe2_LPM steering tables for Xe2_HPM
Date: Mon, 28 Oct 2024 07:24:35 +0100
Message-ID: <20241028062315.377196505@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Sousa <gustavo.sousa@intel.com>

[ Upstream commit 7929ffce0f8b9c76cb5c2a67d1966beaed20ab61 ]

According to Bspec, Xe2 steering tables must be used for Xe2_HPM, just
as it is with Xe2_LPM. Update our driver to reflect that.

Bspec: 71186
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240920211459.255181-2-gustavo.sousa@intel.com
(cherry picked from commit 21ae035ae5c33ef176f4062bd9d4aa973dde240b)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_mcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_mcr.c b/drivers/gpu/drm/xe/xe_gt_mcr.c
index 6d948a4691264..d57a765a1a969 100644
--- a/drivers/gpu/drm/xe/xe_gt_mcr.c
+++ b/drivers/gpu/drm/xe/xe_gt_mcr.c
@@ -407,7 +407,7 @@ void xe_gt_mcr_init(struct xe_gt *gt)
 	if (gt->info.type == XE_GT_TYPE_MEDIA) {
 		drm_WARN_ON(&xe->drm, MEDIA_VER(xe) < 13);
 
-		if (MEDIA_VER(xe) >= 20) {
+		if (MEDIA_VERx100(xe) >= 1301) {
 			gt->steering[OADDRM].ranges = xe2lpm_gpmxmt_steering_table;
 			gt->steering[INSTANCE0].ranges = xe2lpm_instance0_steering_table;
 		} else {
-- 
2.43.0



