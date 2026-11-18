Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033550;
	b=RgWluXh0PVuqll8iuVSUkdev9akjfhPJUrcoU2y+GJbttzxX8WapkIqNOcgFHXQvSpKE
	 6Yo60O1i2W7deSv1WaT3vay1egG1/sHhDmUxD/ShECR+SOVKP4/aHQVT7g/bJdFBnDAHD
	 GKSu+nlXqXk/KB3z3Dp7EvpNJtKUquwQgcte++s0aLhmHk/rz/qJ/r7MCy/bg4G0jlPVG
	 C7THC48n4VB+evzSSj+aWQPVc9QQl/7XJIXKuuz+wRh84EuuFbkRGP3WR8B6UU1yHrvmL
	 Vg0B5H+YsSDGp92skiz1gO4QMFb7Dxs7O7pX2vRIrP3rEHDFtbpNpRd+tlMfh+jvWtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5fWh3zjYj2sgw0moZZBYesvxQbutVsyzEu+o/rkykkM=;
	b=PYuRGGfB4LYbl+yeObLDQ9tk/HLZO6aLoyP4bNEoVnioFzBCSqwz+XLszdi265ghDnSm
	 B0renk3tTThs5BvK8rmHA4vXeulmCQTQPWYqG6dJ5OMrVUC7MPLYLgkpO2d3LN/mJRWL2
	 +Ry6MxIc8yZRE78Hpnkg4plGGwT3ZzwLP1AVATkhT47hDrlYjLk0YP8aqxqCxKlk2g7Br
	 OaycbK3NFTEvs2yPVui4Dpc8+DQWbpNo3S6H/a5JVqeffhXaEJ9Kh3sW0iKfKhWdrjz79
	 y6T+F9ZKhNZxpFPB/9HSXrnnJgoiCp0qj9WYhugdzBaJyiB83WkuWpShyzmeSYRqQUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lySqSHUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48428606A31C;
	Wed, 18 Nov 2026 20:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lySqSHUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573611F000C4;
	Wed, 18 Nov 2026 20:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033549;
	bh=5fWh3zjYj2sgw0moZZBYesvxQbutVsyzEu+o/rkykkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lySqSHUv82g2KmF3MZASP/0lgHqLahftssk3Tby0u0gGbcCCVkPjPXH2XeTB3gKtx
	 Nbg31IBSoeHTMNrSCaH8NH9VDBHTYQ23kJFr4kKV1uRb0imbti5BK952wtCbI2KwZR
	 KpbzvdDDXOcSm+xPt7LGhg8PLnoXJRBarHszODYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0027/3318] media: cec: stm32: return an error when log-address wait times out
Date: Wed, 18 Nov 2026 15:10:49 +0100
Message-ID: <20261118150314.580345894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



