Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062100;
	b=vixI020pXgELYjYX6/Sr7mtmT6SNmyW9XlOeYM8OjSCWpg+t9yb2DFCU/z/HtSv7TJWc
	 dFPq3m3raoj+K28BpmHbE/KnSFKAUTITi3w/2NOTnRgUhni8QgRoQHgUvBe7h+sXV2sFz
	 POAAiA3EYebjJrczQf6clad4O89y/2XhD7FhBJKmbhcO79rxHfQXYzzTJhGahTKF8Oclo
	 qavOrQ5BzXMLKrHDN/nZbd8AuHsaN+ogphWphzufaTTv1skX/DqWgRIcETx7K266lIpJF
	 SCvn/M2bS6S5lR3KrCFcJIb/hYCb1jiu9z7jc3kgGBl4dJ7RjEdN/0Grr77ldhO0yRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uICSR7WaFUABK3xXOJrMsBlyLHtKVQ87awGgHlrUfKM=;
	b=YSpC5ZLzkJntythocT/vhLnjYTPXHdStrojPzf+D25auA3mje6UmCH3kyGkuasB01QYi
	 CyOYl4KJPFCovzI6JrIiaNRVhvZ5IT2+5Pdmw6Yhu7tAxPXBHy8pK6+xRcBUy3MVqJU5Z
	 hq4OOkVcwwZCnCDg+BCYoYajnQwpMwGVILvtJuHcv3C/5LCBqyEDC4CZ/HSNta6nJrYIv
	 Ptb/XcoT2MKnAtt9NcwhsVMVLtP5nSQKnPd8/YDvmLD7N1g4g+OZ5PsMj4TieTveaZbzF
	 mthSdsNwlvOzEywn74tvyj8wJbGrXMSxfNgRN9bcXj8iMozuKjfoVAeyIYKam59KAtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufT6skq+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CECA60A2616;
	Sat,  7 Nov 2026 14:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufT6skq+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD65E1F008A2;
	Sat,  7 Nov 2026 14:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062100;
	bh=uICSR7WaFUABK3xXOJrMsBlyLHtKVQ87awGgHlrUfKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufT6skq+NiL+p2gA0GKH0US49Cq77PcY68JvSCKjzMxMyD4N4H61bsGNV/xRHnbAl
	 GdxH57vAe2w5dizVEefrEsHEQ19eBQeTmZcV3VhTE5mUrY66mti+7Puh6E8U1nV/2S
	 KXnnkOLmIztGmKk88wFRj9hOt8zx/L0envAiK3fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1035/1536] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Sat,  7 Nov 2026 08:50:51 -0500
Message-ID: <20261107135026.743550264@linuxfoundation.org>
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
index e71f1e4597640..f92d44d24cd4f 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -769,7 +769,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



