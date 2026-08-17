Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8E2442FD1;
	Mon, 17 Aug 2026 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977401; cv=none; b=pnfi2UTTWMYUwu3HPvf4fhZ62YDdrBEIG4p8O23hRUXQJQYW+s88XMIFVLlubjLd8p2XGNXibXtkjqf88e7E6uKCH1j9k6jC9DJPmPuMzY5i/fsRS5BGeJedsjKQGrXhIcoKFj5qn+ZTHoES4cs0YGLOjvraoQ2I2Nk9c8VKp+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977401; c=relaxed/simple;
	bh=SrH5kuK9YXZJnYO3J3NUVRC9F0vNpNp4LlOsofY75BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O75G2Mn+6qqb8Ei2NpPC1G09ouJzXBKltD65GQX1rngCHIQ47xTJ0QvLmBVXZECYXfm0y7cRS47LWQpP/TktBNSCWdaKq+oeK0E4IKo+Rn6Gg+gCn/B4JJobfUrraJvXLzPDcTEfIWMvbozdznc6ckGYNksRKatbu46driWsWWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpsIecqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpsIecqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70A11F00A3F;
	Mon, 17 Aug 2026 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977400;
	bh=Hg7/NAaBUgKkpCdQvEQDwVXPoyUKxzTLPjVG3YuEyjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpsIecqnXHl4u8Vvyk+F/7vrit/9ozF5QpfG2oBonLFOsDcfvBwu7VJ/1RU34woRs
	 yqX0DkXEF5yVMTuT1QLNjfIlkMuxzkLjlkBE1xqj49q0TP40mQK0s1JGkXBm0Om2RC
	 ZU4xm7WqH6J+MirHrbLCQtxs1l5kcbfQr1AqulMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/456] powerpc/boot: Fix simpleboot CPU node lookup check
Date: Mon, 17 Aug 2026 15:31:06 +0200
Message-ID: <20260817132550.759102911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



