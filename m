Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3533413B2A2;
	Tue, 27 Feb 2024 13:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041160; cv=none; b=U6b2Dzn1qeejXTaUiCo6l+LMEMiI7punhty4gN+ExoArbc4OyC3VXuytjlUgx+y+5nCLmUeTwqPLMapwFFxVtpxpR9r4Ouj15pXreEdFO2BgG3e7jasm5WRCTZJ7shaj5IlTi0xYx5nzMLGvIPt7cKMq/6Y/AwZUdUc5MwvLxDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041160; c=relaxed/simple;
	bh=eTXOlJTEm6k3qXfOgpy+xHaSqLwlzHm6aP+3uHJZnEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF5wjJ+ZQ5aOnW7YZqLuoWG7EXgsWGUVAk33qMT+C3oa6ljlpQYf8JziPX8rFA3L1f7Ki0KwYrehvpSac867m1l8kW8BbCmUSoXuR7mGEGs80lDYHymV4pS1SDyxx/ciukpvAEFF6ObhCvFFjQpSMI0ba4fkyhUz+o67hEnAskM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea0ZWH/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea0ZWH/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFBDC433C7;
	Tue, 27 Feb 2024 13:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041159;
	bh=eTXOlJTEm6k3qXfOgpy+xHaSqLwlzHm6aP+3uHJZnEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ea0ZWH/w8Xwfszmr+JgjMdCCAvwhVH2xhkow+nMvneOQ5GNjWQIBG90J1UGSI4pFQ
	 OTr2njRRiQtQuwV3uDe+ir+lQSQ1lm656gu03KBlIhCouOLcgB7rA8uoH6tQtyQneN
	 YfXEgWjS5hSyppbi9FzNBn4uR/S+C+DObcpyc/ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 240/334] RDMA/irdma: Add AE for too many RNRS
Date: Tue, 27 Feb 2024 14:21:38 +0100
Message-ID: <20240227131638.623129798@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 630bdb6f28ca9e5ff79e244030170ac788478332 ]

Add IRDMA_AE_LLP_TOO_MANY_RNRS to the list of AE's processed as an
abnormal asyncronous event.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@gmail.com>
Link: https://lore.kernel.org/r/20240131233849.400285-5-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/defs.h | 1 +
 drivers/infiniband/hw/irdma/hw.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/defs.h b/drivers/infiniband/hw/irdma/defs.h
index 8fb752f2eda29..2cb4b96db7212 100644
--- a/drivers/infiniband/hw/irdma/defs.h
+++ b/drivers/infiniband/hw/irdma/defs.h
@@ -346,6 +346,7 @@ enum irdma_cqp_op_type {
 #define IRDMA_AE_LLP_TOO_MANY_KEEPALIVE_RETRIES				0x050b
 #define IRDMA_AE_LLP_DOUBT_REACHABILITY					0x050c
 #define IRDMA_AE_LLP_CONNECTION_ESTABLISHED				0x050e
+#define IRDMA_AE_LLP_TOO_MANY_RNRS					0x050f
 #define IRDMA_AE_RESOURCE_EXHAUSTION					0x0520
 #define IRDMA_AE_RESET_SENT						0x0601
 #define IRDMA_AE_TERMINATE_SENT						0x0602
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 2f8d18d8be3b7..ad50b77282f8a 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -387,6 +387,7 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 		case IRDMA_AE_LLP_TOO_MANY_RETRIES:
 		case IRDMA_AE_LCE_QP_CATASTROPHIC:
 		case IRDMA_AE_LCE_FUNCTION_CATASTROPHIC:
+		case IRDMA_AE_LLP_TOO_MANY_RNRS:
 		case IRDMA_AE_LCE_CQ_CATASTROPHIC:
 		case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
 		default:
-- 
2.43.0



