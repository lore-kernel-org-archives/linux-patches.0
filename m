Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4F1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F171C433D2;
	Wed, 28 Dec 2022 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245929;
	bh=HfpF1kwBCV5oWG+2QYBNPgN87j+LcvD8NQyVW5bCZPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4AQdbSTTlZ8GcNI6V1zefK2OcjY1gMAMe/1op9rSkaKgPXg23taRJtX+LkgZhoBe
	 JhpVkUbxjWzxZ8pxyHw02EV/E8uctOM77VWfu4gsXRIvQmjRiUoUU5K+Azkd7jrTBm
	 aubWKFduuUCxh6lGY8j3dvvn+mNBjeiugRiky45M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Ye <yekai13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0982/1073] crypto: hisilicon/qm - increase the memory of local variables
Date: Wed, 28 Dec 2022 15:42:50 +0100
Message-Id: <20221228144354.757002077@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 3efe90af4c0c46c58dba1b306de142827153d9c0 ]

Increase the buffer to prevent stack overflow by fuzz test. The maximum
length of the qos configuration buffer is 256 bytes. Currently, the value
of the 'val buffer' is only 32 bytes. The sscanf does not check the dest
memory length. So the 'val buffer' may stack overflow.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 180589c73663..959f4846aa23 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -252,7 +252,6 @@
 #define QM_QOS_MIN_CIR_B		100
 #define QM_QOS_MAX_CIR_U		6
 #define QM_QOS_MAX_CIR_S		11
-#define QM_QOS_VAL_MAX_LEN		32
 #define QM_DFX_BASE		0x0100000
 #define QM_DFX_STATE1		0x0104000
 #define QM_DFX_STATE2		0x01040C8
@@ -4626,7 +4625,7 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 			       unsigned int *fun_index)
 {
 	char tbuf_bdf[QM_DBG_READ_LEN] = {0};
-	char val_buf[QM_QOS_VAL_MAX_LEN] = {0};
+	char val_buf[QM_DBG_READ_LEN] = {0};
 	u32 tmp1, device, function;
 	int ret, bus;
 
-- 
2.35.1



