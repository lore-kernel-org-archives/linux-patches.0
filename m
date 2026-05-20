Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE52847B434;
	Wed, 20 May 2026 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302402; cv=none; b=KG7WozheBux+uE1UjfeIwNdeAv8Tjg0DtNQILlB0krilzzshOptyL6xOi90imeq+qd2POWgkwSH1q7zWQtx9BORIOxau+hgmlfjFhtYYujH2uKNEpuaxtp0i7Sb8myfZzP1X1PxB8XZIBqIVcK057Jy7hGISdg6dpMQHb/CAiDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302402; c=relaxed/simple;
	bh=2AyjC7xyH6gKg8nDK/Gu2hNZ0X7BmaPyKP+qaPtWCeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJIUP2rOVQgMADQI8aPnPfPb8H1Xp+gf6bDm+APbcRQt63Azk79UfvxfKmX9wUdi8O/vahMLm5kg20dEJLJcTCKZLOR2BRno7VkUvMj+H44DJOJVnI+axpWpNuN0j8h5Hl2+sux1D169SgFLl0r2CKQl6pt4IMytKY6je4DeXVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdGtUrlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdGtUrlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DD51F000E9;
	Wed, 20 May 2026 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302401;
	bh=2KH1mipiqbvlMsrU6/PEkUJFKjQnos03fITxO+fyysc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdGtUrlTIBOI+eCqG0+20p6ru2jL34gLzZc3MIdb9d2dXGhn03k2Z/jp8vefvibs7
	 0alRpNoJVVGDMKyy05NgVYiLi2Wzgx4hkaElqTdkEgwR/ZHOYpz923zXn1CohOkOrc
	 g6D+aHtqGiTj0JlvQBNArZrWrZnbf2UT8IOgnrHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/508] perf lock: Fix option value type in parse_max_stack
Date: Wed, 20 May 2026 18:21:14 +0200
Message-ID: <20260520162104.087389584@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bd24ed0af208a..bd294fd574972 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -2271,7 +2271,7 @@ static int parse_map_entry(const struct option *opt, const char *str,
 static int parse_max_stack(const struct option *opt, const char *str,
 			   int unset __maybe_unused)
 {
-	unsigned long *len = (unsigned long *)opt->value;
+	int *len = opt->value;
 	long val;
 	char *endptr;
 
-- 
2.53.0



