Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829431;
	b=2L32++TpBdFzJKJ0N7KPa9p4MbG0W9RNclxN7g3rkQaQFOlYpuyUmYbdWPHj3DwZLqJv
	 CId+OwsL49FD2h9wCnTmAxk8dlFqqeKBLHdDhClwYN1CEB15zoJ6BEpA49Njjs3dPgfNt
	 J/azCwqfTyN4OUzbz/DiP1OzToS2uhzVmVMHXdoxsgG1nWEGoa0RAA/imaIFdpxcQLDQO
	 6T9VCVav+0ihbmDy7dZSEVzB3rZi3CecIF4YHyQfjcVMuoAyPkt6wGDAjvECoWRNY8yFW
	 6GgAFuazH/CPSlGqEtQPNWzbER9xq9I8/5zERYcMubnmTK7oXbi5+niUfd6fYx9sipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eCFc1w2DAfw46qclkgq2/hhyx6n5ojtBFoGDwU08zYU=;
	b=MuOs0e+t0+d3FpAOxsgsfMK7Gb3NlwBDvWdXJeplPCyLmCGsRa20Z0sVjtJURsbPmmLE
	 tL47lSpzZkbof5OpcMWB94xcVwadVT3onGXpmU+NloqS6/Wu+rM3pstxP+hHJskQr28fP
	 b32zB68tutjpI53xOS803Rx5dHNGmOJ7kTcyAE/5KBvZEsdrWNqPmqABTbUV+eAsLwVKw
	 aO2RU7PZXxqygk0GBYxFdBfLzcz0/1a/l/BlmsexfLDBlYfwnjpd9C4w67vS57bMDEaAX
	 f19FLd4ZB8xOgwDGJ8U/K1uMEQAQ7Y4mKsLkGqk1MDKKde9HjoYCTJent2GEpHMKd6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k/kpcDuJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E0F606AE06;
	Wed,  4 Nov 2026 21:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k/kpcDuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475C21F000C1;
	Wed,  4 Nov 2026 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829431;
	bh=eCFc1w2DAfw46qclkgq2/hhyx6n5ojtBFoGDwU08zYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/kpcDuJx//OBaGCwEDK8eY/hsZu0VdakzH6Fb6hRhubyPHo8gA0ymHA2GYCUpq0n
	 5jUag/gq+jQ0PqoiwzdOj3QyK3YXVk3NNpi4iyK58bI4ShHuWirRkFRNl7BPTNCIUD
	 nuRKJFVJAdL+NZRiBPIoZzIR/Bm7Z0yOOW8HHVgg=
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
Subject: [PATCH 6.18 0121/1005] PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs
Date: Wed,  4 Nov 2026 15:57:34 -0500
Message-ID: <20261104211047.057389584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index ec6c8dbdc5e9c..a5fa7745bce8e 100644
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



