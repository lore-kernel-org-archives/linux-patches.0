Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC771F78E5;
	Tue, 21 Jan 2025 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483139; cv=none; b=OduqCCJdxRTqVIvax8PevxsHd9TqSQwIcRRBAo8vqAS+WX7eA6+Nz4LOncC8xM1tuwA2dRHPdkj/xmbtftm4R3Qm8p1We9Hl9itgsQ8iJPKgmmf9c9mYUsObDblFqVfKNn69d3eCsZ4TikcicOR5UIPyVE6sx1B+QueQwro2yIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483139; c=relaxed/simple;
	bh=AbCnEvUXGJ+uV74RbojU176U1lZhAQ+pEDk4KiyBmSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fATKqckW6T/0Dd3WirmcaWoVhTXkC3yCTq0/jTNQm1DfIQl7c4U9WKUJ8mgHNniLhKyV6ZyOrBkYy8aLg5SdnUcKLii9qxCCZjGcMb0OUikGfR5Yy/xuRdFHAb7yjOwhtbbPeu3P2rk+wxcj/j1MNhK7RMHtw+8s9dPeq41dP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyfjV8kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyfjV8kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E169FC4CEDF;
	Tue, 21 Jan 2025 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483139;
	bh=AbCnEvUXGJ+uV74RbojU176U1lZhAQ+pEDk4KiyBmSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyfjV8kf3Rwz4A5UqYhkHODhDohhT/JljWMmDFmyYaH2RDfWlvi3nTUkCMZZUWevb
	 JPMyzDXHiGLdTfCxhHULKMdFx3aYK8EVKhRV/7e2eUPVGi+1rkJ6mhSh0H1CXcnzv0
	 5ej1fMo/T9qth2BYNTlDc6mAmCMWTAjpWspd9iIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/127] x86/asm: Make serialize() always_inline
Date: Tue, 21 Jan 2025 18:52:56 +0100
Message-ID: <20250121174533.662306710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit ae02ae16b76160f0aeeae2c5fb9b15226d00a4ef ]

In order to allow serialize() to be used from noinstr code, make it
__always_inline.

Fixes: 0ef8047b737d ("x86/static-call: provide a way to do very early static-call updates")
Closes: https://lore.kernel.org/oe-kbuild-all/202412181756.aJvzih2K-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241218100918.22167-1-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/special_insns.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 68c257a3de0d3..147e83fa86e25 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -224,7 +224,7 @@ static inline void clwb(volatile void *__p)
 
 #define nop() asm volatile ("nop")
 
-static inline void serialize(void)
+static __always_inline void serialize(void)
 {
 	/* Instruction opcode for SERIALIZE; supported in binutils >= 2.35. */
 	asm volatile(".byte 0xf, 0x1, 0xe8" ::: "memory");
-- 
2.39.5



