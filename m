Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FF92EF287;
	Tue, 17 Jun 2025 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175890; cv=none; b=d82GPu+2zuigyXINNLP+rfWAfDml38ogCTf6RA251NWMdr9WN1V8kfF1yGW8VBB3knXoXTGasjb6vsxy00VJgGoYSmMryUGGJJQZKn9Mhv0unrpkbkKxBXG4Q6M/kD8TMY1HHN8wTr5Nb2zYtw+KqTC8BBg6fzHGbDy6DB1eicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175890; c=relaxed/simple;
	bh=ltcGN+82A8NQaTyTLb22IqN47ZhwuqoEQN/gmIaUpi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvjSdGV4Y08EqVoffJ14ER3JtKXqjyRZMTckpP4q3/EG2PWCIJCjGZd+PjeERwHXqneRcF20HyjHbXvB+QgqAyeoQDGTs00Xg0R1x1iBXrT5Ts529sE09hIeUnqX0b4YrDHoQEb20aVXZuKGzK5del6pHnjGTUmezS/J8UAmeAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4MH0Kka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4MH0Kka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88976C4CEE3;
	Tue, 17 Jun 2025 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175890;
	bh=ltcGN+82A8NQaTyTLb22IqN47ZhwuqoEQN/gmIaUpi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4MH0Kka3bE4SInkY/DGB44u39EuZD70ZNlKZakeTDHgL8ySx2U6IDbaB60rKanQf
	 iFsACN1JD+y1Va9GzuuChcs/ZWamusRgLvsrjCGMcwwLQx+2gNy3oqu+oPyxFhfuG1
	 8EYXNk0LtKSYnyyTxD3zCH9BAA2eD88xekKpON5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/356] PCI: Print the actual delay time in pci_bridge_wait_for_secondary_bus()
Date: Tue, 17 Jun 2025 17:25:37 +0200
Message-ID: <20250617152347.140784543@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

[ Upstream commit d24eba726aadf8778f2907dd42281c6380b0ccaa ]

Print the delay amount that pcie_wait_for_link_delay() is invoked with
instead of the hardcoded 1000ms value in the debug info print.

Fixes: 7b3ba09febf4 ("PCI/PM: Shorten pci_bridge_wait_for_secondary_bus() wait time for slow links")
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20250414001505.21243-2-wilfred.opensource@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 095fa1910d36d..503304aba9eac 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5221,7 +5221,7 @@ int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type)
 		delay);
 	if (!pcie_wait_for_link_delay(dev, true, delay)) {
 		/* Did not train, no need to wait any further */
-		pci_info(dev, "Data Link Layer Link Active not set in 1000 msec\n");
+		pci_info(dev, "Data Link Layer Link Active not set in %d msec\n", delay);
 		return -ENOTTY;
 	}
 
-- 
2.39.5



