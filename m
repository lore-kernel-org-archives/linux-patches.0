Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23643E025C;
	Mon, 17 Aug 2026 14:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975645; cv=none; b=NIjDQl+YYYL3ynTfZuhze+NMR5S4oUE8o33dUSMAjlO+G2dnfrEvsRqklGyHvdirUikANPc9M04ispptWhjccBfUQGu8GOL+FVic3CkXuv4VFz3RH8zG3hryvzjE2Z/34HN1m2BvjHqNrswvh+uy8t5lXjA/WDRnV6lKGAkDI4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975645; c=relaxed/simple;
	bh=O2HL2Zbm17mfOY1zJVnA0kppigOqaWyhF6pwycaZIS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdzrrgRzDEP2BI9WqEn+2UNZ2eCZJgCh3kRQxO0wdJBR/rqiqsS6lkbpixbEnb96fnuPHa/z1iEN674rkKpu71nJX4EQw3KVzV5VTOZ++mKZMVMURAj+1QLyYgPxahNypVKi18dS1JXV427KV6d298FRtkQAlTXZUgUQC0Qr3SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShUBxEs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShUBxEs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFFA1F000E9;
	Mon, 17 Aug 2026 14:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975644;
	bh=s988kbS0YhDTS765nik26s3P3Wh/gIyUxlauhJv0pVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShUBxEs1XDlefOm0HmYwjcsWE1uUq/5VIUgr8nZiV4aRWfWjzIxFjI7jADYXueyz+
	 hYRX+5GXbJ6rcPpKWdGJF/zIjOY949MTbKsxG9+3KH/F4uGn3j5nOgx+b6qOymBkxT
	 EYF673+8vl1+9BvB/gunl9+lsu65YVKmt0Mqz6lk=
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
Subject: [PATCH 5.10 098/389] net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation
Date: Mon, 17 Aug 2026 15:28:57 +0200
Message-ID: <20260817132542.944662836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c1d1c21f41b4b1..6ea50a9ef1be56 100644
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



