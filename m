Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F023615FCF0;
	Mon, 27 May 2024 19:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838631; cv=none; b=o/Mwj0UVb2QRUasTxIajNjUXOYyaH/YdaOx3j8aJOfJmVNLkK86RtghmBqGAKLsSvNeO8wOGK5rIn8x/rFq1mwS0fL4dtCn8Ay0VmbXQe7OAF1pqhP+csIQu1w5J1aAOfhJTQFHJHqhqRLZc7aIhwp/X+kXGNaSafHIV4PEZvIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838631; c=relaxed/simple;
	bh=J/QK+GKs+xtdNnjYoHAHgus+R2LlgX0uXkWGhNKSqDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3Xa2HFRWBE8EEdngGBa+UuEdFt5TcBuz/vL1eI2UT/v3Bw83VJiPfGThssTXUaIMX1klD0icL1zmMXOMYftj0E0NFe5AD2Cy0+Zf+RKaSRtvhf5hH8CwctAPcnxqn0bU5vJ+kUBdw+JMlqEYs2gNjAT3gVwOItHDZ04g+WBny0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lif47KEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lif47KEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81272C2BBFC;
	Mon, 27 May 2024 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838630;
	bh=J/QK+GKs+xtdNnjYoHAHgus+R2LlgX0uXkWGhNKSqDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lif47KEML2wY+JbBAJMAcE3mjtl+n5MOqqvFgnFcVVZuF9JPGCcKmHDfP5aiW8ov5
	 h/tlS9Zb0vwJF7DWSAVfXs8ejwQw9IbHuBAF12mo9vFubL6OQG+pxiVOqtw5HJ1NZm
	 jMyNIifAiCZTD/rUYit2YQROd5eQyCvslTwxcG4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 466/493] selftests/damon/_damon_sysfs: check errors from nr_schemes file reads
Date: Mon, 27 May 2024 20:57:48 +0200
Message-ID: <20240527185645.422726240@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 732b8815c079199d29b0426d9372bb098c63cdc7 ]

DAMON context staging method in _damon_sysfs.py is not checking the
returned error from nr_schemes file read.  Check it.

Link: https://lkml.kernel.org/r/20240503180318.72798-3-sj@kernel.org
Fixes: f5f0e5a2bef9 ("selftests/damon/_damon_sysfs: implement kdamonds start function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index e98cf4b6a4b76..f9fead3d0f018 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -241,6 +241,8 @@ class DamonCtx:
         nr_schemes_file = os.path.join(
                 self.sysfs_dir(), 'schemes', 'nr_schemes')
         content, err = read_file(nr_schemes_file)
+        if err is not None:
+            return err
         if int(content) != len(self.schemes):
             err = write_file(nr_schemes_file, '%d' % len(self.schemes))
             if err != None:
-- 
2.43.0



