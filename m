Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF12265633;
	Tue,  8 Apr 2025 12:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116707; cv=none; b=bCs6pXACzgWEIgw8z8nxT76Rv8LxtT5KUQ+QXiSRxuT0uW9SRisuxo07POAywNJo/1b7R5uFaBmT6DCFDXHhvWnpi9fcWgQIWu2gs60n1JQc+fJYg4a2pd5jC9NkSD6mfip3oNVEzMlL4BFqmUS3vsJtlG3IacLi/sdP0436oEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116707; c=relaxed/simple;
	bh=70DxCgvHgFEWOw7GsR4fPONm/WbSjh40zkYMZVrK0Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ltzr6Iw9+beV8RftDwepsggCBtbRZbfau0zaX6FCDgFfwzZgRhl1PFDX5eo0LBI2McH8QbaIDfUmx8dh/PU3I6Ma22wBUgB3quOTZDzSuv4C53IcZ0tSs9RjZcFBELNS4syz9GHTorhH5hlJjfr75W9J+Q0EJYL0LrUIXm7WNEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiWJbPWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiWJbPWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D256FC4CEE5;
	Tue,  8 Apr 2025 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116707;
	bh=70DxCgvHgFEWOw7GsR4fPONm/WbSjh40zkYMZVrK0Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiWJbPWm1JlWEjdcggBBCx6qZpUJPGSDxIavvBzQRO7X/7ay3OIKR7wGMST6xPzmL
	 /nOR5sGYKZvsPKvD1XA4fILmkUHbf7vIovDOzE7B4P2+H1UFnNkwKarZZPYHWDTwqo
	 R9d62L5ynq/cUnSa8QqgG7uuWNCRCWi0rl5yaRtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/423] objtool: Fix segfault in ignore_unreachable_insn()
Date: Tue,  8 Apr 2025 12:49:25 +0200
Message-ID: <20250408104851.293910943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 24a1adca30dbc..4030412637ad0 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4153,7 +4153,7 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
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



