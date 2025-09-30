Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49C5306D47;
	Tue, 30 Sep 2025 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245281; cv=none; b=qDIPD+XTqIEA9zwVMh8AnPWXo53PezAFHtEPmn1bIHIirJaED0ukcwrxnKLk4zEjU5Nq9YDxWeGwptsV3nAfLdIV41tv52/GtjUDEEWmvq5Iiserhe+cHMB7rLoyUbBDf1oYkq6Ehehf6bG/0pEKu4+7QYBI0RUA2qymMJn0J8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245281; c=relaxed/simple;
	bh=9Cz+zhb4TDg1hLWB4r21PyCB0O4p5F2UpsSefsg2zhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXzHyCP38Jgrd+JGE2HTry476+ph+ztpiMhV8t5/LeKGDRSbtduRMGTdiML17UfLqd+KIwq+KsZ0nTKjXxrCjVr8tVnlSQ4cr8U+q8UesHxf7kEKKh0jklKbJsAH5pPzg2HIttKzkcN8U5GVsJMj7UHH8p5JLzxqmMntyxKQNqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nupq/+vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nupq/+vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12D5C4CEF0;
	Tue, 30 Sep 2025 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245281;
	bh=9Cz+zhb4TDg1hLWB4r21PyCB0O4p5F2UpsSefsg2zhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nupq/+vyjgEIoex5JDKNpv7thm6ZZOTbELENJMr5f3eeKQT/oXCLm8suT6o7WwgVi
	 tVVnMuGIEcYb85DO9Ggy9mCzgZki7Nu/Vhz2DWi/5G1uz+wRSMUxLEzCw1sGxynSQd
	 IvR+4PUw23+htaq1BKwaEaciN5kNaY8kCofgRC+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Qi Xi <xiqi2@huawei.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/151] drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path
Date: Tue, 30 Sep 2025 16:46:59 +0200
Message-ID: <20250930143831.143595341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c8386311cc704..0d523812afd5a 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2040,8 +2040,10 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
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



