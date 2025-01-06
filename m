Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63C515A842;
	Mon,  6 Jan 2025 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178433; cv=none; b=BZieBFdcXYulbWvxUHCAd5NiKPsEnt4yc4rn7O61m83NQIm9G0qa7FyNM6VBDABrkRk9eqoOkRHYtKVRBMKXJVD9QujbE/OgziG6J6eSeUPpp9MlCCXN27+IJjNiWfsg3D8cBgRDNbyLNOwPQ8EFSdqsFoujU/rJ7zYaIukEgzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178433; c=relaxed/simple;
	bh=fsn74eakcfpznoc7osKADY1RwBMbCqu1mXfdyFUcTQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcDWwbf2LUIEjGDA2elfk3uTtfuGIayYGzJ07LPQWNx65SnnJV9idnqXVUxAjhYxbu5ifpWCei+SwXWRCUcda2d6A2j8OfcAPDhuooFHqHjDDqDP1Y7MsFOogAiq5akViyfRGkGAZDgVtx60yOK6wbuIJFzD2tWNvXtKnOgBnX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDeEZyBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDeEZyBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785D9C4CED6;
	Mon,  6 Jan 2025 15:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178432;
	bh=fsn74eakcfpznoc7osKADY1RwBMbCqu1mXfdyFUcTQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDeEZyBwpejlyrT9Eu75T+xQXTeOQcI0IUF4Dvda6POc68261ym1wW9DPfpKITrxh
	 YsSPUbZMJ1K0DXxSe/TRErahztumTAIMDgC8Qkdkihq3wp5KlyZ2Jw2h1rGSwoWDd/
	 5MvwhJ8biw4Z+ZavdRo2UQ7lWyEhgnxCRM/Ag+KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/138] thunderbolt: Add Intel Barlow Ridge PCI ID
Date: Mon,  6 Jan 2025 16:16:53 +0100
Message-ID: <20250106151136.602934653@linuxfoundation.org>
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

[ Upstream commit 6f14a210661ce03988ef4ed3c8402037c8e06539 ]

Intel Barlow Ridge is the first USB4 v2 controller from Intel. The
controller exposes standard USB4 PCI class ID in typical configurations,
however there is a way to configure it so that it uses a special class
ID to allow using s different driver than the Windows inbox one. For
this reason add the Barlow Ridge PCI ID to the Linux driver too so that
the driver can attach regardless of the class ID.

Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 8644b48714dc ("thunderbolt: Add support for Intel Panther Lake-M/P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 2 ++
 drivers/thunderbolt/nhi.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index ea2fff90d162..331157b99e24 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1363,6 +1363,8 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL_P_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
 	/* Any USB4 compliant host */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_USB4, ~0) },
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index b0718020c6f5..c15a0c46c9cf 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -75,6 +75,8 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE	0x15ef
 #define PCI_DEVICE_ID_INTEL_ADL_NHI0			0x463e
 #define PCI_DEVICE_ID_INTEL_ADL_NHI1			0x466d
+#define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI	0x5781
+#define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI	0x5784
 #define PCI_DEVICE_ID_INTEL_MTL_M_NHI0			0x7eb2
 #define PCI_DEVICE_ID_INTEL_MTL_P_NHI0			0x7ec2
 #define PCI_DEVICE_ID_INTEL_MTL_P_NHI1			0x7ec3
-- 
2.39.5



