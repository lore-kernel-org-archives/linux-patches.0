Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064144;
	b=KCTREHSi//s9fK41QaVzPoQx3vIZYPMjzfnXx5yoIznaZebg38Fbn0MjOz7Nz5IX8ZOT
	 cDmdI24EINKLRsSU47k45tt3LdTaS1TiJSdVTuJKbtCS46d1Kn7VasxswqA/3AFE5XRpa
	 J1GEsx/KkUWszse20EdQJZ4w8/AfwXQwwQNHJ+VS908lYF4eo/UkS/lAxwIXdAe/l7w7B
	 FiRid17ZHv8AZVLimk6rPzxhA915Lrl28kjcaba9AQwrskx5vfcMTKWpDaMlU2YdkvTPj
	 t3WbM5jQZ38aWNUTzdIOmQ/wL2f1wAk5HPHHB3UopPnGjDhNJ7hYH3WeLcFK+ezl4Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IasYLd+CS8/vVI9o0sbHU2smA1OF4wN4M50iEGegFKE=;
	b=06cOjHjDPih7CbY8MwLHoVC4D1dIgT7VCsd46xQHeOBg/GRvEkOT2wGDkVtM1LQtyFHJ
	 Ebh/9CBEkadJl70516/pMdnJIWz/TN8dskwd95YTjYWwx6YXvIp44H9mZgpxAkiyxslgG
	 Lc4usKK7buhaOILMzTxiLWyC0Aaie1gt6KrA4gE9mISAdcpk0c5eY0Q4S6OrWPvbRq1n0
	 evh1uORI6Bpr0ppN+6DOE7a+BVzvImHwheMDPoZMpzDhEODEpXbDt7dlZX9cXu45zHf2B
	 8K3qrEYNxMXdEr3cLUcqkBkFV2PzmQB/JWmExizRqrKokV5Sd81LqAyZ4MFmrSUerww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rz67r4x8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7926C606A33F;
	Sat,  7 Nov 2026 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rz67r4x8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268401F0089F;
	Sat,  7 Nov 2026 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064144;
	bh=IasYLd+CS8/vVI9o0sbHU2smA1OF4wN4M50iEGegFKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz67r4x8jAPcpL1zjsMs81HKeQVPSnm9/06ElD36v1b5k3JKcr4FSUSclKboPd8JO
	 mJCJim84m4cdirNnv/4vAQnlZt3NaSvPAFDUpzszXwqijvut9tLVOg1W87xPzoWfab
	 bzqRms1k1tL2tqPXS59j++QUcyXxhtU7d5ca3hh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0253/1257] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Sat,  7 Nov 2026 08:42:29 -0500
Message-ID: <20261107134946.494658875@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 9770bb7d335f8f8db01e99168bbdd9ce2cb6238c ]

In hpre_rsa_drop_leading_zeros(), the loop condition dereferences *ptr
before checking *len, causing an out-of-bounds read when *len is zero.

Swap to while (*len && !**ptr) to test length first.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 09077abbf6ade..7894211b99727 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -720,7 +720,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



