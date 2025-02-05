Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4BCDF59;
	Wed,  5 Feb 2025 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767901; cv=none; b=BBp9f6q2lxXYaUL532InZpEl4Z9wqMXj+bvnuVWqT2BIJioIj4xC2lCGX/7o0s0Z1gXcQsQM/3Kxc7QnOt8H6rpyd5h8oRUMgNk3WVF7xiUID3nO/Uk+HPWhEky3i9xyF3MJ7hZnkJ2+6v++qesTm5oeQcopYlFz3UIXaWCMcUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767901; c=relaxed/simple;
	bh=3kw+nRjdC/e+V+2dcFlKLNmIxnSddSYZQpCq1lr33ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R3ntQ24HtnC+j2pQV+iJuLHshky9dshnrAoR0t3u3KKoYw9xfQUIpBvDu5xvrYpEoi9KM1ft3EmCEKBuaot+4kDbAPyWgpHmRXd5aG+Wk1f2ZxiQb/EiDb7OrukSG8cgHS0x7zvU3E2A0MAOGnB5DGEvlQtFTnVmik6MBwQ8qmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vkzh3Ri3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vkzh3Ri3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0545C4CED1;
	Wed,  5 Feb 2025 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767901;
	bh=3kw+nRjdC/e+V+2dcFlKLNmIxnSddSYZQpCq1lr33ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vkzh3Ri3og5PehbabJ7lkDzl9lsiqCXZNUBXdQeHpB5QfwyQMkSvr0W9t8H+hhiH9
	 KQZFN0euXcXy4oDz4AekgYM+lMvKs5Kd52rnafqmnGPld+e9hWXHYTkceymKdEQe2O
	 SJnEIIq9MtZqFLXedrdK6xFIUsYpqKn/2H7cCM+c=
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
Subject: [PATCH 6.12 501/590] ptp: Properly handle compat ioctls
Date: Wed,  5 Feb 2025 14:44:16 +0100
Message-ID: <20250205134514.436169055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/ptp/ptp_chardev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index ea96a14d72d14..bf6468c56419c 100644
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
@@ -176,6 +177,9 @@ long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
 	struct timespec64 ts;
 	int enable, err = 0;
 
+	if (in_compat_syscall() && cmd != PTP_ENABLE_PPS && cmd != PTP_ENABLE_PPS2)
+		arg = (unsigned long)compat_ptr(arg);
+
 	tsevq = pccontext->private_clkdata;
 
 	switch (cmd) {
-- 
2.39.5



