Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057157;
	b=oOyhM3kom+Vke6fbBVbkF7jIOHgtMadC/tjNQmOdxn7rtQsYFGp8s6czD7jqLJnVPMdH
	 1gBQ4TM/4TvJ8IGDPmdKwODqUJdElWqgHsL+oeEttH54YulCuqW78O9nthuMVxySCzRYb
	 w8KMEmXk20OhekhaSfnqLcqBJfhJVWK5aFI7EJFCiAaEYOZ25JzPwcRnWNNSIGj2u8mFb
	 d/NgabdjXzyfx9rdtPLZy9lTJTIM5aFFn/oAaVTgek4toL1Jr+v0HGuLgvSSfZ6+XFTmE
	 e+VS+gtWsRl993+8OothxSbgnvViLVIADZDRDSPxhiuCb6SsNRwj4RafmRCAkVDIwpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DMWWv/odexYepYtJYWta2+RfGE5lSbdgUlHtcnFZe4I=;
	b=WR09WpOgajBOhMiVZTBtl9WwJIlT8exLhVQ3usnShfrzoCSExsYL9TqRpB2Exezs6uRL
	 7YsaNmjXmSGb03sq4pwCZ0bHTVCx29eIZ+ihhHzGVtbBaxnePd86nGWtsWxVW8A41tPaq
	 j3TR5CRGQz9mpTcU8s0yTHkEjfhu27AAZiQHSnS+0YT+0kDQzniF168aC8Z8JGIqES61S
	 CeJCWJda78WdxAZnyacezB5RSLsgTwvhATNSLOwgmOAmIsYuPKk6Nx7uEzhCrjb2qYC5B
	 +IAozZoe6FEhAczw+Ll13t0vhs5/B3a5Q7JR9YYdDsgu5hYXe1OD3Y5+bveZV7h0edQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aFi36UX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1706606A31C;
	Thu, 19 Nov 2026 02:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFi36UX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBB61F000C4;
	Thu, 19 Nov 2026 02:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057156;
	bh=DMWWv/odexYepYtJYWta2+RfGE5lSbdgUlHtcnFZe4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFi36UX/SxfFP7xdxfddMXPFGXO3spBYTL87nwt1Q2nHIjqZpeSGpfp+WFOE2n3Rr
	 PJGNN5w1q7xcFeTlbQGkZ/QEnu1SbFuPgtus1Db2jtLS4RMhmNE7o0qkSi74EF4ADJ
	 p1eeWd/nlJ7YYriJ7ppbqAAHzL52rFCNbhyUlTLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0031/1848] media: cec: stm32: return an error when log-address wait times out
Date: Wed, 18 Nov 2026 15:34:29 +0100
Message-ID: <20261118145912.477276563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



