Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622211;
	b=jluN5Yqapr2eWnPVSDdCjXcIEQY59GUlLpwQ30ky/t1tchOdQUjM/w8RoPvRM5Xb5HKk
	 q2kiHrDmTLlnAI7GuL5v7WgqQ7xLox/5SE0po1tjn1KBi+AxhorKIuidHd/PWUpFUUrRL
	 wtMK7IDV1zn3n27uMPqS4vO9hBSOK0FhMqt7UGleZYWRA6XYZGvWk15rDVLnIHIxDjtYJ
	 g1mbDB+3vi1pl9/lw8IEWkh1ksQwFw0VCJJqL8dgalzyQkP6+9WTFFg1cUfjkgH7pTUL0
	 pNmFHP0DvphTGzLRInOCkZs9LUbOp4UO4d/q1zbZ7HdHnC5TFDC/VQvKVrXF7b67/GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wFv+x2QxdMyikyGqtLLcpHv0Ic8da36LiOiHDBpuCBk=;
	b=WUfJBm6j19jwuRhL274Y0rSftTu6Oh3MPVEdbU0e/vlawa4/VAGiHzbPa2K6NGqY9ysj
	 PIsmUjtEII+S1CXwB0/os84l4mM2R1BVIPG092OQVR3gDgYuULomc2ZXYcOHwl89dmQho
	 aOdAqz0Z083abzIF+V4ig7Kas3XXrsdGpN6FDujCCgTtIzwV6IP3Z7XNgLFdfaYz/ycNf
	 HBl0sNqFxqP4CDuybUEEo7hRLanJbA0NfxJgVxtIV/MiWm+C2IpxmsXmFNJ/+2IJOo6/H
	 NdZUfnBgKJge85h/5U1OipdlWPNXDPkBbuFhcxZf/SyGcj9jH1pBqXGzN7Zbr+JnTKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkOq9GtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB73D606A31E;
	Wed, 25 Nov 2026 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkOq9GtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7381F000C4;
	Wed, 25 Nov 2026 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622211;
	bh=wFv+x2QxdMyikyGqtLLcpHv0Ic8da36LiOiHDBpuCBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkOq9GtAM/Bl5B2sJUImbayH5TlfXWJWkV1V/dTm7zkSaUwtzU1HB7TXBrrKQ0wNy
	 ycGAVQDIh5qFApOG9vMPE9TNY5E3kaPbg90LDKp7PdTBksNSX+sEji1HZ9xXcf+Zb5
	 Jv8Cnkj4DgnLepoFv92FlJiRBukIs/4125KQCOIU=
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
Subject: [PATCH 6.18 466/990] net/mlx5: Lag, Return error when enabling MPESW without LAG support
Date: Wed, 25 Nov 2026 15:30:33 +0100
Message-ID: <20261125143833.013918076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 567e51f0e5dad..6dd97cc372ff8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -172,7 +172,7 @@ static int mlx5_lag_mpesw_queue_work(struct mlx5_core_dev *dev,
 	int err = 0;
 
 	if (!ldev)
-		return 0;
+		return -EOPNOTSUPP;
 
 	work = kzalloc(sizeof(*work), GFP_KERNEL);
 	if (!work)
-- 
2.53.0



