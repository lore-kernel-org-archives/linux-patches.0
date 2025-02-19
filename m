Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAED11B4F0C;
	Wed, 19 Feb 2025 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956697; cv=none; b=peWkAb71hzMNDLQnGeNP1BKc61dnGdxEUsGSYNzWG2gtCB0SjlAQ+qHhxTYvPCOPnCOLrJMyk0ng9r0g4oIqKxjM4HjVBQzuDfla+QigDB73epuUAswd2cMBJxI49eoit2TLIVvwMLkt0Mk8fXHJ0iD3RJP2i7Qaid++M71rtvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956697; c=relaxed/simple;
	bh=KgkM7JpPFkG7W+gJhdvJfD2VJPvUltPSSJ/KhQKuPl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgLEbzm44RZ/XPVYbOA2Q0kflHUDJs647TOxL55nyhHZEzMejrgRhxwlmQ0FWt6K2Ib8H9qh7yujayEZGH2CQ29+iaaCNv9zjrushrpbaWLNLmQl4/ypFxd3251AXkPcXQdnqatqoiFBLafvT9MfUVmdZH8/Y71G6V2BPeJTvEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfM3Xp67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfM3Xp67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEABC4CED1;
	Wed, 19 Feb 2025 09:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956694;
	bh=KgkM7JpPFkG7W+gJhdvJfD2VJPvUltPSSJ/KhQKuPl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfM3Xp67lC5afN+vZnjGiiTqlXX4P/rHPZ2lus/laqlGqkcxj+f9u11KAR97tVv+J
	 FWsyDy6zClnPt71XSrbk75v4wC0BYvtWdSY5D4InevSJmDUT2OpINoHKOnoBmFT1a+
	 WuaZA9ivpNx+Ry2y43gpBFp4ufTbpbsWCjvFk+pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 267/578] ptp: Properly handle compat ioctls
Date: Wed, 19 Feb 2025 09:24:31 +0100
Message-ID: <20250219082703.526061035@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 19ae40f572a9ce1ade9954990af709a03fd37010 ]

Pointer arguments passed to ioctls need to pass through compat_ptr() to
work correctly on s390; as explained in Documentation/driver-api/ioctl.rst.
Detect compat mode at runtime and call compat_ptr() for those commands
which do take pointer arguments.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/lkml/1ba5d3a4-7931-455b-a3ce-85a968a7cb10@app.fastmail.com/
Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20250125-posix-clock-compat_ioctl-v2-1-11c865c500eb@weissschuh.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_chardev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2010 OMICRON electronics GmbH
  */
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/posix-clock.h>
 #include <linux/poll.h>
@@ -124,6 +125,9 @@ long ptp_ioctl(struct posix_clock *pc, u
 	struct timespec64 ts;
 	int enable, err = 0;
 
+	if (in_compat_syscall() && cmd != PTP_ENABLE_PPS && cmd != PTP_ENABLE_PPS2)
+		arg = (unsigned long)compat_ptr(arg);
+
 	switch (cmd) {
 
 	case PTP_CLOCK_GETCAPS:


