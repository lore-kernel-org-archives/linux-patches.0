Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58F97BB15;
	Mon,  8 Apr 2024 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584949; cv=none; b=gdFvoXHSY5jcH5Jvj1O51BDej3znejdH1zusyXod+aOdN9LP5lGS+sTmUJpTSIcc67iOvpPKFpEWqYwZUFfese4Bgn19Bu7f1F9NW8aUmhklPdFK1/BHJdVAJtYKpT/7G8+mOCW5poZIKC5Yp4Qbr24js6fGJ5OH1fbQxRua7Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584949; c=relaxed/simple;
	bh=0YNlyc7uImAcmRwPMn3nmWBxD1TSYCCcDOEt+quYOug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOhwFjBsks8yZMbQm4pNA+y9KY65EnxSXRyVBPSrPmIYUpBSVONkjmRZXR0GU7Kh9rVwqlMz4CdV2AKo1RvLrbykKqoeaJMWW9y1nJnFsH4lhvM0a2I3kt6i8t/eCgefP8sr31etrEaXw2By9pxzStIUtNYevxVhcemUuw1sF70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwrMrWUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwrMrWUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE40C433F1;
	Mon,  8 Apr 2024 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584949;
	bh=0YNlyc7uImAcmRwPMn3nmWBxD1TSYCCcDOEt+quYOug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwrMrWUmR84y4mP2c3+OQCop3CZDazV43rl+09Irn5LqhyDegC/A1+/lGESFOhpMz
	 ureZNfHUracm3x+f/Pm6PybjzBr7X4sUS4FE5EhFhHrawpMXyOw6GEytEFGR1xJUsF
	 hB8kYD8CE+GfcZoszLNG169bsTPsTN4Q1tVbJOHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 610/690] mlxbf_gige: stop PHY during open() error paths
Date: Mon,  8 Apr 2024 14:57:56 +0200
Message-ID: <20240408125421.698268986@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit d6c30c5a168f8586b8bcc0d8e42e2456eb05209b ]

The mlxbf_gige_open() routine starts the PHY as part of normal
initialization.  The mlxbf_gige_open() routine must stop the
PHY during its error paths.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 679415a64f25c..621594061fb57 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -159,7 +159,7 @@ static int mlxbf_gige_open(struct net_device *netdev)
 
 	err = mlxbf_gige_tx_init(priv);
 	if (err)
-		goto free_irqs;
+		goto phy_deinit;
 	err = mlxbf_gige_rx_init(priv);
 	if (err)
 		goto tx_deinit;
@@ -187,6 +187,9 @@ static int mlxbf_gige_open(struct net_device *netdev)
 tx_deinit:
 	mlxbf_gige_tx_deinit(priv);
 
+phy_deinit:
+	phy_stop(phydev);
+
 free_irqs:
 	mlxbf_gige_free_irqs(priv);
 	return err;
-- 
2.43.0



