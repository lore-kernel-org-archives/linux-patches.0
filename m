Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057340;
	b=4uk1/34av6AkSIky6BCc53I7FPJuu0P7nmJpxfbiq+s9mxNTMZ/sY8vGtwPa8oa5aSxt
	 dlHa1nWaxnBj6QMMrYVDYKMZ47yto4yOsGRJzO7b8NMxqi4JbP27/n0adHX7gpco8TnjL
	 65GPm6Ylf/ChK3G3O1+ImILBJ3OvtCi5cJ4fxLQV6GJnm+tL1CekURzkN+EtSVCICfz02
	 WDdhT02GqbbYkvMGLTI4bPV29f33VMwwDbYGvQndLtiOSCaXylLu6l7Ane85Wk82aJqQu
	 tK0A3RMLokFcYzHIboP4Tzli1PCrbdKNVPUD5ciLas+BzS/jhabWyDlD1W84eoIe6vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BB/L+5NTFU/JMN+5b+Y1drjSYsUmx6AlxvQPMPi0UtQ=;
	b=Dv8B8BJgx+qEScaX80oDHKdRSfSBnDsxQ8MdvOXU0D6UfD9K9W5zViyrjwPa0FXTbp8w
	 PSDNWWFt9ycirrcmGfzRbjMOsxFjYffWs9YbsLUJQbUNZJxtOyt62iAXAaufmu//yzLjt
	 BsFVoTfO/n8j+4yC3xUmpmMTPYGF560AMj13UfhP4BK+foCiuau/0dSXQ5Exo80eiYNKX
	 F6jD9Ej1nK1Zq49PfsO3+IGkHymZjhXl1XiNnxG2UNW6rCLTa7e7OdFxHW3Ameea+iA5V
	 +vGRzU4MDkcK2/VtQdTv0zvzzKC4ckOtM/R9tH5KiWGBK2NWchLz03ADJWpmLs1NgCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SAC4vKnt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEB460A2629;
	Thu, 19 Nov 2026 03:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SAC4vKnt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA10F1F000C4;
	Thu, 19 Nov 2026 03:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057340;
	bh=BB/L+5NTFU/JMN+5b+Y1drjSYsUmx6AlxvQPMPi0UtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAC4vKntHGZOPxWmACeukiE+VMlOnW4WmWSOypUlLjnuSw/mDIW17Rbsl29vUITeo
	 yWd0UoSeEA7sre0eEUzH/M7JwdgcQAJShLEWR9rxXlda8JRjEymxWuRX5CVW0bz5TQ
	 lCsnup4ZAIceEXfPgHQnAWHJiCKzWzMmJgLavucE=
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
Subject: [PATCH 5.10 0055/1848] PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs
Date: Wed, 18 Nov 2026 15:34:53 +0100
Message-ID: <20261118145913.417157580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d3719407b8b9..9d8d3b8feda67 100644
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



