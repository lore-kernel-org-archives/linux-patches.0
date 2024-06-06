Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED2196D91;
	Thu,  6 Jun 2024 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682980; cv=none; b=A8WuTm72ZjUUQ2b68UkQssLLI6k4Ja44ntGcTwx/EvE9A7wjfkM5FbU0PAoFkLXWU6b0Xz5s7wuqokn/gP5KjPBjhry7zQEHYNn5oAke/4zdAvc+HnypkxHmX8DdhN4bEZk1mJ+D3f5UpB36ksaDSHg0KSGqT7mBGlmHHzFDX3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682980; c=relaxed/simple;
	bh=H/2P4IKqQQt+trPLP1+Mp4gPQrWXLjcIwx1Wh4xINgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCA0G+wlU9Y/cqILS+BzrzaG+TiDZgUB1XUejfAypLL32FqQTOi3DiH/OYYSu+JonqdUnWImZYu9rRb0eFtmBqtggNLTDyBy7/nnVjvMf9paOH5bulRIVdTFpQoySSgjNfGsUtjf7d/WSnBy3Ii47dEkmoMHBM1/r/m6fmyzkos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5Z4bvtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5Z4bvtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052F0C2BD10;
	Thu,  6 Jun 2024 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682980;
	bh=H/2P4IKqQQt+trPLP1+Mp4gPQrWXLjcIwx1Wh4xINgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5Z4bvtqd2gH8EYE0hukIOnuqmF6ZNj9MOZ6Lw03pnIvirGmCPo+e2/7RTFP7sEWT
	 C+lFJrD98W2+bartnXNaRLcR0Q5hadEaxjw5Ej/5vWAQSL8UrjzIrFuYfGnoLCGdqC
	 Z2SzbmQn4ClBOeTNCoMo2oxnRLlT2bPy2ZctcHXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Fabio Estevam <festevam@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 161/374] media: ov2680: Do not fail if data-lanes property is absent
Date: Thu,  6 Jun 2024 16:02:20 +0200
Message-ID: <20240606131657.303794329@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 24034af644fc01126bec9850346a06ef1450181f ]

Since commit 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint
property verification") the ov2680 driver no longer probes when the
'data-lanes' property is absent.

The OV2680 sensor has only one data lane, so there is no need for
describing it the devicetree.

Remove the unnecessary data-lanes property check.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Fixes: 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint property verification")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index a857763c7984c..4577a8977c85a 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -1116,13 +1116,6 @@ static int ov2680_parse_dt(struct ov2680_dev *sensor)
 	sensor->pixel_rate = sensor->link_freq[0] * 2;
 	do_div(sensor->pixel_rate, 10);
 
-	/* Verify bus cfg */
-	if (bus_cfg.bus.mipi_csi2.num_data_lanes != 1) {
-		ret = dev_err_probe(dev, -EINVAL,
-				    "only a 1-lane CSI2 config is supported");
-		goto out_free_bus_cfg;
-	}
-
 	if (!bus_cfg.nr_of_link_frequencies) {
 		dev_warn(dev, "Consider passing 'link-frequencies' in DT\n");
 		goto skip_link_freq_validation;
-- 
2.43.0



