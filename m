Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B90350A2A;
	Tue, 21 Oct 2025 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076753; cv=none; b=oYplm6yywCTWTUHrRUP72w+qa+/i00oe7JOaDrD1Dwi/WVJcQ7jL5CPiT7ddSw4RMSzMKFnh7EzSwTarKBr2RDybV2txgaHr95mpeh1l37nA882FEjpWV6Foq0Ssx2AkxDOyk4PR375JhnLQDIrUQvETlBxi+vFkA+fDe3XqfSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076753; c=relaxed/simple;
	bh=8JHmGjp+BOYTDcsueH2DcALLHfOTo+3x0Wudv2GCa6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrmzBTy3yk3OlVuHMnwtJtRSJTf7QOuA1NwF1B3P+0a60jFqBkg+lO/w7WxPdDj3yoib05cQSxQHwRd+vtzr08e7mxRcWLI1GYGZz9VME4MzVVZnkbBUNO80++yd9FYFSZ+IDC9R6DGy8E+Fg6W7Aq9nQNZ8T3SZ0g9CNnQsgs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTIePF0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTIePF0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8F0C4CEF1;
	Tue, 21 Oct 2025 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076753;
	bh=8JHmGjp+BOYTDcsueH2DcALLHfOTo+3x0Wudv2GCa6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTIePF0u3ERUUO5TRAdOukGUkSjMVAmn09l1kEyKF+7ioK5/E+SBydJtTibsuAV3j
	 W7ymgZ7u17aIuuZgGxNQJSzIu6pFqExdCev7MCXgfgEGL8xbvLcZfHpf641y6B5RUD
	 2+aOGDanY4VT3ZWAH0CmG2B+NtViifnO8lKlUTd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/136] irqdomain: cdx: Switch to of_fwnode_handle()
Date: Tue, 21 Oct 2025 21:50:15 +0200
Message-ID: <20251021195036.628315897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

[ Upstream commit 2a87a55f2281a1096d9e77ac6309b9128c107d97 ]

of_node_to_fwnode() is irqdomain's reimplementation of the "officially"
defined of_fwnode_handle(). The former is in the process of being
removed, so use the latter instead.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Nipun Gupta <nipun.gupta@amd.com>
Cc: Nikhil Agarwal <nikhil.agarwal@amd.com>
Acked-by: Nipun Gupta <nipun.gupta@amd.com>
Link: https://lore.kernel.org/r/20250415104734.106849-1-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 76254bc489d3 ("cdx: Fix device node reference leak in cdx_msi_domain_init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdx/cdx_msi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cdx/cdx_msi.c
+++ b/drivers/cdx/cdx_msi.c
@@ -165,7 +165,7 @@ struct irq_domain *cdx_msi_domain_init(s
 	struct device_node *parent_node;
 	struct irq_domain *parent;
 
-	fwnode_handle = of_node_to_fwnode(np);
+	fwnode_handle = of_fwnode_handle(np);
 
 	parent_node = of_parse_phandle(np, "msi-map", 1);
 	if (!parent_node) {
@@ -173,7 +173,7 @@ struct irq_domain *cdx_msi_domain_init(s
 		return NULL;
 	}
 
-	parent = irq_find_matching_fwnode(of_node_to_fwnode(parent_node), DOMAIN_BUS_NEXUS);
+	parent = irq_find_matching_fwnode(of_fwnode_handle(parent_node), DOMAIN_BUS_NEXUS);
 	if (!parent || !msi_get_domain_info(parent)) {
 		dev_err(dev, "unable to locate ITS domain\n");
 		return NULL;


