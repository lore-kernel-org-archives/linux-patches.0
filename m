Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FA411706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015AFC433C8;
	Mon, 11 Sep 2023 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444386;
	bh=Rd2pgj+FEY+vqvXa8mUu1oKZMHjDYj18GDkrmnA+uT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTVFz6JAKevfVrrHIdwYVpPCz2D+alCfEQ1MIFwqCkA0AoLHZSFLlcnZ2XfMrLu3N
	 k3nnuKxlzzxTjNuSTXESpZKKMx61nZ0qbKue4hWiPRrVyM6oIBvN6B5Up1UpEwvaj3
	 jRWYS1aGCILim/0R2d8GJ+JMYDULlGS2Gi7Pzq5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.4 712/737] crypto: stm32 - fix MDMAT condition
Date: Mon, 11 Sep 2023 15:49:31 +0200
Message-ID: <20230911134710.409981152@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>

commit a4adfbc2544933ac12e7fbd50708290265546dbc upstream.

If IP has MDMAT support, set or reset the bit MDMAT in Control Register.

Fixes: b56403a25af7 ("crypto: stm32/hash - Support Ux500 hash")
Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/stm32/stm32-hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -492,7 +492,7 @@ static int stm32_hash_xmit_dma(struct st
 
 	reg = stm32_hash_read(hdev, HASH_CR);
 
-	if (!hdev->pdata->has_mdmat) {
+	if (hdev->pdata->has_mdmat) {
 		if (mdma)
 			reg |= HASH_CR_MDMAT;
 		else


