Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B72F1F76DB;
	Tue,  3 Dec 2024 16:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242295; cv=none; b=erlv6oFSF2LcG92NFr5gu5SgrMzxWXo4VciDI03fkSFMazMixjBr6GbzcJ9qw1iAEGlt2OY0d+kr6F8jeyTyubLhnserwqDFjEK43S3R55j2xs/JEt760Q8m/0+lgteskaU2EYLgQwDlefOoDqF8uDk3uz+J7/da1+9IPBF/tlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242295; c=relaxed/simple;
	bh=8HIpfGglYf5BIpKSvlKOE/TmNQt3go3baF8s/ImDfAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/HUCBxK2cdYxCJv656w98qmrUVF1fI+P1c6yHlEVCbIWPjIsJ5j8JWkjyltuPOlDXc46ag6TFE4vnI37957acGsIZZShj6fIgxV+RoLYsWUuLYR738svuboeiIBOfTwLX21wHLmmZDD54buj90pwR+KOuiD/QsdC1V2XSL2z+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjL7T9qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjL7T9qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1C6C4CECF;
	Tue,  3 Dec 2024 16:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242295;
	bh=8HIpfGglYf5BIpKSvlKOE/TmNQt3go3baF8s/ImDfAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjL7T9qZt4UchN9MWjT07HzoUwtgbCOARiIKwQ7zjlOCrc+Mur/m+YqboTjpJmwg/
	 UK4P53AciYjjMpwRqENpqoKctWGr0/WUCgmObMIUNlvKVHg2weFc2H7xAep0vy1iRm
	 mSIcsSuo8Gz/5wX7BBdi4m/4XHqNIrVvuCZTvy2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.12 665/826] tools/nolibc: s390: include std.h
Date: Tue,  3 Dec 2024 15:46:32 +0100
Message-ID: <20241203144809.695407511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 711b5875814b2a0e9a5aaf7a85ba7c80f5a389b1 upstream.

arch-s390.h uses types from std.h, but does not include it.
Depending on the inclusion order the compilation can fail.
Include std.h explicitly to avoid these errors.

Fixes: 404fa87c0eaf ("tools/nolibc: s390: provide custom implementation for sys_fork")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20240927-nolibc-s390-std-h-v1-1-30442339a6b9@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/arch-s390.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/include/nolibc/arch-s390.h
+++ b/tools/include/nolibc/arch-s390.h
@@ -10,6 +10,7 @@
 
 #include "compiler.h"
 #include "crt.h"
+#include "std.h"
 
 /* Syscalls for s390:
  *   - registers are 64-bit


