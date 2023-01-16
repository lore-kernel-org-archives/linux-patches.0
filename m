Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9683D6FA3
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01220C433F0;
	Mon, 16 Jan 2023 17:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888488;
	bh=qE60Hh0ZvwKLEtlroUbqlPtK7XB5SXDwxaQHmw2cJwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AESXAurHZes3FEtgwu/7n8QPOkrbEMdR0g+cXFdmBUcG9ezeUVjDdejSisBq7eK7e
	 3dOvSyCp90NAcGAdTRMw9GY8o1X3bjSu2qnHbIY58cePo/euc3KMOEutW8n6sF5XML
	 svpgasxfyKtjQJdDrHLhNYC19h/+VYjaWZuakEYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Jiahao <chenjiahao16@huawei.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 025/338] drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static
Date: Mon, 16 Jan 2023 16:48:18 +0100
Message-Id: <20230116154821.859427721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Jiahao <chenjiahao16@huawei.com>

[ Upstream commit adf85adc2a7199b41e7a4da083bd17274a3d6969 ]

There is a sparse warning shown below:

drivers/soc/ti/knav_qmss_queue.c:70:12: warning: symbol
'knav_acc_firmwares' was not declared. Should it be static?

Since 'knav_acc_firmwares' is only called within knav_qmss_queue.c,
mark it as static to fix the warning.

Fixes: 96ee19becc3b ("soc: ti: add firmware file name as part of the driver")
Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20221019153212.72350-1-chenjiahao16@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 25baf13d6dfd..c2307872ed9e 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -63,7 +63,7 @@ static DEFINE_MUTEX(knav_dev_lock);
  * Newest followed by older ones. Search is done from start of the array
  * until a firmware file is found.
  */
-const char *knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
+static const char * const knav_acc_firmwares[] = {"ks2_qmss_pdsp_acc48.bin"};
 
 /**
  * knav_queue_notify: qmss queue notfier call
-- 
2.35.1



