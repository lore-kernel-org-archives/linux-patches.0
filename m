Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14E74C0413
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301392; cv=none; b=RGyzVdL5Q0SW4S2DFWkZP44yHMrtWjyWS6YfL34G869RxP3YvykcJhEc536y7QtbDH7TYET28IOGRc4khoHEAakd6lDh8cmQ0LR9A8CALbsvaE+hNHjCrMNQy4y95LHBNrgrzQhJWefrC7LfERCJU0JfMEzxMRgLGEnOPhNg9Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301392; c=relaxed/simple;
	bh=nZpfEUnxRBoAUgmH/6AuFk06MuwRjlxeNi9sgiulmN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApzBJJ2KaIpRgRAgcCf3Pt1a6hAHK/gq8Uz1huztDpTYREKTnjEsKVuIfZ9gmt8C2p8989mlBNNbuXSkoCC8m+c6AKriA160C4SbNRgaLSeAGgclDJQnixgANQz88+DVKO9OPTPKocL3zjZ97Oh899BSN7sJqzh2S5+9urgfKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBIHPAcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBIHPAcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9BBC19425;
	Sat, 28 Feb 2026 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301392;
	bh=nZpfEUnxRBoAUgmH/6AuFk06MuwRjlxeNi9sgiulmN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBIHPAcXY9KMH5aPa5FZbQ8aS25c2ki78kfjz7vh5FytH847BM/MfdH4lL2rK3st3
	 DllYahEIUMDDqjsnHEEL5EfnwjuoWtLxzWAqg2oAz3vWwDdK+k/YdvEJSTwVqqeHNK
	 BXhKNnBs8iXgtWeo2t/J85We8bmXS2VfH9L2sGlVfOXmHlv0PLsWT5TWX5P2gc21qF
	 q+0cKU0rxYcrMDv6J4TIspHH9bD8YaPCGS1sFP0CKEEWtgwPzFplNs4TI6CJ9YIvuy
	 Gm2z4zeRTHflh9h0stAcyKkDhJnyu88KS9z90ORxb094YmgfshIr5HP18nHvJkCCof
	 oHURifX+RJ/KQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Loic Poulain <loic.poulain@oss.qualcomm.com>,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 580/752] drm/bridge: anx7625: Fix invalid EDID size
Date: Sat, 28 Feb 2026 12:44:51 -0500
Message-ID: <20260228174750.1542406-580-sashal@kernel.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 1d5362145de96b5d00d590605cc94cdfa572b405 ]

DRM checks EDID block count against allocated size in drm_edid_valid
function. We have to allocate the right EDID size instead of the max
size to prevent the EDID to be reported as invalid.

Cc: stable@kernel.org
Fixes: 7c585f9a71aa ("drm/bridge: anx7625: use struct drm_edid more")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20251218151307.95491-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 6f3fdcb6afdb9..4e49e4f28d552 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1801,7 +1801,7 @@ static const struct drm_edid *anx7625_edid_read(struct anx7625_data *ctx)
 		return NULL;
 	}
 
-	ctx->cached_drm_edid = drm_edid_alloc(edid_buf, FOUR_BLOCK_SIZE);
+	ctx->cached_drm_edid = drm_edid_alloc(edid_buf, edid_num * ONE_BLOCK_SIZE);
 	kfree(edid_buf);
 
 out:
-- 
2.51.0

