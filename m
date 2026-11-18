Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034790;
	b=E4t5SKE1AJr+9WI2mfTC77mEYhSDWZT6nARR27TOqtL6pIVZAMV4OjbbMb+VkKjSkAvC
	 vlG7x5iih5eJ8dbNmm+TO8Qlqzo3IW1e0j1bUHKQwcY2A9t9dLxXcGjv6cfMM6mPE8zVt
	 wDTrvVT86UMrFO8Vtf1qG//dMGmSc0D2T7bnzuza4Uw01S2046DgXUTNziGejjKG5gSVy
	 3yS9CAv3wLjBa1YyLoKPw+OROaA4YIXQYWHowkOhAVYs0JXcjaiG+fH0Vz0VyNm5iGKJr
	 1/Dx9+g+bqh78BXqtBDQamHgbOuC4sTrWi6TS84npLrV5Rh5cV/XFxBakj8KC8RDuTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1/qU302AcZKES6UDHPYlpWk83+/r8V2tuGjljpl0jYo=;
	b=46yEpESCmPPzOxo2qqLF5UWZzDF//3fWlZdk4x6IlDWSkfmT8l+JsJlJStZQ1rXv+NIo
	 Ef0wLpMyPaek/x7moFWGLSEs2vZV3ISlUWDdPscEOVI0r2uRo/NCkWwuoKlgMCGFEN0Yv
	 wIWUJTrDjugs6k1nOPzPYTxwR1V6I0pjoKl2QpICmjvs7FcNU4AtiZazF4HskZjQeyR+1
	 q3NXSDczrpcTT1OsboSKIpKQaigOsws/yMi3VOhahVcHfJTauoEBPQHMwUuN9ewb09ES/
	 9qo8jMAkVMgbpvUyATGT8LwWLdO0ZExz3iCy/+THH8j3gCf69Q+O4L6i/sVUDx4WyIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnRyDepc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD526606A320;
	Wed, 18 Nov 2026 20:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnRyDepc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243D31F000CA;
	Wed, 18 Nov 2026 20:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034790;
	bh=1/qU302AcZKES6UDHPYlpWk83+/r8V2tuGjljpl0jYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnRyDepcGl3SyrK09qeoOebuSWOI8yjLyfUgu3jaC1wfh1A4YVpJfYfO7BPeLtVAt
	 ZOHPd0AcVEvn3y0MFZN0F9x9pWfx7y6LwFVNFuAOXxS/NPwEY+rxTT0JGvOWWfXryE
	 kd7OVmU77FrmRxnhtv6BCPEQqe4afvvrtECODAZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Liu Zhenlong <dragonliu2018@gmail.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0496/3318] i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()
Date: Wed, 18 Nov 2026 15:18:38 +0100
Message-ID: <20261118150331.907131409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Zhenlong <dragonliu2018@gmail.com>

[ Upstream commit 7362a1553eb09a8cdf8be7e509bd5309a8342486 ]

The of_node_put() matching of_node_get() runs after i2c_del_adapter(),
whose trailing memset() zeroes adap->dev and thus adap->dev.of_node,
making the put a no-op and leaking the node on every adapter removal
and error cleanup.

Use a devm action: the pointer is captured at registration, out of
reach of that memset(), and devres runs the put once on probe failure
and detach, replacing the three manual of_node_put() calls.  The
setup loop uses the scoped iterator form so the child node is released
automatically if devm_add_action_or_reset() fails mid-loop.

Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 02a4a69667a2 ("i2c: qcom-cci: don't put a device tree node before i2c_add_adapter()")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Liu Zhenlong <dragonliu2018@gmail.com>
Cc: <stable@vger.kernel.org> # v5.17+
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260818175750.4205-1-dragonliu2018@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index 0422c73109c51..599785cba1d56 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -518,10 +518,14 @@ static const struct dev_pm_ops qcom_cci_pm = {
 	SET_RUNTIME_PM_OPS(cci_suspend_runtime, cci_resume_runtime, NULL)
 };
 
+static void cci_put_of_node(void *data)
+{
+	of_node_put(data);
+}
+
 static int cci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *child;
 	struct resource *r;
 	struct cci *cci;
 	int ret, i;
@@ -537,7 +541,7 @@ static int cci_probe(struct platform_device *pdev)
 	if (!cci->data)
 		return -ENOENT;
 
-	for_each_available_child_of_node(dev->of_node, child) {
+	for_each_available_child_of_node_scoped(dev->of_node, child) {
 		struct cci_master *master;
 		u32 idx;
 
@@ -558,6 +562,9 @@ static int cci_probe(struct platform_device *pdev)
 		master->adap.algo = &cci_algo;
 		master->adap.dev.parent = dev;
 		master->adap.dev.of_node = of_node_get(child);
+		ret = devm_add_action_or_reset(dev, cci_put_of_node, child);
+		if (ret)
+			return ret;
 		master->master = idx;
 		master->cci = cci;
 
@@ -629,10 +636,8 @@ static int cci_probe(struct platform_device *pdev)
 			continue;
 
 		ret = i2c_add_adapter(&cci->master[i].adap);
-		if (ret < 0) {
-			of_node_put(cci->master[i].adap.dev.of_node);
+		if (ret < 0)
 			goto error_i2c;
-		}
 	}
 
 	return 0;
@@ -640,10 +645,8 @@ static int cci_probe(struct platform_device *pdev)
 error_i2c:
 
 	for (--i ; i >= 0; i--) {
-		if (cci->master[i].cci) {
+		if (cci->master[i].cci)
 			i2c_del_adapter(&cci->master[i].adap);
-			of_node_put(cci->master[i].adap.dev.of_node);
-		}
 	}
 disable_clocks:
 	cci_disable_clocks(cci);
@@ -659,7 +662,6 @@ static void cci_remove(struct platform_device *pdev)
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
-			of_node_put(cci->master[i].adap.dev.of_node);
 			cci_halt(cci, i);
 		}
 	}
-- 
2.53.0



