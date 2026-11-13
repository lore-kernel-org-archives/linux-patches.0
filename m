Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591148;
	b=Q4h0hCC6CmAlQE1Ec2mjjPxbkAKwYrrVbPrMqTO5xkyBPYp8vhL0rT/qy2+LzCsd/XnM
	 8w9QwyCgnFk4BhL6vNK5IA5ibvhRCQt7PeJA3caEGSN9a2EFrLt/8ecj5fQ0ZuD2HxTDE
	 7ArECiyEFIvIF3mfEnk/Ut9a5P9QTEmOJ9gEx8dG08qFr7gVUpEvb7++lfbIiwraKvUK4
	 uX/QIizApkbwtevzkhHExD0Q4LrMvo2MI/V/5ko56gakfP6tXSwxNCTu3PmLTTreyJ+Gu
	 2Ht5nM1d2JnUKSl2RPhYHdUmxD6jmAKeKJTUkusCWBE6C0RsX1ezpjyT6xCo452iSfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ithLnEXMtoGgi7ey8QE2MhynH1iFLJwsoqGmkLivt4A=;
	b=b8Ym4ninUbv/r3Llk79SWEMEF40eYjnqbH9hPAkc/zBxj5N/ExdZoNetans9llLyNr8U
	 NJYvBrEAmdAeuzb69wSlx3CZEkgH+2MUABWcRgSFLhHaheJmLnK17eLY5e3KXVSvzMyfK
	 WfsegUkEWjvlO+DolMMRXoYcesJNrWraQY85N2OMLlRaICcLaGPi/5y7szXTQY/E9kKGW
	 pPqRw5WQDezMMmVQRPVeYlgrhlr8bNOKDPD/HCY+WEmJ4k9wafA2kPqhhkCicPRsDFF+a
	 vup+18g+0nUMPHDwY3VTvq/Oj50lpRdG9BTGGQKP2nK/2GkBL4lJDQNnGfdeY/otUGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltdHds3c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37FF6084366;
	Fri, 13 Nov 2026 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltdHds3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705021F000C4;
	Fri, 13 Nov 2026 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591148;
	bh=ithLnEXMtoGgi7ey8QE2MhynH1iFLJwsoqGmkLivt4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltdHds3c0jujxizaZBX57E5VSofR14FQaF41jdL7psAnArw6efjEGgQi3LqEGRwqO
	 F6wFAEAUb93RDCJGsFKOO+QEIkHoNAM2ah9EwRWa3f/NuL9oHeKuJv/eVyyaNkTnTF
	 wxCggbz0VLh/IvSE1Sur8QQyg+lVyQaTwzMsYYOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/670] hwmon: chipcap2: balance regulator state
Date: Fri, 13 Nov 2026 10:46:55 -0500
Message-ID: <20261113153820.341142314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index cabafbe7ad4ab..aecd320e93d1a 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -88,6 +88,7 @@ struct cc2_data {
 	int irq_low;
 	int irq_high;
 	bool process_irqs;
+	bool regulator_enabled;
 };
 
 /* %RH as a per cent mille from a register value */
@@ -117,7 +118,7 @@ static int cc2_enable(struct cc2_data *data)
 	int ret;
 
 	/* exclusive regulator, check in case a disable failed */
-	if (regulator_is_enabled(data->regulator)) {
+	if (data->regulator_enabled) {
 		data->process_irqs = true;
 		return 0;
 	}
@@ -129,6 +130,8 @@ static int cc2_enable(struct cc2_data *data)
 	if (ret < 0)
 		return ret;
 
+	data->regulator_enabled = true;
+
 	usleep_range(CC2_STARTUP_TIME_US, CC2_STARTUP_TIME_US + 125);
 
 	data->process_irqs = true;
@@ -144,11 +147,16 @@ static void cc2_disable(struct cc2_data *data)
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
 
 static int cc2_cmd_response_diagnostic(struct device *dev, u8 status)
-- 
2.53.0



