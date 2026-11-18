Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041416;
	b=D38MdIF6YHeS0eWMq8jBZixBowCDUpsIIGoDBDmeyII/DrGoePkI6x337HPqT97I9lcg
	 K1mqtB4fS+O/ztax7E5kJXlaS+LDOBxoDupbw3j2ek04l+4nSDEGpm8ZpWgoXCCnYAI+Q
	 rFF0yqO+Gp2WaE0LiiAJa9pWlxtjm23zg8uymlNqE49skYrHlIAn/2mxhOTTZ+gQVon04
	 zzoP3Df/7bAWz8jcywKw+3AfLj0sTR5X60MfFl4dPp21XfOYeUZgE8fUfBr1udQEp5aDy
	 Qcic2w9YUbp7RTj/ysLYIbFoKurVYhBUN/XW6YJ99NVB/AOZEOi/dofloUaHveN8Tgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BzZTS43cGZ9P34kMRMgj9c9g9bQZi33FU6TeN8aGTO8=;
	b=Laq/xxbM7+aJEeXADVP0qcFfT3eEUp6BNxQNv1eDGuZGKIH2RorXJ4NoalbCiVgILIqu
	 VxDQvozZgfvHgyDKP8FxxzamWreRTw4XGW1TC0+7IgeC+nLYULIZSU5HJYLiSCESBkgyJ
	 qqy9RSDQdASBQAreQYIq74OMNV+DKnS6+DIDI9HRO3kaFtA9BNxvd5OwD/Pt7Z6oru7ib
	 T8U82TpgBOtCHzh8ZNZBkxYcZoBfF2N+PjdyCOZ89dJUuSXCmKtNvdkLwC4ek1RNMEsc3
	 nHWXAwIMG+pVZNGCJDTrUT56DnUetsM0+SM6vrKlfVMjWKGSABKZqkk1d1Wowlji4kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfS9Il7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF75606A320;
	Wed, 18 Nov 2026 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfS9Il7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18CB1F000C4;
	Wed, 18 Nov 2026 22:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041416;
	bh=BzZTS43cGZ9P34kMRMgj9c9g9bQZi33FU6TeN8aGTO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfS9Il7c6Ckivg5nD4fnS/eB5nuN/SecWEiR5Ojp6RkPU8LtdyR0QJZSTmLbN0FdZ
	 0tVeOAaqxrfiLUTL+0tCL1GWMdyNOCfk39067teQv6PraOKRNrQdedXla1xQcdKuMV
	 pOk+Gk4NJanKdE7bgz5wNtpSTMXSlM/qmDBAWni0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nir Yehoshua <nir@ciphersecuritylabs.com>,
	Ahmed Yaseen <yaseen@ghoul.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2765/3318] platform/x86: asus-wmi: validate custom fan curves on enable
Date: Wed, 18 Nov 2026 15:56:27 +0100
Message-ID: <20261118150443.680764871@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c12b50f2f6cc..acfab8a6558e9 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3025,6 +3025,33 @@ static int fan_curve_write(struct asus_wmi *asus,
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
@@ -3109,6 +3136,11 @@ static ssize_t fan_curve_enable_store(struct device *dev,
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



