Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8547CC83;
	Sat, 28 Feb 2026 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301334; cv=none; b=GS3yWLhcjmy7qPXrN3yJhkJmogih7AxtCyf359RJ4g+1ZZv0754PJOcnCSLZJB0XW82ijhPuXVAjKePhwAoAfxoWv9g1Rgwg/HTBDyx6x9Qlom3QZrjMUwWYJ2RgCtiL2dOJZEAdcUOZgwxobagrDvO3taKPnhBIq2J99uCN4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301334; c=relaxed/simple;
	bh=ohQ9CucGTQ18a4Fp4lripQpC9sI6uM+kDC8e0VngH0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwz/vK4lt8mbzExH3IWI/LZOKwFWIGEy3e8gmJJocxCWjWKPZmrbrWwmVzuZYjcdNAWd7GLxn8Gps32wasaSLnRWDWwmSSC78f4gCe4Omm5/L5Es6HNoFgq3LUp2jL37uqSb1pQaB9rHLf/nDrTMo3jegYGO1NrZ+r9yNtHy2uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUnmG9zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUnmG9zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ED1C19423;
	Sat, 28 Feb 2026 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301334;
	bh=ohQ9CucGTQ18a4Fp4lripQpC9sI6uM+kDC8e0VngH0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUnmG9zRlKqKiJ3lK6btbRhAcVOFK+IT//oP+XJ9hcn9NCSLYOtQvToIIPjesRi7K
	 jJsmydU3kbhOKgbdY3PAjXkZO+5hPlciCbFUKK+JMyykm/LvdIH3Fs0YGpvghfbA66
	 0bX2nDaVXZd4Z6OyHjFHJCIhzQMul3iSxNtEDbxRCFD4CljbXEuadsQB66VxsMvsE1
	 9DlimHmTwsxpzhFkaHBzL6TkUQGe6FEMKpcWtjDNWCNRECsYXEpuVrX04sn9UNT0Pp
	 UvdBgZ6snII92xm+qWuBToI6U9w0/Y6PjS2YfMESWW3r1gXZdFFO2WlKajQShKN+KM
	 EVmfS0m1jjxTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <hansg@kernel.org>,
	stable@vger.kernel.org,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/752] media: i2c: ov01a10: Fix test-pattern disabling
Date: Sat, 28 Feb 2026 12:43:52 -0500
Message-ID: <20260228174750.1542406-521-sashal@kernel.org>
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

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 409fb57c1b3deada4b8e153eb6344afb3c2dfb9c ]

When the test-pattern control gets set to 0 (Disabled) 0 should be written
to the test-pattern register, rather then doing nothing.

Fixes: 0827b58dabff ("media: i2c: add ov01a10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov01a10.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov01a10.c b/drivers/media/i2c/ov01a10.c
index dd2b6d381175a..3ad516e4d3698 100644
--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -249,9 +249,8 @@ static const struct ov01a10_reg sensor_1280x800_setting[] = {
 static const char * const ov01a10_test_pattern_menu[] = {
 	"Disabled",
 	"Color Bar",
-	"Top-Bottom Darker Color Bar",
-	"Right-Left Darker Color Bar",
-	"Color Bar type 4",
+	"Left-Right Darker Color Bar",
+	"Bottom-Top Darker Color Bar",
 };
 
 static const s64 link_freq_menu_items[] = {
@@ -406,10 +405,8 @@ static int ov01a10_update_digital_gain(struct ov01a10 *ov01a10, u32 d_gain)
 
 static int ov01a10_test_pattern(struct ov01a10 *ov01a10, u32 pattern)
 {
-	if (!pattern)
-		return 0;
-
-	pattern = (pattern - 1) | OV01A10_TEST_PATTERN_ENABLE;
+	if (pattern)
+		pattern |= OV01A10_TEST_PATTERN_ENABLE;
 
 	return ov01a10_write_reg(ov01a10, OV01A10_REG_TEST_PATTERN, 1, pattern);
 }
-- 
2.51.0

