Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D880443A9D;
	Mon, 17 Aug 2026 14:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976015; cv=none; b=q2Op2t71s7XBkhg47ARklrwgtw5/WtTJ5cQ3tsnPrsO+cR0SWrnpcTlKiMaHQXkl4knLz6HAzVu3WCLcD8A2tq9yWW1+mVsbjggUKSYKMCk/PGOLZ+fdMpHARPJ7WDezfXc6kRaWEt7PVGZQVNwhpsg1cOGoy7Gx+0b7z6Sw1G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976015; c=relaxed/simple;
	bh=tMaXWWfJo4pAKXvRiLmCfWyzGDd9m8w/YLwTOxQluww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kccd7PtvK/9QDVB0SK5GRVNFFbkQgzRsH8zG9btOa4yNeSDl+xUjjB4e0FnFuzxl9dDNqMR3H+BmAnyrNdvL5wZLOA23rooJ+6d/l7+oiPVkuJF9k4xntOJzJfWH7m49e0gcc3rXrUaa+2mkxRNjVZexfO9t9pKqLV3ofyAGepM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo6PmHGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo6PmHGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED001F000E9;
	Mon, 17 Aug 2026 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976014;
	bh=/yzBXdfrlPm0p4FYLaf4QkgVi1wtTEOgrF9D7gT01DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zo6PmHGDK10YEOq6Sby5NxYDWZ1FSHUPeY2MkhsosrRZGtl6h8+4vKPxoxz/q38Vx
	 bBd9vO7uFvBxXCEIF4OlUrKUVyHw/Ye/7H14Fy2SVVZo7KYo5YR3NPYNfS1lGDc6u3
	 8svxleyvka0R+A04wQQ4BNLnSsi7uCMfdccynRNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/389] powerpc/boot: Fix treeboot-currituck CPU node lookup check
Date: Mon, 17 Aug 2026 15:31:05 +0200
Message-ID: <20260817132548.041865591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 43863f6575d2211e8c5157fefb83ad0ad046aab4 ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: 228d55053397 ("powerpc/47x: Add support for the new IBM currituck platform")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-5-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/treeboot-currituck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/treeboot-currituck.c b/arch/powerpc/boot/treeboot-currituck.c
index d53e8a592f816..5b5363b74f9f3 100644
--- a/arch/powerpc/boot/treeboot-currituck.c
+++ b/arch/powerpc/boot/treeboot-currituck.c
@@ -102,7 +102,7 @@ void platform_init(void)
 
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 	                                     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0



