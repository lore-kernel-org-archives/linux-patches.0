Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062429;
	b=cYuYDHaouSURjWOrK0zowpcXi1+KDAsrq+hF5GcV9fdUwlXAPo5sNlsjZOOsOC6nHneh
	 f6xx5RTi8fvpiLA73BgCMpDnlQU9QXSA0zOKvdAZZtFxszYRoNiOIIAaQBSHUXdBNABPC
	 dDIv33/pB3jr/QK2XPVkE4fPfSpXJN0eOZaGU5oU8XzhKmeOM7cE9PkiiiUo80OVrwXVZ
	 77IhEsr0bCbRr11FeRQKeVnTgHqklI+Ju2HJIRXO/8SBgjqNSRLadcz7meg0vI8EakdJ5
	 MpVu7V+q3pH3m5wP9MtBPfl3L1eaZyfmArR7e1XMdAENIZ3Gy/25du2NOpaSdYlq6jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jxsavveWySlipUMLVcPh+waj/zlEapDfRgpq7nnh/rg=;
	b=suAavg2uGkugdRhl4s6CTelUErquYB+lvDDY7NplXluKlWDDOPISJwUDVlzgviVRjLYm
	 5UC+tJYQsOJ7/9iy/K8BsReF0Z1EfdNGMjNz6kTGVRDib+TQ4zCE11i4+o16cxgnEyNCF
	 tY3D++1biZIDSFc7WHPhqYp22a+4+gjUqUwvG47E1U8qGMU1bEVNuBDQpu0DVxWCzYrU5
	 /K//erUdnPWXzBNdDtSZw2JgXfdO4BDpTRshc2EXlYTBZIQB4RdPZkgGIQ/K+/A6fzM6O
	 OdKszsTzr1YuwcpxZI8bk7kbSB7fv/qJt1jNCP6q06wWMQ0GIG0N3H1Eb+emxJCau2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aT5trebM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E9B606EEA3;
	Sat,  7 Nov 2026 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aT5trebM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A51F0089F;
	Sat,  7 Nov 2026 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062428;
	bh=jxsavveWySlipUMLVcPh+waj/zlEapDfRgpq7nnh/rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aT5trebMwBipj3/JHaHD77o0K5zbiHJzp8U6xIHU9vj+2ze2H3GzCHvIGjwMDLGh+
	 YfabxiL7GFQWejIu8IGdxlHO6oz6rpvLFCRfK4tbZXSqiviiUbPj5B/JMFLUTDMwqu
	 lE8Ubgy5tTKDYeX5S3eXYRL0pshCNy8bf118RdwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1341/1536] power: supply: generic-adc-battery: fix status with no supplier
Date: Sat,  7 Nov 2026 08:55:57 -0500
Message-ID: <20261107135035.483266127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index aebc824aa2ede..43b735d4d49c3 100644
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



