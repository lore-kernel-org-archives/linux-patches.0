Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021528;
	b=n55edGriGnIHAkQgVjjELSc7RH0MDAjp4COwUYWXPQyzhqHs4KGTmvAwYHqouaNjakXv
	 3w3IVLnMFd+oNlDBjMpN35aD4OjIYT5U1F1F/jlGXtiDzPvwb2AnhLLVZi03OcKhOtI1W
	 iGmQsve41Lnj/aG+MY2Ajt6tkGBaZ+4OR91vR1T2LgJNSencDg2tFNYw5oFstPZwiusGM
	 5XO4NZO7/rP420jvKRMiuZ53/W7uKFNAxQZ0KkKbWZCfjQavilZ+kEA4KySFJMtfK2zVt
	 syyYI8hWr0D1XWBvqDlfEyeYniw5XnY+iqcC7AEqScKKB3ngElYypJ/EZXlfhvPyXuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCvNvVZrISLaTb5V7YZuHFckYjfSED4XpCAqDHqv/w0=;
	b=XdSfoY0hqugQYSVvamSD6hD4qNIMkUn2UYbcr/FnE1Jwb2FSDoPfR0eeB43eWg3bXKLO
	 iCxkaeOo6yYBfcEvB7gKIVKzXFCVwDf5EtqrWv0AIefBqrpuwenopARLwarFjBBDAA3/Z
	 3WZIsjpBA4w7uT48pyblgAGjPiB3cgmM5um03VBc0588FVDzi7OGLR5qJMoMlPKNLPJC8
	 98YUzbkMCaaUGo4NzhCqYffUUswr3fCySINmhyk1cjtQCCg9Z6lJhUszYM7HpGjDdM5fu
	 bB5IhSlOUKxCE7Udei1rrKksGmkzw00vh9xaZnKOizah3WB/8i8hzkF4aLkWnkpHe4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vgELZwzs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165A8606A320;
	Wed, 18 Nov 2026 17:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vgELZwzs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D481F000C4;
	Wed, 18 Nov 2026 17:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021527;
	bh=bCvNvVZrISLaTb5V7YZuHFckYjfSED4XpCAqDHqv/w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgELZwzsLKGr7oai0zT+ipy8OkzSpEBvWq7dAXY+r7i6FZN716tiKsPkNGrkSbptD
	 kMkhTHCpH0Bm4b3h9uUU+rViqzEUkA3Z4FwpPCmXQ2OISnZbT7+CvUByyPR0yKr9yd
	 j6oLpaXLVSVuOTc3CXRyo8b8+bTeNAkExDVwmvLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2339/2651] net: lan969x: fix DSM calendar for empty taxis
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118150409.308055037@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit a031ec9ff5a2e55867430e74e9b497fe844116ba ]

lan969x_dsm_calendar_calc() computes the DSM calendar schedule of one
taxi. sparx5_config_dsm_calendar() calls it for each taxi, reusing the
same sparx5_calendar_data.

Before this patch, the schedule is only cleared after the n_devs == 0
early return. For a taxi with no active ports, the function writes
SPX5_DSM_CAL_EMPTY only to schedule[0] and leaves the remaining slots
at whatever they held before. For the first taxi that is zero from
kzalloc(), so sparx5_dsm_cal_len() returns a bogus length and
sparx5_dsm_calendar_check() fails, which fails the probe:

  Port 0: distance 20 above limit 0

A later empty taxi inherits the previous taxi's schedule instead, which
passes the check, so only an empty taxi 0 triggers the failure.

Clear the full schedule up front on every path, and on the empty path
place a single idle marker (SPX5_DSM_CAL_MAX_DEVS_PER_TAXI) in slot 0,
so the update step sees a calendar length of one and programs one idle
slot into the hardware, matching what sparx5_dsm_calendar_calc() does.

Reported by a customer whose DT enables none of the ports in a taxi.
Reproduced on lan969x by disabling all taxi 0 ports in the DT.

Fixes: 5d2ba3941016 ("net: lan969x: add function for calculating the DSM calendar")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261020-lan969x-dsm-empty-taxi-v1-1-14790f1e7430@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/lan969x/lan969x_calendar.c  | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_calendar.c b/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_calendar.c
index e857640df185e..4442c0c1a957b 100644
--- a/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_calendar.c
+++ b/drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_calendar.c
@@ -82,6 +82,9 @@ int lan969x_dsm_calendar_calc(struct sparx5 *sparx5, u32 taxi,
 	struct lan969x_dsm_cal_dev_speed *speed;
 	int err;
 
+	for (u32 i = 0; i < SPX5_DSM_CAL_LEN; i++)
+		data->schedule[i] = SPX5_DSM_CAL_EMPTY;
+
 	/* Maximum bandwidth for this taxi */
 	taxi_bw = (128 * 1000000) / sparx5_clk_period(sparx5->coreclock);
 
@@ -125,7 +128,7 @@ int lan969x_dsm_calendar_calc(struct sparx5 *sparx5, u32 taxi,
 	}
 
 	if (n_devs == 0) {
-		data->schedule[0] = SPX5_DSM_CAL_EMPTY;
+		data->schedule[0] = SPX5_DSM_CAL_MAX_DEVS_PER_TAXI;
 		return 0;
 	}
 
@@ -167,9 +170,6 @@ int lan969x_dsm_calendar_calc(struct sparx5 *sparx5, u32 taxi,
 		return -EINVAL;
 	}
 
-	for (u32 i = 0; i < SPX5_DSM_CAL_LEN; i++)
-		data->schedule[i] = SPX5_DSM_CAL_EMPTY;
-
 	/* Place the remaining devices */
 	for (u32 i = 0; i < DSM_CAL_DEV_MAX; i++) {
 		speed = &dev_speeds[i];
-- 
2.53.0



