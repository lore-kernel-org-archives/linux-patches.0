Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585542;
	b=jJ7WuiCr/EbVzcQrK2itW+DkpBpHiIG3fTsPCEjZ/CXuyZjTv7kQ4w+hZvarF0DoL0uY
	 xl92uDGki+0nIicqHBl7AuRT9E4V6TZm4fpnDsJ1fTQk71AOSH9VHRwgt0hMh/dyd6IRX
	 rWAkHIoAbi5xInzhRMvecXm82VPXWTKWgZ3TY3zqaEWpSRPXX622ENSBePCFwvRj67h++
	 E3uVZuweJmwQ5AipliOXgkgFGcWZ6WHkLfILbG1TYcMktzCPGzYUanuJdkP4gKFcUDM3u
	 NXWzrfHeKmmvpX//9xCnRk/Dac2Zyp6Ct/K9+lh5lgAIljPA8ZntKHEBaIqJsIUTc0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=94YWS1MQAF+QCpChYbT7N9FrBb8+3cqAG6ydLFtnd+4=;
	b=gqt7t1VNXCJCywgCLhKWpoL83GcrOAHYeyYXLFhRaohPWuPNA+RUeIEoTl1XAnv5qvDZ
	 ibW/m6kkq/oVM8KWKr4J5BrgSjtJyqua6bOpqDUFHvj/kgEWfjuOuQd8JoGO37sISiq6+
	 AtXPykNqH72ZrwBqpCzxuO/aBUlbCw6xJAJxTI1EitU+aJA/ImFPwGTsynyKXFxtFC5cQ
	 YLVE9RVb2r090eRNfBf6QxkLxTnIEHP08twZTYNMy8QDaM2q/GOkl9VB0GxGcsAKNglxa
	 j/MqZaOimySz/0NMUqUH7u4UAfVhtTsBhXISGF+pxb90ejMYjGxJ6bkottvmN4y0JdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIRMlXKq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCF5606A883;
	Fri, 13 Nov 2026 15:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIRMlXKq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC1F1F000C6;
	Fri, 13 Nov 2026 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585542;
	bh=94YWS1MQAF+QCpChYbT7N9FrBb8+3cqAG6ydLFtnd+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIRMlXKqznW9HLfAaAqnq05tAPhPpjGSumUC+a9XSwtKogFiL+IbBP+RrzDnnV/ZB
	 MqsV19RXieNphpblTQJy4UX2y8pabEIwjEbXSJ9UXPQR8ifZUeX3J+MSks2xkBqAOt
	 abKo8golNCgPdRuXB/ZTEibYZLBU/yq5aC8m8th8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 180/507] hwmon: chipcap2: balance regulator state
Date: Fri, 13 Nov 2026 10:48:04 -0500
Message-ID: <20261113153800.579132283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 378add65fd7d352de9fe440d167fde5bf511b090 ]

The current implementation does not guarantee that the calls to
regulator_enable() and regulator_disable() are balanced.
regulator_is_enabled() might return a negative value, and an always-on
attribute in the DT might break the symmetry anyway.

Add a regulator_enabled flag to keep balance within this regulator
consumer.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-8-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 837b1830f2e4e..952789fdb9db6 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -91,6 +91,7 @@ struct cc2_data {
 	int irq_low;
 	int irq_high;
 	bool process_irqs;
+	bool regulator_enabled;
 };
 
 /* %RH as a per cent mille from a register value */
@@ -120,7 +121,7 @@ static int cc2_enable(struct cc2_data *data)
 	int ret;
 
 	/* exclusive regulator, check in case a disable failed */
-	if (regulator_is_enabled(data->regulator)) {
+	if (data->regulator_enabled) {
 		data->process_irqs = true;
 		return 0;
 	}
@@ -132,6 +133,8 @@ static int cc2_enable(struct cc2_data *data)
 	if (ret < 0)
 		return ret;
 
+	data->regulator_enabled = true;
+
 	usleep_range(CC2_STARTUP_TIME_US, CC2_STARTUP_TIME_US + 125);
 
 	data->process_irqs = true;
@@ -147,11 +150,16 @@ static void cc2_disable(struct cc2_data *data)
 	data->process_irqs = false;
 
 	/* exclusive regulator, check in case an enable failed */
-	if (regulator_is_enabled(data->regulator)) {
-		err = regulator_disable(data->regulator);
-		if (err)
-			dev_dbg(&data->client->dev, "Failed to disable device");
+	if (!data->regulator_enabled)
+		return;
+
+	err = regulator_disable(data->regulator);
+	if (err) {
+		dev_dbg(&data->client->dev, "Failed to disable device");
+		return;
 	}
+
+	data->regulator_enabled = false;
 }
 
 static void cc2_disable_action(void *data)
-- 
2.53.0



