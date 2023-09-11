Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C9C1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E989AC433C7;
	Mon, 11 Sep 2023 14:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442311;
	bh=JFQ9nYSXilBDGJ+FApDN/Sb/WuvzmV35KhL6LjskFyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvTV3yzQsqB2J1VHK6SwpYzlaUfjQXemPJyNMudMJS6B0l3PXENeJGNbfKF1AT+5X
	 nwwBBFD5W5+62QWJORdxF3zfTJsjQPPZ7l/aP/pC8HXN5hTSM51kzzS///6wNcuw/X
	 RaplGaSFbhJzmtcXgPmhcdms8vcMWPQTM4tv1m3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.5 720/739] crypto: stm32 - fix MDMAT condition
Date: Mon, 11 Sep 2023 15:48:39 +0200
Message-ID: <20230911134711.193334890@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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


