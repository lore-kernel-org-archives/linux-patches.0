Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F872374CC;
	Wed,  7 Aug 2024 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043753; cv=none; b=SZY47OuXmkqKNTWWQ/+H3al8i8fc65H0IR/NmM4VIfO0UnARaT8dvdgE+XSJKfA5+5OM0/tLjwSAMp813IBsLWN7R89y+LT0YuNho5knDsgkR2b6QMdjDVT/bTj1ww/c+/8zj708WaHnwqA3cUgYyqUJ5kh6FugnrJuJ3GOVm6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043753; c=relaxed/simple;
	bh=/zDMgqT515O7LnOR/PwwYt8sB0gX3yq0EjXFUIaUOWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah4fSgP15J0NX6pzyxbR/VWWzgUHrFyGqMg0aPN6npBzanTtU0lY02nbNGgrvcCmiwG7wIJHEDzD4drzijQEWVBTuRFvZXy575xu1IO7x27E3AnFnhPi/ovpY28jf7wpOE3V3JEFLYLzjjFQRiN3tTWjRAIU3TK5LCMx3rMQn8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+dN+NyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+dN+NyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00298C32781;
	Wed,  7 Aug 2024 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043753;
	bh=/zDMgqT515O7LnOR/PwwYt8sB0gX3yq0EjXFUIaUOWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+dN+NyNug1qU/EqdSpZFJnq9cAdm1Qq0aSEJEPBpxmX6K6j659JXxfvuN3pv1QLu
	 f5MztOHLDeOb+pzlksU8gWlfaB99eAueiaYsdSFy+JBQ/dxt014DFDJlSswsmm1wsf
	 GDaWpPEve8klvx9sv2NXObRkBrm2mVhfGydFiQ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 60/86] net/mlx5: Lag, dont use the hardcoded value of the first port
Date: Wed,  7 Aug 2024 17:00:39 +0200
Message-ID: <20240807150041.228789385@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 3fda84dc090390573cfbd0b1d70372663315de21 ]

The cited commit didn't change the body of the loop as it should.
It shouldn't be using MLX5_LAG_P1.

Fixes: 7e978e7714d6 ("net/mlx5: Lag, use actual number of lag ports")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index a283d8ae466b6..4b4d761081115 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1483,7 +1483,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 		goto unlock;
 
 	for (i = 0; i < ldev->ports; i++) {
-		if (ldev->pf[MLX5_LAG_P1].netdev == slave) {
+		if (ldev->pf[i].netdev == slave) {
 			port = i;
 			break;
 		}
-- 
2.43.0



