Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D331E522;
	Thu, 30 Jan 2025 14:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247127; cv=none; b=dAmqHHXOsov/19n62DIwj6rPfo42zp74YUAdKYxh96arDJG9OGRPEzFcWulsxS6gS5ZWI7tPw3ZFvErsUxe/ZZHKrwkyFu209adux7kHP/ocKviCDmGmaOJOh/t2Qdv5v3jop4mV06m2rBCx6q1zh836iVS13GZRwfcrOjxBl7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247127; c=relaxed/simple;
	bh=54LqZMrp3gmwAVzNylxiid1kN9v+S7y/gkFKIq71lxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkNbJtYugY2kxVZY+G5zkdImQk8aDx+7tHtrWUFuStoiI+ZEqnzO7TuOHzx0DmG7l9caZVBfg1errUCAN6fNi41xWf+UrlMbyh8zXXKkIhxvjJllwDJK/sn+sq8Sxjp9frnGI9hnQS56Fo/zLUasl9Jo4m8VgTr5hm1IdrWm+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGskOXGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGskOXGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00815C4CED2;
	Thu, 30 Jan 2025 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247127;
	bh=54LqZMrp3gmwAVzNylxiid1kN9v+S7y/gkFKIq71lxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGskOXGBqoL+PcgkbYXwaowCqbucSjBTj086Y+p4r3bSTp6BckuEt5li034b+9Bv0
	 1Wo6yaYk/xPdUjjCjcabJsQ1zvkvvMaNqPF502nPScmXrHxhWmZPfNH+JBU4vXRIOA
	 +4Gaqiecm3bF1AK25gKCz+tc1f1vcXUnv0PXIbk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/133] x86/asm: Make serialize() always_inline
Date: Thu, 30 Jan 2025 15:01:20 +0100
Message-ID: <20250130140146.183115489@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 415693f5d909d..ad828c6742d4e 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -236,7 +236,7 @@ static inline void clwb(volatile void *__p)
 
 #define nop() asm volatile ("nop")
 
-static inline void serialize(void)
+static __always_inline void serialize(void)
 {
 	/* Instruction opcode for SERIALIZE; supported in binutils >= 2.35. */
 	asm volatile(".byte 0xf, 0x1, 0xe8" ::: "memory");
-- 
2.39.5



