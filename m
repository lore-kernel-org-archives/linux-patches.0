Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044988;
	b=thfeM2PoU8caDJb3K2nmvZukjPDNubfZ2ZQ4nqTt7K43xI8abJDc/81rlS01mswZSFBF
	 mhM3BBNwKGCNw593dOKmJwpAUvxRbMqx5slOepLzWntYka6ZKHVr2vJ6/k9J8bxDjcNMy
	 sM638xNOgSzK6M19IF9YNiFcVp6eBaL5tSqlsu2rkYYxC42DztnVd4G4/zBep+EtVgi6K
	 yNhNQ3/NTMpZKACxRqa2ThAxr0RG3niBPgjbqcW7z5Fr1XKH70FBUbHk3nBqtjUwD0V/o
	 vPPZU5hQL4ESCyYSL2Qo3znh2R7HcQZIQOouilEvSnQsYFXmwMim3iXaqw4fX0KzLSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1s0dsNePUnQ5atGf5zK8f1H4UoGJk6Cwp/QQ8q4nJPU=;
	b=GqCrhhcXFBALEOiRa3le+JQjdRXqzexGRCWz7GHaOUdeKhy9s2aLz+HyzGeOnncizOrT
	 kPAnX1S5wZs2WWFNdiNwBjLMKmUBC+hDuCY5wJImtjrsuLbV0gZjiD4hQ1BVnrRWMq31b
	 a6xGm1y3KQvHR1LWHFaR6l1AWtekwupdsDoOZLh8RbT0ciuKkoq4fwzj4JlLA4IgNhWOj
	 YNILUptLpsvlBl0NjSt5SfbxevPC5djoBOC/noKxN+ViQBGWCLv8ohQl6rWskTw9OH10Y
	 MqvQoKhQOmbxKU+/jYtBCjekjNE4lidInLrn8ZHn/dxN/SiI944b5xozhQVjnc783cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ThI/ah4K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D31606A31C;
	Wed, 18 Nov 2026 23:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThI/ah4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E2D1F000C4;
	Wed, 18 Nov 2026 23:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044988;
	bh=1s0dsNePUnQ5atGf5zK8f1H4UoGJk6Cwp/QQ8q4nJPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThI/ah4KUJieYxVeu92LX134ahb6L/omWsue5mq/PHgp6kg2nr9dRbJZN8uLmKwvp
	 zYMI3ua2T53kJwZ18Yr1BV0ZMVAMzpAEebNYu1gbIwGO49FTzYENfszjwUbQDWmGVM
	 vk/UBZPxROvVQikMQOSeLEmbpv6M4mCFPar8VCbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0762/2857] crypto: atmel-tdes - zero-initialize device state
Date: Wed, 18 Nov 2026 15:29:56 +0100
Message-ID: <20261118150228.990022976@linuxfoundation.org>
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
index 88ba927d92085..abc2049fa6be5 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1158,7 +1158,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct resource *tdes_res;
 	int err;
 
-	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
+	tdes_dd = devm_kzalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (!tdes_dd)
 		return -ENOMEM;
 
-- 
2.53.0



