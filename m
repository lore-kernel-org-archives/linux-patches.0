Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95423196434;
	Thu,  6 Jun 2024 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682895; cv=none; b=sVSkv3SlVEVM/fD+DIZR92u2u/3SPnb8UdvkNctmBGObKYJBdUQRCzSrx4AAy8HMUvCSp9EjV8xYADOxurxlDLMbRj1n8Y0rjsooEplyfkJ19xEa7gO3jMQBHC+jo+npnELaH7X9BZy7+6Myg3YKcdYwXeZklweVrGNa9wDylFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682895; c=relaxed/simple;
	bh=TKtALNJaeG6nxDaoUPUGfC9DjQU7DK2fXPccjAtnu6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF/TwKouzVWvi1TVd0Qs7BmAMqRsoKwDZ+91iuWKgWHRGA/T4Wh60DDS+b0f1qjq9Hylo+DaANMkSKmFWnEq1r8Pf0MoZHxIyeUiOwSZnLKKG1LyYgkH0aZ31xb3sA52IyAPwUO7pFD68WnMpsR5zC2yrRy6ZiepZX+dVUnZu10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0PU9fXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0PU9fXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C015C2BD10;
	Thu,  6 Jun 2024 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682894;
	bh=TKtALNJaeG6nxDaoUPUGfC9DjQU7DK2fXPccjAtnu6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0PU9fXEeAqhl0AjsZ5OgP32vw02lq7ifm3UtzOEN8hkc4usoPKtuxxm428Nk6Ug7
	 KKHRu3vDooYoxyAfE5JUdJJ18doay7MnCcQTRW7fQSvbB1e0Kz5JpStMx+t7mJV1h8
	 hKyVWZbYIGZl1g2tvJ6lgZBrqWCh4tGIDaGsagnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Tycho Andersen <tycho@tycho.pizza>,
	Ethan Adams <j.ethan.adams@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 001/374] perf build: Fix out of tree build related to installation of sysreg-defs
Date: Thu,  6 Jun 2024 15:59:40 +0200
Message-ID: <20240606131651.740217173@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Adams <j.ethan.adams@gmail.com>

[ Upstream commit efae55bb78cf8722c7df01cd974197dfd13ece39 ]

It seems that a previous modification to sysreg-defs, which corrected
emitting the header to the specified output directory, exposed missing
subdir, prefix variables.

This breaks out of tree builds of perf as the file is now built into the
output directory, but still tries to descend into output directory as a
subdir.

Fixes: a29ee6aea7030786 ("perf build: Ensure sysreg-defs Makefile respects output dir")
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Tycho Andersen <tycho@tycho.pizza>
Signed-off-by: Ethan Adams <j.ethan.adams@gmail.com>
Tested-by: Tycho Andersen <tycho@tycho.pizza>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240314222012.47193-1-j.ethan.adams@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 04d89d2ed209b..d769aa447fb75 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -458,18 +458,19 @@ SHELL = $(SHELL_PATH)
 
 arm64_gen_sysreg_dir := $(srctree)/tools/arch/arm64/tools
 ifneq ($(OUTPUT),)
-  arm64_gen_sysreg_outdir := $(OUTPUT)
+  arm64_gen_sysreg_outdir := $(abspath $(OUTPUT))
 else
   arm64_gen_sysreg_outdir := $(CURDIR)
 endif
 
 arm64-sysreg-defs: FORCE
-	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) O=$(arm64_gen_sysreg_outdir)
+	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) O=$(arm64_gen_sysreg_outdir) \
+		prefix= subdir=
 
 arm64-sysreg-defs-clean:
 	$(call QUIET_CLEAN,arm64-sysreg-defs)
 	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) O=$(arm64_gen_sysreg_outdir) \
-		clean > /dev/null
+		prefix= subdir= clean > /dev/null
 
 beauty_linux_dir := $(srctree)/tools/perf/trace/beauty/include/linux/
 linux_uapi_dir := $(srctree)/tools/include/uapi/linux
-- 
2.43.0



