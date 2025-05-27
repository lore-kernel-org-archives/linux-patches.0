Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09E32566;
	Tue, 27 May 2025 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367036; cv=none; b=WcCOgxDb5bMbz2IwOay3ScnnIdldGmjUN7lRTchzffoxao1Gz5QdQIuA/m7cRSgPyUgp2kKn506MgPtJlWtj9z5TBrQm53ezNZOyJtRbGW/Hj1qKf1OOM+TLETokM2nxyyfQ2NsT9+SpItzvLIhpyh4SjAjv3/U9YDLivPjn6Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367036; c=relaxed/simple;
	bh=wGpcgfhJb4sm9NvByPELO2Zto9iNm2ptI5G+HfHg/9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/U+vVCJTDr8AmRu7OSVrj2a9Z+o8VmbWsbwLFTgvfUfbnYXRaiIiEoKCxXZMWbj5W3lbbUxU+oFBqR624gJ+fSw/bla/uqOelsIJvT74sJAtQlnfGMdmS7aCxXB4ljgD3NFZyqe/49v+6P3jwO5uRFlFKJrF4GcVvXtZGkErf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXRSv+p1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXRSv+p1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15FAC4CEE9;
	Tue, 27 May 2025 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367036;
	bh=wGpcgfhJb4sm9NvByPELO2Zto9iNm2ptI5G+HfHg/9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXRSv+p1JberGGb2MDyAOcvY6TGncStprB5B7LAaeVCfdzUUxXEzwDSq/btWaIvHy
	 ELh82swMWHVN3P0UFBAJS9bFRLr/xbOnJQdH4kMqwql7fIZB4Q2K2F8WKI0mKmteMk
	 NgugIBNnGtmyev2uX+6hD1CbzYdGvTPhLw9f5iSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@linux-m68k.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 258/783] powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7
Date: Tue, 27 May 2025 18:20:55 +0200
Message-ID: <20250527162523.603960544@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 57082fac46687..fe4659ba8c22a 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2889,11 +2889,11 @@ static void __init fixup_device_tree_pmac(void)
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



