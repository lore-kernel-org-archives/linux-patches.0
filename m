Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F622F2344;
	Tue, 17 Jun 2025 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175326; cv=none; b=TDbxr3DGGgy48+MToSv4/fLz3+t4wVHunWXH3LeXLuqMORmRAMdm68bUqcjnsntEFq+7pvH+DPYAdxbBNtlY6IXjjt8PT2symgGVIKXMx58aN1RWxBMwwvC/H/v34uE3LmLw0F0UbMkdyJ6lhU0V8YWVRzS+NhNulDjKplK5fdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175326; c=relaxed/simple;
	bh=GQfZUI3MJmJuGUCjZDMf9tlnpazh29FUVt3B5/BvPx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2KY3TX9CO86UjfduXD8FgEVAn0RAf6ykL2MgnulRIFxSjzH/nqzizPPaWnJIrGMQYnxRwA+Z8bUWpV7SPA/nfskhwVV5t2gXkOdV3a8E2KwwTjqjiAiM0cSNJqCPx3b8552CwF9ZNU0kjg6tsogFhRg9vT9hCdwQmGu4f91fZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhJP5353; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhJP5353"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ADBC4CEE7;
	Tue, 17 Jun 2025 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175326;
	bh=GQfZUI3MJmJuGUCjZDMf9tlnpazh29FUVt3B5/BvPx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhJP5353JDdTbuyp/Wy7KAC9UYEEt+rScDiUcs+IoVJqnmRkTZfNKcypGnbpdKc80
	 4Ree4soTD4Ok+cujszPCiDV8gxR2diO7u9OBHef5oy0/zuPDY6CQFktl9fQuDTIkJf
	 3/6CR8mXbaUSZwtzxBFkiumOnuYgrXoYgwO9Qvc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/512] wifi: ath12k: fix cleanup path after mhi init
Date: Tue, 17 Jun 2025 17:21:21 +0200
Message-ID: <20250617152424.248034347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 45d537066345a..1068cc07bc9f6 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1514,12 +1514,12 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
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



