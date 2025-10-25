Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6325C2F5B;
	Sat, 25 Oct 2025 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409299; cv=none; b=Lp3b52wLwqoPg/hPD8i5ZAh/HhEHL8B0CfcHAsV0XVFJL+OyWwB4C/ooNGdCuySCsll3A3cktJG3YVmuquG8ex4Z5nsep7iKtG+qCB/3PBiN5T6YmFc7P3e16pahkAmIJuHT1kp78QJkE47A/PN27pkhcLXIds4JOPXCU1JmNmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409299; c=relaxed/simple;
	bh=kthK9UGGB/QE0ZUKdh2beRy3IOwxGuSQSP/tYEDl5TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aN9WALQKNZC3czH3/51ewZg+73lnf7uKbd16RRpEWvgFWshgXn9FQUrWmz20EMj/B/tYWQWboFrq9BoIJ8MxiUFVojW1+u0HkF66F8C0FTOgEYEbk6fpc1wFIyX5+OjIfv/l5xI8HSfvWhehuWoJwZpQvUjsdlnBpVGOIP0pUF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBbWfNEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBbWfNEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9760DC2BC9E;
	Sat, 25 Oct 2025 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409299;
	bh=kthK9UGGB/QE0ZUKdh2beRy3IOwxGuSQSP/tYEDl5TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBbWfNEzYP9rH9mBvMmH4o9glkeGu3OfpHI3U6gltt1bxvOf8orlL+PSTFX5bKmk5
	 lS/RojnxEO73YaHX+o52C54aLA5tx9ZQdCyvYiUqDn3M06KPolHj7zxMVOROVdwtY7
	 QxstKAb0YNAD0OswVfqi/uoIk+R/brCU1ODD49dqSzmKd6KZUhYFNGOoOyqdBuIT1d
	 wo/tP3l8lxM+vs8vkZ4Z/Gz5J8cX/TAJVBvIX+mhp4IgL5ZSQb0FDcxYhhyfNPGiuJ
	 w7K9wWJ3DCLTEYCIi+3R4ZLYfemDvs+iaz5EFGZAlyzNVdIbzV9NWRBnz4nc6tqZKc
	 4It4IpOG3dWaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mehdi Djait <mehdi.djait@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	hansg@kernel.org,
	laurent.pinchart@ideasonboard.com,
	vladimir.zapolskiy@linaro.org,
	git@apitzsch.eu,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.1] media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR
Date: Sat, 25 Oct 2025 11:58:18 -0400
Message-ID: <20251025160905.3857885-267-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mehdi Djait <mehdi.djait@linux.intel.com>

[ Upstream commit 2d240b124cc9df62ccccee6054bc3d1d19018758 ]

Both ACPI and DT-based systems are required to obtain the external
camera sensor clock using the new devm_v4l2_sensor_clk_get() helper
function.

Ensure a dependency on HAVE_CLK when config VIDEO_CAMERA_SENSOR is
enabled.

Signed-off-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The patch adds a single dependency to gate the entire
  camera sensor menu on the clock framework by changing the line in
  drivers/media/i2c/Kconfig:30 from “depends on MEDIA_CAMERA_SUPPORT &&
  I2C” to “depends on MEDIA_CAMERA_SUPPORT && I2C && HAVE_CLK”. This
  confines all options under “if VIDEO_CAMERA_SENSOR” to builds where
  the clk API is available.

- Why it’s needed: The commit message states camera sensors now must
  obtain their external sensor clock via the new
  devm_v4l2_sensor_clk_get() helper. That implies the clk consumer API
  must be present. In the kernel, devm_clk_get() and friends are only
  built when HAVE_CLK=y (drivers/clk/Makefile:1 “obj-$(CONFIG_HAVE_CLK)
  += clk-devres.o”), and while include/linux/clk.h provides stubs when
  !CONFIG_HAVE_CLK, those stubs return NULL/0 and no-op, which can mask
  build issues but lead to misconfiguration or malfunction at runtime
  when sensors require an actual MCLK. Many i2c camera sensors already
  rely on clk APIs:
  - drivers/media/i2c/imx219.c:1158 (devm_clk_get(dev, NULL))
  - drivers/media/i2c/ov5640.c:3901 (devm_clk_get(dev, "xclk"))
  - drivers/media/i2c/ov7670.c:1868 (devm_clk_get_optional(&client->dev,
    "xclk"))
  This shows the practical requirement for clk support across the group.
  Additionally, some media i2c drivers already enforce clk dependencies
individually (e.g., drivers/media/i2c/ccs/Kconfig:2 “depends on
HAVE_CLK”), and this change lifts that correctness to the menu-level.

- Bug fixed: Prevents invalid configurations where VIDEO_CAMERA_SENSOR
  can be enabled on platforms without clock support, which either:
  - fail at runtime when an external sensor clock is required, or
  - depend on stubs returning NULL/0 (include/linux/clk.h:1040+) that
    “appear to work” but do not actually provide a sensor clock, causing
    probe failures or subtle malfunctions.

- Scope and risk: The change is one-line, Kconfig-only, subsystem-local,
  and introduces no runtime code changes. It reduces misconfigurations
  and does not add features or architectural shifts. On platforms that
  legitimately use these drivers, HAVE_CLK is already set; on platforms
  without clocks, these drivers are not meaningful. This is minimal risk
  and aligns with stable tree policy.

- Stable backport considerations: While the commit lacks an explicit
  “Cc: stable” tag, it is a classic dependency fix that:
  - is small and contained,
  - prevents user-visible failures on misconfigured builds,
  - aligns the menu with the new clock helper’s requirements,
  - matches existing per-driver patterns.
  If earlier stable series do not yet include the
devm_v4l2_sensor_clk_get() conversions, the change is still harmless (it
only hides options on platforms without clk support), and improves
configuration correctness.

 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6237fe804a5c8..1f5a3082ead9c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -27,7 +27,7 @@ config VIDEO_IR_I2C
 
 menuconfig VIDEO_CAMERA_SENSOR
 	bool "Camera sensor devices"
-	depends on MEDIA_CAMERA_SUPPORT && I2C
+	depends on MEDIA_CAMERA_SUPPORT && I2C && HAVE_CLK
 	select MEDIA_CONTROLLER
 	select V4L2_FWNODE
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.51.0

