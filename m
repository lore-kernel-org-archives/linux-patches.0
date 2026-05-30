Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1250E21E098;
	Sat, 30 May 2026 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165020; cv=none; b=Ibl46bficrr8kcKS2abmXD6BwyG/VD4+VhxcvVtWPXThXKNofdZp2xeL32dJQxWmlrlXUWCdvgORihkB2CLfRDqmoP0AMbcmOeLbAKvGHG25wq+VHn9Ee2bSzvxeevpBtx5HsPZDUAT2u5GbofJZvCZefgTl7SyJBTBGyR2qt68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165020; c=relaxed/simple;
	bh=xPFi5d6GFSAARmK2rAcc+MPTFdu6VDNMSPcVKmqT2Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBwu3XiNdL795UYiPVooipP2Sk1OK9vX4nnXtRJ/7G7dWS94jnbXMPFJsEEiNngUS1P7EasTXgAk7904/L7Tw2gK9R/OJV4IEahVMPXg+9sX6dlPgaWneZX5n2YnodpwLkzJTSQKYw+4bUPYqtWs6PTpplaNHKR7TdL/TBCHrwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sH4wlUfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sH4wlUfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E021F00893;
	Sat, 30 May 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165019;
	bh=Vnuxi5DxoQagZ8MWzz1YPPT1hwBilSPIrYyrS6SWIBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sH4wlUfRVFE2fbGH8vPKA+bhtsQGH4bFGeo7x6LBaWpkVtn4ETIb2EV1clH77hRFV
	 HMtDRi5b8xBoCG/UBqQpMUI9zoHkeRjrRudaCLK4Gz48EqVLvxJ/JYQwDkBcOxK7ij
	 sOvxoKPrZzvKxEdD8pJXozsa8hzmIXcQtfexmCR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 727/776] kunit: config: Enable KUNIT_DEBUGFS by default
Date: Sat, 30 May 2026 18:07:21 +0200
Message-ID: <20260530160258.611588057@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0b5dfb001bacc..a32943555b67d 100644
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



