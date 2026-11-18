Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017466;
	b=jGa4RXCZwqbkWRavNteJc3wWjAm41fyQBM1VtL8Bf1VKNYNgikKruzG2YsptHHhG+qvG
	 gKLA93TwmFvQ3C57YJGq0+V8IfL84X7Tga5C/0wnkDF2kUqIayN3xcLb7BX/q+55SA9rh
	 aZdcR0BwCP2QOzaK3oomK8hVJbB7SOQ6KLSn3/37VrNhYhbYgEnByY+bbls3CgJs/D2KG
	 uZlt2rKJUf7kqHwc8/wBpOnDnVAdGkKWy2S4qz0ZG7x9IMEAZRJMJP8a5jDLLfCY89jAF
	 dXOvPfs3x1E0RDyb+cYuEchXndOPfCigolaWylhOUHaHXGCoMvy/Yw+E+3J5D1y02CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9n7WH47VkHObv6oh0s8IM+kFT7WYCT/bUM+qmNRmirA=;
	b=X6MZA5JnCIp1+DS5D0FV38X9wuHtkAtA808jhsccNkPMA2Ambr6v79QLVqcFfFm6uhw8
	 D7oomI18KJgKU13fYAkr1TpwXRPD2dXA1WFKK97b/K5EDHoQZPCeC3yh19IswEMLpyUv0
	 dQvbuXDoyOEipYx/NZ3Jo++d4oILUZlbaoM7jw49xR1anzfNW+rdIfGEq2CLMTjvoJX1r
	 dlxqTpngsjEcNJoWrc1dYI2KvrS6CSS5QoAEMoyjY2OszFR704AqldwvP+SbqeJ8D34Ak
	 XeRpbAQWKbjzY6d0YpBJUQJJ7fM+A/p7yPbMizYPlTlqiZ4ud1Y/vDlEuQ/TNaHzWMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QdD39MyL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1A0606A31C;
	Wed, 18 Nov 2026 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QdD39MyL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD441F000C6;
	Wed, 18 Nov 2026 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017466;
	bh=9n7WH47VkHObv6oh0s8IM+kFT7WYCT/bUM+qmNRmirA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdD39MyLLY5zKQlyKs1vp6BAwOzvR8ZS36qFQGg1VjQqwFuQWjYv9aTAd4x4ufTod
	 3QpiJKUEhlQJDZSDILZ7C7Mh/QtwNLtnzKWAVfcp1Fjueuqug1wiV5mY0PedQ7FX1T
	 RQ4MlOt90NLk3T/Wdzhyaa7SNvHVCjcZ11crGDhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0894/2651] scsi: ufs: core: Serialize AHIT register access between sysfs and host driver
Date: Wed, 18 Nov 2026 15:35:34 +0100
Message-ID: <20261118150320.051783215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 7dec5cedf7b248036da606c16f9f3f9aa350b417 ]

A race exists between ufshcd_auto_hibern8_update() and
ufs_mtk_pwr_change_notify() when both paths concurrently access
REG_AUTO_HIBERNATE_IDLE_TIMER. Additionally, the static local variable used
to save/restore AHIT in the power change path is not re-entrant and may
hold a stale value if a sysfs write races with a gear change.

Introduce ahit_mutex and ahit_disable_depth in struct ufs_hba to
serialize AHIT register access. The depth counter tracks how many
host-driver paths have forced AHIT off; sysfs writes are suppressed
while it is non-zero and the register is restored from hba->ahit
only when the last disabler drops it to zero.

Fixes: f5ca8d0c7a63 ("scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
Link: https://patch.msgid.link/20260914085148.136429-3-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c       | 14 +++++++++++++-
 drivers/ufs/host/ufs-mediatek.c | 16 ++++++++++++----
 include/ufs/ufshcd.h            |  8 ++++++++
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9927feec17f51..15d1e97e1c380 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4753,7 +4753,17 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
-		ufshcd_configure_auto_hibern8(hba);
+		/*
+		 * Serialize with the host driver's AHIT control. Skip the
+		 * register write while the driver has AHIT forced off; the
+		 * driver programs hba->ahit back when it re-enables it.
+		 * Mutex is taken here (not across the rpm calls above) so it
+		 * never blocks a resume that the driver's path may need.
+		 */
+		mutex_lock(&hba->ahit_mutex);
+		if (!hba->ahit_disable_depth)
+			ufshcd_configure_auto_hibern8(hba);
+		mutex_unlock(&hba->ahit_mutex);
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
@@ -11297,6 +11307,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	mutex_init(&hba->wb_mutex);
 
+	mutex_init(&hba->ahit_mutex);
+
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 12a6d4138e445..ff0a661c14305 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1521,19 +1521,27 @@ static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	int ret = 0;
-	static u32 reg;
 
 	switch (stage) {
 	case PRE_CHANGE:
 		if (ufshcd_is_auto_hibern8_supported(hba)) {
-			reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
+			/* Block sysfs AHIT writes while we force AHIT off */
+			mutex_lock(&hba->ahit_mutex);
+			hba->ahit_disable_depth++;
+			mutex_unlock(&hba->ahit_mutex);
 			ufs_mtk_auto_hibern8_disable(hba);
 		}
 		ret = ufs_mtk_pre_pwr_change(hba, dev_req_params);
 		break;
 	case POST_CHANGE:
-		if (ufshcd_is_auto_hibern8_supported(hba))
-			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
+		if (ufshcd_is_auto_hibern8_supported(hba)) {
+			mutex_lock(&hba->ahit_mutex);
+			/* re-enable only when the last disabler drops off */
+			if (!--hba->ahit_disable_depth)
+				ufshcd_writel(hba, hba->ahit,
+					      REG_AUTO_HIBERNATE_IDLE_TIMER);
+			mutex_unlock(&hba->ahit_mutex);
+		}
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c1..be62165b785e0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1132,6 +1132,14 @@ struct ufs_hba {
 
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
+	/* Serializes AHIT register access between sysfs and the host driver */
+	struct mutex ahit_mutex;
+	/*
+	 * Nesting count of host-driver paths that have AHIT forced off.
+	 * Non-zero blocks sysfs AHIT writes; AHIT is reprogrammed only when
+	 * the last disabler drops it back to zero. Guarded by ahit_mutex.
+	 */
+	int ahit_disable_depth;
 
 	unsigned long outstanding_tasks;
 	spinlock_t outstanding_lock;
-- 
2.53.0



