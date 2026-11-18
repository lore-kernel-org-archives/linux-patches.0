Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050935;
	b=3vTGdYU5lvb/vylLA+7tmOxvziBqHS/ixrDM6biu8qilst2XqGQmhO0UPQYKu0PEU9ps
	 3Dv3Cb4VT+oboPWQePb+pFmEAXcQdYRfIRIKQUA6IJ+RjeFNtFzBY9d/4401gUQM+ije3
	 vKGZXmd6d4kDpBuF87edvvJH7oAr4GDlGBausVF1x1JqNaiJsP7qxpHQEgBU1gKcJyoH6
	 qWpJEk1LqWO5b9LA8LezPLN+cYwh9YFnfZgtSeMNJibXV3POGbzYsu19Q2VAeSih65OoO
	 W8B2LT3ZhSm5bG4HhbsapcjMoPoLQ4/FqeonTpuutURgHHq4X2cW/DUZMpl3ryTEBKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bVEGwIjkwUfqMg9/XwAjC+qQzmti916NUj7RwHAFmHA=;
	b=W1Jv8Nu9d4kGCCHBKdQAtiObDg35nGYzZGLq6j44r711fQC9NcmjQK19dCPiWhjK7kSA
	 HxxXvpXEXTBKyvkQNSxAc2qUAza4OhdmJyl10Zu4cUwx8OrvwyZsGh3cQsNV+whMoEUKq
	 oboyX1cV1gtjioExpUTWR7bswwf4Zzpwe6ZmkL3O+JIaX73wuvGH7UiLMzo+MI7IiOGzC
	 ElyAsGdC7xAOx7Dm7JqD5vIk9KFYAQ5YUDPPduZyW+IIPapLjgFVEw218nE8Umk5uMQx9
	 gz/kip/UwJTsBlfgCzCPNYhwQqdlrOD8ss/4wZMMV9nqEuy+deOIXOZiZI0ZwM38SFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOIwjGSo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC2F606A320;
	Thu, 19 Nov 2026 01:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOIwjGSo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F611F000C4;
	Thu, 19 Nov 2026 01:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050934;
	bh=bVEGwIjkwUfqMg9/XwAjC+qQzmti916NUj7RwHAFmHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOIwjGSoG+qDSjxtpAczu3DyJozYkoEDNp1tIbIObh+Qykn6rPKTdQf+5j2Ij48ml
	 9vYsYkrPAxopco1MfDaA9MGxLAivxL1lQljpEKyvsqMjeRvNNbHuH7Uzp6v5NyTPNF
	 pIp/lI8ERbFIGsFe1Tw7OeqAyGN3bqUWB3ACh4TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0030/2214] media: cec: stm32: return an error when log-address wait times out
Date: Wed, 18 Nov 2026 15:28:26 +0100
Message-ID: <20261118150011.306666716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4cff10c744457..8f045d3e9eb48 100644
--- a/drivers/media/cec/platform/stm32/stm32-cec.c
+++ b/drivers/media/cec/platform/stm32/stm32-cec.c
@@ -195,18 +195,24 @@ static int stm32_cec_adap_enable(struct cec_adapter *adap, bool enable)
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



