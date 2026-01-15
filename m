Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420323A0E94;
	Thu, 15 Jan 2026 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496830; cv=none; b=BaEKq+II9BWxAdaa4yky55W8eDrv9yfzYzp3lQyAX4P/YAYxZ1Y/UQGCtWpYeiCY/cgpP+O23y1jolQUC0HNGuLM+nHWhsQr8/P2n3q0jpOQADl5mJm55cvXXojJVgsQe+IDGw9HQpKUbLhA4UWcM2kiSmJEX1JKDK4JivzpcNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496830; c=relaxed/simple;
	bh=maB+bXoG02GcPQ1dqhIHaM7qoU0LZ81THk6jUJOeZgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOinmecRRqmglV4qFS5klnJB7DYr8oKnMLVjryVx5YCOgkeCABhjwLs83KljC8Cw1+7CTKq2LcMbuIuFZH/rv3DRZZ07DxtoEmMaThBZcxigysdOf75e+NFtyYXtVXgv7i6WshbNWb1iQXxEfSKPHSNRCLSPyUoX1437KgEWOx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN2bCsMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN2bCsMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA68C116D0;
	Thu, 15 Jan 2026 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496830;
	bh=maB+bXoG02GcPQ1dqhIHaM7qoU0LZ81THk6jUJOeZgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN2bCsMKHqZQFzqZBLq2Lf/nzTfnftNIPwmBYecLH0V4gNupaOas52PG+WOMksQ6j
	 0CrXS4CNoFn79ocOn6xcgxXTpt2MoZkXs6Llhm7shgMQRhQxfqpdnKAGLYHOSbf0Fn
	 cnnaFZI+b74MC34no14a56wPGqnsInpAHEf3LmaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam James <sam@gentoo.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/88] alpha: dont reference obsolete termio struct for TC* constants
Date: Thu, 15 Jan 2026 17:48:13 +0100
Message-ID: <20260115164147.403174869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



