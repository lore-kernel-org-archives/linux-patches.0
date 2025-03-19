Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64521A4F0A;
	Wed, 19 Mar 2025 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394861; cv=none; b=DHCSpKkEO6MrUo9++xSnZ3TzkbjBiH0N3UUlmVfO2iLJnb1ov2dLWMokHl341zEq95zC4wJHeUsKULLSjBsCwnasIdbxsqz5qhCfoYmidhidwhj169SfgRWYAC+2dVW72oBp3fzxn1KmftNiRFi//YxvdMSVIrjMTf3yL+DeWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394861; c=relaxed/simple;
	bh=te5j0XcmqjtLnZXDVERfnuY3E3PKzYBc34mZknE8RLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCdo8nKRXupwLF3HcNFoxRAiTGdgLcHyTfQ/qrMkaw5CN5fz14ehs9/QENR0SgwZ2VWJjKn3DotJRBC4ukzyz7tLBIMtAzZ7/ekDiLWOO4d91TRccgJ3xSuTTGyDfe2otyY+50qB6pjnLdU8lb6jiElZEUzv1Iyhhb90ZwlPGVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpuatNoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpuatNoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72074C4CEE9;
	Wed, 19 Mar 2025 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394861;
	bh=te5j0XcmqjtLnZXDVERfnuY3E3PKzYBc34mZknE8RLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpuatNoeMKRv/mFs0eQ59QWEDnizyXnArYhKPwyvdOOeKMayy4+mtliU2k3Us0++v
	 qcWVVY+vNcxViAVEl0a76XylgSu7K4JGMtxXT4EHz/sZ/H7IVhf/X2fdrDnyO+6G9P
	 vhWN4mkmjiYzA2XajCXxeGTsFmxn57W8ZmGwT4t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 051/241] net/mlx5: HWS, Rightsize bwc matcher priority
Date: Wed, 19 Mar 2025 07:28:41 -0700
Message-ID: <20250319143028.990670651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit 521992337f67f71ce4436b98bc32563ddb1a5ce3 ]

The bwc layer was clamping the matcher priority from 32 bits to 16 bits.
This didn't show up until a matcher was resized, since the initial
native matcher was created using the correct 32 bit value.

The fix also reorders fields to avoid some padding.

Fixes: 2111bb970c78 ("net/mlx5: HWS, added backward-compatible API handling")
Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1741644104-97767-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h
index 655fa7a22d84f..7c00740f1d130 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.h
@@ -16,8 +16,8 @@ struct mlx5hws_bwc_matcher {
 	struct mlx5hws_matcher *matcher;
 	struct mlx5hws_match_template *mt;
 	struct mlx5hws_action_template *at[MLX5HWS_BWC_MATCHER_ATTACH_AT_NUM];
+	u32 priority;
 	u8 num_of_at;
-	u16 priority;
 	u8 size_log;
 	atomic_t num_of_rules;
 	struct list_head *rules;
-- 
2.39.5



