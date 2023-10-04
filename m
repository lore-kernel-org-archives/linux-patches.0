Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97B81D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A66FC433C7;
	Wed,  4 Oct 2023 18:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442747;
	bh=Wxa5SbyvzM4aqoIrT+W4jk1eoX8DEEtGSlO6Q+ZkzI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oM3R8YGICpvURm0IOWGQlmPWkNLw1NFSVSLudN+VCWNb/I/vir4PapJSExTi4tPWt
	 VdaUw+Bhk0ZPOzGfrjUzZRcAO9ArgERkzix9mrPTP4HY6bHAamYPHiHgRGbwZULIvH
	 e2rN1pz7fBhNyRwqv366S6oBgdJRAHz+/qeHJcv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/183] Fix up backport of 136191703038 ("interconnect: Teach lockdep about icc_bw_lock order")
Date: Wed,  4 Oct 2023 19:54:58 +0200
Message-ID: <20231004175206.667866923@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

Add a missing include to fix the following build error:

drivers/interconnect/core.c: In function 'icc_init':
drivers/interconnect/core.c:1148:9: error: implicit declaration of function 'fs_reclaim_acquire' [-Werror=implicit-function-declaration]
 1148 |         fs_reclaim_acquire(GFP_KERNEL);
      |         ^~~~~~~~~~~~~~~~~~
drivers/interconnect/core.c:1150:9: error: implicit declaration of function 'fs_reclaim_release' [-Werror=implicit-function-declaration]
 1150 |         fs_reclaim_release(GFP_KERNEL);
      |         ^~~~~~~~~~~~~~~~~~

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index ab654b33f5d24..b7c41bd7409cd 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -13,6 +13,7 @@
 #include <linux/interconnect.h>
 #include <linux/interconnect-provider.h>
 #include <linux/list.h>
+#include <linux/sched/mm.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-- 
2.40.1



