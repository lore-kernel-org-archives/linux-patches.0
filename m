Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D0B2837A
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R7zFJNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFB9C433C7;
	Wed, 15 Nov 2023 19:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076697;
	bh=Eho3B012aL8xGKlLzJz+n9xUlnxtbhchHKG0NSDdc6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R7zFJNB5yabjBEtRg3YD34VOZA0JX9QShtmQWQEIGFVlHpY8B/Zzu/46gXkMGTAL
	 L5Rxoz8dkJ2oZIFVwbAdCa0Ot+1Sr2myd+wSeR8BzEm89ElAgGlnvviVPH3Kl6D15S
	 tkYMbf/z+wRyfrp5VLSpg1kq+rySyOtGvAmW4AV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 392/550] livepatch: Fix missing newline character in klp_resolve_symbols()
Date: Wed, 15 Nov 2023 14:16:16 -0500
Message-ID: <20231115191628.017083795@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 61328328c474c..ecbc9b6aba3a1 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -243,7 +243,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
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



