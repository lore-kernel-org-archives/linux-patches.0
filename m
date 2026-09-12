Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748847C0F7;
	Sat, 12 Sep 2026 12:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216615; cv=none; b=tFgVQTzHuOLeBzpGLs47eKjnU9NLxihq/hb6gDU3a6QqMgoZeorDYvgFBFYUw5oZaP/SQYkq1X51ZuvOqBj937VX9tLkHOm80HlhgTf3rXekvkLnf7TGXlwNIfhjVQoNda4LQgeyJoDhKX8EFcgp21hyxWEsX6GsQzdEQTP5N70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216615; c=relaxed/simple;
	bh=z/R0Q2haPwsdfqVJchowiU5RNS2ogwJcYCKnkXETGT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cO5/g6l9hVLk4RSoFmdlJxjlRGP7PyslNPFAySaxBNymGsbLJS350FRDT6iu45lERxTW5cRB2CpB2/DNaSA6NaGsTybsVkBjJqm2+sCvlAzBWr4y6Db050AXKnDMqFOlFXu5WcHcZDDNSxUd/DMuKW1rMcNDleiPjmDeYYfKvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5AkHteO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5AkHteO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A201F000FF;
	Sat, 12 Sep 2026 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216613;
	bh=8hW6QtabBxbIXUPg4qua88V2cL5el0e+v7BZvgjykKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5AkHteOL/U9uYfRlXKM02w42JizycGvZqIHqYbbsIfL8EdnhyT83JRL/XAfBoL9W
	 Tq+Fa6aZ7oHVPjnIyKq8dYN82p4mP+AmJ+mLFYe0l5/do5HX5oyMrP8kPQ+iZvEaoi
	 gPz2pLJhTYt01NLLL6BJN3C4BCMzThf8sfoiwQbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0745/1376] tools/nolibc/powerpc: mark ctr and xer as clobbered by system call
Date: Sat, 12 Sep 2026 08:52:51 +0200
Message-ID: <20260912065624.148253177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9fc5a1742b0c8fb7edf066cc17fa0b18b7be623 ]

The system call can clobber the ctr and xer registers.

Make sure the compiler takes this into account.

The missing clobbers only seem to be an issue with newer compilers.

Fixes: 0cb0675ec37e ("tools/nolibc: add support for powerpc")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260727-nolibc-powerpc-clobber-v1-1-e0911cc99ce1@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-powerpc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/arch-powerpc.h b/tools/include/nolibc/arch-powerpc.h
index ee2fdb8d601dc..f468b6750543a 100644
--- a/tools/include/nolibc/arch-powerpc.h
+++ b/tools/include/nolibc/arch-powerpc.h
@@ -23,7 +23,7 @@
  */
 
 #define _NOLIBC_SYSCALL_CLOBBERLIST \
-	"memory", "cr0", "r12", "r11", "r10", "r9"
+	"memory", "cr0", "ctr", "xer", "r12", "r11", "r10", "r9"
 
 #define my_syscall0(num)                                                     \
 ({                                                                           \
-- 
2.53.0



