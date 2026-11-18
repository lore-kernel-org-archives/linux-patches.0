Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041189;
	b=Bc2NfgIVrT7tP8naSgIyGyommerpg0btH2RGR/97Q5DIov2pC1r2P1WLjFZUVyvSPnvu
	 18B4mRsti5hLibP+9aHp8t8t7M4L3ArO+wtDqQKNAiqLEnwWpTuvbwrTELNQ0HT9M9t/Z
	 hJos1qVwYG4IXtMViqgMZj0eRsuqKy41eHXT5+moPqcaNNa/vcNBTWA3OWZv9ARg8fqUO
	 vrkjhiIMm7fo0+f7zlG8QMvOnYaZQx+WX/ZHwOpRwYi9UvmUL/jf3YbXiy6oyuoetl9a+
	 2CP7s0iDHdwWkD1a+MXwpJf4gAcromhDArPnkX429oz5S6K6Hwnw7yPZ0jiK7yDh2fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vwsVWKJ5DxGjjXmRJwSXQy/8yPs5yPAZyUEVcxspRMQ=;
	b=0QVXC6t0eFj8fS+YolnW2tJZ2fUnDkoclFXYyceB7sWD02IORbLXYpl7R20+SdehXUfI
	 NSVQMFsbqDRTEUUu+3DrPFe8ETj6KNGrpCPEXGhLKcahTiWfefzLzW77K9E+oDfoqnwt8
	 hAvODsIguWmD+Buou0MThI9VZ4GNtjcMK5tvT2WSYqZx/ozOjfpO9jwG73Ou/3T1wGu0o
	 JmO6Xqb1UvHbeCDo6cTKWtpjvA3uE6BgEjDeXMEgu0e4XQMHz7xfatm02w/qUOzZWKEDL
	 UM5eCMnpJE0zdxVjBhemRsiyFZZKS0z3r52UBrvaue8w778qEVgmDz73w62ckAA6nzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1DPW0jVD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97C9606A32A;
	Wed, 18 Nov 2026 22:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1DPW0jVD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0821F000C4;
	Wed, 18 Nov 2026 22:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041188;
	bh=vwsVWKJ5DxGjjXmRJwSXQy/8yPs5yPAZyUEVcxspRMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DPW0jVDxgXdYM78OPtSoADCi2diL5/9iGNLOzfDQGnxBVCL+hjYqjBr0h8psNT/5
	 gXqKYBXBfwsadFXOYkS4PO8OKqsVRyUrIVJTsNThRha5y6AmPmu933hGUlaLZvcBZr
	 oMevXsXH/OXTh58AHovbi3QC/yHp6RcfEll71tJE=
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
Subject: [PATCH 6.6 2725/3318] PCI/P2PDMA: Safely terminate ACS redirect lists
Date: Wed, 18 Nov 2026 15:55:47 +0100
Message-ID: <20261118150442.587876068@linuxfoundation.org>
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
index f97ac18a8dc8f..560a776188479 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -641,11 +641,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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



