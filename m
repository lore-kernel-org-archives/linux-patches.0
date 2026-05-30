Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BF734389F;
	Sat, 30 May 2026 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162465; cv=none; b=kdWl+Aa+qgAa8P8G/wAPaso4CgQDrmpJLqJrHibiwy6+oxGpMyzgp0+uGm6X2HTe3RJIUKwjmJd1Zg++WzxxLisUTrvQl1VqUj4bF8vsgRyMO/vwiYDcqIKavysAdzOfzH8eBhzdNbXXXxYCuY9t78KLzF2yTZq0Q+py3r7DZjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162465; c=relaxed/simple;
	bh=NbobEh/1C+40blAxGaJhGzMFgM0qLhOTRMsRJYvxbhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qORnMQw4j3Ei8hxPWB8bha0t+yZuXddtZvxVQQNbzSLenY+X+IIbAOu/jcBgvJmYagJr7ADnevBR1LDcdf41txUV7I9WDMOTsDymrcXc8yqqsbBc6YhB0x/7neAFI+Ezo8qiasfehXxMQvdnhInOgoyrq6BzlJPuJmYJLFqslbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLR8INBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLR8INBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6661F00893;
	Sat, 30 May 2026 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162464;
	bh=vdSpR3dQ4TjgGlASpYxs56toyu7rTVW0Zby0tx1UiKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLR8INBrQcRYBHyFWLGTdCf6pZHvWBjepN550eYTBoBbp0LH8b0RIZRMyNlPZVNxv
	 r6BffMvn+63Q/FlS2fmLWb/lkjP6Eoo4RR6dJn2LSrvgQrcNBNg/HtoRybha59BbZE
	 WxcK9RzjoZ7gFIQNWoDkarrVq+fLBjk2f4pVD7yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 902/969] kunit: config: Enable KUNIT_DEBUGFS by default
Date: Sat, 30 May 2026 18:07:06 +0200
Message-ID: <20260530160325.620317633@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 626719b95badd..785c2cfc530c2 100644
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



