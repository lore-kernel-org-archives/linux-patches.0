Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F105200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C11C433C7;
	Fri, 21 Jul 2023 19:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966126;
	bh=HvG5c/nDsy0VF8UTuZmniUkLMAH7WxOVsBnmyLQIeWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K85/YOaZuv/DLhtwlR/VrgqQqEzT6CiseJShXdMjrsJ3dVoaskhXoq7GH0MGVXgKK
	 0cIMWBH4s1Iq3Nlu2+JuEmBwt+WepvaXRTH/AN+PHMJ9T2xH3JWffQmN9L/c9w2/Lj
	 T2LTyI/hZjER669pOzY/shXoYYp/W4hCU3TN4M9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/532] crypto: kpp - Add helper to set reqsize
Date: Fri, 21 Jul 2023 18:02:18 +0200
Message-ID: <20230721160627.062222395@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index 659b642efada1..05b25a819d0d1 100644
--- a/include/crypto/internal/kpp.h
+++ b/include/crypto/internal/kpp.h
@@ -18,6 +18,12 @@ static inline void *kpp_request_ctx(struct kpp_request *req)
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



