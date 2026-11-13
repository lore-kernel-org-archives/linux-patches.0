Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590341;
	b=1rCd4HtKRUnpfhn3FmP5xYN/wjwM6e55bXvvyF4s0jgD60TEyWbpMbZdoVpO+xi9iedC
	 pFq9rLENzsr3JgDEhW9FykvW2U3B7nJJIr9EWcqiT+pgM4dicgbWtQCqlno+SCGRTsN0p
	 4vcbo/TSOI1Qp9Aa9B/1LclbxtVn3bVUmvEl3do5BFi3XTnURSt+mcKnM2sc2bktvAI8q
	 ouLARyMlz/uTz3MrqyGsqm6SrJFdfYYTTHCrMc9aacqP7alOruqA9SaTCXXmuD2obAoWO
	 QmDlf1NAiwZnkpSgQxpTbk0iWPVULNUKLrcZBFkQUaUk69F+ZKAOEcInvELTSz8uihA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FmF0G80KGkWSSvG67ZaelCGM08wFUWlZS3Mt2VQCRF4=;
	b=Dt1Cn/0/QJGoNudbWIX+kP8D9Yq1l/n/HuHAgDobDdNPF3MwfREmNt8OTppxm0oc+ghV
	 fNCPTpGH02hReC9q0gsM+mx7DfzJlmAWxx2DSMITkYPzsP/KmBDqUBLNNnkgui49oX37A
	 tOoexkC9oqxIrqeG4zHxgTBO3gIdvFnSlRJNl6N7FUtDausqBID3bwJeZTumKhVpy3AxU
	 9HjCxpJrp9NF/rUqiI/PiyqV0UNhS2RGuY8tF55Unfj9eXltbiKnR4TYj0AQ7vu8ZIqlN
	 LO65lcFbHYhM7VS+HRrkN1y7vUvgfU/itZbNie9ox6LWv5l3+obuyxegepQOI+/z1KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=simK+pcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C61606D4B5;
	Fri, 13 Nov 2026 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=simK+pcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FD81F000C4;
	Fri, 13 Nov 2026 17:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590341;
	bh=FmF0G80KGkWSSvG67ZaelCGM08wFUWlZS3Mt2VQCRF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=simK+pcvdgx08COyI2hCnVMLZyD0XyjQEidxl3+j5vnp4J/AscUw4++XdfeBY+OiC
	 BaDqZLmr9SHmYFxGRLVZOxHlGlI1H9dBLzFnC1NZOg4o84cE1Oo1S/sk2e/aZ7zT+q
	 fcc/aPwFPAoG6F3Ra4z6L1V1Ea6wQ9D2i/0CGa/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/686] hwmon: chipcap2: balance regulator state
Date: Fri, 13 Nov 2026 10:46:50 -0500
Message-ID: <20261113153830.384570615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 632efe64f190a..3e8218a7ff2ad 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -89,6 +89,7 @@ struct cc2_data {
 	int irq_low;
 	int irq_high;
 	bool process_irqs;
+	bool regulator_enabled;
 };
 
 /* %RH as a per cent mille from a register value */
@@ -118,7 +119,7 @@ static int cc2_enable(struct cc2_data *data)
 	int ret;
 
 	/* exclusive regulator, check in case a disable failed */
-	if (regulator_is_enabled(data->regulator)) {
+	if (data->regulator_enabled) {
 		data->process_irqs = true;
 		return 0;
 	}
@@ -130,6 +131,8 @@ static int cc2_enable(struct cc2_data *data)
 	if (ret < 0)
 		return ret;
 
+	data->regulator_enabled = true;
+
 	usleep_range(CC2_STARTUP_TIME_US, CC2_STARTUP_TIME_US + 125);
 
 	data->process_irqs = true;
@@ -145,11 +148,16 @@ static void cc2_disable(struct cc2_data *data)
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



