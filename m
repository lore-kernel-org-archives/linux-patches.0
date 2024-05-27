Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2081863F;
	Mon, 27 May 2024 19:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837405; cv=none; b=VPDM4o0qqji+iK96g7YM1lmLXGYMQ9PTD0UdudmMnKSpA9oSjGH2VCicOdonxgyJ7+RGG5Lk6ggibpU4PsKvTH4qDk83Y984fr07uuOm7W7RsTC/+H1SQ/K/Ow0B4FyrO/3+hQNKaBGnrXSdiB25EC9Gtc96Doy/PB6FhyHXrWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837405; c=relaxed/simple;
	bh=l0IWcXFWUk0cL7KOwzgKAFGtWprjf/QBXTm/uOoK+Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFL/ESezaOdh1apMf1yRPTwWg62wAEdI0PjJE7QGKtnvPhrFFE4a4iL78WI1FTqtQlTeAJPc1ayWdA5IOMnQLESZhWNtgwrH6qXUm4yUI3qtHOW2hqbaHi8S5cUu6+YPB5Id7Xt+7Be4jjGUMswIGHRcZy9Y6bEtfUFxD0iOi1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/GrynKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/GrynKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255ECC2BBFC;
	Mon, 27 May 2024 19:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837405;
	bh=l0IWcXFWUk0cL7KOwzgKAFGtWprjf/QBXTm/uOoK+Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/GrynKsEJPB0tAhaM1nsZ1y4jma7fn7rd4ibTz+FhazAYP2rlzPQtAEDdwTSnt4m
	 cYuL6yijVf0bP//obfa8mXtF61ZJnO9df+te4xSqnKrODDGSpUXPNKWGMeN+GQsmSo
	 6u8JQvP/88mDDM/Q9M49PbtlnyDMYjb6G7jdladA=
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
Subject: [PATCH 6.9 405/427] selftests/kcmp: remove unused open mode
Date: Mon, 27 May 2024 20:57:32 +0200
Message-ID: <20240527185635.247912747@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



