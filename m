Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879F22ECD33;
	Tue, 17 Jun 2025 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178180; cv=none; b=I9tS35CazYaRvTSY2A4HPim5k/05yJl6OGFL5+m03W4ZOdwUy23juwgkaO2T8CgFUuaWWEintzSCFXcuVZVilM52HPijy0ov4Wzo2GhGBNInd/Sfd+DBARCp+kYdQYXMJvcl9MYxVRjdz8KdDZcHu7HMIBcgd3RUGmez+Qxluzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178180; c=relaxed/simple;
	bh=56Nk4fn8wZ4sP3B8iqpFQqOQXcP/J15g9rxcA52XOqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn2kyZSQuHhRMH7011GMQlcZ/D3eMTMroGE9kX3dUWgWrdljV3LjOL+jIPPPvoCRXycA7SX2N0xM47zGOpw/TC78AU1wujLk57ENq1/L/MY3fGyXD6enuhtSx4Mu6dgNa5vbAe37SXMXvKSQt/lGC9sUg7vmeSYBoauF/QnPDdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1/XrifR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1/XrifR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AA6C4CEE3;
	Tue, 17 Jun 2025 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178180;
	bh=56Nk4fn8wZ4sP3B8iqpFQqOQXcP/J15g9rxcA52XOqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1/XrifRyT1xCrUxs5X8cJ64Kv01c6cIw02PEn5uzher0gSKFEbDV1l2OyqwhnBvs
	 2kDD0ad+rsE9Yj+q0FoCCGlWIzMCpiyvc9JJgOuQphjXmC7NW4BoXxS/5r+QARDlVK
	 oIXhJQGdvuYNFXSYegWAgSIbolfye/bNWSV+kWEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 421/780] tools build: Dont show libunwind build status as it is opt-in
Date: Tue, 17 Jun 2025 17:22:09 +0200
Message-ID: <20250617152508.615981103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a3a40391292273cf78a7920c119cdc386d694c38 ]

Since 13e17c9ff49119aa ("perf build: Make libunwind opt-in rather than
opt-out") doesn't try to build with libunwind, so showing that it is OFF
when building causes just distraction, remove it from FEATURES_DISPLAY.

For people that for some reason notice that there is always 'perf -vv',
a short hand for 'perf version --build-options' and 'perf check feature
libunwind' that now explains why it is not built:

  $ perf check feature libunwind
             libunwind: [ OFF ]  # HAVE_LIBUNWIND_SUPPORT ( tip: Deprecated, use LIBUNWIND=1 and install libunwind-dev[el] to build with it )
  $

Fixes: 13e17c9ff49119aa ("perf build: Make libunwind opt-in rather than opt-out")
Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/Z--pWmTHGb62_83e@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 48e3f124b98ac..357749701239f 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -155,7 +155,6 @@ FEATURE_DISPLAY ?=              \
          libperl                \
          libpython              \
          libcrypto              \
-         libunwind              \
          libcapstone            \
          llvm-perf              \
          zlib                   \
-- 
2.39.5



