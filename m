Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016053;
	b=4G7HgHNoBRTECtOzCuP0kwakM/X8fo4zL37MN8vZ9+N+dqQGC9ajpjs7ioGeJE23BJMt
	 SK56EAtnHIOF7BgBbmSnL+79JAVd/segnvVZXwZf1V3ktWi4Ps5sfAFgawtYhaQBjpV5R
	 I69M2Gtxj0tVZyjY4otBKDpgbgydWQvMppVodWGva/51IxVWntDNq+eOUMG0pC2hpttN4
	 gwmhZD+6HYStl5IPcD3YWGsjDj7sWWatHSn8J43Acx4jbAgoMOaHqnIN5pcmrbbsC4RmJ
	 3ibnujSep8pChLQL800Fl2oH8sItOe0/5M14eqcNFIn96eBkhAkbud/bYtOVPKMx22A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aJ61tzRN4SRrokKg503yW+rw2Qi+rnhcqRIoK7XDOAU=;
	b=rSGQFc1szniuRJRfDebR6ktyWe/KAtls2QMqudfRPSqcvpPz7HaSF6w+O0KV+xQXcRLA
	 CkcHNk2gJBjvNOV2NmL1Q2mPEBde4cwksLnXcQelG9rNVa/RE+/jr6XFmI7rTZySh1OAl
	 PH0vLq5jPKc6WRqS4A/SjeiWjuF4d9UQ0gPCH+GAYFvfS2KJsXxHXMdtPk6yVxnizphJq
	 BeUGxWrJDeYm4xxADWMUeiWyVPbdMnUFIAw2BeQMjp05dw9d+3w5J90vDhwo2AnKPD9kh
	 VkkeBdyBMZMnEc+YE9Xm27YyVAqPgQDrfOeF8snbXuLh7hKq+eKV23XUYTdguWYRFPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4oTRXtB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309C606A31C;
	Wed, 18 Nov 2026 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4oTRXtB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BB91F000C5;
	Wed, 18 Nov 2026 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016053;
	bh=aJ61tzRN4SRrokKg503yW+rw2Qi+rnhcqRIoK7XDOAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4oTRXtBXtC3GNTTQ2PBDE4TWrR+SCL6lAvuagqmd+0DXIq+AUSJoxXJ7zxChtDJf
	 O9A+7o72V76ITLR0iDTyIiddjvSBiMvTESgLPmuAnTe/97Ou0qa9meyeCPqtCxu/pN
	 ZPZ8hpa2y1eTr9XTOTNkRDsBxnOly7cEdfFvt16I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0393/2651] crypto: qat - release instance on DH fallback allocation failure
Date: Wed, 18 Nov 2026 15:27:13 +0100
Message-ID: <20261118150301.985506848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index aa2ea563f25fa..1049c583f84f1 100644
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



