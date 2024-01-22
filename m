Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2715712BF3D;
	Tue, 23 Jan 2024 00:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968931; cv=none; b=LuW8z4ZwC77ybl0yXDOuGJ1qo/CW5MSq9ntYaW9zvZb2PR+EMHGTZhDZ4EvcpabIZuJxQJMOjIF8+88bJiriQjIEmCmFbcWljIX3FWHcP4lU/E2Rh4j1KB+NOFEzaeG22moMFC7CMbBwxIL+Aj4hHgeJhrgHfTS/DThcZZsiXKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968931; c=relaxed/simple;
	bh=/7hcD4WRygq0ItoIHn3cQi+6Em/yEcErk92ypOgMv4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxNushJQ+NrH7lk4Jhk03aDMLQ131ElC7paMxJMyz7QIMWV07GvNnQku+9RcX7mddFkROYGEtaFtX9GL+69PGw8hYyHfKGJ0gqTgU60sDDTS0JS7XxUvWDWUKBH3W6E1Ma5xJmUJowz5rUZkjGmBwuhsoxBXVn3uxzYHRgkKa2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/5fHSHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/5fHSHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE33C433C7;
	Tue, 23 Jan 2024 00:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968931;
	bh=/7hcD4WRygq0ItoIHn3cQi+6Em/yEcErk92ypOgMv4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/5fHSHR5rW4ZyiIOcGf0Q099HB1P8kJk5T6A9KUVO4SjPRQ1PObij0wx+lCfdpTW
	 rrAAvT8Rliu1+7dUqzFVAt/pFZ/CAi3RD40IU83bgcClRjnqJ9jJz694XB6qo0bgtz
	 UjmoZepKJF2xh75Z2ckkOXr5BOO/uQOzC4A7YTB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/194] crypto: sahara - fix ahash reqsize
Date: Mon, 22 Jan 2024 15:56:42 -0800
Message-ID: <20240122235722.321716908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e505c01b7a05..1284991cd40d 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1178,8 +1178,7 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
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



