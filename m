Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380CE55E4C;
	Tue,  9 Jul 2024 11:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524671; cv=none; b=NrVuNWk+yzmpV100u4QiPkEWX+EgxguthwFCVak8CEjAbjDZK9m1O/0fIjRAxh/JqXboyVb1PTwS5NhG++dHMbWJecnb4QWQNpERgsokLvi/KfuJWOcpXheJysMtt4zNADdRemKEZMtx9hpdEJAHeDGNck4AtlGpk2Un6dVC8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524671; c=relaxed/simple;
	bh=EPkPRQQSgBxJfJ/lWNKd8bUcMnqd5Sc9Pw874H76MFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYpDJw0wX0ZruYKdlTOVfzYvozKJRnum8a0FWQBJymLGhjBT57m0LdpmXsD7dLENoSWnfagGROvJ0FRVcQ/9VAKP6rZ98nIVehOyRkhiYr596aV5ynHTOiCUkoQjFWFiRT6tSyhxhQsiUCnpZloyPKrz6XgbI7gFTWgi4KTfsRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwlxGHTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwlxGHTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B07C3277B;
	Tue,  9 Jul 2024 11:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524671;
	bh=EPkPRQQSgBxJfJ/lWNKd8bUcMnqd5Sc9Pw874H76MFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwlxGHTOPFV6tlZp6dweTDrjVm+V1z36VlhGAp9TvEt9sse1tlTRbp0chqSPvrVOK
	 zoRjYbH6rSVyOxen2yOSTdrNZWCZ9DlJWOH898B7R3rme0Xf96UyaciElLNFN8pFCy
	 tz24A5hawVZCJO+GHO7BVGnofXCQmnYjyex6gdP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 062/102] Revert "igc: fix a log entry using uninitialized netdev"
Date: Tue,  9 Jul 2024 13:10:25 +0200
Message-ID: <20240709110653.794960775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
@@ -6679,6 +6679,8 @@ static int igc_probe(struct pci_dev *pde
 	device_set_wakeup_enable(&adapter->pdev->dev,
 				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
 
+	igc_ptp_init(adapter);
+
 	igc_tsn_clear_schedule(adapter);
 
 	/* reset the hardware with the new settings */
@@ -6700,9 +6702,6 @@ static int igc_probe(struct pci_dev *pde
 	/* Check if Media Autosense is enabled */
 	adapter->ei = *ei;
 
-	/* do hw tstamp init after resetting */
-	igc_ptp_init(adapter);
-
 	/* print pcie link status and MAC address */
 	pcie_print_link_status(pdev);
 	netdev_info(netdev, "MAC: %pM\n", netdev->dev_addr);


