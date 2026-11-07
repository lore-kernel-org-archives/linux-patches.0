Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061979;
	b=xdae5UaHL34jg2rTxFp5NIBK7+6pS+rRpw60UERk6j7kNV9mlyAqVYFCRDNi3zPCJ7p/
	 4JTFt9OD238WqsjaTBjcQ9IugNx27fGzbcTmly7H4lGmo4jgrJC9Dg9rg+Ahy1fjj+Rzt
	 /adtsgREp4stVZX0XvMm40H9/R/KdiKFPBMnAtBLLqagCAKdvb9XagyE0EBHGgiUVDOqA
	 FmsR0ZQxwVamYHGpsEksCB8vNVmKfBx7QjlAM+qbxrtp8g++dUe5c6xEZmPDR2p+K1VIP
	 f1oHV/Lp+tAMF3SzcB9UKHXCVGd6Fi8Sd0KqkrEp7Aa5AFAoU0FzSOvXevvCpSMJd1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wwVKTGvZTy9EVjKgpVjY9lgAnuO+LodWT+s7oAezLrM=;
	b=OBEbjW6M0rinKUtHcQ8WNsykXvz8OqLLHP4sXMAHbR5VFaqdwoG1B1JusgKFA4M7czZB
	 6IIiCtnIOYkopMx6TBNnCbNYaLiA+RS49L6o/m8ExIJ1p592qdnsgTfJMuszEuxmbyWPF
	 oMbqG3eZLYXktjpWe8VTzdz2mS6ee/Gz8O0y/bgb16bnFRydcyT6Ilpgkk6ywb5PLnDFd
	 Q8ube2rTPp+y3ynLZ/K5eV/HlU5kbki00s/OuQ1+M8QPjegUAOZTtIP4nC2kbMw8mHn+B
	 VjoY06fONP+VD6cvIhe6vdLA47hDSQrA0apAG//rNX2HGPILKnkarRk93qae4oVYoyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q/ITB7+4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59702606A332;
	Sat,  7 Nov 2026 14:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q/ITB7+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0696D1F0089F;
	Sat,  7 Nov 2026 14:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061979;
	bh=wwVKTGvZTy9EVjKgpVjY9lgAnuO+LodWT+s7oAezLrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/ITB7+4Qsq2Ipj9L/bly8zs4gJU8ylic2yE8KTwJCQRi+45edYWjG4Obi9jZiKi9
	 oTp4KapqSlkp1FvvY126zcXAwOxjPjgTqx0njErGYMuDHbzjpgr+39tk24Jc9L8h9q
	 FzT3B+j3eeqwtKfAEdabpn95cq9I56IR/JmNI/9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0973/1536] crypto: atmel-tdes - zero-initialize device state
Date: Sat,  7 Nov 2026 08:49:49 -0500
Message-ID: <20261107135024.976115852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7ccd3138e82d8..360f5ef930322 100644
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



