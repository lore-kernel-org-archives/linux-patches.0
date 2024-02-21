Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD99B7E58F;
	Wed, 21 Feb 2024 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524941; cv=none; b=sxN7for4pHRow4q9C2aHFmdQBOKkYw9rHTW8M8vKmL0TXQUlMtycCSeCUFnUuUBva1dxx+vistXe+LUV96zmZK//LXsYIVXTR7a+wL4IgUvyY5xyHFWejXGjrQDmKQ0mkwNJZUK+tQwTg5R/kTKMOEkjy5yKU+Ds7kDIP/7HV4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524941; c=relaxed/simple;
	bh=n78mtXBf38NFbC9DY3q+rFWIRipZwAQpsHnkQ6YxJr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeFFoXv1J+STc3X5WrEAOkp6qzh0tvB/RqDak7qhIqkn3BRhiJrZPBVLQvM1unzOpvhF1Bo19Y+jE4rRqQkC0zeQa+ZIcl9skZxaaUwCX55YNa0z6berqG/3zIvOv10bE/AC6rp/ewDSuh01fqq5xlh2R2dipNtnib6qSYv3llE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOezubbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOezubbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C71C433F1;
	Wed, 21 Feb 2024 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524941;
	bh=n78mtXBf38NFbC9DY3q+rFWIRipZwAQpsHnkQ6YxJr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOezubbHitSWUUECZ6ULho9LADDQ0Xm7MYFqSkQL1dq2CdyUVKouKud7ijeGPrfZd
	 /PTyScft/ZrKVKA+0TtFnlSrVxgkFfbyjvHwTGdE8GF5vxNhfsGrdg2Jm87GiTjjHQ
	 Am1io1J7C1RMtYLYTZV8dyWeknK6Tu/dFgs/aboA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/267] units: Add Watt units
Date: Wed, 21 Feb 2024 14:05:44 +0100
Message-ID: <20240221125940.168645775@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 2ee5f8f05949735fa2f4c463a5e13fcb3660c719 ]

As there are the temperature units, let's add the Watt macros definition.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 3ef79cd14122 ("serial: sc16is7xx: set safe default SPI clock frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/units.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/units.h b/include/linux/units.h
index aaf716364ec3..92c234e71cab 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -4,6 +4,10 @@
 
 #include <linux/kernel.h>
 
+#define MILLIWATT_PER_WATT	1000L
+#define MICROWATT_PER_MILLIWATT	1000L
+#define MICROWATT_PER_WATT	1000000L
+
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
 static inline long milli_kelvin_to_millicelsius(long t)
-- 
2.43.0



