Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EAD341AB8;
	Sat, 30 May 2026 17:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162501; cv=none; b=f2/OcXjm2tV0CT3j9qCYC4tMwIoBBg+bgR6tyOdHxeE1KdgPh8tZGwnmri4lWsh0GfYsSgWB+9X1KLfk+G4jbPOAzB+JRPjSipSgMZeoYtdLBvPGs3XWjRivBwcCYBlkf4CAgjtsuZvkTaqEUT1ON5j5MGHxYQWrNHhOc7xGpz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162501; c=relaxed/simple;
	bh=25zegvqdhZijrxAOR4itcOCU8Fg2Elahh3tMorvpuoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/fAOJQpZY+VUzaviwXqUdxqFu6leIRgiTjMRx1cdxgcl9uuxtoeZDIE5LGae/lKCcJMCjMhmu4EZE2xaQ5nqIbVy4cSUpGRO2eYMF4ZAJ3zw5w5CjX1Lyy1bP9tnOblG87KhMMMV96qyr0gmNKs0f0x1MpaMB08F1j8i9GBnKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH4jhNgi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH4jhNgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8FF1F00893;
	Sat, 30 May 2026 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162500;
	bh=v0PHmh0A/ZyBnLCTn6mmiGHt2UFybNTCbOQYp3vxIsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JH4jhNgiuqwXFFzCBUeKiRqv9TkpS97zUy9hlWFvmEyk9DmVufJjH5hNL+3YET4lI
	 jswl/7q7mCDguLAfRT463JrZRANR62mHX/ikAutrz2LypEd9MMlhV4wE4eSvWOqVXe
	 d9vukFf7Akw0Y1369nR+aqI4aew3hf66udvlYDEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 903/969] kunit: config: KUNIT_DEBUGFS should depend on DEBUG_FS
Date: Sat, 30 May 2026 18:07:07 +0200
Message-ID: <20260530160325.647948521@linuxfoundation.org>
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
index 785c2cfc530c2..49defb2f21b69 100644
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



