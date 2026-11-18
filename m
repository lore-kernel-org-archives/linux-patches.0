Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051025;
	b=tjXjLGUnmFW43U8aaP0WQxSMqF08kgGz7eU+BP0amcUNC/1wlTSfK5z0kmpu8P2tkoMG
	 K+hfpo3t7nhSTjfl8ST3QMLOFruRmhje/Lv01tynrzyyu3Uu2Kyps/6BBNN9sJQbWBvpw
	 fIh7rHAPV/oTop+N/SVlvqrDK6BWIWWk1tfWKnsQ1pk1TNJVxY+Y+a86+FZZXl3Wor1B3
	 rMxN+VSJxOcyudnoAE074LOnv5NhUqhzuFUGhQMEzOucceWW1uf9b1Y9xcMR7G3VaQ7tS
	 IlvPc57GYvLRUHC9rlWLB2MWfLo0Mwd1GVLmIpqu7hzJRoygitS0+FseQL5rg3BKlOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7UDLP9EeXn2XYPk2fUE9LrAVeBpFoGKgQ6aH8+YgiNw=;
	b=zD6+0VChD+W7aChOqBYkMjqvrubHqzw4mOn/3n0GEaBdGYPU7gfV8iSFnLC60S7whunq
	 0p7smMYybiUxJs0fUbVGm0BWnU2kFVNwrLOCFyqtRh5EZ/fHUbeLDyV2Mv02E2CPW3jsg
	 c98Ovb+E2vWbjpXKdaAvQdyl3YCB6hULessezHmfAtgbQIfMHtq7khSmFVdburoIGo+TV
	 JFTpDogHgBlwsczbHcFIMdMLBnnrW1Z5+rkvF2WLEGXZb+QnUNPoTnGiJ67JMxLboqQ6X
	 xLqyYJwIBk1tSk/53UJEq1o/HMO37w/QbZGYJpclKmB/CSGaWsGGFFBUxytQvloRo7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/AN+FVi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D90606A32A;
	Thu, 19 Nov 2026 01:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/AN+FVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5DD1F000C4;
	Thu, 19 Nov 2026 01:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051025;
	bh=7UDLP9EeXn2XYPk2fUE9LrAVeBpFoGKgQ6aH8+YgiNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/AN+FViCUH6E9fsVXUmp3w6N3WC3XhIV8uNmuxVebWQPlyBS3S/vNFGZ3pfU9JrZ
	 sgp89Uw4X7dUbZXlmsZ1RmFkgDwBaCi3phguZCRxuLP/6CK4ifih5fYNGr8XQkVn94
	 aX8BIE1Km5c4mSBqOn6XWUD++/pfKDsLWzeFZ8YE=
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
Subject: [PATCH 5.15 0062/2214] PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs
Date: Wed, 18 Nov 2026 15:28:58 +0100
Message-ID: <20261118150012.497764587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c967ad6e26267..aa89408cf0195 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -39,10 +39,13 @@ void pci_ats_init(struct pci_dev *dev)
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



