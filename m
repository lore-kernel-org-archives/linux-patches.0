Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFB537A494;
	Thu, 30 Jul 2026 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427355; cv=none; b=bBMlR5tVmUri/AUVUV1PE6G/rJQZBp8cCz9zPy2hp9DT7JVYC1PsnctTKrSc8ZPNGTXbktSMMLbXwoD+DmU03Yfpwf6R3iPehgQDhyA1+MMeQ0wasY+V+BHZbfhNk38W94h4qb7vz64da/TtrF7Gj1JffZgEXJaiy4HdtDu394w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427355; c=relaxed/simple;
	bh=CXu9ASNIFV046vbj5eZiRrewrm0KXaemvJJBuUcL3AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNRpI3ulR6N629bq9rebw9DMOwcVbKwNuFzr+saP+pQqIlCa+ioZFAMrlp5jeIyfmz/04OnWHHVHNhfnoDHbGbN/Cg8uBHxW3SwQLCkPd8oaIhal3ENiyKQ/I9xSA11TyzVj/hbPM8HYeIsMxoJhByBeI2RFPAqoe15APp8Qrws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWOnMCdP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWOnMCdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BCF1F000E9;
	Thu, 30 Jul 2026 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427354;
	bh=NSjvCZ4nBojY51YxTJEJWOcPB42lBhCp3nxEwC8ODf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWOnMCdPr2B8V0qNdEXZUEqsdMzaa3WoJ6W5Q02hpLu3JwxsJWYhnQOkMmgNHTjst
	 Su8tlJVf2+zWyDweh9YPLHIKchVVZuDUEFM8iBjJndykI+lpuWMMyU2/pUOoH6bDvQ
	 x3N2AvDoF3YvK4RP40ZpoIj6xLztR9/nZEoKHTX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/484] hwmon: (asus-ec-sensors) add missed handle for ENOMEM
Date: Thu, 30 Jul 2026 16:10:39 +0200
Message-ID: <20260730141426.547229285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ada7db8008970..95bf1670156ed6 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -1042,9 +1042,11 @@ static int asus_ec_probe(struct platform_device *pdev)
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



