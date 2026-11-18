Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027739;
	b=gVyaX1+KN71XTLLTxgegN6zAvGT5ZXeDLh8it8mQSSqJhsQYyI+YLXh/4DOPfRtl1Y/7
	 sdfxTzozxa98o7OuNCTYZf8XCdFP3ie160s9UhEgg+OAbVIxiBnBBjtRINwKyEyHGFPbb
	 XMWkbNseE8zeUAHDmhOf6EDS8n63Khfh+DvFQYQsSeK+B9j5WgwX9NYAujg6d1jqjiabW
	 40pjAtSE4pX5GCxHCFz+DamXb8nxmQX2eHbQSOiOGoLPSewzMkPjryFKjP+ruSbCR/u4G
	 9+VyRjeBgNgck/aBMu3K9orK7Nro+wWctqxgF0D03eAoqvZ5BKSE2yhIrHLbeFY2Ipw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=roorL8QSchoeuLk2uM3E5Z4zUQp2wPd3io/WR4WpTe4=;
	b=am8SawziGFbGHPxo7J+YgiQF/s20Fsq91v88w3Q5XlJVy2BfPWpvllebGBhkX4FjbTIs
	 CGqM8FwCT/BBJ/scbB29RuwLH65+k+cbn7ThrDXNaz5ig4Fv0rQUAm+9GwMcJ0FIDwwPL
	 C7fuIWI2rszuYb79BHl1xe+MxTRd9GuaLWzxber4XO5WErQVIrDv99/rNT3kJKglA2ZHS
	 Nbdl7sO2PNTmVm+yvz/ZIiG6rbprsxG1EBypQjgQYWPqXWREYASJsdKKq84dio484wGRm
	 W3oopXJEhvqgRGtIcQeB5/IhvjYfjxGmdFRcepv+MechampKoXHIibAW8X6tHUtCvhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UKwuM5/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4433C606A32F;
	Wed, 18 Nov 2026 18:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKwuM5/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA2D1F000C6;
	Wed, 18 Nov 2026 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027739;
	bh=roorL8QSchoeuLk2uM3E5Z4zUQp2wPd3io/WR4WpTe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKwuM5/ak7+7Kc1xvM6fszsHhEgxThx4lTnAwZs1wSQJxLOzClDFZTr+5Qs45PAx6
	 ePp2AqNHdIlcMuSGvWuBMSA52ZxitbxAnyVw2Ir8csIsEH1BLb7chNRpyn1BNrrRQw
	 kI8LgewnssjwseN+Ddh7XtSSiQQFAO0aAumMkDG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1895/2151] net/mlx5e: Stop asserting for RTNL when closing channels
Date: Wed, 18 Nov 2026 16:00:30 +0100
Message-ID: <20261118150230.824472397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit e0a958ddfc89f2e1c43448cdaeb5b30e54e19448 ]

mlx5e_close_channels() has an ASSERT_RTNL() from the time when RTNL was
required for closing channels.
But the driver has been switched to using the netdev lock a while back,
and this fired from a flow which was forgotten during the conversion:

mlx5e_tx_timeout_work()
  -> mlx5e_reporter_tx_timeout()
  -> mlx5e_health_report()
  -> mlx5e_tx_reporter_timeout_recover()
  -> mlx5e_safe_reopen_channels()
  -> mlx5e_safe_switch_params()
  -> mlx5e_close_channels()

The RTNL is not acquired here, but the netdev lock is, and it is enough.

Rather than switching to netdev_assert_locked(), simply drop the assert.
Upper layers (networking core, ethtool core) provide locking and lower
layers (NAPI helpers) assert that the netdev lock is held.

Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20261020153659.3440902-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fa87f36f0b887..3bbb19712a586 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2997,7 +2997,6 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	ASSERT_RTNL();
 	if (chs->ptp) {
 		mlx5e_ptp_close(chs->ptp);
 		chs->ptp = NULL;
-- 
2.53.0



