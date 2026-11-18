Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022478;
	b=DJw97zlgTjL2OxzS8P4GP0AmGvXjLcR2u4IGXCpMB13rErLfHL6sBTDU8Js659FYBX4j
	 yW9yzAimtvR/gt+gFFFFth3TTcHinEMtuez177zyWJQWaUWrjm0xn/oYwHXIbNdiO6ADU
	 GPcxsc72tMJeBSRB92jc4zkQTRsQzPCwAqtjCUfikPE8ZCCXuOZCLtVfvJ+7wFrwG1k3j
	 NE/SqDxdQxK4qqdNAuRRzAljg0Cn4rrnzDR0cKcI67g0oXq//QI1dkxTt9KtiRhqMCl8/
	 X+CqrsmV6qPYEoLOjiLGgxcjwDQyNW45vBi3diip2jM0qcQAJW9LfzryTYCjFjlD5cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RX0yMBEnL77rIkFFo807FE66nqN1ej0qHFtUmAqKyZY=;
	b=TEWJV5b4TIPfXvz233/clHz7AYC6iLXx9WNs9gfuMo5+zWzLlD9j5VSedj5bipeF1fPz
	 QSg3SQp5sGndYT9QJSxzk7QqN8CNYQ2lhiQEYnIySq8POV3m6xZKjNOkKKTLFN5A+MDut
	 OMjVyQ9PLKOMNfZp1oNH4p2QBdB4gOQKMAnnbeuEP9f/n4HzEokuiIiAzpv5UmJz9T+Uf
	 2g9MOaCiE01tl2q+hISLQ41JULdG4BZQCZ+2qXmklMUTDjUBZhTy1K2eo9IrgPYDtqMTp
	 9tJi2q05xFGDXMYGHsoZf0/hhhkRWaCwLRFoO8jr80ynA0ovPEOFDNMxoGNJknoCujQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlQGDOfo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EF5606A32A;
	Wed, 18 Nov 2026 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlQGDOfo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD811F000C4;
	Wed, 18 Nov 2026 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022478;
	bh=RX0yMBEnL77rIkFFo807FE66nqN1ej0qHFtUmAqKyZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlQGDOfoz4MgOXPuO95m3RgatNyXJ5i4LYII/TkbYtV30G+0fQvDFD5Q2xFph610x
	 0/4+bq9bMDOxGRt7UFr4pFX/CEAQfL1rgWtVEjl+PtprZaCfQwxBbuV79Mr10HKtc8
	 MqhWWCI8skbUjJIHqxTDZS1FToyeEbNrIEqeoQGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0027/2151] cxl/pci: Use the Device GPF DVSEC for restricted endpoints
Date: Wed, 18 Nov 2026 15:29:22 +0100
Message-ID: <20261118150122.641172407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit d2654fa0d841fa36ffa76577f83a2810d643ae19 ]

cxl_gpf_get_dvsec() picks between the Port and the Device GPF DVSEC
from the PCIe type of the given device, and only a plain endpoint
counts as a device. A restricted CXL device is an endpoint too, but
it falls into the port case and is probed for the Port GPF DVSEC
instead of the Device GPF DVSEC.

On an RCD, dirty shutdown tracking therefore never arms: the DVSEC
lookup in cxl_nvdimm_arm_dirty_shutdown_tracking() fails, the dirty
shutdown count stays invalid, and the warning complains about a
missing Port GPF DVSEC on a device.

Treat restricted endpoints as devices.

Fixes: 36aace15d9bd ("cxl/pci: Drop the parameter is_port of cxl_gpf_get_dvsec()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20261008034619.28059-2-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ sashal: Replaced the unavailable is_cxl_restricted() helper call with the equivalent pci_pcie_type(pdev) == PCI_EXP_TYPE_RC_END comparison. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 48c1f3854b799..d2ee7d853f1fd 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -819,7 +819,8 @@ u16 cxl_gpf_get_dvsec(struct device *dev)
 		return 0;
 
 	pdev = to_pci_dev(dev);
-	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT)
+	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT ||
+	    pci_pcie_type(pdev) == PCI_EXP_TYPE_RC_END)
 		is_port = false;
 
 	dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_CXL,
-- 
2.53.0



