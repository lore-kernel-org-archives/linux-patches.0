Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE87F33A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302229; cv=none; b=l6ZWSTbBophB0iFcTf/PNyFelYVtPFx/svU9AqJdyv98bKUdqqu4q58k7jtE1KSe2kX3IG/mVS9wgePjVu82Mg1VSxj8uctXyu8FCn/L7Mj4uhzO2ZTXIdMwRuun+1ONieVfCqFZC4N6/Ycr+/WO5VplY24dZBrCkYUlDK9LBa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302229; c=relaxed/simple;
	bh=pQpY0IZ2yyM20fZsAY3RfVVV2qLQa9t7DpTeonpFKFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5TcRPSY8bJ4Hqfsb4RoR+9TaUP0jNZTo1ECnPn9hfr8lgmONUY+NFh6VR6KhoU3JuJhiEHnFMb5NYoL5OgDk5wwedzgUqQ2BSpVTjGJyW/Tzq4vdqsgWOOegJ4JgS+xxTIXo1okFyiINUJDPYthDHoejJqPmaEwYPnxy8X4CVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5H42RXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5H42RXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9B6C19424;
	Sat, 28 Feb 2026 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302228;
	bh=pQpY0IZ2yyM20fZsAY3RfVVV2qLQa9t7DpTeonpFKFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5H42RXIGu9tPtC6xFqYFzK+xgddldNUUMXXNuMvK5On9Ty9srHjmexY3BLnimHM8
	 1KltJGapiKalGrVls73x4nJWKFyOtYFE8BNU2txvdcogHvFGPHU86AatsV460fdd/x
	 zcOB0+LeFDN0ge1dfu6arZSXXIc/ROp2yjtBcwYDNf1Cz6WkQIcwvkuD9y+1Q/Rv3K
	 TA5l3T/mWHjOa2oZ7V6Se0mMgntYwOdIsJSC/Z2s6GL8hWW9Ya2snkOu23yAt/ErZv
	 vVIHywvgLulhWvU73QGAgi8jKxr93hXClg7r6Rwwbhn5l8GVA8AYA0rW05aqE6sVSB
	 8vwhdUNrOc36g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/283] mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA
Date: Sat, 28 Feb 2026 13:06:20 -0500
Message-ID: <20260228180709.1583486-238-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 81a2c31257411296862487aaade98b7d9e25dc72 ]

The QIXIS FPGA found on Layerscape boards such as LX2160AQDS, LS1028AQDS
etc deals with power-on-reset timing, muxing etc. Use the simple-mfd-i2c
as its core driver by adding its compatible string (already found in
some dt files). By using the simple-mfd-i2c driver, any child device
will have access to the i2c regmap created by it.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250707153120.1371719-1-ioana.ciornei@nxp.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 8f34c1a64c53 ("mfd: simple-mfd-i2c: Add Delta TN48M CPLD support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/simple-mfd-i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 22159913bea03..f7798bd922224 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -99,6 +99,8 @@ static const struct of_device_id simple_mfd_i2c_of_match[] = {
 	{ .compatible = "maxim,max5970", .data = &maxim_max5970},
 	{ .compatible = "maxim,max5978", .data = &maxim_max5970},
 	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
+	{ .compatible = "fsl,lx2160aqds-fpga" },
+	{ .compatible = "fsl,ls1028aqds-fpga" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, simple_mfd_i2c_of_match);
-- 
2.51.0

