Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9CC1A76A5;
	Mon, 14 Oct 2024 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916700; cv=none; b=tNNkym5iM+lViG5hfIfyJ9hLkZgPYFZXaTBvSnXbGUFl6YGDxd3mVBdW7SvRjjXqtaDQUfDj2nkumCX7TREYknnm97G2B7mmy+rtypbpq8qnuXDLmrqdigL01AVhUzsVxh65x/BCKKVTELrp2k+eEI7y5w2Y8WJFWO4JWWX16qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916700; c=relaxed/simple;
	bh=gaWP/TYZXZlMH5uKOH38Ru2bHaRjR18pnFd06AXfG+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVVH7U5hG2Gl3snJS4XITRDggsufafeEQ52sOrqM3A9UNXW/33YF3Jw4ugdMMkgwQLhuPfrJweUp2pktW0VFxXfzwQTI8nO846adatNHG86fkT5xm0uuuXe7vG0UQ/9/ywKPeK5tvQfp2A7Uk3urZ7nRuhwSlDgEqTsk0+eu4lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4Vhrpv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4Vhrpv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E989C4CEC3;
	Mon, 14 Oct 2024 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916700;
	bh=gaWP/TYZXZlMH5uKOH38Ru2bHaRjR18pnFd06AXfG+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4Vhrpv21eCF2vysdvxTQAKzWnFgrbujr5ejNjXcEOquoPMOGUiDomLy7bOV2fdsS
	 EPgMhYhWdrQO6doUPh9SA6b283PyzDBHmnYGm95qqLjaY3BWLi4jjn2/Bqxk/Iu1dI
	 sE1IY3XZrjV5WvqKysavjsEc8gIxvStYbfR6HrKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Shuai <songshuaishuai@tinylab.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/213] riscv: Remove SHADOW_OVERFLOW_STACK_SIZE macro
Date: Mon, 14 Oct 2024 16:18:36 +0200
Message-ID: <20241014141043.382030055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Song Shuai <songshuaishuai@tinylab.org>

[ Upstream commit a7565f4d068b2e60f95c3223c3167c40b8fe83ae ]

The commit be97d0db5f44 ("riscv: VMAP_STACK overflow
detection thread-safe") got rid of `shadow_stack`,
so SHADOW_OVERFLOW_STACK_SIZE should be removed too.

Fixes: be97d0db5f44 ("riscv: VMAP_STACK overflow detection thread-safe")
Signed-off-by: Song Shuai <songshuaishuai@tinylab.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lore.kernel.org/r/20231211110331.359534-1-songshuaishuai@tinylab.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/thread_info.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index 4fb84c2e94c65..8c72d1bcdf141 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -33,7 +33,6 @@
 
 #define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 #define OVERFLOW_STACK_SIZE     SZ_4K
-#define SHADOW_OVERFLOW_STACK_SIZE (1024)
 
 #define IRQ_STACK_SIZE		THREAD_SIZE
 
-- 
2.43.0



