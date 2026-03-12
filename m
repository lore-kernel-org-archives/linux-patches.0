Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA98145FE0;
	Thu, 12 Mar 2026 20:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346542; cv=none; b=HS8GiVAe2LyRIiq7tDskR8WtjbWv5Y8IaXXH1OmVzNTiNq8eupCgYvDcAd60l/+KeVS3qts9S58YfpkhfzCaLz5tmrWpANuhko5bh8XFFoENNannzOO1fKwiuSp+n1DY9/EKwsD1lnfA/ysZCsA0CftoGf6re+CmoeKWvL89cs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346542; c=relaxed/simple;
	bh=8o2IhA60ftNazpNV+sIXdDCXFntXrITHl0oYMkfzx0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5FzNN1jWdorPPuBMwdYM5CtplpFEeQ/uivOqZPcjGIAvt/OPsSmKXIpLKuY5u2wIKQzj3ZFxbukrU682KAi1Xgt56+yV+ZHq5Bi9Wu0gsVaFsuzBwxpVB3Z4b06IZ9ZubWAt5IV7Eg6Fdn/k+ABgN08CRkWdwNW6j8fpZHIFxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pquanAF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pquanAF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7BBC4CEF7;
	Thu, 12 Mar 2026 20:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346542;
	bh=8o2IhA60ftNazpNV+sIXdDCXFntXrITHl0oYMkfzx0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pquanAF51ejsBcWl6AV7FqXGH+AmC/qEdx2p+aTBzx1v7eRIYFBPqJJ806pCXkBxo
	 5G+Y2+LGs09/HfsX/zyd7vuWX/1E/vRrHu373TTmAdWAkDPcto5ZEEv7SaPlUHwfL8
	 brsyHjwhwJVDmLTqI/oP2EnM1m4AG3JQnHFzpNjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/265] mailbox: remove unused header files
Date: Thu, 12 Mar 2026 21:07:35 +0100
Message-ID: <20260312201020.670294259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 4de14ec76b5e67d824896f774b3a23d86a2ebc87 ]

There's nothing used from these header files, remove their inclusion.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index c7134ece6d5dd..693975a87e19e 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -6,17 +6,14 @@
  * Author: Jassi Brar <jassisinghbrar@gmail.com>
  */
 
-#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/interrupt.h>
 #include <linux/mailbox_client.h>
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
-#include <linux/slab.h>
 #include <linux/spinlock.h>
 
 #include "mailbox.h"
-- 
2.51.0



