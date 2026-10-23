Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774449;
	b=gpJEhb+vIwTdlYHBMAnKkpa2Gl+u4XI8AsHMH8ThtIIKB1V45x9izInWfaOYDOI6zKxA
	 tffYyaxxIUNiY5BX9IS4r5FN8HbWB+yEcnT/+Z81Xq5Z6TiI1GUS7lQ8B5Gs6gBGziCiC
	 tw5LgSIcyVOMaZ6ZuSkxXXJwdB9P4EyLxp1a2KEdsF8pYrHrlahTcmLS67ERQCkQRT1g3
	 llquenXintWCo3s390n6gHzWr9e30YGYdAg9PFfsghd75M7begDyHDQoKBhARaEOCPAHj
	 pDMS9dQeiuEYHQx9zG0QLnOXAJsaDrCIs9yoC/s3FDrCXA9E3qwTAx1nwGjThSC2SrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iY38FqGYRYhNKUPmxMUastU45BhcnIJWMIEO8H138VM=;
	b=opWMgb+jFgN6OzQkJyYpbPslEueQhHKu+8InnzPYbKq/TS+3wsBEpiDILNXb9LGYtDm6
	 JS9Eeo2SvZ+FQwgdokO+PUgS/1OeogAuFJNuGbVS2y21v70Ym0I2ZHXe3ExGQIqp3MrLH
	 9CYyoWDA7KQwFqcg702vBECI78/K27w6cA+Htp31B+zXSuZukF5KTZPHxqZVhki/GXv/8
	 vrPGxoob4VNMk1ESFHlgab8gIRA0sgTpWG2XyWmSAouN/sX5vBjmz5O4U7i2IYNpiPWlZ
	 BGydnxLtFKQZrQI0DG+bAGu/HAkKl8cYzUrmJzPM7PIY0eeZRmbiOmNAG0/Rlc3DQZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XnwLkzmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AA2606A31A;
	Fri, 23 Oct 2026 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XnwLkzmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A911F01825;
	Fri, 23 Oct 2026 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774449;
	bh=iY38FqGYRYhNKUPmxMUastU45BhcnIJWMIEO8H138VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XnwLkzmYX4WJySHQeQH3AGLMXa4ChtxeuzJJDXeGbo9JvpoiSln/ijTb6W+pUtzth
	 8jEgoROob6YTQp6SBDzAjV76NluYVp91QnOhqqFxW0dRpzfIWODB+zFAXZCNGPgWxz
	 qmMh7ctALYth5nxalmT6eablPvK9A59hFag/966U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 043/242] net/mlx5: HWS, fix flow meter offset within its bulk
Date: Fri, 23 Oct 2026 18:38:05 +0200
Message-ID: <20261023163714.796509707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Cassen <acassen@corp.free.fr>

[ Upstream commit 1b0aad53ad715b15ccbad8c65d15c149c925f00a ]

The flow meter action is bound to the first ASO object of the bulk but
the rule offset only indexes the meter within its own object. A rule
past the first object runs on the wrong meter.

Fixes: 82d3639ef7dc ("net/mlx5: fs, add support for flow meters HWS action")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261007143830.1733583-3-acassen@corp.free.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 44b311b4532d1..54761754e6577 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -928,6 +928,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 			goto free_actions;
 		}
 		(*ractions)[num_actions].aso_meter.offset =
+			(fte_action->exe_aso.object_id - fte_action->exe_aso.base_id) * 2 +
 			fte_action->exe_aso.flow_meter.meter_idx;
 		(*ractions)[num_actions].aso_meter.init_color =
 			fte_action->exe_aso.flow_meter.init_color;
-- 
2.53.0



