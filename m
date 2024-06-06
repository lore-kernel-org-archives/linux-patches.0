Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A382197541;
	Thu,  6 Jun 2024 14:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683696; cv=none; b=C+DjiJU/vhsEzcDbSJhQR+gLrQE2nArk3eG+p/5MggO000OhMeEvhv6+ZIpnffTNtzQn/hanom9nxH+lBrzypLqz21QkE1qSIurF76x0K5Rd3RqQ0uKwqHSRLZp9lKu+ryNSVz6/1qzaP7A1OGWjlcw2wN+GT2PRYrf9Sro0RKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683696; c=relaxed/simple;
	bh=B1lL10x7SuEnanr97G80Scr0t8PMNwFkTIFYdgWEaWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnHqwDARcDUMKrKLAAgLKapQD+VqvFMMnabqWNF+z3oheSmTkda5FUryXC1oSj2hL0hw+kENd4S7iTttUS6uhDaa6OKqwDS0dSFf5jn+ynXFFtWeg+Ws48/ERtnJl4qwTCQL9+Cpbc407J9xSChttcGiGkcovHby1wTunxfykZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZy5QJIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZy5QJIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CBCC2BD10;
	Thu,  6 Jun 2024 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683696;
	bh=B1lL10x7SuEnanr97G80Scr0t8PMNwFkTIFYdgWEaWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZy5QJIQWhdQbJydgUw1RbMSVGo2wl8YeerdW1Uy+JTJ1rSBdmv+FCGoSNePiipBY
	 Td5xaGeuTZwphfau/jQDezOZnkceYyHa2Cqx+HFVmmnfRI9TI1yziHdNsydJgvD4wa
	 47A024p7OIPLGTsjeuaWhxJB38fh8F8Iki56f2bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 570/744] media: ov2680: Allow probing if link-frequencies is absent
Date: Thu,  6 Jun 2024 16:04:02 +0200
Message-ID: <20240606131750.738162820@linuxfoundation.org>
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

[ Upstream commit fd2e66abd729dae5809dbb41c6c52a6931cfa6bb ]

Since commit 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint
property verification") the ov2680 no longer probes on a imx7s-warp7:

ov2680 1-0036: error -EINVAL: supported link freq 330000000 not found
ov2680 1-0036: probe with driver ov2680 failed with error -22

As the 'link-frequencies' property is not mandatory, allow the probe
to succeed by skipping the link-frequency verification when the
property is absent.

Cc: stable@vger.kernel.org
Fixes: 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint property verification")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 24034af644fc ("media: ov2680: Do not fail if data-lanes property is absent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 7b1d9bd0b60f3..1163062c41c59 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -1111,18 +1111,23 @@ static int ov2680_parse_dt(struct ov2680_dev *sensor)
 		goto out_free_bus_cfg;
 	}
 
+	if (!bus_cfg.nr_of_link_frequencies) {
+		dev_warn(dev, "Consider passing 'link-frequencies' in DT\n");
+		goto skip_link_freq_validation;
+	}
+
 	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++)
 		if (bus_cfg.link_frequencies[i] == sensor->link_freq[0])
 			break;
 
-	if (bus_cfg.nr_of_link_frequencies == 0 ||
-	    bus_cfg.nr_of_link_frequencies == i) {
+	if (bus_cfg.nr_of_link_frequencies == i) {
 		ret = dev_err_probe(dev, -EINVAL,
 				    "supported link freq %lld not found\n",
 				    sensor->link_freq[0]);
 		goto out_free_bus_cfg;
 	}
 
+skip_link_freq_validation:
 	ret = 0;
 out_free_bus_cfg:
 	v4l2_fwnode_endpoint_free(&bus_cfg);
-- 
2.43.0



