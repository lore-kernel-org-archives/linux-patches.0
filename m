Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE37330B01;
	Fri, 17 Oct 2025 15:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715607; cv=none; b=lVXjjY8LSpQeODwgVfc9vD2fjGXkVpYqe7rFTdo0mS4lvCGJEa1FJ2bektOiQZQDw1tTNEh4qli8wDDvIf7zKTYsQ9U3L7WDSz+ywhDDqNx3zRr7L/N/vqccV8HZ5yTtW4wSZzmYN3p1D30tiSfNc8l+bpFj6F6066BXOzew9hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715607; c=relaxed/simple;
	bh=RVFl/Wdg0DPDvYx4wTIiWH+FksbBaW8fsq3sfM9Yofk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAGVICAvZUWBg1BCF+tc01BOpHnbVYA9U9Hf6BMRp/wOoP5xqrkz/qs1ls3B3LlxLIg2dK7FvP1kdaf8RDprfnufYLpLi511hZ7sSJJemzFqnKfyL4LLzb2rHZYZ+hRh085sYdk9n6ajUM5bCQOiTerl/JgTNCYzKYipBNsAURE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/1iSD9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/1iSD9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D91C4CEE7;
	Fri, 17 Oct 2025 15:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715605;
	bh=RVFl/Wdg0DPDvYx4wTIiWH+FksbBaW8fsq3sfM9Yofk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/1iSD9FsYyjqC/eBGHwPsouZ1T0IVRI6oHD7teQ3oKf4bN69IcsuxtXFDRRNJ1pa
	 7frtA0TJknYH/7x847+d0lVt4Wt9KDgFwaaOzu5LEMcMhpeySrx+ZQyQtgSFwD4fqj
	 N4WTGY4hUnzJ9IuSLpRyIS6Tz641LoGRtyfbCEDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam James <sam@gentoo.org>,
	Helge Deller <deller@gmx.de>,
	Stian Halseth <stian@itx.no>
Subject: [PATCH 6.17 241/371] parisc: dont reference obsolete termio struct for TC* constants
Date: Fri, 17 Oct 2025 16:53:36 +0200
Message-ID: <20251017145210.798178549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


