Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057691;
	b=NpdAtXdjA7nyj4S0huQiQmtTxD5sKm6nY7nmyy6vFg2JVxqMmH/2E7EogjkKM+wiZ49Z
	 PaRHVJiRtrcd/Fi60DlF38Tx8Ri1v8GYoOLL8yNeAD49bAiwfKPtSs2ZaGJH80uk9kSMN
	 o6u6vv1LLp33bToiUfW87MxRzppGgzNznkUlJrzkl+tpu2+S8mu2nm7JH3OIepJDm9TG2
	 RQHv0CLnVGR6mPUOB8zK6TTl2HnfpgBY/Sz4fVbnrwIjxkkWBzQWnE/z+7J4LgwxG/BwK
	 tv2bOzV5HnSCtjE1MW24uOxPvz3Z36xRcfV3s7tWbO3sUTJDUWlUAAmzTct1iPaMjKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29qz4RGlVTLCXU2Z7NOulxFcyBX73odRxClVQDxASj0=;
	b=nhMV31AhKrrOoHX0FLKtvR/HCmVkNoGPkRt3fcvzEXcZT7tVb0EVv3luMzukEuo7m9rB
	 tDV52ZlHoF+4ks5j5T42hZg4wLdLvmeE4N056bGw20Ypb2KpmSCmUQIcpELqMBEyHVRY2
	 O0tqLypK2RR0lqPrXbfStI/Xbdu2zlZX6EkAgEeZL7mRfcfogG/HnJ1z5rNGnO3kDUoVg
	 tMwxgH3ElnuWWY+3aakmIBmhhTPOAnAJ1XQV+FyhRvcftrXLJ8mj32CWW4l2EADKlUUTF
	 MCqlmB1KULp3tQI28xwqZb8YEJ7/QgBQNs3FzJmXdiLrSNiUc7pId04+SPwuVCpiUag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J68vlWX1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1618F606A320;
	Thu, 19 Nov 2026 03:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J68vlWX1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B621F000C5;
	Thu, 19 Nov 2026 03:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057690;
	bh=29qz4RGlVTLCXU2Z7NOulxFcyBX73odRxClVQDxASj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J68vlWX1x+zSayaLJZYzxcqed3+O4CqCUbQP4Sj1AV3tIAXArvZTRA9HlboX0DI0G
	 3sDeDM2RM2otG033LHGQBFWRVPJn8wYX8c4OSR0wiZciIsjVNFJ43W/6k5JarSODwd
	 KbPTPBdHj4PqmMnLXN3YB7TifVfSaoKSi32uRRPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0180/1848] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:36:58 +0100
Message-ID: <20261118145919.041605740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7490b8356e52e09c196645912f2c054f79aa5f3a ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152528.53258-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ab-eoz9.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-ab-eoz9.c b/drivers/rtc/rtc-ab-eoz9.c
index 1d6a626fdf933..e19197562c7db 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -433,6 +433,7 @@ static const struct i2c_device_id abeoz9_id[] = {
 	{ "abeoz9", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, abeoz9_id);
 
 static struct i2c_driver abeoz9_driver = {
 	.driver = {
-- 
2.53.0



