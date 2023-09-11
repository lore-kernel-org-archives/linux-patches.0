Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C503111706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15789C433C8;
	Mon, 11 Sep 2023 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444470;
	bh=KBMnE5gJ/iYzShpyuMHPlSsWdEoOimTwsBy0LS90T6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcEggvVTiys53RzUB1jzxecFv0wDihPTJs111JCAbZlYlP56QLw8YS2/2A8m8wAeB
	 jFDBApWJKoWWGt5WS/HI2m5ZzGahg5an7B7VvJlI0tNBLK7fjfFWLLLM4yk06F7nMe
	 vIsHDvpMdRV8T5O/N+MGL0nIYyp8aYW0hTXLukVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Tometzki <dtometzki@fedoraproject.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>,
	Daniel Verkamp <dverkamp@chromium.org>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 734/737] revert "memfd: improve userspace warnings for missing exec-related flags".
Date: Mon, 11 Sep 2023 15:49:53 +0200
Message-ID: <20230911134711.014652360@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 2562d67b1bdf91c7395b0225d60fdeb26b4bc5a0 upstream.

This warning is telling userspace developers to pass MFD_EXEC and
MFD_NOEXEC_SEAL to memfd_create().  Commit 434ed3350f57 ("memfd: improve
userspace warnings for missing exec-related flags") made the warning more
frequent and visible in the hope that this would accelerate the fixing of
errant userspace.

But the overall effect is to generate far too much dmesg noise.

Fixes: 434ed3350f57 ("memfd: improve userspace warnings for missing exec-related flags")
Reported-by: Damian Tometzki <dtometzki@fedoraproject.org>
Closes: https://lkml.kernel.org/r/ZPFzCSIgZ4QuHsSC@fedora.fritz.box
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -315,7 +315,7 @@ SYSCALL_DEFINE2(memfd_create,
 		return -EINVAL;
 
 	if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
-		pr_info_ratelimited(
+		pr_warn_once(
 			"%s[%d]: memfd_create() called without MFD_EXEC or MFD_NOEXEC_SEAL set\n",
 			current->comm, task_pid_nr(current));
 	}


