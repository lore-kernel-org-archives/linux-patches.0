Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E037832B99B;
	Mon, 29 Dec 2025 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025039; cv=none; b=mdn+kGTPSMU4NCUX55myqc1yT/bIhlTEvMzkUFRZ4MGcIwROhWhS+5/ZqdTobf0KWJZuJHcKs5SBA9dcCeG39zvDG9PJEJqeQKVa+Gsf5+MDt+Rk1OzDbplO6bj2XmtXR2ftHWsy55Bsc+tzDH8AcCWaL78fs0jIYlaHOGK2hYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025039; c=relaxed/simple;
	bh=wxKt/eIvBmaH4zMyE7ZxsuzNget1ST9dyB3NGF1J3+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EQmiZdnDzxqKSys8l5Is2VEKqxCUzxGM0TMzxA+8uStCE74cbr8bqkyEMONedRJr/88Mwlgw1iqudH/0zsKEg2dkGTiOZ0ouLM8LNG58REVhcA+fm0ZhdZjxO/sRPh51G5q7ZDfDZ6DYsMsddw+KQwbEc3fA3ebntL66czs0kzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZUNyCYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZUNyCYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD77C4CEF7;
	Mon, 29 Dec 2025 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025038;
	bh=wxKt/eIvBmaH4zMyE7ZxsuzNget1ST9dyB3NGF1J3+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZUNyCYXPvCDR+hMVvz3WsB20xCUwNWHCp4XG8mKRWEEHiJHK6v77+BLeRc388XMM
	 M82NP3LuSCQL4lU+Ry2Z36ihoZDIZ9Hf7N/qNBnIELgX9AIBRfnm3RWFQnPtf+E03z
	 1b8RmX+QDcu4kZtjfIQgS4FUFyHzX6qW4APSahs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/430] selftest: af_unix: Support compilers without flex-array-member-not-at-end support
Date: Mon, 29 Dec 2025 17:07:55 +0100
Message-ID: <20251229160727.052339645@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 06f7cae92fe346fa49a8a9b161124b26cc5c3ed1 ]

Fix:

gcc: error: unrecognized command-line option ‘-Wflex-array-member-not-at-end’

by making the compiler option dependent on its support.

Fixes: 1838731f1072c ("selftest: af_unix: Add -Wall and -Wflex-array-member-not-at-end to CFLAGS.")
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20251205171010.515236-7-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/af_unix/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index 528d14c598bb5..2889403e35468 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -1,4 +1,9 @@
-CFLAGS += $(KHDR_INCLUDES) -Wall -Wflex-array-member-not-at-end
+top_srcdir := ../../../../..
+include $(top_srcdir)/scripts/Makefile.compiler
+
+cc-option = $(call __cc-option, $(CC),,$(1),$(2))
+
+CFLAGS += $(KHDR_INCLUDES) -Wall $(call cc-option,-Wflex-array-member-not-at-end)
 
 TEST_GEN_PROGS := \
 	diag_uid \
-- 
2.51.0



