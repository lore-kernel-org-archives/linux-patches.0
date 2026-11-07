Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064311;
	b=r2Q/yjGu5sR/emK9yw3H9tNybeSRQCpJiFZxEQh70C94iUgieABPutA3XhxKNSMJNOFw
	 g6TIjutANgZWUqLstoboJ1EhtuHCOmIOi1Z2s/VtigXU3uU5jNwMfxsSKXMeyT4UM8Ov8
	 woKkp2Kc9wcI7OyItJ8eCyqmRHsdzCH7upIlwgkynv+U+BgSFkj6S1xGSco9btDXvKe/F
	 4q2ToAMgaqncdhXumUVhh9qsEbID6vtp5T8AI9gWsheO35tTYC5ulG7iZ3xNcu2KV9Z6b
	 CldtKW2Ag+R6eCm9N7dimSisXV4jcN/2LHTbZoOQiY6npfkcmN3ux3po70+CIqB7ftw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJsW1vQd0IdsmYzMb4pcBiljnTCtFWSS6kl3Mm+viOw=;
	b=LDtPsqLPhGLcXvMLYFMkTT+GTd3o6LyFJQveQ+GCxHU2Vfrr559upxibmCycQbpKKrHU
	 bxVfgeXs5cU6GeNApnhfr17PzQ+UCLlP1ApbkjmvilHUmhD4NxurxZACwiAf2AEIK05ds
	 1rSl6a4jLdQts4/pex0XN/cEcg4tetRHezKjmbpGC2FF/udvEbHtZTNjcBYl/cceQKyUe
	 yrfFKqBi50/2QAVD8eizRnaBs5Fh81UHry5S8L/eNhhA1PoFQJIoKU01kVrA6T+hN7DPj
	 DJEP4ov8p0C0L1CiQOyvXhGqwI/jgNnVh2kus+Uy89Yk8Tk3fqGm2w3kq725I8QTg1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PB1bgUvw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A633F606C02E;
	Sat,  7 Nov 2026 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PB1bgUvw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F641F0089F;
	Sat,  7 Nov 2026 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064310;
	bh=uJsW1vQd0IdsmYzMb4pcBiljnTCtFWSS6kl3Mm+viOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PB1bgUvwGENOoQWb7Y8CMor1mMZdH+PntX+iMVQ8cZ6YTZSZyKRBiRF0ZpMABCCRn
	 v/S+GbFXJXzvWFBt7K1S5TAS1aYbHP6NQ9zMlFFLBh9JeIlllPISW+Q7HfWM4aTBf6
	 Ahw7qcnrgCS1GRpC5KcN6V3Yl78lNLMPHxsxxOUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0401/1257] staging: rtl8723bs: fix RX buffer OOB write from device-reported length
Date: Sat,  7 Nov 2026 08:44:57 -0500
Message-ID: <20261107134950.609831891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

[ Upstream commit c52929073fccbc149267a2fd7458626a7e9abcfc ]

sd_recv_rxfifo() trusts the device-reported RX0_REQ_LEN value
(hal->SdioRxFIFOSize, a u16 read from the card via CMD52) as the
size of the next RX packet and passes it to sdio_read_port(), which
copies that many bytes into the recvbuf skb whose data area is only
MAX_RECVBUF_SZ (10240) bytes. A bogus device on SDIO can report up to
65535 bytes, causing a heap overflow of up to ~55KB past the skb
buffer.

Bail out when the RX0_REQ_LEN exceeds MAX_RECVBUF_SZ. This is expected
to keep behavior unchanged on normal devices.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/8114c3adc1acaea78523cc0fb4d4b25f7665cee9@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/hal/sdio_ops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/rtl8723bs/hal/sdio_ops.c b/drivers/staging/rtl8723bs/hal/sdio_ops.c
index da2d9088ab5ac..b7a4ab0bedc90 100644
--- a/drivers/staging/rtl8723bs/hal/sdio_ops.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_ops.c
@@ -644,6 +644,13 @@ static struct recv_buf *sd_recv_rxfifo(struct adapter *adapter, u32 size)
 	struct recv_priv *recv_priv;
 	struct recv_buf	*recvbuf;
 
+	/* RX0_REQ_LEN is device-reported; the skb buffer is only
+	 * MAX_RECVBUF_SZ bytes, reject bogus lengths instead of
+	 * overflowing past it.
+	 */
+	if (size > MAX_RECVBUF_SZ)
+		return NULL;
+
 	/*  Patch for some SDIO Host 4 bytes issue */
 	/*  ex. RK3188 */
 	readsize = round_up(size, 4);
-- 
2.53.0



