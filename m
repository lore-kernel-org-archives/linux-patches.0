Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775A43C1D57;
	Sat, 12 Sep 2026 07:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197215; cv=none; b=U5cLFJLtzS/5fhxdC43ciHN98RkTUwpbFZInhe70n+CHdLf/WAsUFN0YzrJveOeidn61YbVFpuWUqfrHzBJHz+Zv4x378ojk6oEAr36P9PTw1SJo2EQQrQte8qJdsuuE+IAVPiE0kLm0dp8Hq/clITbYmIIQ/HOcqIadUuttwaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197215; c=relaxed/simple;
	bh=QOMQGrcpjTXEjKGpFOdzek9a2jlqBmYEZp+V/NkhCEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7dpxkfQ+nQ+5HL+1hXw0QMQUDaL+q59SipAFP8N4xrTW3XoakwqPOu4Ln0XmBdehtc1O8Aq27+KTQm0d3fw0FFqHaGXS3PucoO3RXm/uWegzsxXdhTgkFYxzYDIeWOEEN0HzeRucR0rOLasJscG5z+K3o4OjUthVdOmCnA9JdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo2M+kpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo2M+kpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC341F000FF;
	Sat, 12 Sep 2026 07:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197214;
	bh=1XMQ5hQSFYZRmWeB78cQTyopW+sFl7fRc7NVTj0TYCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zo2M+kpUmcGQQZq0QoPIEX07afV+JUm/154b8mQ+BTgx3RKDecc5ApXgS5YHnFqsC
	 tC0zUR0UGc8WerP4T2vVJTdv/dVrXhAonhADqLQBxbnZ8AY5XzKGheu9BTUHHo1Iyu
	 HBHgr0QgQkqj4b/w97PiTOlYprIdH4yMHvON7CPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0125/1815] wifi: ath12k: correct monitor destination ring size
Date: Sat, 12 Sep 2026 08:31:15 +0200
Message-ID: <20260912065651.950719458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e87165e4f4b33..42eb3f46f5e23 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -49,7 +49,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
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



