Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022355;
	b=wbWxe0RrhLvpha3q/NG5ymaPFal01oqNWnKl3puvKTEmqowQMRMX+iNRFBVgQ7IIIXDW
	 npfJHhbn6cstyVY8/D1iTPPo3n/a6mEMwDeSeTRvmR28Qz8HgkmK6DuqpShLJZyqmPk0+
	 cC34QlWuk592c/jC6kLdKRRjIs1P0Jk+IclE1mvMKu61GivovuSbFY0G4zHlMGzI5YF6J
	 u0qkB+64idOqcZwjEl8Iy2m5U6lJj3oaDwvbGwWkbHOibhh6Atuv2EOWTvAG2YhiswH7O
	 8MX/NgcMMenzs6qXeQI067B972i9B7m+FL/baoBzWjMDDHC2DRh1357H5YKArOkZ0IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3m44+6o7cATUzOrILO+ukYVAp6DHIBonnMc9W9DUnXw=;
	b=V34JnpRCVTQTEO/U5U/IZCboqjAUrdKHjq1H0vG1XGr48AlUtAgHm+tbcdGFTbyqKRh/
	 yCAXUQ75X/yiQhMrVjOJ1oNNPusHcSMg/I+mvemc41yvo8cuTZCLOj7siLFkF5xPQhOCb
	 AIoU0iYa2y5TUi3jGGOaVR8cKif3XfZXEYLh7LsjGojTGDc5sgu+hr4jPyKA/3Kh7mI2y
	 d4+whA3Jp4xGDytEymJUGoeJYUYS4UPoJsr7nGoNUw1S+KO3kYKkT6NV9U+wMGqKgc2Fv
	 tLKYClrB0GUZzqw0EgGrsGN2QYHwYf3DN5P/xir0CXItJJXS2ho0Q0VcVNFMB7sM5Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqoC4LnG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893C4606A31C;
	Wed, 18 Nov 2026 17:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqoC4LnG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6501F000C4;
	Wed, 18 Nov 2026 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022355;
	bh=3m44+6o7cATUzOrILO+ukYVAp6DHIBonnMc9W9DUnXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqoC4LnGNGnQzdpEEFd/9TmgTeeLJP/7by+lSopFeuYIeKC0aJwLYLOZ5zUmKsAoU
	 D0JLuZyyg+qf2hUJrkvzYYr3J9XREcBWTTL3LjNG/rgfJ5RpE7fROCHZTxAWNSx12w
	 7KtiNUZdW71TBcrjXGI20n8o45pDd84CIWskG3GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2633/2651] pidfs: do not report fields that do not fit into the callers struct
Date: Wed, 18 Nov 2026 16:04:33 +0100
Message-ID: <20261118150418.947534384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 1534c37167488f2b85c74de048e1d6a4ba3848de ]

The documentation of struct pidfd_info promises that "If the structure
size is too small to contain a field (requested or not), to avoid
confusion the mask will not contain a bit for that field", and asks
userspace to trust the returned mask when deciding which fields hold
valid data.

pidfd_info() does not keep that promise. It builds kinfo.mask without
looking at the size encoded in the ioctl command, and
copy_struct_to_user() then truncates the copy to that size. A caller
that passes a 64-byte struct (PIDFD_INFO_SIZE_VER0) and requests
PIDFD_INFO_COREDUMP or PIDFD_INFO_SUPPORTED_MASK gets a mask with
PIDFD_INFO_COREDUMP, PIDFD_INFO_COREDUMP_SIGNAL, PIDFD_INFO_COREDUMP_CODE
and PIDFD_INFO_SUPPORTED_MASK set, while the coredump_* and
supported_mask fields behind the 64 bytes were never written. Trusting
the mask as documented, userspace then reads whatever its own buffer
held at those offsets. The same happens for a 72- or 80-byte struct
and the fields added after it.

Clear the bits of the fields that lie beyond the caller's size before
the copy, in the one place that knows both the final mask and the size.
A request for a field that cannot be returned is thereby answered the
way the header describes: the field is simply absent from the mask.

Fixes: 1d8db6fd698d ("pidfs, coredump: add PIDFD_INFO_COREDUMP")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024041334.831273-2-nickolai@csail.mit.edu
Acked-by: Luca Boccassi <luca.boccassi@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 1bd130eb909ab..03422f49be65d 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -511,6 +511,14 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 		kinfo.supported_mask = PIDFD_INFO_SUPPORTED;
 	}
 
+	/* Only report fields that fit into the caller's struct. */
+	if (usize < PIDFD_INFO_SIZE_VER1)
+		kinfo.mask &= ~(PIDFD_INFO_COREDUMP | PIDFD_INFO_COREDUMP_SIGNAL);
+	if (usize < PIDFD_INFO_SIZE_VER2)
+		kinfo.mask &= ~PIDFD_INFO_COREDUMP_CODE;
+	if (usize < PIDFD_INFO_SIZE_VER3)
+		kinfo.mask &= ~PIDFD_INFO_SUPPORTED_MASK;
+
 	/* Are there bits in the return mask not present in PIDFD_INFO_SUPPORTED? */
 	WARN_ON_ONCE(~PIDFD_INFO_SUPPORTED & kinfo.mask);
 	/*
-- 
2.53.0



