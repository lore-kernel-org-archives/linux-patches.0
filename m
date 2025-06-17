Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A192264D6;
	Tue, 17 Jun 2025 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178198; cv=none; b=pbtDqPiRl++iPoNUkg0DNNvH7BoNyXzKUdJoVSaiWMfiGzm5YP17KpPPwMVuHK0G+hxgpJ0g6vvYkrSt8CCSaN2VHBqFFGYm6S0xTKOdBVdbN3WGXZQVzxAVde96F5TETT7yBKoQI/B2sqXFwtsI/S7dH3o+86Ftz8ZIJalkL+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178198; c=relaxed/simple;
	bh=vQaYCV3cswK0bXRejsX24Bri7b/FHmhS+NNOqyOijhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgJPXr1IrrFc3gvqDaycW6v+uELhiDrQVbJqRF7YSTGKJ6g6bZnc3lXn2YJ7l64z1lNaxVSSqngduELH8gNoOufghhaYrrp2xDvRRASMfwftdBMiZEOIxtcdj1fPcuyCAQTHvb4CdRrDbdOWVfeFB+olaPMoedC9NddLn5tbf38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wod+5s8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wod+5s8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96DAC4CEE7;
	Tue, 17 Jun 2025 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178198;
	bh=vQaYCV3cswK0bXRejsX24Bri7b/FHmhS+NNOqyOijhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wod+5s8P8baeSkmlujNVPy/Ei3uEB6OlWSiaUnVpwjoQ8FqfYDoRm50kGDIYPeKoe
	 K54eMBGq9UR2aQSlSnOGu59PCy+jrbPNyTPD6l/OavtpLNFj5/wZBNuCcH5pRufQbT
	 ScL5CNtdxrA9VpGFvZt5PsaM5M1i7TMefjXcZ6UM=
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
Subject: [PATCH 6.15 423/780] tools build: Dont show libbfd build status as it is opt-in
Date: Tue, 17 Jun 2025 17:22:11 +0200
Message-ID: <20250617152508.698643634@linuxfoundation.org>
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

[ Upstream commit e0eb84cd518084582c0d1db5d904f31b16902fdc ]

Since dd317df072071903 ("perf build: Make binutil libraries opt in")
doesn't try to build with binutils libraries, so showing that it is OFF
when building causes just distraction, remove it from FEATURES_DISPLAY.

For people that for some reason notice that there is always 'perf -vv',
a short hand for 'perf version --build-options' and 'perf check feature
libbfd' that now explains why it is not built:

  $ perf check feature libbfd
  libbfd: [ OFF ]  # HAVE_LIBBFD_SUPPORT ( tip: Deprecated, license incompatibility, use BUILD_NONDISTRO=1 and install binutils-dev[el] )
  $

Fixes: dd317df072071903 ("perf build: Make binutil libraries opt in")
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
 tools/build/Makefile.feature | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 357749701239f..57bd995ce6afa 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -147,8 +147,6 @@ endif
 FEATURE_DISPLAY ?=              \
          libdw                  \
          glibc                  \
-         libbfd                 \
-         libbfd-buildid		\
          libelf                 \
          libnuma                \
          numa_num_possible_cpus \
-- 
2.39.5



