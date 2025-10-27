Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA6E33345A;
	Mon, 27 Oct 2025 18:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591309; cv=none; b=p9sWLYs5t5EUzf8BsKmBXSnUXsWPiBe7z+OJL1Fw9T0VtZkC9vrjc5fyeraeIKdQsVrhtdoKM2/pz68t3X44mmlVheFadWSeQnj14GwM+uk7oRxlRw/tSA+u9k3dh1ef37fUgRql4qhRz3c0HpuujRnORzXxXXQEf0jRpgudO24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591309; c=relaxed/simple;
	bh=HA52Ai5HDdzdajF5/h4JolkAaazksfQ5y7H2cPPGTwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l36MmsIpuZUFZNgA5JbeZf2soqOmLdpVUXEsfa9qF5RpjHl+xe0oGrwekr9EPAYYViMrBD3Xf1X7/MY8VSmed2RRHMhjeC4mFO9McpHMwzd4sbezzoKRWd38VspJQDLEbdjR/9/v4O5bT13/g23CnkM9MwJT7IApiCD92Ng2KvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LF1kJrJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LF1kJrJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C256C116C6;
	Mon, 27 Oct 2025 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591309;
	bh=HA52Ai5HDdzdajF5/h4JolkAaazksfQ5y7H2cPPGTwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LF1kJrJ8cewsmh9BeWCkXzeGUL8QGZYi9g1xMIB6KVEH72vU6NTk9ddGOBON8r/fv
	 7tZJ/eR8eSuqHY7agCSfZtb+P+UhXVH73zSA1AhCEA7Wn+9D+jwjN7559FCwj33OSj
	 xDsAVcVuTgW8w6gubMt3+JMQCrppvFL5XTb6SQ9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam James <sam@gentoo.org>,
	Helge Deller <deller@gmx.de>,
	Stian Halseth <stian@itx.no>
Subject: [PATCH 5.10 146/332] parisc: dont reference obsolete termio struct for TC* constants
Date: Mon, 27 Oct 2025 19:33:19 +0100
Message-ID: <20251027183528.490749934@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


