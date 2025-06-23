Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B7B15ADB4;
	Mon, 23 Jun 2025 22:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717265; cv=none; b=OSaq+qo/kM/UmLguBKfiexUSZ9eOhGo54LZl2/k/KZmanloCZyOccCf2p9xWtVz3l86b0rbg/5+WQI2YQV6eUQiEUdcEc0g0F+rC1mjrBNzySUBWteZMz+1iaRJF4FCOTSY9MfSwDEqQheYWZWimRsYz4vMvrnvWsMcMid15Upk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717265; c=relaxed/simple;
	bh=Z5W6CuHPVPV05Qi5cBvVC30PTJPD8Dqb/5HRn3eUB0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WC9HJBoLRdU3lEA2h6TbyVaGOC6S7xXX7gtCTclNfQ2L9mF3f9DStIALjR6jUtzhLTnlkrKoIfwKwo46frboV11Tx8BjIvSL1eoYiz3yXNYk4dEtf4vT1xBnQSysIUhsHTH8J1xcq/aTmPI150AceOOmjhnkp2yjDrpIjNWX7h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRbcmQxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRbcmQxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4550C4CEEA;
	Mon, 23 Jun 2025 22:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717265;
	bh=Z5W6CuHPVPV05Qi5cBvVC30PTJPD8Dqb/5HRn3eUB0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRbcmQxOy8AmOyaH6D4A4/dmK/KY/u9CwpSbuS/DHX5svG58jpF3V9m8ngMATjA9B
	 UJSEYGhAErAKVf/qZfdYMd0n2Ysrs4lYI4gjOJwUm8riqj3wF5fNFpxhLGiTaHZJDp
	 sYgzLOM3OskNfeN7oy3pXfhN0eE8cyjTrmcwJBH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 349/414] x86/tools: Drop duplicate unlikely() definition in insn_decoder_test.c
Date: Mon, 23 Jun 2025 15:08:06 +0200
Message-ID: <20250623130650.700321132@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


