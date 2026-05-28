Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCA9357D12;
	Thu, 28 May 2026 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000756; cv=none; b=l/miNBSCFFTXNbNLA4UdsiGf00dXqu45fKSviEsueppD0JRFxc6IHWvlHDiA6Kw4sbLa2AM6T6PDR3Sh/6WU43FSRLx4XP0ff8ynZLdDOyNECk1sW/65VkeoTSzdh3+igndqiyrWObbfS3QuZU1GTMkMS9CYD8j+Abw1WdBlk8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000756; c=relaxed/simple;
	bh=yNUCc+ULsggQYCfB3rcll58WkQW0G5QndWj/p4CpG6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ki+Kb75MSEuzYYn8Ui358LFo4jz0uRXjYX5pjSNpVmtyFzj056mYcoK+SmsIN/Cs2qNuAQxlogE21LH3CxJqDsGXx9gjSqK81Ertw8rVrADOfYqJDEy1Q7ASzy3NjtUfWXqRkf38pjEtKQqasf/psMG85N458K28W26ESfdoi/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9i2t11N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9i2t11N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D181F000E9;
	Thu, 28 May 2026 20:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000755;
	bh=bHPJu0foAs/T6XJ8/Pmz0TFp0uH2b8kj8Lma/uqLmbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9i2t11NlydpqX7HB5RvdCp4kBeVVSIGvXTqLs3L+WQefn2m+DspTr14X9y6SGcAd
	 k7gMuYJ7Q4BhRiTJhYx6xXt5PBxVe574qFk8ZKhV+nLMEHsi1J8M9JuoncyZDpnLT+
	 JuV+RjwAu4KsjS8G1yzsTbCNij0YJ7kzIL6Sv6bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/272] kunit: config: KUNIT_DEBUGFS should depend on DEBUG_FS
Date: Thu, 28 May 2026 21:48:50 +0200
Message-ID: <20260528194633.723637628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

[ Upstream commit 8f80b5b227ef9ea422080487715c841856339aed ]

CONFIG_KUNIT_DEBUGFS is totally useless without debugfs, so it should
depend on CONFIG_DEBUG_FS.

Link: https://lore.kernel.org/r/20260425034155.53913-2-david@davidgow.net
Fixes: e2219db280e3 ("kunit: add debugfs /sys/kernel/debug/kunit/<suite>/results display")
Signed-off-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/kunit/Kconfig b/lib/kunit/Kconfig
index 8a30ad48f3c07..e22cbee60ab25 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -17,6 +17,7 @@ if KUNIT
 
 config KUNIT_DEBUGFS
 	bool "KUnit - Enable /sys/kernel/debug/kunit debugfs representation"
+	depends on DEBUG_FS
 	default y
 	help
 	  Enable debugfs representation for kunit.  Currently this consists
-- 
2.53.0



