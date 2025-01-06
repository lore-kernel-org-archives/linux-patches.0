Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A5D38F9C;
	Mon,  6 Jan 2025 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178465; cv=none; b=LnwpLEUv3gv3fuPm0+hXGTioXZtbzOiSpwifm/zXc0wA+Y46KDhvYyj3TRspd7McwB6RULR4GyN6IDF/g1bAx+YNfSEMQN5UnV5Ui1flGgNUUkL2AFaMpanVjS4+gujZRfyBzCFzCOIcGMDkhWpKsSRB1VD20R+w6LJp/sRGrTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178465; c=relaxed/simple;
	bh=FP6wNnsVBP5Q+fDf/BlL/OVUjiLXfdpcPcDsFAClJK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJZph5KhFNn2U5fOzh/+lQ0C+7ek/bG0v2qMNkpKrh9KFsMVdr8IjRvxTDgEDRY6T3unsP3b+PMpLnGBVjy17Z8RbYUq5m7Tyn4yFdhlveGQ9l+rK6LeQV7m+Tu4tLwyFmlH1dYg8+zMS0VhshKUTsu26inkg/8OK8v/3hFvpNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUs2FnnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUs2FnnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4BBC4CED2;
	Mon,  6 Jan 2025 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178465;
	bh=FP6wNnsVBP5Q+fDf/BlL/OVUjiLXfdpcPcDsFAClJK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUs2FnnJ2sWgf83NS7eHvL8EuqT8WERu8AkFO2/t8Py1OHOm/DELDqqdyRLhOQjKM
	 qF+lm2fYp/8Vjc8N5he98ly263LsqZSFSx8rf6IUiwqhbJtb2mfYWtvtKIZp9WQP5l
	 s/teSenpi5q/vCr9e/PeVjowMrX+jZcMNfnqIqgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Azhar Shaikh <azhar.shaikh@intel.com>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/138] thunderbolt: Add support for Intel Alder Lake
Date: Mon,  6 Jan 2025 16:16:50 +0100
Message-ID: <20250106151136.489429019@linuxfoundation.org>
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

From: Azhar Shaikh <azhar.shaikh@intel.com>

[ Upstream commit 135794868ad83d0327cdd78df469e118f1fe7cc4 ]

Alder Lake has the same integrated Thunderbolt/USB4 controller as
Intel Tiger Lake. By default it is still using firmware based connection
manager so we can use most of the Tiger Lake flows.

Add the Alder Lake PCI IDs to the driver list of supported devices.

Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
Reviewed-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 8644b48714dc ("thunderbolt: Add support for Intel Panther Lake-M/P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/icm.c | 2 ++
 drivers/thunderbolt/nhi.c | 4 ++++
 drivers/thunderbolt/nhi.h | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index 90f1d9a53461..b038e530d6cb 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2290,6 +2290,8 @@ struct tb *icm_probe(struct tb_nhi *nhi)
 	case PCI_DEVICE_ID_INTEL_TGL_NHI1:
 	case PCI_DEVICE_ID_INTEL_TGL_H_NHI0:
 	case PCI_DEVICE_ID_INTEL_TGL_H_NHI1:
+	case PCI_DEVICE_ID_INTEL_ADL_NHI0:
+	case PCI_DEVICE_ID_INTEL_ADL_NHI1:
 		icm->is_supported = icm_tgl_is_supported;
 		icm->driver_ready = icm_icl_driver_ready;
 		icm->set_uuid = icm_icl_set_uuid;
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index fd1b59397c70..1e732d2d15ad 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1349,6 +1349,10 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGL_H_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADL_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 
 	/* Any USB4 compliant host */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_USB4, ~0) },
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 7ad6d3f0583b..5091677b3f4b 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -73,6 +73,8 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_4C_BRIDGE	0x15ea
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_4C_NHI		0x15eb
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE	0x15ef
+#define PCI_DEVICE_ID_INTEL_ADL_NHI0			0x463e
+#define PCI_DEVICE_ID_INTEL_ADL_NHI1			0x466d
 #define PCI_DEVICE_ID_INTEL_ICL_NHI1			0x8a0d
 #define PCI_DEVICE_ID_INTEL_ICL_NHI0			0x8a17
 #define PCI_DEVICE_ID_INTEL_TGL_NHI0			0x9a1b
-- 
2.39.5



