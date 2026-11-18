Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031378;
	b=WmqnohcqdN0uRt8Es62qB4Y8UyVSp4ulAfURj4CNqqKhsJGEgibq9YInMmpkE16xCsbG
	 PcX3WH0IbFjJU+6/GP+WH+51S2o4m78rOHE27QrGE4Zil2dv/OAQ2x5bV+0hNpCNXemaI
	 mW8xXFh2r603RhKm6xpO9VyHxMvfCEI2k3HCNy9rJPC++FwoCPnsMoOOy0jYCZd/CFeNy
	 Nnwr+ufd9aPGqd0aai1cd3hBDXdLQdha2mjop+yjGNFUa6FhUcEGMEF6ET8e8cPa2Rdek
	 0GWiRQSJ7q12SaaCABrFTOiLPXhkktispFnV8pVC0zoa0LzYupaSrYY0oamkD6wNO9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vtSXfUX9TsgwZMu3V/32L2oI9FFBL5mKsRFihNal1c8=;
	b=l9+ov8Cg4yZVHNeXNVVXEMmBukMlZb1PEB2THkaCck/u5wbxhy43zAHAI3kBoynbYdSE
	 2fi3DLzVcOhWDsyHzyOO90qcQfTvJQdOM4l+j6pZIKZ2vZT/YGNqo5U8S4H+EHcrB109k
	 klENWG69IVmK2piw3smcSExLsBNSl5iA13w5t8/Gi8XRToOBgHtxrLw/dVVn6soKGwRlx
	 UBB65oklPLGa9LW4qw/I435+vF8iVhWdRN6E4hRXi7LaJWk7yP3SP8McyLHy4kmxvZGqs
	 qFFvhHo7XfyEcR8yhmb1n/RbY27CdD9gTiyU+o76huOeeoiOK2lh+NgTseaHRe73k/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dxrUE4jJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BF5606A337;
	Wed, 18 Nov 2026 19:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dxrUE4jJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDAF1F000C4;
	Wed, 18 Nov 2026 19:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031377;
	bh=vtSXfUX9TsgwZMu3V/32L2oI9FFBL5mKsRFihNal1c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxrUE4jJxnZn1t7SlszXFRjH+vId4KZPVGejxmvvFSgLwdXqFyrxouEwtr8xQJcT9
	 LTditnhX7udl8B2Mx8JvESKOxX99fZLLxQgyLVLNOzor7QFfeTEMgYU3JMJznFuuSy
	 vQqIdPYcEMTQkTq3UwqDhBUrJ5Bj/If6RBE0G6Kg=
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
Subject: [PATCH 6.12 1037/1756] PCI/P2PDMA: Gate the host bridge whitelist warning on verbose
Date: Wed, 18 Nov 2026 15:52:44 +0100
Message-ID: <20261118150051.345053115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 3c2aff7a48a22..01c8b79a9e0d7 100644
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



