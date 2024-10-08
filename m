Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50D91DF72E;
	Tue,  8 Oct 2024 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393835; cv=none; b=XTP2wr/bSATyzJHyuJhn17k/zA21XPTNeOf9ouH6EKbSISCx4ooo7JTt8QN8D78VSc/yGOW3va03SKVgBnKDT8YHMcQpizHAIgv4Cx10Hb5xa/KIdkmlbSQlsfzIEkaWH+YWhxb9Kro8Z8CCkA1h1fxBZ9jxw8jBLhlxvUDMuxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393835; c=relaxed/simple;
	bh=+DU2UwmGkTxOPP3EfIAf0Rmt/il9UDFZNYXBE73eYHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARpP+TQzgb5fl6cw5nCAffYizBdfjNgpcZooSBKJQk+wB5irYhs+U6db1Pc6pgWNB5/In+CcGQm0hiq1YiV/TeFbpUF3PHVW9EMtoa71sIzF42QlgTPK17lekAytrDlEnyf3KVuSNxmp2cdx2iCwn+Tymk1TWhEbWhTB0ztcOhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dwduN9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dwduN9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A48C4CEC7;
	Tue,  8 Oct 2024 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393835;
	bh=+DU2UwmGkTxOPP3EfIAf0Rmt/il9UDFZNYXBE73eYHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dwduN9vONXm1yUgeLCCyAg1X5SHIr4s8zAkQ3w//8ej7bYFtwa97BjeRnL+zrLIY
	 VmiK6b2lvxJEn3sn0OFfV2+PBXuohUwkHFAIcG8KBs7IXeNl4yJ3rQ6o57rJC4rrIb
	 5g1PmQkWc6/ZAGE400pmeWuitnlHErbdqNwVTIVU=
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
Subject: [PATCH 6.6 270/386] perf python: Disable -Wno-cast-function-type-mismatch if present on clang
Date: Tue,  8 Oct 2024 14:08:35 +0200
Message-ID: <20241008115640.015093038@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


