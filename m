Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36512EF9AA;
	Thu,  3 Jul 2025 15:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556289; cv=none; b=kYIzw1ZobTbvcyf1vceaecwD3Lsw8wbAafLBAFejilT0WXYy8mv6vZMdv0pC6/Us9Xji3ba7uq0UKHam1i470IYUMpDwIxRtLcy6K0BhNyTFx4T0gxF2lK2PtJEOs3OpFyyQBmrZx/GtoaWK17HHFRqzvSWl3BLGQOrRByPgrUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556289; c=relaxed/simple;
	bh=hhRSZq+AYocMZU9jVW1RuZe9J0rsvJeMSnYj2QaWNGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d30a/m6qiYwPZ7nz5E07QAm5eA4M0inA4F+hCWU2tuIivzJMCyWIjfPP+SulgB35IgHhM41/+687Rr/i/hWvMl61GepouEItobseBO0GNtpo2jNNPDW21OH6rPML6KBsLaRyML6d5K+vZdxK4A0wKXVY6ttN0cQD/H1J+/TNn+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6KGEV+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6KGEV+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E23C4CEE3;
	Thu,  3 Jul 2025 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556289;
	bh=hhRSZq+AYocMZU9jVW1RuZe9J0rsvJeMSnYj2QaWNGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6KGEV+2x72itFG/+qDgRcTsKW+TkSnaj+keTNr0v/BhVzDFi+sRkRGFBCehJuwN7
	 AaiKFIkvH3PkzvqpZFpxj7sKcp6jmY/qr4A9LYx/UH7jFNdT3Tl4wDJYUFJvfGaCF6
	 YFVda4/lTvtiuadLy7YTc1f+JVSGvfg/KZwIHDLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 126/132] x86/tools: Drop duplicate unlikely() definition in insn_decoder_test.c
Date: Thu,  3 Jul 2025 16:43:35 +0200
Message-ID: <20250703143944.339411330@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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


