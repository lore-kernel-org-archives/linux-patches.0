Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019697;
	b=LbN5ITSFPbFEdGlZ3dqvu1Y2bxWhmPNf3fTQNCS22MzAmd5qtZL9uDOURXog4+6TGkZg
	 /uFKDXwmgonw575zqVreoImb9q5lXujbgko6LYNLqpMumkMoYbeNZaxfPXsL9rhrIqMHV
	 +rl1ORMQOTeD4X/np4umcSbxH8edsTuNAOoE8Qie5IcctdyPhsfbWAQPrAdfI0odn+6ad
	 ey841wWytRh71c+nSHiz80rV8n2y3/ri8GUW1FJI+NQshJbHMM0FsAzcmHlhjnHUHQ2Pu
	 36OaF+iXp7MOG5U7t4ZpUivoa/0AL5sEZY68vlBN31zo9THbEHd4oYU+Mqh7vEf83XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LQgir0b4Vl/WbtH6lDsCdTNRhwTXP2Xd4P/ax154Kgc=;
	b=chF8fl/5aG5IR9xwSIzC2yG7wC5//iMyOwUIKnTl0RScM2PD4PiVzJPoc7qqaRiorjWL
	 SKSw62CVeeJxFnsqQi5c/wY/ZX5dA8/WnoLUWPtKVicVhXWxcLMKMCzbwBH0MtVkhW8is
	 zGtv1HdjQiNGpHKi3wyHapHbNy6WCstzkyPk17bIjSYOa4gQMB+sSEKI/IaiZXxvWAXNQ
	 265nsDKO447ZDTz4DJBKFQUZp5LH8GWi5Alo8RzQGRThjNA9pwcuOocPkmSijChqyic55
	 JKZNGJrQyxyHwPsOHL61h0RayIoecSSXkZmWz8cEm+2vlRssvKkegcuESi1JqWBtK8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVpwOc9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F55F606A335;
	Wed, 18 Nov 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVpwOc9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6851E1F000C4;
	Wed, 18 Nov 2026 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019696;
	bh=LQgir0b4Vl/WbtH6lDsCdTNRhwTXP2Xd4P/ax154Kgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVpwOc9bCYexjsh0Lob+xV/79R9/hIPlItGbxjsDY50Dii+as83MO/ytCmOj+lE/I
	 zb87okw858ZXMrxWLJCaVc07P9Nk7eLVdeFCrW6fFq2Em3k28uJGb320gH2+Fi7+F+
	 xruY6NRKRe/sjh5XWYJncEurFH6hLkejPSnRJCsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nir Yehoshua <nir@ciphersecuritylabs.com>,
	Ahmed Yaseen <yaseen@ghoul.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1687/2651] platform/x86: asus-wmi: validate custom fan curves on enable
Date: Wed, 18 Nov 2026 15:48:47 +0100
Message-ID: <20261118150348.412827846@linuxfoundation.org>
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

From: Ahmed Yaseen <yaseen@ghoul.dev>

[ Upstream commit bcbdfe03566ad0d01c6af3b5476e8cadffe4d3df ]

Custom fan curves reach firmware unchecked, so a curve whose temperature
or PWM decreases from one point to the next is accepted. The firmware
does not respect such a curve: a first point of 100% followed by 50%
leaves every point running at 100%. The kernel keeps reporting the
points that were written, so sysfs stops describing what the fans are
actually doing.

Check the curve when enabling and reject it if it is invalid. Validation
is done on enable rather than on write because fan curves are written
one point at a time and are inconsistent mid-write.

Fixes: 0f0ac158d28f ("platform/x86: asus-wmi: Add support for custom fan curves")
Reported-by: Nir Yehoshua <nir@ciphersecuritylabs.com>
Signed-off-by: Ahmed Yaseen <yaseen@ghoul.dev>
Link: https://patch.msgid.link/20260831-fan-curve-validation-v2-1-7274ca16c8fe@ghoul.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index e4f8636f64623..53d694bffc618 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3739,6 +3739,33 @@ static int fan_curve_write(struct asus_wmi *asus,
 					 arg1, arg2, arg3, arg4, &ret);
 }
 
+/*
+ * A fan curve is a set of points the firmware interpolates between, so it
+ * only makes sense if neither temperature nor PWM ever decreases along it.
+ */
+static int fan_curve_validate(struct device *dev, struct fan_curve_data *data)
+{
+	u8 *percents = data->percents;
+	u8 *temps = data->temps;
+	int i;
+
+	for (i = 1; i < FAN_CURVE_POINTS; i++) {
+		if (temps[i] < temps[i - 1]) {
+			dev_warn(dev, "fan curve: temperature decreases at point %d (%u < %u)\n",
+				 i, temps[i], temps[i - 1]);
+			return -EINVAL;
+		}
+
+		if (percents[i] < percents[i - 1]) {
+			dev_warn(dev, "fan curve: pwm decreases at point %d (%u < %u)\n",
+				 i, percents[i], percents[i - 1]);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static ssize_t fan_curve_store(struct device *dev,
 			       struct device_attribute *attr, const char *buf,
 			       size_t count)
@@ -3823,6 +3850,11 @@ static ssize_t fan_curve_enable_store(struct device *dev,
 	}
 
 	if (data->enabled) {
+		err = fan_curve_validate(dev, data);
+		if (err) {
+			data->enabled = false;
+			return err;
+		}
 		err = fan_curve_write(asus, data);
 		if (err)
 			return err;
-- 
2.53.0



