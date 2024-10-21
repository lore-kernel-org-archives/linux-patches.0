Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6E91E3DF9;
	Mon, 21 Oct 2024 10:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506861; cv=none; b=PXhFkjf115L1/l67uYiNGHiTah6eGN8dyHaD8pGGIMJNM2oH80N5HZ7EEjFjaa1VQEWxTTSHCZ7wRqc63CCfqKGrZ9VVkX2WbKfnp1Gvz1+AtgKV9IbLLsP0mV4bynk1oTJRuhwJp/bBhxoEg1MqI340DSa75erlYjmbWbZ1k8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506861; c=relaxed/simple;
	bh=Zr6on8Q07jwLdWk1Zl+8crUgIO52/1MG/WVwj5JoDjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGxtOztxqneNE0YrSIfGaFjrWfSlrqO/OFao5SifnnN5ll0ZzPKZERSVBdJzmlcxa2CPCE0in4RVpTrpi1eMKwoE8yOKey6HLIm3w9G5J+UK70LtDet/6EjD/KvGdUYVNPY9eGAbdWzi7CFnxr5bwD/F5IyPkNiNOnjhMgGkgac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1xj9JoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1xj9JoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588E5C4CEC3;
	Mon, 21 Oct 2024 10:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506860;
	bh=Zr6on8Q07jwLdWk1Zl+8crUgIO52/1MG/WVwj5JoDjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1xj9JoHm1VtxV3bcEvzROOmTk2lmf7loU+eS99YkAJtMM90vVhb4Ku1jTnHAJ73d
	 oRj1Y3NKXLoyS1Obp++jvSEucOI76Bf0THxNnbQddYUy44j52Jex0Myd9Ex6O/ifHv
	 ZvEQ8QAGjcJBZkeqgmSwrUM1m5Rr/pcqmUm7qQa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 010/124] net: enetc: add missing static descriptor and inline keyword
Date: Mon, 21 Oct 2024 12:23:34 +0200
Message-ID: <20241021102257.117503094@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 1d7b2ce43d2c22a21dadaf689cb36a69570346a6 upstream.

Fix the build warnings when CONFIG_FSL_ENETC_MDIO is not enabled.
The detailed warnings are shown as follows.

include/linux/fsl/enetc_mdio.h:62:18: warning: no previous prototype for function 'enetc_hw_alloc' [-Wmissing-prototypes]
      62 | struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
         |                  ^
include/linux/fsl/enetc_mdio.h:62:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      62 | struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
         | ^
         | static
8 warnings generated.

Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410102136.jQHZOcS4-lkp@intel.com/
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241011030103.392362-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fsl/enetc_mdio.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/fsl/enetc_mdio.h
+++ b/include/linux/fsl/enetc_mdio.h
@@ -59,7 +59,8 @@ static inline int enetc_mdio_read_c45(st
 static inline int enetc_mdio_write_c45(struct mii_bus *bus, int phy_id,
 				       int devad, int regnum, u16 value)
 { return -EINVAL; }
-struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
+static inline struct enetc_hw *enetc_hw_alloc(struct device *dev,
+					      void __iomem *port_regs)
 { return ERR_PTR(-EINVAL); }
 
 #endif


