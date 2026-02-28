Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B094A2E27
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300881; cv=none; b=LLk7jg6FbS+GLquMkBJVP9Pa526xB0wuHj+1ITezqkZpqcyjg5GjWBQGfAqsS0NW5B49gd31pIPD0CUi7/cZX3M6pRf96jahNnwgGfalF7ld9GBFHY8P7AUFtCiv366Q8xAQjRaQM6sV0ZqASmkc988klS6sxTzJ1ufazO9le9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300881; c=relaxed/simple;
	bh=bZJ3rfOPjv7sv5q4HAz0z1txbRUKRRKW+yJTZKrRPXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kcH6WaW8dIqTI53UYs2D1/4E9Ub427aeDcvjnzt369P35Nj1Ng49+YDV1SrqwuY/fmyvO9AeSHiA1BDIxkcBsy5EddufUcyOuqSKEZtry++93smdtw4Zx1C41PnVQBoaHVJt6ZtiCHKxAJ8zt5aXJMnh2iIVooMm2PdCR0+JZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nqb0zNqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nqb0zNqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0CAC19424;
	Sat, 28 Feb 2026 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300881;
	bh=bZJ3rfOPjv7sv5q4HAz0z1txbRUKRRKW+yJTZKrRPXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nqb0zNqLX1xWhWMQsu4sOmEle+xRJzyfZZlG3Y5Q1+aA37qxXkDZnjBNzG9a44TXm
	 NGkqn7KxDJew4NYwWv4jLKouWddTgvT95h9hRp/wJmCrwMglI4yqxjnoX7ejbYHW4c
	 WJ4L6+OYbImGG/wadMmRWg58y1RtkJiAg7LrgYSTVqqq61syqx71wbqY+oenDgvufg
	 n4XnOeWpIugpXKVJLCmSLreQKriFUWEnmeRJbRG5EbWkEzBVn4pX1AUEuEolteMcrV
	 rK+vfR7cHIznaeNLVNIKWSsemKBoszOvig0CmoBESHyOygfWR0Jx2MO7n5nUNQfo1O
	 9YvlStP3LVcWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/752] rtc: max31335: use correct CONFIG symbol in IS_REACHABLE()
Date: Sat, 28 Feb 2026 12:35:18 -0500
Message-ID: <20260228174750.1542406-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d5aca9a17f6de884febc56018f92d743b8ea1298 ]

IS_REACHABLE() is meant to be used with full symbol names from a kernel
.config file, not the shortened symbols used in Kconfig files, so
change HWMON to CONFIG_HWMON in 3 places.

Fixes: dedaf03b99d6 ("rtc: max31335: add driver support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260108045432.2705691-1-rdunlap@infradead.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-max31335.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-max31335.c b/drivers/rtc/rtc-max31335.c
index 23b7bf16b4cd5..952b455071d68 100644
--- a/drivers/rtc/rtc-max31335.c
+++ b/drivers/rtc/rtc-max31335.c
@@ -591,7 +591,7 @@ static struct nvmem_config max31335_nvmem_cfg = {
 	.size = MAX31335_RAM_SIZE,
 };
 
-#if IS_REACHABLE(HWMON)
+#if IS_REACHABLE(CONFIG_HWMON)
 static int max31335_read_temp(struct device *dev, enum hwmon_sensor_types type,
 			      u32 attr, int channel, long *val)
 {
@@ -672,7 +672,7 @@ static int max31335_clkout_register(struct device *dev)
 static int max31335_probe(struct i2c_client *client)
 {
 	struct max31335_data *max31335;
-#if IS_REACHABLE(HWMON)
+#if IS_REACHABLE(CONFIG_HWMON)
 	struct device *hwmon;
 #endif
 	const struct chip_desc *match;
@@ -727,7 +727,7 @@ static int max31335_probe(struct i2c_client *client)
 		return dev_err_probe(&client->dev, ret,
 				     "cannot register rtc nvmem\n");
 
-#if IS_REACHABLE(HWMON)
+#if IS_REACHABLE(CONFIG_HWMON)
 	if (max31335->chip->temp_reg) {
 		hwmon = devm_hwmon_device_register_with_info(&client->dev, client->name, max31335,
 							     &max31335_chip_info, NULL);
-- 
2.51.0

