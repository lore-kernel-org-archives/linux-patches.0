Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FCC1991C5;
	Thu,  6 Jun 2024 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683653; cv=none; b=gO3otPRUH9/xlUt95PGUmfP2UfOgSv7X0xbinGNHDOx4AM2WD1xK523Le6LCIvcoFu9juT4+7MWKwWe9WtV3mqyQ5UZEXx2EAQ22p5deFt6uaqoPYlBQ0IaPWC/z74vYztA9bd4QCLD9gOGcsE1kctC84cB4la+ycfyDaLEBZlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683653; c=relaxed/simple;
	bh=WZsxwi++ZO4bOFsSYxXjqiL0JZtOTKPpdHtPOHODqpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e98pFvGiaWX6IT3N9oc2r7W7JznhVoyjpErr+i+KweeWPpdyeC51V6ulTBUzmtMcv173ahKNDhkSFG5haDu3yAr1tPPPUpgTUV27C4sNDZsBx4VEfVUid926trQf2tEEMho5NJnQvLRkeq72OcGxrKzW2G+ipiYeGxu7uIlLLo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6NZeN0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6NZeN0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D17C2BD10;
	Thu,  6 Jun 2024 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683653;
	bh=WZsxwi++ZO4bOFsSYxXjqiL0JZtOTKPpdHtPOHODqpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6NZeN0wRwSz0U17ajzamsEZXqihuUK9hdMWJLugZacU+0hLO6qR/mJ1WwGgnf5Kw
	 /Bn3qDasX/SqPNZhSShRiS4pezayznDMt42lrjgSPPxZmsxcBcNAd3dcRyOK9KnJ78
	 f9QvcpvXfoLbrMZJaI8d8dmT3t8s2AqJOuOJK/oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Ruehl <chris.ruehl@gtsys.com.hk>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 471/473] hwmon: (shtc1) Fix property misspelling
Date: Thu,  6 Jun 2024 16:06:40 +0200
Message-ID: <20240606131715.251779906@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 52a2c70c3ec555e670a34dd1ab958986451d2dd2 ]

The property name is "sensirion,low-precision", not
"sensicon,low-precision".

Cc: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Fixes: be7373b60df5 ("hwmon: shtc1: add support for device tree bindings")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/shtc1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
index 18546ebc8e9f7..0365643029aee 100644
--- a/drivers/hwmon/shtc1.c
+++ b/drivers/hwmon/shtc1.c
@@ -238,7 +238,7 @@ static int shtc1_probe(struct i2c_client *client)
 
 	if (np) {
 		data->setup.blocking_io = of_property_read_bool(np, "sensirion,blocking-io");
-		data->setup.high_precision = !of_property_read_bool(np, "sensicon,low-precision");
+		data->setup.high_precision = !of_property_read_bool(np, "sensirion,low-precision");
 	} else {
 		if (client->dev.platform_data)
 			data->setup = *(struct shtc1_platform_data *)dev->platform_data;
-- 
2.43.0



