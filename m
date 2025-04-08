Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA58269CF6;
	Tue,  8 Apr 2025 11:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113577; cv=none; b=HASv5/4cYuwlAHaT4ebCWe1AoiNzSPlQ/qFuxu8klhkRd0Vu8tzEmc8qAFXqKr3zIfGzKcHmdjEGLYRKJJ04HFBahc38vUMICH3KYChWxB5KYzrTNvkkKuaeeqm9uNGTCIE9AwIv+sH1c3+mEkO7ZltNsagoaSIIgI3bZOxJM4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113577; c=relaxed/simple;
	bh=lURI0yJ9oliLnOL/S9A1Kq+SBegWKhFeBqjs/ni+oqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5WJEft6YT2fwLdElSOYDemqWrdxDU+yGkCgsX1PhctL69399r7j9EUoBzZDzFNU6JoHx+/CaLxATWERPChaUTkjDSyoKDPD7uKDT+I8lf+XFhcWxcFnYmKjATM6edOAJ8sH34clAd7F4pNSUbFAkV56HeJROUFG8SxGznBf9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O846jMQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O846jMQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52532C4CEE5;
	Tue,  8 Apr 2025 11:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113577;
	bh=lURI0yJ9oliLnOL/S9A1Kq+SBegWKhFeBqjs/ni+oqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O846jMQeiH6RfkhZbOeCfk0duA6ghn4JeEuu8hgv2uxaY/keEV5L1NnKIXhWwrFB5
	 h8Mo4NTHEhIQhW8ZSHN+SCltQlW8FtvDB1rK2700Zzog+JyMPly41iaJTLQ7GFt0Er
	 7Aud+vGAfLXCUkE+leWFKdZkdekIrR5AHD1oHWuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juhan Jin <juhan.jin@foxmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/268] riscv: ftrace: Add parentheses in macro definitions of make_call_t0 and make_call_ra
Date: Tue,  8 Apr 2025 12:50:05 +0200
Message-ID: <20250408104833.791202629@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Juhan Jin <juhan.jin@foxmail.com>

[ Upstream commit 5f1a58ed91a040d4625d854f9bb3dd4995919202 ]

This patch adds parentheses to parameters caller and callee of macros
make_call_t0 and make_call_ra. Every existing invocation of these two
macros uses a single variable for each argument, so the absence of the
parentheses seems okay. However, future invocations might use more
complex expressions as arguments. For example, a future invocation might
look like this: make_call_t0(a - b, c, call). Without parentheses in the
macro definition, the macro invocation expands to:

...
unsigned int offset = (unsigned long) c - (unsigned long) a - b;
...

which is clearly wrong.

The use of parentheses ensures arguments are correctly evaluated and
potentially saves future users of make_call_t0 and make_call_ra debugging
trouble.

Fixes: 6724a76cff85 ("riscv: ftrace: Reduce the detour code size to half")
Signed-off-by: Juhan Jin <juhan.jin@foxmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/tencent_AE90AA59903A628E87E9F80E563DA5BA5508@qq.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/ftrace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index 42777f91a9c58..9004dfec8c855 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -103,7 +103,7 @@ struct dyn_arch_ftrace {
 #define make_call_t0(caller, callee, call)				\
 do {									\
 	unsigned int offset =						\
-		(unsigned long) callee - (unsigned long) caller;	\
+		(unsigned long) (callee) - (unsigned long) (caller);	\
 	call[0] = to_auipc_t0(offset);					\
 	call[1] = to_jalr_t0(offset);					\
 } while (0)
@@ -119,7 +119,7 @@ do {									\
 #define make_call_ra(caller, callee, call)				\
 do {									\
 	unsigned int offset =						\
-		(unsigned long) callee - (unsigned long) caller;	\
+		(unsigned long) (callee) - (unsigned long) (caller);	\
 	call[0] = to_auipc_ra(offset);					\
 	call[1] = to_jalr_ra(offset);					\
 } while (0)
-- 
2.39.5



