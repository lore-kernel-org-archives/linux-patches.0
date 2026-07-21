Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF573368A5;
	Tue, 21 Jul 2026 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654626; cv=none; b=d9KVAsdsGJ426hTRG9cEd8k44NEC2ucSHHRBGUlJLFgJiDYvGOFZ7kbTXQulNh8RYy3RXisbo/RRTubRvY+OZ1WUCI/pETaSMf59/RWYAnFOZqpCjqsX7X7ghGipWFdBAKV6eENJ5X+32qzuZbt1h4QKQaDeN2nHw/2HmIz/NAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654626; c=relaxed/simple;
	bh=h+bANHL7gq9wLUIaFaQjF+KKNaKGR84SAbi6EytNHGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUulrgYysoEQgdO/sp0WQD5GZpeuOh03J0aywUslyxI5QKjBB9nhFtRcZmiogaECGDqSY7OpNFdtH9THPex6pUHt+XVeVYoPWa2xSRGeWQ3S1NC7Z2V9zd3QQh54DSl7b5Ls1H1lQtrDoO3g+cgeDpDrmo+XTZo9Cfk/mO1ZWCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUfkmPMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUfkmPMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F377B1F000E9;
	Tue, 21 Jul 2026 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654625;
	bh=IkJrHciznMwgs9RMW3S/LcvBOWRvj58EuHKBhRWxVQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUfkmPMfdOnH4lj2KrCBqstlfMZTetObdVmD8EKK/3aX9Fl4qeMDeOQCj1T+pL/N3
	 NYYIznFj+YnmcMNyHiC8M11N2huLuqQZmXHID+XcnpllbBTiG+sfDYrYr5HcysEThc
	 VBgggzerP295xTz+IkoS5lH3aDje/DmoKVyg0dHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.1 1776/2077] dmaengine: sh: rz-dmac: Fix incorrect NULL check for list_first_entry()
Date: Tue, 21 Jul 2026 17:24:09 +0200
Message-ID: <20260721152634.640182658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 5fbf3a2a3b96ef5810e6e0fbc601f82067629bc5 upstream.

list_first_entry() does not return NULL when the list is empty,
making the existing NULL check invalid. Use list_first_entry_or_null()
instead.

Fixes: 21323b118c16 ("dmaengine: sh: rz-dmac: Add device_tx_status() callback")
Cc: stable@vger.kernel.org
Tested-by: John Madieu <john.madieu.xa@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260526084710.3491480-3-claudiu.beznea@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rz-dmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sh/rz-dmac.c b/drivers/dma/sh/rz-dmac.c
index 9f206a33dcc6..6d80cb668957 100644
--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -723,8 +723,8 @@ static u32 rz_dmac_chan_get_residue(struct rz_dmac_chan *channel,
 	u32 crla, crtb, i;
 
 	/* Get current processing virtual descriptor */
-	current_desc = list_first_entry(&channel->ld_active,
-					struct rz_dmac_desc, node);
+	current_desc = list_first_entry_or_null(&channel->ld_active,
+						struct rz_dmac_desc, node);
 	if (!current_desc)
 		return 0;
 
-- 
2.55.0



