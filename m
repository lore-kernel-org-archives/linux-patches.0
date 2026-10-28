Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212761;
	b=3zSgxPw+/rxnu0LRzngSCRfZj+qAj4sWUqK89/Cc3kL6yhm6bRgqJ9C3trWc2jgV78Zb
	 g4p+0PdBKYFvCmz8u+DHj5//2vLTXBGyRLzukC2v3M6BziUwODciQfPD+XE2HOLFn+QhF
	 ZY9HANuHGf62wa+7kOhFwRv/pJ6wL8lgBnAOIR8qCdwQJDSQ7c0i1SrIfAPTGfdpGDK7i
	 cASxvRuj/Xl2i/uosD5z5whDUD0Jj2bo5s9X6bmxk3yDVHL+10Msn/YOVNNoCHK1dyv8F
	 h5I8WIYpj9II9UNFE17oE1o9QqSGvcMZw6ALCT+vmqRm6fdonBx6//085JOyp/gqE+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yUbZ8C8t5+As7OOcT9AMVPJvf9dBXZiWRtoWcQ6M8Hk=;
	b=sjlxyNmkaHmNl5eJoYNvbv7iPrPo6AeX5YSQjpJu7Mz2RppdX7y1q6E4A+CSiFv5TXIo
	 6sFgimC8hDy4IbS6T3OU4Zpr0NDedrW+Nq1MZqRb9Yz6ENjdprz8vYznNqwpZMN/oBody
	 3gnJzjUHimIcD1vjDr1/hUulohOQQuaBT3CJoMSf100EGoAc86SIzhsuMnrRuCtdoUlW+
	 9NFOXmXRzjMLPIV1mJc99wWwDX5GXyLaoRw+GfqLjtP2R2PhpbB2D3mv5Icq/Gunno829
	 p+lTnnDnvbg7F+8wkKDR5SvGBPBrdjTdwhjrQehka2C4VmQm3fxykT9vaTfq7KhrGZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAQmclCE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85CA606A31C;
	Wed, 28 Oct 2026 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAQmclCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157181F01825;
	Wed, 28 Oct 2026 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212760;
	bh=yUbZ8C8t5+As7OOcT9AMVPJvf9dBXZiWRtoWcQ6M8Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAQmclCEPybbf2kFXxo9Z+vVypCWIUsMcextisxNTiKFf0dlLXhXOn5LVmPdXna/O
	 oxgg6Fp+3E64BGxqlSIBrgVSMPTy4Hush5ijYtqVWkVShu6bXhLd7JSfJbiH61SUQ4
	 6qw1EsgpavbnVt62QkDc2SapDT2ixW4ihuqzd8gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikola Prica <nikola.prica@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0250/1887] PCI: Accept AtomicOps already enabled by the hypervisor
Date: Wed, 28 Oct 2026 17:39:06 +0100
Message-ID: <20261028170504.920665495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b0d4c3bc205bf..6e861dd4020cb 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3822,8 +3822,21 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
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



