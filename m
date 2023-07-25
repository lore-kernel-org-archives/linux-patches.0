Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AAB1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95757C433C7;
	Tue, 25 Jul 2023 11:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285543;
	bh=l1MJB9eNxFcI3NxeE5kLbluKh1EYgcLUmuKMGSTnHxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vA81G4DkeGmu18n7EKvPEZYD3Yud5W6ZqiLtQs1o6xQVrmZtpsLKZGcP1lsi6v+0R
	 vs9nngiYXkc3+MSSfFbLGmT2EgXBf7Q3ZXUA8/osb+xb3I15AvXjKU7Kq4LL7BZhLz
	 hnnw1CIte5p8i3SzkNNc02o448Sc8L63fpSx9+50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Adriaanse <jason_a69@yahoo.co.uk>,
	Robin Murphy <robin.murphy@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 242/313] PCI: Add function 1 DMA alias quirk for Marvell 88SE9235
Date: Tue, 25 Jul 2023 12:46:35 +0200
Message-ID: <20230725104531.534646836@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robin Murphy <robin.murphy@arm.com>

commit 88d341716b83abd355558523186ca488918627ee upstream.

Marvell's own product brief implies the 92xx series are a closely related
family, and sure enough it turns out that 9235 seems to need the same quirk
as the other three, although possibly only when certain ports are used.

Link: https://lore.kernel.org/linux-iommu/2a699a99-545c-1324-e052-7d2f41fed1ae@yahoo.co.uk/
Link: https://lore.kernel.org/r/731507e05d70239aec96fcbfab6e65d8ce00edd2.1686157165.git.robin.murphy@arm.com
Reported-by: Jason Adriaanse <jason_a69@yahoo.co.uk>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4168,6 +4168,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_M
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c49 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9230,
 			 quirk_dma_func1_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9235,
+			 quirk_dma_func1_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TTI, 0x0642,
 			 quirk_dma_func1_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TTI, 0x0645,


