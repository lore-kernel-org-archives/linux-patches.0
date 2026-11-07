Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062077;
	b=EvBF3gEqqNz2h5rHqoWJTMhdvMbRNBU6BfHJzSivjVEhkVh+2Jw/IKONQ2JcRYbwYS+b
	 GqkytYvNF90OmEKRWJSeZt4aYdvvnAf4+x7PE92ZBs53RhKKMos9FEzTpK0iEVHCoCHuL
	 NNxhgwjQU5kCVwGotcACDhS2SCuIk/CKMB0kWZlR0M4r8HCcZYieltLI7yc/QE0RYEeQT
	 XNBMUDJrxJ+bg9rwMcl/VFhnFAwaOvqL9xKMUIitN5YoOrsJMAQAAbPWGo5bDN37GgOjV
	 De2fuez+/IAWInFIAJRI8xXVzrU4dL/ZUpBAgc7hr8FTefr35kMlKwm4gQBBOM/muwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQQgsNfUKJAm/6PQbFzclseo/DsOr+vtNFrAq750BkM=;
	b=Fc6YoNsTLBiIRzBWPGEZD9ooLStA7fcBSHciCiM3cww3oGB2tjZKAlZbrY2z3PeMntmd
	 cPxYEBh12I5VikBHNQvVwOkYDof783zTDRoFLYHvmXGHytv2V4r1F8dYzlg44+STxLTn1
	 l9Qiknd+SlylnHR8oHyH6ElPBv+EXCW6QXW+mfUCw4aFOJCTcMrm1KJuUbpqnkA0QeWmZ
	 DJ8F1oDWIK0mi53Y0XQbkKYGWSKU37W22eM9H3YDrYhz3qTmi8WnZmeC72YYXDq2OIqHk
	 FnwFvIpeq1ffQd2FjJTuChqt1w6VqAcNx9nfb0iKZU+lwW877zmxIDBa22VKw6f3eZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bm5Fvavi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A96606A33D;
	Sat,  7 Nov 2026 14:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bm5Fvavi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045681F0089F;
	Sat,  7 Nov 2026 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062077;
	bh=ZQQgsNfUKJAm/6PQbFzclseo/DsOr+vtNFrAq750BkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm5FvaviVdFNvr9kS0kjmzb5Tb27k8Z+nIdYywU8+OUPFejTyq1UTOFSa7qp25Wsx
	 PbNFL27hTF5NRNGUL78321QTNDDY0lQ5HOQte0ayiLWIaftxJoVmlkBqdhZ3A9CMCH
	 3bGimDt2BUKQV2/y9flP2woeMl3Sdx5kArC0rj3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1054/1536] mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"
Date: Sat,  7 Nov 2026 08:51:10 -0500
Message-ID: <20261107135027.284851983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit b296be1dc008fe3a536341afae01f66bb302e67f ]

The wcd934x MFD parent (a slim_device) never initializes its
dma_mask/coherent_dma_mask. When the DT-aware children pass through
of_dma_configure() this triggers the "DMA mask not set" warning for
each child.

Cc: stable@vger.kernel.org
Fixes: f959dcd6ddfd ("dma-direct: Fix potential NULL pointer dereference")
Assisted-by: tencent:hy3
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260903-wcd-dma-v2-1-189cff560a28@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index fcd182d519811..6f9e8e5fb20b8 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2019, Linaro Limited
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -217,6 +218,11 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	struct gpio_desc *reset_gpio;
 	int ret;
 
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "Failed to set DMA mask\n");
+
 	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
 		return	-ENOMEM;
-- 
2.53.0



