Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5A8311597;
	Sat, 12 Sep 2026 10:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208615; cv=none; b=fICu+HryKRDNYHmvMMhyKPSG+kvsub+jYLLKD4R37RcYBk9R8AmgGDYz0lFEQhLpeHGM/uIE+RzA5PXeTmVo9ETZaQkZfAR8hQpZ8CGO24NRi4GyVooljAvvDA2wpQiokr3aBmdwal89h/4bjnJzYvJdp+1vUuKW47XBoZopBqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208615; c=relaxed/simple;
	bh=iuQbWhiWwNTxzg3bgK999vf4NZ9iETsBAGzfA++tLZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xkwu5Q8JkbwPuZS+H8f8eKnnA5jshTu389D4F0LM/eabkyEtX4O/R9TnlXA9h/o+02xenZgSrJdomn4N71jH6XBkYjclQ7UFawFdqGl10blQ2dQVvyP/DrxHm0qIciRniEZMnu66vb7SANb0auL4RRePaiyp6tu3hgCDEOUAfHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjRO9Dm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjRO9Dm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E811F000FF;
	Sat, 12 Sep 2026 10:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208614;
	bh=QEp9pbODU+Qu/dXf5+P1OAt/9t6eq1tlju1eIdZVZdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjRO9Dm3coEXsoLiEvgaJDwR1X47tfwO33dCu2Dy8mrrZcRhnTAx3qFkd5nUeMGFl
	 xAml0fysRQJ90EHwA8PnyjfTzK93vALrEqNTI20hRHVckMpAJ9XmgHHDQqcBTdGzZN
	 iUM9m2pmbFoXYXBuE+5cc7x2mRhMKdh+HvE+k/j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0654/1518] tools/nolibc/powerpc: mark ctr and xer as clobbered by system call
Date: Sat, 12 Sep 2026 08:47:03 +0200
Message-ID: <20260912065638.223482712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 204564bbcd328..c7d7a72c16dc6 100644
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



