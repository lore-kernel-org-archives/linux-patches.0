Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B728E29B78D;
	Wed, 20 May 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300944; cv=none; b=sCtejLJJb9TcXKwkBxse0sPIfobh42UZhdHQ5P6cLlZkVwuEfKGKPAL4youI3tlvOWms8yEOCzCjlZKhNqWhtj+1Euh75lmBzAv92UpyQaL9KlsgBgfalxpwuvCoX9osn1+E/9hqafwkxXz4BVOY36fDS5PxmMvm5VEHiD1TSLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300944; c=relaxed/simple;
	bh=FHlQG8yot6eJioJ7S+Xe5K5P/nQUlPg4qp8OXIzCvCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h752hmuHjqOtjHKUqzUt6j42Mo+f+UKf9IIwOvtAX9GcDzt10x18Ik3hgCO3xXT/P5h1aXSrVNFV0FC7QSFu8LJQRZ1dGhxSa7RBNfNXe6jU2Dfw5K7eWtAcYm6xJZ7hUVZM6luy0lT1Qd4P3iaoB2P95ZM9+8YY3KiNB5Cq6uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAe2i87X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAe2i87X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7091F000E9;
	Wed, 20 May 2026 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300943;
	bh=WWrtg144gcFJbxAE5bX7HnL/X3n90cTS7impLggbR4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAe2i87XeeiK2HSxDosroTc4lLK2yJmfPsljfSTZidsKi7sPvXTekISowS1Buk8i7
	 MquR03QXuzwPg5i2+h9hp2wtwjLbwRxUanP3gA9Lk7NqtT9y8YwWr3SCh6bPRnrp9Y
	 NnF2QuSrQ/XYlZnywYtGqn7Acbx7Yxjs/rnh35Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 367/666] perf lock: Fix option value type in parse_max_stack
Date: Wed, 20 May 2026 18:19:38 +0200
Message-ID: <20260520162119.197093837@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 33a456980664a..3d490ea46551b 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -2300,7 +2300,7 @@ static int parse_map_entry(const struct option *opt, const char *str,
 static int parse_max_stack(const struct option *opt, const char *str,
 			   int unset __maybe_unused)
 {
-	unsigned long *len = (unsigned long *)opt->value;
+	int *len = opt->value;
 	long val;
 	char *endptr;
 
-- 
2.53.0



