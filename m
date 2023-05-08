Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78081168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9013C433D2;
	Mon,  8 May 2023 10:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542954;
	bh=SYSH3aCgoCAv0uUDnMzc9nKHtw5VLDWrCEOQIbmsShw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmmtg1f1Lma6PxxuMnA+4K2H8qi81YSuCzxokZjE6mcUzMXMCmqvNIytT2mMuaTfM
	 2LWG2yBopmq+vy+sJnxJsXsY3q/QUYxMM7N5D4dN3GwXsyup5HxvJfcuaHdL1uqs/e
	 FLn8utGLIXMEUrCiQ67YeaQYpswCNm76/pbbDlCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 603/663] hte: tegra: fix struct of_device_id build error
Date: Mon,  8 May 2023 11:47:09 +0200
Message-Id: <20230508094449.132030063@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6680c835ada1b34e882d0a32612f7294c62e27e0 ]

Without the extra #include, this driver produces a build failure
in some configurations.

drivers/hte/hte-tegra194-test.c:96:34: error: array type has incomplete element type 'struct of_device_id'
   96 | static const struct of_device_id tegra_hte_test_of_match[] = {

Fixes: 9a75a7cd03c9 ("hte: Add Tegra HTE test driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index 5d776a185bd62..ce8c44e792213 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>
-- 
2.39.2



