Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519AE6088F;
	Mon,  6 Jan 2025 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178448; cv=none; b=gpYUQPV1Icbhn/gv7BV4qiETy2778GT5mG/wlpbThZjLnTUIbiDbuDVYntfWDS8iSVUCwP80kjcU3FYaFZ6krJztcy1RtrGOaOEhBtIoCPRU9RsHLneJV+sPrzFqdbgoGU1AKEjp7Bqf7VAFreg/2+ufReHN7u9A5UoamC9kbdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178448; c=relaxed/simple;
	bh=hZamCHXmpHxfMX+spi48T4Zf2u8FgBwLPhhveDF5+oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4hleFrhdwS0VHBSZfWPJKH2oGn10u6/AhVlxmty/b6wmEYIHBISodPRFxqc1nXnRwI6XxjOfsj/QU5vAtjuF+q7Np7ZIeLu9VaVWEkeEPiBezA4UXluI1qaSCnhqvHkPS9sMSnONoGxWil+/ngyo/l0MMYef9mbMQUv9O6pHPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wF+mcd/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wF+mcd/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B6DC4CED2;
	Mon,  6 Jan 2025 15:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178448;
	bh=hZamCHXmpHxfMX+spi48T4Zf2u8FgBwLPhhveDF5+oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wF+mcd/Xc7WTlBmK2ds9Og0jCZaWdscIS+SFRKsK3HGFXjUofR1YYT5xV3MQHwhx1
	 WvOXDcRuTY67pNQkov9BOlkt2cq+69NtomhOsjOCnEr6npjNphNp3qz1l6p8vG2ita
	 /C1sf5oWIeP8fMtttiXnAOFiq7fyClb2vsPdsEIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/138] thunderbolt: Add support for Intel Lunar Lake
Date: Mon,  6 Jan 2025 16:16:54 +0100
Message-ID: <20250106151136.640961912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 2cd3da4e37453019e21a486d9de3144f46b4fdf7 ]

Intel Lunar Lake has similar integrated Thunderbolt/USB4 controller as
Intel Meteor Lake with some small differences in the host router (it has
3 DP IN adapters for instance). Add the Intel Lunar Lake PCI IDs to the
driver list of supported devices.

Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 8644b48714dc ("thunderbolt: Add support for Intel Panther Lake-M/P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 4 ++++
 drivers/thunderbolt/nhi.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 331157b99e24..ada11c239e73 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1363,6 +1363,10 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL_P_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_LNL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_LNL_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index c15a0c46c9cf..4b0fccf033e1 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -88,6 +88,8 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TGL_H_NHI1			0x9a21
 #define PCI_DEVICE_ID_INTEL_RPL_NHI0			0xa73e
 #define PCI_DEVICE_ID_INTEL_RPL_NHI1			0xa76d
+#define PCI_DEVICE_ID_INTEL_LNL_NHI0			0xa833
+#define PCI_DEVICE_ID_INTEL_LNL_NHI1			0xa834
 
 #define PCI_CLASS_SERIAL_USB_USB4			0x0c0340
 
-- 
2.39.5



