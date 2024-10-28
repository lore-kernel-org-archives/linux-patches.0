Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBCD2AF07;
	Mon, 28 Oct 2024 06:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098525; cv=none; b=TYG3yST0nMHZ+xaCzIF44Ek5XshlU4duO1GwtsGE46Ot1RTnLCGkdXN4o82ik3Stk+ss+4j7mIVONmUFnA78FW4YNsAaJCs1PYKYo7oGyDVl3I3P8qQdKzpyR/WQCY124FAbCzfA9uq0iVQdN8ECbaYXA1Mwqn9tjdUaQs+IywQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098525; c=relaxed/simple;
	bh=rrFtlMu2vnn0mtJILBhVJiaxgrto/At0NiqWMTt6LbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0C6lJ+sKdUAX0eMEExkvG3s88vNKdyv/CFpqBitvhZCgd9Ks5bwGp95cxiweLOz5AlnoSwXJGwllvnDaOHQMPTS5vGFjB+xQMaxX1OThtPWdEkks67U5TNUWkQG42Eg1b9SjbvqM5tf865Ph7eOwwaLisJZ+1/ZkgVl4AXg7r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DITbnAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DITbnAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7ACC4CEC3;
	Mon, 28 Oct 2024 06:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098524;
	bh=rrFtlMu2vnn0mtJILBhVJiaxgrto/At0NiqWMTt6LbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DITbnAWxP3knYABwE7/iLgVebHjDngpoLmt1RBgPxNuDw+JT1AnBtvjhTZ9Q+f+S
	 Odq/nokUEgrs7I/teGBRMO3l13NWyumkeBtuzSipeG4qv5IZoWC8CYmbmgWf34gW57
	 AOjbPpOYWAmSoyKdzFTdfIY2roaQzdn9njTYB8TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.11 257/261] x86: fix whitespace in runtime-const assembler output
Date: Mon, 28 Oct 2024 07:26:39 +0100
Message-ID: <20241028062318.533435463@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 4dc1f31ec3f13a065c7ae2ccdec562b0123e21bb upstream.

The x86 user pointer validation changes made me look at compiler output
a lot, and the wrong indentation for the ".popsection" in the generated
assembler triggered me.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/runtime-const.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/runtime-const.h
+++ b/arch/x86/include/asm/runtime-const.h
@@ -6,7 +6,7 @@
 	typeof(sym) __ret;					\
 	asm_inline("mov %1,%0\n1:\n"				\
 		".pushsection runtime_ptr_" #sym ",\"a\"\n\t"	\
-		".long 1b - %c2 - .\n\t"			\
+		".long 1b - %c2 - .\n"				\
 		".popsection"					\
 		:"=r" (__ret)					\
 		:"i" ((unsigned long)0x0123456789abcdefull),	\
@@ -20,7 +20,7 @@
 	typeof(0u+(val)) __ret = (val);				\
 	asm_inline("shrl $12,%k0\n1:\n"				\
 		".pushsection runtime_shift_" #sym ",\"a\"\n\t"	\
-		".long 1b - 1 - .\n\t"				\
+		".long 1b - 1 - .\n"				\
 		".popsection"					\
 		:"+r" (__ret));					\
 	__ret; })


