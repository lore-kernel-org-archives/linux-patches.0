Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023496;
	b=w9s/5eFXCNROEgMtFTHP8o/eprkWNB9TnNVu5hxbx+RW/1MFjzBOkXGTJ9g3bSamw7Fz
	 g0Hs682YCfSn/tJ0+1rvHhXr/7uld4FNcz7IcqAOympgTCToQ0qfVvF0WHFNzGW9q+4Cb
	 01UYWKFSrSchf3648im88YQyvg1bqhQcB75N1GDNDs/uqGHqI8ZyNPO185N7SQp1RVdiU
	 9BckIBKJKBS+8MZs5kEq1RHYM8quhl4RcC5HIcDLt+ZrKefNcTtH/NK0oTguQZZ8r6h51
	 gqZnY3qXNTgIzI1XH73+cnOvO1KPaI/l9tPTIVRElF39/E/Bf8CWyq55UXElupLfOpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4x4QQN3U+NfeA8TN8RRPszT8UVo+3bRM/+YOw/JrlHc=;
	b=ZEuTLWm45gzhda/6BjNGzv7bRM01e0R0kqd/INIWRRcz5kM9Mo0H2wqQwiSNm/KU0ot9
	 YZBI4657Bqebk3y4QqIytj3EU5YTikv1kWGWfPxwheF2qU2F0Egx/obYBCxkBUduTXrAB
	 nfzK0dLPOczZv/r5Vo2S6rKBginL3ajE4Eq7Gb/9wnH53+DKKo74C2or8QwER/9/No92x
	 nPdzJ5QuHldBswur6X6ejxZa1lB9X2SuNWbyXqniIpGzVBKGT9fTW3j3Y5UWrkEIbCtLZ
	 1oE9/Ckg6CtITpHWwm5z+jqdbZcBgibbD0Twj4YPxop42i7OuDsjv85zfrRNzJTF6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yA+Q/Hc3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BB6606A325;
	Wed, 18 Nov 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yA+Q/Hc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584261F000C4;
	Wed, 18 Nov 2026 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023495;
	bh=4x4QQN3U+NfeA8TN8RRPszT8UVo+3bRM/+YOw/JrlHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yA+Q/Hc36CMOa8bB9ZO0on++Z6GLxrV3V6IQZwG62nGdcGgP69guGxYi54Xg0jj/4
	 3kQv13iTkotjceecd9nrT7UyotjDTGrcJMwj5cpJdKihDGqBoZmZf+QvuvLYvbk7hM
	 y25TDO31PyIT5kWfbrvwL+ya1Aw41Km5hvXvLfE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0383/2151] crypto: qat - release instance on DH fallback allocation failure
Date: Wed, 18 Nov 2026 15:35:18 +0100
Message-ID: <20261118150136.027468890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 307e27d3e07f58b6d42a8c64d31304aa614ab7d2 ]

qat_dh_init_tfm() acquires a QAT crypto instance before allocating the
software fallback transform. If fallback allocation fails, the instance
reference is leaked and the device remains permanently in use.

Release the instance before returning the allocation error.

Fixes: 5d5bd24f4155 ("crypto: qat - implement dh fallback for primes > 4K")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 173392fdf5bc4..aa809e6d67bfe 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -535,8 +535,10 @@ static int qat_dh_init_tfm(struct crypto_kpp *tfm)
 		return -EINVAL;
 
 	ctx->ftfm = crypto_alloc_kpp(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->ftfm))
+	if (IS_ERR(ctx->ftfm)) {
+		qat_crypto_put_instance(inst);
 		return PTR_ERR(ctx->ftfm);
+	}
 
 	crypto_kpp_set_flags(ctx->ftfm, crypto_kpp_get_flags(tfm));
 
-- 
2.53.0



