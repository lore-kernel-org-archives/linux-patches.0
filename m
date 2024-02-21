Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9764F76037;
	Wed, 21 Feb 2024 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523707; cv=none; b=aVG0vsGNxiGWUTH50e4foZGJQnyEcwK7YiwWvXhUqacpr6l9sZlE0xKDuJncvOXjgeroo9ITrq7OUca8p41fd8cZMuX07gJgPJ4LeknTmIHZ61PmAI5V4QWxNiqelt6Yl4STT4Zowky8rpaAdHOCr+PSSAhaneXdl6F7dgAQG0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523707; c=relaxed/simple;
	bh=XIrcZKjgp8yRJI9jT31ORjyv55gpB1IjGGfYu/t8gCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q01p3fWF/yp3yOSvFGEocnkw3r2SUORn/hJQ8yCTptrf9+FuxRPykZQiPMpwwb8SqoZrw/K6yzofl2ZUo9rFJjZ0T6/wiqM8BqUkufzcDRBMrJFwVuR8bofGk57sAb8QhC22OJN93+vo768fYBAlldWwxr9HrMOykICqSOIpUtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qa4Gwyzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa4Gwyzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7103C433F1;
	Wed, 21 Feb 2024 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523707;
	bh=XIrcZKjgp8yRJI9jT31ORjyv55gpB1IjGGfYu/t8gCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qa4GwyzfRA2KSSe+1R+ZPqz9+78zVkjoUwI5jc9uKtnBsVPNaCRBbTCTnvM7berU1
	 QaRKwL1DLU9W3XkSM7QelQiTGQKTKxTQ/wnokn7D0mcJFwXnc6MU8pOGQm3KCoLzJJ
	 zKYqLXxktvTzQPCbEkRC/+8CznQR1lNu/vNha9oM=
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
Subject: [PATCH 5.10 008/379] units: add the HZ macros
Date: Wed, 21 Feb 2024 14:03:07 +0100
Message-ID: <20240221125955.168317591@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 62149b5082e1..b61e3f6d5099 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -20,6 +20,10 @@
 #define PICO	1000000000000ULL
 #define FEMTO	1000000000000000ULL
 
+#define HZ_PER_KHZ		1000UL
+#define KHZ_PER_MHZ		1000UL
+#define HZ_PER_MHZ		1000000UL
+
 #define MILLIWATT_PER_WATT	1000UL
 #define MICROWATT_PER_MILLIWATT	1000UL
 #define MICROWATT_PER_WATT	1000000UL
-- 
2.43.0



