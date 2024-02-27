Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1807613DBBF;
	Tue, 27 Feb 2024 13:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041515; cv=none; b=UCekCw6i7Q+LxSVET2JNz+wVZBQO5ORKVKP0EMRDKe1APw1G+UbeYflD2uOErFAjSE7gXjqCr0NPzSLa1HwdFJI84d/7CEosHirveCvIPQh0KXEHZ+5uobB4pVL0xxxIwupexQGx13vK6gphdQZFLkRz9sLJCFUn2x4bsuITj8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041515; c=relaxed/simple;
	bh=68HHk01czVH7Q2kVBI9fiOPP5ZlUlZljCnFVbhPNnkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8tMYT/sMonWrUkUVQ4wjMItfohdrYT4ZEn/R2p/JyR9VPzpA3mT1zSqut8EuXVoBzabgFaXKBFoVf0vIVsjjmwThhhfykRc2qHzFm67jR7Z3xbARqx0vajllM8ht/HYZn3YdPhQQlF6rXSu99hWxY7BoZ38fjumI6ryLQfkYgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+1tz0v1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+1tz0v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921A5C433C7;
	Tue, 27 Feb 2024 13:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041514;
	bh=68HHk01czVH7Q2kVBI9fiOPP5ZlUlZljCnFVbhPNnkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+1tz0v1w2bF5Fo1sqnCbupRWrHw/afDEDc9jjNJeYWqJeF6kJUZQZp0+oTs2+fkE
	 mK+d/sp2jTSKxDy/z12dXA/ssOg+MlzjiWlqihDK2E+qpsxBo2a4FOsc/5cljikdVE
	 210ZWsujMMgrjqDLG2am/gFdUtAcX5tFQvPekGck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 4.19 04/52] stmmac: no need to check return value of debugfs_create functions
Date: Tue, 27 Feb 2024 14:25:51 +0100
Message-ID: <20240227131548.667291630@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8d72ab119f42f25abb393093472ae0ca275088b6 upstream.

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Because we don't care about the individual files, we can remove the
stored dentry for the files, as they are not needed to be kept track of
at all.

Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Stable-dep-of: 474a31e13a4e ("net: stmmac: fix notifier registration")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   52 +++-------------------
 2 files changed, 8 insertions(+), 46 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -188,8 +188,6 @@ struct stmmac_priv {
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dbgfs_dir;
-	struct dentry *dbgfs_rings_status;
-	struct dentry *dbgfs_dma_cap;
 #endif
 
 	unsigned long state;
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -115,7 +115,7 @@ static irqreturn_t stmmac_interrupt(int
 
 #ifdef CONFIG_DEBUG_FS
 static const struct net_device_ops stmmac_netdev_ops;
-static int stmmac_init_fs(struct net_device *dev);
+static void stmmac_init_fs(struct net_device *dev);
 static void stmmac_exit_fs(struct net_device *dev);
 #endif
 
@@ -4063,47 +4063,22 @@ static struct notifier_block stmmac_noti
 	.notifier_call = stmmac_device_event,
 };
 
-static int stmmac_init_fs(struct net_device *dev)
+static void stmmac_init_fs(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	/* Create per netdev entries */
 	priv->dbgfs_dir = debugfs_create_dir(dev->name, stmmac_fs_dir);
 
-	if (!priv->dbgfs_dir || IS_ERR(priv->dbgfs_dir)) {
-		netdev_err(priv->dev, "ERROR failed to create debugfs directory\n");
-
-		return -ENOMEM;
-	}
-
 	/* Entry to report DMA RX/TX rings */
-	priv->dbgfs_rings_status =
-		debugfs_create_file("descriptors_status", 0444,
-				    priv->dbgfs_dir, dev,
-				    &stmmac_rings_status_fops);
-
-	if (!priv->dbgfs_rings_status || IS_ERR(priv->dbgfs_rings_status)) {
-		netdev_err(priv->dev, "ERROR creating stmmac ring debugfs file\n");
-		debugfs_remove_recursive(priv->dbgfs_dir);
-
-		return -ENOMEM;
-	}
+	debugfs_create_file("descriptors_status", 0444, priv->dbgfs_dir, dev,
+			    &stmmac_rings_status_fops);
 
 	/* Entry to report the DMA HW features */
-	priv->dbgfs_dma_cap = debugfs_create_file("dma_cap", 0444,
-						  priv->dbgfs_dir,
-						  dev, &stmmac_dma_cap_fops);
-
-	if (!priv->dbgfs_dma_cap || IS_ERR(priv->dbgfs_dma_cap)) {
-		netdev_err(priv->dev, "ERROR creating stmmac MMC debugfs file\n");
-		debugfs_remove_recursive(priv->dbgfs_dir);
-
-		return -ENOMEM;
-	}
+	debugfs_create_file("dma_cap", 0444, priv->dbgfs_dir, dev,
+			    &stmmac_dma_cap_fops);
 
 	register_netdevice_notifier(&stmmac_notifier);
-
-	return 0;
 }
 
 static void stmmac_exit_fs(struct net_device *dev)
@@ -4442,10 +4417,7 @@ int stmmac_dvr_probe(struct device *devi
 	}
 
 #ifdef CONFIG_DEBUG_FS
-	ret = stmmac_init_fs(ndev);
-	if (ret < 0)
-		netdev_warn(priv->dev, "%s: failed debugFS registration\n",
-			    __func__);
+	stmmac_init_fs(ndev);
 #endif
 
 	return ret;
@@ -4705,16 +4677,8 @@ static int __init stmmac_init(void)
 {
 #ifdef CONFIG_DEBUG_FS
 	/* Create debugfs main directory if it doesn't exist yet */
-	if (!stmmac_fs_dir) {
+	if (!stmmac_fs_dir)
 		stmmac_fs_dir = debugfs_create_dir(STMMAC_RESOURCE_NAME, NULL);
-
-		if (!stmmac_fs_dir || IS_ERR(stmmac_fs_dir)) {
-			pr_err("ERROR %s, debugfs create directory failed\n",
-			       STMMAC_RESOURCE_NAME);
-
-			return -ENOMEM;
-		}
-	}
 #endif
 
 	return 0;


