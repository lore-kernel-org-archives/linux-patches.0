Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E260351C3B;
	Thu, 28 May 2026 20:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000753; cv=none; b=Ltl38U0vCtmAIqkyOu9w9db+8DVQfFgbDb+SqkkMJHTDgUbNKzbvOptEFTsIZxjgHcDHNSwIi7JYGl91v0qgCtN4iU3SYiyYw8BX6TgWzPaNfTpH4qW0HpdP6v3JOyfpht7bDv9zmi4nRlAtM4GCcpV53taIHEjbaJ1J2DPtEnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000753; c=relaxed/simple;
	bh=oD4R+toEOzNwxZEX4AnpDHdXbikf0i04b4e3K0DiBqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io92agdsLDTdqpIK4OCyaLP751ofFI/ViK9z7WypW8CZ3yNgffGvvsKLzLCAXmcAYRrrZIH7wdveqA+JBLI4Z9KNeaV1QCkcjcq/XxFaj3rH+Rxy5MS5Agyq5DR8BqM43kXjWs340fTUcoRkXb7+6J7eG/JLK3L9TPU0k8ftFgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txdxG/aM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txdxG/aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3AD1F00ACF;
	Thu, 28 May 2026 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000752;
	bh=787yRouuB6WShMnXO4+rYln1w3OxSxwpf0kQAofhXx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txdxG/aM4Di3BsNfZ9LwtcaGAOpnxKJePpR1B4n3sJmXwzEaZyQF0q7lDdYdJHSIr
	 Xd57Ck6Vm/r48gxZ5YYdUwGVUI9vFFVxFbXuWYuMB6AmMGPlaVECO2UTyMcTLIzg1y
	 667H9s+DcECGHAYGsrBsYwkC0U80wxmClw5yf+6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/272] kunit: config: Enable KUNIT_DEBUGFS by default
Date: Thu, 28 May 2026 21:48:49 +0200
Message-ID: <20260528194633.699575768@linuxfoundation.org>
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
index 34d7242d526dc..8a30ad48f3c07 100644
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



