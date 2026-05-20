Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED154339844;
	Wed, 20 May 2026 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296017; cv=none; b=PgHKa67KYW9glX3bQgB95zML+QErAjMymY/TpsLQmV/pblAVWri1LNMSbRPdNOcK0FdTSwbAHTDZNsdyeqBgMDP8PQoTfcpcCwAIKwMd7voC1VUC8jb6RT6fqq5+JRbMAX8Z6FlhuQihrUjaovPfGPz5uBPogzmhjc/zivdkBmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296017; c=relaxed/simple;
	bh=VcSOv5JZbGgmOd1F1FpR+RH/Q2jU/qspwBjcOQ686ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCqXWFRhkvuI5por1EDGytXl+5PRl5j5V5lB0ZDBaPeiF8aCv+/HEhFyhoWyhdvDJ9yS6Rtbpm2MtbJg+DdPpm1So/RpEecEioVUyGJGj9IzDAdfBMaxniyAHKRHw31DRQi4B43Gzd6qvEquHLhLRr7BZom3T2szkaEox67ZI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tctmUBUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tctmUBUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275A11F000E9;
	Wed, 20 May 2026 16:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296015;
	bh=5+4kt4StYy8kfO3KSAP55j1ULhGbsja7+UGqI8KlRc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tctmUBUA2anjWtDw41fXYRfImu8DWEUHxNqBZc2HW/r+wU9QgPHMIq0XBiz4QfYOv
	 GW4ZW98iroIi5EbLhTEGC5uqJuT01ZGqsJzGU7PVTnC9fnbwXdOk6f22ANriximj6O
	 s1YvpkA4XI37iWUJ0OZCpZLSyQ8YfUfOcBUiEks0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0638/1146] perf lock: Fix option value type in parse_max_stack
Date: Wed, 20 May 2026 18:14:48 +0200
Message-ID: <20260520162202.620854198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit cfaade34b52aa1ec553044255702c4b31b57c005 ]

The value is a void* and the address of an int, max_stack_depth, is
set up in the perf lock options. The parse_max_stack function treats
the int* as a long*, make this more correct by declaring the value to
be an int*.

Fixes: 0a277b622670 ("perf lock contention: Check --max-stack option")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index e8962c985d34a..5585aeb97684d 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -2250,7 +2250,7 @@ static int parse_map_entry(const struct option *opt, const char *str,
 static int parse_max_stack(const struct option *opt, const char *str,
 			   int unset __maybe_unused)
 {
-	unsigned long *len = (unsigned long *)opt->value;
+	int *len = opt->value;
 	long val;
 	char *endptr;
 
-- 
2.53.0



