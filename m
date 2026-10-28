Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212324;
	b=jL2aFb+dKK9YVc3QnJoZ8gV2stoc1NCQqitoHJ8z/zSdTnU3bv8x5uGhKCfBTj+hUX+d
	 IW5mT5TrmLPf06jewD08z25SUf3hS57CsIrIKo8N/bL7QnhHBUllTKyhzU+WnBHXjhvaO
	 0IK9IO6fBrSag99RHupjzt+Iq9qchcppmN7hxOKFmtl4cXsuOgoWX8EaukTntj8XMPFSd
	 RV4ufEwkXOUv1cjmvpqctK4YNKC18JX7lpOc5C12YVRU+ubyij38q3aL29kux2R+DKWki
	 D8V4zeXh1vb4ozXjQrTXGwrZeA0jrKyB4clpizXBE169P9SKuZTWGkDJW9n0Gi8TLkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Y9J+Jk1rRQ1+3PjftPO51yqp3aKy4phCznQ4+ntd8A=;
	b=AoRbju9xmgQFYIpdaFkqEMJHJdGcrffxXPG0R8msb5+Nv9A66yeWl8TyX4j5rnL5dXr9
	 smVi8szJJrZjlqBtBdCDaj/vMbZRsFiIRxSX/Z04N7Y+8Es38gP0LwB+GYXbCP69oqCEI
	 KSl4ba4tjHDmbFodEbMJFzpNY0xYAHsKcMNLoyCRDD10bqYbFLxAvnhdozxsEvgZdYX/n
	 r3xrZZZ/CnCJvIWrxS8gjajqlZ/SajkGhvzR4QIArZMYYLE5ELnsyi+IrZ1fJzp8vHO1y
	 8kwY90bBiH7axfuD6WFwtzpTBe8zWkjMJGgYsPu/cB45elV+8Ynp/NRvDfwN34KC3Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAxA9PWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C245606A329;
	Wed, 28 Oct 2026 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAxA9PWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5281F01825;
	Wed, 28 Oct 2026 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212324;
	bh=/Y9J+Jk1rRQ1+3PjftPO51yqp3aKy4phCznQ4+ntd8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAxA9PWqkXJgXPBPZuocy7FZnazkE/h0196BBRd2Gp6wdkYVJmCzOlO4VroqE5XKR
	 ZrRvq1NORf7fJEOE65OsGak9kavqmmS/OyxdC9B59vfG0sXyTkPN2AqCFl1/Q5XM5M
	 29qYETcIOvDO2WjTlMvkTh3SBdB3FGY3/GrCB0Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0070/1887] coresight: etm3x: Fix cntr_val_show() to match cntr_val_store() behavior
Date: Wed, 28 Oct 2026 17:36:06 +0100
Message-ID: <20261028170500.825271616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 41fb4e925528aefa4b7a5f76c7f81db99c0d0f38 ]

The cntr_val_show() function was intended to print the values of all
counters using a loop. However, due to a buffer overwrite issue with
sprintf(), it effectively only displayed the value of the last counter.

The companion function, cntr_val_store(), allows users to modify a
specific counter selected by 'cntr_idx'. To maintain consistency
between read and write operations and to align with the ETM4x driver
behavior, modify cntr_val_show() to report only the value of the
currently selected counter.

This change removes the loop and the "counter %d:" prefix, printing
only the hexadecimal value. It also adopts sysfs_emit() for standard
sysfs output formatting.

Fixes: a939fc5a71ad ("coresight-etm: add CoreSight ETM/PTM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251202082613.3265761-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-etm3x-sysfs.c   | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
index fd81eca3ec182..a49b3c237c079 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
@@ -716,26 +716,19 @@ static DEVICE_ATTR_RW(cntr_rld_event);
 static ssize_t cntr_val_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
-	int i, ret = 0;
 	u32 val;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 	struct etm_config *config = &drvdata->config;
 
 	if (!local_read(&drvdata->mode)) {
 		spin_lock(&drvdata->spinlock);
-		for (i = 0; i < drvdata->nr_cntr; i++)
-			ret += sprintf(buf, "counter %d: %x\n",
-				       i, config->cntr_val[i]);
+		val = config->cntr_val[config->cntr_idx];
 		spin_unlock(&drvdata->spinlock);
-		return ret;
-	}
-
-	for (i = 0; i < drvdata->nr_cntr; i++) {
-		val = etm_readl(drvdata, ETMCNTVRn(i));
-		ret += sprintf(buf, "counter %d: %x\n", i, val);
+	} else {
+		val = etm_readl(drvdata, ETMCNTVRn(config->cntr_idx));
 	}
 
-	return ret;
+	return sysfs_emit(buf, "%#x\n", val);
 }
 
 static ssize_t cntr_val_store(struct device *dev,
-- 
2.53.0



