Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAB41C6193;
	Thu,  6 Jun 2024 14:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683696; cv=none; b=lvtVIENkTqK3zSZCDsAWsh/r6DPu6fkGCVKi5aqA4N+ITYBHrDoooRfGFt/0kmC3EmLhNrTSmsKR4YB7aIpea51yREf0uGk0oz0pt0Kw5Fwqo7VfWG2J6BE8rM1uIg3+CA6HkLg5Rk2AlJJ0fYnP7gKxAOXJ8d+iPNzkX8WAFZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683696; c=relaxed/simple;
	bh=7QoBJZXHja3KzCO72Yd0u2RSSvz37Pnl7COOY338JYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGPYYKFthSI0QgdOvB76tMExCvN/l7UJHwnyw9FCdo2nIktcsfhXz4b1pqTJ8dH0qYM00Cwg2q5KejgmklllYPg8NfLAzejJTVu4y3QbZ16js4+2qGE3qn+q6t50hy5PKrrHoXftQV/udeVIobfKXT491GbDUDVJIGSZwHxLv9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSVvPn2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSVvPn2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F92C2BD10;
	Thu,  6 Jun 2024 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683696;
	bh=7QoBJZXHja3KzCO72Yd0u2RSSvz37Pnl7COOY338JYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSVvPn2np6BypZYHKFpZqYNOyO55joU7v82ep7SoBVLQepYrrJodA9q+XaA2SSDLt
	 0O0UicWWWpH0qqFOXg7qXmccaHVJOnXz3l3+YAEcwdSfSjQNNtWNzd1QJ2ouH6uovE
	 ZKFkZjnu9Wts1HDatxFI1sQllrzIa9K+iErg8lTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Fabio Estevam <festevam@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 571/744] media: ov2680: Do not fail if data-lanes property is absent
Date: Thu,  6 Jun 2024 16:04:03 +0200
Message-ID: <20240606131750.771746813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 1163062c41c59..6436879f95c01 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -1104,13 +1104,6 @@ static int ov2680_parse_dt(struct ov2680_dev *sensor)
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



