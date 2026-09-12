Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8474F2576E;
	Sat, 12 Sep 2026 07:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199898; cv=none; b=ghIeBAdugUhaOcno4OjdDp8W2exAd5ISro9O8PhIcJn3kU5pZZ4en5E7lXt9L6jNBr2RCFPC8C/AVQsroysiFhTaGThz7vj6JrQUqoduMYaID9XgWTxsU63+fP97rdhkXqG2YYbqs7ESJkkqYip/arfnce2lwwqEgIOm3BPC6mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199898; c=relaxed/simple;
	bh=VmPeRL9BtLna9VPUSJmKdedHBT+WSBpf7/wM2QXYDf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ru05l9ZElf+EG6DJupy4+gz6NwXmoQqQS3/9WDoBwZTp0yarYixvGJjDXdx5FvyjRTbYmOkSJfYePpTsZi5SCZbYtsgggs+QVm/aTEOaMDni/3L6zSmYDAPugMWjMX3w6U4qMs7zdJWM6uSVY8nZq3Bf/vYDtkkvVegteKH4onU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mzkix66a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mzkix66a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAF81F000FF;
	Sat, 12 Sep 2026 07:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199897;
	bh=5U1R1o8rSXOaxmsLHofwJRWAd4XzNnBMetZe+tPp01c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mzkix66axE0WpIUTvKW+77QzZZh8J7MiEOhdURXhsT/Pd2FmhpjG8WyxMK69wbRH7
	 jL9GV/i5HvjlTVl2keWpakRPU8ShR1Bx9rk1GMWKBBzkHxcG23a0eFr8UJ5iZxX4Qj
	 5xgpQEdu5aLJwkawhPAEesXJdDs7J1uhtVv+xZOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Wayen Yan <win847@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0677/1815] thermal/drivers/airoha: Fix copy paste error on clamp_t low temp
Date: Sat, 12 Sep 2026 08:40:27 +0200
Message-ID: <20260912065704.779739009@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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



