Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9851C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F48C433D2;
	Wed, 28 Dec 2022 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244026;
	bh=+kmADvufavP2PZw3Dyc68PmielJOz4YxEOaq3ySOW7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyN37l4/YCYZu1Em27Nq6qGhva0d9lBSqXKV49uR6PPlOz9rQS8wbSRh+EYjH3hiP
	 msSNjhK1aUIxBkfvhFwiv1loKgxwr58+jxk4AciW+7gJu8S/H0IliBfMlOPa4otwfn
	 iKOt30PY0H/JAEZocm1J0BNDdMneMUbhQf79HJv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0575/1146] crypto: hisilicon/qm - fix incorrect parameters usage
Date: Wed, 28 Dec 2022 15:35:14 +0100
Message-Id: <20221228144345.790867341@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit f57e292897cac13b6ddee078aea21173b234ecb7 ]

In qm_get_xqc_depth(), parameters low_bits and high_bits save
the values of the corresponding bits. However, the values saved by the
two parameters are opposite. As a result, the values returned to the
callers are incorrect.

Fixes: 129a9f340172 ("crypto: hisilicon/qm - get qp num and depth from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8b387de69d22..c7e7fc49ec06 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -909,8 +909,8 @@ static void qm_get_xqc_depth(struct hisi_qm *qm, u16 *low_bits,
 	u32 depth;
 
 	depth = hisi_qm_get_hw_info(qm, qm_basic_info, type, qm->cap_ver);
-	*high_bits = depth & QM_XQ_DEPTH_MASK;
-	*low_bits = (depth >> QM_XQ_DEPTH_SHIFT) & QM_XQ_DEPTH_MASK;
+	*low_bits = depth & QM_XQ_DEPTH_MASK;
+	*high_bits = (depth >> QM_XQ_DEPTH_SHIFT) & QM_XQ_DEPTH_MASK;
 }
 
 static u32 qm_get_irq_num(struct hisi_qm *qm)
-- 
2.35.1



