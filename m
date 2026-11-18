Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027722;
	b=ZWEK7aCVuoDiKghxNXvcfXAgXhedhz4jqgJqu93HOGsnOz+DK6Q7VI3ZfvlfHmf98K0C
	 Ggd8z5L00TNWA4I7TyWY6/emqgutynItdPPdWRVjtJfX0fx2XC/r/ES7tYh1Gr0ixyI83
	 PUQNiVshC5rryhJtZD0c7kDle2IneXbPFHlqFaNsCTV21eMC7Tnz2jgWaBjdhQC98CODo
	 xhulm8WAmKhCgclg04dV0G9E4abszbhl8THHIy/0os6ag5kRAi+/BWCI3wdxTQMVrqa5b
	 RlBTIuqXqiR+YzFA4r+VUUqiI1WlwTbZSngLagfS99AksecQfnAJnjoFV/+3rp5/sTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q5gPzJ35lynKkl3WXzcYO2ob5LpSFSY9ZYJ9mf++YcM=;
	b=gouRiVAXOO6m8Q2Mbb1LV26p7LaQ/hS0gkjxtq5Gdfn+Z5BA+v7FoZM36xy2o6Bh+pdF
	 Mm95WIu/EbTHje0E1yL8kVMDknXiQSnuxkYLSfKsfkXOy58GY+Ux7lcI6UAJ/687eeF5j
	 iRAvLI0QQdUBXCE/E9a9gJbJ2mrNhcBnjAg5Sr/3kpkhdzc9JD8oo8Jpe4FatQTVfhk0w
	 R469m6IR9wlzRHYvdDjUqfRmImdsCqJa7hnULdHDYRqNl4wRFKuCPBIAyMAWP4aU0TqDY
	 mqFhhibGZ+WKXaTbaAjNzBj4MFkMYj3L9rH3EKAzABw0ybg8R2vHIwPXvRRfvcK28ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAx9nwx0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6957C606A335;
	Wed, 18 Nov 2026 18:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAx9nwx0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1351F000C4;
	Wed, 18 Nov 2026 18:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027722;
	bh=Q5gPzJ35lynKkl3WXzcYO2ob5LpSFSY9ZYJ9mf++YcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAx9nwx00+vI0zFJQm0/StDMiWWB1qbsB+2kq5Z1c6rBZ+bRMCGHXBF47/PDVC6kJ
	 yjrC4UGLVPkIu1N8Tel6peISBmkC+bEzIgDdzhjYFbQFA6ROOnyVR3JXvHS+wf3zCZ
	 svXVv5JoxLKC36QmptxSFPkikTvwcoPi6gCdXL8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1890/2151] net: lan969x: fix DSM calendar for empty taxis
Date: Wed, 18 Nov 2026 16:00:25 +0100
Message-ID: <20261118150230.643190304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



