Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5892F4BEE54;
	Sat, 12 Sep 2026 09:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206144; cv=none; b=t1sPUM0p93ZpUxSJFpWM3RAQAPj9SR4zCgjSRAlJHLViELFq8AVN0qXjtFHOFx/gJFiCYtc6KU3yvbIaTm1k2DqmezG3nbxmmLDOTvO/kgEjKSS8WkedIUDIeQsN46K0JYvmlW/+qGuWhBTbjBTcZnqcc9e1MFE5wmxSBb74kn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206144; c=relaxed/simple;
	bh=7QhqNANzhGOCjD7Kt9oZPhgb3Cs87Pc3gkQDBvKno/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjXFHyzZx5/WDiLPBwQUnOdnQPlS2Gs0tyVocgUcbhp4h0PwsuiC9ZvXMdl69IyxbheZ37vMqqrd8M6W6S3f18wSgOkphdsCKt8UY6ucswg+1IId/z1FKhoiIgSbJ+ho5uI8nMh+Y1mwR69uRVlcX0AUWW99x2c4bTBdk05Hkvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjtRnnd3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjtRnnd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2FB1F000FF;
	Sat, 12 Sep 2026 09:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206143;
	bh=Eeh3Z4t4S5c9QxhT9xf1SmxlMt0NuGMnirsZPL2z2ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjtRnnd3bBrzqCpPbP16qyKlnybozL0uxi/yqHhKUPAosCC43dMcF4vRw/f88Wbz3
	 t7GjRZ5ctXT/gll3TI7OxB0VS/XLpE14TgFiDdZ1HwNMdJ2hDrecKXWUzJhgg4+BaT
	 hmaEvrWRYYDfJ+qLlQpL18cRGd6Jd1ywxDuJcFls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0147/1518] wifi: ath12k: correct monitor destination ring size
Date: Sat, 12 Sep 2026 08:38:36 +0200
Message-ID: <20260912065626.819218952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 913998f903fb1432c0046c33003db38a9e8bedb1 ]

The default memory profile configures rxdma_monitor_dst_ring_size as 8092,
which is a typo. The intended value is 8192, consistent with all other ring
sizes in the table being powers of two.

Correct the monitor destination ring size to 8192.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: defae535dd63 ("wifi: ath12k: Add a table of parameters entries impacting memory consumption")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260616062342.4079796-1-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index cc352eef19399..5fed8d1bcadb3 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -46,7 +46,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 		.dp_params = {
 			.tx_comp_ring_size = 32768,
 			.rxdma_monitor_buf_ring_size = 4096,
-			.rxdma_monitor_dst_ring_size = 8092,
+			.rxdma_monitor_dst_ring_size = 8192,
 			.num_pool_tx_desc = 32768,
 			.rx_desc_count = 12288,
 		},
-- 
2.53.0



