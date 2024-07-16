Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C370A1DDCE;
	Tue, 16 Jul 2024 16:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146066; cv=none; b=HOmtCYxaZGwWRVYUwj+P9qoRt9qlO6OVY2DK+H5m2fGwp+14Yv2KWG/Fm1SxPd4DVFbboQsARObHGxuBTAPH9Oj7wY8M/FFlGuBTiPqJHt6es8mqxcAP6KxbPWns1MJagnuAaCV1GsabYjti4QYEkOw0/Z+0NYdS5UiOTm8QwrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146066; c=relaxed/simple;
	bh=2Q/aoh2my2NaiNuTe08cnWOxNa8qrffSvB9VIj+/s3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCNl7Xj0xFWec5/5JY3coICu2LkXlZFjeDKyhfV7Wt26GyAmWSQPCyk2PkKbPbIjAga/3T7fFV/slXJP9i3HsZG7DYU2302lTFAIVkEkPlE+C2o7CBgR5YSK+rXDwP6HYuqtZVk8cHv6rplgbASKIIae+gwFHO63qaye81wctzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP8AxvYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP8AxvYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D4EC116B1;
	Tue, 16 Jul 2024 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146066;
	bh=2Q/aoh2my2NaiNuTe08cnWOxNa8qrffSvB9VIj+/s3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SP8AxvYmFQbklZL0xUYL2MNNluvs5kon0UiLgX0HbK1dmPwQg3M39WnqdA4iXWXnP
	 eH2CKXPeuVDC0XoayjJtTzATwMT4RtyzVrtfyj9OmEMRn05QAJ7anOpIKEgViGmpQW
	 MfrsS/4nqfKp+4wWpDHOT1KiWqrf4Rz3Q0+634bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 046/144] Revert "igc: fix a log entry using uninitialized netdev"
Date: Tue, 16 Jul 2024 17:31:55 +0200
Message-ID: <20240716152754.316210253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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
@@ -6673,6 +6673,8 @@ static int igc_probe(struct pci_dev *pde
 	device_set_wakeup_enable(&adapter->pdev->dev,
 				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
 
+	igc_ptp_init(adapter);
+
 	igc_tsn_clear_schedule(adapter);
 
 	/* reset the hardware with the new settings */
@@ -6694,9 +6696,6 @@ static int igc_probe(struct pci_dev *pde
 	/* Check if Media Autosense is enabled */
 	adapter->ei = *ei;
 
-	/* do hw tstamp init after resetting */
-	igc_ptp_init(adapter);
-
 	/* print pcie link status and MAC address */
 	pcie_print_link_status(pdev);
 	netdev_info(netdev, "MAC: %pM\n", netdev->dev_addr);


