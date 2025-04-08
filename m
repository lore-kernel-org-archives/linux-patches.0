Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA626266580;
	Tue,  8 Apr 2025 12:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115012; cv=none; b=PNalzZ6A/o/oqE2bTFcwW6N+3MJjNdKsnTb39kSFQVyaNRPLErgE4XRkjLICCN2iWReEzgCfpSrdEUZzNKOI0OAZNwVGBpz6gPj8tjTStZcQ8ZkgJ9gZUVRY/jKkgjcR4LxE+ZFvdFvZU+G419DlxnA+EyyIEkpkUi/NSQWRJXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115012; c=relaxed/simple;
	bh=yKk3SZ6ZSaCg5swg/HlXrNep1Z1hH8zrEFgG9yK/4+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fvOhEok6F4HM/eC9KSNPHMpuH0B0aubb5VRN6q3Kgxgq7UEfxHTjZOaxf/dYcn7/Q0xu1oUjrCvz3WHjdaiMehgLCMUk80KxUCarJWquXeVPLcHFfaAB2AEQ0s3oX6RSCVq5kUod/gFmA5B6WwjaOS7UqcT2Zu8TWjxr8674gK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1l+uOk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1l+uOk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B914C4CEE5;
	Tue,  8 Apr 2025 12:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115012;
	bh=yKk3SZ6ZSaCg5swg/HlXrNep1Z1hH8zrEFgG9yK/4+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1l+uOk7QmlNDiTfDDPZ5XvLu9rWBIJjRW231QY1n94EG6OSxIDlxy4tt0wYr4wsu
	 p8BBbDnN6i09mbxuXQwksnOD7e5FTAkWjx5wTFXoeBf20tXqc7hZXqJvFX9XiFT7NA
	 /Dh+RWZr/x2iL9jfUOZB9b7GWpXm3hFN1r1gMkPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 317/499] platform/x86/intel/vsec: Add Diamond Rapids support
Date: Tue,  8 Apr 2025 12:48:49 +0200
Message-ID: <20250408104859.127027919@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8272f1dd0fbc0..db3c031d17572 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -404,6 +404,11 @@ static const struct intel_vsec_platform_info oobmsm_info = {
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
@@ -420,6 +425,7 @@ static const struct intel_vsec_platform_info lnl_info = {
 #define PCI_DEVICE_ID_INTEL_VSEC_MTL_M		0x7d0d
 #define PCI_DEVICE_ID_INTEL_VSEC_MTL_S		0xad0d
 #define PCI_DEVICE_ID_INTEL_VSEC_OOBMSM		0x09a7
+#define PCI_DEVICE_ID_INTEL_VSEC_OOBMSM_DMR	0x09a1
 #define PCI_DEVICE_ID_INTEL_VSEC_RPL		0xa77d
 #define PCI_DEVICE_ID_INTEL_VSEC_TGL		0x9a0d
 #define PCI_DEVICE_ID_INTEL_VSEC_LNL_M		0x647d
@@ -430,6 +436,7 @@ static const struct pci_device_id intel_vsec_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, VSEC_MTL_M, &mtl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_MTL_S, &mtl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_OOBMSM, &oobmsm_info) },
+	{ PCI_DEVICE_DATA(INTEL, VSEC_OOBMSM_DMR, &dmr_oobmsm_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_RPL, &tgl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_TGL, &tgl_info) },
 	{ PCI_DEVICE_DATA(INTEL, VSEC_LNL_M, &lnl_info) },
-- 
2.39.5



