Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056766;
	b=xVkEjS0tpFMoY87r3ivHafS4Q7RiCQw5ddarjZu14kjbfUmveOq3Zudo680x4FSET9Mk
	 +hvG1iLJb23CXqq7859SbBrkGdpuzZKeNOLH9SYmhG+zDwE6f+EOkCXGYBvvvIoNTc2sx
	 EsuD7hVK+xtw6rXLk+m4SZ01ui+SWFoGbUgSvTi4JUM0VgNTqKJ+RXwT5zMytfYY7w1T8
	 YsK6kI6gFPzsrjn8FGkjqnPyPxkf+JlR5iunHCx0nBn7WlvJr7Tw7Lbsw6ZZ+M1etKDUP
	 IFpOQcXBVtS2pPvhDzrKvUQpxyIs5cHUicYBu4iDt0eNZsOsPZdc5haHXGKYfnvOu+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2OssO3dNkIipl2txt+fX4i9MHrBGr69Kv6FbEjwVvfA=;
	b=VJrDQQP+rSk/OA5Gwnu8hY5l75rIrBtuib9RFCCznPEJPn30FakBfH6ZXCBLAmRGAMU0
	 /q2ZhHnkJiM2VMQ+saCK1hmMadJmsAjiE+G1l8oIWwjkQpl8/4e1fpyYzaaX+7tC90YMC
	 L+KCOHkgbLLblyaSZTzJjYKShdVpskqcAI6OZ2cawenYtR33VtXRj4MHNT4jggQhjmGKZ
	 FpZ9cb/u1tJpyVy+2feEo7vLX6RDNc6hQeCyfVyncP+eXNWZEYdcdgJnbQfFU25zQyAoF
	 D+glpQbye32TCjYR1D9AylZTDaJZAcR1nwBC2ug+jr4VmitaPUcwKpzKDOiScSmNdtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gY7PluJa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F44606A32A;
	Thu, 19 Nov 2026 02:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gY7PluJa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B710A1F000C4;
	Thu, 19 Nov 2026 02:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056766;
	bh=2OssO3dNkIipl2txt+fX4i9MHrBGr69Kv6FbEjwVvfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gY7PluJaCaLrHQvgU200kp7dkOoAIeX0zNYkVJuZYkV0j/Pn3MBFQl8gpUaQ2zNwW
	 ctdsNP2wXuCpORwL2baS4u2ygsSgD9bnCg3fiWg01oSNv9uYTxDxZWt1frQrRf0Ila
	 OxzRSYAeNVxYUqhXF0/BTOLpRtilxmoq2dzHmpmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2105/2214] regulator: Add regulator_err2notif() helper
Date: Wed, 18 Nov 2026 16:03:01 +0100
Message-ID: <20261118150134.850799918@linuxfoundation.org>
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

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 6fadec4c5561e2fbe1dfa8a7da9bc58d094a8f04 ]

Help drivers avoid storing both supported notification and supported error
flags by supporting conversion from regulator error to notification.
This may help saving some bytes.

Add helper for finding the regulator notification corresponding to a
regulator error.

Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/eb1755ac0569ff07ffa466cf8912c6fd50e7c7c6.1637736436.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8a6d73e316f9 ("regulator: irq: freeze deferred hardware access during suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/regulator/driver.h | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bd7a73db2e66c..6324677ca8abf 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -644,6 +644,40 @@ struct regulator_dev {
 	spinlock_t err_lock;
 };
 
+/*
+ * Convert error flags to corresponding notifications.
+ *
+ * Can be used by drivers which use the notification helpers to
+ * find out correct notification flags based on the error flags. Drivers
+ * can avoid storing both supported notification and error flags which
+ * may save few bytes.
+ */
+static inline int regulator_err2notif(int err)
+{
+	switch (err) {
+	case REGULATOR_ERROR_UNDER_VOLTAGE:
+		return REGULATOR_EVENT_UNDER_VOLTAGE;
+	case REGULATOR_ERROR_OVER_CURRENT:
+		return REGULATOR_EVENT_OVER_CURRENT;
+	case REGULATOR_ERROR_REGULATION_OUT:
+		return REGULATOR_EVENT_REGULATION_OUT;
+	case REGULATOR_ERROR_FAIL:
+		return REGULATOR_EVENT_FAIL;
+	case REGULATOR_ERROR_OVER_TEMP:
+		return REGULATOR_EVENT_OVER_TEMP;
+	case REGULATOR_ERROR_UNDER_VOLTAGE_WARN:
+		return REGULATOR_EVENT_UNDER_VOLTAGE_WARN;
+	case REGULATOR_ERROR_OVER_CURRENT_WARN:
+		return REGULATOR_EVENT_OVER_CURRENT_WARN;
+	case REGULATOR_ERROR_OVER_VOLTAGE_WARN:
+		return REGULATOR_EVENT_OVER_VOLTAGE_WARN;
+	case REGULATOR_ERROR_OVER_TEMP_WARN:
+		return REGULATOR_EVENT_OVER_TEMP_WARN;
+	}
+	return 0;
+}
+
+
 struct regulator_dev *
 regulator_register(const struct regulator_desc *regulator_desc,
 		   const struct regulator_config *config);
-- 
2.53.0



