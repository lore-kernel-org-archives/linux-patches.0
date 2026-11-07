Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064601;
	b=MDlvjfFer6XGP5Ol6nVeO0S3dbdqPL37jggLEdBU43KJrOaIXbHTx52FgT4Zgr6vsrxK
	 watySWYH/u/6cHNFrMxHHSwYh8sgqToj4qvRrHyBuRQQX2CaxMp/p4EUBJF3rNmxjs6Z2
	 TaecPebq9LxHOSdFIcdxlgDibhhQfkzIBSkgB4/DQfsMJ+aEmi2EDyELDOsY8zCaeAC8U
	 003T9pQu0Oy0rbTv5tem7kUpaQH1VzJ2rJZWCkgxLiP39oyFb9o18NZnhDC8Qb5FS8mos
	 9U4grhOQ18im0aBWUR4RQDZmhSo0ajz0aAlg0jDZc7Zh58ZPPmhBqH/MYmkEVru7ovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0KkeB497N5ZuE4hJU0XFbBUOszCPVzixH+x8G5au9M=;
	b=u07MVyxX8DEuzIdoDANjf128xlkdYPHGRpCVwG0tChgcyVrJm6oJpSS0qhSNDkc0utoE
	 MFwzDNv17BmvgqbXN4ewR6m2SQlGrxASlF1OUUJ46NBpsNd8MtMj0gACfJKrHEwYgbAFa
	 +jUFmTwnfwWqfn7W0sVCK/2vTf3Uois5Dkz0QlA9MLyzt97vgzC4Eztz+Z0NsYUKKMms3
	 UJ2TV5Ks7DJKXpxHdGxB7+3rf9JM8mtv6T9mCjzoN1HgS9iZ1W610zhNbtOnfwBSn7hV6
	 kLrpkNZp7VUFlnDfjIqx0eNbpRo4ymOq27YFb8VeFjHIXRbB0iwnszgVObhERmv7h7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlOpdyNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9D0606A9D3;
	Sat,  7 Nov 2026 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlOpdyNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC411F0089F;
	Sat,  7 Nov 2026 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064600;
	bh=B0KkeB497N5ZuE4hJU0XFbBUOszCPVzixH+x8G5au9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlOpdyNdIyZVdKd6XdRsy/1NxlpicevD8XpkZ7pF7wTDsa2y6uJP5X2VYxPKnExSx
	 Ky7oLSD/aJNZwd/SO6nt/knkNmD0ZRHimD5oLUj1Nl7+mg93dfXIE126rzYdUrMCaP
	 W0TLUiagCR8dmLNoMufVT3es9FbPpjdxhLzni7kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0613/1257] cxl/pci: Use the Device GPF DVSEC for restricted endpoints
Date: Sat,  7 Nov 2026 08:48:29 -0500
Message-ID: <20261107134956.236778733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 9d807c1a002ca..e31aad7a525a2 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -804,7 +804,8 @@ u16 cxl_gpf_get_dvsec(struct device *dev)
 		return 0;
 
 	pdev = to_pci_dev(dev);
-	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT)
+	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT ||
+	    is_cxl_restricted(pdev))
 		is_port = false;
 
 	dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_CXL,
-- 
2.53.0



