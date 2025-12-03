Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED293A1D1A;
	Wed,  3 Dec 2025 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779562; cv=none; b=h398De6Yyur/u9jXullkm1GYGnoI/LLYu9+eQTTKMkR+AjtmX7oDnrBC5Fo01e81PExZTCrfO/Tb7ow9zh7nAsE3rvnjW1rURSRcLSdCG42XrB45XLk4it8IM6ZZwcyTS9Gm+m0+fPQlak1iWHgMkreOfjYJ2BDn8bYESewZ094=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779562; c=relaxed/simple;
	bh=Nlfn4dBlkULFCZLZH5UDKQBvgXyAiP7+blRtDxOe5xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebx7w3AahGB0jOAOVqV9/reGcful9oyjrGvh8VBgyVfsskNG2ptvjuL0DM4PXbkobfhu8iK0fHtvLlAES6pB5zxdXGLh0sitqFreqd5v0Ho9vnGTDMeGzY0eexoi5gNta1Y5OjVtOVnRKTNAuTRXmjnLZkcEnOwxyA7IR3wxRkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkiGGdwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkiGGdwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84436C4CEF5;
	Wed,  3 Dec 2025 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779562;
	bh=Nlfn4dBlkULFCZLZH5UDKQBvgXyAiP7+blRtDxOe5xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkiGGdwdQN6Qtpa6S64qGqBAoV5cpzP8WtUmrmrvHQJlYKq8ShviAXRiUJkprE+l6
	 PvwMkTGcHsi4ukOiYOk3sRCrg0rcYBHv4d/iH2Ft3bgdTZE6MczSWK3o2OFjkgBmYi
	 5CC6k+KyuCad12BJrRh0KQrzLsQbqZBolHchwd7Y=
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
Subject: [PATCH 6.1 295/568] tools bitmap: Add missing asm-generic/bitsperlong.h include
Date: Wed,  3 Dec 2025 16:24:57 +0100
Message-ID: <20251203152451.506663846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2cbabc1dcf0fd..937e1e181775f 100644
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



