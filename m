Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E902D2F0026;
	Thu,  3 Jul 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555869; cv=none; b=X7HIZ/Il2sL5ogwazOU45pzVKRW3698jU92ervHrcAAcUYexzYUxYjcBNPajCD7UXFT8Kc9y56ilK9sqUQflSBZAzgAmyFLveRYIue/u+IgubFrz1KB4eTumVtIzYUjD7pfVf2FBpzi/3KIGyVYtw9oE8pqQA7XmKQ6mppPrZk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555869; c=relaxed/simple;
	bh=lyFC/cBoRvACIEfhJhzBzrFlvymEsoz5jzTnhUWyjoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnF9WBAPyC7P2jmQ6ID8qYb21isa3yPuBHS38K4Vri5ZK7TciSjphM1aeA0tNMv26FQ16aUSVQ3Qu4QFM+WDut8qZbaWohoeUKScaZ1u+MbWr5CXjZpTW1w8srdX/4sPgpHJyhgADFPWrd2cdWl9izblyCg3LEUROXVKUkOOtI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Csi23R1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Csi23R1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF75C4CEE3;
	Thu,  3 Jul 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555868;
	bh=lyFC/cBoRvACIEfhJhzBzrFlvymEsoz5jzTnhUWyjoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Csi23R1pY68X01tllpp2d/Hl5Pw3yhZAFR0SIytu5p5tpd08Ob7OBrMubsCJuitYW
	 awZenWiva43Xk9OOBZzmW0KU7scUHFUfIYYvoxhAlslZ1K7bTiDpgCNxWTv6Gc2wdN
	 YmbJEiOjBdq2IN49sscXJPNsEvmFc0HZHtxuL61w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 134/139] x86/tools: Drop duplicate unlikely() definition in insn_decoder_test.c
Date: Thu,  3 Jul 2025 16:43:17 +0200
Message-ID: <20250703143946.418227822@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit f710202b2a45addea3dcdcd862770ecbaf6597ef upstream.

After commit c104c16073b7 ("Kunit to check the longest symbol length"),
there is a warning when building with clang because there is now a
definition of unlikely from compiler.h in tools/include/linux, which
conflicts with the one in the instruction decoder selftest:

  arch/x86/tools/insn_decoder_test.c:15:9: warning: 'unlikely' macro redefined [-Wmacro-redefined]

Remove the second unlikely() definition, as it is no longer necessary,
clearing up the warning.

Fixes: c104c16073b7 ("Kunit to check the longest symbol length")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250318-x86-decoder-test-fix-unlikely-redef-v1-1-74c84a7bf05b@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/tools/insn_decoder_test.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/tools/insn_decoder_test.c
+++ b/arch/x86/tools/insn_decoder_test.c
@@ -12,8 +12,6 @@
 #include <stdarg.h>
 #include <linux/kallsyms.h>
 
-#define unlikely(cond) (cond)
-
 #include <asm/insn.h>
 #include <inat.c>
 #include <insn.c>


