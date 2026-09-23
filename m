Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAB34F55AC;
	Wed, 23 Sep 2026 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172641; cv=none; b=tLg7X0eSjIQC6gv94P2upN8DNkXwDO1GLWoBx+hDtCuXj8Wv90vdkIAqxWVqJuCnvxD6BJZcthjCfsLrg3X/+EmE/mnbPU6AKGPwgzvYWHVEiXY9b+I7KqBs3ooT1+NJbEHrQof8ilDXksAarP6FLhPLN1kY0wcbzPPb8bd25sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172641; c=relaxed/simple;
	bh=06na8ZAKrB/T0pB++u7S+RrfeqMuwaJSMSK79DkaVhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3pkGh/rNdJbUXYWs4oLo2Xj2M+Q+KH9wp1fjT8fOmg1FogqboHHIGUWxMAIbz4OncXnjzDZC5cyCSHFafVyB54E4STMGcpYsKAoHAMUoxGqdljVNblDkexVjOGRNUrgJ5YvcencxWXvPEyylJwYvZY6EXPAXq7XGh8PlmwiyTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHxYwjbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHxYwjbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CBD1F00893;
	Wed, 23 Sep 2026 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172640;
	bh=nf1XWs0aPKYAn0DkurxWEuV8RcnZZ4S+tF097Tr6mYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHxYwjbKv4r0qtooge2b54KoRvEPCavOCSu6RM+545H+nwvWhjqaJ2sLZkxSpjH2O
	 unbVBjKVFaydwxOWYlCiP1BqTMPidZR4lnDzGDiqlUBBt1efT0mjSRkEOHU/BoKpca
	 /PEjss7uOFcYZhKF6s3Nbires9L1W54nnr6oaDxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/398] selftests/landlock: Use an actual chardev for MAKE_CHAR audit test
Date: Wed, 23 Sep 2026 16:01:24 +0200
Message-ID: <20260923140643.712672431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Günther Noack <gnoack@google.com>

[ Upstream commit 173b1bd8730825e1f6862dbd07856e7d68447a41 ]

By passing a (0, 0) device number, the audit test for
LANDLOCK_ACCESS_FS_MAKE_CHAR was accidentally creating a whiteout object
rather than a char device.  In preparation to treating whiteout objects
differently, use an actual character device instead.

Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260813093157.1436894-2-gnoack@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 6b573ca53855e..d8a351273482c 100644
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
-- 
2.53.0



