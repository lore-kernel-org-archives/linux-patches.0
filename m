Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DF3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFA2C433EF;
	Mon, 30 Jan 2023 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088837;
	bh=Dtm1TnpOmr2KvuNJLcKbBBW7XQLvD2VLM+AndWxBQc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSvpOhSbIF7szC+GuoPUWMAt1dgJ7hpk1W9vGaYnGq0A+tKx8XHEbAOko2WR0iU7d
	 LemSR4fvG3GTXGxq0V5DLI/genj9Da1XLTiO8Yn5sLVhozI0DkntSutGwiv1b1+86b
	 jQyyYTHffNaxEz3OwYBP3v19qPI3HvbPbPN42vQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/143] units: Add SI metric prefix definitions
Date: Mon, 30 Jan 2023 14:52:50 +0100
Message-Id: <20230130134311.521025448@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 26471d4a6cf8d5d0bd0fb55c7169de7d67cc703a ]

Sometimes it's useful to have well-defined SI metric prefix to be used
to self-describe the formulas or equations.

List most popular ones in the units.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: c8c37bc51451 ("i2c: designware: use casting of u64 in clock multiplication to avoid overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/units.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/units.h b/include/linux/units.h
index 92c234e71cab..3457179f7116 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -4,6 +4,22 @@
 
 #include <linux/kernel.h>
 
+/* Metric prefixes in accordance with Système international (d'unités) */
+#define PETA	1000000000000000ULL
+#define TERA	1000000000000ULL
+#define GIGA	1000000000UL
+#define MEGA	1000000UL
+#define KILO	1000UL
+#define HECTO	100UL
+#define DECA	10UL
+#define DECI	10UL
+#define CENTI	100UL
+#define MILLI	1000UL
+#define MICRO	1000000UL
+#define NANO	1000000000UL
+#define PICO	1000000000000ULL
+#define FEMTO	1000000000000000ULL
+
 #define MILLIWATT_PER_WATT	1000L
 #define MICROWATT_PER_MILLIWATT	1000L
 #define MICROWATT_PER_WATT	1000000L
-- 
2.39.0



