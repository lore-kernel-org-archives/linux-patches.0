Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290675FF17;
	Tue, 13 Feb 2024 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845931; cv=none; b=Dyb0OBU4FYyvyc2fUHnIP8bPNoFYIoMl+7xUuX88f/gddZOzwkwtsWhf5+gJ/+V+oUm2/jjcFTGTrEjsxW++t2oIGq1dHbYMawBRAhr1DQCJyRhn3gbWAZZ2XghBdvuWrOW5Y7iBxgDnHo/DllMyd+9Lao5tRAWxZR6f4chHYGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845931; c=relaxed/simple;
	bh=jclX8lug7e1qVjhMpt6Z8vTYXLf3D1uZIMgo1xdDTcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8yCoMFPAfHu/7xmwmyJA9abxTPRNUQlqvkdlwnFSwggXUGbRMY4XEQlFY+3Vq5NoWy+FP/nqRCMxb8uvNv9uvfrSjHVpDz2xniqPbG8emyG732UDKpg1x/zRRxHuJK+Yo1GCkDK6sV1mBa6kp+UWODyWzNRdLqsM26pip05C5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiY81VdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiY81VdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81858C433F1;
	Tue, 13 Feb 2024 17:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845931;
	bh=jclX8lug7e1qVjhMpt6Z8vTYXLf3D1uZIMgo1xdDTcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiY81VdCtDQ8VPSGJfGkg9yR/2mXYLhr/hNaPJNtdsQ9oHzavKWw3fKWNUehe4lA3
	 TPq++t7SHmbxxXsMQ+dXNa+H5rH9jYXVC6ayWR52RzRpdjWjQvLeeVulSsRIq2Fv1K
	 SjsRlCUkb1uM2SxgbVY3d12eyrIhUQTaCziGq7T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.7 100/124] usb: dwc3: pci: add support for the Intel Arrow Lake-H
Date: Tue, 13 Feb 2024 18:22:02 +0100
Message-ID: <20240213171856.652044964@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit de4b5b28c87ccae4da268a53c5df135437f5cfde upstream.

This patch adds the necessary PCI ID for Intel Arrow Lake-H
devices.

Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240115092820.1454492-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -51,6 +51,8 @@
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTLS		0x7f6f
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
+#define PCI_DEVICE_ID_INTEL_ARLH		0x7ec1
+#define PCI_DEVICE_ID_INTEL_ARLH_PCH		0x777e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
 
@@ -421,6 +423,8 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, MTLP, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTLS, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, ARLH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, ARLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGL, &dwc3_pci_intel_swnode) },
 
 	{ PCI_DEVICE_DATA(AMD, NL_USB, &dwc3_pci_amd_swnode) },


