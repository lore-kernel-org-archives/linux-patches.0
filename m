Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829289;
	b=P3deqGfAa1zvWkJSHSW5VWcDDIaBgz9szxmMMeoKQxUCKlnKQ8ntW2G862dwUbgxShy8
	 lVqcHOPTXkPf7b+v/V/grQX30M8W2lRVJgprBXb4cjWKDqR97GvqlqfOho/su9X6DVDb2
	 WMXNt7K3J+UzydOIZ8M9VAHYNFb5P11PGiSzR0YF1pId+Pzusy/gEn1drnaqHe+cK8Y2b
	 8nhVFw/Y7a80t9mAHNUT8Wd8tyoA4Fr/ZweDGXMGlvR4zF16/bSHR1dDq3jN8yFt9ij3E
	 duigTaBSgCNL/cTCHhKLHUWGhB6qTSxs8SPONViBbsqr2qdiCIoMtXmK0jOrrY1A20A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/tBpTvUgkikhchI7m0jo93/okfQ+vqQroNCOwqY+6Is=;
	b=0OBZU8QYJnq0nyY0gBsUAQsDsifm9oi0CjyKMSpmdUdsmY4ouQu3+mK89a0zOaY7kGA2
	 h+Ra63merDaK+T1hrYssLdk2y7NdGzPeohGGRMbiU0GQ2NT39O2f+zkPkxLMZXrJE5TyJ
	 KmFMCA41qjFqIMZO9CCqnfSnlNqwqxkxEJH79PcPsTJs4ixuWhlqS3gp0PYnoRsMaygGO
	 xg5rlo0ioeAyNd41CL9FrReOWVb8/Nu2OWmEWKlDRGX90fJWP1kypXd024bPMtZft1qLD
	 gzXKr+xTsKHlMtQUz7thXNLum56zNaF06L91iH9Ui9IU+5AuWaaCVac1imwrNpO/WtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0imTcK7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A53606A84A;
	Wed,  4 Nov 2026 21:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0imTcK7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928831F000C1;
	Wed,  4 Nov 2026 21:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829288;
	bh=/tBpTvUgkikhchI7m0jo93/okfQ+vqQroNCOwqY+6Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0imTcK7HlEqfz1qx/6iH0cFSnP7VtEiu2I+dozdvIeT3bpGRtgG2ZTfwTSHj9z45
	 0mv+dUZXg+yxbetIzxVAnhFldOKrBPRIDeGW8801QHK+dy1KmZq6h5CE5Nv1SVTBYI
	 f9REEXRUO/k/ryAYznPNotAbahPJjtwGkCYWL0XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0031/1005] media: cec: stm32: return an error when log-address wait times out
Date: Wed,  4 Nov 2026 15:56:04 -0500
Message-ID: <20261104211044.431369708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8c2fc232202de..29418966a98ef 100644
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



