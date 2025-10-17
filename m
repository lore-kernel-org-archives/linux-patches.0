Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882EF32E136;
	Fri, 17 Oct 2025 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713240; cv=none; b=U4FGcoQ9DhSfXUKpFfVT+2cc30FTdNhU1KTanfWHM9UrfYFuzYxRn7SbXo32Vd59L/Sym5PyjldI/OsXpK2B8nUQk8b3Hu0RvD7CPksh7vNzqvfJIRMJPNWZq6uk96A74zm4nixk+FhhBnQ0PBnzeNV2XnnKAU2V1h/pg7uH2pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713240; c=relaxed/simple;
	bh=n9f0GABA94tWDsyz9LIlTQvqNg90hPwyhgABs1LP4bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWCs+ehplH84MvOIvijMc/+iADFkTp/vs7+tyPIjp2PIf5P9LzqklfdJWuTsLOZnBM5wXUeFQ2rAcIZFhaqIcdVefRSkSTt8xsVHXoE/erl1BOmMmdkcOG+N05cCEOIj1MMjRWzZUnhQOcT8Vmq/4drC6wkLyN1YPgsdNTYMupQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hs6IjD6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hs6IjD6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D14FC4CEFE;
	Fri, 17 Oct 2025 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713240;
	bh=n9f0GABA94tWDsyz9LIlTQvqNg90hPwyhgABs1LP4bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hs6IjD6Zu9IB86wnYc1OZAlVjYtPIfCFCsaH6JR5Ycx7717jDcMH37QxtWGGdV5B/
	 jCYuRrfuvo8KxtBmoPgSxmXUpGeDbEp2ToJCZGxlWrz09WehXSAiZ4EABMVpQk/QyS
	 dFM7rGGDz6t84YfWXyrmCVGytirgrO7R03mTWUh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam James <sam@gentoo.org>,
	Helge Deller <deller@gmx.de>,
	Stian Halseth <stian@itx.no>
Subject: [PATCH 6.1 089/168] parisc: dont reference obsolete termio struct for TC* constants
Date: Fri, 17 Oct 2025 16:52:48 +0200
Message-ID: <20251017145132.306294973@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

From: Sam James <sam@gentoo.org>

commit 8ec5a066f88f89bd52094ba18792b34c49dcd55a upstream.

Similar in nature to ab107276607af90b13a5994997e19b7b9731e251. glibc-2.42
drops the legacy termio struct, but the ioctls.h header still defines some
TC* constants in terms of termio (via sizeof). Hardcode the values instead.

This fixes building Python for example, which falls over like:
  ./Modules/termios.c:1119:16: error: invalid application of 'sizeof' to incomplete type 'struct termio'

Link: https://bugs.gentoo.org/961769
Link: https://bugs.gentoo.org/962600
Co-authored-by: Stian Halseth <stian@itx.no>
Cc: stable@vger.kernel.org
Signed-off-by: Sam James <sam@gentoo.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/uapi/asm/ioctls.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/parisc/include/uapi/asm/ioctls.h
+++ b/arch/parisc/include/uapi/asm/ioctls.h
@@ -10,10 +10,10 @@
 #define TCSETS		_IOW('T', 17, struct termios) /* TCSETATTR */
 #define TCSETSW		_IOW('T', 18, struct termios) /* TCSETATTRD */
 #define TCSETSF		_IOW('T', 19, struct termios) /* TCSETATTRF */
-#define TCGETA		_IOR('T', 1, struct termio)
-#define TCSETA		_IOW('T', 2, struct termio)
-#define TCSETAW		_IOW('T', 3, struct termio)
-#define TCSETAF		_IOW('T', 4, struct termio)
+#define TCGETA          0x40125401
+#define TCSETA          0x80125402
+#define TCSETAW         0x80125403
+#define TCSETAF         0x80125404
 #define TCSBRK		_IO('T', 5)
 #define TCXONC		_IO('T', 6)
 #define TCFLSH		_IO('T', 7)


