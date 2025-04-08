Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BF71AAA32;
	Tue,  8 Apr 2025 12:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116790; cv=none; b=et00QNziB6dwgLPrL3sXpAfXfaBoC5imbd8MZFVLELLMShLoRk+jR/HqW5H+WkBlnuKMGhBvyUKaDnIaqa1QlRx7Hi/iEJ6ieRqtO1/2b6kXDYv2XD1TtxmflY7abeK1qfTM5p4OYaiQqqoMgRqUXYAs1ZgQqxjzZ+/VC3mVsBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116790; c=relaxed/simple;
	bh=24oonON3z2cIBpA06t4QHgZ+vTpLmkzIC+pE7Fw8SEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEY1OFEurfUHWO57r+91NxNYkhvp16kLBlDoCho/66pWYKzhOkL053RKlfacLUpaZJM/+/BZkWJTGw8x/abf9wOl3cyfyfup/5AckoHzmTMzWgf9GntGv7EoQVGOv5fmnPBiYC+KJCfcxe18JB0wzQE9bnRGXdU/3dLRU+fJ8hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyVoG8QW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyVoG8QW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C7AC4CEE5;
	Tue,  8 Apr 2025 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116789;
	bh=24oonON3z2cIBpA06t4QHgZ+vTpLmkzIC+pE7Fw8SEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyVoG8QW9SBKK6/KpCqsJx44my2ibFgqKn5vogfZbta+mPDFE2WgKZujkeke56Apr
	 z4FN8Hc6IM1+5PE+qPq0i0YVQHGL6ylEbDuyHJTGeY/MxO/hAERZYxm9k6hDhE0bBo
	 1j/DnRilBdDSOkOS3WjxLkm2eKEDuk0vrCgjPe+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/423] platform/x86/intel/vsec: Add Diamond Rapids support
Date: Tue,  8 Apr 2025 12:49:56 +0200
Message-ID: <20250408104852.043787012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit f317f38e7fbb15a0d8329289fef8cf034938fb4f ]

Add PCI ID for the Diamond Rapids Platforms

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20250226214728.1256747-1-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 7b5cc9993974e..55dd2286f3f35 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -410,6 +410,11 @@ static const struct intel_vsec_platform_info oobmsm_info = {
 	.caps = VSEC_CAP_TELEMETRY | VSEC_CAP_SDSI | VSEC_CAP_TPMI,
 };
 
+/* DMR OOBMSM info */
+static const struct intel_vsec_platform_info dmr_oobmsm_info = {
+	.caps = VSEC_CAP_TELEMETRY | VSEC_CAP_TPMI,
+};
+
 /* TGL info */
 static const struct intel_vsec_platform_info tgl_info = {
 	.caps = VSEC_CAP_TELEMETRY,
@@ -426,6 +431,7 @@ static const struct intel_vsec_platform_info lnl_info = {
 #define PCI_DEVICE_ID_INTEL_VSEC_MTL_M		0x7d0d
 #define PCI_DEVICE_ID_INTEL_VSEC_MTL_S		0xad0d
 #define PCI_DEVICE_ID_INTEL_VSEC_OOBMSM		0x09a7
+#define PCI_DEVICE_ID_INTEL_VSEC_OOBMSM_DMR	0x09a1
 #define PCI_DEVICE_ID_INTEL_VSEC_RPL		0xa77d
 #define PCI_DEVICE_ID_INTEL_VSEC_TGL		0x9a0d
 #define PCI_DEVICE_ID_INTEL_VSEC_LNL_M		0x647d
@@ -435,6 +441,7 @@ static const struct pci_device_id intel_vsec_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, VSEC_MTL_M, &mtl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_MTL_S, &mtl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_OOBMSM, &oobmsm_info) },
+	{ PCI_DEVICE_DATA(INTEL, VSEC_OOBMSM_DMR, &dmr_oobmsm_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_RPL, &tgl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_TGL, &tgl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_LNL_M, &lnl_info) },
-- 
2.39.5



