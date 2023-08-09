Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECB215AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C448AC433C8;
	Wed,  9 Aug 2023 10:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578049;
	bh=k5GvgFSBRFg9FOfphDpohELqQvflHGlywHSB04rntLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZcrMS1bkbt+kC5NA7fIeRgHhuexQS2J6Z5Cs3giiOyfZStpprqssTAadnL1aYVDs
	 b7I1gvDwppjL8kQUoy/gkllob+60FH+KUVhzBSVWGNxNePh8p+mHX6ZW2xyaLGCg9r
	 w7sxg340GLt1jrRHUcDGQv0M5qAL6gw8oHP578oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 087/165] net/mlx5e: Set proper IPsec source port in L4 selector
Date: Wed,  9 Aug 2023 12:40:18 +0200
Message-ID: <20230809103645.655725901@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 62da08331f1a2bef9d0148613133ce8e640a2f8d ]

Fix typo in setup_fte_upper_proto_match() where destination UDP port
was used instead of source port.

Fixes: a7385187a386 ("net/mlx5e: IPsec, support upper protocol selector field offload")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/ffc024a4d192113103f392b0502688366ca88c1f.1690803944.git.leonro@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index dbe87bf89c0dd..832d36be4a17b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -808,9 +808,9 @@ static void setup_fte_upper_proto_match(struct mlx5_flow_spec *spec, struct upsp
 	}
 
 	if (upspec->sport) {
-		MLX5_SET(fte_match_set_lyr_2_4, spec->match_criteria, udp_dport,
+		MLX5_SET(fte_match_set_lyr_2_4, spec->match_criteria, udp_sport,
 			 upspec->sport_mask);
-		MLX5_SET(fte_match_set_lyr_2_4, spec->match_value, udp_dport, upspec->sport);
+		MLX5_SET(fte_match_set_lyr_2_4, spec->match_value, udp_sport, upspec->sport);
 	}
 }
 
-- 
2.40.1



