Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B423AB9D;
	Mon, 17 Aug 2026 15:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979261; cv=none; b=VGkNf8VtytLMht54r19fT0q0Umkx/UehFyndAcGuU64jzsvrjyvcnaUfjEbK3NbJFPO7R955A1mJR9hTPYwinh53atpsTmitCHnYtuGyekgnmch+JEAH+G68TXqjo4E+UryJv2oTTqSowxGnnkYyS5xsnaOCBq0OakZ9PkPmvIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979261; c=relaxed/simple;
	bh=l0szuyyGf3FQTXM+HHkHR4KJwJiIIhoglLu9rCSK3Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1YUN4z4VsAPFn1f80cAvPU6QGKlHl1LYJAWbe+feBcALiZFJBTi71KxW58CEwlgPs/7101DsSyOP2rXFjsFhfnrfK3neSEVMRlrhyTlPl0ymk90CyrcwUxN/fOjcUYViShGKtNG7TT2gfFttkX34I2K46XTviShROLm8+KHGr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cz2AzJtu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cz2AzJtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF461F000E9;
	Mon, 17 Aug 2026 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979260;
	bh=sQ/MLcRgmte/xWF2V1hvJ8i2vzVQBka7/g2rD6aJcYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cz2AzJtuUNf4dhvRCLmdnXHFuHXGYOeFcGhofOHEca6SujXPd4oLOfXeC96tAHBHP
	 5HP26996j4q63OHn6k913As0A6rVTYWp7djaCjL4NWfBWGHfZqI4n5IR6PnJUDInh1
	 3THa/Nnaz6exlX2Ttdv75AfGkt58weRaaFIZ11mc=
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
Subject: [PATCH 6.1 165/609] net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation
Date: Mon, 17 Aug 2026 15:27:41 +0200
Message-ID: <20260817132549.538753971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



