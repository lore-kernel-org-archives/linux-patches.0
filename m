Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034788;
	b=YfW4AA4vIoof9vQPP+sS0gKhMFKgCxrtvhljfuJDd+tvrT3oFaJoAKQ6r5sKJhCPzP8e
	 Bv8p5ECpV937fwGoMGhAV5V3DOgqQd/Hqp0wtldtIL/1W0vnF2/SIu+14ItiBIRnpxq7F
	 SBNZK4AABYNjpdQ72FezZEA/CFVzeFybTHeVn0qpx2G0Ht75D348/I0eY/wmc0fJFrdjk
	 tBvqPXffAasWbpOoo+z1/7aRYkQYV1EbDl2qsrHGD0p7WY/u3ATlwP1qaleILFxT2ubZA
	 QR5MKDLfhThcjQuxJiYiPWYY94cjLuxE8Eq0+GCMwk836r32bUZp2o36EWG1Ou5cHXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=i4c0o+mCUGQA3lfoI5SJ9UuhCWaNZHCr/AIgy+CNM+I=;
	b=FBW84qZm7NJO+91x4DbHkrOjbuFTFzjFzEYYTwnWbCkgOLoUSZvegfoPE5hAeK8EFR7U
	 YrXwHbananrc5hwsOsj5EOG1USm74NzptQtdNApxhjXQgFlXnSI27407/JppmresUJbwO
	 EwUrWUWWUtx+QF6UXk8e6R0kvAcwDJ6al7vNDMye7AWhOTOOTt0U6u+EeYTQIEev/CkG2
	 CSWMxZo5GL0G/muhIMq9SJPOeDll5S14LFAo111tE6tt01XPKKt1FxEUZ9kv1nWAaiROe
	 c7xzNVl9CF3kxKz1jdG4pr/3ZW8jeOG/dthyks7Lu4Rsi+HCbrsJdDTdNPp3XDuz3Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G+E0/2/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D2560A260A;
	Wed, 18 Nov 2026 20:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+E0/2/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827DB1F000CA;
	Wed, 18 Nov 2026 20:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034788;
	bh=i4c0o+mCUGQA3lfoI5SJ9UuhCWaNZHCr/AIgy+CNM+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+E0/2/PSgCOfaybQpVJV8mOHANdSnZuGbqD1xz4hXccPfwXfBJSSK7B0pM5CJe89
	 X30REnbfvEThXKEmZAiNPV4+xYkk0/38a8orAo7gPmKZFudQlkwOVB7n8duZH+5TUM
	 O1wBr9rN3yAxuGMrdOxeKlxNi/lVjhoCGPJPulm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0495/3318] i2c: qcom-cci: Remove the unused variable cci_clk_rate
Date: Wed, 18 Nov 2026 15:18:37 +0100
Message-ID: <20261118150331.871009808@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit b88c79699d72caa947ecaae85839b3563662ccce ]

Variable cci_clk_rate is not effectively used, so delete it.

drivers/i2c/busses/i2c-qcom-cci.c:526:16: warning: variable ‘cci_clk_rate’ set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=11532
Fixes: 8284750a1829 ("i2c: qcom-cci: Stop complaining about DT set clock rate")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 7362a1553eb0 ("i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index a759b2a863ae9..0422c73109c51 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -521,7 +521,6 @@ static const struct dev_pm_ops qcom_cci_pm = {
 static int cci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	unsigned long cci_clk_rate = 0;
 	struct device_node *child;
 	struct resource *r;
 	struct cci *cci;
@@ -592,14 +591,6 @@ static int cci_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, -EINVAL, "not enough clocks in DT\n");
 	cci->nclocks = ret;
 
-	/* Retrieve CCI clock rate */
-	for (i = 0; i < cci->nclocks; i++) {
-		if (!strcmp(cci->clocks[i].id, "cci")) {
-			cci_clk_rate = clk_get_rate(cci->clocks[i].clk);
-			break;
-		}
-	}
-
 	ret = cci_enable_clocks(cci);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



