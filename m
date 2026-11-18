Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032331;
	b=nXWprWirbcXiPi3oxDNl2EfyiqcI7Vr5unwu0ON6ZlGsReZKxBR4jeigia1vDItxpJ0e
	 Xv08RjGYU0da8YYNZTyTP8mZdIxlr/q/Am5kXgr7x9G78eLQKnCr1Y1YoUBmbyTNoVgnU
	 HEuef9XVjFpzr3de/YBcRUWnaYCZTQaFqVceYmDv4Bz6zqhtyV4MchnHQP/hcRPZW7BD4
	 ujMaOjRhmbok+ddTdiHoWDFNcxE/DaKfXWF4jaAlLrgkCGWtJgmM07sObyzuMKbhfd2OG
	 nBD9quIn5NauKP/+2BnhkOGR6A0N2dOX/h3Qo1eO//gXdEhoHmxgvJxtoJ9rM8rAbHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DsClk9w+oxBEPhOfh9yBmFOGK8QZgOa7Xsqd1jns41E=;
	b=aOQTP0svJaI7xAJNstDTWzZnpSuOlacq74OA+8Pl15FbxxxLRiJwrpBcORkmoFyFg9vr
	 eE4wiaQalWwuTkaPn0sAwcSvUyQFT27s9MQW2MmdyRT81sFJa4Y+5xlsRmOMy4Qu6Q2b/
	 bYJ7M+ezaT5vmC+qmqU13MlqZbsEdSrX55OTYeJrcSc1F3wAavre4AbvH93vswwCK9cz1
	 06CrSMH5Uae57+a5DV0MR0DsYJv6CnE6yZMVh1qIY59n+7WddsEKuvxPW4I+oC89E/+3Z
	 5NsV1gxGQBJ40f7DDRAebr5hw8iJ/rEmPVGpLNL/xRXC0OjbR0V0qUb28z2rBSUoPAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JI2/y3UD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A2D60A2603;
	Wed, 18 Nov 2026 20:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JI2/y3UD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450FE1F000C7;
	Wed, 18 Nov 2026 20:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032330;
	bh=DsClk9w+oxBEPhOfh9yBmFOGK8QZgOa7Xsqd1jns41E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JI2/y3UDNyPY7y7GIRpy6QYar61weePmofg+FTUsU+KIgt8XBmj5Qv6rfZPGl6MdB
	 W1wg4ZOrXSqWUu8QwDzUaJY5K5ZY9WDabCwQhTvF8bfNluTLnjkbJxkG0YfDpZCocE
	 KXu3dSdjyI7juQhaJhGyEngPtHIoRzH0X3B8zTbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Geels <dmitriy.geels@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1332/1756] HID: logitech-hidpp: cancel reset_hi_res_work on probe failure
Date: Wed, 18 Nov 2026 15:57:39 +0100
Message-ID: <20261118150102.404820135@linuxfoundation.org>
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

From: Dmitriy Geels <dmitriy.geels@gmail.com>

[ Upstream commit 0be03caba6c002385e74d60be934b961aa5e88dc ]

The probe error path cancels hidpp->work before freeing the HID++ device
data, but does not cancel reset_hi_res_work.

reset_hi_res_work can be scheduled while probing the device. If probe
subsequently fails, the work can run after the driver data has been
freed.

Cancel reset_hi_res_work in the probe error path to prevent a potential
use-after-free.

Fixes: ed80cc4667ac ("HID: logitech-hidpp: Add HIDPP_QUIRK_RESET_HI_RES_SCROLL")

Signed-off-by: Dmitriy Geels <dmitriy.geels@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 25cdf5ebccb3b..41daa4251164d 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4555,6 +4555,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 hid_hw_start_fail:
 	sysfs_remove_group(&hdev->dev.kobj, &ps_attribute_group);
 	cancel_work_sync(&hidpp->work);
+	cancel_work_sync(&hidpp->reset_hi_res_work);
 	mutex_destroy(&hidpp->send_mutex);
 	return ret;
 }
-- 
2.53.0



