Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FCD1E7658;
	Tue, 15 Oct 2024 11:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992310; cv=none; b=s6oesOn4PVILeNm9blKdqbMMXNyL5s6TLExmYF2KMlPGD1VYfBJ8VtPfhgrBIr9SiY7OZud3n/1KDTdMYojYib2DV3NVGhxRo35YU5YMLIZBnSb0WvWHeKpfLR/1msG9ueL8zOQPumt4w9EfuNoY5/pcbvNmLUmB5muacELJryg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992310; c=relaxed/simple;
	bh=968K5PVCQnnfvFKAPXCZFvR3LYfOvhekT4aVQlQhhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fftszNtqc98BloHf08zTcgiDI6zkA+aw95GWDwJuOXmrTgfyrUwYWTizmo0B42UXt6+HuY/Oqtdt76hhekBlR1bTLiR1r9GuslsnBGSHh1BfeYM2XylbiaVq6CwgQfP4jwOnVfAiQ5Le6jJvA/WAJhgE8E93CVwrJC+Eb/RTIEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLHncwSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLHncwSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BDDC4CEC6;
	Tue, 15 Oct 2024 11:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992310;
	bh=968K5PVCQnnfvFKAPXCZFvR3LYfOvhekT4aVQlQhhM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLHncwSl5jnwYUTYCd7b4OtIWcP2SjbllMeYomDobd0zWGVaD8c02+7yuRkEu0DHu
	 L9BGHU+v5YURWNpl5vec4/OGafS96Pwk0Ksixn6/I37MjoJK9lcbp4+QW+6692Pz1C
	 Ct7xaXP45E+nKMjfXEJAs7lMXQ8Ifl/ynOmYJxXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/691] net/mlx5: Add missing masks and QoS bit masks for scheduling elements
Date: Tue, 15 Oct 2024 13:19:56 +0200
Message-ID: <20241015112442.252348543@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e42d6d2d8ecb..d974c235ad8e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -891,7 +891,8 @@ struct mlx5_ifc_qos_cap_bits {
 
 	u8         max_tsar_bw_share[0x20];
 
-	u8         reserved_at_100[0x20];
+	u8         nic_element_type[0x10];
+	u8         nic_tsar_type[0x10];
 
 	u8         reserved_at_120[0x3];
 	u8         log_meter_aso_granularity[0x5];
@@ -3521,6 +3522,7 @@ enum {
 	ELEMENT_TYPE_CAP_MASK_VPORT		= 1 << 1,
 	ELEMENT_TYPE_CAP_MASK_VPORT_TC		= 1 << 2,
 	ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC	= 1 << 3,
+	ELEMENT_TYPE_CAP_MASK_QUEUE_GROUP	= 1 << 4,
 };
 
 struct mlx5_ifc_scheduling_context_bits {
@@ -4187,6 +4189,12 @@ enum {
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



