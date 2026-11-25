Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624945;
	b=LIos2hLIcODRG0/Giyrzvi3cnuu1lvOLwF76TCGv4dowyLCHDknp821KAtGnSfLVFRKG
	 GhEH6uVtlcmnd/ZniyMJVvhCcAbxloUAWL/5H+CSH9YrA2RNcYKdjb5MZdn9XhKCBSvVq
	 3kN3mwc0P+SRWFoyjr0xAQsPZdUEG/zO/MI6pI7Hmjo+dbEzHzIZpTCVd6VSDPBMSa+7Y
	 GAYK+re9B88CoyL18H36fmHu74wNeFqqI9vGidsTBrYUu0Atxc0Re92kI6p6Qujo/5HGc
	 498J6e7Q5+nPH7+Lf2IAfm4ty7j1TMmIlzfbT4fIj0UFBbMN3GT5WC8JfASs8ZWgj0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A95+xe+HLCt6Alkasq7A0p47wVG7vyU/sGR4Yn9R820=;
	b=K6IWPEwb6odtkxiFYQGsT1GTDe/DvCrFuioJ6LeOzRVO+CdQ287b/iBw+dF5ZeHq96Kw
	 kbfkIKqZ9FH8ac7zof0uF6dHko3X6FEbdFVgpN0mGpOCcd6OUSJRe8pvNLEtC+k4YloqD
	 eQyCIuzdf8nexJfL0Sy1fAoByCComIfTN2C9EhroVEumZEm1mKGPZ4xA15qzSF6ZoLTpL
	 Vf3HqLpaddUJQpiaWJoLQwcBTx6YxwfB3l1vGkVLUYv/a4sGYtAT3Vi18hrEa43c43PDx
	 Nnpv2jvP7CfNyB1eFdjhQuDXZdEsSna79CoAm/H0FKI5bs7Rp8g6W+o2f1pJbpt5dQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTuwxXXR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DFF606A337;
	Wed, 25 Nov 2026 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTuwxXXR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF861F000D2;
	Wed, 25 Nov 2026 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624945;
	bh=A95+xe+HLCt6Alkasq7A0p47wVG7vyU/sGR4Yn9R820=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTuwxXXRf8wmC4UfKdLBy3egkWfD3H1nAPGy6gX5TEEpEk7/vkRMcg2MbP4RL8lIt
	 MYEJQhtBehCVPfdjyhLwr68HTo6FJTa4fy9ptB0I0MANbS9ddSul9q+t8LQcJZi9wa
	 kPnF2/zZ4ASuKQhRZNAlKcFg2AKcQkuKSdB9qBS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/816] net/mlx5e: IPsec, dont match upper proto selectors in crypto offload TX
Date: Wed, 25 Nov 2026 15:31:43 +0100
Message-ID: <20261125143857.416819796@linuxfoundation.org>
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
index e21c4f3c52967..573895aa9b240 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1739,7 +1739,6 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 
 	setup_fte_no_frags(spec);
-	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
 	switch (attrs->type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
@@ -1752,6 +1751,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
+		setup_fte_upper_proto_match(spec, &attrs->upspec);
 		setup_fte_reg_c4(spec, attrs->reqid);
 		err = setup_pkt_reformat(ipsec, attrs, &flow_act);
 		if (err)
-- 
2.53.0



