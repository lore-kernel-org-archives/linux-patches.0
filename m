Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6075C619;
	Tue, 23 Jan 2024 01:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974370; cv=none; b=U6SPNCF5jAXZnNtwa2ppjNflxkEUp4viJ2iBNBr2mrwKX7lywXATEiMNpY5yQ7pwfKJqD01tmWr1L9fwu5Hj92mtO5+wDDE9N4+6x2JroqeMUJx5dNzj85D6x0cD7m1WfgdAxYESnFJn55Ggmyhq1ABxJCG6PzUg/kNnnphw/hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974370; c=relaxed/simple;
	bh=rXNwmbb8Ay2AfWzdNpE2Goh0xeiPRj+gr7GH/cqwBRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMDtmonJb5AJOnCmvBqQVxRGko74CFVh0aWSQZI7OcnUKovFirDolNvpVdkqgRB3H//WlJu7D77HWkoGrgzpmCrxdFl49eyh1Ut1Rd8jTWijFS17tn54/Nb3X/aFlEpnK5g+ku2K6U10onsa89bkBazYP/76IxsZSzoXaJN9gVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7j5SiSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7j5SiSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D079EC433F1;
	Tue, 23 Jan 2024 01:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974369;
	bh=rXNwmbb8Ay2AfWzdNpE2Goh0xeiPRj+gr7GH/cqwBRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7j5SiSgl9I9AIP8uFBR5KhYmdMVsmks72JpnOY+VjfcjFg17Tj2DbU1NmGvbCZFQ
	 /TtS2N133OoR6Q/pZswRYotJKejc1JvVit6Jk1nQgcsYCozPUcimjmvAwiPJ4CLlpv
	 I+eGkt7fQqgzH+YBBWIS6cFJadLXsBaBCoQHX/mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/583] crypto: sahara - fix ahash reqsize
Date: Mon, 22 Jan 2024 15:52:00 -0800
Message-ID: <20240122235814.259732210@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 96f59d57c36b..80d419d6a609 100644
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



