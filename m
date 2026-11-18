Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023126;
	b=rcld5TjZe01oyLEm/XAbCQLplqB02MmwphbiO5OqXmEq1NoJ8fVMeqHE1ApE9eRWWF01
	 MKvifOxbITlsbGO5pfIsj1JGb37P38bZUXVbXDESoWue5CIsnknTw1/R+35UH1kJd4z3h
	 b/+wxgTq2sbITp59CeQXwUh6GwYzDHi4EMi8Nc8sZCugW/wj5hXlbrWH6KbKKe6nBRz+u
	 bFvh47BacFLBfeMam+NSVjK8U0QtGqWg/IJ1p1/xjLjc6NqacmMWrIRI8GeesGg2BwGZY
	 OL4SxD8En/O32XScFU6oZd8/iv11paGu4MeS4vVeWuTnUeiidzQfCusnqx+5QDBGsBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wt+z4aDAAx7Pdz1BgBaOeKO6dyNNoenBqrMDQQjPqNs=;
	b=TA0DxFRnZCQ7GHmD3Nhw0n7lHFEx/tCzUp59HPcKGzDP2eohP1Ozsa3qZVV3v/23nHFc
	 eSCbUfCLw5Hkk3IFKnSTWpXmsKsGEHFmTByXTGuzYIJffJf2SxqSO2UO1KPxFz2nxUZbJ
	 62c7LNkrCpR3Lm2lt/4OUs++X/R1Vf8WgACeZjczSlfJ3mnSo8B8R+tx4yf6dvM2ZjIJX
	 3eW5HzZLKzSkVpIYsDbjNeJegCTq4/mEEbII33Ua5eQPEF9N2zIcwATFDqqKJlo3jNKfZ
	 9ccEUE6ZjWO/4RQXUmMUJBCi1CeVIczK/rHyTOE0NPKSxF7Kwg3kCBM+9SJcsMYiZrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dBN4AEJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67BF606A32C;
	Wed, 18 Nov 2026 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dBN4AEJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC471F000C8;
	Wed, 18 Nov 2026 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023126;
	bh=Wt+z4aDAAx7Pdz1BgBaOeKO6dyNNoenBqrMDQQjPqNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dBN4AEJoPRHxl9a2KcaX8h8AedtVSROBhrYeEWeHDfCSdNa0CvdEv5ZAyJIelwLq
	 hWgVyhultJ8c27BaaxEnTu8NbATZgmxicRbsXdjlhzwXKaIUWlMl2duhr703aVluGQ
	 g3pEBGhZcPxWtDp8G55RhF2p72omxZGt6nLf4+F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0241/2151] spi: amlogic: spisg: Fix transfer size limit and timeout handling
Date: Wed, 18 Nov 2026 15:32:56 +0100
Message-ID: <20261118150130.553759274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit 754d2bbd92f5ecef0eb4f5b1ac7b1417320a56ca ]

The CFG_BLOCK_NUM field can encode at most 20 bits, so reduce
SPISG_BLOCK_MAX to 0xfffff to avoid programming a zero-length transfer.

Perform the delay calculation in 64-bit arithmetic to avoid overflow
when converting nanoseconds to SPI clock cycles.

Stop the controller on transfer timeout by clearing the descriptor list
register before returning an error.

Fixes: cef9991e04ae ("spi: Add Amlogic SPISG driver")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Link: https://patch.msgid.link/20260731-a9-spisg-v3-2-a15da3f70029@amlogic.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spisg.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-amlogic-spisg.c b/drivers/spi/spi-amlogic-spisg.c
index 8ddb7a1a40567..9e98fcf3d0c12 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -95,7 +95,7 @@
 
 #define SPISG_MAX_REG			0x40
 
-#define SPISG_BLOCK_MAX			0x100000
+#define SPISG_BLOCK_MAX			0xFFFFF
 
 #define SPISG_OP_MODE_WRITE_CMD		0
 #define SPISG_OP_MODE_READ_STS		1
@@ -175,7 +175,7 @@ static int spi_delay_to_sclk(u32 slck_speed_hz, struct spi_delay *delay)
 	if (ns < 0)
 		return 0;
 
-	return DIV_ROUND_UP_ULL(slck_speed_hz * ns, NSEC_PER_SEC);
+	return DIV_ROUND_UP_ULL((u64)slck_speed_hz * ns, NSEC_PER_SEC);
 }
 
 static inline u32 aml_spisg_sem_down_read(struct spisg_device *spisg)
@@ -566,10 +566,13 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
 	aml_spisg_pending(spisg, descs_paddr, false, true);
 	if (wait_for_completion_timeout(&spisg->completion,
 					spi_controller_is_target(spisg->controller) ?
-					MAX_SCHEDULE_TIMEOUT : msecs_to_jiffies(ms)))
+					MAX_SCHEDULE_TIMEOUT : msecs_to_jiffies(ms))) {
 		ret = spisg->status ? -EIO : 0;
-	else
+	} else {
+		/* stop transfer */
+		regmap_write(spisg->map, SPISG_REG_DESC_LIST_H, 0);
 		ret = -ETIMEDOUT;
+	}
 
 	dma_unmap_single(dev, descs_paddr, descs_len, DMA_TO_DEVICE);
 end:
-- 
2.53.0



