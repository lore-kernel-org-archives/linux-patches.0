Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032989;
	b=Xvxr16n9AMBl9rbuy0+dAxw9nRAldvNIYxzMjkWjqu8GjUITIIzGJKuVZkRydp1c6WRO
	 f8la6Xf00WB7AOQxM7crm42GltP1OWcCENwZ1Rd+/HP1AP269jlAPHbmQWHgKFQeoFcQj
	 3meaodwKg2p6Tw5eCsSOtCPVoklrYS1HEjJX/3iWJQ4zqy2tUt3pJhR2R7jPO7j913rl/
	 IUs1FbRNfP0RRzh8CvZhIqtDV1lDFm6Wn9xlkB6LznShonrE9e9Y8s+oDi8Ac1ZzhcxOT
	 Y+5lJTX6xVCGgnVcuFXyF9hMVJu8tVIAleV85WQ5N9G1ohJY9hgS9zgHHNr8FWuoTbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nUk+t5GqBmiZCe5jHzFVKljKoysDlitQ0ojjYFYHyUo=;
	b=MTBiv1MdKeyBRkg2oCU7HBzlJ40Gr/KCfwYPwRXwAaM4a+wLdyHYELAioELQPMM/EqfS
	 wyPgaN9SvZ8KrqCx/S+BzJlDRu7REGRDP2WVFhy0W7iIvln7nfKkQhk6UZHkquV0iLI6C
	 CYbB3eU6ADYqvOv2jWXNE22SlL0HjOvZ3Fx7wRcmkDuLCfptiBFIm0IglTWFeg/6IWnN7
	 tgOOul9rdkk/EypnAjb3nDvr6wYViATEsqPsvSx85lRn9PVHNh//T8tZaeBc8AcqIZPKf
	 fevuUqw7SEtBAAEdUjzH/3S2fgOU5F0ynlH7IBRsKPZwS0+MJFw+8lmlBK0a4uNfVWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9gsPPw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF334606A31C;
	Wed, 18 Nov 2026 20:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9gsPPw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D25B1F000C4;
	Wed, 18 Nov 2026 20:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032989;
	bh=nUk+t5GqBmiZCe5jHzFVKljKoysDlitQ0ojjYFYHyUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9gsPPw7vabVLSemIMMTVhVly8peFBn2PaUMGSS4VTxBhKqiAtwbcltFoQQkcJoTz
	 8BECpQbGlH8R6EKMnKLWVp6CL6HHEn0TCyoONYf3pY5CSLMKsxQ1Im2eplrYi1bOc7
	 GmDaoTMXijEfYXs7+yccLSmx7brVzQCxy/S0PIGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1609/1756] perf print_insn: Include sys/types.h for ssize_t
Date: Wed, 18 Nov 2026 16:02:16 +0100
Message-ID: <20261118150113.922104603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit e0e4470aa53c0022418290fb551c21da4bd50209 ]

print_insn.h declares fprintf_insn_asm() with an ssize_t return type but
does not include the header defining that type. This causes builds where
stdio.h does not provide ssize_t to fail when compiling util/print_insn.c:

  util/print_insn.h:21:1: error: unknown type name 'ssize_t'

Include sys/types.h so the header provides its own dependency for ssize_t.

Fixes: 218c200f677d8af4 ("perf script: Consolidate capstone print functions")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/print_insn.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/print_insn.h b/tools/perf/util/print_insn.h
index 07d11af3fc1cb..e4eb55e8b8a2f 100644
--- a/tools/perf/util/print_insn.h
+++ b/tools/perf/util/print_insn.h
@@ -4,6 +4,7 @@
 
 #include <stddef.h>
 #include <stdio.h>
+#include <sys/types.h>
 
 struct perf_sample;
 struct thread;
-- 
2.53.0



