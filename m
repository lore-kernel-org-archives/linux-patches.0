Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019722;
	b=HzXkaPto88O+0N5dC0dt6Osrxg7b+SXZnbKAcq0Cfv2VWYAmLib0YjqMjdV910VyFKcc
	 PLCHvhD9z7LPuOowf1dEHHo54uySnFMcjDYapZm6q8CcTH8V6fROSYvQ7/vizWXjt4wHk
	 hbfgf0d7QuVYWceUmbKHDiRutpNIsseJDcRlmkwLLg9lwxohVn+8X5L45HuqwYKTe0tS4
	 uqVXGTILnSFyf3TSHFY8SyQBvzS3Z1hFSIAMi2Vk4Rgnpqw5ScYY/pxg+VRFWYvrEn83z
	 DFvCFgKb8dGKHJ1hLZoS9wrmW9AnUXeDd/I9GLx/YIHZmBbjxZ8obWw8e0VTPdd/7Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lNMX7ZIxStMLbWAvJce28LM5ZJvGE6+1yGQ7jz7vdws=;
	b=kiSWePWjqC+2M4j8l8rdgg2GJDOPrP29A1Tdcu4Rsszi2+uUadmZhjc8DXILGoiUBWLr
	 yb6aLAv1nb0VYxTlx8w5BT6lMxtkzx+pldOQvX3lzAOTcw7s1Tn1AUsMPxDvUd4zrQiGq
	 QzN6cfCFyJ69mzNUsoMt13GxEfrPbbNPrxUkrU6KNfjZco+iLdFqD29rjvPKUR3Ju+5Dm
	 Qe4eCDwe3kjc/I4nOljm57bLuTwzLtKI/RQlRQErgwvmigFemgxoXUyk9kTZ4TrmBYr5x
	 sy85pXHU0/nTkdsQCeBcBSc0Jz8Q+JyqUPA/EkdFJLRijc7L6F7VdIn9v/u/B0kTNXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNOVlOiD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0241B606A31C;
	Wed, 18 Nov 2026 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNOVlOiD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A04E1F000C4;
	Wed, 18 Nov 2026 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019721;
	bh=lNMX7ZIxStMLbWAvJce28LM5ZJvGE6+1yGQ7jz7vdws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNOVlOiDyvSlWlYnkcfm0ofHkVQ4rE+0lYbbbYKvwksRLnA91lrTzfIzf3y/dzXCO
	 Mm6bko/vj87lnmDRAbLwoXZzqx5XoZHFsHHkOmBpB+1OD479MEQaHEyvgFn2yCZ6OB
	 eV9WNtMtz4GGNa2bWkmzWJOHrL1ySosX9kVrelrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anvesh Jain P <anvesh.p@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1696/2651] platform: arm64: qcom-hamoa-ec: Disable the SCI IRQ during suspend
Date: Wed, 18 Nov 2026 15:48:56 +0100
Message-ID: <20261118150348.722407442@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit d21c5d267ec0ccae7e629286d3ef51224494267c ]

EC SCI events require I2C transfers to retrieve the event information.
During system resume, an SCI interrupt can be delivered before the I2C
controller is ready to handle transfers, resulting in failed event reads:

  geni_i2c a84000.i2c: error turning SE resources:-13
  qcom-hamoa-ec 3-0076: Failed to read EC SCI Event: -13

Keep SCI interrupt handling disabled across system sleep so that EC
events are processed only while the I2C controller is available. This
prevents event reads from racing with the controller's suspend and
resume transitions.

Fixes: 5c44f48e91de ("platform: arm64: Add driver for EC found on Qualcomm reference devices")
Reviewed-by: Anvesh Jain P <anvesh.p@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20261001-qcom-hamoa-ec-suspend-irq-v2-1-ec71a7cdec79@oss.qualcomm.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/arm64/qcom-hamoa-ec.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/arm64/qcom-hamoa-ec.c b/drivers/platform/arm64/qcom-hamoa-ec.c
index 4d2ad042a7f84..d34afd901324d 100644
--- a/drivers/platform/arm64/qcom-hamoa-ec.c
+++ b/drivers/platform/arm64/qcom-hamoa-ec.c
@@ -331,17 +331,28 @@ static const struct thermal_cooling_device_ops qcom_ec_thermal_ops = {
 static int qcom_ec_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, EC_MODERN_STANDBY_CMD,
+				      EC_MODERN_STANDBY_EXIT);
+	enable_irq(client->irq);
 
-	return i2c_smbus_write_byte_data(client, EC_MODERN_STANDBY_CMD,
-					 EC_MODERN_STANDBY_EXIT);
+	return ret;
 }
 
 static int qcom_ec_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	int ret;
+
+	/* Keep SCI reads from racing the I2C controller's system sleep. */
+	disable_irq(client->irq);
+	ret = i2c_smbus_write_byte_data(client, EC_MODERN_STANDBY_CMD,
+				      EC_MODERN_STANDBY_ENTER);
+	if (ret)
+		enable_irq(client->irq);
 
-	return i2c_smbus_write_byte_data(client, EC_MODERN_STANDBY_CMD,
-					 EC_MODERN_STANDBY_ENTER);
+	return ret;
 }
 
 static int qcom_ec_probe(struct i2c_client *client)
-- 
2.53.0



