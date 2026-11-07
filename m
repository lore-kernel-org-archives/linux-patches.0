Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062933;
	b=yb15sduQOIvWMdQPJpqe7RJmcntUHm1ltcFsmZn2EePUHsMHxl135A6R1w1k2+lHUNNi
	 SHJEroI5K+GKkovvW6Tzw2MA0a4aUb8QLjQTNc4WCc8iD6p+QBxDM4AXiBS+nueAliqnq
	 7WikfY6O18aZ1P7Vx2DQOQCkEz8agqjm1raKQJzOOpBGsYtxCi/P8Nu+xdkhkd04G7H5P
	 ge0iDzXErf32na17CSX+/GLOitqKv7y0pNBx3qB8gvRwrp22rkZTEbgFjmwZzMIvRUa7l
	 s4gBDKC8V0lMegNh9yOJjHFCOiKZRtn3USeGOpJk3b0Hv06blT9/it0c0dNslcBV6iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9sLcet4f+n+AyKe0OMqxV6XiznXQK8SnavVQ30A6cII=;
	b=EMBlSZNjfGzt6RUCzFL9q86NHr7XZ6jL7f33dR9SOGVVOGzeMzJM2/TDkCiKu/rgoi99
	 PNlrRbtEq4eK4NTRc0EeiEQ07wROea50O/TcpncJgBGbVnQ80/GKZu0tssCKAU9GrFQ6U
	 Ji1m7d27xOihaE7izrVfPKo55T47nWTWvSImEHJXzWdOai+XEHVNeP4HAwrXWyGNWxpGD
	 x7EYN9nQs3y/OZ81zZ/ed8iov+QmeOu/W92/ai5RN+uSq5k2UpR6wgaP//2MD0N47xP9b
	 7OWDP8wseM8VgnvYPj1BORHY9ABNNCPmY7Wo/YvL2F64y8U952go6KjiMuabbQzLNXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btuVALdZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631D1606A326;
	Sat,  7 Nov 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btuVALdZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BBA1F0089F;
	Sat,  7 Nov 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062933;
	bh=9sLcet4f+n+AyKe0OMqxV6XiznXQK8SnavVQ30A6cII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btuVALdZjJL5jaLorV4TsluTAHr8M81TE3h2VaxPBOjY7/vL7EfU0qQYtlXHO2t4T
	 JlMle6v/U8UNiZEVWd9cTkwkPEu7t+btsfZfnNNEuA3nBS2jUjobG3BquTcCdZ7VB6
	 a6vLGIfAXHU2LSHirqnv6UJTHou9hlfClKO/UiDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/869] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Sat,  7 Nov 2026 08:48:05 -0500
Message-ID: <20261107134858.893070525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 839c1f6771436..37d5f12e0ef1c 100644
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



