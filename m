Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [83.166.143.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3713C4D486F
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659712; cv=none; b=iv2ITcv3/CHtjQRBETcE3aIBwnEuw972EUd8vRfGZIza5EiqC8HbkhTJlGHDYjZ/ZDhw3c7vDAkWY1A0H01hwivTxTB3scvGT3+DqNa/Phz2JqNSaShUpVxWb5MqFElx2r50fiy1Xfd7LQW4jOSuHVj5YA9EXlWlOv8pdgP+UnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659712; c=relaxed/simple;
	bh=nBSl5Pgzb2KhJmOoQ6yUqBLLtTIDVDSSQMxnJuZmzUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8rGklltA0R4fmgxk4qzgh//mwNDy82DENSAKnCTndUrHASpsza+C5lWlN3cdrNuDd0N/Wpees5V7YIUzhMOG2DQLDUqDCJAxYqCHQAFUPoRHPopEkTkG7grn1oHVx1L3CmciuNYDE/S+F3Szmmco1nq0Dbo2fLmCCm8xs+ly7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=LQbTwaDw; arc=none smtp.client-ip=83.166.143.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="LQbTwaDw"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hm0NY3kcvzc7C;
	Thu, 17 Sep 2026 17:41:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789659693;
	bh=gPWOog/98t63u5XbHxLecl3ddi++ZffyRfW8TmHFDOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQbTwaDw5lsGl9H1vruy6w9WypsG0cFsI55YuVtiNY1K5bGvtuCbprpsn+0ehYvct
	 Sj9s5dureMhu6IwQ8AmnW3mn+u/EgBhGyKzHYOPMQNPe92nL3Xv9loomHBVOnroSKt
	 oUtySaqV6YjLJPx6nT7ThNDuPzgIZZAuvoPc0/GQ=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4hm0NX7091zD3s;
	Thu, 17 Sep 2026 17:41:32 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>
Subject: [PATCH 6.18.y 1/3] selftests/landlock: Use an actual chardev for MAKE_CHAR audit test
Date: Thu, 17 Sep 2026 17:41:28 +0200
Message-ID: <200794b92b5f014ec277099a0b64e4ab375a0a89.1789655724.git.mic@digikod.net>
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
index 6b573ca53855..d8a351273482 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -7315,7 +7315,7 @@ TEST_F(audit_layout1, make_char)
 					      .handled_access_fs = access_fs_16,
 				      });
 
-	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, 0));
+	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, makedev(7, 0)));
 	EXPECT_EQ(EACCES, errno);
 	EXPECT_EQ(0, matches_log_fs(_metadata, self->audit_fd, "fs\\.make_char",
 				    dir_s1d3));
