Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060573;
	b=18s3/IMhCiebsPhCGZRIhB81jPX9bYKmzd7B0S2S37SsNJ11kMjns55kKSPw6cVILovW
	 XBJVt+XLkVrkmwLJXpmVGRHTtJ1QsavmVVm6PGqhw9UBPSuULhoDlZSJnBwoIprSCYnJQ
	 abAEJh1+VD6Mr8rkAwQ7+K/jk5bu0EuSTTDgwgCNsjwXfFaja7lzheIUDCfwRShSkSYKd
	 /lM2ifp1hxD+rQ63EjPLA/iMLTQ9wckxYURsglmVG6ujLUW/T78V66XI9e+47K89daRJX
	 b23MWpxdN+xKu/v6CEejTMEWySnt6GEELxLVHI4cyHxthVoIIgNH0dFGDPJ9F3UHFtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/USbAiXcbsz/57AzdG4Vnwn9skmW5reoe1u3tpNFsUA=;
	b=i3x/OVL0zEXWgJcCtzX4UZ7OOCaP1iZE9AH2qynlRZVJeX2LU7/ZH8KK+jP5v6IfQBui
	 UtNZ7rQRP/0uDhxrvMShXUSy4M8cnQHg/0sk3ImJWw8Oxd0tTD1/jcdCrHtzhHR5n8jIB
	 hFSmKpb0N2wEJwLyAUvFTbDSgXPLeu/m4KwbISu4e0fDm0ZNHICRFtmPvBBy0rkb1hmzr
	 KOcQQLa2lU++EFuvR7CLhX7dzyaNWSygez/G/REOZvst675u5RHxGrZAo/Tx18JwXSerC
	 1spo5qRxEYCoQC4jUwHbbLPaIdnUrY01lKAYHPxnRgHUiRH3eNAWjL6W9skepQyrs4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLDt3Ssa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51675606A326;
	Sat,  7 Nov 2026 14:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLDt3Ssa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26151F008A1;
	Sat,  7 Nov 2026 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060573;
	bh=/USbAiXcbsz/57AzdG4Vnwn9skmW5reoe1u3tpNFsUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLDt3SsaNXTMmaUeZDtYfNCyExSfjCPFeueg5KR+ZWZgi89XX5t8itI+z+vuP2iDs
	 1Ls04h4n9qLadBHGKHlX6QddLJfrdk65LCFHabpjj9FQsGBL+FddLX5TkVsSG1DgEY
	 p9oB9NppBJHUfxs3cw/dVd6SeN9dqrim3MzZF2bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0033/1536] media: cec: stm32: return an error when log-address wait times out
Date: Sat,  7 Nov 2026 08:34:09 -0500
Message-ID: <20261107134958.598405250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3bc2e4a26465386332ee1a40219d8dafba335b0b ]

stm32_cec_adap_log_addr() waits for TXSOM to clear before disabling CEC
and updating the logical address registers. The wait result is ignored,
so a timeout can still be reported as a successful logical address
update.

Return the polling error before touching the address registers. Compute
the address mask only for valid logical addresses so the invalid-address
path does not evaluate a shift based on CEC_LOG_ADDR_INVALID.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/stm32/stm32-cec.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/cec/platform/stm32/stm32-cec.c b/drivers/media/cec/platform/stm32/stm32-cec.c
index 35f5ea42a802d..dbe0968303c05 100644
--- a/drivers/media/cec/platform/stm32/stm32-cec.c
+++ b/drivers/media/cec/platform/stm32/stm32-cec.c
@@ -194,18 +194,24 @@ static int stm32_cec_adap_enable(struct cec_adapter *adap, bool enable)
 static int stm32_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
 {
 	struct stm32_cec *cec = adap->priv;
-	u32 oar = (1 << logical_addr) << 16;
 	u32 val;
+	int ret;
 
 	/* Poll every 100µs the register CEC_CR to wait end of transmission */
-	regmap_read_poll_timeout(cec->regmap, CEC_CR, val, !(val & TXSOM),
-				 100, CEC_XFER_TIMEOUT_MS * 1000);
+	ret = regmap_read_poll_timeout(cec->regmap, CEC_CR, val, !(val & TXSOM),
+				       100, CEC_XFER_TIMEOUT_MS * 1000);
+	if (ret)
+		return ret;
+
 	regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
 
-	if (logical_addr == CEC_LOG_ADDR_INVALID)
+	if (logical_addr == CEC_LOG_ADDR_INVALID) {
 		regmap_update_bits(cec->regmap, CEC_CFGR, OAR, 0);
-	else
+	} else {
+		u32 oar = BIT(logical_addr) << 16;
+
 		regmap_update_bits(cec->regmap, CEC_CFGR, oar, oar);
+	}
 
 	regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
 
-- 
2.53.0



