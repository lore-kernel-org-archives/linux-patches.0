Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619145;
	b=eMYjkiekhJ1jDEUMsvxDBmqMAgVl63q7yjXg3FvVNGF9ZBtUfgKvJKCyzySJtMcIs3jM
	 fOdTCndRprph/otJSIamAjPMItC8ycPfF/dQ0h+PjW6CNhLiexPp4rW5uwnvXPjekUWdo
	 Gk/b8gq0kwMwQtePYfVskCXnbU+V9dvNwsQZ4MZ6wLjLlm5FCntrjU4c9Xx43QbsgbmAU
	 D3od05CP/n23Cya2soO/M48tMZjJDRftCeSlJ68VISFYU7RW3qd6uqsD0R3x/aHu5mWDT
	 QywtBYxAqfoWxbCYAw9ygousZJHn/23jPxRq/tZzyDJ76VfTzUxOzZ922cBGcPeC44Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ib2rN8GeYSTbFD/lNVhiInFWl61mdtqX/DQ3EKReoco=;
	b=oHJQb1KFsSnK81ykELKLLHqKgNprEVibvTCr8XmvgZbhziDKE4DB3kxWe+XIKie3jY3+
	 PehS+45NWFtTBnzlaadQ9zlIIzfbfKK7ePi5KTpuHaQTgVAvPdVDRo+aFKQRYGaFgB4vR
	 TQKdXLBALOfQxlc1lsOGys+IH/+iaqhS65a5boDt0W8HrnSTCtoqc8VEZrpj71sR9WQi7
	 heY9GHDN30Ul4HWaR8D9SvtNNoVW3+A+7CrJO9LhpIvB+c6V16NQUv1bCmzMC9piybIc4
	 Vz33g71tAqN83913SDiMFw3cjJzDFznDRtFDkk+N3eTMqgmJT5Fgx3dsJUqu/YQ+85g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KdZt+MIw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641AE606A321;
	Wed, 25 Nov 2026 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KdZt+MIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AB41F000C0;
	Wed, 25 Nov 2026 15:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619145;
	bh=Ib2rN8GeYSTbFD/lNVhiInFWl61mdtqX/DQ3EKReoco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdZt+MIwRi4/vYsllM18MUcyH1z2PM2CHZaD2pYjGzjmv+ULtgb5vn4YKh5I67aCt
	 WfN2lxhMDbxrLQRiqmsDXWsFMmftuUF1pIr/uOA+QfYLcvk8m1H2O6gTTZO9+tlMfv
	 0B5mrgXsutOk+QSJrIFO9Bzsrl0SbCNnKr7zO++A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0460/1005] net/mlx5: Lag, free steering resources on LAG destroy failure
Date: Wed, 25 Nov 2026 15:29:58 +0100
Message-ID: <20261125143832.521935335@linuxfoundation.org>
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

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit deceb70d1303105e4368a19b251a6fd94428eb11 ]

When firmware fails to destroy LAG, driver returns before releasing the
steering resources, leaking the associated software objects.

The bond is no longer eligible for offload, and the driver cannot
prevent its teardown. Release the steering resources even if LAG
destruction fails. Preserve the error logging and return the original
error after cleanup.

Fixes: da6b0bb0fc73 ("net/mlx5: Lag, use steering to select the affinity port in LAG")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261104183947.772195-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4e173b08cb37a..a8ba1c2086063 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1096,7 +1096,6 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 				      "Failed to deactivate VF LAG; driver restart required\n"
 				      "Make sure all VFs are unbound prior to VF LAG activation or deactivation\n");
 		}
-		return err;
 	}
 
 	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
@@ -1106,7 +1105,7 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	if (mlx5_lag_has_drop_rule(ldev))
 		mlx5_lag_drop_rule_cleanup(ldev);
 
-	return 0;
+	return err;
 }
 
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
-- 
2.53.0



