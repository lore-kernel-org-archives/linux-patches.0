Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615A3238C35;
	Mon,  2 Jun 2025 14:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873421; cv=none; b=QZdmOnbKk3UUL8J/zleyk5LkBiU+2RCpxDPDmPYAMixQcQIW17ypNJ2Iy2TMGa0mR89DI0iy0rmmXrBmfkOojm56w83GUIM5PuZn6PRfTQ1PonBn+Ifr+7i3Tt8saNKc2pJPB7I/NKKdsVT/4OS3uVri9WpY9SlYjmNE+Rhf2kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873421; c=relaxed/simple;
	bh=EmF4iN7F9f9ffz58ox/vToLwAHG5SLqI2KTn8RkN15k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shV6FqwIdx/cLkJt04U7rpd7L4uj/CvVNUs/I0q8f4Dxx1enCoKwB3d8v41AEEyWAZwGOx4uH8dUwABCFbYeXzQHKCRBWtjA7DfKzfJjfB+KaVsE8eNBWwMWk4DnPtvj0gwgdzJ1y6MaNBClQIo2Aal2PiUY9WdXnr46mqwmFVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwbBqxQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwbBqxQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2B6C4CEEB;
	Mon,  2 Jun 2025 14:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873420;
	bh=EmF4iN7F9f9ffz58ox/vToLwAHG5SLqI2KTn8RkN15k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwbBqxQKJUDIZO9kGdXca2z4qnu4lEyNqXvcaAwX38QkrFfTTdmDykJSN99HDbFQJ
	 NITY4itT3qcgA51+uNpoWLBMUUDcLWmxHaJnzoZKs8yuekc/mKTMk4LHA89APrRNOi
	 92nXZ2uW8/hZqmU57OsBihdq/PKGeHjxYQtSKojY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/444] powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7
Date: Mon,  2 Jun 2025 15:43:19 +0200
Message-ID: <20250602134346.378072738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6090896f7497..ac669e58e2023 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2974,11 +2974,11 @@ static void __init fixup_device_tree_pmac(void)
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



