Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E070329C328;
	Fri,  7 Aug 2026 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115956; cv=none; b=Fr8/UzywTboW2cCP3uEng+sNJhj1kKwzouH97PZanuMUTLnTRf2ZuzFn/TK1JJfZRWhZCc2Csjnws/PmCLVSEoPAlukl2ByDC+94T3lkkLIP6k+RPAqCVAUPOip7KHcJTMyPSsHZfVtvcO8RtZAsFuypWLRURB/GRYp1w7riJa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115956; c=relaxed/simple;
	bh=fzdtzX5FUXYGBwJaXRaPSIpyddWYNdJFJvtTyVhL5Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiFbzkIiOycU7ygqyRkZZ7i2h0nNgOCFb5EUH1IJXWBpXT3Laxenl3nwUWKs6z0S0gED/e52klCs1qKpPmcWYazKcV0AeDtydDIXYBt0oouRBNEKF18555ZO/9UYb7nyLFzcLzkM0yxy/1H2BLksnomRMVHy49CVRit+B31VGUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqEgSclS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqEgSclS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498551F000E9;
	Fri,  7 Aug 2026 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115954;
	bh=PWFE02UONHOBPKfdHlVlZ5XE5SAehefRKTZWVJFUPzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqEgSclSfrwfF82FdJw6zdw90uXahpFntfqJi7gUVx+jlZ9W8puD9JWcYXGkGTBtd
	 3vsfU/CqSACjd3LAlYjAyvBMNiUllexNBVYzI4k9bAI7j9E0o6nJ83uUXkaN5QB3sT
	 a0QU2aPi7aKHwZ2gNwJxcCyJFVSsFKyG1IKH1xIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/261] powerpc/boot: Fix treeboot-currituck CPU node lookup check
Date: Fri,  7 Aug 2026 16:36:56 +0200
Message-ID: <20260807143416.657722807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



