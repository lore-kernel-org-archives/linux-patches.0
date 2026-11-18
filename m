Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015579;
	b=wU353SACjwKNrJyELt5KX1YuvmckGXVVH21f0H2+5wS1hvY7P9lEja6+qCj9IpBWdjBP
	 7Jcf85v7O/K4xGYzmThg2toQTKkwMooSI1yzja6B4Yk/JsEHEZ2WWqW1iHfVKIbHOnOAk
	 nLqZ5mF1dCs8TgOraF14EzNK7+y0/OmSVdITrUMFN2xINnwEalDFfjlUyJwNaXh67clA9
	 R0jn9NJCd1rmSrHRFN0nQO9gTzdSZpd1MKwo4lFFVFlcUaeX3yV+QeaWMRb1cNos8EnyI
	 cvZq8QCsVqGsDmLmk+He6VE3i03OJgTG9TGlhOtwsGQLUDniydG4uBcgEwzAVCTTjGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p//B/MtH6wae0QcSqvz93o52bGD2fObx0+m21tPiFec=;
	b=qSgiM5U0gPaYLEutubY0HL3ELbUmkxWOKE6uJAeafHqMUCNs0yqITln3qAR6QhFxHQ8F
	 VLx7JOafTPbLllXHTzNmqiC3liSmXLPIfUxAABFZHQWfwEN87jLZWCX0tNsx++rme4v7E
	 1maRhOxrFaplslCZIddvWQCIP7GQ4QIDWUrb+XcO3CQbZUWqUSzjXSF0Vkrfitl8u+e7g
	 AYw5jnXL129o6IjDqY62P+O1UzZJRdNBYla9wstdOo986JpreLRuwlXVUgFj+l7JUscdw
	 ULmBm9JW/bLFkj60gdJg/v1ENY/Ujt1FAM/v+R6yC6m0KlxRYpiJlpk0XNt79m4Aiiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUI4BVbd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E8606A320;
	Wed, 18 Nov 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUI4BVbd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A9A1F000C4;
	Wed, 18 Nov 2026 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015579;
	bh=p//B/MtH6wae0QcSqvz93o52bGD2fObx0+m21tPiFec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUI4BVbdQQV1vB2UVuFL8ZAVPJmsFfM6piYE0hQ/K19WBbbBygJO8I64ZRqti2LcQ
	 /b4wXRn12xVSefnuEIbqWapqWTpuYpiP9iD6yXXQnJMGZjviB3eiiSMFwV92fwDV93
	 oMJRO8bqYS4uxsu5COm9pR4kg60dUVOgYGgNbA84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0224/2651] spi: amlogic: spisg: Fix transfer size limit and timeout handling
Date: Wed, 18 Nov 2026 15:24:24 +0100
Message-ID: <20261118150255.930839149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9049a87e9d0f2..58dc6fedd8bc3 100644
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
@@ -565,10 +565,13 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
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



