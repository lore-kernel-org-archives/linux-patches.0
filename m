Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3241B33A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302228; cv=none; b=kT2hu95ytGekOTFRO+KZHg3b7C+dE18QbL7+7UWFXtcubZB+D+VO0VdocWF636qUvayjro9dfXcIr7Ef9HVPZn787ZM4VHVW/EMa8/a5oTY5xkcKdK2LH/ODz4HeXpO3Yn3lint5P00p5gptTTaMdGaHTpJUAePTiBAEWJQvceM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302228; c=relaxed/simple;
	bh=SlhDBqUycxRmFqTOxPJTXIaV2tAqSW0l2JmOq1MxwvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSICrt5Mb9T9aSYgKnckQ6+u+T9yd3ZL3SkyywggHn/wSmhQklUQkBqyQwpVdpkjTbJ3s1BTTK3gDv6ROGqcjTvxyZgSFQzQWRb96Pf4KKaQZ7uK9iKjEThx9sUsWMYvMJ8n+d+nvQKPd+vrm57HOCkFzy5QlujXN8VVWc5mOeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFZ+d8UF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFZ+d8UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDEAC19424;
	Sat, 28 Feb 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302228;
	bh=SlhDBqUycxRmFqTOxPJTXIaV2tAqSW0l2JmOq1MxwvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFZ+d8UFamh0Dml4XrCktXMjZe+EPkIG4VlSNt3TYQqyw7W0Czd8Dl1E9SShWF5Ug
	 NENXBzCwmNqld/z/yqkQfmbw6UkiH2UvPgMs6Xc/6gcgiQTlrFI73DUtFiP3I0QAj9
	 hqM7z53JcBhCn/D4uWh9y2O9DCpk4ojev0x6ABvDYA7ZZfwesn/KtE3FvRLWOz3zT1
	 hdKc5G6F7UQOEcZqGjZY1sjHF+M+8wjlVv8f64sRG1Sxzu890H/njrpwjtk9mBXKG+
	 eARqWbPjztr/fi5DwLqaFF0ODXNh4GTNWSj/d1upjo/05iXbGhA/nEtjaPJlvH4CYD
	 74kgJoAbjX2fA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dzmitry Sankouski <dsankouski@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/283] mfd: simple-mfd-i2c: Add MAX77705 support
Date: Sat, 28 Feb 2026 13:06:19 -0500
Message-ID: <20260228180709.1583486-237-sashal@kernel.org>
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

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 7b591ef98b3fc1ce20c3ccb86715429b72e2e6f0 ]

Add MAX77705 support - fuel gauge and hwmon devices.
Hwmon provides charger input and system bus measurements.

Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250123-starqltechn_integration_upstream-v17-4-8b06685b6612@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 8f34c1a64c53 ("mfd: simple-mfd-i2c: Add Delta TN48M CPLD support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/simple-mfd-i2c.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 6eda79533208a..22159913bea03 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -83,11 +83,22 @@ static const struct simple_mfd_data maxim_max5970 = {
 	.mfd_cell_size = ARRAY_SIZE(max5970_cells),
 };
 
+static const struct mfd_cell max77705_sensor_cells[] = {
+	{ .name = "max77705-battery" },
+	{ .name = "max77705-hwmon", },
+};
+
+static const struct simple_mfd_data maxim_mon_max77705 = {
+	.mfd_cell = max77705_sensor_cells,
+	.mfd_cell_size = ARRAY_SIZE(max77705_sensor_cells),
+};
+
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
 	{ .compatible = "kontron,sl28cpld" },
 	{ .compatible = "silergy,sy7636a", .data = &silergy_sy7636a},
 	{ .compatible = "maxim,max5970", .data = &maxim_max5970},
 	{ .compatible = "maxim,max5978", .data = &maxim_max5970},
+	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
 	{}
 };
 MODULE_DEVICE_TABLE(of, simple_mfd_i2c_of_match);
-- 
2.51.0

