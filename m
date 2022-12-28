Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C1F1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7963DC433D2;
	Wed, 28 Dec 2022 16:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246486;
	bh=XknLPQW+r/NWKRWn+iQQ1a3zK3Edy3Qz6rW4qZq5W+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9caV9ujxs2QmLAa6DhMYdxtr1NF2zLc62BDLAYMHS59eS+1isCmllsAQ1Wo6dobY
	 Qlfh3NIx4kows3wLnXon1CpgQwPwVIbrmqejepKiBDCXemSyZpDqBm4i6v35IO7BaC
	 KU1uxeLrDvbfAxgli6BHdvh1HNpApp8nVQ3MeF1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1054/1146] Revert "PCI: Clear PCI_STATUS when setting up device"
Date: Wed, 28 Dec 2022 15:43:13 +0100
Message-Id: <20221228144358.931859454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 44e985938e85503d0a69ec538e15fd33c1a4df05 ]

This reverts commit 6cd514e58f12b211d638dbf6f791fa18d854f09c.

Christophe Fergeau reported that 6cd514e58f12 ("PCI: Clear PCI_STATUS when
setting up device") causes boot failures when trying to start linux guests
with Apple's virtualization framework (for example using
https://developer.apple.com/documentation/virtualization/running_linux_in_a_virtual_machine?language=objc)

6cd514e58f12 only solved a cosmetic problem, so revert it to fix the boot
failures.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2137803
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b66fa42c4b1f..1d6f7b502020 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1891,9 +1891,6 @@ int pci_setup_device(struct pci_dev *dev)
 
 	dev->broken_intx_masking = pci_intx_mask_broken(dev);
 
-	/* Clear errors left from system firmware */
-	pci_write_config_word(dev, PCI_STATUS, 0xffff);
-
 	switch (dev->hdr_type) {		    /* header type */
 	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
 		if (class == PCI_CLASS_BRIDGE_PCI)
-- 
2.35.1



