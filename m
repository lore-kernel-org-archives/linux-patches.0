Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4DF14AD19;
	Mon, 16 Sep 2024 12:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488128; cv=none; b=nitCG8CRriE2pmaCXFYljXcOGx5Ufd7S3471/F0jr3ix3pOrY9ceJRetB22nzZaBsCsBvOMniY2HP14I8bzR+EDQ2VyujiiDAgFgf5Jc6/Ggkm7v2G81kMpiQsbnvGVua4no2lHuIjTRRtszHNOrARhXLZhYPQ+EcV9aDBjF9Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488128; c=relaxed/simple;
	bh=I8z2L4wYtkFAijtNX7/MuXA1B+UOTJK38SOi3/Urw2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRNuRgzicKp/osH7nek9J8jLfX0evfdjLx5LdkAE25TzPIoVQ0qVZH9SScSSuZilSpy6iasfJS9HKeIvrEVHpAiAnXwgrkrEbhwmjgP32Lh8dKn38rr2mGAtNlo2Ko7JgTTntZHEFPYZQrXfrXTPAc7TxdKrTPp1cKaI9Df4DBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3fOsAv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3fOsAv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763B8C4CEC4;
	Mon, 16 Sep 2024 12:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488127;
	bh=I8z2L4wYtkFAijtNX7/MuXA1B+UOTJK38SOi3/Urw2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3fOsAv958fu6j8BfnVI+YrjZQmJ5dpkp6y5H/peqQAWKKY5qCxd+UhdufentNc38
	 I8JgRx1NQV6Qw31zF87wc/9JL9hFZIIlY4WGEOqJ5u6mcuzmO10UOC7boJ7NpDtsaJ
	 sNpqU3VW56P32s9/hO6Jz2ZgcybtVlS9U+0CXuL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/63] net/mlx5: Add missing masks and QoS bit masks for scheduling elements
Date: Mon, 16 Sep 2024 13:44:22 +0200
Message-ID: <20240916114222.581780673@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2aee17a34d7..64434a3b7e1a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -973,7 +973,8 @@ struct mlx5_ifc_qos_cap_bits {
 
 	u8         max_tsar_bw_share[0x20];
 
-	u8         reserved_at_100[0x20];
+	u8         nic_element_type[0x10];
+	u8         nic_tsar_type[0x10];
 
 	u8         reserved_at_120[0x3];
 	u8         log_meter_aso_granularity[0x5];
@@ -3746,6 +3747,7 @@ enum {
 	ELEMENT_TYPE_CAP_MASK_VPORT		= 1 << 1,
 	ELEMENT_TYPE_CAP_MASK_VPORT_TC		= 1 << 2,
 	ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC	= 1 << 3,
+	ELEMENT_TYPE_CAP_MASK_QUEUE_GROUP	= 1 << 4,
 };
 
 struct mlx5_ifc_scheduling_context_bits {
@@ -4444,6 +4446,12 @@ enum {
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



