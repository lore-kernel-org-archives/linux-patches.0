Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D4B5475F;
	Sat, 12 Sep 2026 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224160; cv=none; b=BtaQHO34YPZPuPFrPXspEDhN4iYXDKbkHRuj1M7clBudFEmqSHVfQper+Pji9ZFk7JrVuWnz4OyIeZCFDuICGjXyPFlAEAdgkdKN1gLwgq9O0kctvhRt0vtuEndPuR9wk3sxyM4VBmyq17Valfkgi+F1emutXJcHZjf+1gmPBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224160; c=relaxed/simple;
	bh=j+U5JUAPwjCWNCwk9Jo/g/uQT5K8GakHY7T+YlgvYgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FaDqINDQwXfQIiWpPAfzz0V+ZyDT1ogSdOs8P6J+TOx10FNrJi8GNdjub3RpyzeESZo+AFeKH3SDsFIk2vStyOAR1xBJgLHzUzjmXACs8oZNtTRCIcj3IauqBlMMkZyWor44fGXeWo5p/PgQ6mfKe5V++fkeTqbUKoM06yjQYSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jl12zpR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jl12zpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53D81F000FF;
	Sat, 12 Sep 2026 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224159;
	bh=u9xBQixv8vroQ6pzUTzP3a+hE9jwwPLaLx5If7lceb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jl12zpREFSBDmBB98K8m2LeTDcHvuwV8PDKE7Shk32bIlWBGfbyJDWIGEUCnCyfY
	 ml3M2cMFWIeeoTq2pH7hM5u18VhGXIjWWBt1J53xLOcEiVfdjKpA03arcZS+NUeRDV
	 F5fn4G/HcfBQ1QMUIVmx8GFee4T3E+fQiESMmMQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0935/1424] tools/nolibc/powerpc: mark ctr and xer as clobbered by system call
Date: Sat, 12 Sep 2026 08:56:07 +0200
Message-ID: <20260912065628.261573219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 41ebd394b90c7..377ea7f4b1c76 100644
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



