Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A13527B320;
	Mon, 22 Sep 2025 19:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569750; cv=none; b=J/UaYs68bm9jX4UX6lHDi8qnG0h3zWYm2hEuuWk4xPBdobYXffzL0UP3SbEtsmp4cLON6qInJxOZKGUgJzhbeKXVz31MUtB8Jn/3lyrd8I4MVJCqGphpFo3Lh1LlGQIAozhN2aDF/LLSFbFRxil1OGd+ywok4RhzsJnNxzlfiAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569750; c=relaxed/simple;
	bh=8KTJHbEyKh67xoK+QXW1tJl33GOniGpb4mONZYtPkVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEfPLECPanhpQVynJEPT1yrIg6DJWd1J0M1hJvoFXwkyA5CAfbJWFDemTZj5G0xvslDOr/z/wX0IG651HTBOZWjyFJqMrA7vNwiig306jECSxjpLXpK+kNqzYPitC4y9vOQq6rIIDjPhKeoElJz9qo4L0Zd5L6QCyGetNSgTst4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S53yCsjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S53yCsjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B4EC4CEF0;
	Mon, 22 Sep 2025 19:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569749;
	bh=8KTJHbEyKh67xoK+QXW1tJl33GOniGpb4mONZYtPkVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S53yCsjbDlE3gEBrg3bPn9tgNPLKmvOMpB++1LZ/MnEWxNsNp/PUmN7zrZunZ5PZm
	 d9nx7nKXdD3GrFlrU144oLB7PkGuCFxsFGMqa25daXgpxI80UdKt2u49gWvd65SR5L
	 L0GgFQt2XCwwUsCSCVgc0L6D5gd5ocnHK6VMk/iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Qi Xi <xiqi2@huawei.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 54/70] drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path
Date: Mon, 22 Sep 2025 21:29:54 +0200
Message-ID: <20250922192406.055390811@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 858f5b6508491..bdb9fc00c776b 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2057,8 +2057,10 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
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



