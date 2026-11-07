Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064976;
	b=1Y2X8GbwDtANO+Rfh/VZ/Xh6HIdddDzcawN7O4K0g63BHK0QKjI16l6erpJXxb/UIZzZ
	 cCTtjCux6viALLeGvVPqSQoUhoR4BjttIRGQ5/yyxwQ0X/uM+RvQJFlbkt8MxwbR4nIf8
	 OzP6DKW5NuL2hWsUi9VVKB4kAFsOCI6W3cei2X2X7ltq1oYqt0IqJmaTrfIDuxoHQtpQS
	 RJeI98ZgJtTCxbqksVtnk/+OXTWlNwWll3b5BiDYsIkM/ygR76maIaRIpIV+hy/TLpGyj
	 OR+FyoRQuWBzmj+/qUNBpyggybEdm2MgHhnLdCJxeCGbWGrzLtnh9Y3hLIxdZEA37sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/FcVeubTK6uidqVtWRvnH5e1Cmj4H7HHq6408DyybM=;
	b=TxSB6kC7GdLwr/aVgdwPrbjx7h5DAZTKxgDaShGYLDWUWDt2kDv0eFuznUK+yvzCrpY8
	 ap/cysfnvKHpuOZCCGrqcRx/XlvKcBpIqU/GdrpDjx5lz6dCvOSV/USgPs8R+RYEitjPh
	 cYclplugQkj3R4cqBZxbr5Gd7CS1cJdcL2VjwlMMuIYuA86Rrm9ZofDDuB+pW0nQ8sWDW
	 iWSCshyhFxfMN5q4vFEM+yniDvyQKPSCERBLjMOPNI6SnuU8URs89eRHyjOEufRUoVM7e
	 uLs+Z+DAm/Vu4IJyxnRbvSwwIpWNAxiB691Nmt2Y15aumFhnXIauHbwDvB/Pk2Q1KBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnTnmNfK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50194606A9DA;
	Sat,  7 Nov 2026 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnTnmNfK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71851F0089F;
	Sat,  7 Nov 2026 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064975;
	bh=C/FcVeubTK6uidqVtWRvnH5e1Cmj4H7HHq6408DyybM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnTnmNfKrAUt+sbS6hs8c6I1G8V3kgg1OMWB4wdID5pVtNLa2nK9yrG+hFdbaYTm5
	 09uAFtP/cTP+6CQeOokaS5UoswY0+BVIibyNmoiGtAMyq7vEbrOzNFqCiPWfdCwR5k
	 q0V2CTyKBwUO0kPu7cszIhPL7drknZXNce6tukdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0854/1257] power: supply: generic-adc-battery: fix status with no supplier
Date: Sat,  7 Nov 2026 08:52:30 -0500
Message-ID: <20261107135002.920041983@linuxfoundation.org>
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

From: Tim Douglas <me@timdoug.com>

[ Upstream commit 8ae5a3f40045ff486826ed6b6a83e39a0f380073 ]

power_supply_am_i_supplied() returns -ENODEV when no registered power
supply supplies the battery. generic-adc-battery's gab_work() tests this
return value as a boolean, so -ENODEV takes the supplied branch and
reports CHARGING, or NOT_CHARGING if the charge-finished GPIO is asserted,
instead of DISCHARGING.

This was noticed while bringing up an out-of-tree Linux port to the
WikiReader: the driver reported CHARGING on a device powered by two AAA
batteries with no charging hardware.

Only a positive return value indicates an online supplier, so treat zero
and negative returns as discharging.

Fixes: 46cecd130d55 ("power: supply: Fix power_supply_am_i_supplied to return -ENODEV when apropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013022153.6707-1-me@timdoug.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index f11a5c794e7e8..937b84e04ba27 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -135,7 +135,7 @@ static void gab_work(struct work_struct *work)
 	adc_bat = container_of(delayed_work, struct gab, bat_work);
 	status = adc_bat->status;
 
-	if (!power_supply_am_i_supplied(adc_bat->psy))
+	if (power_supply_am_i_supplied(adc_bat->psy) <= 0)
 		adc_bat->status =  POWER_SUPPLY_STATUS_DISCHARGING;
 	else if (gab_charge_finished(adc_bat))
 		adc_bat->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-- 
2.53.0



