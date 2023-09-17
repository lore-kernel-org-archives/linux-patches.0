Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7546FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E8AC433C7;
	Sun, 17 Sep 2023 19:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978593;
	bh=CkwtqjJlOr6rUmGAlOhG2N8wnzwBseVUbuk5OV6iqCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVAaxOurZlF2G4PeJUTUMDTlJ40ncpqaNp2+y4EJh/BtYj4VGwoE6GmTx3i6lSTfr
	 E+6St2Aw2FcpRw/GKT0xCnfuP9Y3Vu5nWmfuAtr7br1VRdYFZ4i+MLGuQPhPSz1Dag
	 qSVpiLQDDlnHcAbg/Y6YlQ9/C+M0ScXKmBpSOGYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/406] crypto: caam - fix unchecked return value error
Date: Sun, 17 Sep 2023 21:09:17 +0200
Message-ID: <20230917191103.850470761@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Jain <gaurav.jain@nxp.com>

[ Upstream commit e30685204711a6be40dec2622606950ccd37dafe ]

error:
Unchecked return value (CHECKED_RETURN)
check_return: Calling sg_miter_next without checking return value

fix:
added check if(!sg_miter_next)

Fixes: 8a2a0dd35f2e ("crypto: caam - strip input zeros from RSA input buffer")
Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caampkc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 3acc825da4cca..5bd70a59f4ce2 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -222,7 +222,9 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
 		if (len && *buff)
 			break;
 
-		sg_miter_next(&miter);
+		if (!sg_miter_next(&miter))
+			break;
+
 		buff = miter.addr;
 		len = miter.length;
 
-- 
2.40.1



