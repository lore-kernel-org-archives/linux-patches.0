Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C1B12DD85;
	Mon,  8 Apr 2024 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583038; cv=none; b=bbyE9usDlW9/9qVCeHzssLqlNmo/5b5iF8HqQx9VSIbSFVZ49pDLWWk45qtu15VFrWpsFWNt7WhM1jJ2selHCzj/NE6LNDVBSuDCtubCpfe377AP1MzwlWUob8r+AnWQ5i5RmpPb9L6ZtS7ukIykCqYHHreI7NO2Bxa03h187aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583038; c=relaxed/simple;
	bh=sqe1EP9C83MFnujduD8c1Bg2ABtu1IkHmzMG/O+rbAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0vr4+vYnFRuKGUqZVBHJNkf3tC69U5FTdQYDVazLVXocWYeNdG+A6/mHTqnFxveDq1bWPIV8aRo/6bPgwy2LozHRqwGGGb2F6TQFOi2Y3+tJ1h/AQZY9OAFo1aXphCBB4Vi5u1r0xzalcDGLcOI26oWhUeNjn7JLVHyoJTAZLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZRMtQrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZRMtQrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E00FC433C7;
	Mon,  8 Apr 2024 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583038;
	bh=sqe1EP9C83MFnujduD8c1Bg2ABtu1IkHmzMG/O+rbAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZRMtQrDMDxAZSGUC2QyPo+qmQgWlqauDrTFzkq0xwkJdrPLaS/eNbsakhmrJ2Jnc
	 8punm5zjBRoBa9KGbDv/DqD/0W2gxdnUj8q5wu8ABUwgdimCDXwKbO3iYjkeidpmc0
	 eNJZbXeL4sT4YIdeDv2CGo3mA7PYAFraPnI+em68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 133/273] e1000e: Minor flow correction in e1000_shutdown function
Date: Mon,  8 Apr 2024 14:56:48 +0200
Message-ID: <20240408125313.426810750@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 662200e324daebe6859c1f0f3ea1538b0561425a ]

Add curly braces to avoid entering to an if statement where it is not
always required in e1000_shutdown function.
This improves code readability and might prevent non-deterministic
behaviour in the future.

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240301184806.2634508-5-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 861e8086029e ("e1000e: move force SMBUS from enable ulp function to avoid PHY loss issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index af5d9d97a0d6c..cc8c531ec3dff 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6688,14 +6688,14 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 	if (adapter->hw.phy.type == e1000_phy_igp_3) {
 		e1000e_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 	} else if (hw->mac.type >= e1000_pch_lpt) {
-		if (wufc && !(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
+		if (wufc && !(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC))) {
 			/* ULP does not support wake from unicast, multicast
 			 * or broadcast.
 			 */
 			retval = e1000_enable_ulp_lpt_lp(hw, !runtime);
-
-		if (retval)
-			return retval;
+			if (retval)
+				return retval;
+		}
 	}
 
 	/* Ensure that the appropriate bits are set in LPI_CTRL
-- 
2.43.0



