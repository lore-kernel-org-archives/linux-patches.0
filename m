Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052319;
	b=bZvME85ZIddS92AOa+N+MS7UbBmwsz8XKvUubRFFhkEzZoU+Gj7fjtNyv1fbJ3RmGv6s
	 nXSflisM2VeqHPsql7N1dTeiR4ClQAnxCDnsiK4/2CyXIoXdrv0pbQIYdNPdPT77tjZSt
	 +tqiG+Fev5lv9IDzxY3pw7zBpRRr6J2KwSSJ3MuGcGteUgLqCA7DLU7elAE9d/g0k8rvQ
	 8zuXuDJjv3JCMkCjyG1bui0iB1ihhL196BpMdJywwN+VPDaD/behJTzYAz8clrHbCk3p0
	 P+eZ3LcaR3kDJsCjcI+SibFQLlfOc1YvdHZBvhrdAmzUzD/lA9vs+F9bcfHeXe89/4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FxVDDqQNjUyojTL987YKppcPVjr0WMNsNSr6pKqFJsg=;
	b=MT65oetSlknu3mwBj6U0Mc551EElZ3IcNgNt7aQ/ExmrTTggT6iNDpCHK98/BHgpw5jT
	 Wso8lN0cgYRsGEw8/XLc2HNOfwmfYnbpoB4s6PSwIKD0YIpyOWRbIgNa1LkXNkp5h5E8q
	 NBJ634S3supOXiOu9sMUE64mGOe2eLX5c/82SWvfbApBR9s4PlrdMwpqpGUmfW5AKaPVX
	 IlPivqvJhJXSsmqHMXw/NalR8/+5LRasvVR7CMlVDq+tQvR2hAPvPHLjCLnzB1Z1gKTlw
	 mUl5Al2EptY3314AaasVefivjR80heTXjmpwaSnfNDENvsvmvhs1Djoj74Fc2pDrNeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RVko/Iq4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C36606A339;
	Thu, 19 Nov 2026 01:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVko/Iq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287221F000C5;
	Thu, 19 Nov 2026 01:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052319;
	bh=FxVDDqQNjUyojTL987YKppcPVjr0WMNsNSr6pKqFJsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVko/Iq40/kt2BXeeEx+Uu58wj2lmf5NAxgNyo1CHxCjXcPrSZx8u6EwDFkVBbMkP
	 MmRUuRsy6Htf1cf2VEJy6c0p+h4WxjEGelqswSGsHeo6FddzxRqXlNcjeD6VVCrIRN
	 /1iffkiAWmmPu1nYb3mq8Qdhhe8CVJeHpp070ePU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0518/2214] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Wed, 18 Nov 2026 15:36:34 +0100
Message-ID: <20261118150031.813811013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 14e2f2042a557..d3a37aaacff8f 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -746,7 +746,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



