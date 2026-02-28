Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC00842DFFA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301156; cv=none; b=Qo+zd6259KWRSruwtjBmIG3Bjzm8bdPMMsA8dvYC6evEdiaLXcLVK6ZGiMGpBNmq98fD2I5KQr8etEGbJyytsinIP5s298oo+ZRo3Hn/bU1U4j45xmUbsseqRDL54zSsV2AhHG3o3QPRvb/zUJS1L4mzOlMbhkRJZ/TXMcERq6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301156; c=relaxed/simple;
	bh=EBltPShLdHRg5MHLH88vzR0tSq7BbpzYUrYZ3TMQlZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4vLAAPED4yfiEeH8u4D3dlIZUCqI56z9IfOXlKLCX750KfPhSFWOpO8nFu9c73t/00kw5lGeWHHhVQ2Rs/28kaXEfYM234SDJo3r9Q3Jrjaz7r9bIVH2GAtCQTnVA5Fuv0zFOsnHES+Ano9OgpPs3sz6HKcQzj4m4KFJDU/dzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cc5HvwU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cc5HvwU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FE5C116D0;
	Sat, 28 Feb 2026 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301156;
	bh=EBltPShLdHRg5MHLH88vzR0tSq7BbpzYUrYZ3TMQlZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cc5HvwU9XUQ+Nq4SFn/QtUzBXZhmEZgWY9G5QgSja7K2WgoMTBuqZrZxJUDzPUshD
	 ApF4ib1Fuyxx0u6FuxOW/n20m3KCzDclTXzY9gAmXSdnnUQiSp6az1PHKB3zo27oe1
	 y2eGfjkkDZbOsD3Q8Lub+E4kZXXAMrzNsRPvtGb+VpCOc6BGe6Iwhc0ClQHYDb/nmt
	 3oeqdQHqyloQUv55KAA850bGV4fkMEr42pnrsjPROydwOedTOO95WrB0pakuVEUWcS
	 t4P4VtndcOYOfIYfHNkofqi4uBP9Fgy9gmBZweHPnPUwZ9U03QyZmDkq+grxcLXScX
	 Ijm9tJphPfTBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Peng <Daniel_Peng@pegatron.corp-partner.google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 320/752] HID: i2c-hid: Add FocalTech FT8112
Date: Sat, 28 Feb 2026 12:40:31 -0500
Message-ID: <20260228174750.1542406-320-sashal@kernel.org>
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

From: Daniel Peng <Daniel_Peng@pegatron.corp-partner.google.com>

[ Upstream commit 3d9586f1f90c9101b1abf5b0e9d70ca45f5f16db ]

Information for touchscreen model HKO/RB116AS01-2 as below:
- HID :FTSC1000
- slave address:0X38
- Interface:HID over I2C
- Touch control lC:FT8112
- I2C ID: PNP0C50

Signed-off-by: Daniel Peng <Daniel_Peng@pegatron.corp-partner.google.com>
Acked-by: Jiri Kosina <jkosina@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20251117094041.300083-2-Daniel_Peng@pegatron.corp-partner.google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-of-elan.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-of-elan.c b/drivers/hid/i2c-hid/i2c-hid-of-elan.c
index 0215f217f6d86..b81fcc6ff49ee 100644
--- a/drivers/hid/i2c-hid/i2c-hid-of-elan.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of-elan.c
@@ -168,6 +168,13 @@ static const struct elan_i2c_hid_chip_data elan_ekth6a12nay_chip_data = {
 	.power_after_backlight = true,
 };
 
+static const struct elan_i2c_hid_chip_data focaltech_ft8112_chip_data = {
+	.post_power_delay_ms = 10,
+	.post_gpio_reset_on_delay_ms = 150,
+	.hid_descriptor_address = 0x0001,
+	.main_supply_name = "vcc33",
+};
+
 static const struct elan_i2c_hid_chip_data ilitek_ili9882t_chip_data = {
 	.post_power_delay_ms = 1,
 	.post_gpio_reset_on_delay_ms = 200,
@@ -191,6 +198,7 @@ static const struct elan_i2c_hid_chip_data ilitek_ili2901_chip_data = {
 static const struct of_device_id elan_i2c_hid_of_match[] = {
 	{ .compatible = "elan,ekth6915", .data = &elan_ekth6915_chip_data },
 	{ .compatible = "elan,ekth6a12nay", .data = &elan_ekth6a12nay_chip_data },
+	{ .compatible = "focaltech,ft8112", .data = &focaltech_ft8112_chip_data },
 	{ .compatible = "ilitek,ili9882t", .data = &ilitek_ili9882t_chip_data },
 	{ .compatible = "ilitek,ili2901", .data = &ilitek_ili2901_chip_data },
 	{ }
-- 
2.51.0

