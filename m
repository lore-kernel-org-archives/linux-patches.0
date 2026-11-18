Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058256;
	b=pcBqlx/gGRwkMtD+JyDk7MTMkt3A2IWqxo3pTsZZF701GZfnmkohU0zurTYFtQ7YpZRj
	 hPjhzMpcK/iYxj/K3KTH+aoQ4kL75JQuCLewYsLO37uvCeDECuyRnq+ebvhEYbyUTd/hv
	 aHgcyPvzoRWQ3imsBN5rDEwbuD4zVVWSlMGCSjrg01dfdca3dUpxGFeCBgxRoK69B1MbM
	 6NOqjEBOHKwz8cnv4OwD2BYP8l1koVvZco3Kpcjx0sMFG1k4mDnWugq1iF1fTZUOWksV+
	 Npybqcbs7kanG47Me1e7jEWpiVpvDA+X4oO3gntQh59Ei6R/P/jFUHR18AFMg6qNTTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BsRTC5LS+sfhtPjPoEU+cjTwnu94hI5s+NkchqD/Gmw=;
	b=ET2303ER3yIlpkkRIvHzcae5mZkFoLQspXslAE1Ry3v+m46Fa1qsEwkrWB13eeqAV7ls
	 gOyC/IbnuCZHga96Z4CwVqbZSUjGXovgCr3Bih73HH7tf7pG3fkxlZsSuH3khdUAOEgOB
	 dMk3YO5MS6tx3wq7B9gQL6DcXgfqabayptNUHnOtEIgYIs719YSGgxYzlKBFJSFxi+5u3
	 EJ5eOzO+iNldFbiDLT4h5ppn191OrWWQRw5RY3OnkkvVwQX7D57OArxm/ZYerwI8g50RR
	 MrXEn+zbT18sU7Lzw0fKycHFb0fTtDirFgNKtEkHpxg9BiABIKMv52UjJxD7DoVZGjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLn5+r+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87B3606A31C;
	Thu, 19 Nov 2026 03:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLn5+r+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F971F000C4;
	Thu, 19 Nov 2026 03:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058256;
	bh=BsRTC5LS+sfhtPjPoEU+cjTwnu94hI5s+NkchqD/Gmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLn5+r+MsgtVwdqbrN7tjhfDcaJk5xIEam3HzfPvy3Ws8TrQgI8xDrKCUn0rSa6E7
	 S8rZ9IyFx8p6czvvVyR8m1iXmrFZ0c5rIr7yQ0weRKovLdfDqet9F6FbkTlu2Z4UwK
	 XHxaz3C6jzPMi/DPYXpCjrlCj6fQqFEYSg0LK+Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0421/1848] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Wed, 18 Nov 2026 15:40:59 +0100
Message-ID: <20261118145931.644595604@linuxfoundation.org>
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
index 90c13ebe7e83a..4477a781bc3f9 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -687,7 +687,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



