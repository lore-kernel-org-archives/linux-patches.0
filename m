Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A8338E8D0;
	Thu, 30 Jul 2026 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427526; cv=none; b=oPiLu2Jf7+7lC0W8uEwAy0z5kZh7S7NAl+bpLr2OY1rdo80Zgr9HNwxNyGGhV41aaYsh2Z0ISdv70JMlzMZnC8XJzaElrsrcZ5hT8d+/kdqr4oPLU0s06BLdmT9O9x6NwuAHSZXIDZdMHVky9YEuS7DeAzqLOQ3WhVwYaGO0rlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427526; c=relaxed/simple;
	bh=wCEagj0cLbk+gQvTFiPnoySiTs0R4xJLtEmOm1j1ZoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFyv16YVxYDydYR4z9wCzYLHkPBsysBe+Qb9Ie11T7F2XQJqpcDjwpt4JWmKrR/XuripWTBBs3IKwegZ4TpnHphfO0Aa327Myv6NDgErFSNtbpsRltlRlgl1cdU8WGNj+SCAgRvtPSCll2fjegEa7RMZ6inIGS5ckXIjbBzvlis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwQe/jvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwQe/jvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA86C1F00A3A;
	Thu, 30 Jul 2026 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427525;
	bh=ziKeBdhNSu6gOdPWLjYdaaVcy3f2FULxHobED+yFsbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwQe/jvKITCl4Kc1Ts7FPXnDU/RGCJ846Fr1Vajs//XYg2Fwrc5Mb5Runs7A5iYtC
	 0fRQ8jdLIqbzWqlqRfj476x0ireMm1bqcGWbigDDPx0Rw+bT2+lkSmB2ELHR9C24qF
	 1PfpVAK7M3N0wIi17Vbe/VLX5cV/0LZqsIgICRHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/484] net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation
Date: Thu, 30 Jul 2026 16:11:38 +0200
Message-ID: <20260730141427.833541811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit 9173e1d3c7c7d49a71eee813091f9e834ec7cee5 ]

Credit Based (CB) TSA is not supported by the mlx5 driver, so reject
any configurations that specify it.

Fixes: 08fb1dacdd76 ("net/mlx5e: Support DCBNL IEEE ETS")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260717075125.1244877-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 0bc3ae071e8324..1a73fa436a1368 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -309,6 +309,14 @@ static int mlx5e_dbcnl_validate_ets(struct net_device *netdev,
 		}
 	}
 
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_CB_SHAPER) {
+			netdev_err(netdev,
+				   "Failed to validate ETS: CB Shaper is not supported\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	/* Validate Bandwidth Sum */
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_ETS) {
-- 
2.53.0



