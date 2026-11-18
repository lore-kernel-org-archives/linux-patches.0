Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060559;
	b=VJlKMs+GMv8DXHBtKbpbFtV9jAD/3MkzfJgtY/7f35dkTsA/rQpa9+r6mvDt2cQJKOLM
	 KMPtXDTZ/5fSekHR0+P6pvGQO0at36E2wGXNjxKwZFFcNf4ZgJmximj4vxlQSpGMK+iPn
	 XxKDZgtWOlrmdmvHwssxAdT3ff3IC8DfFcIbAXjMLIf0e2nXCeYVhxJneGH2xNvEsuXXN
	 J3xr7G1sXo4tyJUczh6zoywNeNB6Co+ZnFoxx+djY71YCXEYmvweyegd7w0jHhmnio5bT
	 T+9i0cqfOaqHEiT4ikWzRA97IXunuaoc70hueaZnuyRKuUahAqg2MvILDXiZpMC5pBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g0ztFFxcJnjMicNlmT8FZSKmxd3OZKmf1Zxf0eBwpe4=;
	b=gOxvn7ovJPI1SiLgTDF8NR8tJBjR8XxrrFwrwyZfeiXC6fql0goBU39QBC/RV0ozb6rb
	 Wvz5uDwW0VKaPtxxK8mWUKDb3/1NQc67LbBYmc45lb9PpVvKSDeBL0M2ceDryU3sGGLTS
	 U72vZjd/9NnpSZWgtE89KLGV7XTSQlzDc5EzJUfXnHg6ODpS0WR2hLLYDob/R7Pf+2KJV
	 M8LvKCQK7XGBG47BCBdjrv0bjant7Ledhv0C3EX3Sxx1r550BqtHw22bZRH2tAzgokW2c
	 BPWMQviHjWcbDJ5jpdlCkkCm8DAbTCYMDk/TxVkpj/zITzzkHmzy3Uxg+bOz/nsK7rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYDmQLPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D142606A32A;
	Thu, 19 Nov 2026 03:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYDmQLPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0011F000C4;
	Thu, 19 Nov 2026 03:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060559;
	bh=g0ztFFxcJnjMicNlmT8FZSKmxd3OZKmf1Zxf0eBwpe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYDmQLPEJIFbKPKGzyWuMdqIEv+kV3fgcb/KIf0njSxQD/gCfiOC6dGl06+eHIiJt
	 o32ik9Fknih/PEysqi9R+8ndhCcXNIxiIo5CUsIhWD6ushUKmPvEZQ5bpLqzKIn//H
	 2ce79u0IAKbN7UFvTmNGNT33iDcbHy7JpRg+iv6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1200/1848] PM: wakeup: implement devm_device_init_wakeup() helper
Date: Wed, 18 Nov 2026 15:53:58 +0100
Message-ID: <20261118150010.109140534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6fb698ed6deb7..13fcff797a2d8 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -222,4 +222,21 @@ static inline int device_init_wakeup(struct device *dev, bool enable)
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



