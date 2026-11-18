Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040085;
	b=3McoXD7Cceu3R4r0ewY2vWvFfsUX6zbT2PeAnmzOppjWea8QoQV3jg+hjENhyVT5U6MW
	 MB4ojxzXppxLn/wGYY0oQUp3Q6WWeONLwfDNop6QTweEkWz8W5Qncx8l8mX6WOfinDRMG
	 6lKDjhA5vgULke0OjSfOgoX5VWbBfUq2uGWFu7fFDM8llzLN0PujcrKYbgF4LfWTdTYQk
	 lw7CnVACOLpQHqCH6LG0BDz9LJf9ISSWg0pRkkpPhfeX3I93RY18FkUQOt2SBgYsNGwdr
	 AiwqxVVG6UAWC5GtXD8ddweCGPMvcsunZnaXWZHk0d26ZCn8sk/D6XMX3pEtwHgY15g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pS08ndDgyS9IqfdOmJq81wqNOcj+fGfZ4oJ8jw2TBso=;
	b=36io5rWnKOkQkf8RZcWhA6+X4KuBg2L99drqW0AdwIHRbXccOfwVxaf+Fg6nVAyvS/wC
	 Sc9GgEYvItAY4+/v5p6aNrbVH8wtfXodPmYT9c7duRECgekZnPELrftLSuOQTlPiGXSJx
	 n4J8Bve6TMgp0sRDz58wDLOj8bibF+iAccwo7kD5KPeaePCQhXV5SVLKLq4Lz8yBZGXQU
	 aQEeHgBqoFicNXUWH6B0Mo/JmGnyMLqIVjT4PPmFfwg+u6FrI+CFLuUYmuHmXF6FjZwqL
	 TE9S0f+VYOy7y5QxZGeLks7gb21K7KxdVpO74Nwi5632RzC64dVV1XtMF4KzjKM2dWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3ozofSh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BF7606A31C;
	Wed, 18 Nov 2026 22:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3ozofSh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D41E1F000C5;
	Wed, 18 Nov 2026 22:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040084;
	bh=pS08ndDgyS9IqfdOmJq81wqNOcj+fGfZ4oJ8jw2TBso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3ozofShW0nWACvnadM7/Xj4pknuEcoHT1x34iFc/+bBApnITbtW+GRnPVHVXq8j8
	 TLPAjfrZBzN+7Hri88RojTxs70YCkHLCrAlINAfOXDLohurdvzOx1OzAxiJp3oNEzA
	 MsEiOhwHDvNK/y2IkV8qXmu3e2lw6KgU+4BWRxm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2332/3318] tools/nolibc: fix WIFSIGNALED() for status 0
Date: Wed, 18 Nov 2026 15:49:14 +0100
Message-ID: <20261118150431.609136038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 368fae47c6cae28a312c5dc86e5bdb8f9369fd26 ]

WIFSIGNALED() needs the subtraction to wrap around for status 0, so that
only 1 to 0xff, a terminating signal with or without the core dump flag,
pass the check. But status is an int, and 0 - 1 is -1, which is less
than 0xff. A child that exits with 0 is therefore reported as both
exited and killed, and a caller that tests WIFSIGNALED() first sees
"killed by signal 0".

Make the subtraction unsigned, as musl does in the same macro.

Fixes: 8c934d4822c7 ("tools/nolibc: add helpers for wait() signal exits")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260923205622.1123270-2-danishkhateeb03@gmail.com
[Thomas: Drop stable@ Cc]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 48dca7b188d06..ff422a6d3277e 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -106,7 +106,7 @@
 #define WEXITSTATUS(status) (((status) & 0xff00) >> 8)
 #define WIFEXITED(status)   (((status) & 0x7f) == 0)
 #define WTERMSIG(status)    ((status) & 0x7f)
-#define WIFSIGNALED(status) ((status) - 1 < 0xff)
+#define WIFSIGNALED(status) ((status) - 1U < 0xff)
 
 /* waitpid() flags */
 #define WNOHANG      1
-- 
2.53.0



