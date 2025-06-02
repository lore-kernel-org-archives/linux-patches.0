Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF53222562;
	Mon,  2 Jun 2025 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876069; cv=none; b=tqnvzhM5LXZjSH7UzKxaOTZwIK75SRRkKBeLYNFD9D3deA6BqFKSryggH91KLF2CEXwcH1jguDrpBI5B1aVv0WGWs0dI+/lpYY2HCIYzn9oWGiWm0jjEeYjy4C+RAsOO2ffwRYm15ACsnthQLYjUNHicK+Ap5t9EM2c1tA4kH0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876069; c=relaxed/simple;
	bh=wN2Rn46tCfRJexV32qFwLm24fWd2Dw0+3y1zD/tA5F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qv5764tENnPi9B9rSG5Jss7bsIFz8QwWU5Tv0cNkpYjzQF5mrctsnQ2oUChTZ2UdHfrBQ/SL+D6anIFKBnz6z0rzYc1xi0XCgs+vpgJIfYoEr4cNAQgbFsbrlf1YLfFL/n/KcmuP7TRLD6VZMs+5rWeb3fKVYruB+R22m3SejQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekgDzCND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekgDzCND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD71C4CEEB;
	Mon,  2 Jun 2025 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876069;
	bh=wN2Rn46tCfRJexV32qFwLm24fWd2Dw0+3y1zD/tA5F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekgDzCND1pTu7QBcUNGWBK20S6IQQzVn6wnNxTNnlfdpasowoYB1JkYXWoZB16GB4
	 qdbji0hTdPo9I9tXehbasvId6aWEZ2xWl1TqhaXgsHx457/fCQZ1DDSlPEKQJ5VToH
	 I/wfuP0VAkE9/EhnY6U+ykM3eiaEqEe5Egs2Yknc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/207] powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7
Date: Mon,  2 Jun 2025 15:47:14 +0200
Message-ID: <20250602134301.176756047@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

[ Upstream commit 7e67ef889c9ab7246547db73d524459f47403a77 ]

Similar to the PowerMac3,1, the PowerBook6,7 is missing the #size-cells
property on the i2s node.

Depends-on: commit 045b14ca5c36 ("of: WARN on deprecated #address-cells/#size-cells handling")
Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
[maddy: added "commit" work in depends-on to avoid checkpatch error]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/875xmizl6a.fsf@igel.home
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 302c2acc8dcbf..491de25e38a86 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2978,11 +2978,11 @@ static void __init fixup_device_tree_pmac(void)
 	char type[8];
 	phandle node;
 
-	// Some pmacs are missing #size-cells on escc nodes
+	// Some pmacs are missing #size-cells on escc or i2s nodes
 	for (node = 0; prom_next_node(&node); ) {
 		type[0] = '\0';
 		prom_getprop(node, "device_type", type, sizeof(type));
-		if (prom_strcmp(type, "escc"))
+		if (prom_strcmp(type, "escc") && prom_strcmp(type, "i2s"))
 			continue;
 
 		if (prom_getproplen(node, "#size-cells") != PROM_ERROR)
-- 
2.39.5



