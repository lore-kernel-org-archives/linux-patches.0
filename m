Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F23376A9;
	Tue, 26 Aug 2025 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208765; cv=none; b=tVs1wNgoG9grdqtO3kol8u0qY60rmuJ1TfY2XPlYhVgr60TOn7STccbG7SkXoRu3byEBVQPdD2G53gCV195HcpNb43kh0M3Tz8lTylwS40fJ1DMFwPzI6sJ0jKLYQ2gbVoOJJkQqVRHgxe1NXDb17Ai5RGOjKfQbqh8wNLVXfAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208765; c=relaxed/simple;
	bh=NziUAMzOdH9cRM4ah7c5U7KhK274yOuyFPZ+JsVq85Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtD5M4Ii/2T2k5ZNhmpY9FrJxzjrKTXHKnukXRRarZFuA9XQ8T30IJvNUmweZFmxJVoEYnKvteM8GEoxDZXlf4BBJgbMlMY1QdaXn/uGHpGJO2NClgnAKkvWBCsALpD7KPhF8OMAC+9mW/aaObWpW1zY1HSIf7RhJqhyE/e10sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEGpAdw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEGpAdw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AACEC4CEF1;
	Tue, 26 Aug 2025 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208764;
	bh=NziUAMzOdH9cRM4ah7c5U7KhK274yOuyFPZ+JsVq85Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEGpAdw943Z6n2J8ggSpNOEKCrjhhLi8UCimIG/7y+OIApAW/MBrMlGqZGdde5P7J
	 bEFBJZ11gNJvfstLeLDcg8Omgg0XEK0OWJZhbg0yqt2iGXXzkbtgxGoC7Ib9z4JXNZ
	 Jc8HHqrMfIgMbbSq/noy1p42t2q2Bb6spFB4lWVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 235/322] usb: dwc3: pci: add support for the Intel Wildcat Lake
Date: Tue, 26 Aug 2025 13:10:50 +0200
Message-ID: <20250826110921.707226692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 86f390ba59cd8d5755bafe2b163c3e6b89d6bbd9 upstream.

This patch adds the necessary PCI ID for Intel Wildcat Lake
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250812131101.2930199-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -41,6 +41,7 @@
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 #define PCI_DEVICE_ID_INTEL_JSP			0x4dee
+#define PCI_DEVICE_ID_INTEL_WCL			0x4d7e
 #define PCI_DEVICE_ID_INTEL_ADL			0x460e
 #define PCI_DEVICE_ID_INTEL_ADL_PCH		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLN		0x465e
@@ -431,6 +432,7 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, TGPLP, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGPH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, JSP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, WCL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADL_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADLN, &dwc3_pci_intel_swnode) },


