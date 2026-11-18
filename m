Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058147;
	b=V8TlzpPr4KXBYt7nJtZv4s/tqbCKo3cK1UsiaIXnR7N1PH2jhBc6TO8SmNpJtkvBzJh2
	 hMNBR9rJN1lJG58E//oS5cRIIK/opafeNsN+RwaCkdkBqP589w5plvdcnBBYqw93eqiCl
	 iQ70F6o3mQSxjz/HHh+iRz+Aty0dDczUF7CLJPvBT8Ck2H+SWUE+cb8xwiXWiY9AgKjkD
	 FaKBotANYi47B1oBaHqPGxOCTXQ58YLn/iSqZQQbs930zjFAWzxtKBryeLh3IOU2Zl84t
	 xnaE0Fc8kdVxKhkAzZuWdLoIEvfY0mN6DE5wBMX13eGihIVpYu1sMb8+rVNfjZlWIpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3HU8oDnxmoVlaP4LgpDLkkD5mOuuUMzTsCznyQDirE=;
	b=Bd2lzIvDRkNlAsNZ1kT3RYMv9sJ1f5BGPAID3rVlINiAkb3nv0abF/B5nT1AXjsXGRdC
	 0oY38o73f+C0/RA+p9tQYYS8j3CnUs0bKtMCm4N8yoLig5JcPwSOUhcd4OAlm5SEDXxMx
	 FIvYRCZYeGkiYRYFZ2oA28c6S1E0MVxltmgtU6hlE9a6xwNsePzBVjp43x2EAifErMY9Q
	 qI9HQd0v2/umznBDolQMqVolQKmIwtZPq6F5GHasv5fHQP2XkSEoUZYk9s8oTYMAC6+AP
	 K5imb4J/4fvT+rj1jWdkspaQZ1iexnmPOPEtfq1USgHvh4IOClT4QTvaS3e7Lf1EhVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iD8G/phB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43644606A320;
	Thu, 19 Nov 2026 03:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iD8G/phB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A9A1F000C5;
	Thu, 19 Nov 2026 03:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058147;
	bh=m3HU8oDnxmoVlaP4LgpDLkkD5mOuuUMzTsCznyQDirE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iD8G/phBYGNoEPC5tOIs6AoZ1vVLUEZxk48iG4HCuA4joMMAbh1+E0Cho5nS7ZeLd
	 rTJW0Rt91b2vTvSZ4f+gc79wUmOhgiBKhQKFLpOm1c7hzTU9E4FteK0n30tQOBbzcL
	 GwUXkNTpH14YrzGfx2wmWqQgMwPcglGRrdGBATP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Damon Ding <damon.ding@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0381/1848] drm/bridge: analogix_dp: Restore mandatory samsung DP DT properties
Date: Wed, 18 Nov 2026 15:40:19 +0100
Message-ID: <20261118145929.512913602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3d8f08d895612..d488c65f63083 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1643,6 +1643,7 @@ static int analogix_dp_dt_parse_pdata(struct analogix_dp_device *dp)
 {
 	struct device_node *dp_node = dp->dev->of_node;
 	struct video_info *video_info = &dp->video_info;
+	u32 val;
 
 	switch (dp->plat_data->dev_type) {
 	case RK3288_DP:
@@ -1659,10 +1660,14 @@ static int analogix_dp_dt_parse_pdata(struct analogix_dp_device *dp)
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



