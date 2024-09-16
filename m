Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5BE156F53;
	Mon, 16 Sep 2024 12:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488342; cv=none; b=LyqJXP+r/9bahA9f3BR7PuMZSRoBqWVjHBsgeYLLOuBExGsnCQgbSYc3C0Z8HlL9PK1u/117iZ6ibSLKZjc4X4Mg9OF3T5BnbUEKbBRPB6FbD4IUhPGm6852xpBU5ilUyKWQXF0zUcZamzlAUfJB3DUmVHNWRa0OoFMJryb2Ai4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488342; c=relaxed/simple;
	bh=gJhqwPSWmeYte1jsmBwiihR9wPskCqWyqfc1nW12RzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLdjSL58x0EMhCSd6/1PDH7RXEYxm3+xtnl+f5vKFp8dfvuee0eXhVBSH24yhENPllw1lLEImnSqpslgbGQ7maspP+X34B8xxc1Bfx/jygo6RkgYNvsh+08A1hf45s0KofXWRa5Ru6Hcgk8DCMBATT4/gzTJrWV1ZjhIGO2QPKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEqt1uuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEqt1uuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64587C4CEC4;
	Mon, 16 Sep 2024 12:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488341;
	bh=gJhqwPSWmeYte1jsmBwiihR9wPskCqWyqfc1nW12RzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEqt1uuB/V1LARs92OF1qds9T3yd8jG99mVP38qhs1K8pEeGuc5wsusTlgyXedMyb
	 ghEK7RdVZ/9KVoG7jtkaQSXc2KcH7oowiaSh0Z6V7W21/hMsZUKBFH0+J1JlONj/XB
	 tG7ar6boOFlTh1qRUWaiECoVFLx7oAvn+WejiCdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 080/121] net/mlx5: Add missing masks and QoS bit masks for scheduling elements
Date: Mon, 16 Sep 2024 13:44:14 +0200
Message-ID: <20240916114231.803181427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 452ef7f86036392005940de54228d42ca0044192 ]

Add the missing masks for supported element types and Transmit
Scheduling Arbiter (TSAR) types in scheduling elements.

Also, add the corresponding bit masks for these types in the QoS
capabilities of a NIC scheduler.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index d45bfb7cf81d..d4dd7e2d8ffe 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1027,7 +1027,8 @@ struct mlx5_ifc_qos_cap_bits {
 
 	u8         max_tsar_bw_share[0x20];
 
-	u8         reserved_at_100[0x20];
+	u8         nic_element_type[0x10];
+	u8         nic_tsar_type[0x10];
 
 	u8         reserved_at_120[0x3];
 	u8         log_meter_aso_granularity[0x5];
@@ -3916,6 +3917,7 @@ enum {
 	ELEMENT_TYPE_CAP_MASK_VPORT		= 1 << 1,
 	ELEMENT_TYPE_CAP_MASK_VPORT_TC		= 1 << 2,
 	ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC	= 1 << 3,
+	ELEMENT_TYPE_CAP_MASK_QUEUE_GROUP	= 1 << 4,
 };
 
 struct mlx5_ifc_scheduling_context_bits {
@@ -4623,6 +4625,12 @@ enum {
 	TSAR_ELEMENT_TSAR_TYPE_ETS = 0x2,
 };
 
+enum {
+	TSAR_TYPE_CAP_MASK_DWRR		= 1 << 0,
+	TSAR_TYPE_CAP_MASK_ROUND_ROBIN	= 1 << 1,
+	TSAR_TYPE_CAP_MASK_ETS		= 1 << 2,
+};
+
 struct mlx5_ifc_tsar_element_bits {
 	u8         reserved_at_0[0x8];
 	u8         tsar_type[0x8];
-- 
2.43.0



