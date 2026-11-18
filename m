Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048009;
	b=bqoZO1kY8kyQOkAZD/02xHYt0BOAB/NQN+6NnplOovPfR/V9EExhTju+mZ0BiMlcDLjy
	 +2rd3VDhbZNu+MhSBDo7i7YZST9rI/Ya8fJQEXBnvTPKdSMnJ2B3tKP+LIfn1FOGX/OBF
	 3UuIRgM7qAvoxw5wdplVAodun3Ilu7K7QtIf7fTVnH1GYPVwPSxWisw4y1jKrGQzY5KGa
	 59ttPAEhfYreoz1uYq6Gx+f34afZutROMdKVdcKbHRViBSuyo/7poaQHFZHsAEbaW+S98
	 Sy+VBxghgqa8qtTU2zlubObium2FnwiZMyXl7I++ARQe+WnwVBkIho3dAl48C3t+NRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WHE5EdCMt0SHImWlwe543TKOgch7S+NRIEUD/wBepkY=;
	b=YiABG1Y1pla/rewkLf04JaE84IefcL1Dec7pla4CSeySFUYx0BDvcJCRhh28x0a+bpAL
	 WKlWxBROLviqq1sdeQiMzeP6rg5X6RLqN0LMnCvQDh4vV6ckTrhzLn+NB9TsOVIBP6bDx
	 SUE3GdRZV4yJbDzo/sx56FVx6+g8mfWFAnTkkD8gxkHZ+KuawEoZf5bCI3/04w5LwVNro
	 tWsqR1Ok19A/FJsHGsVTGfIbWgo8hP+Grk4eyVlTniSbUMtw3oC/Yf+RxXsDR+H3YxSWx
	 91YuQtoUAZBfjf/7j/UXXjdvP/ZeEK68YrVw68HFxMjjO2JAkaH1Jt0eND1T4quOkZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USgQgOwG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9437C606A334;
	Thu, 19 Nov 2026 00:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USgQgOwG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6801F000C4;
	Thu, 19 Nov 2026 00:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048009;
	bh=WHE5EdCMt0SHImWlwe543TKOgch7S+NRIEUD/wBepkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USgQgOwG2VONdDcd6sMA4IOyXAtqN3iKfBln+Q2W2TtZtJm0fogLh21XliZ07qNZa
	 sE3kl647pX0S79CpndqopmBM2hT9DAJCnNFJu7qn3L1J5uK7p4YiEfRql6g7NVdkta
	 vTB1Hm36vFikhKNek9V/QITdqWKTwvJpXyLHTlxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1842/2857] PM: wakeup: implement devm_device_init_wakeup() helper
Date: Wed, 18 Nov 2026 15:47:56 +0100
Message-ID: <20261118150307.575147693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit b317268368546d6401af788648668f82e3ba1bd3 ]

Some drivers that enable device wakeup fail to properly disable it
during their cleanup, which results in a memory leak.

To address this, introduce devm_device_init_wakeup(), a managed variant
of device_init_wakeup(dev, true).

With this managed helper, wakeup functionality will be automatically
disabled when the device is released, ensuring a more reliable cleanup
process.

This need for this addition arose during a previous discussion [1].

Link: https://lore.kernel.org/linux-rtc/20241212100403.3799667-1-joe@pf.is.s.u-tokyo.ac.jp/ [1]
Suggested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241218040935.1921416-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: ece9baab2a6e ("power: supply: bq24190_charger: use the wake irq API")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm_wakeup.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
index 77f4849e34189..9a0d6d4a85d98 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -232,4 +232,21 @@ static inline int device_init_wakeup(struct device *dev, bool enable)
 	}
 }
 
+static void device_disable_wakeup(void *dev)
+{
+	device_init_wakeup(dev, false);
+}
+
+/**
+ * devm_device_init_wakeup - Resource managed device wakeup initialization.
+ * @dev: Device to handle.
+ *
+ * This function is the devm managed version of device_init_wakeup(dev, true).
+ */
+static inline int devm_device_init_wakeup(struct device *dev)
+{
+	device_init_wakeup(dev, true);
+	return devm_add_action_or_reset(dev, device_disable_wakeup, dev);
+}
+
 #endif /* _LINUX_PM_WAKEUP_H */
-- 
2.53.0



