Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018316;
	b=l+8A5LTtt7Q+xWrNzy6nguI4WfQctyDLMV789zlYuosTuk1N9YEUjFgbH5XgOvHwjjRI
	 fHU4dWxwW4L8V7aHbGzQJXWKqOpoJgPFqlNeNpof+swLjc/X/50KQ/wi51CTq0TKFfDyM
	 uGcNg6NufoQtAvAvaiJTZAX3nxN3FUUXETu7I4mmQ1yo1sBLHa63AUnsGs62PyVOGsyag
	 orYY/J80ch86gKycDrYelHF/x41VrPB+itLDkFn37RkUcqtU0AH+R71dyFlr6IQytDEyj
	 mq3ssWoPh2Sba9KByksE9Bd0dpsM4l/y8fImqr9IK6nW+7mZljW6I7dZEpFtGOheNkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QiKBW3JwmidupF0FemGjs1M1D+GRKmn0Ut5DEKL5q1Y=;
	b=Fh+zGHim9jvtsBOyBodLA/KYn7NKW7Lhl1n8CD2IL4j22wcnYAEkKL+SaOhvFlanYS1a
	 NcxN1IxAfTiBWBgS0rWX9gvNRzI4387yBBhJ3KQ04a16bH5Gn6sAi5EnMI+xFSF5CpSe1
	 oyipOWpw1qPXAO5DQxPy5Ng3fwTD29C6dIGHw6PK1TDrwoqsAKE9xWQrPOO9rBnO3yi9k
	 9Jyh19ahTsCMPAhOP8Nb0XO379CehjKtzN+dJvWyqm+XxTID2he7rm2rVFBhd0EH3R0bD
	 w80KBsGr73cqruOj+tu0XyK8LC4rr3ucXQg5aIB8rAvUyNCTgvY0bl3YIly8qItxfeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecmlS28T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73001606A320;
	Wed, 18 Nov 2026 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecmlS28T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99861F000C4;
	Wed, 18 Nov 2026 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018316;
	bh=QiKBW3JwmidupF0FemGjs1M1D+GRKmn0Ut5DEKL5q1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecmlS28ThWOaVbGi0N0i544EwVnQXWSCwPRpjlqnMBUrtC2wUggIljdvPSI3xnb/v
	 NlOZwGELuTc+Y+xvcywYfajlVGfqXJlUThnr2NxHXZOnwDuYdJsBw8JFx0C9fY9XhK
	 YRSPpnHJQzz0tL3gU4iA61t3tTmPlGwGARUuZQJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1197/2651] coresight: etm4x: prohibit modifying cntr_val while session is enabled
Date: Wed, 18 Nov 2026 15:40:37 +0100
Message-ID: <20261118150331.090881833@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 76b21c25a5f7701ded1386952bb37a29d3ab69c8 ]

cntr_val is overwritten with the values read from the corresponding
registers by etm4_disable_hw() when the session is disabled.

This means that any changes to these values made while the session is
enabled would be lost when the session is disabled.

Therefore, prohibit modifying cntr_val while the session is enabled.

Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Mike Leach <mike.leach@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20261003-separate_etm_cfg_v2-v13-2-5d8a29aead95@arm.com
Stable-dep-of: b2131cff7224 ("coresight: etm4x: fix inconsistencies with sysfs configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index 4945d577ceabf..863bab9c2e27c 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -1615,6 +1615,9 @@ static ssize_t cntr_val_store(struct device *dev,
 		return -EINVAL;
 	if (val > ETM_CNTR_MAX_VAL)
 		return -EINVAL;
+	if (IS_ERR_OR_NULL(drvdata->csdev) ||
+	    coresight_get_mode(drvdata->csdev))
+		return -EBUSY;
 
 	raw_spin_lock(&drvdata->spinlock);
 	idx = config->cntr_idx;
-- 
2.53.0



