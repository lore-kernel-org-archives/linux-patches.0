Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC472E62C;
	Mon,  8 Apr 2024 13:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581761; cv=none; b=efRUmaRf5sb+G1VPTZMcsHMXECifSEMr5MclnEA4qFxUX5ATi/DqE30tgAPU/SfiN2kxHLP/lqdECk1ue2Azkj89pGaF8L5yFAxFBkAxUhS/BvuqDF2Pmh0WGTjKRSszlFneRHYtoWzEkAXkKRwk7W0FPc0ymalkJQNyez4pSa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581761; c=relaxed/simple;
	bh=5p81a0RUe+aR/okxS3ytbXPfd8fTgBhlK7dYGhv1bEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpcadPtsopy3zqhvhIm33Edd1osj6VyxDAH3dgoNBLIs8g0qqQ1p1/+gXp2/1MBojf9i2YMkq52cXVltG8jNMIFmpJj3OSaraCIwXgaxq1PK18QjItoKwobDPlXBq1HBxg2VG0NDesZaEipjpZUnXE4dj311xXd2bCAdXN4nbQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1PCPNxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1PCPNxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EE6C433F1;
	Mon,  8 Apr 2024 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581761;
	bh=5p81a0RUe+aR/okxS3ytbXPfd8fTgBhlK7dYGhv1bEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1PCPNxIVoCkJEk3J+dm3dnijCce7O8aU9EecaOiEwoeC8MgnSnvuu/XSAdq/FUvv
	 Iu6R5vnVmMGQv6vge2L4XQtZH6V4oZeLiwoOvDDF/zDONXng+3Fi9W+kY7RKLaYDra
	 eU64BsEqTuc6UgRQhZ0nNXIr2y+z/FSiQahBLmr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 018/273] igc: Remove stale comment about Tx timestamping
Date: Mon,  8 Apr 2024 14:54:53 +0200
Message-ID: <20240408125309.861911519@linuxfoundation.org>
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

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 47ce2956c7a61ff354723e28235205fa2012265b ]

The initial igc Tx timestamping implementation used only one register for
retrieving Tx timestamps. Commit 3ed247e78911 ("igc: Add support for
multiple in-flight TX timestamps") added support for utilizing all four of
them e.g., for multiple domain support. Remove the stale comment/FIXME.

Fixes: 3ed247e78911 ("igc: Add support for multiple in-flight TX timestamps")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e447ba0370568..23bed58a9d825 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1642,10 +1642,6 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 
 	if (unlikely(test_bit(IGC_RING_FLAG_TX_HWTSTAMP, &tx_ring->flags) &&
 		     skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
-		/* FIXME: add support for retrieving timestamps from
-		 * the other timer registers before skipping the
-		 * timestamping request.
-		 */
 		unsigned long flags;
 		u32 tstamp_flags;
 
-- 
2.43.0



