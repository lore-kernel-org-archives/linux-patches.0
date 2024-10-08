Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6ED1D0BAA;
	Tue,  8 Oct 2024 12:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390709; cv=none; b=SkKFG8WQNCOMu0grOcKoxHPAZSE/HwA52oPxFb3RbHnL4D9nKBfFEpSi8alFt+1AFG4+JXJPvs5NY47+n+4ftjZkrR2wXc1ngXrEi3bJLaZl4wnlMSdcuqRHvGoDiz+fRmkBO8j3cvI9HWJsHWTAcsE5d98K4iHi0l0Sau644K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390709; c=relaxed/simple;
	bh=exqbaKdcut4XAge8A5gJA7aDcg0XFAbPy/538zYSGtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6/LafAbc2Ga5Qpf6nD01g8AUagtp7VIX1ViYtTFrFAKOeI4p5r4tnvrmV2vh4rLEiGXs+q4IQBdDMkTpyQzInx9Sn51r8Y1c/Ws24JNZkQEcckVGg0BVHEwYuMsc//8CWFM47KuROyVmEuqNKPKg2rk3mYVoY5wAbceJwAgpjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3dBABGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3dBABGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B162C4CEC7;
	Tue,  8 Oct 2024 12:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390708;
	bh=exqbaKdcut4XAge8A5gJA7aDcg0XFAbPy/538zYSGtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3dBABGx3q2lzLSLjkOsCh3DscqBDaIpG9j0maPmft8L4zxAkDfIc3f40hgwFarCf
	 bwcBs2AVzhiZ0hrPpqBpGR0JM9VfQp2R0RIGn4/NEPx78iWhWRFKQw7fKz1LmiFpzv
	 ZFgzuO5yMVHfKPW4KDoxqM2JqPq7j4pINm7V3iN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.10 369/482] perf python: Disable -Wno-cast-function-type-mismatch if present on clang
Date: Tue,  8 Oct 2024 14:07:12 +0200
Message-ID: <20241008115702.943300326@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 00dc514612fe98cfa117193b9df28f15e7c9db9c upstream.

The -Wcast-function-type-mismatch option was introduced in clang 19 and
its enabled by default, since we use -Werror, and python bindings do
casts that are valid but trips this warning, disable it if present.

Closes: https://lore.kernel.org/all/CA+icZUXoJ6BS3GMhJHV3aZWyb5Cz2haFneX0C5pUMUUhG-UVKQ@mail.gmail.com
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org # To allow building with the upcoming clang 19
Link: https://lore.kernel.org/lkml/CA+icZUVtHn8X1Tb_Y__c-WswsO0K8U9uy3r2MzKXwTA5THtL7w@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/setup.py |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -63,6 +63,8 @@ cflags = getenv('CFLAGS', '').split()
 cflags += ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter', '-Wno-redundant-decls', '-DPYTHON_PERF' ]
 if cc_is_clang:
     cflags += ["-Wno-unused-command-line-argument" ]
+    if clang_has_option("-Wno-cast-function-type-mismatch"):
+        cflags += ["-Wno-cast-function-type-mismatch" ]
 else:
     cflags += ['-Wno-cast-function-type' ]
 


