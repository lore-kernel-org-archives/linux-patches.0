Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041191;
	b=awY6GIZMOXEv5GB2a3LU5SBriHUS2yPOncdTTyz8vxAMJb+tByNPK0ACOeNlDpNYD5we
	 ZN/8e4BTGQmp+YnuPfUTXqNa5X2Gt2hFfciwiP0tIHkP//YIUernSNbGW1V9hNn39zzg6
	 dgWmlp4833O/Ewz1tyhs8TXcSzUGfYTCNDN/uBd2HVCxLPtc9PXnKwWq5O3bmgdyeZlA8
	 l6Aq3f7ZjWlF7+5c9sI/sQV/VzCGKPsS9+PlQD+qo7OUqJ91A6xSr88c9MExhXRrbW+c9
	 PffXf1OVJMVYiTy/aZEoWrqHeOLgaidZg87J3MH5LtJOUU65ala/FXB/lNz4Fvh5/Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ChcgCVHhcp5piFGVaDi93jP//1kR5H6sDd2W3u9QsQw=;
	b=r79Y8pgw7xNReBhqJaVTueUSj2JbiuIaHNKHFJVkPtAa1oDUBSMDZy9PiA9hjPiTLiUk
	 8jeScqQpQLPVU58DpNl3GJesiYLVcgzKPEidURTkXY/aQjw0bz6F6V0qlkeZpT2Hg4zIx
	 Dgp+jltp7xKx4UqDCb03qs2e4LzDRPaaLTnNxz6tIllXjh2D/gqqj1Vxk3Aq96mkQf8sE
	 v+Xh8ZIOt6/QUH+fhSR88+1PEcLfo9TPk7nfmWCb2JPJzzCBiWxhQUZOe124SaIF6GUft
	 sQNMtpDDrOtQmY5Ws+cIRjzyusGiM+VLC6Cn5/s4r8v2ilQoLWRiyfIbL/Mim/FCU4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuO62j2M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8399606A325;
	Wed, 18 Nov 2026 22:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tuO62j2M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CED01F000C4;
	Wed, 18 Nov 2026 22:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041191;
	bh=ChcgCVHhcp5piFGVaDi93jP//1kR5H6sDd2W3u9QsQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuO62j2Me1Zss3KrzGZT3SAeAaRVXyCEB1mO7ICkBOJCprv7s2GCXPPSNKb9EMXbw
	 yk9oUVMUJKfXTY/arWQTnpYOKTkg/DZ8lf8x/gJHJ4XMACTxkfyc3XVUmzxisO4ca6
	 PRfQeTQuKCYQCWYdT6Mgb+e7C8mp2NXZ72cJ/sMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tushar Dave <tdave@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2726/3318] PCI/P2PDMA: Gate the host bridge whitelist warning on verbose
Date: Wed, 18 Nov 2026 15:55:48 +0100
Message-ID: <20261118150442.613575586@linuxfoundation.org>
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

[ Upstream commit 36038f0e8377ef316b723d0d85b1510bc64069ab ]

calc_map_type_and_dist() prints every other diagnostic under its verbose
argument, but reaches the "Host bridge not in P2PDMA whitelist" warning
through host_bridge_whitelist(), which it hands acs_redirects instead.  A
caller that asked for a silent answer still gets the warning whenever any
port on the path has an ACS redirect bit set, the CPU is not whitelisted by
cpu_supports_p2pdma(), and the host bridge is not in
pci_p2pdma_whitelist[].

pci_p2pmem_find_many() is such a caller. It sweeps every device with
published p2pmem and asks for the distance to each client with
verbose=false, and pci_p2pdma_distance_many() recomputes rather than
consulting the map_types cache, so the warning repeats on every sweep.

The argument was never meant to say "ACS redirects were found". When commit
cf201bfe8cdc ("PCI/P2PDMA: Warn if host bridge not in whitelist") added it,
acs_redirects was a bool pointer that the quiet entry point passed as NULL:

  if (verbose)
	  map = calc_map_type_and_dist_warn(provider, pci_client,
					    &distance);
  else
	  map = calc_map_type_and_dist(provider, pci_client,
				       &distance, NULL, NULL);

so the argument was true on exactly the path that commit describes.
Folding the two entry points into one verbose flag turned the pointer into
a value and left the call site alone, silently narrowing the warning to
paths that carry an ACS redirect.

Pass verbose. This also restores the warning for a verbose caller that
takes the host bridge route with no ACS redirect on the path, which until
now was told it could not use peer-to-peer DMA without being told which
vendor and device would have to be added to the whitelist.

Fixes: d1b8dc09dd71 ("PCI/P2PDMA: Simplify distance calculation")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://patch.msgid.link/20260830-batch-p2p-fixes-v1-5-5044e8dfbe2e@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 560a776188479..ffdf4360fdcf0 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -578,7 +578,6 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 	struct pci_dev *a = provider, *b = client, *bb;
-	bool acs_redirects = false;
 	struct pci_p2pdma *p2pdma;
 	struct seq_buf acs_list;
 	int acs_cnt = 0;
@@ -649,11 +648,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
 			 seq_buf_str(&acs_list));
 	}
-	acs_redirects = true;
 
 map_through_host_bridge:
 	if (!cpu_supports_p2pdma() &&
-	    !host_bridge_whitelist(provider, client, acs_redirects)) {
+	    !host_bridge_whitelist(provider, client, verbose)) {
 		if (verbose)
 			pci_warn(client, "cannot be used for peer-to-peer DMA as the client and provider (%s) do not share an upstream bridge or whitelisted host bridge\n",
 				 pci_name(provider));
-- 
2.53.0



