Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99371D516F;
	Mon,  2 Jun 2025 14:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874716; cv=none; b=NzQTyLi4SFAu2ekDhWOaYDGF07tZeABaMS4CDmVTecFKjx00wjIruk/r7g5DRncWji82CLivS1TXNgkUXoLPLdKwzhGPzuGDvbfviGJrW0dAwNrzk4RPA3wzaCpxmWTDvHODn8I/JgRvpKd4/OP+kLVI2VcBfPeY2Ub9MMtyEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874716; c=relaxed/simple;
	bh=/ytuouzGczHGeKcy9tzsQfEhkQh3ZIzzr3a9opPA6mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6UvdkJxE7aTW48rFF2wBf5JdahR2zZIk61N5MWAnKrGnirGwbvOdTLHj/DT+P+VyJ2l9jcONA2bH4KHCLyzsv2Nkh7Xx0hD2vtUx0oH1eguNdS42Ldv2xzeM2yx3yeBsUvY0W3RAhxnWmvbnLDbkk9bZ5fEEKlH10X86rCh1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDAKvbya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDAKvbya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4255AC4CEEB;
	Mon,  2 Jun 2025 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874716;
	bh=/ytuouzGczHGeKcy9tzsQfEhkQh3ZIzzr3a9opPA6mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDAKvbyaN+/1EIwouXry01KnfDdl/cNt1d0TVhk98WVe+npic6KPdWJ0UFc92jleK
	 F4Cnxn6o1VVp0w/EXijMAr+ssYo+rs3xAi2md/s6oslITAl1cqQc8weMNtTMczenM2
	 kmXpM70jyN6Tt7o7+ku8KezBcmaSMIewDeRgMhMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/204] powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7
Date: Mon,  2 Jun 2025 15:47:27 +0200
Message-ID: <20250602134300.138849573@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b7ef63614417d..e0abb13b5806a 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2906,11 +2906,11 @@ static void __init fixup_device_tree_pmac(void)
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



