Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9E6268C6F;
	Tue,  8 Apr 2025 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111791; cv=none; b=kkJvdr/BucQ9jd/Y9NIMv57Sx7ZhOjBqNw9nFltPr0F+Gb3b4Fi4iiorLyq+Vn8AcTu0WO1ek+0pqqzmWTP9W821f9SvrYtgd5dzT82hq3a3DZB1gTNbvytOFj3h6gqg1MaS+GlcNJWhl6ZuXCGgAWjYS3Umx4b7mX9UkPoTIAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111791; c=relaxed/simple;
	bh=6TDLd3EUJC6tmZp0sKOqW/CSik75v3RkNlTElKL41+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZPKi8I6P5gxWFxSKMr9vQxberWl/DOeDVzqNpmCV+W/aeW8B8OKS+VUbRnPKXISI1LFGb1uC1AnX19TtkY07p04Win9h0fLBEwBPzKjBzslMX6klzl+ujb9s3Hvb1YdwTpG+ePsgxaV/0rLS4G6H7ncOnvqJ/vb4r3QvOsJiGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxXS5Xhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxXS5Xhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E978C4CEE5;
	Tue,  8 Apr 2025 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111791;
	bh=6TDLd3EUJC6tmZp0sKOqW/CSik75v3RkNlTElKL41+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxXS5XhdMy9jMZwIrG0OQr457cLYsdcKQlzmNsXUwYvtEGXdqP4zS/MuP3S2CUA+x
	 zxqipS1debaXJWbB68eVd1QkDxEgld+r+mtCfO3gRYS/xzRAOhT05sIjgVX7F/TTkr
	 mFrBq5ktpoEAR5w2CYdXOOMX64PdjHlu30Gsxv5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 562/731] objtool: Fix segfault in ignore_unreachable_insn()
Date: Tue,  8 Apr 2025 12:47:39 +0200
Message-ID: <20250408104927.346639468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 69d41d6dafff0967565b971d950bd10443e4076c ]

Check 'prev_insn' before dereferencing it.

Fixes: bd841d6154f5 ("objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/5df4ff89c9e4b9e788b77b0531234ffa7ba03e9e.1743136205.git.jpoimboe@kernel.org

Closes: https://lore.kernel.org/d86b4cc6-0b97-4095-8793-a7384410b8ab@app.fastmail.com
Closes: https://lore.kernel.org/Z-V_rruKY0-36pqA@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 813e708c16499..aa071017c325c 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4009,7 +4009,7 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	 * It may also insert a UD2 after calling a __noreturn function.
 	 */
 	prev_insn = prev_insn_same_sec(file, insn);
-	if (prev_insn->dead_end &&
+	if (prev_insn && prev_insn->dead_end &&
 	    (insn->type == INSN_BUG ||
 	     (insn->type == INSN_JUMP_UNCONDITIONAL &&
 	      insn->jump_dest && insn->jump_dest->type == INSN_BUG)))
-- 
2.39.5



