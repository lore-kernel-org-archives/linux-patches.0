Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D151F1925AA;
	Thu,  5 Sep 2024 09:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529393; cv=none; b=NCR2AJToiu66LVHqEjPkj9cRxkX7obyRfcxYDHntaLTNbjX3FP9M/l9kO4iPR9A94PkrUOW87H9VHu3B52bn5elcpEOHbsc475XLJ+RYpDyayVN6eWbyMNkYmcECgG2vGIzk3U2G1MXKnRw3SYelMzK8XfS+mXg9HrfZ7VoXWSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529393; c=relaxed/simple;
	bh=tOJhoHS4X2jZduOmu6YBgjDRaebecoGCNbi1CeyoGDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAXu5aHhtmin8J1orgBNl8FeQksLUJ+mR4yABMvQ1U8j5Effko9l6EKb3mSF0jEJk/D2V3UeuaZ+aVJsDFA9Kg0Qu0IgySXqOwbbXK6cU9juagBg0es5H96eFWoT+/KuU2BB05q34cmKKIjfIu0PZow+RxPG3JdD+jHS7mbZPR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guPo7Taq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guPo7Taq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E26EC4CEC3;
	Thu,  5 Sep 2024 09:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529393;
	bh=tOJhoHS4X2jZduOmu6YBgjDRaebecoGCNbi1CeyoGDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guPo7TaqFcKhHNvBIBoo6eMu7wvp/7pk5cONVPznCWVZvba0n/HDtwL8QmKM+2pk+
	 a2NrJOxsb+GG6lwiFK0J6sCszEEpqYXH9Z+QwlrpoHx6B70haS6seQEUU+Mu1i/XN2
	 bAeIxTGHs2aF7vlJeyN1xJ7dU3Z9S/3t8plb0M5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 019/184] platform/x86/amd/pmf: Add new ACPI ID AMDI0107
Date: Thu,  5 Sep 2024 11:38:52 +0200
Message-ID: <20240905093732.997133207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 942810c0e89277d738b7f1b6f379d0a5877999f6 ]

Add new ACPI ID AMDI0107 used by upcoming AMD platform to the PMF
supported list of devices.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20240723132451.3488326-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index 2d6e2558863c5..8f1f719befa3e 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -41,6 +41,7 @@
 #define AMD_CPU_ID_RMB			0x14b5
 #define AMD_CPU_ID_PS			0x14e8
 #define PCI_DEVICE_ID_AMD_1AH_M20H_ROOT	0x1507
+#define PCI_DEVICE_ID_AMD_1AH_M60H_ROOT	0x1122
 
 #define PMF_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
@@ -249,6 +250,7 @@ static const struct pci_device_id pmf_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_RMB) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, AMD_CPU_ID_PS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M20H_ROOT) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M60H_ROOT) },
 	{ }
 };
 
@@ -382,6 +384,7 @@ static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0102", 0},
 	{"AMDI0103", 0},
 	{"AMDI0105", 0},
+	{"AMDI0107", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.43.0



