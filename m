Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D801C32EB;
	Tue,  8 Oct 2024 13:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392498; cv=none; b=DN/MAiXF61rwEZMYwxU2Dz0oKF3JNfi3Ns3miEYf8Gl4jSVtlafdwl1TBCMo3iedruMmM7ccQUNymg7MHFTUTA4mr0zMMG02BFy0ozHrfJKMG4S3UMOviAD/933R5BEYmzCrfEJ5VSRO3QD4oGzsNHoN2G0xFTSVBSr1SxqqAOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392498; c=relaxed/simple;
	bh=W+cb3FbG6g7aTke3iZiCZgdHc2DAdAudt/o/0w7idaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc1EfVBoPVuTGiMdfsz4JUGN8QyWVLtjdfWvu+WOAB0cpKhvHMbR3y/Ka/279WnZ7YidTnjIFH1FeywhfneVIfgeURDAFt8pAuK/tFVo1aLIh1nlTY4UgIDXoo9TJ63BF5D0Gc2wrqTI73euPJGO9EOTNgH0rahIIP1HaPK3Dh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQj4H/xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQj4H/xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FABC4CEC7;
	Tue,  8 Oct 2024 13:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392498;
	bh=W+cb3FbG6g7aTke3iZiCZgdHc2DAdAudt/o/0w7idaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQj4H/xeDKmsuin40fvSxMup913rm16wSR5PlbnAyHfvIIeIvuzNTnaUw9fUPrjCx
	 NgikLLoyf92KaY2gQlZzIxs2Yqzpi6BjbH15MAsCTL7IU3RskoAuM0Zgnofy9EobHr
	 PgXY92kRn+oXluP8iiWlIOoSeHX48EE8PoA8wTwg=
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
Subject: [PATCH 6.11 432/558] perf python: Disable -Wno-cast-function-type-mismatch if present on clang
Date: Tue,  8 Oct 2024 14:07:42 +0200
Message-ID: <20241008115719.272201292@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 cflags += ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter', '-Wno-redundant-decls' ]
 if cc_is_clang:
     cflags += ["-Wno-unused-command-line-argument" ]
+    if clang_has_option("-Wno-cast-function-type-mismatch"):
+        cflags += ["-Wno-cast-function-type-mismatch" ]
 else:
     cflags += ['-Wno-cast-function-type' ]
 


