Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829668;
	b=dkLBAMCZIQQ14HmlSUKdoDsAh/K0zzFYR0uhgYykIcctgdAw+HEtEw5SE7MobbL62eTh
	 z6uCxVKckoJXbz2Na1UexovzViMIp+zkEH33Dsmra3zdL8T1NZOYUviN09qDVZEf2V6w/
	 OiaHgi4LcDp2YJELIVwwpdM765qvkKjXovyFG4nVu+3ApwWZ1cJKpzrM0VgmurkUr55R/
	 T5xaXPtJE/cl2f2z2pe22K0PVillrxxXfobEDXGFOhFsuRVoUwyKuDz+G+XPJpmFKgDQ/
	 bPZb4mBykAnv5JOs3BoOt8KZNlL0Uef4CpqVk9OC9c4dlbfTrhKccdsfm+wWYvQJbEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=udGTOhhkqG7HscxyiXq9qpBJLUsRQFSPccfrZOcm7kg=;
	b=qvBxK+lsWJgc404rnm+fofEPWXpfyNuZDcczAV2aBmYJZjgA2MPzpQYF4hx/hO65wHz/
	 zgGXYP1fMWcYe7joBA2cu+NT109nFXSDkaRkKnmsJxvhlyk8ju8iFM6BGaXsn5J+4+9zp
	 AJgJQU7A8+QSPfbOSU2CyxfUkFe6YJYo8vRzws/XG34bCEw6ErNzgslDUhCgixJr+4id6
	 Evkrw9kaJ1rWJloew9GM3XBPZUST2JIbZly3vtIYX5TysEmOcNGRD4a0uoRV4oo3jjGwg
	 4RbGH30YlJwMhwh5z8uGPW8Cx4gALoBnSJ3QWK9hEoirgOnxbxAJXRMVrhnwNlyEqeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2gMW8e7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55349606BA3F;
	Wed,  4 Nov 2026 22:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2gMW8e7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D201F000C1;
	Wed,  4 Nov 2026 22:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829668;
	bh=udGTOhhkqG7HscxyiXq9qpBJLUsRQFSPccfrZOcm7kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2gMW8e767BL/gBUwAiQJV/3PLfAl3t8rmZD2XJTKn5miRMUNsZtpr46a/+eOHs/8
	 ddZdT99qtOl+q1eMeMqK0gCgw/AnjE/pqNHZTCK0D03Q0xWfoaHf2IBtLC8oSfiGPh
	 Be3kadKpm/AJWqJSpOIhnTEgfF5ZCudGyDhqgd5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0269/1005] i2c: qup: Propagate clock enable failures
Date: Wed,  4 Nov 2026 16:00:02 -0500
Message-ID: <20261104211051.411097006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a477626332800942f463d76aa48db0c47f1dfd18 ]

The QUP I2C driver treats the core and iface clocks as required
resources, but qup_i2c_enable_clocks() ignores clk_prepare_enable()
failures.  Probe can then continue to register the I2C adapter, and
runtime/system resume can return success, even when a required clock
transition failed.

Make the helper return an error, unwind a partially enabled clock, and
propagate failures from probe and resume paths.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260624055237.29977-1-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qup.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index a0e076fc5f363..ee7915ee2ba2f 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -1657,10 +1657,21 @@ static const struct i2c_adapter_quirks qup_i2c_quirks_v2 = {
 	.flags = I2C_AQ_NO_ZERO_LEN,
 };
 
-static void qup_i2c_enable_clocks(struct qup_i2c_dev *qup)
+static int qup_i2c_enable_clocks(struct qup_i2c_dev *qup)
 {
-	clk_prepare_enable(qup->clk);
-	clk_prepare_enable(qup->pclk);
+	int ret;
+
+	ret = clk_prepare_enable(qup->clk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(qup->pclk);
+	if (ret) {
+		clk_disable_unprepare(qup->clk);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void qup_i2c_disable_clocks(struct qup_i2c_dev *qup)
@@ -1823,7 +1834,9 @@ static int qup_i2c_probe(struct platform_device *pdev)
 			ret = PTR_ERR(qup->pclk);
 			goto fail_dma;
 		}
-		qup_i2c_enable_clocks(qup);
+		ret = qup_i2c_enable_clocks(qup);
+		if (ret)
+			goto fail_dma;
 		src_clk_freq = clk_get_rate(qup->clk);
 	}
 	qup->src_clk_freq = src_clk_freq;
@@ -1975,8 +1988,7 @@ static int qup_i2c_pm_resume_runtime(struct device *device)
 	struct qup_i2c_dev *qup = dev_get_drvdata(device);
 
 	dev_dbg(device, "pm_runtime: resuming...\n");
-	qup_i2c_enable_clocks(qup);
-	return 0;
+	return qup_i2c_enable_clocks(qup);
 }
 
 static int qup_i2c_suspend(struct device *device)
@@ -1988,7 +2000,12 @@ static int qup_i2c_suspend(struct device *device)
 
 static int qup_i2c_resume(struct device *device)
 {
-	qup_i2c_pm_resume_runtime(device);
+	int ret;
+
+	ret = qup_i2c_pm_resume_runtime(device);
+	if (ret)
+		return ret;
+
 	pm_request_autosuspend(device);
 	return 0;
 }
-- 
2.53.0



