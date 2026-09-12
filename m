Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18507379C38;
	Sat, 12 Sep 2026 10:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208283; cv=none; b=Lu9cwLvlU6JNDFUAwcgYDkJ+Ds4X6AUdC2w//0OTRJvsRkBC7DJPZ36Bz+3xTFArHomJcOSY35AdcjDdFVB5BRF0ZVPqfZgqGvUUkhz7zcjHMN7u0uVv2KLFHAWjb0y65gIYjR8Tnm2S8KU8gLKcVBZbXTyO1PXPAnpMgkKuY3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208283; c=relaxed/simple;
	bh=Vx5YLf9VyYJIkFR3RFlnduwC3FpFA+jMps9sdJCCFIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejZa5YyfyKHVkjqig8QjmHOltW3fnVZtfEJbwXmdGGcF9eSfZESHf/cBXaXKnUH+Y7+76EUkl+UxfdpDvQG+YuqOIfAEw/dFhr+lqX4XhIa+oUQfAFmduXWGXsaJT6z/MLF7V/g80GZWx6N7+YfqsERVKG2nEwFmEGAguOmBVzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXXsHPnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXXsHPnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7A81F000FF;
	Sat, 12 Sep 2026 10:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208281;
	bh=WCpEtcPLy8BoKu+LyrMTioACjKtZa/ibLuOoFO6MKDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXXsHPnj/IorXmFe2IQqxluQDqCBkEa7O6irM1vK56Zg5cGUeMDNAxBJpliX+lxjJ
	 +8C5N8uS7NXbhj+Bp/j82u7XtjLv+lkXxgt9SAc1CKLqQYWB+FXZI+suYJy7Ycb4ZZ
	 ood9QtvD8pT2ZukPcpab2/um2gkhiAX5r0CLBMtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Wayen Yan <win847@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0585/1518] thermal/drivers/airoha: Fix copy paste error for sen internal
Date: Sat, 12 Sep 2026 08:45:54 +0200
Message-ID: <20260912065636.661430102@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



