Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0CA3AA197;
	Wed,  3 Dec 2025 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781112; cv=none; b=W4ktttttjSCr1i9TZFn2NoWziU1DyarnK0NORs+yPFZbMfrXPB7SaK7Nx0odLI0wRba+P6JnMtaG6C7Hxwywkwjp6bonVlFty5O95/fQDK4XhEmCcC84LKTHsYT7lKMURfa1qdl491uhJN5Uco/fe6vWOjPT/OXEA8hVsGPR13g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781112; c=relaxed/simple;
	bh=+vkSzC2J+ZITU89o7PQPd6A0cHO+aEuGyP69rmi7/9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfRs6/7MJ3AV5tAWA64sl45GogNoi+3PHB1O2f/0ZFZiVd0UEQNFXO06DIj8kV5OJwIFbEg4t3pkbcuJR/R9UqpXgrFUiJh0OijS8ONHctGUZrloHgUv/C5wPQGuJpHZvTI+fhWVeTynNLnGN2GcDZ2b5/PbhUVFZCE3X4KMYsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPep03YT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPep03YT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D237FC116C6;
	Wed,  3 Dec 2025 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781112;
	bh=+vkSzC2J+ZITU89o7PQPd6A0cHO+aEuGyP69rmi7/9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPep03YT/DyOrP4dIwYHTGP50/3nbqY2ksBnlEt1QJFP7pCl96C745/+nIW6p0TIF
	 BYQzSaQzeaGoyQ7WnyueM7gEekVrJ/ztzrAQrtLVq6ut2aQw/AmgWOR7767AX3eRzD
	 SgM/mAhbeAbC5jGciOtFKLG2S91YlXUBNfz0s+ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 51/93] thunderbolt: Add support for Intel Wildcat Lake
Date: Wed,  3 Dec 2025 16:29:44 +0100
Message-ID: <20251203152338.407724552@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1536,6 +1536,8 @@ static struct pci_device_id nhi_ids[] =
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
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HUB_80G_BRIDGE 0x5786


