Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D8B302CB9;
	Mon, 27 Oct 2025 19:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593036; cv=none; b=pHBuqzZZypBPs8aUqx8VzwEY6RhIY+mw8hpPUXg1NY9HqItOvk7MVmuSu+PXyJqBVMbUTrbPcNg+U8uIS06TONRV5LDs3RyGOv47tB0+NdjSY4FnWmKeu62xRRDoT8TxymoQW/YvU/dvE/QBXcNN0h5OTxD0VWQ/93irOH8r+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593036; c=relaxed/simple;
	bh=cSKt53/eBpVsfd5TGSsfqOIZ8QvURi0xrDK98RCaVAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUQ3KW/dgNFGkqXzkgJAp0qQ20AociDa892SUBC4vyDCDurRa01oIs3IdqWiSwiyJWAgU/evHDp1JFsHJQ6vRetGS8HVyGyYZ4YmbNSHf3KEoDprClldHESUaON81p6fEIEn1P3kK06rIBYWiWw1ewJSKhnfyOBUWlT+LhlOGXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrTex9dH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrTex9dH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CB4C4CEFD;
	Mon, 27 Oct 2025 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593035;
	bh=cSKt53/eBpVsfd5TGSsfqOIZ8QvURi0xrDK98RCaVAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrTex9dH/uWMGP6e5y5TOtcmlXy3sNlx1f0JIKZ8tr003Kn4k8dgk77xfut0+tBkQ
	 7yt1OXH3xwC1Qu6aiV0M8LIQuD4mNHDgpHY8zSHc5jfwW13LsbwA/8Ek2oIVjThwTn
	 uuZNmSJtqoEx9/nDerQSZ2oIVkIVg3sN9gODNHP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.12 104/117] mei: me: add wildcat lake P DID
Date: Mon, 27 Oct 2025 19:37:10 +0100
Message-ID: <20251027183456.836404218@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 410d6c2ad4d1a88efa0acbb9966693725b564933 upstream.

Add Wildcat Lake P device id.

Cc: stable@vger.kernel.org
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251016125912.2146136-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -120,6 +120,8 @@
 #define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
 #define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
 
+#define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -127,6 +127,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


