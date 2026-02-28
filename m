Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1C6340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301024; cv=none; b=L2GqcYmvEbedwvipVHUHy9NRgNqjJY1tf+Zg1EOE/ksnwutMYeeXeGN1AKScvMgNL4+ziIRGAqsghyXDPBxP8ISMpPLXBquAvHoRd06uxZl/OCDNJc8v4xzkF7/ZoMmKi2uYRS33qJPGqVrg0IRySVYcucGMX19LW2klwVFj704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301024; c=relaxed/simple;
	bh=CYMxtiBY6+W5eiUXskeWyFEavQ9L2866Ci7dWzcUohk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgLA/5hIOSsPFGUNUjKKV8nS0jM7g73kGkWXWdZ9ow3PVgCWV6D5eapfKex16/4vZCEU83KdWgPC/o1Q7uoAetlvZUN4ZtqD8vHZK8HGLv8SUwgQ2Wq2zzZtXllVVu9dxreICaO6tsiwbxJgbeIkevNbpEpTblDlnJjZJ9LKSpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6DtegBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6DtegBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6182C19423;
	Sat, 28 Feb 2026 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301024;
	bh=CYMxtiBY6+W5eiUXskeWyFEavQ9L2866Ci7dWzcUohk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6DtegBYvnc7igR7Mp603SKLPCXifoShHeTAUzqMF51qyxxmW/gV9XFW7bBgX2mPG
	 ogcc0xED3YjE7ar7EPHvFpBMBCYvVEOmJ/eMdo8CmdHJp3Cd+BuouiqcWx2qh7Q4MF
	 rXOHKpYmMsi8PnLQqBd0FDHGG2NCXW48N/r+lU+h95r07NA7Knm1N9h4fPJ/KU5uUH
	 fM93buDsSWUtRL2p5OJfKvzZwdA4kbt7gZO80Nd469Ul4wGlpUw+xDW8SUGGiTzGjk
	 +gV609re0AZUBxfU1js8Pz38LnkQnytGeh6EVKSIMvRWenBs9ZVGH+BJIWxiLTCj3R
	 dwIfzQCzTXPLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/752] media: mt9m114: Return -EPROBE_DEFER if no endpoint is found
Date: Sat, 28 Feb 2026 12:37:52 -0500
Message-ID: <20260228174750.1542406-161-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 437e1f6a960035166495a5117aacbc596115eeb6 ]

With IPU# bridges, endpoints may only be created when the IPU bridge is
initialized. This may happen after the sensor driver's first probe().

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/mt9m114.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/mt9m114.c b/drivers/media/i2c/mt9m114.c
index 554f25071cca6..b1325e2cd1321 100644
--- a/drivers/media/i2c/mt9m114.c
+++ b/drivers/media/i2c/mt9m114.c
@@ -2360,11 +2360,17 @@ static int mt9m114_parse_dt(struct mt9m114 *sensor)
 	struct fwnode_handle *ep;
 	int ret;
 
+	/*
+	 * On ACPI systems the fwnode graph can be initialized by a bridge
+	 * driver, which may not have probed yet. Wait for this.
+	 *
+	 * TODO: Return an error once bridge driver code will have moved
+	 * to the ACPI core.
+	 */
 	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
-	if (!ep) {
-		dev_err(&sensor->client->dev, "No endpoint found\n");
-		return -EINVAL;
-	}
+	if (!ep)
+		return dev_err_probe(&sensor->client->dev, -EPROBE_DEFER,
+				     "waiting for fwnode graph endpoint\n");
 
 	sensor->bus_cfg.bus_type = V4L2_MBUS_UNKNOWN;
 	ret = v4l2_fwnode_endpoint_alloc_parse(ep, &sensor->bus_cfg);
-- 
2.51.0

