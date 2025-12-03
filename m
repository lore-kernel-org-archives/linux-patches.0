Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DC30E0C2;
	Wed,  3 Dec 2025 15:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776744; cv=none; b=fVar66EjwfK4/sQEr7cGAVZUSFRrL7/NMPR3Jjjwm70qScZfhbDNNDJmrrfgyVdezSanEHCb5zxNuce73Yo5+DiLE+Wf2oMpKvCyKE1VM4UXUU0IvnfDo/w7VXfsa9JtkKlyRcJ7tgvDwFjIXROVFvXgieBNH4Pl189bjbJjgnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776744; c=relaxed/simple;
	bh=VU5P1vO90POWQ2+c2ki+yNGGj46hgmkJ08mI2eyFy8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hpv/JGUpFyhZeqJtrWm5befUtLEuW/NwyOVSYbtjaH8RgDbuXAffhWecoJUY37ux0zm4uyctt21RbjHe0v6ldiQ4njijrxdzVpM0y1iIVGlP8MvDGdRz30KkP0gGk8eZq0UKwrWzEg+GlbcjN+kBg/ioZo/9DSqJsp7F/VxTZW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHn+YC+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHn+YC+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3043CC4CEF5;
	Wed,  3 Dec 2025 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776744;
	bh=VU5P1vO90POWQ2+c2ki+yNGGj46hgmkJ08mI2eyFy8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHn+YC+SAoqYa6nfue+3sABlR5rTzM4hlcbYjVs1xldTxVwPdzqwBOoWPu3+GwgDc
	 KpqrlvaiPjlVQr/fs1K0tvxOnHimjWEseyCCBnRVfMhhdzPliE/SJb8QSr9EkyQJvB
	 e/pzXygwKdzAfeBCGJUIofHEJ35SSsa8HZUg3zc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 273/300] thunderbolt: Add support for Intel Wildcat Lake
Date: Wed,  3 Dec 2025 16:27:57 +0100
Message-ID: <20251203152410.745156514@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

commit 3575254546a27210a4b661ea37fbbfb836c0815d upstream.

Intel Wildcat Lake derives its Thunderbolt/USB4 controller from Lunar
Lake platform. Add Wildcat Lake PCI ID to the driver list of supported
devices.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |    2 ++
 drivers/thunderbolt/nhi.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1375,6 +1375,8 @@ static struct pci_device_id nhi_ids[] =
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_P_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_WCL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -75,6 +75,7 @@ extern const struct tb_nhi_ops icl_nhi_o
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE	0x15ef
 #define PCI_DEVICE_ID_INTEL_ADL_NHI0			0x463e
 #define PCI_DEVICE_ID_INTEL_ADL_NHI1			0x466d
+#define PCI_DEVICE_ID_INTEL_WCL_NHI0			0x4d33
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI	0x5781
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI	0x5784
 #define PCI_DEVICE_ID_INTEL_MTL_M_NHI0			0x7eb2


