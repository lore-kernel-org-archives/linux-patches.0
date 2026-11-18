Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025251;
	b=m0OXKMDyT8aw3oZsXrT3HznzxxGS63zR1Yw5rqVS3ymu5TyM41jTyMAE1n9BmuKkq0qJ
	 aPFZD8OH4lLBqMdz6vYycC0S2RvSLWgWGdWm8udhoEOBmHJ4nc81JK9m2R7LWJFWhWT/i
	 rS1+DvDTOEbC1am5owqxWIOsUliXCkW2Nwkn+jIe6idCqrnGgmCS265DhXdPDpwweynye
	 Y8j6G1N1Toa42c1iWOxOqYEEwA3EDh+lxJbPKx76UNd5l59PgUf9bJaz9jDSrD+yV8PW6
	 k0w5rGQtA8mm7XjEgqKYN3qMqLVR5LlXuEjegKxEhnEph5JXYwz+2Lzkzgz8QAc97hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7URUDCm8T80mmdGArM/fKZxqC+cn/a0Bym3b3Yzzztk=;
	b=MMtj7/lCDwBQI5F5ONRs2IO7wUvC3t4LkWvild8Qx+Sl0/KCM+vkd+SJNasp4nyoGV1e
	 fe+Y1LBcxHa4ZpaoIpkSxPqDl8fCs3G8BzYF9zzvZVWFgnYePB0QZTEOiLVE9aLbnVjLd
	 VnLJ2vqzFpuLfEpwoZxQam6GK9wz+C4P4m8NPREALJj9EaYHGOZMf4Zsjps18CPZkCQkj
	 Ra1TaolZ7IULypRJKusQVvFp5sJfG3Io+bCdGq1KiJRaErp0Jc+oZOit5eWlvoUtmHPmP
	 r9VUWpxOPl0kqb3bexsRyNzq4YznVzU6o262EBkC4r0+VE839KZ/EoTmZm3WX9m2H0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwyifMDO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB82606A332;
	Wed, 18 Nov 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwyifMDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C671F000C4;
	Wed, 18 Nov 2026 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025251;
	bh=7URUDCm8T80mmdGArM/fKZxqC+cn/a0Bym3b3Yzzztk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwyifMDOJVJPtuk+LlyTz7JVL2W+LO73SeeJtcmB9XFivXT/rCwLJa8/Pm0CGdWGI
	 82w7T6q0p9ohjFgSihWADJRWJJGtH8d0s24rLdbj0U2Fmiex5yiVXcSH30nagMx3vo
	 I5o86kMg85AYXRk3kHci91+xFO7FCuCgp1Lrmip4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Jens Remus <jremus@linux.ibm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0976/2151] perf build: Do not duplicate CFLAGS in Python extension builds
Date: Wed, 18 Nov 2026 15:45:11 +0100
Message-ID: <20261118150158.049136834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit bcd2cc4405bdb9ac77210d0df5990d46c311be66 ]

setuptools already uses CFLAGS.  Passing CFLAGS with additional flags as
extra compile arguments causes CFLAGS to effectively get passed twice:

$ make -C tools/perf V=1 JOBS=1
...
building 'perf' extension
gcc [CFLAGS] -fPIC -Iutil/include -I/usr/include/python3.14 \
  -c /root/linux/tools/perf/util/python.c \
  -o python_ext_build/tmp/root/linux/tools/perf/util/python.o \
  [CFLAGS] \
  -fno-strict-aliasing -Wno-write-strings -Wno-unused-parameter \
  -Wno-redundant-decls -Wno-cast-function-type \
  -Wno-declaration-after-statement

Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 2ed38aa8a52d ("perf python: Track linked libraries as extension dependencies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/setup.py | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index b65b1792ca056..a0ce76624a230 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -74,18 +74,17 @@ class install_lib(_install_lib):
         self.build_dir = build_lib
 
 
-cflags = getenv('CFLAGS', '').split()
 # switch off several checks (need to be at the end of cflags list)
-cflags += ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter', '-Wno-redundant-decls' ]
+extra_cflags = ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter', '-Wno-redundant-decls' ]
 if cc_is_clang:
-    cflags += ["-Wno-unused-command-line-argument" ]
+    extra_cflags += ["-Wno-unused-command-line-argument" ]
     if clang_has_option("-Wno-cast-function-type-mismatch"):
-        cflags += ["-Wno-cast-function-type-mismatch" ]
+        extra_cflags += ["-Wno-cast-function-type-mismatch" ]
 else:
-    cflags += ['-Wno-cast-function-type' ]
+    extra_cflags += ['-Wno-cast-function-type' ]
 
 # The python headers have mixed code with declarations (decls after asserts, for instance)
-cflags += [ "-Wno-declaration-after-statement" ]
+extra_cflags += [ "-Wno-declaration-after-statement" ]
 
 src_perf  = f'{srctree}/tools/perf'
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
@@ -94,7 +93,7 @@ build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 perf = Extension('perf',
                  sources = [ src_perf + '/util/python.c' ],
 		         include_dirs = ['util/include'],
-		         extra_compile_args = cflags,
+		         extra_compile_args = extra_cflags,
                  )
 
 setup(name='perf',
-- 
2.53.0



