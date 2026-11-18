Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045261;
	b=1zjupd5uzkLkIhq811sjGBIVL430pEtkP0wRC4CTovH9bf90t8EEk+pNTxmdEiveHXYk
	 RcNUNEBABteVSQ9c5ZWWHHs8ZDY30QVUcPU3YPFP+Yo7sWHJsLmuk7G6dcY9bGZaZlMXj
	 1/hnA72gT/yRhuIyp7lwGfAOUmhmxYcUa28baSTDrbkjb9Q0po7FJOE/zCWM1UadFf1dl
	 WHMV/4jLS6ELQm22z+lEBw4EV230iXwz3YIKId7SuDYXpJtP2WOV4AYspKH9AEip9xzzT
	 qyRn5/GaMolYvP6O+1FbDH0mmq/+ELqXHvAATq8UKsuz8JC6xYTJb4liq5InuusPhwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Bcbrji1AunklWE8qgOVsmXS1YeBetBG5S7q70hxWIo=;
	b=zaHe1HQnP+CD+A+GgE8UcCkot8i37pGoXVxzncpQ9nuBBuITDngNXCQvEKxQ1FoN9dq0
	 I3QgeS/CcU4x68YDqaWRUCd29ZGzuGwkxeRRVgAwb116CtwvoeNQbtyLyjKxy4c1gVjux
	 D6WYnQQtYQ27fMB+tVwJIlnSvxaXi09zDBntrvOd/F0bewAhR1Bt4ISUQaysIpWj6O9Wg
	 hUkM9XXPtibJomcMIQDVCPY7fEyycUhXiXMJX2RXCzhOl6BpBwUBoEyzmZMtwytkB0d+T
	 9LOm+Df8as6B1UsYDHcezm2h4GVhKv23AGhb/LdwpQPcyVlaWWyjI0yJtAg8u/pvgzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJMqhmlE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E397606A325;
	Wed, 18 Nov 2026 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJMqhmlE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85E41F000C4;
	Wed, 18 Nov 2026 23:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045261;
	bh=3Bcbrji1AunklWE8qgOVsmXS1YeBetBG5S7q70hxWIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJMqhmlEjNviKwaLLR+zdcSf++sueMwq9WAEzr+V2UPK/9qQREWQYZJj2Yq7uzFq2
	 MfQUsGCjmtoIDHIyT514s21JWuC0XttBcMBGrhT4MOmqOx/xViPD/q0MBl+yk1k0ur
	 q0C9JS+qNEpDRTrkZB8FmqSDwM+3Dk+roVF+JblY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0860/2857] hwrng: amd - report partial reads in non-blocking mode
Date: Wed, 18 Nov 2026 15:31:34 +0100
Message-ID: <20261118150232.530850052@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit e7f5ce911efb2017381f28bbedb6243a74a9c285 ]

amd_rng_read() returns 0 if no more data is available, even if some data
was already copied to the output buffer. Return the number of copied
bytes instead.

Fixes: 85962d2248fa ("hwrng: amd - Convert to new hwrng read() API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/amd-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 5229da114377a..ab45736ea617e 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -79,7 +79,7 @@ static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 				if (timeout-- == 0)
 					return read;
 			} else {
-				return 0;
+				return read;
 			}
 		} else {
 			*data = ioread32(priv->iobase + RNGDATA);
-- 
2.53.0



