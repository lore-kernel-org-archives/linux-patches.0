Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619256;
	b=v68lIBO/TueGYzHo0yOYYWz93luVP2H/XQpjUQ0BvdE5JNnRDEHAJJ9mLigv7StU83hI
	 Ncf4G0s0LhJUr0jKgpZ+xIX1uS3kGgjSG8hb+l6ptuAHpjcM80CMn4JM/e5NfXzEzdG1Y
	 Klw/DM4IGjsgRm3NLR8PfRka6Ba5Igfyz3tsBEHHJQIhoO+Inc+5dwccBbaLLei2xfzEi
	 GsMGAosnHPKpq5scuqMLuZdljMxUHSLpwCA74d4/+62Pi5C6IeiotDs71zAXSEDDsXigM
	 tG5dEYQqcfz1tc+29RKDmqrFS7LguRTDbI0sdZcVdL/JugmKb3+j82auk6Wtqr85XkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jd8sjmY9P2R/gOm2u32wf/I5m/SiBAou4rIIkAPTKuo=;
	b=qfWHzj2X64X8Ohs8JwMOF2LqQwLuO18O/HkkKMJQPhrTi7j66tVu3aVwnnbZSKCmSAjt
	 0CdMlh4D7V41U8xAUGO3cBV1kiGbOIF6ELe2czAorzDt9wiU59rs+snBuuw1MBGYREnC0
	 LuOdAV3KdmuxF7Xa2JhBmnJhieEGGj6vS6G08xDQdrS2Arx7hsPIYVYzfS36PVcVitqml
	 cFug7tvKGchJd6LWITmu9d4F/RmOavlMlx4bLTc+VPZdOiREKm1niRXRm7AIb10xQyNvo
	 dtV6r9QLGEUmxzbRAdDWAROJX7FM+YPTcEqXmPykBdJZ5kC+NDh0HKX9dG2nOFppQeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C49jjuAv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF1D606A334;
	Wed, 25 Nov 2026 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C49jjuAv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34141F0093C;
	Wed, 25 Nov 2026 15:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619256;
	bh=jd8sjmY9P2R/gOm2u32wf/I5m/SiBAou4rIIkAPTKuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C49jjuAvtTT4kTwDHC/MKV68SyqawcF/TubBlfuHDXuwJO10Q4hzBHEV2UX0MKiyf
	 jYBAdClBOUx7LnU0Lv6kzSEwiOtXmlamqGsakMpYR37EEajsIPLaPBJcFuMr+xxoaL
	 yBfguMR5JyNaRVgGLZyMBE9j4l3Seu1Qn4Ls0sKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0538/1005] net/mlx5e: kTLS, Fix missing error unwind when enabling RX offload
Date: Wed, 25 Nov 2026 15:31:16 +0100
Message-ID: <20261125143834.348261177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 343672bad64153e895d201ff6d3dfaf15c22682e ]

Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
ICOSQ"), the async ICOSQ is only created when an XDP program is attached
or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
the channels so that they get the queue, but it ignores the return value
of mlx5e_safe_reopen_channels().

If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
enabled. The next offloaded RX connection then dereferences the NULL
c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
not help, as the flag is already set and the reopen is skipped.

Propagate the error, clear the flag and destroy the accel TCP flow
tables again, so that the feature stays disabled and the next attempt
retries the reopen.

Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261110101709.2589088-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 337201f128958..3cc1213c2f682 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -139,7 +139,11 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
 		err = mlx5e_accel_fs_tcp_create(priv->fs);
 		if (!err && !priv->ktls_rx_was_enabled) {
 			priv->ktls_rx_was_enabled = true;
-			mlx5e_safe_reopen_channels(priv);
+			err = mlx5e_safe_reopen_channels(priv);
+			if (err) {
+				priv->ktls_rx_was_enabled = false;
+				mlx5e_accel_fs_tcp_destroy(priv->fs);
+			}
 		}
 	} else {
 		mlx5e_accel_fs_tcp_destroy(priv->fs);
-- 
2.53.0



