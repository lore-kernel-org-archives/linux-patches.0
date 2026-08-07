Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95403101A7;
	Fri,  7 Aug 2026 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113936; cv=none; b=T8RxhNqVTvDRUtEoYCJBKwndHe4vHexrKxsUI/gfIqEKITMZdikMxiaNJ3tYnA8jjQg9k8Zo7oIEL/t00EHF1ZSXShwVDowFE5cdctAMGhRyDto4FlK+VrOJ1OPr2bCCkIAOI6ED74jX41cDvGzns0IMiSLd2Zai1BRcTTv41VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113936; c=relaxed/simple;
	bh=2BRjgFKi8GKpo+hnePW+7imXasoTDxO7WSYQ1KCSL5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QK+UGVAKF9nFzx36Tjck/00uDiTR/szL6TDwXpOmryNcnl6C4cD6l7IjsHhTzoaWJaCw61NSatz0aCjZRPqDVFzo0mIIU55wONIbdBtqpErBSUn2F03kORuMMTwS7pAO3NZsw7JJZ3+qdLIsYbeqJQXZd2XVjiyoMUOXh4rA26E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tug8IXfr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tug8IXfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04F51F00A3A;
	Fri,  7 Aug 2026 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113934;
	bh=fQUKciy4jalCFZoVGF8/BDX2j5OPXqDS632tfXzJCWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tug8IXfr2yYB96n+V269qHtCiSQJOnMkoCVQJkqOYoE99JZ8wNL4k5/2Mb196nbHp
	 S8QrMNbdPDRTCRNJDhYwtoYeBghTtFjRfIYB0ic1X2DBlZ6AAq8RAxjV61Jo/q1fpM
	 2vuvvY8un9nnP4sTy0ophK8n25YYDTbollO3INNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/337] powerpc/boot: Fix treeboot-akebono CPU node lookup check
Date: Fri,  7 Aug 2026 16:34:50 +0200
Message-ID: <20260807143420.401614839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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



