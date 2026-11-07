Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060665;
	b=c/KK1YQDqIwXr4JWYLvOgjXGk7k5kEII46vfsHVRN22OflGPaPtyHfgMw/9b5N3uj9Cb
	 WlbJnKMYrYg6BfYSvC+PLSlLUM/jY9xlhBwqTxsYq4UP2eTiuZBI+RJiweIMumHRvNmDv
	 cQd2ayzG+jF1/1pI6+4Ke52gu0+aBOBzTFS3sq8a72itNkKdSPCdbQ/H7JAram5fyI52t
	 1phD4r5akA0sxDxtAhkrR3lM0EMXDQo+5qEiY4j/Ai/by67hvdnQSLF2o+h3EUACAELel
	 oqFW4xGUeZyAWJdgSHhlPm4qfpSNnenJnb2QCUfHMLgVRS7yc7kafm0oOYMniCAOhgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7wuWj8GYCCYn2VPd2lsbYfemS1MLlYzkgO5ajpKPIws=;
	b=UMARdSzrmTx26kQlEXNAxeDt068wG7SIgCSqYoOunauLUiotc0RCJznpOU0z9o5eKI/s
	 cGtWWTGB5mBILZJBnCBjjkbQqllRARX2nuY3I5QF+b4H/Vmg4ENsqwxs4DiuGon+9srGo
	 40+7EyHfPCKmVHCo/hOCl/3XQzSCUNVUzFFV9bIimlAzhGeQAKc6EmbZLRx5BxJVenm4t
	 jnD/92uxunz3XqGEhYL2f2aIXUEaPJtv/sQ6teaibKRrt3fiJYJNqJVara+601+/Pp4gB
	 yDraw4Mdei0z9BlXKyDppKPjUs9hU+Wu4yM4oBd/+P+82Yk0uASPY2HY8QfqowgfWuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHlkOBLh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD34606A326;
	Sat,  7 Nov 2026 14:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHlkOBLh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2971F0089F;
	Sat,  7 Nov 2026 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060665;
	bh=7wuWj8GYCCYn2VPd2lsbYfemS1MLlYzkgO5ajpKPIws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHlkOBLhV/8ReLFS1MUJokizbRu+SgN23m+qPLdXmkc1n7uCpL5Tn0Uq/KbNcgXpA
	 IXG5KfQlOCHCG8nWOuw79oCIP/ymjyCYN91sWiMGCyGft7xLkPLBuGSdGCwhxEPGxZ
	 OjaOtsPy6TSAQPn4ks79WlsoxlHFSy75CiI4TqdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0102/1536] PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs
Date: Sat,  7 Nov 2026 08:35:18 -0500
Message-ID: <20261107135000.535509112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Shrivastava <praan@google.com>

[ Upstream commit 4f2cd6091ac41566a7300f5a4590d20a99aaa8bc ]

Update pci_ats_supported() to additionally check the associated PF's
status when called on a VF. This ensures that PF-level quirks and
untrusted status are correctly propagated to VFs, providing a robust
support check that aligns with the kernel's PF-centric ATS configuration
model and is immune to the timing of VF-specific fixups.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/ats.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index c331b108e71de..0d67ab98e0537 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -40,10 +40,13 @@ void pci_ats_init(struct pci_dev *dev)
  */
 bool pci_ats_supported(struct pci_dev *dev)
 {
-	if (!dev->ats_cap)
+	if (!dev->ats_cap || dev->untrusted)
 		return false;
 
-	return (dev->untrusted == 0);
+	if (dev->is_virtfn)
+		return pci_ats_supported(pci_physfn(dev));
+
+	return true;
 }
 EXPORT_SYMBOL_GPL(pci_ats_supported);
 
-- 
2.53.0



