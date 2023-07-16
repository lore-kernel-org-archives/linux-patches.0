Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C228E2
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27889C433C8;
	Sun, 16 Jul 2023 20:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537602;
	bh=rSR415NwhYXaeph6Ts+kMRDX1fKWB4KQPtEIoO3Rshg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZhHz4G7SsI3SDu1/6y4D47I5kIFb3CSoyx5zXGEnVYA0zbKjjzV6Ja3EbRx/603K
	 kjn27GUdc4Ys/YnWerPQWUSq4cJ/49qxNaJF0dYV8F+fqnkRYFprz7UeTGaAjO0RAc
	 aiAfjMeCXIYzcpjhUldIFUw0VV6bwH5nrG7Wgl+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Andi Kleen <ak@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Guenter Roeck <groeck@chromium.org>,
	Ian Rogers <irogers@google.com>,
	Lecopzer Chen <lecopzer.chen@mediatek.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masayoshi Mizuma <msys.mizuma@gmail.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Pingfan Liu <kernelfans@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Ravi V. Shankar" <ravi.v.shankar@intel.com>,
	Ricardo Neri <ricardo.neri@intel.com>,
	Stephane Eranian <eranian@google.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Tzung-Bi Shih <tzungbi@chromium.org>,
	Will Deacon <will@kernel.org>,
	Colin Cross <ccross@android.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 155/800] watchdog/perf: define dummy watchdog_update_hrtimer_threshold() on correct config
Date: Sun, 16 Jul 2023 21:40:08 +0200
Message-ID: <20230716194952.711347717@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 5e008df11c55228a86a1bae692cc2002503572c9 ]

Patch series "watchdog/hardlockup: Add the buddy hardlockup detector", v5.

This patch series adds the "buddy" hardlockup detector.  In brief, the
buddy hardlockup detector can detect hardlockups without arch-level
support by having CPUs checkup on a "buddy" CPU periodically.

Given the new design of this patch series, testing all combinations is
fairly difficult. I've attempted to make sure that all combinations of
CONFIG_ options are good, but it wouldn't surprise me if I missed
something. I apologize in advance and I'll do my best to fix any
problems that are found.

This patch (of 18):

The real watchdog_update_hrtimer_threshold() is defined in
kernel/watchdog_hld.c.  That file is included if
CONFIG_HARDLOCKUP_DETECTOR_PERF and the function is defined in that file
if CONFIG_HARDLOCKUP_CHECK_TIMESTAMP.

The dummy version of the function in "nmi.h" didn't get that quite right.
While this doesn't appear to be a huge deal, it's nice to make it
consistent.

It doesn't break builds because CHECK_TIMESTAMP is only defined by x86 so
others don't get a double definition, and x86 uses perf lockup detector,
so it gets the out of line version.

Link: https://lkml.kernel.org/r/20230519101840.v5.18.Ia44852044cdcb074f387e80df6b45e892965d4a1@changeid
Link: https://lkml.kernel.org/r/20230519101840.v5.1.I8cbb2f4fa740528fcfade4f5439b6cdcdd059251@changeid
Fixes: 7edaeb6841df ("kernel/watchdog: Prevent false positives with turbo modes")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Ravi V. Shankar" <ravi.v.shankar@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: Tzung-Bi Shih <tzungbi@chromium.org>
Cc: Will Deacon <will@kernel.org>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 048c0b9aa623d..771d77b62bc10 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -197,7 +197,7 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh);
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_CHECK_TIMESTAMP) && \
-    defined(CONFIG_HARDLOCKUP_DETECTOR)
+    defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 void watchdog_update_hrtimer_threshold(u64 period);
 #else
 static inline void watchdog_update_hrtimer_threshold(u64 period) { }
-- 
2.39.2



