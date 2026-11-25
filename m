Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619286;
	b=U+oCHd/188ClCx8hXWKW7KJk4y35LBf1G/5dEnEcRM4RbIKuOzYUA2CMSDaeM1Cf9dMv
	 qqJy7MQV5MznsAR9AZpHxm5EzKBWZfcNQAaKE22o6qwvsjDMfFypzsoXH/5QfAUd6KZ5v
	 +m1IMiEp722YSoBG8VmF8tBHy9bjR1xoKN8e9JmRVaLWXyIq6UbeqCMMj2sBALPFkiKSI
	 rRLrYkfF4JxGYaGXg2E9q9Qli3Kh+fPAbx7xmkz984Kc/As/WddXIAFaQKSpL/A+L5jlM
	 A9vkpopgguRZT5zMw4tylyBLzmswme68vD3TljwarqiGsy+yFeJ1jfIh9OYsVy8E4ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=62y+BofiiS/fXOnH8r2fIkrO9y8iYmpITg1webdztjI=;
	b=VTbQ+0OXD4LrE+/OKVdSuofF0RsEaPt4v38XPLusM7aaV9aGxFPsFolic1Sj+zIB9LWf
	 0vwJm2qDj1Gf+agIGZeE+fve773Gc4lM/QopCwbmF1HO1cEBIc9JnRGLZxAN8tRRfHViB
	 UYbTAIxBKsnCmUXZQ/92QAacpaXePmzu4C9Jp3Mi0xHBS2b8ofXIGQNx5yNQgEQfGd6iA
	 8QtI2Dd3HZLZZ/Nd9IR8KCLbn8qKjPzjfAOKhw3LNnxoZfFNponyGyzU+Q7ErNErbfGRn
	 bqnAXTE8E7GpieXtslA07CFuNFPT32uFoz5ACvCnVIA7QljdyUeNMfMHnxT2nJx0tJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU2FX9QM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097B4606A331;
	Wed, 25 Nov 2026 15:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OU2FX9QM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A9A1F000CF;
	Wed, 25 Nov 2026 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619285;
	bh=62y+BofiiS/fXOnH8r2fIkrO9y8iYmpITg1webdztjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OU2FX9QMXB3WSQ6opRIcuYxHviXaGakonQrNiSOBnaZVxzH9r+82evMXWkPcPCWng
	 +nKb/5HHE3zYEqt8daaNklD/dqQURT6jX26j2xFjsJJxHBmadrFb5R/xvH/GZaxc1r
	 4R3iK4PlkO3dGJ/+B2wcsUObkKHmOzI24VbPrX/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0546/1005] net/mlx5e: IPsec, dont match upper proto selectors in crypto offload TX
Date: Wed, 25 Nov 2026 15:31:24 +0100
Message-ID: <20261125143834.535725639@linuxfoundation.org>
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
index 55de9abbd72be..5c69e89b13a72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2194,7 +2194,6 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 
 	setup_fte_no_frags(spec);
-	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
 	switch (attrs->type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
@@ -2207,6 +2206,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
+		setup_fte_upper_proto_match(spec, &attrs->upspec);
 		setup_fte_reg_c4(spec, attrs->reqid);
 		err = setup_pkt_reformat(ipsec, attrs, &flow_act);
 		if (err)
-- 
2.53.0



