Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235672E405;
	Mon,  8 Apr 2024 13:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581568; cv=none; b=pA2mJeptEUk5Wxy+ggKILFlajkCQvRKJYlOUGvPIQZoolXdOBPe9PyzZ4heWP00utFTKoVVKJbyWCNDsPSEOolqpQGNuadGCMc+IhPtf2wcp6F93gjT5wVn40EwUzJF+b3ocpWZnVF2Xa2TyN63x+y0CcqF8XaXiOqx1al9dv2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581568; c=relaxed/simple;
	bh=rGZG94WZEBcKoNdROQxUvuEGYKRKWx0ajBFyo7BRgYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKtVn0dB1TaGfTZcLE3DSo940kn7S9IdA7m60dkpHdOhD6mC8/zU7u0+IitmVacIEQEjvFIX1myKkOnGWPtl5WO4lIQs8oS3ji9gzD1WCz3CDtQLaMz1aYfiN/ILxaL3x1hexL/on2Jaew4Gx0GJk5ZPbyMw0cHVol5JacqdQmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4ZY2sAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4ZY2sAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF82C433C7;
	Mon,  8 Apr 2024 13:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581568;
	bh=rGZG94WZEBcKoNdROQxUvuEGYKRKWx0ajBFyo7BRgYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4ZY2sAf+QLrASQCUqMO3uEh44XaBTM+e9p1bV+tObvpbyUK84kX3SJ0m2qH7HXMi
	 pq0N0W+fMzFOIGr05gOpmQKTRp5eZ62oWz5qhW1GQsPZO4Xzr2wjSrDxBGM/eUwkdj
	 ex98y19QTOD0QLStzm+XtLnQJ04B80gIjVM/7gDg=
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
Subject: [PATCH 6.6 019/252] igc: Remove stale comment about Tx timestamping
Date: Mon,  8 Apr 2024 14:55:18 +0200
Message-ID: <20240408125307.248150648@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index fc1de116d5548..e83700ad7e622 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1640,10 +1640,6 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 
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



