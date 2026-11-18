Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034785;
	b=hoVVyOHbJtPSXz+2WMrmUjj9ELO5rjyE8IBJwrg2lGGCew/kb61aYfK69B5kkasld3Rw
	 lonKaqvZPFCjggcERjgJhfMBWxlSjPsh6YsAvics6RcvR8HxOENAXTB6VlKLzDrKoaoSU
	 Z1CWUZ2+0MdcUpPt4Ud0QoggQTFyGE/K2AEOrsc0SQ/1inqkV7Qz4q4bzxQklTc0/fKSB
	 vFPnOG/wJIl+Lrsj68z1EFyHuM5TFBYX3Fmo29fv8tGlD4wmZbkrHY+PhczpURU59uvhI
	 DiDFGQYZebJzuuumFPUACH/sq6qz3KcGSowPFKRwVdYzvyzmHdgwHXVUCRSBZXg5yYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ohH9t02VkPZWRyK/tSsybOajP8jcWVm0zMg9jra/aM=;
	b=l/zVtmK9Y7BSojeLUhP+Y5TEOShDOw9BrFN6TD7HqGI77y3oLLytJ7HRhfPHCSSJmsM/
	 GH47QTw5swkr03lY6nzBTOfPUC7dv8f/tXZrFiPE+2x5jml1qiIla34KQMJ2XZZ7ocrdP
	 RqLBIBgq01fc6kD+F2blpTJz15VYXKnuxvMONRjeQ7Zsnd5+CS6MtIqcPku7kag92tl3I
	 +4EZ//xsX6C4erSsI8mmiKt3Cr8KXNGZp1hzNKXfWKsKvEtx2flySenfrtytvUwjfWB4Z
	 zVxSxcKK3VBrAhWCwT11yDgj52VUX0mdgkKSG/rOHU5drsU3+h7NFfVKvCbQZiHSjgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcqNXXBX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8000A606A333;
	Wed, 18 Nov 2026 20:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HcqNXXBX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6EA1F000C4;
	Wed, 18 Nov 2026 20:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034785;
	bh=+ohH9t02VkPZWRyK/tSsybOajP8jcWVm0zMg9jra/aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcqNXXBXVOSw45mfAAYbe3ZBzYXIjoliQ6uVOh4PwGzxJpz4RXu77/jXbPhYsMQ+X
	 D2A9bU8nDq97TMu408fcJ9HjTeZm0FNXAuuQKE0ZvPWKCnfW07yQ1Pz9PoDkaG2JnR
	 IvQUEJrYQArAhQ7PrDC6YtiwaXBMyoI3YYNzdtvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Richard Acayan <mailingradian@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0494/3318] i2c: qcom-cci: Stop complaining about DT set clock rate
Date: Wed, 18 Nov 2026 15:18:36 +0100
Message-ID: <20261118150331.833915619@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 8284750a182937bf805f703311501730f02eb40e ]

It is common practice in the downstream and upstream CCI dt to set CCI
clock rates to 19.2 MHz. It appears to be fairly common for initial code to
set the CCI clock rate to 37.5 MHz.

Applying the widely used CCI clock rates from downstream ought not to cause
warning messages in the upstream kernel where our general policy is to
usually copy downstream hardware clock rates across the range of Qualcomm
drivers.

Drop the warning it is pervasive across CAMSS users but doesn't add any
information or warrant any changes to the DT to align the DT clock rate to
the bootloader clock rate.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/linux-arm-msm/20240824115900.40702-1-bryan.odonoghue@linaro.org
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 7362a1553eb0 ("i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index c73cf7abe5832..a759b2a863ae9 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -600,14 +600,6 @@ static int cci_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (cci_clk_rate != cci->data->cci_clk_rate) {
-		/* cci clock set by the bootloader or via assigned clock rate
-		 * in DT.
-		 */
-		dev_warn(dev, "Found %lu cci clk rate while %lu was expected\n",
-			 cci_clk_rate, cci->data->cci_clk_rate);
-	}
-
 	ret = cci_enable_clocks(cci);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



