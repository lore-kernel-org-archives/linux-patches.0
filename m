Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035898;
	b=vrgLt1TRFWUsCpyBfSXICl8XL42Oru5W/zf99Z+rOaQzw0hkBkSnO3AMpBM34m2pc0tt
	 uVSAY1Z4aF5uC1Nqg5eP7MF0fZ5+RVbw5gUSX8WMUQV0t6pNMPmiGKreUYCSIBou7l4bz
	 nC+453wIHwFVi60oiDJpzDdvTIyeKWOWviwJdvKB/ksGn5VJKss5a92aBifBjKvIzHC9H
	 oOa9dKYnRdGhW3JF1iBdcmTKT+RG/y7Fwq29W7SMwi84vun9PrUoQB6hPGpODT3fTh64C
	 upAQoJNaPMNKwtjLlCBr29U/9r+XWYyRFp1d49aXxlQ8sQRcffgfrgf6yTo4EAEEBTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l91YAoHTRgUPF0GquqG7tXvuKR2lCcyQrc9wGo4EzqA=;
	b=294mIP3cI269PE7SX8dGSUipJMludcaKbhL/tqdo9NaPTy8b0Rnj7TsNGQrAWwvgHRaf
	 bpYE+snY+kaXW7eXRs8B7MPNU8QwvtpMzMB+ZSCfDXDNvonp3xOWiIgkao81SBirky8kW
	 SxSkuAWDZ4wphmPiS0Fs7n/GGqbgoO0y56QFGp6LD5DzMD2LMZohmFJUHGHLn2NHWi3P7
	 SPHpPDcxuff4LDk8jVBX2KflpEkXw0NsEwDhb+NTpk+EBkpXlEKcU+KLzdnls3Y2fSxBZ
	 Odu3LPEdJyhCAnsgaFYIycHIPuHj7K8uqxRjtTAbLNToVzPPM9tVmL7Un/ZaSPzwNQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f0k2jewS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB90D606A33A;
	Wed, 18 Nov 2026 21:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f0k2jewS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC6E1F000C6;
	Wed, 18 Nov 2026 21:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035898;
	bh=l91YAoHTRgUPF0GquqG7tXvuKR2lCcyQrc9wGo4EzqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0k2jewS8sQeqniaSibs8zxurTpPvhWSSsCvADXRxfNzX3ih47BbT9xuCW1iPrtBX
	 PVcYfzyzleiTUNWNq6TCecmdnXbbc2ThzisxBucfHmx5LPC2A0MO42//bENLqcvCmJ
	 VocteUfj/msc4IIWsQRJ6fGkbI+CfrD6U6Q2jB0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0866/3318] crypto: atmel-tdes - zero-initialize device state
Date: Wed, 18 Nov 2026 15:24:48 +0100
Message-ID: <20261118150345.284981664@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit dbe70508d507acd677e67eaf029040f5e3a3b2b3 ]

Commit c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of
kzalloc") accidentally replaced kzalloc() with devm_kmalloc(), so the
device state is no longer zeroed.

atmel_tdes_hw_init() tests dd->flags during probe: a stale TDES_FLAGS_INIT
skips the hardware reset, and a stale TDES_FLAGS_BUSY makes
atmel_tdes_handle_queue() treat the engine as permanently busy, leaving
every request queued and never dispatched.

Seen on a SAM9X75 Curiosity: the first TDES request after boot never
completes and the TDES interrupt count stays at zero, while the AES and
SHA engines on the same SoC work normally.

Switch to devm_kzalloc(), matching the Atmel AES and SHA drivers.

Fixes: c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of kzalloc")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 14a43e700c6cc..0d47022db9488 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -945,7 +945,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct resource *tdes_res;
 	int err;
 
-	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
+	tdes_dd = devm_kzalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (!tdes_dd)
 		return -ENOMEM;
 
-- 
2.53.0



