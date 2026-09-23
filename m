Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A247A0C4;
	Wed, 23 Sep 2026 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175333; cv=none; b=VT9FSswf4UcWmSSRemRmM7fCgX8x4wGjd6E9mygQOsocOwzeD7zCNG6ZGpQGbrN/2i8vqIKISRTRvtWoYZip060U75Hu/Z4brfSfO/tH8rY+BQv+JNS6NzRrf4+KaBGLjCsdmnAd4P3SZZnH/8yeVIEOJmOOLdUZ9jJ9IEl/hFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175333; c=relaxed/simple;
	bh=wVc/tRq2pzd3lPlo+JvUoM1kDy82gx258OM9h1p+sbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJlb46VmNMHM4mcpMJAgiDJX5WRpflFiQcVRSDxWuhecyTvwdjA+Qpc/3ZafSAfsN1ks6d8MC8mnLh1a+ITkxw3WEzxGMnBnFZzFMD/5JR+XVzHyUQx+1mpe6PPgkY0x9BK3CP66KZdC87Nusp4WDKHIWgYIvhCVR7PW19t4060=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNe/t+Bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNe/t+Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7131F000FF;
	Wed, 23 Sep 2026 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175332;
	bh=IQnuN7pA2n3dgrsBooxubJ2Vr5AzqatcJmnK40Wxthk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNe/t+BvDo9jRuuqZ1DV9acXKUKMF8BeVsnx5BbZENID7DjVH2K+XuImyK0qyHoBu
	 CGQEMW5xFve7p9/PZmfTvPIoaYdn6bEumuAE6oPLWwA0WnNdDq5dTj5PO/TE+hJZWG
	 R8Dm4h58906suJRuVBIu8JM6NYKIpbScANhVOWtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 395/398] ASoC: sdw_utils: subtract the endpoint that is not present
Date: Wed, 23 Sep 2026 16:07:49 +0200
Message-ID: <20260923140653.709044230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit cb0ae6f22790ead71a866f94c7a5a70ad56af16a upstream.

When asoc_sdw_count_sdw_endpoints() count the num_ends, it doesn't skip
the unpresented endpoints. But, asoc_sdw_parse_sdw_endpoints() will skip
the unpresented endpoints either by quirk or the SDCA function doesn't
show up the endpoint. The endpoint number mismatches between count and
parse and the machine driver will show up a warning about it.

Fixes: 26ee34d2f5c7 ("ASoC: sdw_utils: Add codec_conf for every DAI")
Closes: https://github.com/thesofproject/linux/issues/5620
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251212121112.3313017-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1441,8 +1441,10 @@ int asoc_sdw_parse_sdw_endpoints(struct
 					 * endpoint check is not necessary
 					 */
 					if (dai_info->quirk &&
-					    !(dai_info->quirk_exclude ^ !!(dai_info->quirk & ctx->mc_quirk)))
+					    !(dai_info->quirk_exclude ^ !!(dai_info->quirk & ctx->mc_quirk))) {
+						(*num_devs)--;
 						continue;
+					}
 				} else {
 					/* Check SDCA codec endpoint if there is no matching quirk */
 					ret = is_sdca_endpoint_present(dev, codec_info, adr_link, i, j);
@@ -1450,8 +1452,10 @@ int asoc_sdw_parse_sdw_endpoints(struct
 						return ret;
 
 					/* The endpoint is not present, skip */
-					if (!ret)
+					if (!ret) {
+						(*num_devs)--;
 						continue;
+					}
 				}
 
 				dev_dbg(dev,


