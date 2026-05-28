Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51CE2E7379;
	Thu, 28 May 2026 20:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999773; cv=none; b=c71MaYquLH0vhKZkTm1jrQ3Yg3BqIfaBRevZmTWjYkwx9L0hKSb/T+1ysvoDdqlMGCtgbcXOrZJ0KissCnRJrnH4ZEeUhyC4gn5rY9nIMB5u+X8gjuIUypYP8cW2Yg0TRxpqwlF4mbmYiN9zEYWlh4y9SJKNt8f/jZEGjUXOC9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999773; c=relaxed/simple;
	bh=l7sN4yQoYtM0PnJEj2w056bgkz77/1iuGtARZjDzePw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWzSRLqRMnpdXxEKAPfsi+mZ5AfZukU8A+02tUDqU/l9oLLoA5PHNeUCZub/P0eBc15W+cV7yd06LEbYzg5m/V08Ye7SKjIcF232/DrHQGrvof+89ftidGBE8JQ1VkX5gPqLxoH0ckgqUAlG0RoRoQTldVoQg4p9C08tqwA59IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfpqxG5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfpqxG5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD101F000E9;
	Thu, 28 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999772;
	bh=WBpHNPy0BA0D42u05GLJe1SxjBCa/BbSDofrIb0MwrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfpqxG5sPXZh8OkKHE13Kd1B7GFYA+FhUN8b5Zb+LB4tNZNJN7N+ekdLVNlsCK5gq
	 51AXJuD3G5KB521+b1qbNN85H4/ZE1fm+Be3TGD1zkdOsuLdnNYb72khm4H1tX4DVX
	 GORCADwdiiBwX9sx3B8VeU3GznCXCCUihWxa/yUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/377] kunit: config: Enable KUNIT_DEBUGFS by default
Date: Thu, 28 May 2026 21:47:03 +0200
Message-ID: <20260528194643.778837687@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

[ Upstream commit 17e4c68ff35090d8cb743e3c82c09f92fda1ebda ]

The KUNIT_DEBUGFS option is currently enabled based on the value of
KUNIT_ALL_TESTS, but it really doesn't have anything to do with the set of
enabled tests, so just enable it by default anyway. In particular, this
shouldn't be only visible if KUNIT_ALL_TESTS is set, which is quite
confusing.

Link: https://lore.kernel.org/r/20260425034155.53913-1-david@davidgow.net
Fixes: beaed42c427d ("kunit: default KUNIT_* fragments to KUNIT_ALL_TESTS")
Signed-off-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kunit/Kconfig b/lib/kunit/Kconfig
index 7a6af361d2fc6..2b9fd107a69fe 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -16,8 +16,8 @@ menuconfig KUNIT
 if KUNIT
 
 config KUNIT_DEBUGFS
-	bool "KUnit - Enable /sys/kernel/debug/kunit debugfs representation" if !KUNIT_ALL_TESTS
-	default KUNIT_ALL_TESTS
+	bool "KUnit - Enable /sys/kernel/debug/kunit debugfs representation"
+	default y
 	help
 	  Enable debugfs representation for kunit.  Currently this consists
 	  of /sys/kernel/debug/kunit/<test_suite>/results files for each
-- 
2.53.0



