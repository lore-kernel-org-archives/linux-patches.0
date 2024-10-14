Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B926E571;
	Mon, 14 Oct 2024 14:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915891; cv=none; b=BnhSeCYygq76UBmeY4Cs8nFmTMv1GA5r9bUkhSoGgC464uKOqTRJ1X80GgRm4SEjsCnm4JacSwBZDDA7DPG6X1HhSoP7tYp2LgUmBBnb4Xki95OPx3N8WJNnNXA8HlwzYiioOm+AcahtVUJ80/wbUMEm8TyY/TQyW9DA4U/gPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915891; c=relaxed/simple;
	bh=1Tn2NGhjYACNPr6NXGFv1Ens55ANiwaFFo8riPQRCfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbcEu52ypwVNSwj2itpH4EmBP9TfoPnp2c3qEG4Km5sjcdPKXM5eiiAaaw22y97Ibd9g7O0q3WiNhJbXniQv2Vawe/dx6TS9/AEtRxYn+e5YYumd1sniHS20p8dcwRFYNO7HKkzlnzMnsnnlFDayfNRWEGyRSEyf18pDwI5ngh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvsTqWa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvsTqWa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A371C4CEC3;
	Mon, 14 Oct 2024 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915891;
	bh=1Tn2NGhjYACNPr6NXGFv1Ens55ANiwaFFo8riPQRCfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvsTqWa8/BraYU05K0UGEHFZ3dH57Qo6CVSiAjEY4Ev32zXj1Z+FPJ5Z4bciVfHmn
	 0VVlx5+ClrEcpj0F0FqZnRSI39Sa5kV+3ST+lMfWRIDHOUVRt0Pbvhfy4C8ISt4XIL
	 KbAGgul0o7cKrxzMasWJ8zJYWkZAEuLU3m366Myw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srujana Challa <schalla@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 008/214] vdpa/octeon_ep: Fix format specifier for pointers in debug messages
Date: Mon, 14 Oct 2024 16:17:51 +0200
Message-ID: <20241014141045.317378206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit bc0dcbc5c2c539f37004f2cce0e6e245b2e50b6c ]

Updates the debug messages in octep_vdpa_hw.c to use the %p format
specifier for pointers instead of casting them to u64.

Fixes smatch warning:
octep_hw_caps_read() warn: argument 3 to %016llx specifier is cast
from pointer

Fixes: 8b6c724cdab8 ("virtio: vdpa: vDPA driver for Marvell OCTEON DPU devices")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202409160431.bRhZWhiU-lkp@intel.com/
Signed-off-by: Srujana Challa <schalla@marvell.com>
Message-Id: <20240916162255.677774-1-schalla@marvell.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/octeon_ep/octep_vdpa_hw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/octeon_ep/octep_vdpa_hw.c b/drivers/vdpa/octeon_ep/octep_vdpa_hw.c
index 11bd76ae18cf9..1d4767b33315e 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_hw.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_hw.c
@@ -475,11 +475,11 @@ int octep_hw_caps_read(struct octep_hw *oct_hw, struct pci_dev *pdev)
 		dev_err(dev, "Incomplete PCI capabilities");
 		return -EIO;
 	}
-	dev_info(dev, "common cfg mapped at: 0x%016llx\n", (u64)(uintptr_t)oct_hw->common_cfg);
-	dev_info(dev, "device cfg mapped at: 0x%016llx\n", (u64)(uintptr_t)oct_hw->dev_cfg);
-	dev_info(dev, "isr cfg mapped at: 0x%016llx\n", (u64)(uintptr_t)oct_hw->isr);
-	dev_info(dev, "notify base: 0x%016llx, notify off multiplier: %u\n",
-		 (u64)(uintptr_t)oct_hw->notify_base, oct_hw->notify_off_multiplier);
+	dev_info(dev, "common cfg mapped at: %p\n", oct_hw->common_cfg);
+	dev_info(dev, "device cfg mapped at: %p\n", oct_hw->dev_cfg);
+	dev_info(dev, "isr cfg mapped at: %p\n", oct_hw->isr);
+	dev_info(dev, "notify base: %p, notify off multiplier: %u\n",
+		 oct_hw->notify_base, oct_hw->notify_off_multiplier);
 
 	oct_hw->config_size = octep_get_config_size(oct_hw);
 	oct_hw->features = octep_hw_get_dev_features(oct_hw);
@@ -511,7 +511,7 @@ int octep_hw_caps_read(struct octep_hw *oct_hw, struct pci_dev *pdev)
 	}
 	mbox = octep_get_mbox(oct_hw);
 	octep_mbox_init(mbox);
-	dev_info(dev, "mbox mapped at: 0x%016llx\n", (u64)(uintptr_t)mbox);
+	dev_info(dev, "mbox mapped at: %p\n", mbox);
 
 	return 0;
 }
-- 
2.43.0



