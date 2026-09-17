Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [45.157.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940E74848B2
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659710; cv=none; b=sVa5b5o4pRxhX5SNoFvxtUGaKZWL9w6sqiRbGmUm4Y/EqtnI6Z2OTE/b1M2LtNj7pTHByRW0p9VkLmxDnMj9O3erASZYlldVeYvMCFFoVPdZjvYxqNW+KN1jLOtnSWr8ySmrkPlYvlTVPJuPuAKiPR3bJU7rOOjM7PIz3/AEhOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659710; c=relaxed/simple;
	bh=ivx+OLOBcB9IpGu9RYXyG7g9It1+08waiZVhdl1k074=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFDJ6PNa8jPv/Y7XxNoiUjjgPamftwQ4Qrf61o10ZwAMLKv4aLLE00SF6YTsqzyKR0iv8Hveiw+xckA9ZWs2+Zowb59zm45TTCKrID2qyw0vqbYLJPJZ+NPH0F485X9dA5zdVmg0wlrI6s5yp+8HmEWzvpmMWjJBC8SnxWOdoZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=P5yLSUVH; arc=none smtp.client-ip=45.157.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="P5yLSUVH"
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hm0Nc0dxzz99h;
	Thu, 17 Sep 2026 17:41:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789659695;
	bh=AIysOsGelTSXzFxukdBAM0r89JT/JMk0OcsjWUWKMP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5yLSUVHk4EN2E9GuqDerPkmNu3UjRdN9K+c3woeL6E6QsYMgB1UegSJBNqwot5QU
	 3GWThtjzxbkKPmzFgluf7lJ+W3GgCfkyQ53IeHn8mIhwiyUVM+uH6NdumlyIxO9Itm
	 Lcz8yVeS9fl9dpyPUSipyG2fbWj5gDl3hYUYf6ZA=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4hm0Nb2JVXzWCx;
	Thu, 17 Sep 2026 17:41:35 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>
Subject: [PATCH 6.18.y 3/3] selftests/landlock: Add audit test for whiteout object creation
Date: Thu, 17 Sep 2026 17:41:30 +0200
Message-ID: <9539a3c743c116978a45ddf306e1a17a9c34e62a.1789655724.git.mic@digikod.net>
In-Reply-To: <20260904045755.888243226@linuxfoundation.org>
References: <20260904045755.888243226@linuxfoundation.org>
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

[ Upstream commit 8c46c6acbebe0d8544fd1b55e5ddf36828d7b9ea ]

Add audit_layout1.make_whiteout: This test looks similar to
audit_layout1.make_char, but creates a whiteout object through mknod().
Since whiteout object creation is now guarded with
LANDLOCK_ACCESS_FS_MAKE_REG rather than LANDLOCK_ACCESS_FS_MAKE_CHAR, it
also needs to log the matching denial to audit.

Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260813093157.1436894-5-gnoack@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[mic: Backport: adapt the audit test to the older ruleset helper]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 tools/testing/selftests/landlock/fs_test.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 3088d301073e..ab5d7f792ee2 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -7522,6 +7522,27 @@ TEST_F(audit_layout1, make_char)
 	EXPECT_EQ(1, records.domain);
 }
 
+TEST_F(audit_layout1, make_whiteout)
+{
+	struct audit_records records;
+
+	EXPECT_EQ(0, unlink(file1_s1d3));
+
+	drop_access_rights(_metadata, &(struct landlock_ruleset_attr){
+					      .handled_access_fs = access_fs_16,
+				      });
+
+	/* Whiteout creation is denied and logged as fs.make_reg. */
+	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, makedev(0, 0)));
+	EXPECT_EQ(EACCES, errno);
+	EXPECT_EQ(0, matches_log_fs(_metadata, self->audit_fd, "fs\\.make_reg",
+				    dir_s1d3));
+
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+	EXPECT_EQ(0, records.access);
+	EXPECT_EQ(1, records.domain);
+}
+
 TEST_F(audit_layout1, make_dir)
 {
 	struct audit_records records;
