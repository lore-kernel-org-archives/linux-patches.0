Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68420442139;
	Thu, 30 Jul 2026 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423897; cv=none; b=QBouZY0AdnnV3RgPyy36nDzkHFELL/A6ZNFZ1urLA0UertVVdVpadypW8PVlut7XWm4BlI3Gbtxohk75jNtRnCjsAYaKSOWVSzv6CqTmeNc6ea7ED9lBWuhMmOTcasg2UhKonBrNUjXjBOVHcxujzgy9x5oGPNgsNJYiEyXlb2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423897; c=relaxed/simple;
	bh=c8hWg6ftDot95p6Cj4erjMn4VzIKv49JDi9wovLiFLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPqEL2MkIyxmGgWBVGfya+5Tfd3lA9wlqBd+JBDRnrt5RIMSICj53ch4T1h4tUelepsWXfxMz59A6GH7Jjd9X4u2zK4Z3vkq7KUVjSKxcNeLN5i0mikDGxjQDfyWi0ZX6IUOG5Sy2iucOqNzP63C8KswxCqbMKs1vybR2ZNn7zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRLb74Pn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRLb74Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB2B1F000E9;
	Thu, 30 Jul 2026 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423896;
	bh=TRchT6CTKeylPGNHcvDtHVcUaR3Ce4aMsePx+OBqkek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRLb74PnkODilBYZX0I/YcneHZyVxf+jq65NP4CLscpS9k62wKxPFn1Tih5qOhn7Q
	 nvkegBU6NIgqSOqlgSi9Oxg9nogLQcszNtkXrtXDn+M6ag2YVqjynv8gXYg3Pjarnn
	 bd9WXnS671C/TYHs0uP92DLPiBmzft/pAzG8O4us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/675] hwmon: (asus-ec-sensors) add missed handle for ENOMEM
Date: Thu, 30 Jul 2026 16:08:53 +0200
Message-ID: <20260730141449.457394548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 52986b64881eab..13fd212ad40407 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -1353,9 +1353,11 @@ static int asus_ec_probe(struct platform_device *pdev)
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



