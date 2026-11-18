Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054972;
	b=jEimMv9+5Y9Pzdrch76pjJWtAcygHFCvZrEHQA1LhybxvXd8kGeMBS1rwwoHts9diVBq
	 byUJCW3K4MGiZNttrP6sBXNa9su+BTpu/u0zT2RdZT+PoPKT6yNmYxIizcrR8bWH7BBiN
	 gxnEzbLEEq7YXHDiAShJM4PRxGpFXCwIUJ9BJjAlv2ztw2QRuSDXDF2TckxOD6DJKo4aY
	 YjtFJ2qO+wzZVirquNjGG0fmOXfOK/ToJJCuk9gdy9ZOXhLJBj9LChqgyrAPpZ2vGzWST
	 idxUQ3CoK5KU98ATK/YlH5GHVfWy08znzKLcTDXLbzli+qkG46dgPlmRnbs0JiufKGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uM7kKciphcY9Hq1mdn76AZSYuexsgf4WAdnz92XAKz8=;
	b=Qc/P1DSeIZZl5vEIC77QUvge9UkANlMdF0wtm0ARG4GEtbrrFWh7yKGVktZ95hFt6OCz
	 h4L60f73ojA895w5/6o0X59w6Ai+buGNlPyYkY40aMZp6lKkyzbxgA4rcBJ5BE0RxROSJ
	 slA7ivxOwMYXBohSI0CAoY0a1j+9j2h5/fVH9B2fCcfTEeJQyWgmeryYiCgFR9+kLwvAo
	 X933PHH2eKgd5crCWq9WGAOZLg7h2yQNkKCTZG/j+VZZRXcFqPrs399/3xX9kezNaKa+x
	 MkIzm014Lkv2rNItZFsIEmZOM1yYegsEpPZtlyaQXDLEctj7GyfSlTtFTW4OJ+LrA5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d2hEfGqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF1C606A32A;
	Thu, 19 Nov 2026 02:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d2hEfGqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285561F000C4;
	Thu, 19 Nov 2026 02:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054971;
	bh=uM7kKciphcY9Hq1mdn76AZSYuexsgf4WAdnz92XAKz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2hEfGqrAnpq7Sg7xA3PjgEiXYgM3IIB/CNc9PfRFrgtY8U4XslZ+MfanVuif4srW
	 g0CMSQ1Xtabstq5s1oHnwUOf0+nBVVhMMYOkajCSrsJ/AK2AHmfq6c+P+5sq/NzaAG
	 aitCIhrXZutTSfn3KJfi3lg0Ckqs8kf2pHvydrc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1425/2214] PM: wakeup: implement devm_device_init_wakeup() helper
Date: Wed, 18 Nov 2026 15:51:41 +0100
Message-ID: <20261118150108.201727663@linuxfoundation.org>
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



