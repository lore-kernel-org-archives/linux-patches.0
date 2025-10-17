Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A16330B00;
	Fri, 17 Oct 2025 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716325; cv=none; b=fYfX1ghdC7lyxMSMUnThebpjKnJdOmoci+BT4tr0OT1W2PA1PAale3vA03od79aY7eoFVPGB+uII/u0xit8k+zJX5hKfCTVGEzu0Qpnx5dvKXwnSKr4cpoCNGAddQa1mAZowUd/Sgesuq3c5SJPVh82Fy2FdwqA6WDTB6tuqPNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716325; c=relaxed/simple;
	bh=exOzAKYyZqWdz3l/rN4xuKsrpx1NjgptUR/yfAc9w/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvqq7aWOtwXh8VeyZ2Nhx4hSAOddtHzjfRkwgcXtXWCQG6VL4d/W/eyr3KwSeA/HQp8zDuqEjW7890U64rJYtopQKgUjG/qVy3kzfkGGsCHO7QEAitox3qYSrmntg7mZaQb72pw4uRRgZQRpyGjylXuwyrqdC9e+sDJ/ZPWD3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLE88u86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLE88u86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5444CC116B1;
	Fri, 17 Oct 2025 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716324;
	bh=exOzAKYyZqWdz3l/rN4xuKsrpx1NjgptUR/yfAc9w/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLE88u86G77oJrcRTZwIecPAKmfrB6e9/tRB1tYMLffW9mPUH4RJqJ1WVwaSJFkXt
	 nGPmwQs1QjumTeLc1rs0NjnkmhRfKwU4pxwRTW2JFYpTibuLzbogPnUT9sXgSExHoQ
	 1CyvTft/pwR1LmSoVXthVo4ck0GfuE2xx2a1NW9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Bill Wendling <morbo@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	James Clark <james.clark@linaro.org>,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev,
	Paul Walmsley <paul.walmsley@sifive.com>,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/276] tools build: Align warning options with perf
Date: Fri, 17 Oct 2025 16:54:05 +0200
Message-ID: <20251017145148.027432958@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 53d067feb8c4f16d1f24ce3f4df4450bb18c555f ]

The feature test programs are built without enabling '-Wall -Werror'
options. As a result, a feature may appear to be available, but later
building in perf can fail with stricter checks.

Make the feature test program use the same warning options as perf.

Fixes: 1925459b4d92 ("tools build: Fix feature Makefile issues with 'O='")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20251006-perf_build_android_ndk-v3-1-4305590795b2@arm.com
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: linux-riscv@lists.infradead.org
Cc: llvm@lists.linux.dev
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index aa3b0d75e44b7..37aa85a81e0a0 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -268,10 +268,10 @@ $(OUTPUT)test-libbabeltrace.bin:
 	$(BUILD) # -lbabeltrace provided by $(FEATURE_CHECK_LDFLAGS-libbabeltrace)
 
 $(OUTPUT)test-compile-32.bin:
-	$(CC) -m32 -o $@ test-compile.c
+	$(CC) -m32 -Wall -Werror -o $@ test-compile.c
 
 $(OUTPUT)test-compile-x32.bin:
-	$(CC) -mx32 -o $@ test-compile.c
+	$(CC) -mx32 -Wall -Werror -o $@ test-compile.c
 
 $(OUTPUT)test-zlib.bin:
 	$(BUILD) -lz
-- 
2.51.0



