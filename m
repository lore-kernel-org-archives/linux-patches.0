Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD42E337B;
	Tue, 15 Jul 2025 13:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587224; cv=none; b=ZkwJpCbQw5ItYdkZQmwRxufIEPu7jkjwtIHEqQ5UxGewUek1LPqE+tI65xMmWTAi2+rf90rk0I+T/qd36R3N5cdIGuQyY4RzgIemLKsrtTa4YmZoSNvkRZc5Yjw0V8GZZGfF4oTJUa2kJKnno9lCCv+X2VJ4Cvmpqqgab409V+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587224; c=relaxed/simple;
	bh=mmkLNBEUpTRHg3fp3rn6vTTt8CPTx7YnN0rW7+Qhu7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6hIquOT5e4ZFRSl/PBLhI2NzuZBufrCr4hn26IAEKV9F7YxU16XlSGf1SpK2hbupXskfRWf6CgUGLEOBpcspxbh6p0IoXYDrouKa9aznC7ZH99a5deGIM6LSAuNwpfJ/l8azXHglMav1L8Ndgz3QBIQjwf2jHGmOCssMXZ7l/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpT/6154; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpT/6154"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2E2C4CEE3;
	Tue, 15 Jul 2025 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587224;
	bh=mmkLNBEUpTRHg3fp3rn6vTTt8CPTx7YnN0rW7+Qhu7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpT/61547hQ2/CHcHzTmjexBjMex6YRAVukRtIsFf3xc8/RCrT+hX+suUB2uoQgrT
	 JQES2tuZ5H3V7CN/0KhueDtuL94367nw9pMayYtJxtuBvC554nciPEmXwLk2/j95qq
	 lfUDu74XAwbGROiq9n3ZzJYPKi6y0sHiqiSx+XsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH 6.1 21/88] x86/boot: Compile boot code with -std=gnu11 too
Date: Tue, 15 Jul 2025 15:13:57 +0200
Message-ID: <20250715130755.366749918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

From: Alexey Dobriyan <adobriyan@gmail.com>

commit b3bee1e7c3f2b1b77182302c7b2131c804175870 upstream.

Use -std=gnu11 for consistency with main kernel code.

It doesn't seem to change anything in vmlinux.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Link: https://lore.kernel.org/r/2058761e-12a4-4b2f-9690-3c3c1c9902a5@p183
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -43,7 +43,7 @@ endif
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386;
 # that way we can complain to the user if the CPU is insufficient.
-REALMODE_CFLAGS	:= -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
+REALMODE_CFLAGS	:= -std=gnu11 -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)


