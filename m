Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064038;
	b=aY6r+Www83zwqivBezjvpnb9BJcbyhQqqwk1/tH12gBGb6EuQtajrp9Uw8oUbH0C0X8Q
	 tOPS3pds91Qs3Lh6kAPDT9utKNv2HWOlNSPSygSXZZTDR9T5VZKSIs8YoNxi0jXSYnTQg
	 a/ryJk/t+YZw/6u6fDO/ymD1ysd2rTJMnhSwbfcWySMsQ8G64M7dPdGThLTH6Yq+/HKln
	 n61fQ2i0rjQpFyCfuPCxGgtVsfFQ88/gQUdy3MQPDLvs/euqpR9EVgw35rUIAvunPMXGN
	 AALwFEESjcX3RuEiJkkJc351y3QEqpGt+WmtbYMeeeKDqjjU4+rQPTcNsBuHqaifRXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tajlADtF/NNfQjdZNVQDjT1ZxMIpGIKKE07zMUi7V0I=;
	b=W4lPUBDZBFl7MuxT2mY/4oRabpHpOAcG9N0ukJgE9VqjhCBBmuTMAqleZfg82qn4SJYJ
	 od3Irv9R7kS7oTvqti4P4K6wrxW+aYqc/Ci+SH2HLcP+Zq4gybvC0+xgUqBz3ojBpmWZq
	 LW1ddR0N1TMUn6sqhtjXlJtMdqUGA6QEpQh9vaOQlPuh1UuCO6WW4GLB7BvSjMZ+KM7pY
	 xzWOyRFCH6xzg7VpqtC1+OM9eoHSy8RbXpw0JnAZdRAvEzKAa5Y+/UYVwlIPUvCJZL+t4
	 fMtbo0B/zp5ItJWbQuJLTN9FDbixhZM8+c/AskPAIdRGSThnmz52iEHOJTVoAtsW5dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNrb0vUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259CF606A9CB;
	Sat,  7 Nov 2026 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNrb0vUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C726C1F008A1;
	Sat,  7 Nov 2026 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064038;
	bh=tajlADtF/NNfQjdZNVQDjT1ZxMIpGIKKE07zMUi7V0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNrb0vUhaepa07W2NR5eQtxozeMlrkdh79gwcgmcuRjzVqn6/0tVS2CooWBKq7iQj
	 NHEHsMvyNZMQUC99DbVOTOqjhFhsWKLoyLSyzt1dGjhKodmmWCbynrrWHhLxdzctzF
	 Bek9ch8ngCaCzpd/f/gdGVZvssHqDJkhCTHgAxGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0174/1257] media: i2c: ov2735: fix power cleanup on remove
Date: Sat,  7 Nov 2026 08:41:10 -0500
Message-ID: <20261107134944.160296894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 06d4f202f007b160e650e8dd861a5fc223024f34 ]

ov2735_probe() explicitly powers on the sensor before enabling runtime
PM. The probe failure paths call ov2735_power_off(), but the remove path
does not perform the corresponding power-off operation.

The managed runtime PM helpers only clean up the runtime PM state.
devm_pm_runtime_set_active_enabled() disables runtime PM and restores
the suspended state during device resource release, while
devm_pm_runtime_get_noresume() drops the runtime PM usage reference.
Neither helper invokes ov2735_power_off().

As a result, removing the driver after a successful probe can leave the
sensor clock and regulators enabled and the GPIOs in the powered state.

Call ov2735_power_off() from ov2735_remove() to match the successful
ov2735_power_on() performed during probe.

This issue was found by manual code inspection.

Fixes: fa9e6df636fb ("media: i2c: add ov2735 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2735.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov2735.c b/drivers/media/i2c/ov2735.c
index dcb1add1fd9fc..2defcaa8b7950 100644
--- a/drivers/media/i2c/ov2735.c
+++ b/drivers/media/i2c/ov2735.c
@@ -1081,6 +1081,7 @@ static void ov2735_remove(struct i2c_client *client)
 	v4l2_subdev_cleanup(&ov2735->sd);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(ov2735->sd.ctrl_handler);
+	ov2735_power_off(ov2735->dev);
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(ov2735_pm_ops,
-- 
2.53.0



