Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B621504F;
	Thu, 12 Dec 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016422; cv=none; b=osyrTW2wzQkfliH5UIFb2gn3Rim8zZgLeafis/VoN4qaLPesK5EhMrC7pcfn5KYu6Tu9FpM8LdvEEqslyy3489JmhnhHfBCnxDrO+RyBQ2J0P3cfhD3HfAlHvIlmGFKz71wdhg9FCUVCUm70z0x2Y9Cf3UfET3gsiDeZHVIlbLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016422; c=relaxed/simple;
	bh=8wT6a6gsD35aZYLT3y/ZDhszMqASZz6w7D0SjaRugoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwhYkMygJn3vdpEPwhRzniSwDLd8A8CFTY6qSi9LyYVsJiMSwAQF7wTweBiSmg8sDaMk1VjXBzzpnap8OAHqrHHP3+xYGk23iF8hjJeKBz3gMG8keUL3g9bwUPDqaUukBZC5KSsthX0Iog4wn7GQOqSxjadrH9elLtHYEIdyCek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuvtMCQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuvtMCQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8782BC4CED0;
	Thu, 12 Dec 2024 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016422;
	bh=8wT6a6gsD35aZYLT3y/ZDhszMqASZz6w7D0SjaRugoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuvtMCQCdgFQ7KGakJ0wOvOYuCfs1NsPrupq35WLxT5CZIOhmQn+yRf3qaWcAKzoL
	 73Q5GCVZ7oxa0WgKugHI/VNxiS68UWle9JUYdeDZNJGx4i0ucezA+6B950cbF2vfHv
	 h+U5jGrzUdbdol798GeulxONz3DCmgqw3BYpF2bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 164/466] selftests/damon: add _damon_sysfs.py to TEST_FILES
Date: Thu, 12 Dec 2024 15:55:33 +0100
Message-ID: <20241212144313.283452490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Heyne <mheyne@amazon.de>

commit 4a475c0a7eeb3368eca40fe7cb02d157eeddc77a upstream.

When running selftests I encountered the following error message with
some damon tests:

 # Traceback (most recent call last):
 #   File "[...]/damon/./damos_quota.py", line 7, in <module>
 #     import _damon_sysfs
 # ModuleNotFoundError: No module named '_damon_sysfs'

Fix this by adding the _damon_sysfs.py file to TEST_FILES so that it
will be available when running the respective damon selftests.

Link: https://lkml.kernel.org/r/20241127-picks-visitor-7416685b-mheyne@amazon.de
Fixes: 306abb63a8ca ("selftests/damon: implement a python module for test-purpose DAMON sysfs controls")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/damon/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 5b2a6a5dd1af..812f656260fb 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -6,7 +6,7 @@ TEST_GEN_FILES += debugfs_target_ids_read_before_terminate_race
 TEST_GEN_FILES += debugfs_target_ids_pid_leak
 TEST_GEN_FILES += access_memory access_memory_even
 
-TEST_FILES = _chk_dependency.sh _debugfs_common.sh
+TEST_FILES = _chk_dependency.sh _debugfs_common.sh _damon_sysfs.py
 
 # functionality tests
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
-- 
2.47.1



