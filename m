Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E590F30F548;
	Sat, 12 Sep 2026 07:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199903; cv=none; b=EoF1vtcgv398MT7buXuwU8Xcqgr/oRtMfFjTXdaSvBzNTlgvinHnDespCafhqGmHiFH7sXan6U+gLSIi2GQ6D5TMnx7iu1slXSgxDvqJcVGIcmDZCbxy675wldxdHtOsrjf4fvDpdSEJVFN0rYWY9gPvYbykJ9PWhfsrR8UbbNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199903; c=relaxed/simple;
	bh=5Y0/cX/4B25ZpBM9Gzb/W34p9ZgW8Y0K3rZYUhAgniY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWZbj/WwNX4LjjqBltgl9qPPAOQfJ9mWyw1zMdUf6PCi0MVpkBPobUfExmStkTZw5D3CrxTMmxB0Z9e0evTpiFzI+Ueg+7asah0+r6Ju2Bn3R7cv2dciX6gR2yR+0YDJAcyPAaacSD370CgTDAdjby09SfQL/Y++DlVC6QXnBeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztnL3mj6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztnL3mj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA94E1F000FF;
	Sat, 12 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199901;
	bh=VD6ohk95XnImW1AMwWWaQS0sVw6VcaWDKMP0NOyYQ4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztnL3mj6euYY9b39Y3uIk6GTDHLokQU5fdklf8/frbZKMFSRKm/4L9mWlKTG8Jw+0
	 D8nt79A5cSSBxHpxmuZJL/sy0m4hj7x5IJNy8FTNb9+DkwzAbxKnnaWU+Y0Q3ggSMr
	 htu0g9tTvUeMWnyd6g9zx/K+tatuZpcpW80xKdCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Wayen Yan <win847@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0678/1815] thermal/drivers/airoha: Fix copy paste error for sen internal
Date: Sat, 12 Sep 2026 08:40:28 +0200
Message-ID: <20260912065704.804260625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 6791265d609549be55bb35b747c9648d0b570c12 ]

In airoha_thermal_setup_monitor there is a copy paste error on configuring
the internval for temp monitor. Fix the error and use the correct mask for
the sen interval for the EN7581_TEMPMONCTL2 register.

Fixes: 42de37f40e1b ("thermal/drivers: Add support for Airoha EN7581 thermal sensor")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Wayen Yan <win847@gmail.com>
Link: https://patch.msgid.link/20260702094846.17325-3-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/airoha_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/airoha_thermal.c b/drivers/thermal/airoha_thermal.c
index 439aa011b75c7..829a7327fc403 100644
--- a/drivers/thermal/airoha_thermal.c
+++ b/drivers/thermal/airoha_thermal.c
@@ -403,7 +403,7 @@ static void airoha_thermal_setup_monitor(struct airoha_thermal_priv *priv)
 	 * sen interval is 379 * 52.715us = 19.97ms
 	 */
 	writel(FIELD_PREP(EN7581_FILT_INTERVAL, 1) |
-	       FIELD_PREP(EN7581_FILT_INTERVAL, 379),
+	       FIELD_PREP(EN7581_SEN_INTERVAL, 379),
 	       priv->base + EN7581_TEMPMONCTL2);
 
 	/* AHB poll is set to 146 * 68.64 = 10.02us */
-- 
2.53.0



