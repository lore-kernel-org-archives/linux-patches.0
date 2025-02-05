Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E52151988;
	Wed,  5 Feb 2025 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766139; cv=none; b=aXgf0yEKDqAemttUFY3O7dzq1AHJ91QAkGeqq1iuKHztkiZA8AbGIh1fuN5sH7L7XnCeWRwzElL/0mkVqSUVl85rbboUDLnUXKfvWdGf/dxb9SCE8eRVJPnv/31iFwt/yvWKhxk//toVFbho64mMS/0kEYmbeAulW9wiDMho75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766139; c=relaxed/simple;
	bh=xQMaRFOPxrwC+2uKmAUMoQhxEIK/ZtxBfoxdItlBOBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ehWKIKUK5I0NU2aQ9GqrEy3U7C5MPwOpC00s6gwr04LQMJhAGlc7RGqvQnFLdfbz9c0zQWo8pxhD8FEvsSzeP/ZNnZ8jilw9v++9M7bjl08nma1Mf2PiHe57+2Nl08Py0H4y4ZRQUnt2W2O1/oBijjsARenM9m5QiWu0XPRGgOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkEMucEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkEMucEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7473C4CED1;
	Wed,  5 Feb 2025 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766139;
	bh=xQMaRFOPxrwC+2uKmAUMoQhxEIK/ZtxBfoxdItlBOBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkEMucEcrtxIeyaafT6FtjO7DSTk66xyli6xvsLPeqGiC/UKCE+cfQkW/3q4yW/2o
	 6Si+8kozoP69qfKMb2Qj2HKl/wXsLgRy0KabMzLALATnx2CjjPbpFMoWOtPy+nezWA
	 qUScEViagZFbbqgQUOMQzw7IU53F6Dx8+5eJdh90=
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
Subject: [PATCH 6.6 333/393] ptp: Properly handle compat ioctls
Date: Wed,  5 Feb 2025 14:44:12 +0100
Message-ID: <20250205134433.052833614@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


