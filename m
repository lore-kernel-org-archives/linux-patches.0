Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FA53F4DEB;
	Mon, 17 Aug 2026 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979951; cv=none; b=TUaV8JIYQTyO7IiSJNejMpU2MitH3nZlGTNPvHAePl4ZkSR5yk8D0aN7Kmt95aX/St22TJhV4enNoz8yGeU6CM68+EQYDzHbpJ0JK3amL3X2i5e0NTMiwJagduVGDMXMvjd3oCfrnD1koRCVqXUHP3rwBr2vHcUWRLlKZVROlfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979951; c=relaxed/simple;
	bh=u7i7kmk9IJiCkAn0xdZ/LH4HnSdM43Zaux1SJleplmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/b2OmTq13QWKEndyuuPhILqir9X3tbKS0X1702XOOppE/ti7CK4jmSlyXDJhkWKayDxAprPocSwenRxERIVdPTfTB0idUn6BEZDbqYRA4/t2FXXvcMsuiT06Pb9HQYoX9JwgfwOkRZb8nvQ1H94e0qbiZPqJiA5EQWWn7nK8p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unZhuiif; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unZhuiif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA981F000E9;
	Mon, 17 Aug 2026 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979948;
	bh=ix0m0s/OXEFvVGClbMM0PBQI49WdgpV8JuHQWkAxZYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unZhuiifYqqPyeQbTVVHt89RWqwcYZ+duSbaUbvOpzUD4z6KOFr5n4AzAGFfexfoO
	 kVLBbC3ugc3yxqcndGqyPgrPmhPupt82FQw9oLdcpBK4PpbUD9CcA7GvdGr3ADd1oC
	 C3s8hVCDGJT6xr8WgvHjLCnVm3y1lPubBZHHClkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 364/609] powerpc/boot: Fix treeboot-akebono CPU node lookup check
Date: Mon, 17 Aug 2026 15:31:00 +0200
Message-ID: <20260817132556.463722037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit b24fc8278b70a9d27ec801a427ab4de9b769d69a ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: 2a2c74b2efcb ("IBM Akebono: Add the Akebono platform")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-6-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/treeboot-akebono.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/treeboot-akebono.c b/arch/powerpc/boot/treeboot-akebono.c
index e3cc2599869cc..1b529037480fb 100644
--- a/arch/powerpc/boot/treeboot-akebono.c
+++ b/arch/powerpc/boot/treeboot-akebono.c
@@ -146,7 +146,7 @@ void platform_init(char *userdata)
 
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 					     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0



