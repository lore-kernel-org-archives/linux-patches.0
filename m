Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6921CAA65;
	Wed, 19 Feb 2025 08:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955391; cv=none; b=bxXjpTHch/VH48JgJnu8r9r4wFn+41bY1A2xk7epV/YJ7Woc4Qi9yKxZmt1E4OzfF5CHS+RmxAf2GDQOgc7ec5wADQy+F6xfI1hbB0QdZducvpu9Wa3ougYqChkZSi3gTJl/SoczBwYN/V7fUOJ8VWQBcW6eaCEUtUMjXDwVNEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955391; c=relaxed/simple;
	bh=+wF3/Ds3iOSewy0F66KWJY2XG6pSO8Osr5LM6IbYnt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N3zEaEDt81Vf2nMdnAITFYqHmqEVeaSCxqwCREX+1iJJmFgyDWiwQ263INnqddMetfWIonTsypXyrSYRAmypoYIXkIRqgQtHEhhoBrHfZe/uOimSdqK6pXSF+sKshAXGvkYbsNLVcvpqC2gBESjsYBdjkS9NNBoGN0ePcy+quH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oO1ax86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oO1ax86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A70C4CED1;
	Wed, 19 Feb 2025 08:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955391;
	bh=+wF3/Ds3iOSewy0F66KWJY2XG6pSO8Osr5LM6IbYnt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oO1ax86CYDGRWfuMCS9Dsj2dM0CHjxlHIX/fGYJOn/QYDq5zORqr3Rt+D4CPffq5
	 PlNotGSMYMZ63ed5zX0yII1vr6RO+WrT8ILeogOxFB+NEGtc1DLdx3f9kl8FBkNm7Z
	 a+4vx/+64Rm0n+NJGB/R7eAFedsrUEBa7SAcVWqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.12 221/230] bpf: handle implicit declaration of function gettid in bpf_iter.c
Date: Wed, 19 Feb 2025 09:28:58 +0100
Message-ID: <20250219082610.335736714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

commit 42602e3a06f8e5b9a059344e305c9bee2dcc87c8 upstream.

As we can see from the title, when I compiled the selftests/bpf, I
saw the error:
implicit declaration of function ‘gettid’ ; did you mean ‘getgid’? [-Werror=implicit-function-declaration]
  skel->bss->tid = gettid();
                   ^~~~~~
                   getgid

Directly call the syscall solves this issue.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/r/20241029074627.80289-1-kerneljasonxing@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Cc: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -226,7 +226,7 @@ static void test_task_common_nocheck(str
 	ASSERT_OK(pthread_create(&thread_id, NULL, &do_nothing_wait, NULL),
 		  "pthread_create");
 
-	skel->bss->tid = gettid();
+	skel->bss->tid = syscall(SYS_gettid);
 
 	do_dummy_read_opts(skel->progs.dump_task, opts);
 
@@ -255,10 +255,10 @@ static void *run_test_task_tid(void *arg
 	union bpf_iter_link_info linfo;
 	int num_unknown_tid, num_known_tid;
 
-	ASSERT_NEQ(getpid(), gettid(), "check_new_thread_id");
+	ASSERT_NEQ(getpid(), syscall(SYS_gettid), "check_new_thread_id");
 
 	memset(&linfo, 0, sizeof(linfo));
-	linfo.task.tid = gettid();
+	linfo.task.tid = syscall(SYS_gettid);
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
 	test_task_common(&opts, 0, 1);


