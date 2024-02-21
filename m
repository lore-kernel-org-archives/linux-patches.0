Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212B27BB1F;
	Wed, 21 Feb 2024 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524948; cv=none; b=hmO9St8LokgjVc8rZT+xblz6Z973IlbvR5n9+KPMWWw2TW8NYrF5SGdB0XhyYPtokWfBjZ7MlxOJuogGORpgJGH6IoENIqWGLqFG2lLo0UeZiAurYNrRdzKX7IEwqu/ZJQUvwiy4lHhQx4xZSqKnD1vBCoJmdxlUgG773L6InD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524948; c=relaxed/simple;
	bh=4zKIUcfsPfQkYowtx5OsnIlq00Bbcq1Okb5McTTp3SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdO4k4y3CyKhPgsfgSga/bgftaBdYss3J7p87Zf13YGkMwqZmO/wPcUywF41lqAiiIVsRd70AjSxx8IH2f4lA1adpfyhezEN03kYCicC/97K4HEa1hXUAKwIlngAufbIYOmBm86JDxZYFXi8yUoNgUoOSlxxh6qOEHtjkdWWmuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sf8o+9F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sf8o+9F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589B8C433F1;
	Wed, 21 Feb 2024 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524948;
	bh=4zKIUcfsPfQkYowtx5OsnIlq00Bbcq1Okb5McTTp3SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sf8o+9F+REUH5ve9DwNrBjr4CzvcwcH2w2PianJlDwiKZcMg35n4EAoU/3zdGe0Bh
	 54RKhhm5nkC2hREp2apOZpRvmon94C+kZ7JNCx21kjRGFAeBGfA0lf4HLZNS5CVfg/
	 goabW29R+yy59M1krmeCE+mmQjKcydAcRHpESgOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Christian Eggers <ceggers@arri.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/267] units: add the HZ macros
Date: Wed, 21 Feb 2024 14:05:46 +0100
Message-ID: <20240221125940.233681045@linuxfoundation.org>
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

[ Upstream commit e2c77032fcbe515194107994d12cd72ddb77b022 ]

The macros for the unit conversion for frequency are duplicated in
different places.

Provide these macros in the 'units' header, so they can be reused.

Link: https://lkml.kernel.org/r/20210816114732.1834145-3-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 3ef79cd14122 ("serial: sc16is7xx: set safe default SPI clock frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/units.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/units.h b/include/linux/units.h
index 4a23e39acc7b..a0af6d2ef4e5 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -4,6 +4,10 @@
 
 #include <linux/kernel.h>
 
+#define HZ_PER_KHZ		1000UL
+#define KHZ_PER_MHZ		1000UL
+#define HZ_PER_MHZ		1000000UL
+
 #define MILLIWATT_PER_WATT	1000UL
 #define MICROWATT_PER_MILLIWATT	1000UL
 #define MICROWATT_PER_WATT	1000000UL
-- 
2.43.0



