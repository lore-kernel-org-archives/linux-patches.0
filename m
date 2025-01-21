Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B2D1F55FA;
	Tue, 21 Jan 2025 17:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482108; cv=none; b=rmbne/QCVpwX4EisPeMk45rHWkWZLKo/FTI2v+AOR1F80iH9WJWi0JWuVz9f4QMyvaUwTdgeKZqigc9RRnMEH4kNClq3Uzdb74WhGCfRbsRvDW8Li+cY32qKtu6vfK8+eIJIY5Z9igzYdo5WZXwmaH/KAUvIhDP163Tlvs56Xik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482108; c=relaxed/simple;
	bh=NQCif2Xe8eiMevXikx/YVtWWDamGGgbld6qv95jykbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3rI1d2/UXICJPM3trvW8Qp/vRjvhvJb1rJK7qOrbvGGZ2wy04ok92LzN2/grM/NFEdRgwW/USo0KPdxDPo63GqVI/7j4/TIgRYduC2Jqm34FrqqDTEKpvVavTy1/i4A82N0+dQAInjK57ZkUrcu9euZR4YHFmpEhoTNZiKSuC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVF54E01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVF54E01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FD7C4CEDF;
	Tue, 21 Jan 2025 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482107;
	bh=NQCif2Xe8eiMevXikx/YVtWWDamGGgbld6qv95jykbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVF54E01+CQffKgXKlOwF9uZ/N0DDp7pVTv6d82E4/9tydIZRQmmUX0yDwpOSptAz
	 8eRtCZ6wjryrqrox0iT8RQEIHD1qoREPNKPZzoPPbWss7wE7j6z38hhuSwLXszxbZ4
	 jlSBmo+NPGvfW9f5vpQpGkWY6O4atCjdYqv2YgsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 37/72] x86/asm: Make serialize() always_inline
Date: Tue, 21 Jan 2025 18:52:03 +0100
Message-ID: <20250121174524.853285084@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48f8dd47cf688..1c5513b04f038 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -217,7 +217,7 @@ static inline int write_user_shstk_64(u64 __user *addr, u64 val)
 
 #define nop() asm volatile ("nop")
 
-static inline void serialize(void)
+static __always_inline void serialize(void)
 {
 	/* Instruction opcode for SERIALIZE; supported in binutils >= 2.35. */
 	asm volatile(".byte 0xf, 0x1, 0xe8" ::: "memory");
-- 
2.39.5



