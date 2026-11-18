Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034725;
	b=R28V5KxSSt1uc3khbHf95hBJkeiH9fD9heu1Uh/hM/wMk7VDXAA5RBPUISikTqV1gOkv
	 4E9LAvcLIqCNgCIjb5vO7ThB3vMVc8cvvozyfynHjR7xPV2QZtpDtbvjDDvKeHoR3ImwH
	 a5pDRxIHeuUWZw/DAX1dgnstL68DbUW/E16PsjCjjL1WdlXc7I7Da6cpkGOtfcQ6P51AL
	 Ehze4pbnC4GkxA0SsnHyk5tQk6Qz+BhxVGmI1sRgKl5C/AeUDlzUCKlhCIxVROXEEo6z8
	 +q2t9skkOM5yZA+hO4Vl7P9n5uaSr64LkUhaTj1OTNfz5VJAv4YspGA1RJFegF7VkkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GDM36imokqSrUtAKMTmGv1cFoZqZSlozoTf4oAdC5So=;
	b=XXlE8owrxxh/WSfmIxLu8bHZzhOjn/H4G8uAGxXvL1+1oRhYgQDvh7i8sVeBxiDzs7XI
	 4DweuOPk2YVr2HFH3RuVUfkKZTZND1GNMm9gK3asPsB+bY/+lwR1kfZg29ZH7tWkicUc3
	 SVrbfsVWV2cFczmlG3qeZ5/bD/S5Vktl/R7+iqo+t2tiKkGicSKBtUvLKqRRLwow6aaa4
	 6IhELspFiXCWPCdXXsBVZAigL/ECn+dvKuNy4BFBdvju7yeqLOcVCGkp3VwqVauv2ys8d
	 yNAmTlIiNPcx8yL+R17HF87V4j9Dm1CBMAg/CuT6jK2OyNFHK8b1SZM3eeO1TBlAddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=029DkBE4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF7D606A32A;
	Wed, 18 Nov 2026 20:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=029DkBE4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7EF1F000C4;
	Wed, 18 Nov 2026 20:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034725;
	bh=GDM36imokqSrUtAKMTmGv1cFoZqZSlozoTf4oAdC5So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=029DkBE48qEaKYW5jXtUJ5SUcxguMIKcV4TM97FWxNBRsBBd78LI+rCIz6MtroUDd
	 FIhmGBdkMsVgAZYud+t/7cdD5okpcStgLD/duN6YmbwkwDP03aWKCHcWzE0vtr0dJQ
	 G7OH2jaa9fgwdcyOyYcEBHWrEZribOzxaOXhEPJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0434/3318] i2c: qcom-cci: Remove overcautious disable_irq() calls
Date: Wed, 18 Nov 2026 15:17:36 +0100
Message-ID: <20261118150329.675816178@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit f0285c286bca5a1e018ba25040cef6c7806c31ef ]

In cci_probe() the controller's interrupt is requested using a devres
managed API, and in cci_probe() error path and cci_remove() it'd be
safe to rely on devres mechanism to free and shutdown the interrupt,
thus explicit disable_irq() calls can be removed as unnecessary ones.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260515234121.1607425-5-vladimir.zapolskiy@linaro.org
Stable-dep-of: f98d49864821 ("i2c: qcom-cci: fix autosuspend cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index e5dacc6677b01..cd2fe0cb77bdd 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -630,7 +630,7 @@ static int cci_probe(struct platform_device *pdev)
 
 	ret = cci_reset(cci);
 	if (ret < 0)
-		goto error;
+		goto disable_clocks;
 
 	cci_init(cci);
 
@@ -662,8 +662,6 @@ static int cci_probe(struct platform_device *pdev)
 			of_node_put(cci->master[i].adap.dev.of_node);
 		}
 	}
-error:
-	disable_irq(cci->irq);
 disable_clocks:
 	cci_disable_clocks(cci);
 
@@ -683,7 +681,6 @@ static void cci_remove(struct platform_device *pdev)
 		}
 	}
 
-	disable_irq(cci->irq);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 }
-- 
2.53.0



