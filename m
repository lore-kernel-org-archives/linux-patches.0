Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE0F501F30;
	Wed, 30 Sep 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783684; cv=none; b=DnUIH3EO1bx6+9PUKVPjt1NnJqIXULe1NQgzXOz2CJOpEszlsZ57HX/hOeaFle1sVw0i9iDunn2AL3bXSt8IrhrFwZlCwOOOnCFi8M8M8GmquWon74Mg/uWopV+4d41mQNm8nsnLcDPf8h7T37zh/CRb7FqmQZ1JuCtJOGSmv5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783684; c=relaxed/simple;
	bh=XnR0ps6oF5sLf0SMjzhBILgheohXUVTpHOMpGDUkU2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fu3+z5tGB7B4gdBzENt5TZ9JARglgccf1HtL+jLdsRmmJTzjq9IxGThkbw9EP7ewPdFxq0elWh4njhx8vvv06pcmf9WmpogucWZHsxt5ytPUOBGJu9tBGJpSvD/GwZqK6wphcG0g8bXgo4tsc6I9V/kVE7hyBW5weX2ZqaHB/FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MClHawKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MClHawKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B971F00898;
	Wed, 30 Sep 2026 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783679;
	bh=nlZQzb6nm3qk/2/CCbtqoRCwqPBk4MkRrnhwLdW9KBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MClHawKZ0XHYL6sKCMFFirFKVzp/g43EFHTUwyaAom7GHxSKDZVgyGh4/V2hAuG1+
	 xpkROqRMFyZI+534dJ1JU59L7XZuD6rBk8TK/C5ijETr6PhoY6cqzdTkkTl8afoNi2
	 5SwjxzNWldP095HIynju0e50CvT7YpAe4E1vgazw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/595] selftests/ftrace: Fix unique symbol check in kprobe_non_uniq_symbol.tc
Date: Wed, 30 Sep 2026 17:26:16 +0200
Message-ID: <20260930152358.072904947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit d22c3e0088e85be8131f7a9283f759cdbb20726d ]

The current regex also matches symbols in modules, which makes the
test fail on s390 where name_show is present only once in the kernel,
but also multiple times in modules:

000001b1401cdc20 t name_show
000001b0c05e6c40 t name_show    [mdev]
000001b0c0495f30 t name_show    [i2c_core]

Fix this by changing the regular expression to only match the function
name.

Link: https://lore.kernel.org/all/20260909092954.2200558-1-svens@linux.ibm.com/

Fixes: 03b80ff8023a ("selftests/ftrace: Add new test case which checks non unique symbol")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
index bc9514428dbaf..07b1177c16344 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc
@@ -6,7 +6,7 @@
 SYMBOL='name_show'
 
 # We skip this test on kernel where SYMBOL is unique or does not exist.
-if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}" /proc/kallsyms)" -le '1' ]; then
+if [ "$(grep -c -E "[[:alnum:]]+ t ${SYMBOL}$" /proc/kallsyms)" -le '1' ]; then
 	exit_unsupported
 fi
 
-- 
2.53.0



