Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [45.157.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA77E4E73CA
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659764; cv=none; b=MmorG37lQ8M8iDE1MzSU4jVJiZHNyjAzcUAXmxg3iK66Pj5MerAac23BfKFKEqadH2PjwlHQcpNKK4MJu/udkiHMLv/C4/auUck0Rc5AbouNb+bxQa2BClKm4scdxfs7gKod9ZEhfAy55ciLYOe6MM5A/sWwkD01SZM08M/DZQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659764; c=relaxed/simple;
	bh=xFvgNitfMvo65FADLIbS9Nu1T8sk1RSn3GrcQ2vUUes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujn2+8kTt6ugu9TErs0fRIahFmyOWaX9PvtKrBA0s0HypVgOU2Qe9wnx9ioCK0e7O/76kSaEVGsoE144jYl8SBGfNkP0ZWQhIoX8KODWq849h8Ahxb/LaVATIMg6z1XoFRo9gUmpysrfW6gfIoJKpXjGXHNLy9gjnQUyPz5oqj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=x67mbk2p; arc=none smtp.client-ip=45.157.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="x67mbk2p"
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hm0Pj1C3RzBPN;
	Thu, 17 Sep 2026 17:42:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789659752;
	bh=TuhqDm8FDSxFczLLbID82yK/CBX52AdJb09RSZAIB80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x67mbk2pO3WCDOqIJriniHeF731V/3oFNWg9ZQg28dh+TyndkdYok0KdGbWYYTELL
	 wpovOy2UERjYVTdN6Cd0JasToUN1EVFWEyW0EpTAQ7sa1XiVuJzLRfbCFctTwM3hBV
	 erXyG67VAhqWj9RTUXw+2B4D6NZp6cSLobAwKAy8=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4hm0Ph0KcxzLmD;
	Thu, 17 Sep 2026 17:42:32 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>
Subject: [PATCH 7.2.y 1/3] selftests/landlock: Use an actual chardev for MAKE_CHAR audit test
Date: Thu, 17 Sep 2026 17:42:27 +0200
Message-ID: <1aa1d524419bd5119577f0ccb8b6c058b32021e4.1789655724.git.mic@digikod.net>
In-Reply-To: <20260904045811.854612571@linuxfoundation.org>
References: <20260904045811.854612571@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

From: Günther Noack <gnoack@google.com>

[ Upstream commit 173b1bd8730825e1f6862dbd07856e7d68447a41 ]

By passing a (0, 0) device number, the audit test for
LANDLOCK_ACCESS_FS_MAKE_CHAR was accidentally creating a whiteout object
rather than a char device.  In preparation to treating whiteout objects
differently, use an actual character device instead.

Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260813093157.1436894-2-gnoack@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 tools/testing/selftests/landlock/fs_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 86e08aa6e0a7..e82b56a74c5f 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -7436,7 +7436,7 @@ TEST_F(audit_layout1, make_char)
 
 	enforce_fs(_metadata, ACCESS_ALL, NULL);
 
-	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, 0));
+	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, makedev(7, 0)));
 	EXPECT_EQ(EACCES, errno);
 	EXPECT_EQ(0, matches_log_fs(_metadata, self->audit_fd, "fs\\.make_char",
 				    dir_s1d3));
