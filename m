Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D923D11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3D2C433C8;
	Mon, 11 Sep 2023 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445446;
	bh=IRbf+7U/dc7uWa4hoHmQsC74RYGB4384Uh+5FknMuBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsqewd1ESv/4QAe620xf4Ww7+e2HEukSq0GNgskqjxc/gaycbdOipXOBAEca7Mvh3
	 a6EN96hLaRpgWTO2goPNk4kfI4mwb0uo5/oa4VdPKhHBYGAEUfQhpjcMf0eWKa71JC
	 8ljLMWHvOyBZbGfP7Mj7d0umdJO+lgKCuFVEYQuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Zongyong <wuzongyong@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 350/600] PCI: Mark NVIDIA T4 GPUs to avoid bus reset
Date: Mon, 11 Sep 2023 15:46:23 +0200
Message-ID: <20230911134644.012582524@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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
index 472fa2c8ebcec..d6fe44a5270d5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3631,7 +3631,7 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
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



