Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047311;
	b=aleRsxalP7YV94hgobcVq3EZRmcv//2HhtPZ/z40bfG0o0GzCDgMnXp3XidylapJOSOy
	 gA3CNgqbOBWl3iY/V0RQeJ5G0G30MpacKGOnfRyhyqkDjOW4idmoLBPB9uyzxEBPNF1iH
	 9RF0LY8sn5fg4lzFJ+AwiNghsyWOXH+XnPoPTFqrQcROCNP4l5pSCXYfjfuGBnihi1j2X
	 2jx/Q4mmSsKfGO1IfWqpenjYmO6KS2PHiPIv0IMQNyxO4ntS7knnF58sEN2Nbr1gHKQsV
	 01X8jNTbdxkNf/OKb3t13dg9cpriLhDk8SziMXiGufLdVo0bPR4OPH+ouyxd9QucK1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rmbJnW4pG2UScpmkCg2Z9OZQl1bm6R0nbDLpVFZ0lP0=;
	b=kzb2atz0FXfRM+GHi6jFSqgj5kQpOYVcfmy3khuULmp1P4M8YPwTSk8D5ZaBKH6EGPPt
	 bMS/ZZ0Nsmr8FcoZJEiQgRqBCfsqhZYEuJkzwbHkR9rKWmk6uelmL0JWqY4s51IFpPa09
	 z+oNQAg8y6PLbUg+lR2hs6ggNjehnHPy9GnLSvNQ6zCKJFDQolAajpPJGpEAcDbSjOTKi
	 NW/YSLZMZmlP4jfQFqEQF7ZmAQ3xG+oyFaqRTsJafKmljX3S7oaUm/qXgV7SKLN5a/ZIC
	 WGP5q0Bng2eUyVAsV+jqmvOwAORq7nM3OnfwuEx+v2/ztudj2JCqfUtahorkZ/7SXDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1khCGq6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60524606A32F;
	Thu, 19 Nov 2026 00:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1khCGq6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD761F000C4;
	Thu, 19 Nov 2026 00:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047311;
	bh=rmbJnW4pG2UScpmkCg2Z9OZQl1bm6R0nbDLpVFZ0lP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1khCGq6kt7fR4sxZzKA3qSPubxD+ApcZZ6mzOn9gA6gze2i6Z+G/MsJ0fb70Uaig
	 VrBwNNCI/eIhtD3O2CfUVfJzr6rGn0nA5VjhfAowUtK4k6fjnqEVJBh0aRItYngacQ
	 12cDYpa6HeixmNF1XA5AKETCTWVREudCUTBv2T7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1591/2857] power: supply: generic-adc-battery: fix status with no supplier
Date: Wed, 18 Nov 2026 15:43:45 +0100
Message-ID: <20261118150258.657947085@linuxfoundation.org>
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
[ sashal: Adapted the direct supplier check to a > 0 comparison in the existing is_plugged assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 0af536f4932f1..33e151422d946 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -209,7 +209,7 @@ static void gab_work(struct work_struct *work)
 	adc_bat = container_of(delayed_work, struct gab, bat_work);
 	status = adc_bat->status;
 
-	is_plugged = power_supply_am_i_supplied(adc_bat->psy);
+	is_plugged = power_supply_am_i_supplied(adc_bat->psy) > 0;
 	adc_bat->cable_plugged = is_plugged;
 
 	if (!is_plugged)
-- 
2.53.0



