Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030284;
	b=KGyCuRlq9Xc3IdNyAldnA/Vsp2NeBS69uUFt5JhgcvriqQ9RO3I0/JMh59LO+tqiet9Y
	 szMGxXdRWjhFJGYuiLAD8XkgXFbff8MrLoUSP/WO9yjbXR9ZQew+UYaaZoTpVI0KKZjLG
	 wYV71a0jmnEKUNPVsXR9alqoqd7y2EWmjpjUdc4XP8lLhirA4yzB06zUYHXPlq6FvGq2J
	 0kn6a4RwTaivn+l7LQlXlybVgp0caWy9cqJofsu/mKHfWDRZjAPLrtTXkhhXoSkPeWkq8
	 9Hsv/La/I+Q7xECY/JzJsg0xnqAhUPi3cPfwmk6wZjJwHaj1CFfvMQGbokj71x/JXxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o82GvH6JJd3S/vuFlXXmwuoNjsil04nOvWP0ZBW8qks=;
	b=NXf4KW/+CFyGwdvRycTHIHjYWGr31JAMZ3JK7onpSaLqx5SjbgYNWkrLzcRjL/9p95XE
	 toGIl8810P4LUcy19sX0Tb1zfhyhZlwDvZKI2yc6jTplMO5XWYfn6jvuiNQI1LiEkG/7I
	 pFxWHc8D+M+/Gr17WZq0qEqtV9FydkKsXDpbKADdObWDUKwWEzRtitgnwwmqSipLVburM
	 F3Od/CJOp9WoqbyfMNkwRKeIoRe8wPuqWcWxwuzfs4WmUDubN0z23Lckyf2Mn2BXmoJPA
	 TzslLeH6YjAMz22tbDBJVjrfI/ep4TtjWIR14Nt7HdNSmx4YMAw6BYCVE7Ge0bdZSzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZ6+1+6V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E354606A7D9;
	Wed, 18 Nov 2026 19:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZ6+1+6V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F771F000C4;
	Wed, 18 Nov 2026 19:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030284;
	bh=o82GvH6JJd3S/vuFlXXmwuoNjsil04nOvWP0ZBW8qks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ6+1+6VspcdS1SKzejxAEITWk59FJ3AanTVM66L+bMlrc6VcIGwvaoyqttsNNj56
	 5j2lVKaLPcaglSIpFnXhop8DxiDGELlQj9a5KW2Iv4YcFGAlCMl8Bpg93tq1+ME9Tr
	 l6JxV+wVlT+nyELuK+vfKCQOFyHYqJEJnBIbh2rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0609/1756] scsi: ufs: core: Serialize AHIT register access between sysfs and host driver
Date: Wed, 18 Nov 2026 15:45:36 +0100
Message-ID: <20261118150033.201167822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 798ad0338cd97..9dd1607c49d07 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4544,7 +4544,17 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
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
@@ -10668,6 +10678,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	mutex_init(&hba->wb_mutex);
 
+	mutex_init(&hba->ahit_mutex);
+
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index e4156238f51d9..ffce98cca2d81 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1266,20 +1266,28 @@ static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
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
 		ret = ufs_mtk_pre_pwr_change(hba, dev_max_params,
 					     dev_req_params);
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
index 70dcc13d136d6..cca831cc800f3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1001,6 +1001,14 @@ struct ufs_hba {
 
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
 
 	struct ufshcd_lrb *lrb;
 
-- 
2.53.0



