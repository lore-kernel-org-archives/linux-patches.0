Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF1C7D417;
	Mon,  8 Apr 2024 13:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583344; cv=none; b=Z+LbYwohIf/COpCjMGHN9ojCqOFGUKuLmQSLNGNxCnrUIVcsUH6It74Rj70S0tCND4NqrO7LAklJGyWFd/BhDdAmcPh1ntFZVB/Wg3Egh0NDOilYCSeQCBsmMBDtQY5mAQrfdlhMi/mb5C6gnjlEMv3AZWbUsr6pUAquqztvjtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583344; c=relaxed/simple;
	bh=hkyzYiT/J1uzTOr7t8tefRAB6Ide0NZ3Q0huVqOR5SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSHLZaqIq7ywe2PLEXMsnq5kQmPyIkKxRWMXkq7PANns0p+yHBHyIVW/64QomBIvSWDRXahb4gl2FtG2WsVnRDCvLVaR/DCS6p4YZnXWWWs9BjSwcziF3bd+ugmAh8wwfyguS8lNgU+7113uKRJ23iGZ11Anb8aGLFTCOlpo2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2wckF2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2wckF2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1623DC433F1;
	Mon,  8 Apr 2024 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583343;
	bh=hkyzYiT/J1uzTOr7t8tefRAB6Ide0NZ3Q0huVqOR5SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2wckF2FOnYfGrPxrETczw4sD2ebbzfdBQA5wVu9W1vO/AEzfyVJyt8ZyhAG+fUX8
	 BpMqGw6mBx659jnJeFi39rnOg4eJ+TwmihfgvLsINugH/Nuz2upS8+PkjwlBVRyJoC
	 x7RTURGd1BG8u/LdxEEIQyzSWZwjvahkkOWcq7Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 166/273] spi: s3c64xx: explicitly include <linux/bits.h>
Date: Mon,  8 Apr 2024 14:57:21 +0200
Message-ID: <20240408125314.421965144@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 4568fa574fcef3811a8140702979f076ef0f5bc0 ]

The driver uses GENMASK() but does not include <linux/bits.h>.

It is good practice to directly include all headers used, it avoids
implicit dependencies and spurious breakage if someone rearranges
headers and causes the implicit include to vanish.

Include the missing header.

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20240207120431.2766269-4-tudor.ambarus@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a3d3eab627bb ("spi: s3c64xx: Use DMA mode from fifo size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 26d389d95af92..1e519b1537e71 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -3,6 +3,7 @@
 // Copyright (c) 2009 Samsung Electronics Co., Ltd.
 //      Jaswinder Singh <jassi.brar@samsung.com>
 
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
-- 
2.43.0



