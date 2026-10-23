Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773875;
	b=gbdpDBCJp1HwpDAoziLgBZRMnWj5BukqZBqOgz8yrERSVf5nEK8KfkzHvYbi5PAqHgIB
	 kOWbuzPTdHVWNNSxgktBId/r9rshHNcG1d+nWWuR6NAWKsskmVOuEF7gLs7YPIjw26Ojt
	 HFCECMAAh/09+tMkvfh3HhhkoZit6F5S7qjVuDoUygpCgVk8NzuX4kOX5h8G6QlOo27Eu
	 TKv4DF7qr18wE94buXQxy7jJTR58e4v0dPaKq06D9DBMWQNdL7Lu9eiOYJ6LWJRPI6xBM
	 OF01s+eE7mdKPTL8J/thqIJZel1cw+GPxostmJ8FLDQVyL/0kXbQ7zXepiG2HIk46ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ls3GMEjz/1C1XRtA3jP9tosNRIGd/DodGTqWMQ0HW/s=;
	b=xqHxVTjLmTo7/mFC2lgeMmnxdPpjnuO70v40JEk5fGnEsQ/p5RX0jt/7ejz2pgzXhS/5
	 Q1DcqFaLgUlb6lLSlwy5Olswe/oNYxlb91OZEtHq6xBKLN51qFOiKGLPJey50M7iE6FWe
	 SHbDQSdI1jlkR8+u6f5jFHy7ex3etacXk7cA/Fc3s4xbYvWrqnn8Q9vPKvkn9T04Z42dh
	 tr1O73x8W2TUj++MF2ucz92Oml/5iTQzu2nZI7GE+Ssv4ayUQVoOQ/6gz+moVsg6N7Qv9
	 ZIOSoPObxMfPRWKIlgP6n24G1wXta8GlTeR/pVHxz8dIdkwiJoI0YD9L31rxcE3tGiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+VavKtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A933606A31A;
	Fri, 23 Oct 2026 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+VavKtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E42B1F01828;
	Fri, 23 Oct 2026 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773874;
	bh=ls3GMEjz/1C1XRtA3jP9tosNRIGd/DodGTqWMQ0HW/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+VavKtAfsQNqPtNeWM+f5VOWx36JexAklgY+05jJGxYfvQ7ZFEVzECCn9fimdKCY
	 dkjjG6E2gF7I1lHlmHoxodaTs1icIOiNmxE0QKApG8+lFvE8Je5Kerh+qG3XUCzChB
	 0H+3rrqXo534gEck6cr3zDKZhlf9e/LWh1xM2IBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/193] net/mlx5: HWS, fix flow meter offset within its bulk
Date: Fri, 23 Oct 2026 18:35:21 +0200
Message-ID: <20261023163715.247626047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9e8dd5241ff4b..5745ba84c3a0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -931,6 +931,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 			goto free_actions;
 		}
 		(*ractions)[num_actions].aso_meter.offset =
+			(fte_action->exe_aso.object_id - fte_action->exe_aso.base_id) * 2 +
 			fte_action->exe_aso.flow_meter.meter_idx;
 		(*ractions)[num_actions].aso_meter.init_color =
 			fte_action->exe_aso.flow_meter.init_color;
-- 
2.53.0



