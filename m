Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624933;
	b=2LM9lmj0dili6j/+w0muiE31MRbfyJmT9sXvaeBZ443l6rgnJ5qXwL1BgFaKxP82Kvr9
	 3UusxRdu4QyC51WQe3IVa0JxjpuYHXL215gMc1oq6Z/+Nivojyt1lO16d8L1DIRP1o6HK
	 H3slyt+6PNv547cUenrKV/wVQ/iqjydylhs170CDGC1MaAoJIP0JjAEzZSXI1EcD3+lkc
	 PV8BF8inMLM58s6PIJpnNZF6xaYYWAE9R8CikRCYgLGw5H4WX2pMjj9CR3brC9p357qiu
	 DXNYw/LisUkpjnXbzz/LHeBqp7f4unl149YAYjxiRSJS9CtWlJyU7lzJFkMfFmdqG/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/MTdPjT6koU8a9jltikgy1r/kJj/+WFuy3bDoZ4jNPU=;
	b=i/3i0X0xJHI+KoFkGlH6UhWodS+JV7JU3fMpq36sDIcLOxfIV3qnYcyB7bKA+cFnNEm0
	 mw321PlFn7BoSvlF75vTLzf2zoVCZUAOZ9OZelKEcrE9jZqjiuEGvy1jW0a0hwfG/QKDc
	 xiiQzfPB1K3ergJ0nySluwGzXuwg6xnZQ95EIsf5QnI/X9PKMI2lKWJjpOPdf2zQ8znUl
	 7K++7adi5RGb4+JWXhn8k7zEAYnv/WYaIN4RGMBpwd0/IzU1rPOKi5VLO15FgplhgWwGC
	 gdWjmDTZibFMNsI8Mn6o9aYARgyYgS871s9IQbGa4xurgpRPbd2dzjMiC7fsvoBnQAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MgGEBliK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0E7606A321;
	Wed, 25 Nov 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MgGEBliK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B581E1F000CA;
	Wed, 25 Nov 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624932;
	bh=/MTdPjT6koU8a9jltikgy1r/kJj/+WFuy3bDoZ4jNPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgGEBliKEjpTGFDOnLZmSEkx/K99KBeDYenmUuQATNgX5ZjqVWEkuMaRMLXOoq8GS
	 C/9UAj0/QN1ObgDCexgOJ/iGSoKajc2EK7hgWXjfG+7l5UFmIzZkWj6MBJ1VuuVm0y
	 JZnYj7qEdLak7gRFY+pzSLRFoJbQP/I68gDVmQu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uri Dar <udar@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/816] net/mlx5: Lag, Return error when enabling MPESW without LAG support
Date: Wed, 25 Nov 2026 15:31:39 +0100
Message-ID: <20261125143857.322876544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uri Dar <udar@nvidia.com>

[ Upstream commit a532a7049ba23edeb2e16f7bb5929314f2e47ca0 ]

When firmware reports a function as not LAG capable (lag_master=0 or
num_lag_ports < 2), mlx5_lag_add_mdev() creates no LAG object for it.
Enabling multiport E-Switch on such a device returns 0 from
mlx5_lag_mpesw_queue_work(), so
"devlink dev param set ... esw_multiport value true" reports success
although nothing was enabled, and a following "devlink dev param show"
still reports false.

Return -EOPNOTSUPP instead. mlx5_lag_mpesw_disable() ignores the return
value, so disabling keeps its current behavior.

Fixes: a32327a3a02c ("net/mlx5: Lag, Control MultiPort E-Switch single FDB mode")
Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261110114350.2639891-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index b0a60d2433e50..36009fb4ea5fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -165,7 +165,7 @@ static int mlx5_lag_mpesw_queue_work(struct mlx5_core_dev *dev,
 	int err = 0;
 
 	if (!ldev)
-		return 0;
+		return -EOPNOTSUPP;
 
 	work = kzalloc(sizeof(*work), GFP_KERNEL);
 	if (!work)
-- 
2.53.0



