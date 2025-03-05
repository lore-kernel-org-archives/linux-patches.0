Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB281A316B;
	Wed,  5 Mar 2025 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198541; cv=none; b=P/aOa9rphJHU6HHrduDQVuOmPwlBe5hzBlh4oIn0MaX1nvej2ItZI9Oza7JS8BaxD8hNtSA/0F73oo7SpRgh+Fg1HPVxHuhJ+LN5b9bEgoF5sWdgaxpmfWi+tdg4o+ZP0G2cHlD9b8AWXyGeUl7ZQrGhPNLfaIwoy/d2jQFGqHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198541; c=relaxed/simple;
	bh=88GVaGMZPQQJisEieuAR5oseC1MPgb6wVxW9pvP1F/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e10i2b+4zOG8XRY/m1NQ4KgtCG1gnaWf1ls84vSvi+ST8h783XUmOxfnKjqhKhcS5xVmbQ3w5ZJ4QgdLriBPP+qXtUEh+qlEFWf8xDrPH9MuI5nZxsRrYoauACZat1rz1TQneSkKcXi54qZr/NVjsKUTB/0QG31HzAQD/RtIqho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoJ61RkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoJ61RkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FB5C4CED1;
	Wed,  5 Mar 2025 18:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198541;
	bh=88GVaGMZPQQJisEieuAR5oseC1MPgb6wVxW9pvP1F/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoJ61RkZi9AeEhPnnWrMeX6Fblm+7Du5mg4riM/O/jKR85JzUUR1RbD6Hh8ybDE67
	 Oelc74MpDlpF9T+QQ4wLdvthh5e4c1H55iF3hf+HJ4NXdmxt1DzwqvDTydKVq1AUFw
	 NVaXAbnm2Zft1rn/Ij+ThlcH2xqdCSrEi2Q1e3N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 056/157] net/mlx5: Restore missing trace event when enabling vport QoS
Date: Wed,  5 Mar 2025 18:48:12 +0100
Message-ID: <20250305174507.556849372@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 47bcd9bf3d231bfd4698d7d3013597490fd5e2d6 ]

Restore the `trace_mlx5_esw_vport_qos_create` event when creating
the vport scheduling element. This trace event was lost during
refactoring.

Fixes: be034baba83e ("net/mlx5: Make vport QoS enablement more flexible for future extensions")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250225072608.526866-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 07a28073a49ea..823c1ba456cd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -564,6 +564,9 @@ static int esw_qos_vport_enable(struct mlx5_vport *vport, struct mlx5_esw_sched_
 		return err;
 
 	esw_qos_normalize_min_rate(parent->esw, parent, extack);
+	trace_mlx5_esw_vport_qos_create(vport->dev, vport,
+					vport->qos.sched_node->max_rate,
+					vport->qos.sched_node->bw_share);
 
 	return 0;
 }
-- 
2.39.5



