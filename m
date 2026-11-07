Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061961;
	b=1KB5UUxqwsTPN5AmsrPiItgZpRRnCnvq8MKo57lGYgL42kyBDmzGp3mFpbWAXpTca7cn
	 SSgobhXqYE/6QxSo1KTZOFBx2m+HVGou9GffD4ExY8sN/RGwjYU8rTHnRiN8owE0T1uLc
	 P8/+qobo6FPg9El43X0f7dX3AIQABdyTuf+pdO3dg2E8L36bPW3ZDX1m3aSbNbYPO763G
	 2tbmt0V3CTc7tdqbvt+yNA+P80enjQYYVAnETvRt98SJblNO2qIdULu893FjOYm8pTU3m
	 CMaMeDdl/Yh4AxPXnpmPc0BlYOE3BpZ/JMTWFgQkOD9v4hRpGPOgHnBPjDz8RocSq1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQykZKR3mGtHfjaNJ4eHZxf29fTuC8ObaguN8F+7680=;
	b=zupps/mrkOL5/8zt9nNC/f7utYF40hwYzU3ShwTsryanZBqTjMoA/Low/jI0ZoVGjrla
	 u24PrWuumeR+br2yhJllvGRPkglJ0uhze56euqCFh91cFFnRS8DwiQcJ5npFFIXqK6Eop
	 wERY2ieK2RBXK3RvV6gGXIeu0wtPsWX1B57CcIqUvE4X7r4fOq2lGxet39xr/ON5QtO/X
	 UMdWm+1mp6X687I7IXjU4tL1jtKc4r9xRcbryvjsCYNeXMOLj+pLrh5a2uAYsJPxoyg9K
	 RyvLcNoUrKmJ89NG670u6HU2VgED4kc/eHnjGIDr+MbE7DSSgMBivwKQwO1f0l+mmxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poFZiCUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C684606A32E;
	Sat,  7 Nov 2026 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poFZiCUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE4F1F0089F;
	Sat,  7 Nov 2026 14:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061961;
	bh=TQykZKR3mGtHfjaNJ4eHZxf29fTuC8ObaguN8F+7680=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poFZiCUZvUc0dBl98PTQTXdKwpoJW9Qcalo3yIl7Cj6dj3BvJE3RGN4LP8ZnnNlwa
	 I0oBYjfgAuH1fhTAuchIbJ2ZzsM41jDL0JPYTX8fqzWPoHeL0TeEg0dlrc3jLmek/L
	 HRXuPp6XEunHuNDYyZ5pC+lyohLE716zsiOSuLLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Damon Ding <damon.ding@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0959/1536] drm/bridge: analogix_dp: Restore mandatory samsung DP DT properties
Date: Sat,  7 Nov 2026 08:49:35 -0500
Message-ID: <20261107135024.586381788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bfa88409a7ff0..bc8de97a92055 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1502,6 +1502,7 @@ static int analogix_dp_dt_parse_pdata(struct analogix_dp_device *dp)
 {
 	struct device_node *dp_node = dp->dev->of_node;
 	struct video_info *video_info = &dp->video_info;
+	u32 val;
 
 	switch (dp->plat_data->dev_type) {
 	case RK3288_DP:
@@ -1518,10 +1519,14 @@ static int analogix_dp_dt_parse_pdata(struct analogix_dp_device *dp)
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



