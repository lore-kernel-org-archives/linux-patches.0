Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2928B1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28E7C433D2;
	Wed, 28 Dec 2022 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244394;
	bh=UM2gO9+o7hnCGwcUNaEeEQAPY079Neovmli6/kdR7V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRBaGNneXrlyYZrI5otiB4sgj+Vyj6Jb98GKMf7tsxK1q8xQkCL0+aWBMpvYZSWII
	 PB7xEpq9EsNlpoga7aOcUsG/4xOpwBiTQTLpN40yuMN3SwY6mZnQPhIdLJSWEkizWu
	 ntOosf2JqLUFiKl9P7uEeXui3rEO5W9tOSyRJPRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0662/1146] crypto: qat - fix error return code in adf_probe
Date: Wed, 28 Dec 2022 15:36:41 +0100
Message-Id: <20221228144348.134590622@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 31f81401e23fb88cc030cd586abd28740e6c8136 ]

Fix to return a negative error code -EINVAL instead of 0.

Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index 2f212561acc4..670a58b25cb1 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -261,6 +261,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
 	if (!hw_data->accel_capabilities_mask) {
 		dev_err(&pdev->dev, "Failed to get capabilities mask.\n");
+		ret = -EINVAL;
 		goto out_err;
 	}
 
-- 
2.35.1



