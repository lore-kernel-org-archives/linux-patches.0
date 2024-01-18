Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE43B22F0B;
	Thu, 18 Jan 2024 10:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575102; cv=none; b=BjOfSAWhu9jH93nBLe+JdWgYu/dWFhmQmK8PVnq8mCjzYI5QbQ9NyEPlY05pHDhoowGs7FGJWbAydhsJOchAI9uNjTZYWBYRVXK/B4wkyQjQ4FwnxbXsOZFIsU6n6idc9A7jOI2OuvQKMb45vcIQ+BseDIaQ4gtS65gN893Or8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575102; c=relaxed/simple;
	bh=AQV4vTYqAd38fUigTLTBuuxNZlinffmo9+onCv0NOnI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=eggtQf3MPAj3dNLhxyHgJDAAujpV92Jr8Y8FBAL9PEBnL6JCsNsDU43BlSUAsVxHra40KkieOVZf6K9UlO9KXqqACnXMCBNgOzEOoSLaQIlwuvmTR5K5GnbyK0KnzZgGg3wBUqPTaClAbJ2tC+ofx0QJaoJukXChNxmYVcVBjo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vs2tFo1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vs2tFo1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F078C433F1;
	Thu, 18 Jan 2024 10:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575101;
	bh=AQV4vTYqAd38fUigTLTBuuxNZlinffmo9+onCv0NOnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vs2tFo1hAOsfU8hpYkPUHoloAQi8UbrOcCXuQkSL/Cvr9pLxjPjShjJW4SHc1DrA2
	 1E3G/ECu18c0QUE53RnkJgcS+1Uham77pCRY6dPODn+r7woOcdrHt34Q/BpMmbBB+3
	 Fk7lZ0rTMgEvYvLeQbk4t9eKzdbhNbLjlTbGf22Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/150] ALSA: hda: intel-nhlt: Ignore vbps when looking for DMIC 32 bps format
Date: Thu, 18 Jan 2024 11:47:14 +0100
Message-ID: <20240118104320.589792733@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 7b4c93a50a2ebbbaf656cc4fa6aca74a6166d85b ]

When looking up DMIC blob from the NHLT table and the format is 32 bits,
ignore the vbps matching for 32 bps for DMIC since some NHLT table have
the vbps as 24, some have it as 32.
The DMIC hardware supports only one type of 32 bit sample size, which is
24 bit sampling on the MSB side and bits[1:0] is used for indicating the
channel number.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20231127111658.17275-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-nhlt.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/sound/hda/intel-nhlt.c b/sound/hda/intel-nhlt.c
index 2c4dfc0b7e34..696a958d93e9 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -238,7 +238,7 @@ EXPORT_SYMBOL(intel_nhlt_ssp_mclk_mask);
 
 static struct nhlt_specific_cfg *
 nhlt_get_specific_cfg(struct device *dev, struct nhlt_fmt *fmt, u8 num_ch,
-		      u32 rate, u8 vbps, u8 bps)
+		      u32 rate, u8 vbps, u8 bps, bool ignore_vbps)
 {
 	struct nhlt_fmt_cfg *cfg = fmt->fmt_config;
 	struct wav_fmt *wfmt;
@@ -255,8 +255,12 @@ nhlt_get_specific_cfg(struct device *dev, struct nhlt_fmt *fmt, u8 num_ch,
 		dev_dbg(dev, "Endpoint format: ch=%d fmt=%d/%d rate=%d\n",
 			wfmt->channels, _vbps, _bps, wfmt->samples_per_sec);
 
+		/*
+		 * When looking for exact match of configuration ignore the vbps
+		 * from NHLT table when ignore_vbps is true
+		 */
 		if (wfmt->channels == num_ch && wfmt->samples_per_sec == rate &&
-		    vbps == _vbps && bps == _bps)
+		    (ignore_vbps || vbps == _vbps) && bps == _bps)
 			return &cfg->config;
 
 		cfg = (struct nhlt_fmt_cfg *)(cfg->config.caps + cfg->config.size);
@@ -289,6 +293,7 @@ intel_nhlt_get_endpoint_blob(struct device *dev, struct nhlt_acpi_table *nhlt,
 {
 	struct nhlt_specific_cfg *cfg;
 	struct nhlt_endpoint *epnt;
+	bool ignore_vbps = false;
 	struct nhlt_fmt *fmt;
 	int i;
 
@@ -298,7 +303,26 @@ intel_nhlt_get_endpoint_blob(struct device *dev, struct nhlt_acpi_table *nhlt,
 	dev_dbg(dev, "Looking for configuration:\n");
 	dev_dbg(dev, "  vbus_id=%d link_type=%d dir=%d, dev_type=%d\n",
 		bus_id, link_type, dir, dev_type);
-	dev_dbg(dev, "  ch=%d fmt=%d/%d rate=%d\n", num_ch, vbps, bps, rate);
+	if (link_type == NHLT_LINK_DMIC && bps == 32 && (vbps == 24 || vbps == 32)) {
+		/*
+		 * The DMIC hardware supports only one type of 32 bits sample
+		 * size, which is 24 bit sampling on the MSB side and bits[1:0]
+		 * are used for indicating the channel number.
+		 * It has been observed that some NHLT tables have the vbps
+		 * specified as 32 while some uses 24.
+		 * The format these variations describe are identical, the
+		 * hardware is configured and behaves the same way.
+		 * Note: when the samples assumed to be vbps=32 then the 'noise'
+		 * introduced by the lower two bits (channel number) have no
+		 * real life implication on audio quality.
+		 */
+		dev_dbg(dev,
+			"  ch=%d fmt=%d rate=%d (vbps is ignored for DMIC 32bit format)\n",
+			num_ch, bps, rate);
+		ignore_vbps = true;
+	} else {
+		dev_dbg(dev, "  ch=%d fmt=%d/%d rate=%d\n", num_ch, vbps, bps, rate);
+	}
 	dev_dbg(dev, "Endpoint count=%d\n", nhlt->endpoint_count);
 
 	epnt = (struct nhlt_endpoint *)nhlt->desc;
@@ -307,7 +331,8 @@ intel_nhlt_get_endpoint_blob(struct device *dev, struct nhlt_acpi_table *nhlt,
 		if (nhlt_check_ep_match(dev, epnt, bus_id, link_type, dir, dev_type)) {
 			fmt = (struct nhlt_fmt *)(epnt->config.caps + epnt->config.size);
 
-			cfg = nhlt_get_specific_cfg(dev, fmt, num_ch, rate, vbps, bps);
+			cfg = nhlt_get_specific_cfg(dev, fmt, num_ch, rate,
+						    vbps, bps, ignore_vbps);
 			if (cfg)
 				return cfg;
 		}
-- 
2.43.0



