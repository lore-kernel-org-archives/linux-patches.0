Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051475;
	b=1Oqk58JjsEjrKi3kxp2LwH7G29At2iBnqudpX48MckthvjP1JfCN4AW09ATd3zuuXSrq
	 NTHIlUjJfAwEA1393tpRANhJCkZONcnDNP3HbH9+PPHiksQzAhV6kTWe50tY104yFvFi0
	 7C9mjBxVTZ8MC835e0NrPBSp0ZSoCEMwooLw8NldgLCLiIG+jIY9GLwBGlklwHWZXZ4Xc
	 WSsXXxBRw2qGmbRfYXpj6x7YgIwt2ULO+iy3WnXQMesSLPv7DouHXShGbJ7tQOHfl+0g6
	 QM3T63czRsbNGZX5nhSdtN0VTry8990FdGhbZRnRu7KBdTnBh6ZD8o1pWeo/h+dQ7LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ErGfwk85w3YmiEt67Ed5REmset8Wvvoinqmws0NCV18=;
	b=UqDMqMtXI0DAUDG6Yqlb9f5h2uRA9T4G8PrUr/wsaFzgs9x+iIuPTm8QCdUAQDLWQDvU
	 Y3/i0vttXBSP30uRzZtWz2+5e1vRF+ERANFHRB8oqZQ6x4o8L+eCL8hCTCStwbmdTDN6k
	 YOrgDPeaaPGumMvHMgikKQTrcOY2lTr2Zewlod84/yrB1qDODNYxl0EpfLiIMkkGBOy4+
	 w6NERD8RfNPR+HEPKVdhsZjqVHs6wPdJkU061V7AsVlHhe8qt0GOibtQIkxyOCNOFeOIE
	 5Tlzm4a+wU0I8ejBI8gAm0YL6fx4A7Anpx5eEpRBBNuYo0Gww3Ueq9EoqO/Zw2ioEiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9P5CwY2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A110606A32A;
	Thu, 19 Nov 2026 01:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9P5CwY2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A461F000C5;
	Thu, 19 Nov 2026 01:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051474;
	bh=ErGfwk85w3YmiEt67Ed5REmset8Wvvoinqmws0NCV18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9P5CwY2gQDcWcQpY8xL6MkTmqvZBPQVK2hgGdJM3EysR/j7jCuKS05XSyZM2Yci/
	 t/TwQby8mVe8a+6FniNr4BrMYj2Gh74xuavp4XKG1gb9+KKlhhNRqLMxpAtg2O/j6u
	 875JGJJOp3pzTWjQTL+bHaNRtCUOTIMySlU9yHbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0222/2214] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:31:38 +0100
Message-ID: <20261118150019.128368251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 31c264100d781..81222335a3dc0 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -566,6 +566,7 @@ static const struct i2c_device_id abeoz9_id[] = {
 	{ "abeoz9", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, abeoz9_id);
 
 static struct i2c_driver abeoz9_driver = {
 	.driver = {
-- 
2.53.0



