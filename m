Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD81A37F011;
	Thu, 30 Jul 2026 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425721; cv=none; b=Ddc39yAC0EiUo+HA6QRWsDIOoLvuVl5kmodXjwvUHm13G6PU6+EygCg7J0ZnDa1Qnq/BAxZqFmFfHzqOT9zqxdb9zSpDFttusA+oWNlzCXXFsdKo4DMP4dL/fukZT61hIlLp2pr4OkKB8XvZ/uqkAFO41m8U6YBC0MVZtzdGBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425721; c=relaxed/simple;
	bh=r+KrxZZQnum3198YW1Alt9+grzQ5CrG11mptpHMR9eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6NFszmJTds7ZN5hFQcPyegNZ9l8Q6FPmIZ32QNV579WrlTiNmzskzbqtq9m8VSR+RJazw66HYfU9wG+NcZXNRLNGiPgNLo5dFXXVE43SBzPspDTeD8NENl3g4wRmG6pHJbS18fvnWU5x125Ghl7GHZcPIaKlNiwphXuYgxpuS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7yHA/7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7yHA/7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1671F000E9;
	Thu, 30 Jul 2026 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425720;
	bh=Ca+HN6MgFUCmUvim3mbrXXhvMO6sUOGtpDNF1JpjYok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7yHA/7HV+w063WlvA6gF8Jg28F7GmWSwdoow7GdlMqcZezC3GsO0wlw5PC9y+7/L
	 bS6XK0xcF5361bRxBBIeeQ+ihZxaWBiLwIDZ8YSUh7Y2H/blrI4oSrjctZuIrAt6h/
	 qqfBfHLXHx5S6G21WHcG862JwM5t4eoDsNJM7Di4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/602] hwmon: (asus-ec-sensors) add missed handle for ENOMEM
Date: Thu, 30 Jul 2026 16:09:19 +0200
Message-ID: <20260730141439.480564237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit 9813c1f49efeadbcb17e4a41972350ac783f9cac ]

Add missing return value check in the setup function.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260712130602.1256700-2-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index d08abd1adc0812..ad1a2ff618a38a 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -1064,9 +1064,11 @@ static int asus_ec_probe(struct platform_device *pdev)
 		if (!nr_count[type])
 			continue;
 
-		asus_ec_hwmon_add_chan_info(asus_ec_hwmon_chan, dev,
-					     nr_count[type], type,
-					     hwmon_attributes[type]);
+		status = asus_ec_hwmon_add_chan_info(asus_ec_hwmon_chan, dev,
+						     nr_count[type], type,
+						     hwmon_attributes[type]);
+		if (status)
+			return status;
 		*ptr_asus_ec_ci++ = asus_ec_hwmon_chan++;
 	}
 
-- 
2.53.0



