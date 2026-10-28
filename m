Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208610;
	b=4cUwGey4IzBFvzG6QUB2CGDsFeRLGJgzPkq6IiQdVwaPgFCGgjGK4vgn7G1zeGXNfJv7
	 ylzQ47ZfLcU3dZV0cVTF9Ml+XK8yCOetI6tQ4vvvQLZaXusu5zH2w58VRmaVPakbXzZCk
	 is/qOw8mFLMdhIT1vWHY8uFegP/kZ1EHHtnJ5c8J63xy1TRqnfBcYNEML6Af4zvSqrz1y
	 za7UmchBUQRzukffdQoKDXkgWA/yYhWo43ge09QXYU3COlRs+cyjCTG2aR32f+Dy20sk4
	 0aJsTAuaUHZRMMz1cHADAa5ECw8qMz/ygUp0I/TGS3W0FkaMQ/QrXgfj73uq8fIlsTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Jxh+ZSpYmlOtec818goJa/A97WHxGgTT0JECMN2L/+o=;
	b=gETQ3pFjyKXg01uXdn1xiOKFP7kJTeUMQ0vuRPBt6e/e5EgYNFjQWzQ/xSWi6Q3zNh5U
	 rqkd4XNBNXiXmOixRX2voQdji4AHaLBYoQ3oTEGa7qVVThmcOA7H8I+/zYUIX9sOcEhHP
	 cTMuPAR4yM69eq0/nMFty5jQmK0MHmsnx6TXbu+qlomWw0EMDegQPE7KPico4iH8s+GvZ
	 aCSjjv9q3gsuHsGniRKy6vsfdQ7wXDAz2zE8x/GiT12vVPdnv1xtCxUWskSU7E9nelxzw
	 MdAfW2n7a0oY+vkD+4AyvSouln/tACB3++VGEvCPQ72bH6SZUzoDsMVE3ALhP2oj0Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iyo3+2kB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1902606A322;
	Wed, 28 Oct 2026 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iyo3+2kB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024B21F01825;
	Wed, 28 Oct 2026 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208610;
	bh=Jxh+ZSpYmlOtec818goJa/A97WHxGgTT0JECMN2L/+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iyo3+2kBd+N1Nz7QnIJ1nBzLFXA+Kue//wtTRnv5h9ysDYKhCI97KAx4Qxvs5IL7O
	 iamJSa31iWKn6cTTYW5UpnxoDK93ukTjVVI8PfIjN7o6l7h9m5bBpCAFD2EzNhwWo1
	 oybZjAsuU8hkQLjZrrjQl4ZPIE4omlGyWtVvFCLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikola Prica <nikola.prica@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/516] PCI: Accept AtomicOps already enabled by the hypervisor
Date: Wed, 28 Oct 2026 17:55:31 +0100
Message-ID: <20261028170007.745553674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Prica <nikola.prica@amd.com>

[ Upstream commit 40cce45b921f7930886bcba43069edc579725457 ]

pci_enable_atomic_ops_to_root() currently fails when no Root Port is
visible. That is common in passthrough guests (ESXi, Hyper-V): the Endpoint
is assigned to the VM, but the Root Port above it is not visible in the
guest topology.

In those setups the hypervisor may already have enabled AtomicOp Requester
Enable on the device. If PCI_EXP_DEVCTL2_ATOMIC_REQ is set, treat AtomicOps
as already enabled and return success instead of failing the Root Port
walk.

After 1ae8c4ce1570 ("PCI: Enable AtomicOps only if Root Port supports
them"), pci_enable_atomic_ops_to_root() always returns failure if the Root
Port is not visible, so drivers don't use atomics when they could.  On
systems where the Root Port is not visible but *does* support AtomicOps,
this is a regression: prior to 1ae8c4ce1570, it enabled AtomicOps in the
endpoint and returned success.

Fixes: 1ae8c4ce1570 ("PCI: Enable AtomicOps only if Root Port supports them")
Signed-off-by: Nikola Prica <nikola.prica@amd.com>
[bhelgaas: commit log, code comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://patch.msgid.link/20260921111903.978687-1-nikprica@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6658bba9717d7..9ebe741e23938 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3598,8 +3598,21 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
 	}
 
 	root = pcie_find_root_port(dev);
-	if (!root)
+	if (!root) {
+
+		/*
+		 * A hypervisor may expose a topology with the root port
+		 * not visible to the guest.  If the hypervisor has already
+		 * set AtomicOp Requester Enable in the endpoint, we assume
+		 * it has verified support in the root port, so it is safe
+		 * for the driver to use AtomicOps.
+		 */
+		pcie_capability_read_dword(dev, PCI_EXP_DEVCTL2, &ctl2);
+		if (ctl2 & PCI_EXP_DEVCTL2_ATOMIC_REQ)
+			return 0;
+
 		return -EINVAL;
+	}
 
 	pcie_capability_read_dword(root, PCI_EXP_DEVCAP2, &cap);
 	if ((cap & cap_mask) != cap_mask)
-- 
2.53.0



