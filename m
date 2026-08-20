Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F6347D931;
	Thu, 20 Aug 2026 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243184; cv=none; b=rXwIE60zEaLzgxAsWmS36rpZM/OVkgYHUC4c0oPX01tm21KZ/OwQKeXLxcgkM6g5u/kQOD3TqtpyNOc4Qf4/66Jj5Jz+mZYxv0GIth08z8q+qGsUVyvmrLqiOEo9IEXTghL4JG1iWclNsueEKN1d573uxY6B3tUwGKo1lCR+3/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243184; c=relaxed/simple;
	bh=xjMNbbc5VOa3IIn/oxB4RMaMU99SkfjWX4nrgG4u7Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qiur9Ydf7tl6/b0nLMza+KPRJq+wUp/7W6VHbsAXBqCIodPIFMJsw6IMsjzOcWRwOyVfd/UaqUqdOBqn4kMo/IWYd/VTjxK3ao/hicp34po59e/1jrWCKY9vfJ8lYHD5WfU2t8sstWRpq6nJtWtP69r3YTaoDLl9njip94ADOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbYJvBNO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbYJvBNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAABC1F000E9;
	Thu, 20 Aug 2026 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243180;
	bh=Q5ob6/QNAGUW07JH5/eo336aosggeUaeWv29A/m2FtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbYJvBNODjNbQuTNHitExx4bBWeSXkcLtSPD2fbumemsOfVbpNw3qpe8bGTBEgiAg
	 wgi0gl0L9Uwb8+tiuH4rs4Ao4NW4muDI5xsf/W08bUNLho6Du7GR45cHevsFAp8IcG
	 C2L1W58qPfGLtMm6JtGyO2TiCsWuXCuWDdO91Y0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/303] crypto: ccm - Set rfc4309 maxauthsize from child
Date: Thu, 20 Aug 2026 16:56:54 +0200
Message-ID: <20260820145301.822870511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 438f4896f78f69ec73d5f32d2c024193f1223569 ]

Set the maxauthsize of rfc4309 using that of the child algorithm.

Fixes: 4a49b499dfa0 ("[CRYPTO] ccm: Added CCM mode")
Reported-by: Seohyeon Maeng <bioloidgp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ccm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 6b815ece51c6a..30c8f10408a3d 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -753,7 +753,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 
 	inst->alg.ivsize = 8;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-- 
2.53.0



