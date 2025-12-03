Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928B2398F8C;
	Wed,  3 Dec 2025 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781146; cv=none; b=ll0L2hVsFd5LM2nks0ETw57EiYYptd2k/XFzOKtKdvJD5Kqbxbq+3/t+4fAAaaT23UKEtDllKHofwOETSzmKjQfjTYF06GvmQI22bSpfOAImTMJOBflcWfZOJIWM+Vl0euNAo+iDpmKKBPvN+2f7RBpXx5br74MVhzocJaSZ4tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781146; c=relaxed/simple;
	bh=6B7mUhYJW0Fy0PY0UpDPuesFEf/ZdgxCTJ8lOXBZ728=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ/iMt9KI+7ndOFuS310FQrESJRQcyEr/xgkDQONv0mayVYXzXO0+K3KhOIcrctgtZWtVGQ2jIxit8oF9hXyCzoN3WEIvHKXFXJVUFSreG6twW5a5lZqlkEdWXq1ew43ZD6tAIh82wO45HbDM6w5+0G7S5QXO+hEQyny2zP+sxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hI3Q31OO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hI3Q31OO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7300AC4CEF5;
	Wed,  3 Dec 2025 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781145;
	bh=6B7mUhYJW0Fy0PY0UpDPuesFEf/ZdgxCTJ8lOXBZ728=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hI3Q31OOod8zraxdKaOgNL1KTnKzlzIsfgTh6l7XLqsHnqziEv73i60ArwTDyvHyj
	 YJZMZ/LMqTZ94820ube/M0thGki7kMWt2dLgIfNnq+8OAhEnsaC7W2vTt2hku10qeT
	 JNfHgJndMi0KTDJIgX6lEtLSM4vLGHqvNz3Gd8sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 64/93] usb: dwc3: pci: add support for the Intel Nova Lake -S
Date: Wed,  3 Dec 2025 16:29:57 +0100
Message-ID: <20251203152338.889783147@linuxfoundation.org>
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


