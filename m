Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EBC39A26E;
	Wed,  3 Dec 2025 16:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780809; cv=none; b=HlKB2On5hGVZ2blEJNl4jlIDygNTsmlwniGZrUaQKnjANfFcHdd2j8e+aCqWvHqe9r5xJY3rVzhMfV3CyiqbbskKXtGI1ZwdTx0trs8cOlCg8+7MGpEh+8PhLCcozqJu0Y45QT8PBwxJ73V1/RPHNGm/tQvQIxrNNTTnN+Dfq3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780809; c=relaxed/simple;
	bh=sOCK/8ZTrXhPYh92up1fLHDJL95iFL6E7IaSN7N09bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeUxOme+C8RT0qFh7VCIo08OoDL/Bwkozw8VRwHDiDW4Ff5rugeXgr6dl4Urxi39Aagg4FJ63sjgmQbmIaKnHeXVjhpGV3Qsq7q/3lkJmR2JwNA4NrQi3Zlryf5DErsObIGjvVHv0XNvM+UH2JsiplFcLn5LeVs78gG8fnBOWPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3XFWv7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3XFWv7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6A8C4CEF5;
	Wed,  3 Dec 2025 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780809;
	bh=sOCK/8ZTrXhPYh92up1fLHDJL95iFL6E7IaSN7N09bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3XFWv7OWrtuRyfVjSFoSbOlH2ioswSJoohBdNK4e1dL9vQKR0BZh+xsuBkx3zeCc
	 lWPbrQFARy70MjCcYT1tkOGs3UVbZkpDoRpTF24AA4oB5UUzQH0pYU26aG6pDO6LTG
	 8NZ5V5bqB0Pgo+aCJD65Cw4cRr7tY32+M5N+noBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 095/132] usb: dwc3: pci: add support for the Intel Nova Lake -S
Date: Wed,  3 Dec 2025 16:29:34 +0100
Message-ID: <20251203152346.808451726@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit c57ce99ec6cb55b53910b6b3d7437f80159ff9d8 upstream.

This patch adds the necessary PCI ID for Intel Nova Lake -S
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20251106115926.2317877-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -53,6 +53,7 @@
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTLS		0x7f6f
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
+#define PCI_DEVICE_ID_INTEL_NVLS_PCH		0x6e6f
 #define PCI_DEVICE_ID_INTEL_ARLH_PCH		0x777e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_INTEL_PTLH		0xe332
@@ -443,6 +444,7 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, MTLM, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTLP, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, NVLS_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTLS, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ARLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGL, &dwc3_pci_intel_swnode) },


