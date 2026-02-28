Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5F6355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301012; cv=none; b=W9ch4gt+9p1iAPSkvoxcuTjv6UPPKYjyus228WbpvXQK6V/Oq09fmSqX6ju7vqTGTO5xIsRgPJGpnV/Aa0gDIr6zmonr/FGRppTjrO2BbSlhAN19pQWBE9D+hx5tRQu8eKDTiELNseyvkoWB5iWTQ8kw0Ma2MFCsskB4DQqIMo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301012; c=relaxed/simple;
	bh=RKr5G6gAHKyrvfZNxegpUsEQQpPD7ejuk7Za6Lk3c3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5k3M1eTKlPVT6CcCyZ5FyTN2sB1F0HivNWNxObMfuU0tvgOGm/Qgs/ViqsoduKqQkBFCvkPkHrmjLXvjrj8wOdiRf8mBF19dExC/W2VTXWCTUAY4Aw3ZKC0RNY/BRZPy6ZMtAx9V68SblCG5yIDsB55Z9l7l5P91KGyemhnKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6oLx5sT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6oLx5sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16345C116D0;
	Sat, 28 Feb 2026 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301011;
	bh=RKr5G6gAHKyrvfZNxegpUsEQQpPD7ejuk7Za6Lk3c3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6oLx5sTQYQ3YxYkXls9U9TAXWHUNkvoqF8ezlWGiz0ecjPKwvTQ4nO1rS1DILcGW
	 w9N3dc8x+h3QuZvtlz+pCZuwkvp94Q9C6iSCg1rbCFh83Z5C+MlZcucpsjAA22ap+K
	 605OMEfhvYaxgzjvAEq4scH1JmscPOiz5fSKcoDmyQ/cUqhRDbC0O/AG9mB1oMywZR
	 f3dPkg0y/z7cX1gC6+I1z8Nzww3qsbvhuqtnUN7sAHmArDSxxJmB0XBXfO0D24s8YL
	 rnThxVacRmXvLhclPyIA201jGE30qCJIGrUJgmQ61n7C8ji50KNvrZhI1pRD63gtgF
	 fkTz65Ud+GRvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/752] drm/amd/display: only power down dig on phy endpoints
Date: Sat, 28 Feb 2026 12:37:37 -0500
Message-ID: <20260228174750.1542406-146-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit 0839d8d24e6f1fc2587c4a976f44da9fa69ae3d0 ]

This avoids any issues with dpia endpoints

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 483217a91029a..d4a0961f6b516 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -284,6 +284,8 @@ void dcn401_init_hw(struct dc *dc)
 			for (i = 0; i < dc->link_count; i++) {
 				struct dc_link *link = dc->links[i];
 
+				if (link->ep_type != DISPLAY_ENDPOINT_PHY)
+					continue;
 				if (link->link_enc->funcs->is_dig_enabled &&
 						link->link_enc->funcs->is_dig_enabled(link->link_enc) &&
 						hws->funcs.power_down) {
-- 
2.51.0

