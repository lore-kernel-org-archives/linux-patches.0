Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026068;
	b=wRWlwCt9DfWTgISr8cVdPWRQoN3+T4wlzvAxq9d5oCKeDurkzBkPuI0AIVAejjt7j94q
	 3q6ZqfjrTJe7VRhj+J56KgzKq/P2s/EkhALCEl4848t/2i7I368aEgIhoFmCV4XlZH7cs
	 CMVtrGA20oTTP7fT7tBTv3uibeTc/oV7Oad47uYt+U3yDn3ok4EmufjDeVzDKo6auascY
	 Z4xQrFJGc7Lk2AdT2tJwdEwR8V992ZXFPpR+t4Usb3LTmjHcJfnbBevCREg1uIyzMF0L6
	 dU71XMVSYj8z42zY1noUr+6wIp9WGHO4+AszgBb4MB6vgBZYdIcUs8pDameTdS0YeJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5w2iei0bkl57wjO8gXKTtyecaEcjkx4drB5l2owrie4=;
	b=DfpMC5YI7B/9Oy8vAyhMEJWgY5NRJFAxNyR1b2mDMZOxkxr52atutJyUiu1ncnQwypqw
	 CxuqC8L1d4hsL2a+ks0rp8GBKETDkjmOLl02xy/dhiS8iGz1KWQcuXzGXyC67kD1UScZI
	 ecMM1HS78qt2tHJIcDdzZRgcnXsDJI19DXmEjdfEHhtH+/4BKUe1dpGhbOLwaC0Zd1s7l
	 UmG3wpJ4pn2G+mroaW728ean8TrHphv9wz6TwbUmJwqBOJr/02l/cYrHLK89/7aofcQ/r
	 ttF+9IFTVrg68A3YS5qavgG6ONxBnFtPSPG/yrM2igGkb4K5fRdXQ8aVhNWANYJpJWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6tA9kV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857D606A325;
	Wed, 18 Nov 2026 18:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6tA9kV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEDB1F000C6;
	Wed, 18 Nov 2026 18:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026068;
	bh=5w2iei0bkl57wjO8gXKTtyecaEcjkx4drB5l2owrie4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6tA9kV7Z3jz13tZIvCvbsKlZrGTdf+FOUUtzUGRLSykJElWiWxPwA2vJ+CnV4wqk
	 VfqqHWNL5sZEyXPLah7aTK0sRpyUPV94daIaniDJZrWq2WNtBR22yYZ1NPufQC0lMp
	 xWbeAcl5fI4dGzdEXz0yYyjSSOEOLO2n0ihrBdYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tushar Dave <tdave@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1304/2151] PCI/P2PDMA: Safely terminate ACS redirect lists
Date: Wed, 18 Nov 2026 15:50:39 +0100
Message-ID: <20261118150209.604627743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit fa291d6429ebc1efb7fab011f643b842ae5f23f1 ]

seq_buf marks an overflow by setting len to size + 1. The ACS diagnostic
path unconditionally writes a terminator to buffer[len - 1], so a path with
enough ACS ports to fill the 128-byte buffer writes one byte beyond the
buffer when verbose diagnostics are requested.

Use seq_buf_str() to terminate truncated output safely and remove the final
semicolon only when the buffer did not overflow.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/20260830-batch-p2p-fixes-v1-4-5044e8dfbe2e@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 751b3897ea18f..f988178b5d5d1 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -658,11 +658,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	}
 
 	if (verbose) {
-		acs_list.buffer[acs_list.len-1] = 0; /* drop final semicolon */
+		/* Drop the final semicolon; the list is not empty here */
+		if (!seq_buf_has_overflowed(&acs_list))
+			acs_list.buffer[acs_list.len - 1] = '\0';
 		pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
 			 pci_name(provider));
 		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
-			 acs_list.buffer);
+			 seq_buf_str(&acs_list));
 	}
 	acs_redirects = true;
 
-- 
2.53.0



