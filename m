Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048249;
	b=Fu/PGbtoRmaIM/VnTkS1c/v010DeHu325S0VjHKpGItgPcf1BJNCYAtUkcaArJddClmh
	 /50IK40mjAIXjtZeY/9omzyK6jKWRNTNQb9NoJWfi9P6ufMCqk80AhKi1KuslLEA6wzJD
	 rJVowS0CuY67m2O/ybNWeVA2y9NNANsYsv2BCiU+ZjdpLJhSyQQb1iVrrHDUYBdOZNb2i
	 DpcIqLZ+YT9ZPVzw4KEgAvIFAidM3kurJ74YUQXYULzKNW719u4s/teDaQGoi0gntNzUA
	 i9oxiYB91faBOynMw+RW6Vfyf+gj6YPi1ZN4jNZSmJyLZ6iaBvMzTA+VoFOzrfkkwrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRma3kCmNvDpMvqQBYyGTeL4Vn0zV5CFW3QmqwKZVRE=;
	b=jUien9G0r+ZbZjb3RjEctus4Zr0KTR3tmAZGf04LFoGy3Wz/Oy9JtF7QQEax40Mpg+zh
	 kHcr9eRfRbyc2Ewoyzlx6/GUf68Rmfh59P/a+GEHb6l1XVOozQI0mxrcpeM0L0CUkPQPs
	 9mUkS7HlOoITCESxwogJW1D/sH304U7rjNyJpTzUXYOvHxQeNWbyDpIGeDqLv6UngDWa3
	 2kmn4q4jRrPXkLJW/mrBmGDmGkDh9LyLTFXN5VaoToAJpmhrERwhbpAJFWdUQvTVyEKEQ
	 udB7yajjOeLg6B4obOQgyoLUQQVVviMd5MQoudAfEaImV0/OEjb+gYit/eHyGG9Xgkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXgo7y+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAAE606A31C;
	Thu, 19 Nov 2026 00:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXgo7y+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CEF1F000C4;
	Thu, 19 Nov 2026 00:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048249;
	bh=GRma3kCmNvDpMvqQBYyGTeL4Vn0zV5CFW3QmqwKZVRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXgo7y+eJSn/b7PMe35PGC/qS6jSlM/Tbbwhs4Gj+CbUKAqVEQuvgCJTU0w6SeDnr
	 Yqyn2xB/ADS1MMGsgf87GuyHhb70iPluWVrN6w95TgjA0BGz65gBWG/IkpDSNEs5N7
	 0XTXiwxbvIH1v8Kg9cKGhmlqPUkPwxwlnK7ISQhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1927/2857] pinctrl: amd: Add PM debugging message for turning on/off wakes
Date: Wed, 18 Nov 2026 15:49:21 +0100
Message-ID: <20261118150310.595351070@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 54b962fa14dc82a625436fcbcee7b3f2067a4f6d ]

The GPIOs for devices not in _AEI/_EVT such as touchpad or touchscreen
won't have wakeup turned on until the suspend sequence starts.

Due to code in amd_gpio_suspend_hibernate_common() masking the interrupt
can make this difficult to follow what's going on.  Add an explicit
debugging message to tell when that was turned on/off.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://lore.kernel.org/20250814183430.3887973-2-superm1@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 44c232e80adc ("pinctrl: amd: add timeout to irq-enable readback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index cdd7841b93163..755fb30731a83 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -440,6 +440,9 @@ static int amd_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	u32 wake_mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
 	int err;
 
+	pm_pr_dbg("Setting wake for GPIO %lu to %s\n",
+		   d->hwirq, str_enable_disable(on));
+
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
 
-- 
2.53.0



