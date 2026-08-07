Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FD53A3E7A;
	Fri,  7 Aug 2026 14:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114708; cv=none; b=QyCjjWJXf9d2k+jfPl3o/OmNo8nHp7Y+c3WmgyMDh4l1UeypTyRUwr5k0D+3AunDPOznPGL8DY6E0SFUwV/p2ngXZUsWCij1mZxfL8Pa7z2pYnDEobZm8j1XUXWNVbv17LLp7X+YZCq3mz7zT/yzc0kVAwnyqSUbnrf4awqy670=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114708; c=relaxed/simple;
	bh=cGorWnF5OWV1DTxWBhe6xXtoO53cNZz+82yDPf/Qlw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZswrkH6yftTWr4e15HXcV4vl5g2G4zYfSTt5RXEqGDyhId4o9Po7NNbBm/2keo0v7omUuUf0er0mnoREqEk75JX6EqSs2OLjNpCxuc5OxBftAQmRWGcyr/ziYypuDYFBe/a1++zeCZajiaAclBE89wAc826Dvnlg9olTYOcNxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF25hd/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF25hd/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0566E1F000E9;
	Fri,  7 Aug 2026 14:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114707;
	bh=yBVatAnFoPHZJBMXmFUqSSpjLKIFe5rZQdhAJ9j7iEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SF25hd/tgzjJ66OJqaGBY3ybh/rX3Mg2MBMnyEHpu7iTq++cB0EXOZ51AbRb56Fk9
	 WNvhv6xE5nnVPN19JHd+0MdrqtIc2FGPFITfMJGw62HhWK8msroHHd/nqIwbdLSydk
	 E8DwKB99Id5cL8AhEbrQjuAPRcw6AaNyTpsz7ONI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/396] selftests/lkdtm: rename STACKLEAK_ERASING to KSTACK_ERASE
Date: Fri,  7 Aug 2026 16:33:00 +0200
Message-ID: <20260807143424.712201048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cff124c1eddd3..665a13a37363c 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -74,7 +74,7 @@ USERCOPY_STACK_FRAME_TO
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



