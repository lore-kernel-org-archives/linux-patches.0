Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018322;
	b=F5RIDst+lwRfxD6LoKmh+TBG580Qu1/Ndyumhzy823GcoXr9xFaSKmg1GQeFpO9vf1h/
	 psNdpfeXf//zDMBRc8onR4SeX0esUYKiUmYqra8O2xUfUhD7yHT86Hrcqf4myykCpFnRx
	 U59LDoPJHgv1czzLmedoMfe0MGVRQHW8rQjeqk2Gz+fWFh1I/ZI/WJCcbaCqOMXZRFjLn
	 aVP27nevaNotErjObQ0L2evpNbyQ07SRckbcvBZDlO3UeRfuI0x6k1t+9hCMeJ11+iwOn
	 eBrcFbGEsfEPi6XZy0TbMgGoVEgKeqT7/cogI+mLuSkpXKhPhHDV/UfZJ+ltSiystKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UYN+h1eRYkMXWv1U6dEIWhGbPIKkAq49zyHlC6O0JjE=;
	b=THxYOCqqk9GhlmOYpF+qWKJfbizdVFPcwBLPeQ3bBBR/I0oWEtSI3OW7fH/r22UQSm4N
	 oguMS5o03DxyzIHJ/qzHUP0lwpK5b7NWUR7rD5gaFsYSPNUP/FDHeH3N7kBBDHUIa3Rnv
	 VyEq0PsKpeEFWIzFelZ4ABIv/eunxJr/vrAeAy7aLhKjJoiTCzor+aAjIYWSFD1jHbpko
	 20sn6hWdNneAyYYQ1+T2abk4kGddPO6ILwUGs2mwVRadSwiBlDQlv4Ct0W1II4mXhJZ2D
	 AYrZ+b6Dd0vfrRm5R5wijRtHQvh60+GJHr5SL3GoycV2UUEjHM9gG6nMiFuFbB/grxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yhYp1eA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6560C606A320;
	Wed, 18 Nov 2026 16:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yhYp1eA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEFF1F000C4;
	Wed, 18 Nov 2026 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018321;
	bh=UYN+h1eRYkMXWv1U6dEIWhGbPIKkAq49zyHlC6O0JjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yhYp1eAg74Bjo47bmdFZJoaLyWxtv9n8SKiOWOJFJhEVDo+XRhUwfSrZiwBqjq5y
	 qhoizWzlRfEO7WMz8u0vg9H7Fgb/Tl2MUievFyRp1uWgBuQVLJvntL7nUMLT18w3WE
	 HaGcNFco7Ausps6SaHy6C+I0D6kalywsI5LqFUd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1199/2651] coresight: etm3x: Prohibit modifying cntr_val while session is enabled
Date: Wed, 18 Nov 2026 15:40:39 +0100
Message-ID: <20261118150331.161995240@linuxfoundation.org>
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



