Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030794;
	b=5cDGnfOwGeNNtx68PeJAcNuHyIRA2vN+nk/4wA92l+3jjpvWj9wWxbRN2k0fhKq06aa4
	 jCx7/vlJzmx7I1szKPnM4pxLsL99GZLjvimiL675FdYWkSn57UVbxZQvpZFN623hWBDv0
	 dLAbRdeOxnlV8TamXLVd+3KiyMTT3tpJOsPm0KUbVf8lCCXOcY0Cl+5Z/tvatR8bR4eaU
	 FjMDZVTtpbp6GqSMTWnZ9bXICXtJ196HtdU5CFuj8Kq8d3hkXPD370hxrhvFAKJ/H0QIs
	 WHe/PcDfps6f53k/NYP2/YBOqk2qVlx+1f+85jeHL6+SxzUPYNYBrem9RDXRVMoyM5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4fy1GLMHAGMfWfgPkBASWWPGhheM47wYLme2qEcT9H0=;
	b=xHV+4XDq+JaeD23McWDMQ6O26CD7y0GDg3LE2AU8+b2FM9eJD6cczdddzY7DZbNq7hSX
	 Fj8eeSmVBWazcxlkkFeDHI92mT+HlSjPr880D4Ot7IgjgC68t1LZHXl4XGEOr6WvLgdUL
	 LFFDSY/jPb8Jr5OFW03rqqH1l6NOANx2q9UsolRullVKj10OfIRR4527+zsZtcP43gDt+
	 srs2srwnvh/PjXs82ECbW8q8eIvxT8J3abH8VRQKnOH/yV9CNfRcdc1+WJ8eQ65JsDu42
	 IaXnrukVsZK2pKV+/OghSoQUSnf00BUD8Csk5Ii2FvFGGtVUor4U6TZUYk4XcLfC69w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ifGrJ7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA2F606A92E;
	Wed, 18 Nov 2026 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ifGrJ7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310191F000C4;
	Wed, 18 Nov 2026 19:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030794;
	bh=4fy1GLMHAGMfWfgPkBASWWPGhheM47wYLme2qEcT9H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ifGrJ7tuNLbI2ZrgbWpY5ujWAWFLfK4cGnXgAszd3t1vuocSQbmt+nWulhBUSHpX
	 MVJuC8ATa8TC7HiU7d2Ds50AqrQHR97ZNMeL+Ufi2fygi+Ai+V3FTSuNOsjKTfrx9F
	 s+3RRnvq2w3N4bJKOLA+hH5se5HRbciyZXQiQM3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0829/1756] power: supply: ab8500_btemp: Fix event temperature reporting
Date: Wed, 18 Nov 2026 15:49:16 +0100
Message-ID: <20261118150042.515879148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 56f136b2d071d..082bd09cbedfd 100644
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



