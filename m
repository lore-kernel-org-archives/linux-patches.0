Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1846A143889;
	Tue, 23 Apr 2024 21:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908587; cv=none; b=KyiKUwRlVLhRtwpHedFIVKvodGyke4sAJKU2yHcoA7qcbmyD5QL2pgiVI/EcQyHMq6hcq+uFoeOd4UCAd/mam6iYpydC5cFf2sP+cD4rGjmthXBATpd8p5w6OyCL0LngHLzYDhKTMhqRxmiD6dJFOcxfFbf6ksexSmkV4KoWepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908587; c=relaxed/simple;
	bh=DXEW5zkkK3tk1nkeAQHxa4WKGBIIGjRAr6VvIxYb9hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMXuE4CSIo47Y+eaaDImplwFRL2qik1bAPs2e/hMGlJ1KQb2X7BoZ3EbrIDAnntW5agWj0KZiMnGCs3dVtN/IGGZzELCAvKHC+0oLqfl4KHoAaWRK55WlhELNoL2hfmjh1wUunJNv460sRN+/asnBM859uonIFZkYMZ6JwdxtJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/6bsfFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/6bsfFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E045FC116B1;
	Tue, 23 Apr 2024 21:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908587;
	bh=DXEW5zkkK3tk1nkeAQHxa4WKGBIIGjRAr6VvIxYb9hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/6bsfFZoBPYK+Rt/eZkxoNX69yOm9JaXNTXotIO74pRuneTy6LnVaXzXwWtwKKjK
	 EZCBLJedjXcnJ69ekDw9papzbSsMr/J89sjI9R0z+6dhe9YWZXLXM3dh0kHEWV/58d
	 dDPLYKVbH4jP6QEM06XCkq76CnIMrG+6727THtxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Justin Stitt <justinstitt@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/158] selftests: timers: Fix posix_timers ksft_print_msg() warning
Date: Tue, 23 Apr 2024 14:37:37 -0700
Message-ID: <20240423213856.384807402@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <jstultz@google.com>

[ Upstream commit e4a6bceac98eba3c00e874892736b34ea5fdaca3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/posix_timers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
index 14355d8472110..c001dd79179d5 100644
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
2.43.0



