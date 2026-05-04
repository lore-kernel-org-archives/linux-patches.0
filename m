Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C253DE43C;
	Mon,  4 May 2026 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904275; cv=none; b=HC/fSTL0/jkDTb+curjvxBmq4CxSf9saLwz5obWcNLC/l9nO0FdAttrzoN/abtT79obJybRp87jQL0zTTEigT1rk5xUXSb4NXDvY++Kzx/lwznl4nXKCBPJVgIncnb7hP8pwgdVGOHeVJiGb71N91xlxnEHKE5d1gkRHTh7+bEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904275; c=relaxed/simple;
	bh=A88Lgn36cFnp6TZLVX4V0MSHC5oXGmsKLkKPseL7YFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QT2cTTCNUTCNnjh/UmIJJz95KvvFCz8BFnMEzKT3KNqx9Y9DDhbAJ7dM5mjlBVzvWigH4K5hQDhkBfcfR+4cik7Na0Cc+cJwqrXmeUSgRWFNVXk8OSfE7NV1DWoVDpalFenJUf7c0cdKwY7f6Rif/dX9rwAbBrSsUBLcmvciGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiRX63DO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiRX63DO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF7CC2BCB8;
	Mon,  4 May 2026 14:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904275;
	bh=A88Lgn36cFnp6TZLVX4V0MSHC5oXGmsKLkKPseL7YFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiRX63DOfFaUO5aViJJASlNekMkLMMZK1vzH23nQzoS3pBMQf8Qn5X1n7XvqqtiSI
	 3So/ji6PHnu5HqIdODyOikHGVbW5lfhRfRCX9Kpo7o4l4rg/ntMnRqRzg3DRbsFAXC
	 UIqeNuwK19AC8PMFZwvv41h/Zr3nAfyg/a99VQVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 251/275] mei: me: add nova lake point H DID
Date: Mon,  4 May 2026 15:53:11 +0200
Message-ID: <20260504135152.364720802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit a5a1804332afc7035d5c5b880548262e81d796bc ]

Add Nova Lake H device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260405141758.1634556-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -123,6 +123,7 @@
 #define PCI_DEVICE_ID_INTEL_MEI_WCL_P      0x4D70  /* Wildcat Lake P */
 
 #define PCI_DEVICE_ID_INTEL_MEI_NVL_S      0x6E68  /* Nova Lake Point S */
+#define PCI_DEVICE_ID_INTEL_MEI_NVL_H      0xD370  /* Nova Lake Point H */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -130,6 +130,7 @@ static const struct pci_device_id mei_me
 	{PCI_DEVICE_DATA(INTEL, MEI_WCL_P, MEI_ME_PCH15_CFG)},
 
 	{PCI_DEVICE_DATA(INTEL, MEI_NVL_S, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_NVL_H, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


