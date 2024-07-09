Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F143A158860;
	Tue,  9 Jul 2024 11:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523728; cv=none; b=lG3Nu1znYdYyeoL55BfqxrAtg9mNbM5sFaMvcJ55EhvhxLU54MpVhPPjz0qRHxZutI24pI5DEdJRjpIfXLTyL1wlVvmErqCs8i9D5/cXQuTCTxFmZABN+/qQ1j/0Iia89XQsLPwTC9FoC72eJUs8Qo8/YCGiWhWbVgAbpwTnG08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523728; c=relaxed/simple;
	bh=4CKS7SlLxFWlPDpq15NcdgOQmufDmqPz3AgApn6ZSs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DY1FVUF5P2La3i2rVzcWq66s6Bup3lFU3auJM5G4IfneutbhLVvj6yGuoEhwd6tSZC+4VUPYcAKymU6FWXACdiOFT4R1vXIrDwPwyHWbTz3II8V0C7v59atMGTSc4Wa22yeHu3n784P0Coz1QBjdjPD1lZIZZhbvLRqQ7ZNg91A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwXDSTCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwXDSTCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED9CC3277B;
	Tue,  9 Jul 2024 11:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523727;
	bh=4CKS7SlLxFWlPDpq15NcdgOQmufDmqPz3AgApn6ZSs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwXDSTCYncGiuBQp17TBK9CBlpNall88YRPWE20E/wMyCrpTdP7OW+pTEYYmMIJbT
	 LI4sEsPFjL6e7Es9o0TExR6VJbvfJ3pFNiTkk8Fk/oOgiUowrFRwuis6HzefTOjEnY
	 XukQGAukei5Yxxx0Hbiih24Tb5ZIE7x6U+0beKqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 089/139] Revert "igc: fix a log entry using uninitialized netdev"
Date: Tue,  9 Jul 2024 13:09:49 +0200
Message-ID: <20240709110701.622083903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Sasha Neftin <sasha.neftin@intel.com>

commit 8eef5c3cea65f248c99cd9dcb3f84c6509b78162 upstream.

This reverts commit 86167183a17e03ec77198897975e9fdfbd53cb0b.

igc_ptp_init() needs to be called before igc_reset(), otherwise kernel
crash could be observed. Following the corresponding discussion [1] and
[2] revert this commit.

Link: https://lore.kernel.org/all/8fb634f8-7330-4cf4-a8ce-485af9c0a61a@intel.com/ [1]
Link: https://lore.kernel.org/all/87o78rmkhu.fsf@intel.com/ [2]
Fixes: 86167183a17e ("igc: fix a log entry using uninitialized netdev")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240611162456.961631-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6908,6 +6908,8 @@ static int igc_probe(struct pci_dev *pde
 	device_set_wakeup_enable(&adapter->pdev->dev,
 				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
 
+	igc_ptp_init(adapter);
+
 	igc_tsn_clear_schedule(adapter);
 
 	/* reset the hardware with the new settings */
@@ -6929,9 +6931,6 @@ static int igc_probe(struct pci_dev *pde
 	/* Check if Media Autosense is enabled */
 	adapter->ei = *ei;
 
-	/* do hw tstamp init after resetting */
-	igc_ptp_init(adapter);
-
 	/* print pcie link status and MAC address */
 	pcie_print_link_status(pdev);
 	netdev_info(netdev, "MAC: %pM\n", netdev->dev_addr);


