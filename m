Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548CE1F76D0;
	Mon, 21 Oct 2024 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507379; cv=none; b=RcUen5ZS/o16mA0n9WoNtVQul9+G7r/xyvyUJVdcAWa61i0dGvWB49SwfjFD1KXRJU8iBKkisPPrU87ZW6EuBlwuka67JSpkt/xnoVrWkoLbLA2q/MeSMx9cfpjMCNP+BFLloNTs66TLyyzzdfxV6Ok0Hs4O5OvRBbJMsolBNbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507379; c=relaxed/simple;
	bh=p2L/RJAcczu6SRVRkud4QeaSvh5mzxO/s+npFoA3VHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlI0NALTFNpVHmL5M4nbJczKbNPd3LkBgVioDQISBANWJq/pAlYmLNXvqwiYLxAtAX5MQ4pXWhmBnF3bDPJpzZBnyHvjvfX1OVOXxQSAjXW4g6NFo9hIQt3iYr+/vhkT/NjZSHi0Fpvtmnb1jXCclHCntARGEnAj8qR6LTuVS8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ep9ckNw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ep9ckNw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8091C4CEC3;
	Mon, 21 Oct 2024 10:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507379;
	bh=p2L/RJAcczu6SRVRkud4QeaSvh5mzxO/s+npFoA3VHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ep9ckNw2s+cKjzihEOasSPD5s3+phrummPbOe4PwLYgeoC6+2y1CvnCHJnLR9JZ1A
	 Y0wSrsOCKViOMya2TsHP0d06VOukRg+SaeGs2PMgOCd/9xcTLIuzlav78QDyGEuB6z
	 uB3ps8wm4lHOssra9UfmhMy5l0rPOqGt60rcNb3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 26/91] net: enetc: add missing static descriptor and inline keyword
Date: Mon, 21 Oct 2024 12:24:40 +0200
Message-ID: <20241021102250.846094217@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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
@@ -48,7 +48,8 @@ static inline int enetc_mdio_read(struct
 static inline int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum,
 				   u16 value)
 { return -EINVAL; }
-struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
+static inline struct enetc_hw *enetc_hw_alloc(struct device *dev,
+					      void __iomem *port_regs)
 { return ERR_PTR(-EINVAL); }
 
 #endif


