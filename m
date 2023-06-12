Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6CD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43814C433D2;
	Mon, 12 Jun 2023 10:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566869;
	bh=JGArsnGpUZ67DXBDnAEQi3ykRVpK6gnih3n/0AwWznw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMTAuj/XWXbvlu8ERUrXrcqHyFjVLqkqpzH1J+0AmiDsBs+zevDzY0Zq8M+Eimqih
	 ZomAgexFnriMKJaB1k7mesYVNupkjOvLQBb35Ln1NkhjBa16KaazVecw0/kGpYeKRX
	 RrW5zIe8bZ+wqAiRLE20UirGXhvqAKsV/vM2AhEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 063/160] bnxt_en: Fix bnxt_hwrm_update_rss_hash_cfg()
Date: Mon, 12 Jun 2023 12:26:35 +0200
Message-ID: <20230612101717.892993207@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 095d5dc0c1d9f3284e3c575ccf4c0e8b04b548f8 ]

We must specify the vnic id of the vnic in the input structure of this
firmware message.  Otherwise we will get an error from the firmware.

Fixes: 98a4322b70e8 ("bnxt_en: update RSS config using difference algorithm")
Reviewed-by: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 651b79ce5d80c..26766c93b06ac 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5376,6 +5376,7 @@ static void bnxt_hwrm_update_rss_hash_cfg(struct bnxt *bp)
 	if (hwrm_req_init(bp, req, HWRM_VNIC_RSS_QCFG))
 		return;
 
+	req->vnic_id = cpu_to_le16(vnic->fw_vnic_id);
 	/* all contexts configured to same hash_type, zero always exists */
 	req->rss_ctx_idx = cpu_to_le16(vnic->fw_rss_cos_lb_ctx[0]);
 	resp = hwrm_req_hold(bp, req);
-- 
2.39.2



