Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8251536C9CE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302230; cv=none; b=HEUwKXT0HrsvP64aQXQT9QtrjGSZwyzst1helXu53FeSP50g1CqDpEJvjbGrmJtcifGLHoVBbMoN4tVszBhCAR+aISfZET9yIaqJeHR+UonERFtS1S9X4wzSbN3Qo/gEl+0AVJbKLSt6ixkYbp8JKimEud24FXEwrQ8Y2aCyI/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302230; c=relaxed/simple;
	bh=hGXZ59kvmcx95ywRU43kVK6zh7LEe4wodG/c3kPLo9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5T6gsZOni0l2T70cgLV3XxndogFdfRh+ARZbePKd6uAtUcwJz3INFgjTU17/K1KgKnLherGz/rUSaM8ITnOFH6RWJEyJNBr1oaLSzWMv9HBs9tAJ0xLefebn93tL+xZ1STesYpdRVaifigKHp0lnQ9N4+qKmRiWeimun2JxqG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qu7+mbdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qu7+mbdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C15C19425;
	Sat, 28 Feb 2026 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302230;
	bh=hGXZ59kvmcx95ywRU43kVK6zh7LEe4wodG/c3kPLo9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu7+mbdd9Z19yIdm0Kjq1tG3xJbVmPA8sNakrRiE0UgTNEjuQGiU+oZ40KPvgOUZa
	 7gXQVXt6alt1uH+dmL8rR7kzCoLsnOp+5IkuNaLoGDaHya9SeuVrktrJbB+ZSszIYM
	 2ylSrImMhI7ZhDTkK5DC8cb9P14cqxgxV5nu8bxayCn/DYLmmnVsVtA463khKcVZDf
	 n2+xmaLSHWf51KLUJod2rgdqkO8VSJO63G3DVeE/7Cnfhqq5IAnG48ZmAFpxR/55vX
	 mTuT92F9QhbzVXlLhVLsCm9QmTwVIVyv6MnaLDj+A/yJQ6f4d2KY4JSaGR39ZLwS80
	 1j9rQbMlKTMEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/283] mfd: simple-mfd-i2c: Keep compatible strings in alphabetical order
Date: Sat, 28 Feb 2026 13:06:22 -0500
Message-ID: <20260228180709.1583486-240-sashal@kernel.org>
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

[ Upstream commit 3ed50d77924ff2e35918739df145dd429cee0ce4 ]

Reorder the of_device_id structures so that they are in alphabetical
order.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 8f34c1a64c53 ("mfd: simple-mfd-i2c: Add Delta TN48M CPLD support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/simple-mfd-i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 63ac263888606..0cca7a9044cd4 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -110,13 +110,13 @@ static const struct simple_mfd_data spacemit_p1 = {
 };
 
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
+	{ .compatible = "fsl,ls1028aqds-fpga" },
+	{ .compatible = "fsl,lx2160aqds-fpga" },
 	{ .compatible = "kontron,sl28cpld" },
-	{ .compatible = "silergy,sy7636a", .data = &silergy_sy7636a},
 	{ .compatible = "maxim,max5970", .data = &maxim_max5970},
 	{ .compatible = "maxim,max5978", .data = &maxim_max5970},
 	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
-	{ .compatible = "fsl,lx2160aqds-fpga" },
-	{ .compatible = "fsl,ls1028aqds-fpga" },
+	{ .compatible = "silergy,sy7636a", .data = &silergy_sy7636a},
 	{ .compatible = "spacemit,p1", .data = &spacemit_p1, },
 	{}
 };
-- 
2.51.0

