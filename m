Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038451;
	b=o5d0ewwVdM2egKK3RUA4k4oEBQeYq/fGEFhBLP+HRSAx0KkjUJR+bgW4thU4wxNVRb0/
	 FX8ak9nwa2WvtYcrnzRbsMbLsGqUFlclY6ipIcMPjh5AhTEqRUu9sM6+qOvXCDj6wCgCs
	 ktZ50qN0SRdIF6ouh+4ED1IhDoxBb4ss6UWoWZDc40f9sZj2OpWvoK6Yx+Cdf1dk9iSEw
	 4CSPl38joSPSVItyRAgyulYj2kSbaV6hZ+ncIqRKlC74TnntK8+2x/06S/zwsX51YDM9D
	 W0tsazQXJ8v1PQHv6Z5e8E52GvRsMpj/mxclHaUScPYiPYZE8W3qeKizTJDZ5zDe0mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lLI4K+/cd5W5FuuK91Wqib7oA3xinR7mhsuOizBXk1E=;
	b=QxNqB6oLMdkhBQgeDVtgvJUYYrtOv7N8Qp1zzTSbLLfamm7QexNTO+mg6KNVguhtqWmm
	 ZoQ5DCD1Ow2ENyipWmWrUsw3w9pRO3rKhX22g8WE8ROc647IDvczxNpR2k2P3iH3Nj2sR
	 QpXQZ6JZKOjqubal62dL/sjchQPApGiq93V4iowaJQHs/p5e/em6ozExjoirrcvIyYLyM
	 2qlE5QkEsymgJ2h8RiIvaTCZHk9t+vMNor46AMvjKmHDHm1u4INqash0sTblsefAriQc3
	 5oyaRWKwQWcCMqdLnvoA7AtTfC129vsf/Aiv7oXj7175548iCgQ1c11ZJeSiAfvxuaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVnnDDVP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE80606A325;
	Wed, 18 Nov 2026 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVnnDDVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCD51F000C4;
	Wed, 18 Nov 2026 21:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038451;
	bh=lLI4K+/cd5W5FuuK91Wqib7oA3xinR7mhsuOizBXk1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVnnDDVPVyMH+OwlJ27sc1qYZ8cbO9tz9z7eUbiEJgprwON3OuRSwxL68owigQYAI
	 zz1otWRdLWKnq8iG+07kS54EX4zKenxwwu3Htq+2THMWxK8qJCl/+RD7eb5+6LZoBi
	 KfBnGlQFmpXNBbW0M6FEDPNOVKyymUeQHuqO0Wwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1749/3318] leds: ktd2692: Pass context to regulator cleanup
Date: Wed, 18 Nov 2026 15:39:31 +0100
Message-ID: <20261118150414.328769406@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit c73e9f04445f361d5f19ca2edfde742ce18348ef ]

regulator_disable_action() retrieves the driver context from device
driver data.  However, ktd2692_parse_dt() registers the action before
ktd2692_probe() stores the context with platform_set_drvdata().

If devm_add_action_or_reset() cannot allocate the action, it invokes the
callback immediately.  A later probe failure also invokes it during
managed-resource unwinding.  Both paths dereference a NULL context.

Pass the already allocated context directly to the action and retain the
device pointer in it for error reporting.  The context is allocated before
the action is registered, so reverse-order devres unwinding keeps it alive
through the callback.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: ee78b9360e14 ("leds: ktd2692: Fix an error handling path")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260910194525.99654-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
[ sashal: Adjusted context for the device pointer insertion because the structure lacks shared ExpressWire fields. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-ktd2692.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/flash/leds-ktd2692.c b/drivers/leds/flash/leds-ktd2692.c
index 670f3bf2e9062..b54220658f969 100644
--- a/drivers/leds/flash/leds-ktd2692.c
+++ b/drivers/leds/flash/leds-ktd2692.c
@@ -72,6 +72,8 @@ struct ktd2692_led_config_data {
 };
 
 struct ktd2692_context {
+	struct device *dev;
+
 	/* Related LED Flash class device */
 	struct led_classdev_flash fled_cdev;
 
@@ -258,13 +260,12 @@ static void ktd2692_setup(struct ktd2692_context *led)
 
 static void regulator_disable_action(void *_data)
 {
-	struct device *dev = _data;
-	struct ktd2692_context *led = dev_get_drvdata(dev);
+	struct ktd2692_context *led = _data;
 	int ret;
 
 	ret = regulator_disable(led->regulator);
 	if (ret)
-		dev_err(dev, "Failed to disable supply: %d\n", ret);
+		dev_err(led->dev, "Failed to disable supply: %d\n", ret);
 }
 
 static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
@@ -296,7 +297,7 @@ static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 			dev_err(dev, "Failed to enable supply: %d\n", ret);
 		} else {
 			ret = devm_add_action_or_reset(dev,
-						regulator_disable_action, dev);
+						regulator_disable_action, led);
 			if (ret)
 				return ret;
 		}
@@ -354,6 +355,7 @@ static int ktd2692_probe(struct platform_device *pdev)
 	if (!led)
 		return -ENOMEM;
 
+	led->dev = &pdev->dev;
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
 
-- 
2.53.0



