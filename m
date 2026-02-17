Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6C82594B9;
	Tue, 17 Feb 2026 01:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771290086; cv=none; b=KD7jCz3A/KApONNei9DO8e9+3ROPTSUi7q9+Gqnfy9zYE+JR76FrSzk+K2n/6m5g+BJYWSDdfP60Lh3XqV6TyJoWjRqXJHsUgG4+1tzXg+eE2sxMm4aMeAx57ZIZj3+6Jq+1YK0/grUrONTTzIPUrQICq19DW2xWYP0bmZcxJYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771290086; c=relaxed/simple;
	bh=22h4jkN+njBHp+FSq94tcW7wTethWMHm328U9gEdOQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3E+SW04VMDU3nK4IB867IIbbNF6X9c8yodDVezQY88j5FgnnHMG0Mp6ecWO8hc5jpFSohSKGOHOMAbUaF/xc1+3cS5hKyKINXonq5zeUTkDmBslUnPCkE3LPjNwcFtx22HEk41ivaMdPA5Oq8Z4u9YydDmSXyD5AeRrrvqt6YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INbyTBSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INbyTBSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76236C2BC86;
	Tue, 17 Feb 2026 01:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771290086;
	bh=22h4jkN+njBHp+FSq94tcW7wTethWMHm328U9gEdOQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INbyTBSkOck19USn1fi0UVA05sE20z1/UnAa/HGUgT/M+n9pJcTfF0kANi7JxqT2l
	 QBD6u1YI8+KoyLmXuNA0zeWQ2wQOLLQKN8AgU5c9ZFgjR60kRTnp6aJ2hs/B019DO6
	 r+0ZlwJLlGXjJkuhghQ8RrsSZ7SHmQCHJ/F66OhSOq6FbFxN9hk0m1DBDzKbl1lcfp
	 a+TBkd2gSZ1S99xfp3V2gzxAKKxOSjkWoysRNXJ4K4mGtzGhxjJpVGMTFaJ+JyV4+0
	 LjBy4+QYDZS1F1aeH6lyJkxAsZ9RqFg1AmqAvms6cSJkZbodp66mdtyNgKY0RCpHCS
	 YYM9xpcpAr1Yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Peng <Daniel_Peng@pegatron.corp-partner.google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] HID: i2c-hid: Add FocalTech FT8112
Date: Mon, 16 Feb 2026 20:01:16 -0500
Message-ID: <20260217010118.3503621-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260217010118.3503621-1-sashal@kernel.org>
References: <20260217010118.3503621-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
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

LLM Generated explanations, may be completely bogus:

The ili2901 entry was added in December 2023. For older stable trees
that don't have that entry, the patch would need minor context
adjustment but the change itself is straightforward. Even without the
ili2901 entry as context, the addition inserts cleanly in the match
table.

## Verification

- **git log** confirmed `i2c-hid-of-elan.c` was first added in commit
  `bd3cba00dcc63` (May 2022), present in 6.1.y+ stable trees
- **git log** confirmed the file has had similar device additions
  (ili9882t, ili2901, ekth6a12nay) following the same pattern
- The code diff shows the new entry follows the exact struct pattern of
  existing entries
- The commit has `Reviewed-by: Douglas Anderson` and `Acked-by: Jiri
  Kosina` (verified in commit message)
- The compatible string `"focaltech,ft8112"` is a new vendor, but the
  driver architecture supports multiple vendors (it already has elan and
  ilitek)
- The `elan_i2c_hid_chip_data` struct is used identically for all
  devices in this driver
- The `ili2901` context entry was added in Dec 2023 (commit
  `03ddb7de012c6`), so the patch may need minor context adjustment for
  6.1.y but the logical change is trivial

## Conclusion

This is a textbook device ID / compatible string addition to an existing
driver. It enables a FocalTech FT8112 touchscreen that would otherwise
be completely non-functional. The change is:
- Small (~10 lines), isolated, and low-risk
- Following an established pattern in the driver
- Reviewed and acked by maintainers
- Critical for users with this hardware (no touchscreen = unusable
  device)

This is exactly the type of commit that the stable kernel exception for
device IDs was designed for.

**YES**

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

