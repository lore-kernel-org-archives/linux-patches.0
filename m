Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1669041DDE3;
	Sat, 12 Sep 2026 10:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208278; cv=none; b=ROlAUefM6NxpNTMBJagwwDKFV62No1wZ+YwHYCJ62tGN3r5/1vIjn1lAf3yRJ/+vCevGFUrC781RITc8hYTK7l9Jhh+cXbtTrjqYPpO2i1GuRa20SQIqpEFtGmBHel+5JOFCY/D2HTxlXpwJlsrXOTSBDbwVr/tZ6dGg5/zZaZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208278; c=relaxed/simple;
	bh=Hou4rDx03xHwHiKSGYhbQ6FAs3yxfGsU5wFbN6XEdw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TaaThLdZloNhNltA+LLKYRwnMyNMBGpHUClbCLEAM2DpLKAWm1jrAohfZ6AoDMvtgenPsOQ6taP8KPztcBwcQfGyDRZVAuiBiVU2vFC8L6RYdu3xcHw2cKz28syqLZDMJdxyF5ppbnWj+fSXy/hQ0zBqywtQU6T9UBjxgJTrNI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVdBmRlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVdBmRlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3B51F000FF;
	Sat, 12 Sep 2026 10:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208276;
	bh=qJ7gaKycGQUw6UD3Eof+v4DtjiERyUm7iyvBDXwd2nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVdBmRlKYk1crMDllRljpkCDlzjkFMcosZKOHFcwOmN/VWctNJIE0dSkZd4un1GMG
	 yHmouMlBl3QeHDvKx3Ry4RZ3yPDFCF7DycbIHPI24ez14HUMra9Hk7ECRu0LebSVg0
	 xDXgk3rpqfmtJH+XP355kqQilIXzGtskeOEawogw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Wayen Yan <win847@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0584/1518] thermal/drivers/airoha: Fix copy paste error on clamp_t low temp
Date: Sat, 12 Sep 2026 08:45:53 +0200
Message-ID: <20260912065636.636505121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 251621813fb4275e24431f9a0690aec9b15823e7 ]

In airoha_thermal_set_trips, there is a copy paste error on clamping the
value for the low trip temp point. Fix it to the correct value and actually
clamp for the low variable.

Fixes: 42de37f40e1b ("thermal/drivers: Add support for Airoha EN7581 thermal sensor")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Wayen Yan <win847@gmail.com>
Link: https://patch.msgid.link/20260702094846.17325-2-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/airoha_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/airoha_thermal.c b/drivers/thermal/airoha_thermal.c
index b9fd6bfc88e5e..439aa011b75c7 100644
--- a/drivers/thermal/airoha_thermal.c
+++ b/drivers/thermal/airoha_thermal.c
@@ -273,7 +273,7 @@ static int airoha_thermal_set_trips(struct thermal_zone_device *tz, int low,
 
 	if (low != -INT_MAX) {
 		/* Validate low and clamp it to a supported value */
-		low = clamp_t(int, high, RAW_TO_TEMP(priv, 0),
+		low = clamp_t(int, low, RAW_TO_TEMP(priv, 0),
 			      RAW_TO_TEMP(priv, FIELD_MAX(EN7581_DOUT_TADC_MASK)));
 
 		/* We offset the low temp of 1°C to trigger correct event */
-- 
2.53.0



