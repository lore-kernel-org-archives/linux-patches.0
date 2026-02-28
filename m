Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2223191D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300951; cv=none; b=K357OQ7eMMSrsPRFE0Cnd15mQN08Op4ciQ/3QgzIughb0rmP1yoB7pqYmXrHWd2z70oGWsnTNsnHFH9QX7N/EFUULlPGL/ibE5+PpEs4HYTvBaywaHL6wD3GOU7t0w8h1tWO15NZudXir69NoUbxHzQeMafkue1i/FdhOx804sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300951; c=relaxed/simple;
	bh=y120UP/A72i4KPCXXzfD+Gijbl0GECCbaubnP5MiEKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNoRRt1VSdGYq5KcLvB5f+AuzZtOxPsIQJIKFqKowyDIuUFkf5+7iHdnnSr0q/l4cqf3Z1c9i7I46YzW0pCDQsGwJOKFQhsfbohemA7EWzG4vIrGqnMxunzyZUV9C3YbbNGrqTmaShbgEbztRSWJOu8BigjNat16ksFkIm+2kNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdp/EnjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdp/EnjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D846C19424;
	Sat, 28 Feb 2026 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300950;
	bh=y120UP/A72i4KPCXXzfD+Gijbl0GECCbaubnP5MiEKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdp/EnjFGTKBLO/pHVieogPq0U9Iiirg1sMhIUqO8dpJhFwNCvjg+nZOzVseEFQoC
	 AJLSu2KEkAjYC/8SeTIUHSGvYhxc9Gw8oUL1U45EZrYlT2/OyQjnZu0zn6OSq0R4OE
	 UuvM1jGuomRwxpSIIswJYUi5+molU+YpkZjYZXdV8s6NhT0GolzS7qfWfq84jpcSPF
	 MlQ7c3Zf6Y0EjP4a7vOZ7x2hI4oEkBxS9iilOCp5s0+lDQbx8TC9q3PukS/BBxy6zi
	 GoeWuIQhNe75F2erzSLOQgNHsUnLjUsNtaLq3vweJ9vdR7o1xjGJxRxvp9SbJFGUWW
	 CRrlPEzFKzdJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sam James <sam@gentoo.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/752] sparc: don't reference obsolete termio struct for TC* constants
Date: Sat, 28 Feb 2026 12:36:25 -0500
Message-ID: <20260228174750.1542406-74-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sam James <sam@gentoo.org>

[ Upstream commit be0bccffcde3308150d2a90e55fc10e249098909 ]

Similar in nature to commit ab107276607a ("powerpc: Fix struct termio related ioctl macros").

glibc-2.42 drops the legacy termio struct, but the ioctls.h header still
defines some TC* constants in terms of termio (via sizeof). Hardcode the
values instead.

This fixes building Python for example, which falls over like:
  ./Modules/termios.c:1119:16: error: invalid application of 'sizeof' to incomplete type 'struct termio'

Link: https://bugs.gentoo.org/961769
Link: https://bugs.gentoo.org/962600
Signed-off-by: Sam James <sam@gentoo.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/uapi/asm/ioctls.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/ioctls.h b/arch/sparc/include/uapi/asm/ioctls.h
index 7fd2f5873c9e7..a8bbdf9877a41 100644
--- a/arch/sparc/include/uapi/asm/ioctls.h
+++ b/arch/sparc/include/uapi/asm/ioctls.h
@@ -5,10 +5,10 @@
 #include <asm/ioctl.h>
 
 /* Big T */
-#define TCGETA		_IOR('T', 1, struct termio)
-#define TCSETA		_IOW('T', 2, struct termio)
-#define TCSETAW		_IOW('T', 3, struct termio)
-#define TCSETAF		_IOW('T', 4, struct termio)
+#define TCGETA          0x40125401 /* _IOR('T', 1, struct termio) */
+#define TCSETA          0x80125402 /* _IOW('T', 2, struct termio) */
+#define TCSETAW         0x80125403 /* _IOW('T', 3, struct termio) */
+#define TCSETAF         0x80125404 /* _IOW('T', 4, struct termio) */
 #define TCSBRK		_IO('T', 5)
 #define TCXONC		_IO('T', 6)
 #define TCFLSH		_IO('T', 7)
-- 
2.51.0

