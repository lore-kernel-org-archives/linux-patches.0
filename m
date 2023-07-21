Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF93327F1D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6367AC433C7;
	Fri, 21 Jul 2023 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965434;
	bh=fYypAZVeI8mYnK+mqgKmp+IrxnpJmAzOR7qYomiiEig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKEU8Aouii7t49/NOLAVn6UG1nqXn39qN+saRMXkQstjuosYnIeKzTcVA5NAehCtF
	 FbHBBhKn1/oAFrPS2BWcd9WnuhGswDq5lWchksI/QwcboWT1kwDR4RkW+C2PUYTi5n
	 c0/xZnRmm8jYCaP5Fa/ZYgUTDXzeTk/+966qSlDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.4 254/292] accel/ivpu: Fix VPU register access in irq disable
Date: Fri, 21 Jul 2023 18:06:03 +0200
Message-ID: <20230721160539.849988908@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit 020b527b556a35cf636015c1c3cbdfe7c7acd5f0 upstream.

Incorrect REGB_WR32() macro was used to access VPUIP register.
Use correct REGV_WR32().

Fixes: 35b137630f08 ("accel/ivpu: Introduce a new DRM driver for Intel VPU")
Cc: stable@vger.kernel.org # 6.3.x
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230703080725.2065635-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_hw_mtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_mtl.c b/drivers/accel/ivpu/ivpu_hw_mtl.c
index fef35422c6f0..3485be27138a 100644
--- a/drivers/accel/ivpu/ivpu_hw_mtl.c
+++ b/drivers/accel/ivpu/ivpu_hw_mtl.c
@@ -885,7 +885,7 @@ static void ivpu_hw_mtl_irq_disable(struct ivpu_device *vdev)
 	REGB_WR32(MTL_BUTTRESS_GLOBAL_INT_MASK, 0x1);
 	REGB_WR32(MTL_BUTTRESS_LOCAL_INT_MASK, BUTTRESS_IRQ_DISABLE_MASK);
 	REGV_WR64(MTL_VPU_HOST_SS_ICB_ENABLE_0, 0x0ull);
-	REGB_WR32(MTL_VPU_HOST_SS_FW_SOC_IRQ_EN, 0x0);
+	REGV_WR32(MTL_VPU_HOST_SS_FW_SOC_IRQ_EN, 0x0);
 }
 
 static void ivpu_hw_mtl_irq_wdt_nce_handler(struct ivpu_device *vdev)
-- 
2.41.0



