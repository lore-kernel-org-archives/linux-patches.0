Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CDE156F57;
	Tue,  9 Jul 2024 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524098; cv=none; b=oJN3zhS6YzYZDnRKIhc0ckgxJitAHuouyq2dXAsIgfnu3KMe68YkOog8NW41oNnBOMGPv06b4XSgFhqBlbIoHHDgEhIz1SlMbwldaXya86ffQaC84S09iXkj0XlAqqHXmuU2fz52KCsjQCEICWFRh2Cpcef5doxt3OKXNcJH5jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524098; c=relaxed/simple;
	bh=CafOrv89tEJRmi1vFz+E3+SVECaqJ2Nt5wKk3+ZOWlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FksgpSwdmEnKmLHvCT0rojeeFyUQOPZoLGmhXk3RqXUN083evrEOS2ky6T9YOcKw5IE0AMeQogSaDbuWOs3D67px6Fc6JmHPIJPrXsioEbEWrPXoS33GPg7MuKxwv6NHjyknUHrbdNPgsJ9R7DQTtLd51nKcPgDEF8nBUfBGTXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToXWz+JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToXWz+JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E480C3277B;
	Tue,  9 Jul 2024 11:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524098;
	bh=CafOrv89tEJRmi1vFz+E3+SVECaqJ2Nt5wKk3+ZOWlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToXWz+JGGS16pH9sNYgjOXrRS/M1vm/9SOpmrkTHfGiA4aZPl1svQZvN7tn6yJKDP
	 CpE639V+Zb0UmF0y6wFRbhzy98CKbofjW09tRP5PZM0eQlmV54MWmO8s0yl48j8d3c
	 GhOVaq+/74veiRRIuJBmXEWQ50w0RtZzPWBAFzfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Higgins <brendanhiggins@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 062/197] kunit: Fix timeout message
Date: Tue,  9 Jul 2024 13:08:36 +0200
Message-ID: <20240709110711.361972162@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 53026ff63bb07c04a0e962a74723eb10ff6f9dc7 ]

The exit code is always checked, so let's properly handle the -ETIMEDOUT
error code.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240408074625.65017-4-mic@digikod.net
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 3a35c13007de ("kunit: Handle test faults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/try-catch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index d9d1df28cc52e..9c9e4dcf06d96 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -78,7 +78,6 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	time_remaining = wait_for_completion_timeout(&try_completion,
 						     kunit_test_timeout());
 	if (time_remaining == 0) {
-		kunit_err(test, "try timed out\n");
 		try_catch->try_result = -ETIMEDOUT;
 		kthread_stop(task_struct);
 	}
@@ -93,6 +92,8 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 		try_catch->try_result = 0;
 	else if (exit_code == -EINTR)
 		kunit_err(test, "wake_up_process() was never called\n");
+	else if (exit_code == -ETIMEDOUT)
+		kunit_err(test, "try timed out\n");
 	else if (exit_code)
 		kunit_err(test, "Unknown error: %d\n", exit_code);
 
-- 
2.43.0



