Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15512550DD;
	Mon,  1 Dec 2025 11:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588622; cv=none; b=tH+2CL+GdFrWBduQbNyuNnrn/rlYz+Bdgr5vtnGsQnWRkVW36UZw+cJDBVdjMoKD0pcB2kkeVVuEpLecV/4V/jOyZHzCJghH6Pz5mXIyUDQxbvpk+8/BAr57GIYGd9c9IARueXoetb4WWA6gxYv41sK7A7LvZsPzEl6pkaaGPUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588622; c=relaxed/simple;
	bh=yJrTOdOty5vO0ot2E2if7p8wobBpAyI027aYC2u1qS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAF3qF7Kmlv0EpKgO6pQGifCRllS3ZbkSfQAkOwcjsnCOm3JmNCvpl73OCx+MyIB9K1dwdjIdRqmVmRM6iH/vv6nj0kuoV+8zY6CWlRO5TcVhpwKK4p6hJjMxy8KM0BUUWfIFsdFwkXX2bgZFfPUSlBSsnzSZO+ueRtVA048Hqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQyMkmoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQyMkmoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E1BC4CEF1;
	Mon,  1 Dec 2025 11:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588621;
	bh=yJrTOdOty5vO0ot2E2if7p8wobBpAyI027aYC2u1qS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQyMkmoh6B9pHf2lwAMvxph4LSSoOFIofy1xGEQZrzDAH/5umxwGbSerdIOq0CMtn
	 F4/r02Bali2Fwf+ZoP5GajrrdwtP+rUUwj1G3eGrbDjDVnDSzIaPLnBMtDW93wYvgz
	 g9avslWTv59YTRhYEE3TLsWmCgrVDBeuYrfa9ftM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
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
Subject: [PATCH 5.4 111/187] tools bitmap: Add missing asm-generic/bitsperlong.h include
Date: Mon,  1 Dec 2025 12:23:39 +0100
Message-ID: <20251201112245.242725985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 tools/include/linux/bitmap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index 61cf3b9a23a6f..614df0e8822c4 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
@@ -3,6 +3,7 @@
 #define _PERF_BITOPS_H
 
 #include <string.h>
+#include <asm-generic/bitsperlong.h>
 #include <linux/align.h>
 #include <linux/bitops.h>
 #include <stdlib.h>
-- 
2.51.0



