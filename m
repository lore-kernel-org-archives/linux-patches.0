Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042910;
	b=5ef9jhrkf9YGFyOfqRmktAuaLTZYyZnkVMTR1TJgwq8f0tT34Q3wzUBYCWSO1ZPIkn7J
	 DEaU3Rd8I5K8QxRcqSalZZB+hdjuoeVUhICxPPnllsbFzQEbdKR7B09gUeAIU9oQLtwA6
	 xGQts8DW/PbyZrbWaTzlhXct2CGtsqznufJzLfADfNggOFIZsqUu68yHiv3a7s0WfLcds
	 TIvlt4NuJyqKvx2QkTiMGr7QZI5pLqdBeEU7An+FTC23HgQRn/TW50sGby7Xwsl0rDYLx
	 loF2/ZnmPBDxsczFJtBfEllJ0qU4Dyj6nIxRpgLaOIZhZfgz6H3bkpwfUjMf0nAKVXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6gWFXCxx7drnriwmbxBckBDz4hYXUHiTL0BadG/26o8=;
	b=imbvp5MjLuObbv6j4iqnj+YQ7MIt+pdsQF4Ex+ShkO/gip4HBz61teKBtRHPICSxRA5R
	 BhJL0qYnMDVX3YsS1ekUMol5rgZU/Rq6KXMWfI/qtfdsr96qHt6v3ua1lWlbeWekr6F/B
	 NVboNwc+wdm3LNPERpV46RXHu5Xtw4/McOBJQNJ6QzNFI/vk0sEWyx9GRMe8KgQlF1dbH
	 5VpxeH6eyu667pHEA1HfgzR8qZRVMmUWmSGuIht5xDtpdSwsaHiWvsJNDJXwxEds8Ang8
	 wfNC3CTz++MkK5AhzejpJEREPOYeQNc52RuVFO+ypekKIvfGSiAky/q1zPtOpmHhUFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COUxs2CA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF24606A320;
	Wed, 18 Nov 2026 23:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COUxs2CA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA9C1F000C4;
	Wed, 18 Nov 2026 23:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042910;
	bh=6gWFXCxx7drnriwmbxBckBDz4hYXUHiTL0BadG/26o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COUxs2CAvctk0RodmXGvJ8NfE22add3yI+hzkAkAvFoKjIlslMulEmg8QWm4Oc8ih
	 R8IGJOvxySyDy7lciBsmwvZbfIhOw3q5dueZqLszHJdfy3aoqz22GNp5do5UMrCq0g
	 ZGeh+aXUxnWXHAlPf6RfVcLS95BzswpO9bfPXhDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0024/2857] media: cec: stm32: return an error when log-address wait times out
Date: Wed, 18 Nov 2026 15:17:38 +0100
Message-ID: <20261118150202.231297665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4dd98ad021ca0..70dad0dc65e8d 100644
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



