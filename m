Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018628;
	b=xKkhIldr5cDFSPAU3rktpH0B0WnmSaL8q+0aG6xWm4IM6nCPF+xMIiZSDNI+ykxFmb1h
	 EIPs72ofEB7Jv3H5VHCrqsKRiLhc6doh50UbhbPWmKyv9TH5PwOvYwwmx5KMcH6hODRN0
	 po8KYbCj2o/6sqjO5syd1gYoAAGfk7DAYak0gn+aQJ8cSyaJ5shAFxrn4bapKAl1b06U4
	 keu3nrYHb82oOUXmVy3roemnALqX1r+nwcxGVGucpuOUK4eHFjpnZywmf/yIEmUofjpW/
	 jtUwngtOx+dU3n3d1XuZ9P6HjxMclmGmrZDP+46/xWGMD7yqVlZAkEPqotBjS9TkkSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9VGNMlXdHqNsEzohsJcjsoeBNAmGVd2JQlEpkQ0VOo=;
	b=ahigz997MJozt5Wc6KAjXYf6Vwng4plrK0mLHNsYKRiLoptcUXDuu3eNZcFu2b9PBZdF
	 xio1P7IQCFXUfDk7DyplHxpr+piRF6jb6LtIyuI+E1lOpE/66iDsQMwOZIlErubflLnJE
	 GU1hETvMS7EsIIQdZ6GDPH4dNk2Hc+N4JTCopyzpwA4PLZDhdTjYuL5uOCl9dts7y5H3T
	 g1y96ki9XyNFvwoWId5Z4+1QdhSaoJdiWZPSb1f3VRhZ5gkKcv5UZR+Cj7W/1rWLGiaXW
	 yajLjtoKFO0Sf9O1/Hh+dLVDa59Xq/JlWCUVnrkp5aX/GTGirIL4DymRVNjwGrL6nXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=md4xQGtr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91726606A320;
	Wed, 18 Nov 2026 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=md4xQGtr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04C11F000C7;
	Wed, 18 Nov 2026 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018628;
	bh=u9VGNMlXdHqNsEzohsJcjsoeBNAmGVd2JQlEpkQ0VOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=md4xQGtrHfPkXm+72Akxraspxv/lp6GrSrwnEI8GfkcQO/zfdP5yNc4Y5ziYcrMcn
	 +oJaR1GCqMKEKHDbvBkLVLbqpVD5bYh11MqFkl2Pte4WSQ+dsHVkBHzFmki/V92O8r
	 QbZXvxrttapeDd4dxvNoUPCOwPy94I7IUUwrcxWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1266/2651] power: supply: ab8500_btemp: Fix event temperature reporting
Date: Wed, 18 Nov 2026 15:41:46 +0100
Message-ID: <20261118150333.545204673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 95990cda8e42dda4bd3f1475d578323981bd8579 ]

The event-aware path initializes its local temperature to zero and
compares that zero against the thermal thresholds. Consequently some
events report the measured temperature after it crosses the event
threshold, while others always report the threshold.

Start with the measured temperature, clamp it according to the active
event, and convert to tenths of a degree only once. This path is used
by AB8505 and later variants.

Fixes: 1f855824757e ("ab8500-btemp: AB8500 battery temperature driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-5-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 90a61d9db72c0..8ed0246b44228 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -468,39 +468,29 @@ static void ab8500_btemp_periodic(struct ab8500_btemp *di,
  */
 static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 {
-	int temp = 0;
+	int temp = di->bat_temp;
 
 	/*
 	 * The BTEMP events are not reliabe on AB8500 cut3.3
 	 * and prior versions
 	 */
-	if (is_ab8500_3p3_or_earlier(di->parent)) {
-		temp = di->bat_temp * 10;
-	} else {
+	if (!is_ab8500_3p3_or_earlier(di->parent)) {
 		if (di->events.btemp_low) {
 			if (temp > di->btemp_ranges.btemp_low_limit)
-				temp = di->btemp_ranges.btemp_low_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_low_limit;
 		} else if (di->events.btemp_high) {
 			if (temp < di->btemp_ranges.btemp_high_limit)
-				temp = di->btemp_ranges.btemp_high_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_high_limit;
 		} else if (di->events.btemp_lowmed) {
 			if (temp > di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
 		} else if (di->events.btemp_medhigh) {
 			if (temp < di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
-		} else
-			temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
+		}
 	}
-	return temp;
+
+	return temp * 10;
 }
 
 /**
-- 
2.53.0



