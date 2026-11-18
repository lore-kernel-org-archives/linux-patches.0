Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025183;
	b=fTQXRoULRqSG9EeFH+YG3atdFBAWaD/8sxYdTAG91aHFvWTyplg2N1qc2yr8Yjqm7bOB
	 vmY5jAXQGztP8+5CoeLdDH6I690kxbYy29ew3Hibun2SBJVh9OuKIS2UF3oXlVgWzMQTn
	 8paEDmnpDdKH5XVgzsasNcG03bCsVkbCsMa2jrhNvOAA5hQIDUwQ2gs/2ViM6HOSoDfm/
	 1hSzqHWSIQqVY+pL43XSV4wbIxeBYP4Tb2uUc9bgHMv8y9Ok7Fnn5xNJSwEyfD4IGFXej
	 DgaEcM/uwMeQjCjE9mOqmsXCad/+rSBOY/iyp08R6voJz7az6qm8qd6GVh+BiyyclWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X/XPdCmAnDWiHWvS7a3K8rtHBX4NLyhZcGZq4+1Qrnw=;
	b=JzXEwkYKt/Mm8wl1G9a+5EnBnrBqFHbHEzXpGJbqLsQaSLm4g+m4o1B1sCnuKF6f4OLy
	 1ZBPaogBtT5kUMHUncCiu/Q6K8F6jWw1rIJzuJntEKHymLohQ0HYH0Bo7Fvi6XskVl6yc
	 /I01zt39+iunFS18IaBJR2OujdLGOylOHPkNM11rdtXc++SfhENkzcaTuUrktfiRjO1oh
	 IMlarLGn/PBGp5FW5021PUmiirwUQDDflbknnprxwCWEKb2OQ1S8oUz2f/ED/UbHEOef9
	 51u1BM0ylnoUE9qrJofqPZnIhwNhFHFYHLsMhH31G6PA0k6Myt8D9oBZqfL5WN0O/Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Djo5SqJm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5BA606A331;
	Wed, 18 Nov 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Djo5SqJm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACC21F000C5;
	Wed, 18 Nov 2026 18:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025183;
	bh=X/XPdCmAnDWiHWvS7a3K8rtHBX4NLyhZcGZq4+1Qrnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Djo5SqJmI4q0b91e1mmiEzt7h5T/bj5fZdW380e3tRsowdjvgP5xsEsggU1UiyRiL
	 VES0mmLA/i2YqojnNEMZND1C+N0UM3DnlZwK0KjaOzjws0ZI0HMz9TQRY6Ov6Rb/qy
	 0n5pcIrvt01o/jIFKjXb+RnOI8Z6ydAY3L/7NTgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0990/2151] coresight: etm3x: Prohibit modifying cntr_val while session is enabled
Date: Wed, 18 Nov 2026 15:45:25 +0100
Message-ID: <20261118150158.525138629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 88eaf963853d557957a9dcbff6b33d1626c91cb7 ]

cntr_val are overwritten with the values read from the corresponding
registers by etm_disable_hw() when the session is disabled.

This means that any changes to this value made while the session is
enabled would be lost when the session is disabled.

Also, reset shouldn't be called while session is enabled.

Therefore, prohibit modifying cntr_val and reset while the session is
enabled.

Reviewed-by: Mike Leach <mike.leach@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20261003-separate_etm_cfg_v2-v13-3-5d8a29aead95@arm.com
Stable-dep-of: 950cca5352b0 ("coresight: etm3x: fix inconsistencies with sysfs configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm3x-sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
index b3c67e96a82a4..cdb70a4382eb8 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
@@ -75,6 +75,10 @@ static ssize_t reset_store(struct device *dev,
 	if (ret)
 		return ret;
 
+	if (IS_ERR_OR_NULL(drvdata->csdev) ||
+	    coresight_get_mode(drvdata->csdev))
+		return -EBUSY;
+
 	if (val) {
 		spin_lock(&drvdata->spinlock);
 		memset(config, 0, sizeof(struct etm_config));
@@ -744,6 +748,9 @@ static ssize_t cntr_val_store(struct device *dev,
 	ret = kstrtoul(buf, 16, &val);
 	if (ret)
 		return ret;
+	if (IS_ERR_OR_NULL(drvdata->csdev) ||
+	    coresight_get_mode(drvdata->csdev))
+		return -EBUSY;
 
 	spin_lock(&drvdata->spinlock);
 	config->cntr_val[config->cntr_idx] = val;
-- 
2.53.0



