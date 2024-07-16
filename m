Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A35F27733;
	Tue, 16 Jul 2024 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145038; cv=none; b=U+wO2k6dmW79El5JlVdOFT2yT5iXeN9d4N/UPCyYjRNk6kssmoKROtJ9vucjFtWQ2Nnye2+1KkMmO71z2Kqi5Uc4L4A5AV7LMtaUYVEblxj65sF3CEJbMTqQavDaecXmKNsMm0Bcn7NOfL2w5+H2Us76VDzekYsaFtbV9sH/iKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145038; c=relaxed/simple;
	bh=81PZ1DwCkACQWMfYDIfCyqw/7e0jtqShRa/EhwCh5Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLyfM7RM02iS9KDqMl6ypEzMt8E5VUkdEYFMMtuo/NfahRPTcASfj799USPGGWytEW2QX5Pr8fYmJIgypaMp7MZDVoYerIgSHUZwO3iHvvP23uQu7S/uKqqMKJbqmjJdNTjmlgYMCrAqTdhdXVZ3LziqH2MvxXRJsUaOnAlqKPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7zQmOW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7zQmOW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FDDC116B1;
	Tue, 16 Jul 2024 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145038;
	bh=81PZ1DwCkACQWMfYDIfCyqw/7e0jtqShRa/EhwCh5Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7zQmOW+Hwj4LtxNfprNkbgU0+elOnhefclepD3Nb3OkAg50qYYv+Ft5/nGYDcsn1
	 9oNd0ttuWIUQkF7V8qIgqfG/mH+AycJW89DLZ6miv/dR6mRkcyn48+pmccCLHg4tXx
	 ji9BWWlX/ZwWFKBX0O11bCkXcR988G8DKega8rok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.9 077/143] usb: dwc3: pci: add support for the Intel Panther Lake
Date: Tue, 16 Jul 2024 17:31:13 +0200
Message-ID: <20240716152758.940251384@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 2bf35ea46d0bc379c456e14c0ec1dc1e003b39f1 upstream.

This patch adds the necessary PCI IDs for Intel Panther Lake
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240628111834.1498461-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -54,6 +54,10 @@
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_ARLH_PCH		0x777e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
+#define PCI_DEVICE_ID_INTEL_PTLH		0xe332
+#define PCI_DEVICE_ID_INTEL_PTLH_PCH		0xe37e
+#define PCI_DEVICE_ID_INTEL_PTLU		0xe432
+#define PCI_DEVICE_ID_INTEL_PTLU_PCH		0xe47e
 #define PCI_DEVICE_ID_AMD_MR			0x163a
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
@@ -430,6 +434,10 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, MTLS, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ARLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLH_PCH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLU, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLU_PCH, &dwc3_pci_intel_swnode) },
 
 	{ PCI_DEVICE_DATA(AMD, NL_USB, &dwc3_pci_amd_swnode) },
 	{ PCI_DEVICE_DATA(AMD, MR, &dwc3_pci_amd_mr_swnode) },


