Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC998F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5AAC433C8;
	Sun, 16 Jul 2023 20:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540459;
	bh=0tcqVNSTf99UKfOObiqCCc26cJ6qUzBuwXHjnm5pMvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUuSpqxzfpFKpmhszJRJKpWLNrZ2U+ehTRr9poXX3cuMI2NZsCgfjEZLnU3Mf+5ct
	 Ph/F4SCD6SlOtuzrlUjah90Hf0XcRACCjCdVH52zRnP0BDTiNcKIZ4He30njB8HUiG
	 tDD6Yz1FAkNV5nKiMsbHHEVcH9u82W0a+TbWx/NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 343/591] crypto: kpp - Add helper to set reqsize
Date: Sun, 16 Jul 2023 21:48:02 +0200
Message-ID: <20230716194932.784082721@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 56861cbde1b9f3b34d300e6ba87f2c3de1a9c309 ]

The value of reqsize should only be changed through a helper.
To do so we need to first add a helper for this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: eb7713f5ca97 ("crypto: qat - unmap buffer before free for DH")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/crypto/internal/kpp.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/crypto/internal/kpp.h b/include/crypto/internal/kpp.h
index 9cb0662ebe871..31ff3c1986ef0 100644
--- a/include/crypto/internal/kpp.h
+++ b/include/crypto/internal/kpp.h
@@ -50,6 +50,12 @@ static inline void *kpp_request_ctx(struct kpp_request *req)
 	return req->__ctx;
 }
 
+static inline void kpp_set_reqsize(struct crypto_kpp *kpp,
+				   unsigned int reqsize)
+{
+	crypto_kpp_alg(kpp)->reqsize = reqsize;
+}
+
 static inline void *kpp_tfm_ctx(struct crypto_kpp *tfm)
 {
 	return tfm->base.__crt_ctx;
-- 
2.39.2



