Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E18C3CFF55;
	Tue, 16 Jun 2026 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632906; cv=none; b=Kic8r0XkR3GCDEibEtQWFUuQno6D/CBk0pALVkgfv+KZ/V4NtIhx3HA7GLe+1P/6eb4Sggr9glHizIXMR2f+/UQSW/8UxXd3VpeS7G/wvG/jtqp84Sogzk3+AwzPZAWYxCZxyJoFg4QmAHAYh5odxRaOo8e6o8hpWG6ex6iEwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632906; c=relaxed/simple;
	bh=VC+k/N0hQW7sQ2Sp9OS6NZFpZV2+TkVtZhW1SrSzKik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH2gCp0xgCQxl4qL9yzg/2/xsVqquiECAJYbrdBA/yJrR7RDR+RH1W5WQY+E/uqofbK2Mnm/Jb2kV1LvQyerL5GVwur/+T+XhSz/K9CU2758EtI4inZwFXmcnJwp0UlaquKzMnrNU+guAQRVpyEuGQppFFvn1IgBq2DYiCEWa4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5DShiOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5DShiOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5521F000E9;
	Tue, 16 Jun 2026 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632905;
	bh=Rhcm12vBOKENke5PX70Oa8RGF8LF5avByfFe+3aUP70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5DShiORff8yWr+u0p0OBvK0qRFepOUZ/hmJlzgfFmYqR7SHN4iuHNfclB/nChln9
	 vwJGVmGAjfTvRwEjFJUXI6vMyN9F0AUn6nQ7/xMBWmGe/shKS1ilxX2ySDCilO0kQI
	 a8itfjrln7geV9Kvd+OvZnoKOQsCE7e5T18+482g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 499/522] perf build: Remove -Wno-unused-but-set-variable from the flex flags when building with clang < 13.0.0
Date: Tue, 16 Jun 2026 20:30:46 +0530
Message-ID: <20260616145149.117110676@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

clang < 13.0.0 doesn't grok -Wno-unused-but-set-variable, so just remove
it to avoid:

  error: unknown warning option '-Wno-unused-but-set-variable'; did you mean '-Wno-unused-const-variable'? [-Werror,-Wunknown-warning-option]
  make[4]: *** [/git/perf-6.5.0-rc4/tools/build/Makefile.build:128: /tmp/build/perf/util/pmu-flex.o] Error 1
  make[4]: *** Waiting for unfinished jobs....

Fixes: ddc8e4c966923ad1 ("perf build: Disable fewer bison warnings")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/ZNUSWr52jUnVaaa%2F@kernel.org/
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/Build |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -1,3 +1,6 @@
+include $(srctree)/tools/scripts/Makefile.include
+include $(srctree)/tools/scripts/utilities.mak
+
 perf-y += arm64-frame-pointer-unwind-support.o
 perf-y += annotate.o
 perf-y += block-info.o
@@ -265,15 +268,22 @@ ifeq ($(FLEX_GE_26),1)
 else
   flex_flags := -w
 endif
-CFLAGS_parse-events-flex.o  += $(flex_flags)
-CFLAGS_pmu-flex.o           += $(flex_flags)
-CFLAGS_expr-flex.o          += $(flex_flags)
 
 # Some newer clang and gcc version complain about this
 # util/parse-events-bison.c:1317:9: error: variable 'parse_events_nerrs' set but not used [-Werror,-Wunused-but-set-variable]
 #  int yynerrs = 0;
 
 bison_flags := -DYYENABLE_NLS=0 -Wno-unused-but-set-variable
+
+# Old clangs don't grok -Wno-unused-but-set-variable, remove it
+ifeq ($(CC_NO_CLANG), 0)
+  CLANG_VERSION := $(shell $(CLANG) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
+  ifeq ($(call version-lt3,$(CLANG_VERSION),13.0.0),1)
+    bison_flags := $(subst -Wno-unused-but-set-variable,,$(bison_flags))
+    flex_flags := $(subst -Wno-unused-but-set-variable,,$(flex_flags))
+  endif
+endif
+
 BISON_GE_382 := $(shell expr $(shell $(BISON) --version | grep bison | sed -e 's/.\+ \([0-9]\+\).\([0-9]\+\).\([0-9]\+\)/\1\2\3/g') \>\= 382)
 ifeq ($(BISON_GE_382),1)
   bison_flags += -Wno-switch-enum
@@ -286,6 +296,10 @@ ifeq ($(BISON_LT_381),1)
   bison_flags += -DYYNOMEM=YYABORT
 endif
 
+CFLAGS_parse-events-flex.o  += $(flex_flags)
+CFLAGS_pmu-flex.o           += $(flex_flags)
+CFLAGS_expr-flex.o          += $(flex_flags)
+
 CFLAGS_parse-events-bison.o += $(bison_flags)
 CFLAGS_pmu-bison.o          += -DYYLTYPE_IS_TRIVIAL=0 $(bison_flags)
 CFLAGS_expr-bison.o         += -DYYLTYPE_IS_TRIVIAL=0 $(bison_flags)


