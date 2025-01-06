Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A50D13B59A;
	Mon,  6 Jan 2025 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178927; cv=none; b=alq79vR75JyGFMpngpJWDZ88UT7ONxhONG6yKnEFA7Ymdo/kEruCgt1gUZCFMlkX1ATf2RsNHz1GEIIMng2pGWDpbqxoUncTnHn/pYy7A4QDf8pyCcVJB/tFtiCUyUaslexgy41bksoJJYGcH+6pBsWsqsPvnv7bUafgaa5oM+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178927; c=relaxed/simple;
	bh=ht5tZ67BKPzyUqwCKRAvSOOLQwEu7Rk+yZLl7yETLXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBS52POWj0xiiSH4j3bc6F/3SOp/fChV3dsexsVOnZFLrI2I3VfXYix7SYEp3kU1ukk9vWjHcWXUFPo7xjqmn8SR7lG+l+OqLe/2OoqZBvpajfdSS1w3V6F8MbOz2nJKDNjd5/t7jM34irkzc3WvCHYpbVnYa3WGnVRqv0L5fuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsBV5+yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsBV5+yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD1C4CED2;
	Mon,  6 Jan 2025 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178927;
	bh=ht5tZ67BKPzyUqwCKRAvSOOLQwEu7Rk+yZLl7yETLXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsBV5+yhR+tS1tUqcedVkcMPspYmA7L82aBEUwhu5HjhHKb0/byRRL3yGTQN75Buv
	 MyEYUnM7mqqByihUvwiuLXBdi4vAmina3I2zpL+Siz1ZEEjbU3X2rAQkKBLHsMfDGX
	 BYu5RqqTzUA6v9SCqh198D3swKvXtYND2pAP+UeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George D Sworo <george.d.sworo@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/168] thunderbolt: Add support for Intel Raptor Lake
Date: Mon,  6 Jan 2025 16:16:55 +0100
Message-ID: <20250106151142.500452459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George D Sworo <george.d.sworo@intel.com>

[ Upstream commit 7ec58378a985618909ffae18e4ac0de2ae625f33 ]

Intel Raptor Lake has the same integrated Thunderbolt/USB4 controller as
Intel Alder Lake. By default it is still using firmware based connection
manager so we can use most of the Alder Lake flows.

Signed-off-by: George D Sworo <george.d.sworo@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 8644b48714dc ("thunderbolt: Add support for Intel Panther Lake-M/P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/icm.c | 2 ++
 drivers/thunderbolt/nhi.c | 4 ++++
 drivers/thunderbolt/nhi.h | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index 11c0207ebd7e..e4e92f014a8b 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2511,6 +2511,8 @@ struct tb *icm_probe(struct tb_nhi *nhi)
 	case PCI_DEVICE_ID_INTEL_TGL_H_NHI1:
 	case PCI_DEVICE_ID_INTEL_ADL_NHI0:
 	case PCI_DEVICE_ID_INTEL_ADL_NHI1:
+	case PCI_DEVICE_ID_INTEL_RPL_NHI0:
+	case PCI_DEVICE_ID_INTEL_RPL_NHI1:
 		icm->is_supported = icm_tgl_is_supported;
 		icm->driver_ready = icm_icl_driver_ready;
 		icm->set_uuid = icm_icl_set_uuid;
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 7341376140eb..99faa8a5e9c0 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1437,6 +1437,10 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADL_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPL_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 
 	/* Any USB4 compliant host */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_USB4, ~0) },
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 5091677b3f4b..01190d9ced16 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -81,6 +81,8 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TGL_NHI1			0x9a1d
 #define PCI_DEVICE_ID_INTEL_TGL_H_NHI0			0x9a1f
 #define PCI_DEVICE_ID_INTEL_TGL_H_NHI1			0x9a21
+#define PCI_DEVICE_ID_INTEL_RPL_NHI0			0xa73e
+#define PCI_DEVICE_ID_INTEL_RPL_NHI1			0xa76d
 
 #define PCI_CLASS_SERIAL_USB_USB4			0x0c0340
 
-- 
2.39.5



