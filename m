Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D05472790;
	Fri,  7 Aug 2026 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115000; cv=none; b=QTnyAw/83H76UTsa1xICFGVBVN19h34dHm4/O86oy4GCB2bJm3kia3dgmBiYFUaalnOIk6F1tL/jxt5Nq55YM4+DhlFixIUgkuqhQ/Ne3zbGtG0dnWdldwen7D+2h0FlqZA1/3H3WCYLLTHjB2LWZYHpSsF/2BiXapoYwtR8TCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115000; c=relaxed/simple;
	bh=JlNkDdcp1YQM4YFmKKLzX9zWfGMLjD0mu2UJqPzofXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9YJepImItdLO3Bf2B9PyK1hhSMP/aMx17GQ1O/WuuOpoCu0Y0r0TUECCkIpXm7W7BnB4gNhgX4p34EMi5iKG8ggpKnvjo9beyDm8qPAhs3P3LMtHsoV5JgsT/AcrLyQDlss2K1qvWHYQU732AeVi3dr+7thAgfnps+E7SSQyYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGBAd9fs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGBAd9fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2461F000E9;
	Fri,  7 Aug 2026 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114999;
	bh=qqxn43/uWJdEYTJIuwrucpM5+6GIPeqeBi7v5Lhi/Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGBAd9fszFEdy5vv8uw2aZqGypjED8FUYy1NjZiWUWukiCdkUgZuIjXoJMsiVgzwg
	 FyVGg3d337yTnnROK17vztSRZejZa9yW52x26QmhECt2vDRjKahQV2U0H09B059/7W
	 zV/sTiCLB6JGYfHbrw48xyV3IwgbacAfIVQq5t6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/396] powerpc/boot: Fix treeboot-akebono CPU node lookup check
Date: Fri,  7 Aug 2026 16:34:15 +0200
Message-ID: <20260807143426.329549970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



