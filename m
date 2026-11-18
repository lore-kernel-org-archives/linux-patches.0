Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044962;
	b=pmlcA/BoAZ320JHJhNMBFZeCAZTnCYzcNptC+T7J0LDy1NdVJZC5G9z7IKvJUdwhIrob
	 /+qLftzum8B4B66BixuH2rzka4d9I1bgQnPGwDHR087KkU0VpqLYCfPwTp7Go+N6HMhjI
	 HcLETYm2fisxB9sLcRbsn4NxDyAT2N9p95vzKb5jPqUtoivp2OT5CH5LghJHAcTyEoziC
	 3EIdDHq+cuUp9UvbCgKnt8Ls69MsksWZu940a5iMjlByJoJJYgpZNT2uM9LjUg910srFj
	 OJxvrLPHvrL9WEyjX+H97TNxwgkDTidCvUWnP4v02HaKRTpGGvdGKvV0jjZg0y7oJig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wmsHGN+O3T/J/Km5SixN5ekAVWQvuRx51KVTYqzXweM=;
	b=rdRi/ddXH+X+5slvXkfFZSSuF8Bdv9TpvmNuVXx3CvR3stjRc+DTKgbv8nmjgwDVgnaj
	 /5OkKbGMO2WAkI9yc9XsJpo59M856wRZleyoSF6ksmb1pWn9d1PCDFmUTsl8T+LLxe42k
	 10dH6503JLOuY2KVy9JfkYG2QwIgVKolAnUIey8r7NBkTWupVexWy5N/cmyzxZIActUaY
	 wRu+Z2yVYdR8g7ZVgG8wx+gvCNqhLR4I6HhTY3mpst+ThMluNvopHl9o0VxnlofKofbW0
	 nFXEPoKYt6RwK/sVokXUNwczNlgN+hBLB0ADQayKYR8NJwJO9xrTStti0Ytb0ePhZKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DWV0C14;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C763F606A338;
	Wed, 18 Nov 2026 23:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DWV0C14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296B51F000C6;
	Wed, 18 Nov 2026 23:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044962;
	bh=wmsHGN+O3T/J/Km5SixN5ekAVWQvuRx51KVTYqzXweM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DWV0C14A0eFR8LYQVsmb8nDbxQGfqgzwNDyt3Brwar6A4xYJ5PSrf0aUv+8w9rCt
	 PjSjfezRcT8WbI9BbL3xJ6W/9+vbayKQcD2pHe+0EqEeyQ0aWRBVwjix7DsB5h9l68
	 8uiK8zpVnbq4sI+w8focuITuURTDW+V2nzlGW0GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Damon Ding <damon.ding@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0754/2857] drm/bridge: analogix_dp: Restore mandatory samsung DP DT properties
Date: Wed, 18 Nov 2026 15:29:48 +0100
Message-ID: <20261118150228.701745053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 02f569dd66c94dd67b2586f776235cf4177409ed ]

Revert the change that made samsung,link-rate and samsung,lane-count
optional for Exynos DP. Add error checking to fail probe early if the
required DT properties are missing.

If these properties are missing, video_info->max_link_rate and
video_info->max_lane_count remain zero, and so do link_train.link_rate
and link_train.lane_count used in the subsequent link training flow,
resulting in link training failure.

There is no way at all a device can work without these properties.
Here is the code flow when either max_link_rate or max_lane_count is 0:

  analogix_dp_commit()
    -> analogix_dp_full_link_train(dp, max_lanes = 0, max_rate = 0)

  analogix_dp_full_link_train(max_lanes, max_rate):
      // Read sink capabilities via DPCD and sanitize them
      link_rate  = read_dpcd(DP_MAX_LINK_RATE);  // >= 0x06 after fixup
      lane_count = read_dpcd(DP_MAX_LANE_COUNT); // >= 1 after fixup

      // Clamp by the limits from DT
      if (link_rate > max_rate)    // 0x06 > 0, always true
          link_rate = max_rate;    // link_rate = 0
      if (lane_count > max_lanes)  // 1 > 0, always true
          lane_count = max_lanes;  // lane_count = 0

      // Configure TX with the zeroed values
      set_link_bandwidth(link_rate = 0)
          // writel() is only executed for bwtype == 0x06/0x0a,
          // so LINK_BW_SET is never written and stays at
          // reset value; phy_configure() gets link_rate = 0.

      set_lane_count(lane_count = 0)
          // writel(0, ANALOGIX_DP_LANE_COUNT_SET) enables 0 lanes;
          // phy_configure() is called with lanes = 0.

      // Program sink for link training
      drm_dp_dpcd_write(DP_LINK_BW_SET, {link_rate = 0/lane_count = 0})
          // DP spec requires link rate in {0x06, 0x0a, 0x14} and
          // lane count in {1, 2, 4}. Writing zeros is illegal, so
          // the sink cannot enter the training state.

      // Training loop
      for (lane = 0; lane < lane_count /* 0 */; lane++)
          // loop body never executes; training_lane[] stays
          // uninitialized and no training register is programmed

Since the sanitized sink values are always non-zero (link_rate >= 0x06,
lane_count >= 1), the clamping with a zero maximum unconditionally
forces the training parameters to zero. Clock recovery can never be
achieved, so link training fails deterministically.

Consequently, making these properties mandatory again cannot break
any existing device: a DT without them could never have worked in
the first place. Failing probe early with a clear error message is
more helpful than a silent link training failure at runtime.

Fixes: 0d0abd894ead ("drm: bridge: analogix/dp: add max link rate and lane count limit for RK3288")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://patch.msgid.link/20260828065153.590802-4-damon.ding@rock-chips.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index df9370e0ff230..5a0368c2f5912 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1635,6 +1635,7 @@ static int analogix_dp_dt_parse_pdata(struct analogix_dp_device *dp)
 {
 	struct device_node *dp_node = dp->dev->of_node;
 	struct video_info *video_info = &dp->video_info;
+	u32 val;
 
 	switch (dp->plat_data->dev_type) {
 	case RK3288_DP:
@@ -1651,10 +1652,14 @@ static int analogix_dp_dt_parse_pdata(struct analogix_dp_device *dp)
 		 * NOTE: those property parseing code is used for
 		 * providing backward compatibility for samsung platform.
 		 */
-		of_property_read_u32(dp_node, "samsung,link-rate",
-				     &video_info->max_link_rate);
-		of_property_read_u32(dp_node, "samsung,lane-count",
-				     &video_info->max_lane_count);
+		if (of_property_read_u32(dp_node, "samsung,link-rate", &val))
+			return dev_err_probe(dp->dev, -EINVAL,
+					     "Failed to get samsung,link-rate\n");
+		video_info->max_link_rate = val;
+		if (of_property_read_u32(dp_node, "samsung,lane-count", &val))
+			return dev_err_probe(dp->dev, -EINVAL,
+					     "Failed to get samsung,lane-count\n");
+		video_info->max_lane_count = val;
 		break;
 	}
 
-- 
2.53.0



