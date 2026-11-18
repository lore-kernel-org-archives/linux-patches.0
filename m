Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043036;
	b=mGY1XY55xznKjMFjW4BC56BcgF4WhtH1Sz7qWqDapOquCUiWB4ge9mP/Z/FD/brO5VT7
	 dISvrskJEXz8Yjq6TuDM+OVXoK/C35xjRO0wqhziZ3CF1Kx40sohIjHKfsWrNIaR3/NXC
	 8TrHxa9i5DQs9E/Vs+Wl8cs37t6vvneW27o/O0O2Dx1fQpRVkTdwu9YCJ8sXJDz3ExGdd
	 Z7ap5PxkvexrvoBX7RZxWbkpm3j1LT9Ml+k6Hw85iBIP+OTV5R7SizRJUTctt3zXPfUEw
	 lNXsLdUXVveU+uZaium8rfmIHNlGw7w76p6bNHz/IwabQzUlVjcirNjSZhe6jsercxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iHfYwPA3FqFuu4iAM777jj/XtcPG1I1bcFudLVARo9Q=;
	b=4WwGuWNSUqPMa2SzSbfEwOKXOWVl56v+YW+v2EwYqSn5ZQBEELZNhyvmsMrNHGoeTpJC
	 O26Q0qtoLjnAONurxmjsO5+FJ16De2R6YzYMl0R5lwUjm6LUaezdIAnREBcNe+/CKo2Nx
	 Jb6bNYzA2oqFDXUIXCwNsZksp9DKOPksUpVdAywGLeo+HwIgUvCRT3w007C37nV4X39u1
	 UckvA3+Ik8o9jb/7DngZRw6z32dNIQaBOyMIVMCR5e4KTV3HTqHImzuMjC5+C+UsVBnUy
	 kZw5KN5Dv65lNCcS5aDUuFzVh66d5a+Gufj+q496ABF8bJcTyyIToh9OZpJxCW/J9sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JiBkWE8Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1295460A2615;
	Wed, 18 Nov 2026 23:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JiBkWE8Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD8D1F000C6;
	Wed, 18 Nov 2026 23:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043035;
	bh=iHfYwPA3FqFuu4iAM777jj/XtcPG1I1bcFudLVARo9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiBkWE8ZTpTAelLn0JHecLAe4D52wnm4SOFk18VD1YZrTiGpf7yqvj4oQhQ2gP4cs
	 97kIu7/Uy3BWgD8CJ04HMXt6mxE8ETCaZgAyhQNWzpMnd2yDl8BbrFu/5Duw7OdJ59
	 g/ulO7zxlI8vUFH4TJ1JTfa3SG/W/IxcG/1xCeVY=
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
Subject: [PATCH 6.1 0068/2857] PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs
Date: Wed, 18 Nov 2026 15:18:22 +0100
Message-ID: <20261118150203.770975474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



