Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061099;
	b=BHhjFq6PhVki2/7mFJ2HM/Po1fduX4NFSWBxvAzDFzT2omcOjvqzaBdbI2kPQYmbCLvJ
	 4a4BUoUW9BndrlyzVe1p643aXT8hxXJKPcxF9vXNLJEThSTgEYiwmHyt5rP3FWubBTBV2
	 vDaemB4rlGmIdq1eeIeo4IrVrsb3lBP+1dPL8FKObdWyOmRadEr7A76hriX1sQIdZEYD3
	 Q0sBSaZ4zGLjyk2Q1KytBIz/S59/DyWXLLbMNeFeVhhuCBMnLWyUXzZJLpYyunbejzbK/
	 fMXf8WeeeONFc6mgiClVBHiMzZRtxazOCklCf0ZcMCq/gWVxpF69xTjP9ANH1+klS4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=03iKMbvikphZXGA4rV3s4GGQBc8xhqxR3/Z9x8MJyV8=;
	b=2RsLNiXPa4uBd/38s4WZdvHlipKBLSdGP1LTDyYmQSrB42XZzWu8jc8TzOE+yHnB+B7b
	 6krhpr0eyfheUQfW3AtE5TBVJ/W4cZYrqs5brx7Uw9f7uqx7wrmnojeHPlFPwwZMd7nmm
	 VClresNqfZ7wZYyQe/IwzayLkChMuQQzaks1iENI7qOwebd4j/nzxgLrGEr8R4IeiaNku
	 gUN1uCHJbJLJkjZt49ILQZtj7wk6IfYMc+n6O90HV5jA82s4cOFh0/GCpe4lrhsTR3pDK
	 cZeVavXupnfRkdljabEJ7UghXhVCkTcRNG4lWzkTnIe3JR5OMS+vAwSOKUD4VJJJOWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuaEqrAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE5C606D837;
	Sat,  7 Nov 2026 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuaEqrAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FA81F008A1;
	Sat,  7 Nov 2026 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061098;
	bh=03iKMbvikphZXGA4rV3s4GGQBc8xhqxR3/Z9x8MJyV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuaEqrAcPHJ3M83Sg69Js3YQoRgjBFumx+S0TnELHZrNY2qNDrRe0KXrjFjdqCR0Y
	 R7xcihn7oxqzXPx3xqo8OmPSc/og6ddCFcQ7QpwJQcSpmDbbM6FmAXpCgJAmihsGWj
	 p54X9PUkBUvO8zEr/XLBPX8RPux9RQ/JikzeZRlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0369/1536] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:39:45 -0500
Message-ID: <20261107135008.013718135@linuxfoundation.org>
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
index e17bce9a27468..2d7b7535ea520 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -571,6 +571,7 @@ static const struct i2c_device_id abeoz9_id[] = {
 	{ "abeoz9" },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, abeoz9_id);
 
 static struct i2c_driver abeoz9_driver = {
 	.driver = {
-- 
2.53.0



