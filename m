Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026071;
	b=sgRrs9cudYF34WzWyon46rDYd0YYUO7mN6rmaOgPHr1RYyPJnzvPwW/K9qXM4WwWZp/z
	 xZM6nMkHY1cdweQ+R8R2P4FfcsEWWh3Ct1jjtFEiXR05foMw2N5ATodK7GtbZhTWgObpK
	 jYAfBcq1dqDO4aRpLg4njNqPjSfoOhHrfsHU2I5ww63R/7dIw+gVbQYMnq5PxgZu82pQF
	 ra8dq7Lt4syOEPSCCdyV3d6zaH8nY3ewynQF4zJQJq3b9/UXg0MXOZFkqsiwJSpU1yOt9
	 /XBRiHaw3CecRWwYaDS3lKHfvwycnBpvk8ajHynh3v/Eqv74bBF4tFaWiqaLmv4HRyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QrahTOOWUWiPTi/E8BL4FP/AepDkkiM2XxuLTb7SrX0=;
	b=gmFxh6xK75VFTHWM2CIuTRoOP/mjQ6zSJvj99EcPEWGvXVCvUtBbQEScMJWhcc+QI2H8
	 kL5CR0e6PX2e3HDh2nM1+PZOToAcBuwleHutPyfB542Nbe8ACEhKJY+CuwQ5ki/DNNmEx
	 67nkJ2BIDsXKAnB1WHsg/CwFMR+XhYFNmUjwlIygy8odepgYCO32uxcVAlprmH1wLZIL/
	 r44/4ncOclF4XLmYYnOzFY/lplGPVexwDlgvrifxLraR2G78boATHmiNWZcde0+XJ/dpE
	 AyqZT6yhxrG/te23ZpeOgL967YN8+KpS2sJxvOE1EbiZLGkZ5e2AOqgygE1mCjeaWbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysJFNVEV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852A7606A31C;
	Wed, 18 Nov 2026 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysJFNVEV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FDF1F000C7;
	Wed, 18 Nov 2026 18:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026071;
	bh=QrahTOOWUWiPTi/E8BL4FP/AepDkkiM2XxuLTb7SrX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysJFNVEVlPYoXAhbzWragxJJ0dJ7GsfBp26wPIZCyeykvKci2Wu3R5y0BvNuQzOVz
	 dPhFoRd4tvLUvCZxdat8+RIPPt4Gmt0EylwHGQ0YWz4+0L1YTXqcOu6vwsM8uNY8gk
	 gNYOl06PTte/9nrEX2JpAAUa3faQt5Go2pCpo9Hg=
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
Subject: [PATCH 6.18 1305/2151] PCI/P2PDMA: Gate the host bridge whitelist warning on verbose
Date: Wed, 18 Nov 2026 15:50:40 +0100
Message-ID: <20261118150209.640341558@linuxfoundation.org>
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
index f988178b5d5d1..f4049fc7175fb 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -595,7 +595,6 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 {
 	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
 	struct pci_dev *a = provider, *b = client, *bb;
-	bool acs_redirects = false;
 	struct pci_p2pdma *p2pdma;
 	struct seq_buf acs_list;
 	int acs_cnt = 0;
@@ -666,11 +665,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
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



