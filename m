Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1831D2796;
	Wed, 16 Oct 2024 21:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113167; cv=none; b=JymouRn6XaYjcqX1jVe1zfie0Bn12zb033homQ6LFQP3rUazZCeZdIQ7edNkE90CJUo9w4SCo3y2ykFQBth/L8+6TwoheEeTQzjPDtO+nss7Q/XNUpgQ+Bx8gDMpP9R3sEVVRl6gmoh1g+UJrWcJK5xn7SzputAFDFZQ+EfHxdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113167; c=relaxed/simple;
	bh=S/t7EO/pV80OVsSMddiDyh0HtBgYgcq4zwF02N632nI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ad/HP2e1gRwdMd4huULshXFtoidkNcGv/s4hlyaocBqQaRiPKa5aIc3pWb+KAKXGu59yv9DLfID2G+UdIjkKESaaXcKp5bjDv6OZckniuQr8z/nImipNxnpXP1g8VsKowXo5oOKcbr3Ra3VAVikb6X90zc3g20b6I3SSVCADTP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uV/w0oHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uV/w0oHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E57AC4CECF;
	Wed, 16 Oct 2024 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729113166;
	bh=S/t7EO/pV80OVsSMddiDyh0HtBgYgcq4zwF02N632nI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uV/w0oHOwBQ+NDUL6z8FHft8RN4lgX3EMUBtvhnBIDFVDTtYXhSQOLnsDDHpooP3q
	 jdHe97X/Nm2Jinkw91UtpvCCHe/vwDD0iFwo5d4v+dpc0S143iJgsFNWc6a5oYW1Hu
	 XqOu/foVP1l6NnKmdib11PfJURzxrbUhaf85izGjGSrSrQo4yjizJ30YXpII9vhXF3
	 tVOwM2eacOKUoajpNotZXPn4xKMV/9a02aWLvU2TvgQkg1tZjZLmCM9oBj5PqUgN/h
	 c84s1PBSIyonAW5v42CwWERYZNs46o6XbaKRmffqKo8deOUKroyg/ViGumFZRSlM56
	 6wp4LgFSsy+Cg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 16 Oct 2024 14:12:37 -0700
Subject: [PATCH 1/2] um: Fix passing '-n' to linker for stub_exe
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-uml-fix-stub_exe-clang-v1-1-3d6381dc5a78@kernel.org>
References: <20241016-uml-fix-stub_exe-clang-v1-0-3d6381dc5a78@kernel.org>
In-Reply-To: <20241016-uml-fix-stub_exe-clang-v1-0-3d6381dc5a78@kernel.org>
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Benjamin Berg <benjamin.berg@intel.com>, linux-um@lists.infradead.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1041; i=nathan@kernel.org;
 h=from:subject:message-id; bh=S/t7EO/pV80OVsSMddiDyh0HtBgYgcq4zwF02N632nI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOkCOj5tr/Y7uLt9WCLE69N5tTU4cW94sGH/pkzzBxtNN
 gSo89/pKGVhEONikBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABNh4GD4w3NAqMg9M28Oc3Wk
 TqHbYnudXwsmt9zb8YdjgYel60HJTEaGd/6rJ3SVddWu/cm0i7mp7Mi6S9V71lVmV8w777SxJOk
 6LwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building stub_exe with clang, there is an error because '-n' is not
a recognized flag by the clang driver (which is being used to invoke the
linker):

  clang: error: unknown argument: '-n'

'-n' should be passed along to the linker, as it is the short flag for
'--nmagic', so prefix it with '-Wl,'.

Fixes: 32e8eaf263d9 ("um: use execveat to create userspace MMs")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/um/kernel/skas/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/skas/Makefile b/arch/um/kernel/skas/Makefile
index fbb61968055f44ac8a963d4c7d250e7c6bbbb321..f93db893b8236cf805edd01b41501d51dd8f0a35 100644
--- a/arch/um/kernel/skas/Makefile
+++ b/arch/um/kernel/skas/Makefile
@@ -27,7 +27,7 @@ quiet_cmd_stub_exe = STUB_EXE $@
 			   $(KBUILD_CFLAGS) $(STUB_EXE_LDFLAGS) \
 			   $(filter %.o,$^)
 
-STUB_EXE_LDFLAGS = -n -static
+STUB_EXE_LDFLAGS = -Wl,-n -static
 
 targets += stub_exe.dbg stub_exe $(stub_exe_objs-y)
 

-- 
2.47.0

