Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF131EBFFD;
	Mon, 21 Oct 2024 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507789; cv=none; b=at6McaSnF6aPqm9d8V4qjDTonuBlfR0QV8fmYWbSaN3/ZgT6DzCwbQ0pv1YAOyfQgT9azp9VjJ+aH7Hqk+9Kh6nw0woHejCmR/0qU22mclcdNYh1UP17fyBWS0hIzejcy7jZvylJyQh+kkfbXWNX1k7J1wYwyVH1lRSqvZ1StDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507789; c=relaxed/simple;
	bh=zTO4buLTtD3E5uRN9jQnl3lN07Za5zkQD0TuX2bDcOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGMmzcTQcXaatRpNxWSsd2lYNn+tv75+WsBN2bksqmaFFevBcDXdBHAaxN70EpNJBAicIZnu3ePN5vSjApHbm3lYGHS1ag+6+wvmeqyrVHCfdz8/fuuZBLamyohIImILDox9f2ouaGPp9XQQ5HnZuzUXPsjSOU/4u8/W1vBw4+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1N4FMkbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1N4FMkbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41336C4CEC3;
	Mon, 21 Oct 2024 10:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507789;
	bh=zTO4buLTtD3E5uRN9jQnl3lN07Za5zkQD0TuX2bDcOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1N4FMkbB9qtq0pdNdznotLLM8kXNVOjaGcsuvwf5qXNBMv9Bh00YPBwgLRLeiwmrn
	 oGzgiDbbPSU1IlYQVUQC8s2J/iqAmMH1R9D/02G1/yGvJ01nZJwgqp+COEyCSMOjkh
	 a8bFJcYCUSfUSNKwQ0o9mquUQ2X+aS4O41hhix60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 02/52] net: enetc: add missing static descriptor and inline keyword
Date: Mon, 21 Oct 2024 12:25:23 +0200
Message-ID: <20241021102241.721902328@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


