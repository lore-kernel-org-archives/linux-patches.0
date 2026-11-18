Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041749;
	b=LI8nWvje62sHkM92+qYE3eW9F+X2Csa1edCCDsOVyWqZ9w4qRIbB8x6APMv/V2Wzlj2Q
	 vAuqNWoyEnZwmVVdihPCA7RVTlybEvOMcK3ZxG67z9JAiz7haOzIHo/cevLup9U1GNt1P
	 xjkJ7nD1Zfd0dQ/Zo5P82QMeCZYqn+b76jKD6llxAWQtEgsum8e4cBrxnFyyN9H07jEwH
	 hWgsSGk8JEShbGuujOHGcxinExgpLwq3AhvxeIYGgs7YaMNWc+I2OZTRMQygw6WxT2SyU
	 /BZ5M6CxfL50vZRuJNey4HOunVczlPENe7jcuPTau9hqIKOs1lH7q9X9x/07uoRaC9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fBUJzsdW032kaBYpyj8+NnxMleEODbnywk/JeuU9Y2c=;
	b=o87Xq3VjvmYxkQGZkUH6maIYdmQiUAu5Y75Ii1wH7aO9ZjoF4E/E3alwRjx7KhWj8cga
	 SAOK9I0zpjs8NbLX+ULSDgZ0+DVkKQrVAtap4oIstepoViYuv8aSsjzsv3/TIkrE+EiAJ
	 LDNv8bwEAdlgiR5fpzcFsPU+QbaKk8DBcwtHkFrxANPUCk+YkbE4rlwn8cP4JI9YSpKNC
	 6Y0Kml85WUaxxv4TY+OFra8tRF4H2I33tufxCMdz41bMyreuZHxID4+Qg0A3BPmnszcUM
	 MTqP3PDRDajoOEj3H8ZfXVgqjARRrXNqsEj5x8fHWkEMrO5z+TZwc9tFrQeMu37st9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHn5H6oI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD598606A320;
	Wed, 18 Nov 2026 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHn5H6oI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F601F000C4;
	Wed, 18 Nov 2026 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041749;
	bh=fBUJzsdW032kaBYpyj8+NnxMleEODbnywk/JeuU9Y2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHn5H6oIXFetn3aO4Pl/pBqtSwGAfGyUEK7mDMLMw8meiWV+CQbS8ystQoDWPREp7
	 gRLf0QvcB/xjFjnsiud5utPMNci9lI+AL1L6EOeTkAYq89ihTS2sxiJjk/E+aeZ5xO
	 aOr0ApXHl00VtDOADuExNikRBGPZGjTEZ2HlCNgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Jung <jaewon8868@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2924/3318] selftests/ftrace: Avoid unlink error on first run
Date: Wed, 18 Nov 2026 15:59:06 +0100
Message-ID: <20261118150448.125334455@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaewon Jung <jaewon8868@gmail.com>

[ Upstream commit 0abfa9ad5c6917cb9a509276f32009d944b3c269 ]

On the first run, ftracetest tries to unlink a symlink that does not
exist.
Use rm -f to avoid the "No such file or directory" error.

Link: https://lore.kernel.org/r/20261014114839.6258-1-jaewon8868@gmail.com
Fixes: 7dc1e125f07a ("ftrace/selftests: Add softlink to latest log directory")
Signed-off-by: Jaewon Jung <jaewon8868@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 22d0f5ec9bd28..370a2893dc545 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -223,7 +223,7 @@ else
   mkdir -p $LOG_DIR || errexit "Failed to make a log directory: $LOG_DIR"
   date > $LOG_FILE
   if [ "x-$LINK_PTR" != "x-" ]; then
-    unlink $LINK_PTR
+    rm -f $LINK_PTR
     ln -fs $LOG_DATE $LINK_PTR
   fi
 fi
-- 
2.53.0



