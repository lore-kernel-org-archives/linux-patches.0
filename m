Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C305019D091;
	Thu, 25 Jul 2024 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919266; cv=none; b=LkU7y1tf9xDf2gdPyUilN1l6qFfnspjVOz6t8jeDoxRPBdxd602osKVYGgdivc53CPJpeX+oRnsJVDgjml7oN0HGjhkq217gf+d8xFf1XMPrZwodCf4QwAl4o7NcKMiIjtE8FYe3alCgRys1czf7ll9mKanCzeRIn0k1OVi6GqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919266; c=relaxed/simple;
	bh=d13Fayu+YC/5MkZQsDl05Nl6PonPaj2q/BGUgA4YHrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urWUHiMlW24DWx9YhFY243mr/GU7rIaiWEiz8b18xtI0s+FFkacTNvc5o+iPzRelr70RyP+Vm+G+2eLcxbAlDlKBjZZD5y5pG0MTrperYWqP4HxdTZn0HOMuswmMdW0eKTKOoA1SPLQ6V2HBlnBKaHs0Eht0s/kXCPF0WNFbdRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKWNzZE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKWNzZE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D42C116B1;
	Thu, 25 Jul 2024 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919266;
	bh=d13Fayu+YC/5MkZQsDl05Nl6PonPaj2q/BGUgA4YHrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKWNzZE6BS3mO5gMm7YR0OXO9nZ3mYwTfr3I7YEuaLw+ofiyP+Kzt2j9S4jJrv8M1
	 eVHBWr3Dl0Zs05udU111KV8hnV39+5cJLoLcVxMUmhOBVET5wUPv4m94psUyPNnN7L
	 VGUFX1jHhtfF70WVOrZJ7ZPmFH2x6L+IkuekmibQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 75/87] samples: Make fs-monitor depend on libc and headers
Date: Thu, 25 Jul 2024 16:37:48 +0200
Message-ID: <20240725142741.267332048@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 8fc70b3a142f97f7859bf052151df896933d2586 ]

Prevent build errors when headers or libc are not available, such as on
kernel build bots, like the below:

samples/fanotify/fs-monitor.c:7:10: fatal error: errno.h: No such file
or directory
  7 | #include <errno.h>
    |          ^~~~~~~~~

Link: https://lore.kernel.org/r/87fsslasgz.fsf@collabora.com
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -122,7 +122,7 @@ config SAMPLE_CONNECTOR
 
 config SAMPLE_FANOTIFY_ERROR
 	bool "Build fanotify error monitoring sample"
-	depends on FANOTIFY
+	depends on FANOTIFY && CC_CAN_LINK && HEADERS_INSTALL
 	help
 	  When enabled, this builds an example code that uses the
 	  FAN_FS_ERROR fanotify mechanism to monitor filesystem


