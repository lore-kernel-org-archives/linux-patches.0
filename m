Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062781;
	b=oujOF7TygGQHINvczG4r6mehzCCbsW5YH/TwQkKU6YJSn5AeeYHDFj+ayt/RUBSF3zSm
	 LFpmfX5PwfKTwMm34e3N9txclnOKaavgLJvYRT0A4GuxE2plvKQSZsfim12IspPXzzXUe
	 w7NHNROuL6estirC2KuOsxXInYd2nogOm6cFf1m7CO5S6Z6/0dTns5WbYr5x2IshL/QHL
	 l1HUxzvAi4p6mrOwFmMDqn5nxaTQ1KYiOqYnAiVnrRAV7JkJzWEw0q2sBxGfCk/m8k3i9
	 Q4kL7spuvkI+1t6VCx89VObVr++jDQbFO+kKAVsPovvGx6eebeZaCoDrceRzsayzvAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DjBSQEVUhLYVPnVzha7Siza1m8/3C3Mc9UZlawVkjHI=;
	b=CzoTJ4G3UlHe6TihKLCOjOI2K6LgXruX0tuDyNe1nUORxDiu50+SSGnsfM5cqeu3sIKI
	 OchBF5DgkHpdAe2HMUw8PGhC7LWH6qC4IKsyfnNWkmVsTWwLqKZRXSG2AYlJGUZvdHLC0
	 Si+CHHMV3I9yco8pkKJ0Wqg4vpSdC5gTMkp+W/2SZVhpsl29G+sIgU2PywpdQAR/7UBgH
	 Vb4d1osSVjT0J3fPaSUU43Z3V7wZy9ZqqBA+5DPBUGu4bTFW9lDaQbGvJs2GwShmJQxgj
	 fr6S139xzeXl4p0i7PICEYmoKajrM4j8FHgftiTA4F4RAn68ozcVLzDqSNpF2SVUagQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd2RZT6e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BE5606A326;
	Sat,  7 Nov 2026 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd2RZT6e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE19E1F0089F;
	Sat,  7 Nov 2026 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062781;
	bh=DjBSQEVUhLYVPnVzha7Siza1m8/3C3Mc9UZlawVkjHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd2RZT6en99g2Zd2ett8t7WwEDGR2aNm5LAp0zWyvXlaBwFqtXU4Vz/TUUhd0Hkz/
	 9NEyyOhga5kYlc9IjolmZkal7UiDXkOjqYIYC0R4aijR3J41gOZy6lpiIVq5vqDe4a
	 0BxIoXEDb5/PUaWQ1p0/P68IP2l71pl1eEz4KxmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Michal Simek <monstr@monstr.eu>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/869] microblaze: Fix MB_MANAGER build with older binutils
Date: Sat,  7 Nov 2026 08:45:22 -0500
Message-ID: <20261107134853.516623938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



