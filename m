Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210902;
	b=DhdVEkS8r+5+hth0UJCtPajzwKXu3qhmTU4lRwCa6c/b7z8Ji4IR8Pp/jiMbeDJlTUUV
	 IDRiVsXMuIbfmLVL46x21S1krWuyRFfM24FfJYXkSGasO8bmPHd08aq/yHDjX43BIQVyg
	 mS7J/tBRlzDJ2A3AFELZxCHkOVsB21z0DI9fHMikY5UD2qGi4bHJHAv0VOR5hESANZzWY
	 pzP7/6jcCxH0PsPNgGSArcmpHQUchBZnbqSqKVP2/CGcCtKzosh4S++dcedXe1megR6oX
	 63Vr/Zr/MfhZEWl6GtnxOfzNTOcfwcdDBksJ0DHQQw4Hp8aWc1Qdyo8k6krEmPjSj2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JRbNPq8EZZ/RPhG4hnyQ7PurkRc/opuRNY2EXXZokik=;
	b=THBf2U+c2+MtRfuQzsnZR433wBoSrZ+HeYX+cGAkt62KRe8jVOqCFgHFRdM9IMEcud0O
	 33JMlyXtWorKLn0s2jk2x9WMFumKfXSc1r/rBphApArzxWqmoNQJGZnGPW2h64ja0nt/l
	 UXJx3pJhiQcpzoGnB4I41Rq1jhc0nmYW4X/OpCOIwEVpftSgObShaSbhUQSLw81okn6UT
	 88/sziYH3CrlrkyQHMFm6k/C422OkjRy91mjSJ0CQYgMTWKRSAVblSgag2i0ZQVCXbXe0
	 xDtqjHqQI5voDUAAU+z4xKd+Y4zdRVhqfTXi2RlGCXjYM/AD0v7AvOr/7rBQbren7aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0LuxIm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C88606A31A;
	Wed, 28 Oct 2026 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0LuxIm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CC41F01825;
	Wed, 28 Oct 2026 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210902;
	bh=JRbNPq8EZZ/RPhG4hnyQ7PurkRc/opuRNY2EXXZokik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0LuxIm2ELv+jpIzJr2SvyG8kkx8Em1gfoGy6Fp0EgY22GpGQTrhanVGeVZA0um0m
	 8a42dvMcYfbY2Z5ZuxSuOcIPSFOyQ9CTvJUkNBd0u95+kvVo3Fjl0GM7IJsyvpL9WL
	 zl0vc2w2dPqR3zcsU4qqhy1FbfgeoQ8d29ry6MCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikola Prica <nikola.prica@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/571] PCI: Accept AtomicOps already enabled by the hypervisor
Date: Wed, 28 Oct 2026 17:55:37 +0100
Message-ID: <20261028170012.519446877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ab7e61aa9e5c1..adda41abdbedb 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3637,8 +3637,21 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
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



