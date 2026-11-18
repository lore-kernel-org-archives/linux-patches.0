Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029455;
	b=aedSuyna1P1nO194ny26QKRV6ceW66q8u4vbOOaYdqdkB9uLRf/4LOKJNdoJOGnxbxuo
	 vt3zEc8+FMMh0odxfKKkWAZXHq0hKejFxL3H6PelvkCijMYlgDflXqHc3Bl1r/IUmzIGC
	 MWOwoUWH38yUts7gVTqr8wQ/YARxMJYvV2ynARfyWVP2V2nGWFtea/JudU5TSt2R24JRn
	 WGgGVTCHezptVBKKPFfNCFqa6ACv7a6MWnkE+pZpVW0aHsIHPQKYKA0n2hUc53wqpTVze
	 +Aky88v2TDWHD+XTXN86eGccyRrVpMW0oyluM11xiOAE2xvx6R5CgC0JnMP+MeWvWWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WBPDNjlaxADiGq07IQFhrRnSwDN2WJUQaCZvTSaHh/Y=;
	b=LqqfSuwibrYIkS/69UfTISWe1MdIznhrnBlvfcuz5G4E1GS838ZF68AS7yhPLML/+hPo
	 LRkQTpm6TIE5y3TLwWd7Ghd5Ffk+eRAdCSw42gGJOFfZg3/SDRqihIeY2atI35jAS850T
	 zq/u80Am4pMdYQfXu5dEfLe6OaA87eG2rkMf+C5lqfZNciSlndceynQECoAIRo2PRDBsB
	 W5w4p9N2pc/6P+8j8lNlwDt/P6GKqKivMeNxEVrYYdQqzFP/mR3XhmkCmoQMOjJob31I9
	 Wtuo/hLaSkrKM4asu7Gpt6UpUl+24BWN9No81Xswa9B3cG8i2VHh16zDExG1u6zt/Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a0So/oQf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B57606A330;
	Wed, 18 Nov 2026 19:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a0So/oQf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E621F000C4;
	Wed, 18 Nov 2026 19:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029455;
	bh=WBPDNjlaxADiGq07IQFhrRnSwDN2WJUQaCZvTSaHh/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0So/oQfPlL1Pfz3aeP+qPd652R0CI7Of3KhqLFOo/zpKfsceUOk/GLDN4ow3Jc9e
	 toJlppy/fVAPCsYYjyvP4L1NXbZqgO8AQHTiqKhOlsch7iF+PoRz1lBEf6Mb+bDpJr
	 0lldF1JjDfxIhllMnGKB8OTwJisncJLuAqg46Yd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0355/1756] crypto: qat - release instance on DH fallback allocation failure
Date: Wed, 18 Nov 2026 15:41:22 +0100
Message-ID: <20261118150022.475344847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



