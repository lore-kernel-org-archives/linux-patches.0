Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622240;
	b=XDc7cI62F1TttwTXS15Vv1KiEe2EjG3WS+SYLYfE+AI2a08gyNUqwdvx7QVZQ8QMbcty
	 cXaLLvBoi8wiH+jzRh6+GIlW6blEYPkF4AfbfPqZY18NmcnJyTT3NV5kos8U4IOzQVk/X
	 pr+waaxLjjGuBTNvsI7/7FYk9Apb4JdlmKeA8mCPD+jPs/x9kq0o25I/2UPwZggA6Ien/
	 zNCQv6A0DoVo1d5s/S9CTuaftry5PK1DQQK8R884bESOKMoGAQ+SdllddH5SQKxZMNagM
	 rpGIZWNXaV8vR3ywR8De9wzyRzsDCuWY+E90fD98dpA89Txb9yx2KKFBn6OYDN6nz5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I3e0RWBm0PgmKp5LuCgiXkiFcS9Tu0ilXAk51hfWA4g=;
	b=qu5cLZ880P72P5ZcK+SJlADoyXcr2rVKFpZcZGI+NG0Zh8Uft20/xEAyZzAWFORS+vXn
	 e5ph+/4EzMXnVDzWkmvSlUl3bj7uH3MGOJRqGjhQBBkNw1C4omUzyB4+m+TG019xvC8Nw
	 JIeqTMD9H28Ehh5YyZ5IgGa/VhuO4rn6eZNlDML0DJED5Wh7Sa7Ynu0pXzoV6eON9LqNA
	 GmoqfoDlhnUUKUz7/Yay8ne/heh25NGsNaCOXYC1UG52cPNLLYJ+RpN/OFeNcRzkRsTNR
	 XtowtLcPT311StUMby0wIwHrIWKrT+MgsgIfM5lVSATytc07+ze+dB/7L69xjZPhkgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ePKybZ7T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E664606A323;
	Wed, 25 Nov 2026 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ePKybZ7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AD51F000CF;
	Wed, 25 Nov 2026 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622239;
	bh=I3e0RWBm0PgmKp5LuCgiXkiFcS9Tu0ilXAk51hfWA4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePKybZ7TzCQIMTRbjpClc1n5W4oI4DMr9Du2xbSWriZEY3wwBvowSEzrvFGf9/G09
	 uIBf13masc14HQFyPDXcIkL0xUPhbMKq4RTkTFXlJUWTcpDVRQLxk8Y/HIP5bPMp4/
	 BG8s9fJkhiKi2hDhHAVRJbDV/IwusuYTzN9RAGz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/990] net/mlx5e: IPsec, dont match upper proto selectors in crypto offload TX
Date: Wed, 25 Nov 2026 15:30:41 +0100
Message-ID: <20261125143833.198945653@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 5ed47bd79cebee8429d06c6640aac7ac7c4805ca ]

The mentioned commit introduced support for upper protocol selectors
(protocol & ports) to mlx5 IPsec offload. In crypto offload mode this
causes offloaded TX SAs to stop matching traffic.

In tx_add_rule(), setup_fte_upper_proto_match() is called for all
offload types and programs a match on the upper protocol (TCP/UDP) and
ports. For crypto offload, setup_fte_esp() is then called and sets
ip_protocol to ESP. The resulting rule requires both ESP as the IP
protocol and TCP/UDP ports, which no packet can satisfy, so TX crypto
offload silently stops working for such SAs.

In crypto offload mode the stack builds the ESP packet and the HW only
encrypts it, so the SA rule should only match on the SPI. Move the
setup_fte_upper_proto_match() call under the XFRM_DEV_OFFLOAD_PACKET
case, where the rule matches the plaintext packet and upper protocol
selectors apply.

The other three callers are unaffected: rx_add_rule_sa_selector() is
already only invoked for packet offload, and tx_add_policy() /
rx_add_policy() are only reachable in packet offload mode, since xfrm
policy offload is exclusively of type XFRM_DEV_OFFLOAD_PACKET.

Fixes: a7385187a386 ("net/mlx5e: IPsec, support upper protocol selector field offload")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261111081337.3129580-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 5c5b33b01bebf..1046627d4080b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2187,7 +2187,6 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 
 	setup_fte_no_frags(spec);
-	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
 	switch (attrs->type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
@@ -2200,6 +2199,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
+		setup_fte_upper_proto_match(spec, &attrs->upspec);
 		setup_fte_reg_c4(spec, attrs->reqid);
 		err = setup_pkt_reformat(ipsec, attrs, &flow_act);
 		if (err)
-- 
2.53.0



