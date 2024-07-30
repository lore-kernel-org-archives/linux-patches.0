Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F012D1B583B;
	Tue, 30 Jul 2024 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354711; cv=none; b=dyZYqlXWQpCQm+6qCS89DnMauACTcUiOgE46hOl+zOc077URx5LSzvnIyFpRiA1gLNREzL5UpIw63sLnq8DiwQ5F7TtE/kHqOXR4Ln2Ma/Y3wITp69abLKX6oOzZjQ9aAlWjqLxpUJ9amkbwLEIzeLb46zrutfjDV9YHe77LmTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354711; c=relaxed/simple;
	bh=8L81HC5eYCy7G0rLz3D87is9OLUkYLijjO8VSHeA9E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YW0zP5m+u+pdQtFP4z+VVRRBPdr2evlGw4hg7Xsm/Mlng8kZCvJ5gRMMyzdR7utifyMbIEUV9IFNbdi/FpD3QZUrO2K/eB/5FW56g4bKXKFIT6Uh5kUTBq2gPcGepS7FG124xYSKyyESn9xm9VDt5TeUqRKiw3bjy3Ux3hi9gic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxEq1q93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxEq1q93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B1BC32782;
	Tue, 30 Jul 2024 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354710;
	bh=8L81HC5eYCy7G0rLz3D87is9OLUkYLijjO8VSHeA9E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxEq1q93nElcPs8OPHad2fMB5HCIESaXw6nk160GWqzAJWZoQAMKKeFlCpXDKGv9W
	 K+pOerYJre+YOVMudCgRju9qxNtUDzpZvt5Hu801WT+5UuhiRvhVJb4dkRFgddZVkz
	 aZwyoihfoWgkYA1tQbY501eq/Sk6f8jeyV1JFUbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/440] spi: spi-microchip-core: Fix the number of chip selects supported
Date: Tue, 30 Jul 2024 17:43:54 +0200
Message-ID: <20240730151615.816774552@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>

[ Upstream commit a7ed3a11202d90939a3d00ffcc8cf50703cb7b35 ]

The SPI "hard" controller in PolarFire SoC has eight CS lines, but only
one CS line is wired. When the 'num-cs' property is not specified in
the device tree, the driver defaults to the MAX_CS value, which has
been fixed to 1 to match the hardware configuration; however, when the
'num-cs' property is explicitly defined in the device tree, it
overrides the default value.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Signed-off-by: Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://msgid.link/r/20240514104508.938448-3-prajna.rajendrakumar@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-microchip-core.c b/drivers/spi/spi-microchip-core.c
index d352844c798c9..d4c08d3668741 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -21,7 +21,7 @@
 #include <linux/spi/spi.h>
 
 #define MAX_LEN				(0xffff)
-#define MAX_CS				(8)
+#define MAX_CS				(1)
 #define DEFAULT_FRAMESIZE		(8)
 #define FIFO_DEPTH			(32)
 #define CLK_GEN_MODE1_MAX		(255)
-- 
2.43.0



