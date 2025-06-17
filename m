Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2A92EF286;
	Tue, 17 Jun 2025 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176396; cv=none; b=DcWMzrUBHcx4wMaojZ4wHy0+SNqa7Pkjj2jkbm3+KnpGLpzOptR7WKvl0M52hIa0lRayYgz9Lf2dPkblBBgbmD9h1sD35VoWsD4aDi0pHKnXZigfL4wq/Hh+P25Y76LaS5zRwH2DKtpg7iIhZR2FdwLgRP0CK5u3EYA/ynvXAQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176396; c=relaxed/simple;
	bh=RFTevoG/1vW9OjYgMJ/CkHeAj/d8/vE8IfJ2ksNcPCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTSheTCNLbL+71uS8Bd2GotiMr/yHhvd+PEPd8/ikf+4EvpPnweTO/yl5SD4ibsEgN5qt7qSQQE2PoVzG48vpCfsXJoFAQEUSuymFDx/glaqQsy2nBibPaMgnRIlIDanXAHXtPShhx/DSeHFKPYGUxqHWhM8syqXsIrVKdBqVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUH5Iguj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUH5Iguj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDDEC4CEE3;
	Tue, 17 Jun 2025 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176395;
	bh=RFTevoG/1vW9OjYgMJ/CkHeAj/d8/vE8IfJ2ksNcPCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUH5Iguj/e+yUOC7r6wqJkt7cZXOE/61bVVSBikUrKp9paWZT2GwENcd2AkwRJXxd
	 H46CyILQv0CbiU5wIT8azLJ514xHEWADtmtUT1c9lZQY76bmJFVTmGn9KGo1EtQY0O
	 tFEOWza5jyl427uuXIK9+PdEjcZXRoJlL8t4riHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 176/780] wifi: ath12k: fix cleanup path after mhi init
Date: Tue, 17 Jun 2025 17:18:04 +0200
Message-ID: <20250617152458.645922423@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>

[ Upstream commit 6177c97fb6f05bf0473a2806e3bece7e77693209 ]

Currently, the 'err_pci_msi_free' label is misplaced, causing the cleanup
sequence to be incorrect. Fix this by moving the 'err_pci_msi_free' label
to the correct position after 'err_irq_affinity_cleanup'.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00209-QCAHKSWPL_SILICONZ-1

Fixes: a3012f206d07 ("wifi: ath12k: set IRQ affinity to CPU0 in case of one MSI vector")
Signed-off-by: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250403-ath12k-cleanup-v1-1-ad8f67b0e9cf@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index b474696ac6d8c..99b2c7927ec81 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1710,12 +1710,12 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
 err_mhi_unregister:
 	ath12k_mhi_unregister(ab_pci);
 
-err_pci_msi_free:
-	ath12k_pci_msi_free(ab_pci);
-
 err_irq_affinity_cleanup:
 	ath12k_pci_set_irq_affinity_hint(ab_pci, NULL);
 
+err_pci_msi_free:
+	ath12k_pci_msi_free(ab_pci);
+
 err_pci_free_region:
 	ath12k_pci_free_region(ab_pci);
 
-- 
2.39.5



