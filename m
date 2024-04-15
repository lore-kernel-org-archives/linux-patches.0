Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51191D524;
	Mon, 15 Apr 2024 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191441; cv=none; b=K+3YsTS0BMcTmXmQPuvDEJtXo27C/4FXx7/xybbLK/v3LviDVfDDlKqxwavhfT5uw9GvNuQC0faNWuLXTa1FHqirDwi9x0xQ5p4X5+zSsgz1zC2UYC/xhe2H2FzKNxX8Evn+4cGhMCDi1PAF0l0q6Cp5owqj4lecKDxHHh3c+4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191441; c=relaxed/simple;
	bh=KKCFRsDUnNtcOruXsV923Mul7fROEWhVbcCA80yUF+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6vrXhIhBt4gwqJ7WgfhgZFw2MmC55J5rEgkWwED/BarHCQk2WY9pi91QMTCC/vw375psUm1U+Lu9UtmpX6Z0KdVKKU9hb9Y+LpdJ6iVqG7UhTzIN4IEmMccT+U7LLxwqWqOSnSfiQcEX3ImvQTFs5qRNZ08MvnEBFaGpJMow7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTKA5iIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTKA5iIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55F4C113CC;
	Mon, 15 Apr 2024 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191441;
	bh=KKCFRsDUnNtcOruXsV923Mul7fROEWhVbcCA80yUF+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTKA5iIliMsKHPB+hN7AmauVwG3WnynvZI2MLB606uYNgLx5uu0rUx8cJpWCqRzzm
	 /KWczaaSPQSvai+d1HDDeOpQ4bjSmaCd4oEhg4QQ+uuy/XXbfgZQUNJGBlJHv1epXi
	 XAO5SbXCk70UM/BCGQT9I0IP5J54InDfX51KqRkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Justin Stitt <justinstitt@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.8 144/172] selftests: timers: Fix posix_timers ksft_print_msg() warning
Date: Mon, 15 Apr 2024 16:20:43 +0200
Message-ID: <20240415142004.747513906@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <jstultz@google.com>

commit e4a6bceac98eba3c00e874892736b34ea5fdaca3 upstream.

After commit 6d029c25b71f ("selftests/timers/posix_timers: Reimplement
check_timer_distribution()") the following warning occurs when building
with an older gcc:

posix_timers.c:250:2: warning: format not a string literal and no format arguments [-Wformat-security]
  250 |  ksft_print_msg(errmsg);
      |  ^~~~~~~~~~~~~~

Fix this up by changing it to ksft_print_msg("%s", errmsg)

Fixes: 6d029c25b71f ("selftests/timers/posix_timers: Reimplement check_timer_distribution()")
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Justin Stitt <justinstitt@google.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410232637.4135564-1-jstultz@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/timers/posix_timers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
index d86a0e00711e..348f47176e0a 100644
--- a/tools/testing/selftests/timers/posix_timers.c
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -247,7 +247,7 @@ static int check_timer_distribution(void)
 		ksft_test_result_skip("check signal distribution (old kernel)\n");
 	return 0;
 err:
-	ksft_print_msg(errmsg);
+	ksft_print_msg("%s", errmsg);
 	return -1;
 }
 
-- 
2.44.0



