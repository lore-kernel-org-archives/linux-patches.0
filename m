Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049439;
	b=pELPdHVBKhRWrvRZ8mw0q4SXjKVbdbX20TF6Qk/ajlAWD12SG2hPUMQIyX7oOJACv5eW
	 ay9dYdnsxqDujy8QsBz/C4jdaMULHZA7b+PQqIP/4YK8AWokw8TcmUBqemqLYUOmkjhhI
	 rqnJr2fzbFoRvzsthv/MT4/dXcmVirzU4/bCVbCKuXb5psQkdj3VM7SZ7OBgQG7wPfA23
	 DafZTRJ3yBtCw/MDYHCm2Sxp0Drhwo4omHWvslz4KJeGA4Kh2Hqv/OfhniwG9t+DWEkK1
	 NYSziPmoK8vQ58JpUo3UswINmMv6WGQwZHPINpuof8FBHZZG4/D1wN6Sx7g5HYwevtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KFqJ8KGWfvQYt4/5S9vrOqgzxup5e1Zo+CronoHw3k8=;
	b=X6ajIZgfZkxzl6ZN2sL7B7Hd0zPaoyY8AuLHFeAKPF1+KU3NTF1DcoxPW9O/+WssiFup
	 GKLhvPlmt+FO73+3/dAqlZ2QAGVVQvBnhSWRPwV3vrQXlTldFZpjtZyrVtZcO16i/+tww
	 KC8pCtYUs4VYRvjDmZwj9yBuB51zvdwMdKpsuy6PT6CwEjrJiVpOFXtOQK31E+2UlHxBX
	 R3Md3qDp1gSXPs2/n/wW62DtI7kw0rd21ujB+vdjxLmAH8AyVBS/ZyOVoJo7s7f1bC0Le
	 EiEdOv0tj7HL4Sww2XZwOyp/B/XALyIqAgAxgrHko4+ynRU61jcuxBUlGqIeZK3JWVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jk1KNVN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B9E606A325;
	Thu, 19 Nov 2026 00:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jk1KNVN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EA41F000C5;
	Thu, 19 Nov 2026 00:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049439;
	bh=KFqJ8KGWfvQYt4/5S9vrOqgzxup5e1Zo+CronoHw3k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jk1KNVN0of2ZBfyU9+LCHW+2zap8KY1lTLMX0RhHNliq9BbSPxiwytchKJe2hc2j7
	 3IJzEaRjSTXbhVwF5y9VZQWOymMa9IoQ+GamZyVnouUQV22nkwDRGooCgSKCbTHWZL
	 TZdKu+h+1H+j8sn4Ljk00tQZalMn2drDQAUKzVOU=
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
Subject: [PATCH 6.1 2351/2857] PCI/P2PDMA: Gate the host bridge whitelist warning on verbose
Date: Wed, 18 Nov 2026 15:56:25 +0100
Message-ID: <20261118150326.174327927@linuxfoundation.org>
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
index a4210960bba10..7585b4cae3ea3 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -452,7 +452,6 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 	struct pci_dev *a = provider, *b = client, *bb;
-	bool acs_redirects = false;
 	struct pci_p2pdma *p2pdma;
 	struct seq_buf acs_list;
 	int acs_cnt = 0;
@@ -523,11 +522,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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



