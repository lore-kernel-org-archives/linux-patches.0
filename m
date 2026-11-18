Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058166;
	b=re2BlxvSMY1QscH1J67TnT+4uUoe+M4gwfKlBE8Un9bggiiEoSIdx4fs7nLs9iU6X4HN
	 4eC8GYXsaLtp+ygc2icpl7ajyZn6bpFNGDaRa06slS5wTvG5NTPI6blUGRwQKOHC7RIhH
	 RvJqLY/VvrULc5lfSW9QVEWBlmZX9t+n6EfaLuPQ9iBYDvy3CvQWpdSwdMWfYteATELQ/
	 zcdn4iBWDeo7ecRBulTXI2bbSzQd0+uqYn3g8wsd2XBFd0OvK/2TB8xBUxB1qyOZWyUNx
	 NBU4EdpMUvJhfL9CoZuhEtv8xs+R0GOzSCVIfIPWdtKOAz+dYn8u9XCrXkz4TlLdGuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WHQfd0nLDjguUbZleBUdX5cjJgC1i0Hr0OLLaCVSthc=;
	b=gE5c0vlJlDEjxwuUycpU04FFgjNHy8Amz8085Qiu7edWoDOkLJx8grcKoOUW7xdzBe5P
	 BoyR5FFkavHCy/jQWn3iRwoIqHukYK9UviMLPp4rNc7gLZ7zquMKOfLgVVgt6MAtXjN5s
	 Ur6dLCfxcbXlffkiGOacBR9KXKzOaPz6vHLzzzJcwLNM7Ap1mw5WdBWXTVg/75lxr+GcD
	 DmthKqpa0mjIsoQ6v2wzfttJ7uoI92odPDJ2tRFLswaKz+HQ9ft5/vozuIYKIaq4tcORr
	 4aTFcBIDKd8aucDTH99NAcbz8cN8xGwFyjtG9+DFRip+mxfuGsfoe3IrXOs0g5gO2jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGKoFZay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABB4606A326;
	Thu, 19 Nov 2026 03:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGKoFZay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F176C1F000C4;
	Thu, 19 Nov 2026 03:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058166;
	bh=WHQfd0nLDjguUbZleBUdX5cjJgC1i0Hr0OLLaCVSthc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGKoFZayhfxYs0JehXiH0pdtwMfH13yckc9ROcIC1KCbfq9W1mOPJR9kDG/7A7cam
	 GW2v8qYWVnKWWK6HQYLUlS2/e2bdnHfgmg16I2FbtDBqZlQ485Ohk14In2E8skTrPL
	 VHeiNm5o2uASjQuG73dqp6XmgNL6fufeDEiOomqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0388/1848] crypto: atmel-tdes - zero-initialize device state
Date: Wed, 18 Nov 2026 15:40:26 +0100
Message-ID: <20261118145929.926069989@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1d7097cf72df..72e3e7d2083ab 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1165,7 +1165,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct resource *tdes_res;
 	int err;
 
-	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
+	tdes_dd = devm_kzalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (!tdes_dd)
 		return -ENOMEM;
 
-- 
2.53.0



