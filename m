Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590549;
	b=GSmWVk/BWXkhzhXD8PQ6wqby1+OFN0vF25c9M4eLKOvIvuGo1oNE3twkxWcdGfhKZBqQ
	 nrNj7sJyYcqex4fOTyg1Th4uTuTXoz7kUyn8Sc0VBSfQQ4rvlKjEsVsXEzLd+gpWOff/o
	 6yq51xsPF2/Fc1sjkH7d9bthcZd3uM8+xAz4PEtsIQ0INpHle9tXE/Qr+ZW3kc6QcA/WV
	 bCxeH+yVlB3PiEUErPCIJXYyuPEmra7GiPcW0hrBvUbTe3hOPuc8LqdhqdaIumTSOjOp7
	 ExL9E1QJm43d1Sv3i1K1Oa6sMLkourQWWdhob9tujgVWa+tNh1RUCWdAIit2wmedg9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mqZR/i/fnuez2oNfg8HUPFy8CNCanQ4Hn19K3UGOOEo=;
	b=FKywTGsbyiHdlxzP87muRvFsuq+l2Sve9QDp6aTbQxtOe6RiiCuT6jg3NOvLvE+DJqM7
	 AcVIdRFtrH/V/G/JPNvNWnnFxIcef/vSmKmyGvucTcyG0obUV09WRJSpnYzEzSRLEHZFh
	 3FbIDytgV7FucnZKd/ItknlnT4N3zxahBF/KiojatbTxcXHoYJptfNXLzM1b9/xETwPyP
	 QBPBjn2uH6NeeQUqPKp4CbcieG6FRoBXApYvuMAJ0K1p8OVHEZzhltDvEKHM6gaAdRXzZ
	 E4A3CQV4SOniJuMEcD84eyDEQCIUC9auL2MV6FKRrKC1MCyggkiIvIuZoOmMg98hIJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aUE6A/rl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85AB606B361;
	Fri, 13 Nov 2026 17:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUE6A/rl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9391F000C8;
	Fri, 13 Nov 2026 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590549;
	bh=mqZR/i/fnuez2oNfg8HUPFy8CNCanQ4Hn19K3UGOOEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUE6A/rlTFT80ceN1+tHvyBWDOp5jQJR/jg027rhXDJcoHesqctrFCjpoueRsFC+k
	 +IYsY+wds+6fgzViBwmP7CRIMwMGq/ePMGqLmNoNNnXhvN58m11p5X10bNGJYvWGKK
	 Gj+0vkA1OQLfs52e2tn1o97L+/lxDizN+8SSP7js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 487/686] soc: qcom: pmic_glink: Fix device access from worker during suspend
Date: Fri, 13 Nov 2026 10:50:20 -0500
Message-ID: <20261113153837.452977492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 7d0767c5cd878707fd6711023731549c83563840 ]

For historical reasons, the GLINK smem interrupt is registered with
IRRQF_NO_SUSPEND flag set, which is the underlying problem here, since the
incoming messages can be delivered during late suspend and early
resume.

In this specific case, the pmic_glink_altmode_worker() currently gets
scheduled on the system_wq which can be scheduled to run while devices
are still suspended. This proves to be a problem when a Type-C retimer,
switch or mux that is controlled over a bus like I2C, because the I2C
controller is suspended.

This has been proven to be the case on the X Elite boards where such
retimers (ParadeTech PS8830) are used in order to handle Type-C
orientation and altmode configuration. The following warning is thrown:

[   35.134876] i2c i2c-4: Transfer while suspended
[   35.143865] WARNING: CPU: 0 PID: 99 at drivers/i2c/i2c-core.h:56 __i2c_transfer+0xb4/0x57c [i2c_core]
[   35.352879] Workqueue: events pmic_glink_altmode_worker [pmic_glink_altmode]
[   35.360179] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[   35.455242] Call trace:
[   35.457826]  __i2c_transfer+0xb4/0x57c [i2c_core] (P)
[   35.463086]  i2c_transfer+0x98/0xf0 [i2c_core]
[   35.467713]  i2c_transfer_buffer_flags+0x54/0x88 [i2c_core]
[   35.473502]  regmap_i2c_write+0x20/0x48 [regmap_i2c]
[   35.478659]  _regmap_raw_write_impl+0x780/0x944
[   35.483401]  _regmap_bus_raw_write+0x60/0x7c
[   35.487848]  _regmap_write+0x134/0x184
[   35.491773]  regmap_write+0x54/0x78
[   35.495418]  ps883x_set+0x58/0xec [ps883x]
[   35.499688]  ps883x_sw_set+0x60/0x84 [ps883x]
[   35.504223]  typec_switch_set+0x48/0x74 [typec]
[   35.508952]  pmic_glink_altmode_worker+0x44/0x1fc [pmic_glink_altmode]
[   35.515712]  process_scheduled_works+0x1a0/0x2d0
[   35.520525]  worker_thread+0x2a8/0x3c8
[   35.524449]  kthread+0xfc/0x184
[   35.527749]  ret_from_fork+0x10/0x20

The proper solution here should be to not deliver these kind of messages
during system suspend at all, or at least make it configurable per glink
client. But simply dropping the IRQF_NO_SUSPEND flag entirely will break
other clients. The final shape of the rework of the pmic glink driver in
order to fulfill both the filtering of the messages that need to be able
to wake-up the system and the queueing of these messages until the system
has properly resumed is still being discussed and it is planned as a
future effort.

Meanwhile, the stop-gap fix here is to schedule the pmic glink altmode
worker on the system_freezable_wq instead of the system_wq. This will
result in the altmode worker not being scheduled to run until the
devices are resumed first, which will give the controllers like I2C a
chance to resume before the transfer is requested.

Reported-by: Johan Hovold <johan+linaro@kernel.org>
Closes: https://lore.kernel.org/lkml/Z1CCVjEZMQ6hJ-wK@hovoldconsulting.com/
Fixes: 080b4e24852b ("soc: qcom: pmic_glink: Introduce altmode support")
Cc: stable@vger.kernel.org    # 6.3
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260819-b4-soc-qcom-pmic-glink-fix-device-access-on-worker-while-suspended-v3-1-169b00e0d9d4@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ sashal: Adjusted SC8280XP hunk context for the existing payload parser, which lacks newer Thunderbolt/USB4 notification handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink_altmode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/pmic_glink_altmode.c b/drivers/soc/qcom/pmic_glink_altmode.c
index 7f11acd33323b..22e4c1af745c8 100644
--- a/drivers/soc/qcom/pmic_glink_altmode.c
+++ b/drivers/soc/qcom/pmic_glink_altmode.c
@@ -303,7 +303,7 @@ static void pmic_glink_altmode_sc8180xp_notify(struct pmic_glink_altmode *altmod
 	alt_port->mode = mode;
 	alt_port->hpd_state = hpd_state;
 	alt_port->hpd_irq = hpd_irq;
-	schedule_work(&alt_port->work);
+	queue_work(system_freezable_wq, &alt_port->work);
 }
 
 #define SC8280XP_DPAM_MASK	0x3f
@@ -346,7 +346,7 @@ static void pmic_glink_altmode_sc8280xp_notify(struct pmic_glink_altmode *altmod
 	alt_port->mode = mode;
 	alt_port->hpd_state = hpd_state;
 	alt_port->hpd_irq = hpd_irq;
-	schedule_work(&alt_port->work);
+	queue_work(system_freezable_wq, &alt_port->work);
 }
 
 static void pmic_glink_altmode_callback(const void *data, size_t len, void *priv)
-- 
2.53.0



