Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460EB26B2BE;
	Tue,  8 Apr 2025 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115917; cv=none; b=J39BkwEFGXjlVrlshRC67suyu+aWZIrEGycN3cZ27CRiWNgFM1zVCO0Jsi1g0Xqo5XsYnfisTup46E5ecZlGv9B9frk4ISYTLnXFiRGI9XUFvmoRPl23SoLpxUU237GaZDVSTzR+oJOK6d4Ivu1uqZuQwg5oRSxx/AyRt0Nu82k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115917; c=relaxed/simple;
	bh=fi/LfwrJ13H8z3WZBt/Bv3TS+dEOvdTY4eLN0mZpag0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAcjrX4SBJSXYfhsna476OoqABVaqtELsGylxhwnB6pYYNMIv7GWkTve6dpXQ8JxQBHRNIvKkc6jft1Uf/DOwyo+nLCjuEenD6caQJxlZmpLo1zsakyXaPV7Djij7VEudsPBs+Y1Mvc99lx4rTWdvai1PwXXot7E6T8yTzJM8nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJU+fB9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJU+fB9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68581C4CEE5;
	Tue,  8 Apr 2025 12:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115916;
	bh=fi/LfwrJ13H8z3WZBt/Bv3TS+dEOvdTY4eLN0mZpag0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJU+fB9Yhf+iZKQ6ICV7pialkZs6CatgM80RJ1iTcatlqbr398l2LwzbWDCU6n08u
	 SB5Va2rCSNNcuL2PKhzLHaI+BXgcXQ3Prxr8yQqlmC3e5w/Ptq72F0VAVzP1xEcARa
	 3WDoYLECudJ98QgY8BJoeXde/W/UR0H8oCjZNwFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juhan Jin <juhan.jin@foxmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/204] riscv: ftrace: Add parentheses in macro definitions of make_call_t0 and make_call_ra
Date: Tue,  8 Apr 2025 12:51:21 +0200
Message-ID: <20250408104824.735742401@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dcf1bc9de5841..3d97c951a3847 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -82,7 +82,7 @@ struct dyn_arch_ftrace {
 #define make_call_t0(caller, callee, call)				\
 do {									\
 	unsigned int offset =						\
-		(unsigned long) callee - (unsigned long) caller;	\
+		(unsigned long) (callee) - (unsigned long) (caller);	\
 	call[0] = to_auipc_t0(offset);					\
 	call[1] = to_jalr_t0(offset);					\
 } while (0)
@@ -98,7 +98,7 @@ do {									\
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



