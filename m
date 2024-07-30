Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273D81B5839;
	Tue, 30 Jul 2024 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354718; cv=none; b=Ig2xwLoT8CZuoNAk8wmd9Gk7OgJc+/He/BPi1dZ1KW6xZhHPz/NOGB8xdqxQEBDG9SQCYeddIBWg1JwXmwwOYDQYQCQBLnO+exz6wm/71B1stncymFP/K2RNVfbR+agpTFpBBDr9q27emOmWQuI9WGOvM6M5NWXYzb2XQZ1swVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354718; c=relaxed/simple;
	bh=Hcm8pcZQnBRMivrNaU0j938l26jdooyivhYe32E6nMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEz7Fp8amNw0JAk7/thXR+/MPGDQJRkwrrHnAq1uf7IxXzIkD69Vks8Be3cMaL4KMNEn2wf79L2S8cysSfIbqhRXPdUcUg4gL9+bKQSKC1Yy5vUECNV7bTXnD8eKOI8IeRl2DuuA7Ck1ZmHqe7JiG6MXGSl7l8MW5gPI3oOtc6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyGV6qo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyGV6qo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C628C4AF0A;
	Tue, 30 Jul 2024 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354717;
	bh=Hcm8pcZQnBRMivrNaU0j938l26jdooyivhYe32E6nMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyGV6qo0nmr2WL/xUEU5Q9hQMY3fuw94PNpzx2FK4KFhSOs0iiMhmab/bl+PdDRQj
	 1e/qiNS1FraNMROcYp/RawF8+iHy8YqByDoahSX10saZEjVriHEThh90cPjIt5cJav
	 42n1L3M2cQefhdV2uOzItR+gUGPjS7yaiusPgy2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/568] spi: spi-microchip-core: Fix the number of chip selects supported
Date: Tue, 30 Jul 2024 17:41:48 +0200
Message-ID: <20240730151639.860544225@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b451cd4860ecb..6092f20f0a607 100644
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



