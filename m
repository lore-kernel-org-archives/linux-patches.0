Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3665170836;
	Mon, 17 Aug 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979938; cv=none; b=YNMoHYE0cp3y7/WlbhwmhFw3jlIkBA8KuZrL0D5auSMcfP0ZYckRPV6B+qL2Wbc8Hw+WaHDqy6CeAa7K27b6txRB09XlTHSXRgUdA93IwtZXv53PxCQMYIEiY171Gq2nziZ8/kNZ6XM0AA5tqwXu8yualdKIy/P1X2ho1i1/yac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979938; c=relaxed/simple;
	bh=TvGfIZluvw+W1ru4PxhCH+TldvR6+OtpcT8qQfXD/x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgVTapKvjAE4eBAX6RNNUODKMjvW1lpuIrVNCwnBJVdQPCmmBBl/d+ogVVAFWMuFW71ROEoAeYrxGm+haV1VZ5CdST8YO6qp3a9Bxh3qdJJXH1FM6E+NaoWiR+HQ+/m8Ewl74Q1rscU0YI/Y39i9YE9wuoY5mRtmA8+P+DqSSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cm7Dj+Mk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cm7Dj+Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2103F1F000E9;
	Mon, 17 Aug 2026 15:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979936;
	bh=D9p3w/aL3RdnAHjLQKTdPlx9hNO7HbLHzWHCdXgtu0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cm7Dj+MkPjEOdM2IP7eBjgeyG/IBxxPw9rkKarsBGPdnLfDqD62M6yByuppnL2aSq
	 zVwQemMTCV63rtVBO8AiEdt6Xi1U526JukfsrMJM6QXPCbgQY1T+kLb5HFr2hQNemt
	 Qn/fb4N44o179R7BOYty8WA8NsFLV18XyHyhtoI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 362/609] powerpc/boot: Fix simpleboot CPU node lookup check
Date: Mon, 17 Aug 2026 15:30:58 +0200
Message-ID: <20260817132556.396430529@linuxfoundation.org>
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

[ Upstream commit c824ab65685bb119c6c6a3a200b3428c72862d5a ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: d2477b5cc8ca ("[POWERPC] bootwrapper: Add a firmware-independent simpleboot target.")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-4-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simpleboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simpleboot.c b/arch/powerpc/boot/simpleboot.c
index c80691d83880b..27591df41e9e8 100644
--- a/arch/powerpc/boot/simpleboot.c
+++ b/arch/powerpc/boot/simpleboot.c
@@ -68,7 +68,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	/* finally, setup the timebase */
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 					     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0



