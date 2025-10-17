Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EDC3370FB;
	Fri, 17 Oct 2025 14:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713071; cv=none; b=aB0llvgewPSp0raBrOeXt0vrPu6bF89D4a5lr0nxmkhv6tAL+uX2uxUYtSsXJ+mafD8Dzi5+ECh9iLWUymUrGRtTqKuLUeNprNpDun5wsOks0ROPjcWlU8ky3C98Oo6WJdeJJQijoiRrQT4aH1jJrn1qCp5cEFh0FXV4o7RlQBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713071; c=relaxed/simple;
	bh=yyXdbqmVBwCJBAnDFJ6uojdAFVjK3BND7ZL/z25OXiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGycjbHmGir7K1wlk/h6uzRBiWLLExMN+uKFazO18PDhx/14MwGPH5JczmX8pimU9Ynp3ww+fgZawyZ7/EG/AsHOaNxVzRE269vzg4ijSl+ZloV123O2Je+qIEXb2IpSGmoseITmw1ZYwWhbGz+W+J1oLsjPoWpRO2hhOCvd4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlAO6bDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlAO6bDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B84C4CEE7;
	Fri, 17 Oct 2025 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713071;
	bh=yyXdbqmVBwCJBAnDFJ6uojdAFVjK3BND7ZL/z25OXiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlAO6bDXr0YEqUbd3vX7IqaM68TdJ5EHbXO1NaZf6BBEbusVCGtxyY9rO1BSqYdE5
	 BWRw53ySzQ7x3gYfiEc/Q/0kRewETZyJ6FTMoff2Gd/4Osgp1QAIBuyNuSMyoH1NBB
	 x9R3jRIFBDTr0A1q20lgTD3NzBMisr+KrKOb7+eM=
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
Subject: [PATCH 6.1 037/168] tools build: Align warning options with perf
Date: Fri, 17 Oct 2025 16:51:56 +0200
Message-ID: <20251017145130.385519209@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 690fe97be1904..1b7886cbbb65a 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -282,10 +282,10 @@ $(OUTPUT)test-libbabeltrace.bin:
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



