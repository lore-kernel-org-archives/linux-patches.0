Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0178305045;
	Tue, 30 Sep 2025 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244229; cv=none; b=OUJuHjzPl8q4u3Kb5769Dsg7eVGxJERJwMndsY22sB1+gxFytiNfeBDcuq6T5CaQXzIoTl/EWVDB8LEWj/NBXRjNp3nV2fL+QBlmFxLAeP5tAgRf1ZSQousRzfPNuo2lAgIC4YJAtLkAInZU4kBixMRlJiVxtgrK3jSVDmyf7FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244229; c=relaxed/simple;
	bh=ueJcc9tk9r6eXY3/YhQP17n3rY4h8T7v/Lhzx7/OU3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6eEF7Lk8/RMFcYJOD/cdz9X12xEyieL/gccMiQ3BSon7b5KdnVqcGeXym3YQYF/zSa09ea5n/6KZ+zeBWRFpqvj0mozREc2X++Mw9nC3TBqnDw0SvegKtGmL7OkTncAE7QUlaySlq9bYtCNARXx0KFiczPlkp+TYBliGa0ce/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRzDaDt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRzDaDt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2060FC113D0;
	Tue, 30 Sep 2025 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244229;
	bh=ueJcc9tk9r6eXY3/YhQP17n3rY4h8T7v/Lhzx7/OU3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRzDaDt/uZjSsJ0+tdz+Nqzu2eSkD/7C97iY9nTp/dUTH6X8lTSJI1bgHY34U5yQF
	 DnK6m0SSxu9D32v95gRjgZt+b1+Ga2OJWwtHh+VkXG07EQsdvFHzLyLNfvI8VUIQzH
	 YPizCxX9N7kgc/r5k1yjrSkSWJzmsng4k12AtSsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Qi Xi <xiqi2@huawei.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/122] drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path
Date: Tue, 30 Sep 2025 16:46:38 +0200
Message-ID: <20250930143825.747682767@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Xi <xiqi2@huawei.com>

[ Upstream commit 288dac9fb6084330d968459c750c838fd06e10e6 ]

Add missing mutex unlock before returning from the error path in
cdns_mhdp_atomic_enable().

Fixes: 935a92a1c400 ("drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20250904034447.665427-1-xiqi2@huawei.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index ae99d04f00456..5876589d42b7d 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -1978,8 +1978,10 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
 	mhdp_state = to_cdns_mhdp_bridge_state(new_state);
 
 	mhdp_state->current_mode = drm_mode_duplicate(bridge->dev, mode);
-	if (!mhdp_state->current_mode)
-		return;
+	if (!mhdp_state->current_mode) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	drm_mode_set_name(mhdp_state->current_mode);
 
-- 
2.51.0



