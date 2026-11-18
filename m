Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018313;
	b=W6m1iGiqm2whFpBqGw+5ZOFZewpsQiq0etbnOp4bIsXXnvKm2EhiP2C82+XkiSk1Kn2t
	 i2jOnmg6JSBc7IV/pXU957orxZ0U6zVi5oiPeofl10Qa5VXcgvyYHna+mnCJzkJ+u+wU1
	 MIx1PgzMaVmK43BrJDLy3bvaL5bUFRfjBsgTjI3ihCJz2zNMRLTkY1KlNXTRJbUX+jdh9
	 5d/8FoHpvRz63wTpHJtprmqHdWtPxVF4lds4QUrg8J9uvU/Q1MPgQ/nu8PzrS5yUdbu3i
	 GYz4/mBN19UKDf3HQG4xUaHuEWdaF4hVc3LHACDcYyLuGQqOUdZtp88xE4z0p5k9yYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VeTpcSwDHTIrRH5upYu04emytQaAvEZwatXZXFW2dAk=;
	b=RuDhlLY11kz0dT42tjVkpSRChUAIkf2jr12cgSaqm+vI9iFF5RKWh78lcY4tmDsHytpi
	 7LXNp5MMN5O9D4zGfwxSlgQll16WVFPD+UyvdbvZEItEEzo+qs1IeWgnNIFqrp/4RV1Z3
	 degXEQ2OtU687QiSy3edruGMyuLsfOxHGJyvHYjHlGQ/oR4x0W/Xh35znKNCKtSzlozys
	 p8ck/21y7CpTtki+VdJ36l6jI4VhzkNE2AXicJw+hEu5eV3ilLDiTvDPigYdSrbCpvrZX
	 /T872x03U65fHF6a6k0kcjquAMyU8mV77IlaVqUc6FmknYMzGncq7z13+qP2GYWYnag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zg8NPCJW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB66606A31C;
	Wed, 18 Nov 2026 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zg8NPCJW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8081F000C4;
	Wed, 18 Nov 2026 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018313;
	bh=VeTpcSwDHTIrRH5upYu04emytQaAvEZwatXZXFW2dAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zg8NPCJWH7AIN9D9hs5aG5zs/60F9TKZKoLBqhUb8aSC8vZFTdgsjT03SGwjeDhe/
	 CS/NNW8SYMKm9+3nuFDKxIYhAzXvkqfQUMHsttdtS1vmnJsss0mXSMcKDVkBjKCHVI
	 Jsv6sbNL5O4FqKXRObinejiBw7KP82WUNQ/eEbrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1196/2651] coresight: etm4x: Prohibit TRCSEQSTR modifications while tracing enabled
Date: Wed, 18 Nov 2026 15:40:36 +0100
Message-ID: <20261118150331.054503430@linuxfoundation.org>
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

[ Upstream commit a373952d86cf5d1efac5acff4f1d85fe66094d47 ]

TRCSEQSTR can be changed by the ETM while a session is active. Its value
therefore needs to be preserved when a sysfs session is disabled so that
users can read the current sequence state after the session ends.

This means that any changes made to TRCSEQSTR while the sysfs-session is
active would be lost when the session is disabled.

Copy the TRCSEQSTR value when disabling a sysfs session, and prohibit
modifying seq_state while the session is active.

Suggested-by: Mike Leach <mike.leach@arm.com>
Reviewed-by: Mike Leach <mike.leach@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20261003-separate_etm_cfg_v2-v13-1-5d8a29aead95@arm.com
Stable-dep-of: b2131cff7224 ("coresight: etm4x: fix inconsistencies with sysfs configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c  | 4 ++++
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 2247ad55d4442..9ca03a5913a30 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1073,6 +1073,10 @@ static void etm4_disable_hw(struct etmv4_drvdata *drvdata)
 			etm4x_relaxed_read32(csa, TRCCNTVRn(i));
 	}
 
+	/* read back the sequence state */
+	if (drvdata->nrseqstate)
+		config->seq_state = etm4x_relaxed_read32(csa, TRCSEQSTR);
+
 	coresight_disclaim_device_unlocked(csdev);
 	etm4_cs_lock(drvdata, csa);
 
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index cc6cdd3ae29d5..4945d577ceabf 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -1435,6 +1435,8 @@ static ssize_t seq_state_store(struct device *dev,
 
 	if (kstrtoul(buf, 16, &val))
 		return -EINVAL;
+	if (IS_ERR_OR_NULL(drvdata->csdev) || coresight_get_mode(drvdata->csdev))
+		return -EBUSY;
 	if (val >= drvdata->nrseqstate)
 		return -EINVAL;
 
-- 
2.53.0



