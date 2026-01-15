Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E89396B7D;
	Thu, 15 Jan 2026 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496018; cv=none; b=XPVlLaplYUc0l5epoVWdfQNbrb1GhtIXW3rdvNG0QHqDFH+ap2FD4PHB/0iClTVUt8qF6gAmBJyvtfKg+NmGQNKVHbZA0pTb0ZK4Ote7ErgMT9eJIcCB9v4nigbfzNK/I427RzGeJLwhr5A+1PqwcX9vvu/b2f2tPsW6KiBC+4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496018; c=relaxed/simple;
	bh=120rb4xYp8RvbDZ8qBYa1qyad4aB5lkSAZgt/CUxB2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjRejV4RdEdJy7JwVglgp/ZvrWTiyjFOliRGLtgAvgEgMiK4E0Gt0bfEC0VwRrYP7hkxNmkjQxlUsVRgOh90n6uifHbeYNCxBTta4m8B8YnpXPqZVu8+Cy0BZZO5v5gAdvWhHVyJMukAJTbSDF98/9OASHfeWSpZlJK/gU++rMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RM/UD5W9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RM/UD5W9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2FDC16AAE;
	Thu, 15 Jan 2026 16:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496017;
	bh=120rb4xYp8RvbDZ8qBYa1qyad4aB5lkSAZgt/CUxB2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RM/UD5W96UZZGmFWba+HiUmkCdoKJkWX2HwmjulbybF4hc8COWIlZ2GGUPAX6SIJc
	 hnqRmwg7k5bK9uxPafArCaBlod3N0s0EDBS+d2OMyylP2+/c5LcZCa8Sba+KIW1MmX
	 KwSsf5VHbowwZHoZ9EnSlghi4G827lulgsn3NRc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam James <sam@gentoo.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/181] alpha: dont reference obsolete termio struct for TC* constants
Date: Thu, 15 Jan 2026 17:46:26 +0100
Message-ID: <20260115164204.100210454@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam James <sam@gentoo.org>

[ Upstream commit 9aeed9041929812a10a6d693af050846942a1d16 ]

Similar in nature to ab107276607af90b13a5994997e19b7b9731e251. glibc-2.42
drops the legacy termio struct, but the ioctls.h header still defines some
TC* constants in terms of termio (via sizeof). Hardcode the values instead.

This fixes building Python for example, which falls over like:
  ./Modules/termios.c:1119:16: error: invalid application of 'sizeof' to incomplete type 'struct termio'

Link: https://bugs.gentoo.org/961769
Link: https://bugs.gentoo.org/962600
Signed-off-by: Sam James <sam@gentoo.org>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/6ebd3451908785cad53b50ca6bc46cfe9d6bc03c.1764922497.git.sam@gentoo.org
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/uapi/asm/ioctls.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/ioctls.h b/arch/alpha/include/uapi/asm/ioctls.h
index 971311605288f..a09d04b49cc65 100644
--- a/arch/alpha/include/uapi/asm/ioctls.h
+++ b/arch/alpha/include/uapi/asm/ioctls.h
@@ -23,10 +23,10 @@
 #define TCSETSW		_IOW('t', 21, struct termios)
 #define TCSETSF		_IOW('t', 22, struct termios)
 
-#define TCGETA		_IOR('t', 23, struct termio)
-#define TCSETA		_IOW('t', 24, struct termio)
-#define TCSETAW		_IOW('t', 25, struct termio)
-#define TCSETAF		_IOW('t', 28, struct termio)
+#define TCGETA          0x40127417
+#define TCSETA          0x80127418
+#define TCSETAW         0x80127419
+#define TCSETAF         0x8012741c
 
 #define TCSBRK		_IO('t', 29)
 #define TCXONC		_IO('t', 30)
-- 
2.51.0



