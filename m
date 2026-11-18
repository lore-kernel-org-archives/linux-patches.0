Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033630;
	b=ss6rUUU/Bh0JpdqMB2+VSh1nqNIBmh8XclZ29ts8yBAxpKqw1j6/ir00/Tpqdnt6A5gR
	 IKBtB/XZaWsCKKjtWGstV5Y85gKGFZ0kr91FhOMmLI6q2M411AGPf2V/u7qDnkBdw5dhr
	 GnEe/2ILhanry3H41bg9ydq7/06fJ2pWr1MGYgVof8KZRSVQm6gd/VQs6OUJz4oQgXN4a
	 1aZZ6Y38Dx1DiQYALKWKiivEOJrviQpFgtWM1JUZBSQ0nd28XjLzCY8X21RGE1jRjBWFW
	 MBO0UONq6Tz6+dy7a7BKjtyF5SweMQb/VzYX5B9t4vyAdaGkODAOR4L5XJRa7tFvkWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aZcYcecsfyjxjWMCGXIKRZCczG0A3BPpABpPonc0/n4=;
	b=utVnEkVF0gb6EaUQGgXKgBPBXa1BfEsJHHknI6LVtgy11Cx0Qfr/XOV7TlrnhNZdQNE6
	 aDDJ7hwHKWgobcrrsZbrxfLLVDks2ZzmmFmuDIy7Zc8U8n1Dbt9tDblG2R53wkDSa7xH8
	 ux8W1b7PCwsbZdjGwmOPoYVuW+6JFkRAgkQjS1CuyFdDIgTp/su0Z+OfE9+U9+H6yHvQQ
	 oO4B0Oj97RD6B7g/uGZcOqJdLZYRF8To5wslNXpcqXxEj7b7TXbdzea7jigt1jsfpj+l4
	 Uy1JH+Tr8FG0IdklOKCQ8rztPFDPdGJfZq4EU1PgeUQdPjGnsIsMB5dVNFdYNi/cDVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4spiJTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35970606A325;
	Wed, 18 Nov 2026 20:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4spiJTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934581F000C4;
	Wed, 18 Nov 2026 20:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033630;
	bh=aZcYcecsfyjxjWMCGXIKRZCczG0A3BPpABpPonc0/n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4spiJTwyGTlf3yT6bEw7qIAX2okErp3dAtheh0dHU/rsbW882rD3yS4IPkzj0wPh
	 +23Bho69mp4p97BMs+lePTLKBbJq4CwmXSqoxC3EfkDRPk4n0yZ/UsYk7cHUDjaiT+
	 mT5eH90WJxST4PY6FV33AJ22eJdzb1av6YyQXjmQ=
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
Subject: [PATCH 6.6 0084/3318] PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs
Date: Wed, 18 Nov 2026 15:11:46 +0100
Message-ID: <20261118150316.628192810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f9cc2e10b676a..b9edb2239c2e7 100644
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



