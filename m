Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818675172F8;
	Wed, 30 Sep 2026 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787141; cv=none; b=ohHgN8P2b7T+iKjK6ar+7MlSDIwioFp5W/YvljXulym4Iv9HDVneh0wIWmTeROH6LwigI28k62WF1VdhWI/vqn0mLqNNaPR33lwL2HNP12RCCdFgS3060dRVyXZ+32FHTrACzFet1lMWWSZGOLicOZUaCC7B8ubGswWALON3/6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787141; c=relaxed/simple;
	bh=OJbvGy1WSeLQkF+wDv6TQFzAVxkwqPDbHxRhF2c8Enk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkgmh2+m4P8s2e7yMUBhtplr8S+0AsPXPFaXzWljgk2iMEoMKUw2mPf509k9LmVaqOqoaGbEvOcKDvEi0bzsY/dwq+YIlLgE1zubqrk1fULye/zYmaQsdoV0COWTJvlr4yEBGarttzLXktQFgp7DzDGJZDCnEsXZkL80btCB4To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZgjTgFN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZgjTgFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58191F000FF;
	Wed, 30 Sep 2026 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787140;
	bh=3DknalspYNvUE52XOnRmrZjlVUiS+4kdJ9RsCh/5IH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZgjTgFNvTDAyI9R5rvi4O38Qd5uM3s8pHUzwyLP+4L1VM2q3i+TND7yM3q54Ub80
	 VNlyBhg1qa/MtAY3enhDKWdxg+yzHQILvhbQsrOk5mjXFn0MqTCt6tnRsw8xDGZ+hF
	 j4GVU3JEXc/UcvvOtB2QoXoS1rE2DsqQ5I33hM5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sk Anirban <sk.anirban@intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 126/457] drm/xe/gt_throttle: Report power brake as a throttle reason on CRI
Date: Wed, 30 Sep 2026 17:23:51 +0200
Message-ID: <20260930152348.769872769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sk Anirban <sk.anirban@intel.com>

[ Upstream commit ea4debcd8016f73c5dee3a29250a3d7977f015ef ]

CRI defines bit 5 of the perf limit reasons register as a power brake
(PWRBRK) indicator. Add PWRBRK_MASK and a reason_pwrbrk sysfs attribute
for CRI in place of reason_ratl.

Signed-off-by: Sk Anirban <sk.anirban@intel.com>
Fixes: 8578e6d0546c ("drm/xe/gt_throttle: Drop individual show functions")
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260909114931.1039331-2-sk.anirban@intel.com
(cherry picked from commit e199c851c0ab608a0ca89e7be1756a1461b41a2c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_gt_throttle.c  | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 08251c7a1a4b6..247a736a54aaa 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -651,6 +651,7 @@
 #define   MEM_THERMAL_MASK			REG_BIT(2)
 #define   VR_THERMAL_MASK			REG_BIT(3)
 #define   ICCMAX_MASK				REG_BIT(4)
+#define   PWRBRK_MASK				REG_BIT(5)
 #define   SOC_AVG_THERMAL_MASK			REG_BIT(6)
 #define   FASTVMODE_MASK			REG_BIT(7)
 #define   PSYS_PL1_MASK				REG_BIT(12)
diff --git a/drivers/gpu/drm/xe/xe_gt_throttle.c b/drivers/gpu/drm/xe/xe_gt_throttle.c
index 1e7e3a31aa698..c0af5484611d1 100644
--- a/drivers/gpu/drm/xe/xe_gt_throttle.c
+++ b/drivers/gpu/drm/xe/xe_gt_throttle.c
@@ -39,7 +39,7 @@
  * - ``reason_mem_thermal``: Memory thermal
  * - ``reason_vr_thermal``: VR thermal
  * - ``reason_iccmax``: ICCMAX
- * - ``reason_ratl``: RATL thermal algorithm
+ * - ``reason_pwrbrk``: Power brake
  * - ``reason_soc_avg_thermal``: SoC average temp
  * - ``reason_fastvmode``: VR is hitting FastVMode
  * - ``reason_psys_pl1``: PSYS PL1
@@ -200,6 +200,7 @@ static THROTTLE_ATTR_RO(reason_psys_pl1, PSYS_PL1_MASK);
 static THROTTLE_ATTR_RO(reason_psys_pl2, PSYS_PL2_MASK);
 static THROTTLE_ATTR_RO(reason_p0_freq, P0_FREQ_MASK);
 static THROTTLE_ATTR_RO(reason_psys_crit, PSYS_CRIT_MASK);
+static THROTTLE_ATTR_RO(reason_pwrbrk, PWRBRK_MASK);
 
 static struct attribute *cri_throttle_attrs[] = {
 	/* Common */
@@ -209,12 +210,12 @@ static struct attribute *cri_throttle_attrs[] = {
 	&attr_reason_pl2.attr.attr,
 	&attr_reason_pl4.attr.attr,
 	&attr_reason_prochot.attr.attr,
-	&attr_reason_ratl.attr.attr,
 	/* CRI */
 	&attr_reason_vr_thermal.attr.attr,
 	&attr_reason_soc_thermal.attr.attr,
 	&attr_reason_mem_thermal.attr.attr,
 	&attr_reason_iccmax.attr.attr,
+	&attr_reason_pwrbrk.attr.attr,
 	&attr_reason_soc_avg_thermal.attr.attr,
 	&attr_reason_fastvmode.attr.attr,
 	&attr_reason_psys_pl1.attr.attr,
-- 
2.53.0



