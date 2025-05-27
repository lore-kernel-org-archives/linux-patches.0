Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C4F194A67;
	Tue, 27 May 2025 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365028; cv=none; b=ZdMKkwzTrXNY1Lx2EcLqJuxf9wxTL4ajJxLLknH0FFlHIbAiQQTm0gaVKTNDG57ASd1pRWkrcCAOUyKXtJVjC1+2PwHUQBVlKtxvU31oQYr47EbTPOTs1l5eY6wjJ9bc6/MX0wy9A0RjqTx/h4EBNSd3iflifq+Ya1nnI3dG+n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365028; c=relaxed/simple;
	bh=eJm2LXPggRIGPVxxxJkQnDpYxnrp9bgpbIY5U8td+yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lg9/zj7mgGtes2rtLVNJHx9RTzENfNJLRzeDg/IcCQCIUEb5+oF5B2d3WieNN43tubD13Ozl3+c3xBLO9avGygO4qLuG4+qEnKz3AGy09yCvwMAn2mVU+iAV+XelEYQ1ylMjNTbSz5RK0n9Ge7657PRsAcBL40wNkCh3MurO+q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtD21yst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtD21yst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD39C4CEE9;
	Tue, 27 May 2025 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365028;
	bh=eJm2LXPggRIGPVxxxJkQnDpYxnrp9bgpbIY5U8td+yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtD21ystyzT0kHsHU/H3kZWu9aqDbAUVieJkxwcWG4VxWFllt4Ab+hJmBeAFupyZc
	 DBZdA1zP1EoLHBTKu4I+18PFUkOKIHDAB/vJo6y9zcEgG/hBcxb288gD8SnCuvzFX/
	 IA9kZpKq3s49QnINBdvQwKNOAoDJ9SxtYD4k1Yuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/626] powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7
Date: Tue, 27 May 2025 18:21:47 +0200
Message-ID: <20250527162453.714761534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 935568d68196d..b1dc4cb9f78e6 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2982,11 +2982,11 @@ static void __init fixup_device_tree_pmac(void)
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



