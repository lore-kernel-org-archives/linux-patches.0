Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035728;
	b=Mg+meV84Zzq5zeyRRW6ZqIKjQrHcHn9/+VI1IBvGiibZeRIbh1lxLeEoEtabGny0izop
	 Ct6rGKxfIk+BYZHXoZf4JvnzV0YUNePgzEg6UZWjsDXTbFHDiJ0Faz8bM3TFk4zAKAp1n
	 Y4QvTde5Z4Nh5ZtkCv2tibjQ/4gk+xhEmnPh4uPHzcvKlLGvGodmHsq3mtZH1SyKxPHIo
	 Vwe5d94sgLkX3pRPN9nz3u2yNnYE9llpqtNiKzpKTWfBlQMIgxiTS1oEoP1iNTkPAIxU3
	 aJecZckfAKUpN6qXAbNqfO0Da0qwgKPTqjMSEpNxpwKuwNVO/83Le0RhRn5f+u/hnXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CHHac5+xIiL2BLocpzepttq9CzHdGOY+Cl7azQVEs0w=;
	b=FKrSUlZADd7CAJjshBKcdICCV894oivBLT7bjMe7XQMzFUEyjmRq42u9Nzm9Q8Ma4Po+
	 vRIi969KlfcjFs/D8LlWnZE+msFPx1u9y4P3qUjBM6NqVRHojkfR8KGoVZh1l+FZLHuQ8
	 /vlibYQR/GEQVUkr6k//4L3FTV8OVA1wF+7WTaQWIov78gc9LZPTb0YIF3l+9I8abeV8L
	 2BYSuevCbfwOzaC33a8FMd0QTN2C6oYIb2p+hB/aJKClG8bgpVUA+FMQ30bEZOJeSeVhK
	 RBc7ZbpGE3seAH+3qC66TT7pX81/REnVWrfbdnhH+oB+kXNTYzzd3hCZ63Si4/0PlIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RoWk6M5K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203F6606A31C;
	Wed, 18 Nov 2026 21:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RoWk6M5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8291F000C4;
	Wed, 18 Nov 2026 21:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035728;
	bh=CHHac5+xIiL2BLocpzepttq9CzHdGOY+Cl7azQVEs0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoWk6M5KW91Npk03FZghoultz+eRyV3ocaPD845ssMLdc2PnPibdsTOa7iIDM9WA6
	 U7mpMO5zu1c8SiMszYcVKeFaD3xShcduFqBHEOscrmHMwsAGlBuJ0/RXlrEZvSEoqI
	 ixMNOuoYt4i1S/gCg1HnW3QQuNgnkAS6FILny7+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Michal Simek <monstr@monstr.eu>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0806/3318] microblaze: Fix MB_MANAGER build with older binutils
Date: Wed, 18 Nov 2026 15:23:48 +0100
Message-ID: <20261118150343.154457699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 79c8aa4da3d5453dd956d2170d1c9c716311ea06 ]

Commit 88707ebe77e2 ("microblaze: Add custom break vector handler for mb
manager") added the suspend mnemonic to the MB Manager break handler.

GNU as only learned this mnemonic in binutils 2.42. Linux supports
binutils 2.30, where enabling CONFIG_MB_MANAGER fails:

  arch/microblaze/kernel/entry.S:946: Error: unknown opcode "suspend"

The suspend mnemonic is an alias for mbar 24, and both encode as
0xbb020004. Use the underlying instruction, which GNU as 2.30 already
supports.

Fixes: 88707ebe77e2 ("microblaze: Add custom break vector handler for mb manager")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310310151.UhB396Qs-lkp@intel.com/
Suggested-by: Michal Simek <monstr@monstr.eu>
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260813024026.5402-1-kmehltretter@gmail.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
index 582d7256d8154..ad44341a5dbc7 100644
--- a/arch/microblaze/kernel/entry.S
+++ b/arch/microblaze/kernel/entry.S
@@ -943,7 +943,7 @@ ret_from_break:
 	mbar	1
 	mbar	2
 	bri	4
-	suspend
+	mbar	24 /* suspend */
 	nop
 #endif
 
-- 
2.53.0



