Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCB0168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0F5C4339C;
	Mon,  8 May 2023 09:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539503;
	bh=3mEJP8tmz/XW5HcFioTquKyOJJLG48D3oWkCAML/yZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o23jO2DOnmmi0BStX9SuAXJJcZyDC38h8BNJ6/i5SRQXqr2ltLRWQrX4muEIq3c0j
	 o5u59DKcCK4LNA+wBTh5ak/NvrXhjnffTCoQl0bc4v16cDtUMRi/sSWK/HeRnlgdDj
	 dYE4PdnHQLhva5NRp/BjVMTjtcKiHQiRUYL4HFo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anh Tuan Phan <tuananhlfc@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/611] selftests mount: Fix mount_setattr_test builds failed
Date: Mon,  8 May 2023 11:37:32 +0200
Message-Id: <20230508094421.961572023@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anh Tuan Phan <tuananhlfc@gmail.com>

[ Upstream commit f1594bc676579133a3cd906d7d27733289edfb86 ]

When compiling selftests with target mount_setattr I encountered some errors with the below messages:
mount_setattr_test.c: In function ‘mount_setattr_thread’:
mount_setattr_test.c:343:16: error: variable ‘attr’ has initializer but incomplete type
  343 |         struct mount_attr attr = {
      |                ^~~~~~~~~~

These errors might be because of linux/mount.h is not included. This patch resolves that issue.

Signed-off-by: Anh Tuan Phan <tuananhlfc@gmail.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mount_setattr/mount_setattr_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mount_setattr/mount_setattr_test.c b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
index 8c5fea68ae677..969647228817b 100644
--- a/tools/testing/selftests/mount_setattr/mount_setattr_test.c
+++ b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
@@ -18,6 +18,7 @@
 #include <grp.h>
 #include <stdbool.h>
 #include <stdarg.h>
+#include <linux/mount.h>
 
 #include "../kselftest_harness.h"
 
-- 
2.39.2



