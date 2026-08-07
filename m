Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875D638C2C0;
	Fri,  7 Aug 2026 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116572; cv=none; b=mqg1xmuwifIRBhZyipU0alWlHsPl6sTxDMIfw+QHG56jB+NRQfIe7zyI2YaFdInvI88BxRjBPzPSqshkze1S9hr1anQEbvNoKrRxKfwMwVVio4yHHpY2IsGmS8Ec6zwufR5IZwtI4BNIL1m28shzbtA8ogkzkSPDk36ay0GjlQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116572; c=relaxed/simple;
	bh=Bt735QhSSMhY9IkY4vJCoil4ghhVOQFSbgBJ6wM7d+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDRMJl/R4KKXVPHP4mVJVkuGfYhRjo1zcvkUlk/UMgWbZ/nadTBQjhWXJFwCIMG4ScKG9ol7XctMuuPfhLLm+OXhFagH+ssu2BG7/zbNbQYxj5X9f1M+0FmWyW+RBzjodPqeKT7Ih3vvdE8OZZ4K759qattPo84XKYf48A6qZsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrMMqSXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrMMqSXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43981F000E9;
	Fri,  7 Aug 2026 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116571;
	bh=aMvr1ibEor63eRln9zBFt+xGAfcR08jFTRJewjhGYRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrMMqSXyEQiSsOmCH0aHA3xvHLyFsyfRTbQ5s+x2+ly7jU0Wd8xZ1eFMB/RHbkTjn
	 hg4Y/JvDpFmCgqBpYrLU2GylSUXt4/y6mwE6WG8Rv60nCCe2jr1wH58nVK9L7NODs5
	 zRIAtHbcVU33LC1ko2X+c+pEvk+mKf9UB/a7cUKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 016/438] selftests/lkdtm: rename STACKLEAK_ERASING to KSTACK_ERASE
Date: Fri,  7 Aug 2026 16:33:32 +0200
Message-ID: <20260807143428.355021696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haofeng Li <lihaofeng@kylinos.cn>

[ Upstream commit b3a7aa9c0020ae549a0d4964867ff66d2bd61709 ]

Commit 57fbad15c2ee ("stackleak: Rename STACKLEAK to KSTACK_ERASE")
renamed the LKDTM crash type and selftest configuration but missed the
entry in tests.txt.

As a result, the selftest generates STACKLEAK_ERASING.sh, which run.sh
skips because the LKDTM DIRECT trigger only exposes KSTACK_ERASE. Rename
the test entry so the generated runner uses the registered crash type.

Fixes: 57fbad15c2ee ("stackleak: Rename STACKLEAK to KSTACK_ERASE")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Link: https://patch.msgid.link/tencent_CD80B5F746B6AABD68AF3F1097AD02C96F05@qq.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lkdtm/tests.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lkdtm/tests.txt b/tools/testing/selftests/lkdtm/tests.txt
index 3245032db34d3..444040ca51689 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -78,7 +78,7 @@ USERCOPY_STACK_FRAME_TO
 USERCOPY_STACK_FRAME_FROM
 USERCOPY_STACK_BEYOND
 USERCOPY_KERNEL
-STACKLEAK_ERASING OK: the rest of the thread stack is properly erased
+KSTACK_ERASE OK: the rest of the thread stack is properly erased
 CFI_FORWARD_PROTO
 CFI_BACKWARD call trace:|ok: control flow unchanged
 FORTIFY_STRSCPY detected buffer overflow
-- 
2.53.0



