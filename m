Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063003;
	b=dlJFrd/bCT2QpwUTRcpDySHf8dyv+BuOwxPgZuwDEpg71iT2r2sJzF4ttdw6W6ZPxZWO
	 35CpXRfh7Ef+yjdkP1zIY8qEn2DMhSrsFIjzWGOFN+2/ZGqsOz7b1s/dIpi//5nG5ezTf
	 sEaQbGY3YUEynxJMaRH+hb8yZ5/8B78ypzUoW8b+piKI8wzK2PPk5Y+U2si/7dl5OQOzB
	 lK2xivSDCbvNkUR0ldX/l8jGfLO5HkVVD+nFI4C+t8Z1mqS5d2PgKabTrtr6bBo7mAY0D
	 6CpMrPx4OB7WhO7YFC55mz6LrzCGZRTAkOanm1px3OWgccQer/DfaG9GbLXEyHBuUQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8sis7j4qltvDCiqyKMe/Uf2Dkhz+DTYIJWjJNr9ZsqQ=;
	b=RogfEiHMHHxbPxEs3/39BR3D+6abmLWW7FpNQMRZ+de20Ei8Bv3zomSI51RxQlhmt9FQ
	 tVqeh2B93jZZPbi6+xKeLlqYRT5Th8nXceoAMLzJO9A1jy06qGLVmev4CeGGDlEQBFsO9
	 TN0VH1bQmVKd0EGlkC5cRn+srnOAyXe80eYeK2UWLfADEKjoLR9i+1j/13/jXJSSpCQf/
	 XvhgZDJrcC7FlguYJ3ZeTZe/qqGM43vtjDl0zzPL8niGWLYtoNIbu2rJireES86mXpqCd
	 9mbSunwHG4ayyvXNa0ePwCnkVc8PtrmjCe0gde8ySjcXE9N5+/0VN4IOMzTefNcr52A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQJmtqyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA5E606D80A;
	Sat,  7 Nov 2026 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQJmtqyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62F71F0089F;
	Sat,  7 Nov 2026 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063003;
	bh=8sis7j4qltvDCiqyKMe/Uf2Dkhz+DTYIJWjJNr9ZsqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQJmtqyHT5K6TQzFEiGrKhyhNmws+u9Uk00Bgq/xtsbiP31vgOBahtO9P+dlgUa6y
	 dJ3X1H37HKFECBe4z0mXtyr+ZyQxoGIwM4j6P425PHe0IodYkFWh6ykHE8ZdvyWnjo
	 FXqcCZFMVWbW73/3/VxUvfEbxABkDlr/ysoJPgVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 230/869] mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"
Date: Sat,  7 Nov 2026 08:48:32 -0500
Message-ID: <20261107134859.644994074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3c3080e8c8cf7..7bea64fc09562 100644
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



