Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239562E8E10;
	Sun, 26 Oct 2025 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490271; cv=none; b=WMzCyLdutVBwpC6cIEruXNrVPbPUXt0o1tkwxobS70nLvFJJ3K530SCj0++sTnmeWuJCArRT13+BlU0WxkfewLQuBueFjyFbTDvAB2q7O2XKqQeXBwETYlsd5LDpoXGR08nE30+4Ug2x/NWC1hCoPt0S8CUWkbrkGxvJ97hEsZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490271; c=relaxed/simple;
	bh=mYA0kuEy+iMjCDuLWSe3e9vl19YomaAULcFIHykUdUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXhQLPZ2hNAol1HmvGiu7/ufZJ2d3rJxADYcUDwJOQgu67Qf5KCRp3aIJHlWype7rOT1PhHxNJ/44SgzraALDHHikWSO2Oq03Lvkx8P57P+VlVFDLUdu/0DM8zftWtEhtulxQGEVm3pxFaqWmmumL6rX9TIGysB3f8CG7/M+Ll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLyuvgHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLyuvgHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E63C4CEE7;
	Sun, 26 Oct 2025 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490271;
	bh=mYA0kuEy+iMjCDuLWSe3e9vl19YomaAULcFIHykUdUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLyuvgHPZ/zaAtoMUy5DWpJp6ZTy4ar01p2AuXHZ+BBJVo9AZU0uu6o65edkRTF4S
	 BVHdJcs7LTHgzRihNVakE7MK1MsXc1egMODd//QrReO9XEdylJ8NrNkCqc7dkEY4hc
	 o6gfLHL3QYVWbBtcoiLp/7kBLJf3jc0dHy3hEcM73NIVvmyk4jp2OpkFXAqfGe2igY
	 8uLoYaYVgF32YnKRZF3OLDN7/7aDWUJiVRKA+v33jrhwr6nKrgC0+wt9Jhq+4CEuVg
	 dd0gOc+KR9nJkC1mIlM3XD9pH1BM/gM+eI0eg7irga4CIszALB3gyYOkhy1DK7fm7N
	 IDcxkw7m0YSHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>,
	Yury Norov <yury.norov@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Darren Hart <dvhart@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonas Gottlieb <jonas.gottlieb@stackit.cloud>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Maurice Lambert <mauricelambert434@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Machata <petrm@nvidia.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yuyang Huang <yuyanghuang@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.4] tools bitmap: Add missing asm-generic/bitsperlong.h include
Date: Sun, 26 Oct 2025 10:49:11 -0400
Message-ID: <20251026144958.26750-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit f38ce0209ab4553906b44bd1159e35c740a84161 ]

small_const_nbits is defined in asm-generic/bitsperlong.h which
bitmap.h uses but doesn't include causing build failures in some build
systems. Add the missing #include.

Note the bitmap.h in tools has diverged from that of the kernel, so no
changes are made there.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Darren Hart <dvhart@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jason Xing <kerneljasonxing@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonas Gottlieb <jonas.gottlieb@stackit.cloud>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Maurice Lambert <mauricelambert434@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Machata <petrm@nvidia.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yuyang Huang <yuyanghuang@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – `tools/include/linux/bitmap.h:6` now includes `asm-
generic/bitsperlong.h`, which is where `small_const_nbits()` lives after
the 2021 restructuring. Without that include, every inline helper in
`tools/include/linux/bitmap.h` that uses `small_const_nbits()` (for
example the very first helper `bitmap_zero()` at
`tools/include/linux/bitmap.h:34`) leaves translation units like
`tools/lib/bitmap.c` and numerous perf/selftest sources including this
header alone with an undefined macro, producing build failures on
toolchains that don’t happen to pull the header indirectly. This is a
pure dependency fix with no functional or ABI side effects: the new
header is already part of the tools copy of the UAPI
(`tools/include/asm-generic/bitsperlong.h`) and just restores the direct
include that should have accompanied the earlier macro move. Because it
fixes an actual build break in user-visible tooling, is tiny and self-
contained, and has no regression risk beyond adding a required header,
it is an excellent candidate for stable backporting.

 tools/include/linux/bitmap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index d4d300040d019..0d992245c600d 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -3,6 +3,7 @@
 #define _TOOLS_LINUX_BITMAP_H
 
 #include <string.h>
+#include <asm-generic/bitsperlong.h>
 #include <linux/align.h>
 #include <linux/bitops.h>
 #include <linux/find.h>
-- 
2.51.0

