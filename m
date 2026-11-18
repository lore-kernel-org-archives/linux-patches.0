Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039476;
	b=Nuc+nqu7J4swPRP1+pm7nEiCbzwMBe6jRYluRcPvlODYwbxXu1fuzKyab4TkhzfNUopP
	 sro2Xz8e9Z2lc2iPj5kYlNDo8ZkXi1PfvvFgXA80f8M/P/yWpT7jDhxOS4VcZnt6szyST
	 TYrCst/g5zYiXRivZla1gXMkaBCMXHrej0tMHilSP/0SLGnPKB4r84tiXU22SyPx3SGNU
	 rCZRmNMBlMINNGTOyEKbhX45UiD5m0i0ggYAjE/GPjXHglLgArXmkSZWygtqRcF7zhALx
	 fN4WzXaB9zd6hbjDzltX4yFiGAUD2zhCCzO/k1R1j/pzK3+Asp8rkmKnmYiNXeoyqXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OXY5ak/lys/25TLFpNSMZx2W5WzUW2Bd057W9c/+FcI=;
	b=QF/qcGCCX8p0hAM5RYSeMN4cgkJDlYaBz4A7r63VnXZKB7VcUc3q3yU6V9EiQHZS7Ezg
	 Hlwfe8BtDzQimCI6hfcifc/HdFNnbLtmjv6z6n27idlEA7sTEzLJPXCFtIcbfUNCwrR5A
	 Hy6nDwpzylbi6lATrbEc0QyynU9o4IX78Hgx5voLofuKflY+SEkWu/zU74R3MIZ+gYHlq
	 Tehfv+R/BFoakGkmIpOkZ0XfEfqa3mhaKqMLK91S0kNQWKsFUysDOOitUgY8OgVUAgunq
	 pUMKZ02aJt/YHwArZZj9qEE9+K3GLaek1BOMbBMHe4svUKnSWi5kydVPT4IuPwR1kAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2TDpt47;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9141E606A31C;
	Wed, 18 Nov 2026 22:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2TDpt47
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BBE1F000C6;
	Wed, 18 Nov 2026 22:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039476;
	bh=OXY5ak/lys/25TLFpNSMZx2W5WzUW2Bd057W9c/+FcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2TDpt47Pkw9tRCNBX0o8gdx36YK+v5FY0uYcd/7L3jVXyFzTWHjm2j8Gm+/PsEFA
	 1X1EPjy15AMPqlvYmSa/txuQHA4JSig/79fjOnCKGsTWRCWHnEqueiiP0s7xya2X2j
	 MDiFcdvQKfpqD9YCnAIh2yKieCM7bdGzg+oCkHRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2114/3318] PM: wakeup: implement devm_device_init_wakeup() helper
Date: Wed, 18 Nov 2026 15:45:36 +0100
Message-ID: <20261118150425.488102283@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6eb9adaef52be..6cc5c85d83118 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -242,4 +242,21 @@ static inline int device_init_wakeup(struct device *dev, bool enable)
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



