Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029280;
	b=udtVknpbSFAl0LJ+Nik47bPYGPNiqYoC67wI0Ud0a1pSqJ7XKZUh8lcVtQCOtOuE8wMy
	 gQnorG6lKHGboCcvJBqFZzK9SZyvq2EH8glEo65Z4nPb8DlnnVnToNnd9lbkqVskEIgD2
	 ClZ1ZoowEikP6Zw2Ko51slrY+0z2Cxqjc8QcZf9hhE+K9i+cfxcoK9ilUnA/q3t/Te82r
	 pU66WxLy3a8opddnizG0WjJQo+4l/GoCYIP6gdgqQDa/4ZdRyfPbvakf9o1GNv9BeZME8
	 nUDiTuEKOpKdaK8M020lK3mIWlXfwh0N1bml2O8bIK9LoZJ70gFJIJlRpcIF5Tn4Dbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3pOSH7oEnrxwUKRnUfsDG77MsXanwTk4/s7jfe0lps=;
	b=TzRPo6+Kwt4irv4Hxm2FQYlt/XUArrUrJ+5ctlOivcugwdAf6mWN+hPyuSNvt9sa2ZRU
	 Dc4p1oXTSdrxFemg12owdvUv6dcxLdyyFzzB3JxKi+feiienkW2nCSC/339iNKAHP6FyB
	 pI0TvrgsVnpL3Wg87f4ye+c7fItarOcKpZeWMuf47sjFfIAQFuT4KWhEa6E+aJOCzEA2R
	 PqiFtBPptI71d+T333ZUqbuNb6XvJUi2uvQX2Bx1XhuP2VqyHVVETRD1MWJ9HSWjmXnoR
	 btWHv3oGrWJk/hr0PpDrLUwYbCISEKtQPhKaJqNQ+GWs2+PYosDUw5Y6GgUiyCVv87Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vyz2ZLYH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C10D606A31C;
	Wed, 18 Nov 2026 19:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vyz2ZLYH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12D61F000C4;
	Wed, 18 Nov 2026 19:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029280;
	bh=X3pOSH7oEnrxwUKRnUfsDG77MsXanwTk4/s7jfe0lps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vyz2ZLYHnMXxs2DCzXJi2ErdPRh/Jv6r7lPXDnYDw6qgUwsAcyz91uX4mXEv3IKsU
	 zZpBxKxySfPXPS7NJFxqe+ce9BBtCN0iVH1iOZdeg+U7k6Um4jKqbfc8XUNh1HDcZJ
	 Dn9iDvqREkgTGEf0s/3RlqVWTdv5OP4LdC5LLJaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0294/1756] PM: wakeup: implement devm_device_init_wakeup() helper
Date: Wed, 18 Nov 2026 15:40:21 +0100
Message-ID: <20261118150020.075718591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 76cd1f9f13653..59d542f761fb7 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -240,4 +240,21 @@ static inline int device_init_wakeup(struct device *dev, bool enable)
 	return 0;
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



