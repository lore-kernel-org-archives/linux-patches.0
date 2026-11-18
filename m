Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056013;
	b=IjlN0y3HazGmE1338yJvMMRdo+ISjQJrIF3kVIbEYpKVqd53hGTp46oaN1PGXYJAsrfR
	 ZR/xWDx1x7kHBoTb12K0VDIuW1OjISI4BJdqhIYH6EwWqVWJ4bhmfa94SKjrFv/MrqGWc
	 mHoZg+5N6ah8+nrEToL0e7zL3C7hHQIdTq9qbBB9kksh/T/FNpj7G0kXL4fLy+lV5Gssd
	 q+ljqgHx8ZGZgR+JyD/7UDzLlln0xAQ8Fvx56XNjvmh3wrCw3xVA0PNan6jaAR/W9JSW0
	 q+F7mipYJ7ST7PNFecmHwZxQudA8x8LJwJktb3NNVAqzxtpVXupNkg1phtG1stM7sdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kDAGYVHSzuqJwDkb9kHMMcf8wwrG7Ok9G3UNFHkYv+Y=;
	b=mW3uxefDQdEdZC0/laouTRfd1NhfU6nV73LRERaVmnggbQM0p1lt239XTj7Gi3MeFqeC
	 W36WZKS0pgeDZxYj6+dHPdy0h+1XYXmT1HDlyDlhGJQPR33dXx2ynBHHlIKM2kbyUNTBV
	 oDKxky0Epz522rLl0uXzgfYHCcvOsTkVYFZXFwyN0Sb7G7TzBLE2vGL0E/QopwaSqtzJa
	 oA5H/wemWAD3+NI/1TyHjrJ4RXiYMt1pQa1cuU5M5WUQIxYyRk9YJiakNyJNumwoYabdR
	 wXKedmNoZCkw/GadXoOw10tbWbUFhT1rGQS3xNgOZlRG8FQ5x1iNwRbOO72LUtYvrQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpuoWOjm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE151606A32F;
	Thu, 19 Nov 2026 02:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpuoWOjm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B831F000C4;
	Thu, 19 Nov 2026 02:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056012;
	bh=kDAGYVHSzuqJwDkb9kHMMcf8wwrG7Ok9G3UNFHkYv+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpuoWOjmk9n0lABw8q70H/Gcl8+qXWA7qQZX+vWbEWRwyTAPAsYWT9lmZYNzU5IIV
	 F+mjl0uanwSgeeDBM+4CLXaM084TqMBYZ+O6Yzgdf+8bgc/ClwAsS5oBjxneUz3EPb
	 0TAcYcS4RGKwo4MeH/QZsNYTyAhFiSwT7KXERdKI=
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
Subject: [PATCH 5.15 1836/2214] PCI/P2PDMA: Safely terminate ACS redirect lists
Date: Wed, 18 Nov 2026 15:58:32 +0100
Message-ID: <20261118150124.880841158@linuxfoundation.org>
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
index e70993730728b..1663a8e2c4174 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -515,11 +515,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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



