Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED342E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64E6C433C8;
	Wed, 20 Sep 2023 12:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211985;
	bh=B0eqCZHDEt29SwoAuF77RLWz81Aty7CPgkjYwlqge5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcSZZ7G3YJ/qioNyZ0It5idxsECm7zrJ5/GnMJ/uxsa7xp54iR4hsEwECRNt1PpKa
	 KerGB/3sB6TXJKdjOjwBbLVedLSwLDXYRj1DaABc1D7dpr9G2QDDiEaanol2ODlxNF
	 yUfwJg+FSnkBN7R//koDF/SjL39SDYMO0dCAnC2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Zongyong <wuzongyong@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/273] PCI: Mark NVIDIA T4 GPUs to avoid bus reset
Date: Wed, 20 Sep 2023 13:29:08 +0200
Message-ID: <20230920112849.813755295@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Zongyong <wuzongyong@linux.alibaba.com>

[ Upstream commit d5af729dc2071273f14cbb94abbc60608142fd83 ]

NVIDIA T4 GPUs do not work with SBR. This problem is found when the T4 card
is direct attached to a Root Port only. Avoid bus reset by marking T4 GPUs
PCI_DEV_FLAGS_NO_BUS_RESET.

Fixes: 4c207e7121fa ("PCI: Mark some NVIDIA GPUs to avoid bus reset")
Link: https://lore.kernel.org/r/2dcebea53a6eb9bd212ec6d8974af2e5e0333ef6.1681129861.git.wuzongyong@linux.alibaba.com
Signed-off-by: Wu Zongyong <wuzongyong@linux.alibaba.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index fa9d6c8f1cf89..a43e0e20b1ea6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3472,7 +3472,7 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
  */
 static void quirk_nvidia_no_bus_reset(struct pci_dev *dev)
 {
-	if ((dev->device & 0xffc0) == 0x2340)
+	if ((dev->device & 0xffc0) == 0x2340 || dev->device == 0x1eb8)
 		quirk_no_bus_reset(dev);
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-- 
2.40.1



