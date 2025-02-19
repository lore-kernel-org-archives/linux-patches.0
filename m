Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404781E0E05;
	Wed, 19 Feb 2025 09:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956312; cv=none; b=MeyQLI1MxiIyJVFs0QPwYbNRGC/02MMTkhwa+vZtHLzhHm8jmiC1kdHTtUTfP0nzVU/CRTkRI5uNilAF9wPyQMqUdghUOzZkcAaXmM3ClBdlkuS3wYNRroCmHJg535mPRCZ6UnXHNpLADktVWKyR3h/pGh/thl4Gd48aZ3QyJV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956312; c=relaxed/simple;
	bh=4jgZHYwBP8YMoMrOTSm8MYOiZu60cvaRrbzXw8wprVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHxtXNvqahwW27RIdKI75mCrZeuwnTmkjH63WQ2g674AUBUyot1zk71saSpo6KLe0XpZTl9UT0md6A23J0KlLFdEEx4TZmtZ6cpy0wyuJbnuByPQAI1i/6tUNduqLmy833jlAZNHAc5bjo5jZ9BYe4P2SL7k9yzx8EOWv+4by5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMV46RCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMV46RCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80BCC4CEE7;
	Wed, 19 Feb 2025 09:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956312;
	bh=4jgZHYwBP8YMoMrOTSm8MYOiZu60cvaRrbzXw8wprVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMV46RCasNZAwwhpvNlQhAJ+b6cMWFlKHZ+1MgBzPvVkVCqtbNerVFX9nMxfnudnH
	 B7VFdaRIwe1z0vJu2QMaMZkZBI6XtXZUZcf/LU2q/Hl+X6/+TOX0uXK+9wDm/NdO2s
	 DHjz1BnX0KXdzmwKTSMGV9Xws/dRpuI1knR5jCyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ba Jing <bajing@cmss.chinamobile.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/578] ktest.pl: Remove unused declarations in run_bisect_test function
Date: Wed, 19 Feb 2025 09:21:54 +0100
Message-ID: <20250219082657.311132480@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ba Jing <bajing@cmss.chinamobile.com>

[ Upstream commit 776735b954f49f85fd19e1198efa421fae2ad77c ]

Since $output and $ret are not used in the subsequent code, the declarations
should be removed.

Fixes: a75fececff3c ("ktest: Added sample.conf, new %default option format")
Link: https://lore.kernel.org/20240902130735.6034-1-bajing@cmss.chinamobile.com
Signed-off-by: Ba Jing <bajing@cmss.chinamobile.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 99e17a0a13649..f7f371a91ed97 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2939,8 +2939,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
-- 
2.39.5



