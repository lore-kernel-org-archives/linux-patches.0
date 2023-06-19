Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779A3AD26
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D35C433C8;
	Mon, 19 Jun 2023 10:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172222;
	bh=fJq3Hi33yj9LJ+8xSEBf1WK4slcQWuCD+cpqgsFNdYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiGE99OV/d2Hh7uFU9lkekAwS5RoOVW3UTYt1fTmC/TejJ8jWWr3shO7ohjteB0K+
	 nVQd5ftFn8uhIjbkhFlbUWCOXlsaGIZTWs0WrKV451VLCyzNuTX5lRbIUs8c83Cgoi
	 ECsIIg1Y0nXxifZoODS83RGujIg6cLz9gTgcXy0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.10 80/89] batman-adv: Switch to kstrtox.h for kstrtou64
Date: Mon, 19 Jun 2023 12:31:08 +0200
Message-ID: <20230619102141.916424918@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Eckelmann <sven@narfation.org>

commit 55207227189a07513ba4107d72e256313a66a2f3 upstream.

The commit 4c52729377ea ("kernel.h: split out kstrtox() and simple_strtox()
to a separate header") moved the kstrtou64 function to a new header called
linux/kstrtox.h.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/gateway_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/gateway_common.c
+++ b/net/batman-adv/gateway_common.c
@@ -10,7 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
 #include <linux/errno.h>
-#include <linux/kernel.h>
+#include <linux/kstrtox.h>
 #include <linux/limits.h>
 #include <linux/math64.h>
 #include <linux/netdevice.h>


