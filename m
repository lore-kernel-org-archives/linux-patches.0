Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597AA15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF192C433D6;
	Mon,  5 Dec 2022 19:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268669;
	bh=US7oShXQJBDEtU+at6sdVslNjiXJPtYp5fCk8brToDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OV9OH4Z1mRXoiWyJkJ386yGOYHNSP3IPK1ncD/36pv2OpRaPZEzweqhwYNqzyA2RK
	 Se1JZ1eeyQ9dYGfeAqTbvxPxknk1sus4mjZixKYHdzKn/fudjelTKG+t2ylIASQPx9
	 9qgbx0nawtuxCy3TCRjsLRrnPT7r5cI3NIXxOc2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 61/92] mmc: mmc_test: Fix removal of debugfs file
Date: Mon,  5 Dec 2022 20:10:14 +0100
Message-Id: <20221205190805.536818216@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

commit f4307b4df1c28842bb1950ff0e1b97e17031b17f upstream.

In __mmc_test_register_dbgfs_file(), we need to assign 'file', as it's
being used when removing the debugfs files when the mmc_test module is
removed.

Fixes: a04c50aaa916 ("mmc: core: no need to check return value of debugfs_create functions")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
[Ulf: Re-wrote the commit msg]
Link: https://lore.kernel.org/r/20221123095506.1965691-1-yebin@huaweicloud.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3195,7 +3195,8 @@ static int __mmc_test_register_dbgfs_fil
 	struct mmc_test_dbgfs_file *df;
 
 	if (card->debugfs_root)
-		debugfs_create_file(name, mode, card->debugfs_root, card, fops);
+		file = debugfs_create_file(name, mode, card->debugfs_root,
+					   card, fops);
 
 	df = kmalloc(sizeof(*df), GFP_KERNEL);
 	if (!df) {


