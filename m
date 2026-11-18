Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018801;
	b=a2JsYx5VnqnlAS6s4KTlFGi9mGvOwugpGm6z5PGV8g6HieeaLaufkGjJI9gr1gedIGcf
	 +kfNLSEELS3RnDr6LzoYNfEajSjLJkeffW1Rrr1GZCbu+GIyH+ftg+IOhIUK5Yv2sMIi3
	 TsuGm2hpCRwtPFfucLPQ0bgghhx75pn5okLXuJrRUPScSyHgeP8csfpc92kjkpNnkXahD
	 vYaOSXAZEbd1yebhVOOfR/kx+2fbHHWdScIskiwr7NNrn+7S5m2Y6mxKHQ+GHckotTSAT
	 VjjQSoSO02LdJWGoGc+6SS8+LYdQek99bKXaHgAaquipWjPnwg8x2S1rp6NeAlo3rng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PUtoUaaXGwgtolX6STiR4cWECGEfdZmvxKlkFoIoE4Q=;
	b=Z/RIAmAkl88cYZpSo4N2ousjBswz6nZUyUgj00N3W0ElAp4Z0PkLo7Z0ZDOGVWiSpdwv
	 YZLDcN0y9W3NDczJZw/l8iEsDTxeE2LCe8MZ7obQ/79txuwdqFid9yyh9KNSP8nwFAz6t
	 CMackL/Mxxqgybi8t5Ow5nZQNw/bnAwpT34ZIHuF9y7LA00tDl5yJNFEfuk+L/IURhgbx
	 0Ytnezh4eiDdZ82CkO+OyFoXmx7FkRqZEhsmcGUOe3NVYepNBKXz8ZZMXUupmGLVMqW9u
	 QmER1VFgEoRtxuauMyxSMhJBY7WljGZrBs8QP0KUevaDA23qIVujZ3aSUEi6uEyBfIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wugWWwz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F31C606A335;
	Wed, 18 Nov 2026 16:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wugWWwz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABC11F000C5;
	Wed, 18 Nov 2026 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018801;
	bh=PUtoUaaXGwgtolX6STiR4cWECGEfdZmvxKlkFoIoE4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wugWWwz6U9x1qzwBxz25d/7mOosVN5g5pBnUe595WshoxdZihMzHYYHQcT6qOP3Yk
	 6lzpt8C1ucybLqX3EUJgE9u2wmTOh1gHJokIHBLuu0mMyHOBLjHF6j672zLzfhoOV3
	 JeiOK/4IqagDJZle0PdOlWJDWL1eaMN7AJiQI6DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1369/2651] sh: Fix built-in DTB build with generic rule
Date: Wed, 18 Nov 2026 15:43:29 +0100
Message-ID: <20261118150337.314904148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 642c9b8ee61dd492eb75b347f9e5f0ce6bf24281 ]

Commit 21bcc49974c2 ("sh: Migrate to the generic rule for built-in DTB")
selected GENERIC_BUILTIN_DTB and renamed the Kconfig symbols, but left
arch/sh/boot/dts/Makefile using the old obj-y form. So convert them as
well, to fix the build error when using CONFIG_BUILTIN_DTB.

Fixes: 21bcc49974c2 ("sh: Migrate to the generic rule for built-in DTB")
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/boot/dts/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boot/dts/Makefile b/arch/sh/boot/dts/Makefile
index d109978a5eb9c..16e281b859ae2 100644
--- a/arch/sh/boot/dts/Makefile
+++ b/arch/sh/boot/dts/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_BUILTIN_DTB) += $(addsuffix .dtb.o, $(CONFIG_BUILTIN_DTB_NAME))
+dtb-y += $(addsuffix .dtb, $(CONFIG_BUILTIN_DTB_NAME))
-- 
2.53.0



