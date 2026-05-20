Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082BC3D75D3;
	Wed, 20 May 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298697; cv=none; b=ohTJk3DzQCTYdCNTFPH4IfSBTnKrFCVhsJ/Hu6ZgMo1JTskKSKzEBWkPQQ+YMFHhLGs1Ac1Hy8FpZZODhv83p5qnPB6DeH7xL0vfu/qrqPTmWio5rIQ7hhziLp+DgN72OvwyUtTGxZMvAX0lEktVap9RTs0K/Yylxf29rR7NPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298697; c=relaxed/simple;
	bh=z2PnkFdJDqCzD4b66Gb0/GjGmjnCdzec1bppY6+APl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHPVSXxmhOQ4hE0OSybFkwtI9yFe/P3b9Ieu2MEU7bRKxl2tauFtUPNnpSDDDmV09pe2o/0D+TQxUbLyInS66D5wRHEQcZVD4q6Y+HPOFU+hQjbhYLkz33470AexCAgRThC9NG4oO2Dr8U+VLweKUsHdncoo43o1nMHgFjYdP90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4fpWSCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4fpWSCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAFC1F000E9;
	Wed, 20 May 2026 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298695;
	bh=cS7u3K2Zj6/Qtz6nrVj8r/zUjNRu1AL48UTpRZudQBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4fpWSCInWIFArh2jJNhUhf5gdqMdaZB78mkvJi3kpKmXRzcmG61zSA65Gf1JyhIp
	 5LbEkl2s3XwrMMsc9WZSRLNdxMLWQlADh5s1Q6bUBsvkliaXcf+UiUMxL9eu4CuZD2
	 IkJX8ueVcdP3zZhhWPEhehp6OJTYclwOE13bZue8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/957] perf lock: Fix option value type in parse_max_stack
Date: Wed, 20 May 2026 18:16:32 +0200
Message-ID: <20260520162145.574874291@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



