Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1786243AC4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG4PxqG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADB5C4AF69;
	Wed, 15 Nov 2023 20:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081396;
	bh=4TJvYqPD/spiVTKi5o+kEp0g/0QVRhJWy9FBv0VurMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG4PxqG+TKO8mkTOmOTBpTDOOFL5Y3DoO9Y0MinRlZ7rGoFUX9tLv98P1JnoCA1Sf
	 R2U5T12TL5iS0AaVV1jOn3OB963OF3jxMxJi3Q0uHrI9n8GmgJ0tiuDshTzzxt9+qO
	 VLEjBtR8S/HEHFOsXvLFTLa6xZ9LGE7JB9s4Oq0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/244] crypto: hisilicon/hpre - Fix a erroneous check after snprintf()
Date: Wed, 15 Nov 2023 15:35:20 -0500
Message-ID: <20231115203556.058670143@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c977950146720abff14e46d8c53f5638b06a9182 ]

This error handling looks really strange.
Check if the string has been truncated instead.

Fixes: 02ab994635eb ("crypto: hisilicon - Fixed some tiny bugs of HPRE")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index edc61e4105f30..08e56f1da365c 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -854,7 +854,7 @@ static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 
 	for (i = 0; i < clusters_num; i++) {
 		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
-		if (ret < 0)
+		if (ret >= HPRE_DBGFS_VAL_MAX_LEN)
 			return -EINVAL;
 		tmp_d = debugfs_create_dir(buf, qm->debug.debug_root);
 
-- 
2.42.0



