Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1108148FE6;
	Tue, 23 Jan 2024 00:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969179; cv=none; b=NginWitfWMInpF6/ATWw/9Eg5jOF/M6AjwqNuRVXQmtpoG5Upc7n25wbnre3Oq6NERiMP43PKRESChC1upnWuidsQ6Z2MBBK37/ZyMe78rSux/lFfQ0AL8HnaVDi6SO/kHekZLUznMrtS/PsGmxTCPl8oCGPPSMJBgpFxcWvzrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969179; c=relaxed/simple;
	bh=TbNR9RrOtND68mfh58j+mBNw/uZ3cW/vDGJqlZasK5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJSa+0XxLRhUyw/TAaTAbsMIxMSBrHe9gffTikQU9kfvLwdsU5gpCeoZW2y/Tt5MPoEbils4NoVlMTvLj6zRPws39AOte85UvVaoxQ9q3v5jl7AhDd4gnbQDRC4w8ETSGvG5Phn3H52v69Hy62IH6OPqYb7kf91U3jXr+3miGsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/XBfATM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/XBfATM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50055C433B1;
	Tue, 23 Jan 2024 00:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969178;
	bh=TbNR9RrOtND68mfh58j+mBNw/uZ3cW/vDGJqlZasK5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/XBfATMpiUIZUxnXuiHHZMyr0TpCE+iz//mOCXdhpjcxqAIXE8nsDQ+T65uyN9Zr
	 02BUCyjEzWGeTHnIR8t1EAhMCljuqcpgNonXTYn0SEK4dBSHNvirQAnzQB4ZZWlbfO
	 3JUTanARp1VKdqN2OUk/Xt5bxSCb65rR/OEhazC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 077/641] crypto: sahara - fix ahash reqsize
Date: Mon, 22 Jan 2024 15:49:41 -0800
Message-ID: <20240122235820.444027665@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit efcb50f41740ac55e6ccc4986c1a7740e21c62b4 ]

Set the reqsize for sha algorithms to sizeof(struct sahara_sha_reqctx), the
extra space is not needed.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 78666b82ac80..31973e6ce520 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1162,8 +1162,7 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
 static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 {
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct sahara_sha_reqctx) +
-				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
+				 sizeof(struct sahara_sha_reqctx));
 
 	return 0;
 }
-- 
2.43.0



