Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDA2EC4;
	Thu, 13 Jun 2024 12:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282120; cv=none; b=J7udKNZNAPQyrihfr1mYZA/rcqMGIZ+qyRlU7arxsJOtVMJCfMwAHTQDbLQDQhdvhITy5QIgAlgatTWNGKyGQ09JbKQdC8LPs3NaF1HFhwtr/XXq5J0zU3JqNlcqJKSsmtU5RlaIJ4Sp9KxFWnT8UNO9BIZTnMQ5Dk8ipAOj/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282120; c=relaxed/simple;
	bh=J/irDsD8SlqO4vxOMxtkuYUzp5dzACAkuj0fthluGsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipw4qLM2+ovW/w8/i2uttBVhQIbsjTVJfhKUF1JPTyo5RAvIrdijc0Anpn/ah5NXWDckAzoAS6pNmL1k0YkH4BsPR8FOBVdfvaSk4ChbSfEaSOj5SR8fPXjPyqihxH38SEkS/He5MLTfU8WNokjs5RHGVBEYXe5idCbckdKUd20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHOeQ5Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHOeQ5Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA93C2BBFC;
	Thu, 13 Jun 2024 12:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282120;
	bh=J/irDsD8SlqO4vxOMxtkuYUzp5dzACAkuj0fthluGsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHOeQ5CyMCyccNbW0HmXBLGfLQWVe1WJarYangk1QPUmJ4X6/Hvua6iDe0n622fym
	 Lczr9SJJqR1FwQ77xhUCfmVFge5Tm/daPERBA3P7cwDyBu19hVFux27sfVChjtIL8U
	 g/nGQaa/Y1d2rLe9qS+QnSffEUBixuzifqg2fFPk=
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
Subject: [PATCH 5.15 169/402] selftests/kcmp: remove unused open mode
Date: Thu, 13 Jun 2024 13:32:06 +0200
Message-ID: <20240613113308.738904864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



