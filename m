Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B7E3B47FD;
	Mon, 23 Mar 2026 15:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278341; cv=none; b=GTtMqi9tb/qXu/msdzZDciVUre6yHgY8mdA2C6vHvihmS8NL8bMIYAg5T8SZTM1htCGka/ti5BNYNHJAPNWUJmnOC7upE+6LMbK/rvSDerJTuyn2rEf/ZZDRbygf5nS2BTlWnJP8nlvLxWuQMPDnIU492KCizxW4NvQD2YjaQFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278341; c=relaxed/simple;
	bh=4Wa2ArHuaLpPhUyMhXoj5lCTFkinANR93ZxxpBf4vJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jONFQ9GN16tR/UzGBCoZz7w8OoyiaZ25hLVwEIMg/JtCkGXEYpcEdmm7OmgoJjsP2etspCuFVlhNwth77RZh3Z6j/frqi7m+yFmitNe5qoQWyg35NUVvWHIuxEomRCkPw89WS2syWZsGfdp3D60T2Bi5VAmbDrULAQpnpe/W5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hrp0nUYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hrp0nUYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B9BC4CEF7;
	Mon, 23 Mar 2026 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278341;
	bh=4Wa2ArHuaLpPhUyMhXoj5lCTFkinANR93ZxxpBf4vJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hrp0nUYHtoqD2/fhssxtJb0E/zi8y5rcuZ0Ba4azBAJTpfWF5tqII4FJoRmxf1eRs
	 FWmuf7rgoGX7+X2UPkYJZhIl6wAxGszmF1i2Eeox0+YZ6aXXC6MaHaMMgU1zlrLApG
	 ITboDDidn3wB2guqlNeQadWwJLRt5SK9Oc0CIQn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 275/567] usb: dwc3: pci: add support for the Intel Nova Lake -H
Date: Mon, 23 Mar 2026 14:43:15 +0100
Message-ID: <20260323134540.631168379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

commit 17ab4d4078e22be7fd8fd6fc710c15c085a4cb1b upstream.

This patch adds the necessary PCI ID for Intel Nova Lake -H
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260309130204.208661-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -56,6 +56,7 @@
 #define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
 #define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
 #define PCI_DEVICE_ID_INTEL_RPL			0xa70e
+#define PCI_DEVICE_ID_INTEL_NVLH		0xd37f
 #define PCI_DEVICE_ID_INTEL_PTLH		0xe332
 #define PCI_DEVICE_ID_INTEL_PTLH_PCH		0xe37e
 #define PCI_DEVICE_ID_INTEL_PTLU		0xe432
@@ -448,6 +449,7 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, CNPH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, CNPV, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, RPL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, NVLH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, PTLH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, PTLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, PTLU, &dwc3_pci_intel_swnode) },


