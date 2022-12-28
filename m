Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5341C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F95C433F0;
	Wed, 28 Dec 2022 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244676;
	bh=McW/8nwFYSGcHhImg2cINQRrI6dxWYM/dTlcRg4RDc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7lBKUL0oagEQXWRpsNMYdcLhJkHPEYOp1gC596qTZu4ABuP4zoFoCMgAOe54N7o4
	 tZaXubN2Nys+jA9Y68txGFq+O6xdf2IMLuSFLy335P+jDlKL4EhV7eK04e/sXWFWhi
	 p5CFLpWTIufbAIbhu60AlZ5tsCmXfy0b37u/MqJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0713/1146] habanalabs: fix return value check in hl_fw_get_sec_attest_data()
Date: Wed, 28 Dec 2022 15:37:32 +0100
Message-Id: <20221228144349.511237980@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8749c27895a369a99e4a21709b3e3bec4785778f ]

If hl_cpu_accessible_dma_pool_alloc() fails, we should check
'req_cpu_addr', fix it.

Fixes: 0c88760f8f5e ("habanalabs/gaudi2: add secured attestation info uapi")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/firmware_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 2de6a9bd564d..f18e53bbba6b 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -2983,7 +2983,7 @@ static int hl_fw_get_sec_attest_data(struct hl_device *hdev, u32 packet_id, void
 	int rc;
 
 	req_cpu_addr = hl_cpu_accessible_dma_pool_alloc(hdev, size, &req_dma_addr);
-	if (!data) {
+	if (!req_cpu_addr) {
 		dev_err(hdev->dev,
 			"Failed to allocate DMA memory for CPU-CP packet %u\n", packet_id);
 		return -ENOMEM;
-- 
2.35.1



