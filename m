Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061424;
	b=uuZD2lDf1GbTRgL442P1DKwysY2NOdUXYYvn9DuCF+TDPUYF8DhNF1sRFxiVxkdTi7ka
	 P3SE8WDVua8yR4F3JRp8AcOG47ARfpy+Vnt/ysCKzFicSfO2thhXznuDjpjd6x597sWbs
	 dgxBPdbFZdgxDrk95WJ9kf6Q/LMgGRVivaA8Jv7ckiRtyUQLA0elIf0lO7X2zOevVsET4
	 hatffQuh00313Xsmav0uXRnl0dPjIicyJf65VnKm0FHGcnhnhpTleUXgOS+UaLCmc9mRu
	 kQXfCyKacBrjyNXNxpCfu5hW/NRurBtd0S69rtSGSslRo2kpbk/cjTlbeAzC4xIG4pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Zv8C2xoyqlaQJMlP2OIaODP5xUrkPc+aOmPCWEeRvY=;
	b=CWibTFcu4VXkYaWf5aJnPu2HUC9DC9OMAlPYZ9sgb4LSAqgRSDLqVFc0mIWDSYpSMPpt
	 EYOSlZEu7RAF1xe8ZlSYHjRLLRtsLHFH4YK3dS4i6iiyDFwY0MNm6scVYBWxgTLZc/FeU
	 Ut1P/BXVjWgDwxSFyCnZ+gFkO6rpSsidWWwLZutwAbg+4Dnn+OJdRNd+UQfPxegkWRXJu
	 KELZw9u4IBfIfxegMW9abu73oy+CPnZ4XDuEiLZTZAkET7Wy6ZuLEs9S3rxVKNbdhRVGL
	 3nSY2hWBdD/w+BO9iZRKYHeyONxsrpJR1uG/d3tq9jyDYz0KazpAQLkKWUvnD26sfCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5xouKnk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A993F606A32F;
	Sat,  7 Nov 2026 14:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5xouKnk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C4D1F0089F;
	Sat,  7 Nov 2026 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061423;
	bh=4Zv8C2xoyqlaQJMlP2OIaODP5xUrkPc+aOmPCWEeRvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5xouKnkLW9slQkDimfFtiMPfxFRZeURJNb4i2sYuhB8tzER69aN0Dcixj/76rpKx
	 QJJjKTKSYvsxhRfwdagj2kYh6VSGjpaYdw+c9qKhyp9A7ndEiDNyg2Te+DbXilnVQc
	 ZG62fU6724ZTLh9Ygttwc/N8tdeXymxGlYN3Ebk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0498/1536] i2c: qcom-cci: fix autosuspend cleanup
Date: Sat,  7 Nov 2026 08:41:54 -0500
Message-ID: <20261107135011.444187676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f98d4986482151a835b521a734722fe8dc5ca37d ]

cci_probe() calls pm_runtime_use_autosuspend(), but the remove path
does not call the matching pm_runtime_dont_use_autosuspend() before
disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without undoing the autosuspend setting during
teardown, this reference is not dropped and usage_count remains
unbalanced.

Use devm_pm_runtime_set_active_enabled() to manage the runtime PM
state. Its managed cleanup disables autosuspend and runtime PM and
restores the suspended state on probe failure and driver removal.
Remove the now redundant manual runtime PM cleanup.

This issue was found by manual code inspection.

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260812094425.3515179-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index f1fafa426ca90..599785cba1d56 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -625,9 +625,11 @@ static int cci_probe(struct platform_device *pdev)
 	cci_init(cci);
 
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
+	ret = devm_pm_runtime_set_active_enabled(dev);
+	if (ret)
+		goto disable_clocks;
+
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
 
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (!cci->master[i].cci)
@@ -641,8 +643,6 @@ static int cci_probe(struct platform_device *pdev)
 	return 0;
 
 error_i2c:
-	pm_runtime_disable(dev);
-	pm_runtime_dont_use_autosuspend(dev);
 
 	for (--i ; i >= 0; i--) {
 		if (cci->master[i].cci)
@@ -665,9 +665,6 @@ static void cci_remove(struct platform_device *pdev)
 			cci_halt(cci, i);
 		}
 	}
-
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 }
 
 static const struct cci_data cci_v1_data = {
-- 
2.53.0



