Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022087;
	b=S12RsNSC3ZtR7hS8CRCExfUZUDQqomsqFT2zg/od9uoM+OLkkTkWIcCrUwLB5JBbR1WW
	 0AseVNquMtTARw05xYDiY/JMewEPSIGq1GXGcimxpo0TVy+X35HuqbcWqNbFb7y6AdFj7
	 5J8pjMrcnvQOihrhsNS0tfM5NR0u/efZJlV8CQXKa1m4M4l0niJQXoaZpeIRWWpsYI8qQ
	 w+AjK7+lF1Z4h8qj6HepR2QSiLbYGANjO6xCnmfC1mt2pqPG4imgYlf/7xS4ASCbYGf4x
	 qbTyw3YK81WAc2g+IJcxMYiRV1VEgjasl77K7dQ97WunUR05G6BmdvK23Ji63l9VUNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odsmbfD4LVBg76OSy0QOq+3cbkqtAW2CACNA5+FL1kY=;
	b=1o+6slxXSV15IMPC2o2M/daGfc7nIWX834JpXzHCvsu/3ZCfvbOqemaQnTWCch/MdZgr
	 skAHHcwFHreBOYuD0jZxGNhy6rKU37TfQ3IIIZVV0rSngQaBN/xstVO0oN07ul7R3Tc7Q
	 SGupS7SzbLYPyNr5bNrwkTMCpUFNVXTbzEyDIywRjCK2sqC6LAJZQ3erIMOYzUbl0rJt6
	 Dd/ds3J6pEhAgB4nULODCWL+moYFwO9yeFT9dtAVI7xG+rIDjaMLBsHbFAUhHLA178RiQ
	 13IeSqz6EnuT6Qw9sS6lbf33hw6yi3dwB9i2Qot2skq8ed88thaoEJPv2/U3onZvVWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KNPMV+z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8AE606A31C;
	Wed, 18 Nov 2026 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KNPMV+z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912D71F000C4;
	Wed, 18 Nov 2026 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022087;
	bh=odsmbfD4LVBg76OSy0QOq+3cbkqtAW2CACNA5+FL1kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KNPMV+zDkfYuhthSEqajc+FvlqFlVxZaOANuxXgWmqtL9Mssc4e52fwiJgp8EtAF
	 aDYNgZzhBjQqa9wgOlTewjB6YkBceq5OxHa+Cbws7Ts8f59REPhn22Ix7g60nJoHxs
	 1aIzjjequD/+eXGYLapjsUBX1s6oyKA5Q0Knc/oU=
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
Subject: [PATCH 7.3 2497/2651] perf print_insn: Include sys/types.h for ssize_t
Date: Wed, 18 Nov 2026 16:02:17 +0100
Message-ID: <20261118150414.715078368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index cefa5c5f246e5..3de9438af9cd7 100644
--- a/tools/perf/util/print_insn.h
+++ b/tools/perf/util/print_insn.h
@@ -4,6 +4,7 @@
 
 #include <stddef.h>
 #include <stdio.h>
+#include <sys/types.h>
 
 #include <linux/types.h>
 
-- 
2.53.0



