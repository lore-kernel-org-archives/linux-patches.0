Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F4D524AF;
	Mon,  8 Apr 2024 13:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583271; cv=none; b=EAgY9spFht+c9hVB/YQtRYLiSdqYWKYLOHgSXD6H1z+sv8Ffw8wDvmkEDYixITwvCXt8XEFFPjjT5V4hX3xuIx3FzXIgWS4P3YZ13lpmrw65YeEEEiG4tZdkwi8Ahtzy/J1gsla7OWaFZbFXvovZPrUuijMSdNCNtOgA4N5nbY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583271; c=relaxed/simple;
	bh=faAPl0wlLM8jRN7GLcUQ5/WzGH2VQ4rxlY+w/UCCzUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVsyaJZnPV07INhekBlcL/r+QrhEVITj2UkWQ/Bv+S3UUBEWeMBhgDbbnK2QUrz5WBmi0lpAbWgo/PmItiUxEpmaqpN33lZgMtH0CCUBXIZeBMs0t/gb2AuwIAR8XSo/IKlQd9O4gLRO2OBYOGBoKASGbO2sA45EA+HF3NyNPsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILOClTtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILOClTtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20898C433F1;
	Mon,  8 Apr 2024 13:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583270;
	bh=faAPl0wlLM8jRN7GLcUQ5/WzGH2VQ4rxlY+w/UCCzUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILOClTtNF6m56BJ0zpvdym1hatmzSsbSxmhgeGq463l4Eei6/SXQnaePJA34nfWOQ
	 Voc4gHrL5/o94TBz3e86xlK7vhdrqAogziYou3KBgQm7TahzQiO2XvDnzfT6sDhRSx
	 DTH78fO3RKYU2ZNgW6Tnvu+JC8tJ71TPp8kUyS88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/252] spi: s3c64xx: explicitly include <linux/bits.h>
Date: Mon,  8 Apr 2024 14:57:55 +0200
Message-ID: <20240408125312.119914211@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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



