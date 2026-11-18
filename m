Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048196;
	b=icn/G+cw06n7Hkv0q60pnT9jNkNF0V2o1L5WKvo5e2X1V5kBm7/GwvyETKtU3hPgvFeC
	 smewVVjhn0jHCo1qITRgtzj6g5/JcRlwgFykcYH1OFF/ElAbA4grHJ2XqnFzYz3IlHYMj
	 bMbJykeYRYLl7H+bfvxRryH7s1VIInSLaAculME/RPFkjq4Y137p8AUPehAiNBtamWGho
	 LdTjHA1LGyEdQfpBLBfFzqf10xXctWXTUynpB3cAA1gjj4Fz3nbxjJpxMS1kFxltL99Vi
	 8Gt83GLG4b1PYbSCxzgjOk76q7VPFCZQc3r2uismCVoTpd7a2XI04k26ubsAlbDi29Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vY59qIYAk0mstval8Dk5zyZ8c3I1i8Xp+HvCJ8A3hq8=;
	b=LBe9yPgP3vPy8RESRm0WSxcAhXOHaF/lIChXxoNwG5joL6DzkmGSNS6CQDzPJ2/MGC68
	 4x5RffmrqEOKIGAVXA3OUbd/zKyVQaBHoTv/FItd97X4uNrdsDytxCxe/dDRJWK9trdEl
	 I2DFa9r3KzsoFngLJEMO2DY7ncO9IH6luiBbWwnMbGgSoROc1qsDnnOdfunmNg61wUwdE
	 58dHbPdlB1T1N9r1VODhXZHBEYssZ35VtCSjYUswNKLIW1gWL6Q2Td2eqkxXpRDEbsTjj
	 U1W3Vb9C7yZN+Wi5f7zajC9IRxiQogVqWoVChmTIFXddO4gTgz8YVnHB+o8yiHkFg0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fcra+VM1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27DF606A325;
	Thu, 19 Nov 2026 00:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fcra+VM1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3641F000C4;
	Thu, 19 Nov 2026 00:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048196;
	bh=vY59qIYAk0mstval8Dk5zyZ8c3I1i8Xp+HvCJ8A3hq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fcra+VM1T9wpmU1r9uiHQOKSnhLzytTqNoBE2mCfFaQvncyr35Dp5/nIE9vWc+ELj
	 N27arBJfyCKaZjypOAufcXB/3mB6xu+qBPj7Mi6gangF2e/vk2c/Os4V+gmeBC7Ta1
	 q1cZByDs2JgKF12VXvwyQ6ZHDu/hJasOMPvuO+4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1910/2857] spi: Fix the return value in spi_new_ancillary_device() kernel-doc
Date: Wed, 18 Nov 2026 15:49:04 +0100
Message-ID: <20261118150309.991022752@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3742867ce96539100ed5f4c754f04273d8aa00d7 ]

spi_new_ancillary_device() returns the new struct spi_device, or an
ERR_PTR() on failure, but its kernel-doc says "0 on success; negative
errno on failure", which was never true. Describe the pointer.

Fixes: 0c79378c0199 ("spi: add ancillary device support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260911230211.11755-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 2dbdf10e9803a..9658d4100c40f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2422,7 +2422,7 @@ static void of_register_spi_devices(struct spi_controller *ctlr) { }
  *
  * This may only be called from main SPI device's probe routine.
  *
- * Return: 0 on success; negative errno on failure
+ * Return: the new device on success; an ERR_PTR() on failure
  */
 struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
 					     u8 chip_select)
-- 
2.53.0



