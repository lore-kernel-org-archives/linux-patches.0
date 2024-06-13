Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC1C143883;
	Thu, 13 Jun 2024 12:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281069; cv=none; b=HfP2BfdGK0u0xk525BMhUfBpwOTdLqCKDyUIR0MltJVy9ucPHbXohCMFhl0KqXyie8PX3M4Ktmmg2617QcywE7+6mMNCIjKo1bTBOLaU4nNKqcVBfkk52qalTjsWCO8/55ncQwmk7lO+NNw17Sa3uFcjGa+AW0YZT5Bu/7aJEFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281069; c=relaxed/simple;
	bh=tTw9115B4xgumtm47YEqxm0P7aW1ufxRdFIDZpFh8LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnJ2CdfTjdjZG9GnhHmZ3XtVJETXD/lrQPpjluvwvAG9v6Vi7A+mhxFNgvi9VRcalXXq10vuYvn+OL1Elo2/9fBje2c+vHmFG+ZiVoJM4tn3NJQuAO83I4O9K/k66lqdgGHOvCpzOxr/VL+2tsDKNi8W+0gE659m9sE04DR95Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwzbYcH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwzbYcH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5436FC2BBFC;
	Thu, 13 Jun 2024 12:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281068;
	bh=tTw9115B4xgumtm47YEqxm0P7aW1ufxRdFIDZpFh8LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwzbYcH2A31uRIpqv6iiZyxBjEpX7TU6bDPhk5KYu4WkVOHDjgmUc1hzpLBoWNx6A
	 IVPlm+pWTC7jIQblco0kK9OgICHSgaHCjzrBXjJN8L913wV2Wvhq2fWFoSNzL1RExz
	 wspgevQHwyYMbbbv5hdcXBo6ILZhHpU46oGTZ5lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/317] selftests/kcmp: remove unused open mode
Date: Thu, 13 Jun 2024 13:32:26 +0200
Message-ID: <20240613113252.511071131@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Liaw <edliaw@google.com>

[ Upstream commit eb59a58113717df04b8a8229befd8ab1e5dbf86e ]

Android bionic warns that open modes are ignored if O_CREAT or O_TMPFILE
aren't specified.  The permissions for the file are set above:

	fd1 = open(kpath, O_RDWR | O_CREAT | O_TRUNC, 0644);

Link: https://lkml.kernel.org/r/20240429234610.191144-1-edliaw@google.com
Fixes: d97b46a64674 ("syscalls, x86: add __NR_kcmp syscall")
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kcmp/kcmp_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcmp/kcmp_test.c b/tools/testing/selftests/kcmp/kcmp_test.c
index 25110c7c0b3ed..d7a8e321bb16b 100644
--- a/tools/testing/selftests/kcmp/kcmp_test.c
+++ b/tools/testing/selftests/kcmp/kcmp_test.c
@@ -91,7 +91,7 @@ int main(int argc, char **argv)
 		ksft_print_header();
 		ksft_set_plan(3);
 
-		fd2 = open(kpath, O_RDWR, 0644);
+		fd2 = open(kpath, O_RDWR);
 		if (fd2 < 0) {
 			perror("Can't open file");
 			ksft_exit_fail();
-- 
2.43.0



