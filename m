Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC2F1F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C79C433C8;
	Tue,  1 Aug 2023 09:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882843;
	bh=uIsY3qB5y7J/YErIoaxKxt45A82bLthalDtnSBT7pI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrUYRYAOGi4TFoBif7a/NcUdHExVQStCkPn1ik59V8SqlmJ8LsTfvry44QEl8cU+q
	 XASzSSDcEPjTDt+Br4qDEa+IVZr8YxFkXfrfG5i5KE1hXVDAw4Izu/7104lNIvcmkQ
	 7JgFwIJ6/4pQhkmL46VoYhmqXcb4kMVZcnWBCxMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 022/239] i2c: Improve size determinations
Date: Tue,  1 Aug 2023 11:18:06 +0200
Message-ID: <20230801091926.437652047@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 06e989578232da33a7fe96b04191b862af8b2cec ]

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding
size determination a bit safer according to the Linux coding style
convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 05f933d5f731 ("i2c: nomadik: Remove a useless call in the remove function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-nomadik.c | 2 +-
 drivers/i2c/busses/i2c-sh7760.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 05eaae5aeb180..5004b9dd98563 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -970,7 +970,7 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	struct i2c_vendor_data *vendor = id->data;
 	u32 max_fifo_threshold = (vendor->fifodepth / 2) - 1;
 
-	dev = devm_kzalloc(&adev->dev, sizeof(struct nmk_i2c_dev), GFP_KERNEL);
+	dev = devm_kzalloc(&adev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto err_no_mem;
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index a0ccc5d009874..051b904cb35f6 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -443,7 +443,7 @@ static int sh7760_i2c_probe(struct platform_device *pdev)
 		goto out0;
 	}
 
-	id = kzalloc(sizeof(struct cami2c), GFP_KERNEL);
+	id = kzalloc(sizeof(*id), GFP_KERNEL);
 	if (!id) {
 		ret = -ENOMEM;
 		goto out0;
-- 
2.39.2



