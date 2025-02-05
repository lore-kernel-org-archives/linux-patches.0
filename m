Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0B31547D8;
	Wed,  5 Feb 2025 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765442; cv=none; b=FX9wnhZVyscaSm9XMm3CRfMJwaYUqxQjR7QE6BkuG7LDwsXAsAbIA/oHVjBBlm3hapwUrUnO21Wlh2LNH4yGjIcVN0vJ/an4rSAXQCJhVSkwFnNQdy5UDXJLXnAGt0skm1Xk/+rhUZMQDlVpN4FEbrj/letLEuAsLtLrYRToHQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765442; c=relaxed/simple;
	bh=gW8lffTZ1tV9XAdkxhtG8C4vaStnfFuVpxJjnbMZM/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRl2sbCrMUhzLWkY4yWZbwEb2Ghvhb756FHFPy2Tu30a0o8YkCRTRfhBo+iwKfXCmA1jNweuPL2zKZa/6kbmshV4+B+ELObR31kEJU5EOxVwFFfXYLg0tIqzoUhbLFzD2hID1bQ8DxoTwwWxlpms362/8iT1aBh8Vgv7jnbFWIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GITLkS8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GITLkS8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFF1C4CED6;
	Wed,  5 Feb 2025 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765442;
	bh=gW8lffTZ1tV9XAdkxhtG8C4vaStnfFuVpxJjnbMZM/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GITLkS8OnLVqCd5sv/Set7+EO0sQAcV+NpPXJkLSZmGZAqiDPko6Iwa9oIsJxUIN2
	 n2iPVI1r2tgLdIXnhCJpX4eoZRyBN2ziPydKiu3TFWSd1Qlr/B9uWjEc7H39179RwQ
	 t3Gu/efiXjP0/AHVjAiLT2f7O5IrLA3e2lRglL2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Tahera Fahimi <fahimitahera@gmail.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/590] selftests/landlock: Fix build with non-default pthread linking
Date: Wed,  5 Feb 2025 14:39:35 +0100
Message-ID: <20250205134503.702043151@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 0e4db4f843c2c0115b5981bd6f6b75dea62e7d60 ]

Old toolchains require explicit -lpthread (e.g. on Debian 11).

Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tahera Fahimi <fahimitahera@gmail.com>
Fixes: c8994965013e ("selftests/landlock: Test signal scoping for threads")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20250115145409.312226-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index 348e2dbdb4e0b..480f13e77fcc4 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -13,11 +13,11 @@ TEST_GEN_PROGS := $(src_test:.c=)
 TEST_GEN_PROGS_EXTENDED := true
 
 # Short targets:
-$(TEST_GEN_PROGS): LDLIBS += -lcap
+$(TEST_GEN_PROGS): LDLIBS += -lcap -lpthread
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
 
 include ../lib.mk
 
 # Targets with $(OUTPUT)/ prefix:
-$(TEST_GEN_PROGS): LDLIBS += -lcap
+$(TEST_GEN_PROGS): LDLIBS += -lcap -lpthread
 $(TEST_GEN_PROGS_EXTENDED): LDFLAGS += -static
-- 
2.39.5



