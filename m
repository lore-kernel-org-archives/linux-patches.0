Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E6B30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ADCC433C7;
	Wed, 20 Sep 2023 12:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212926;
	bh=AZYJ5AmqwJMCZOArXVBiTxg1nBgxzPkQrbqqZ/br89A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOhnsOPkv4f65iATV+dH03/L9GCUYYZj2zaaRSGlwdrGHa3toGb00WhYWCNSr9cfs
	 hFwGLNZ4lgKuaWMBEcVWMpT6wFrWlWR4VGlAbidzjm+rDekY/lLJnH1AXY9tasjlHk
	 56DoBiCo8j+y6WKSGD6x/R+XfQiu5IJGnPHSXm48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/367] crypto: caam - fix unchecked return value error
Date: Wed, 20 Sep 2023 13:27:27 +0200
Message-ID: <20230920112900.331475153@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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
index 30e3f41ed8721..e0bba20c13cb5 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -225,7 +225,9 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
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



