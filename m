Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B0318657
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6vSrsJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D567BC4E759;
	Wed, 15 Nov 2023 20:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081507;
	bh=/1sNiiJo/bCH9YuXmuRJJn1K90AYcdTW2flwHlBY9jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6vSrsJny3BNF58mrHsAZZeeCBu6XNmjO8TXSFVhL5QNvKwiVA2y+XorZQSYYs8ne
	 rTuHrYz6y43GlQK9Va8tfri7WRWw2JyM12UVYQrhtjvOzFlBLBjuFNByEZvC5mJCGl
	 WDZOpBtP69u7jsxP5gIKkMWtRCsyipl8HRnulg7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/244] livepatch: Fix missing newline character in klp_resolve_symbols()
Date: Wed, 15 Nov 2023 15:36:02 -0500
Message-ID: <20231115203558.549557951@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit 67e18e132f0fd738f8c8cac3aa1420312073f795 ]

Without the newline character, the log may not be printed immediately
after the error occurs.

Fixes: ca376a937486 ("livepatch: Prevent module-specific KLP rela sections from referencing vmlinux symbols")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20230914072644.4098857-1-zhengyejian1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/livepatch/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c0789383807b9..147ed154ebc77 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -244,7 +244,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 		 * symbols are exported and normal relas can be used instead.
 		 */
 		if (!sec_vmlinux && sym_vmlinux) {
-			pr_err("invalid access to vmlinux symbol '%s' from module-specific livepatch relocation section",
+			pr_err("invalid access to vmlinux symbol '%s' from module-specific livepatch relocation section\n",
 			       sym_name);
 			return -EINVAL;
 		}
-- 
2.42.0



