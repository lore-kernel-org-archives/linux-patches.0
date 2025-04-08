Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E2F268C66;
	Tue,  8 Apr 2025 11:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113367; cv=none; b=dTqx0gRuStbDgLKeMtP3xa0uVlaKrPuNjC7dDPg4xBPbXNV5Pn/UZxjHXU0EUU9m1VaSA8q1xeXNu8lYTtjutuG9fQz8x+kMFB+VnwfuRzteVZqqlPMUN7LBZIV9Ui4q0IMup1F5klmvqdJwEmnF4DH2Y0g9XcOftDd1JzgVjD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113367; c=relaxed/simple;
	bh=+7sh84ocRXAQYxNjR1hvttPaKHiXrQVdvXV1iDqXHyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHSToKcRZxjn5EbCv9NAIqBwyzbSHQg06USNP6RVAfbJy8kGsHKxjC7XpPx0FtyNNIl0V6noxRkim6lnmd7pQln5C+MTWhiR/V8Ud/upqvqdu3R9ejLY6dNe1Nxw/Gorwf3MKtRoF2Y5NN3Lno/IuE3chP1bgYI5sYYiTEj+xXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYxxZ8ja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYxxZ8ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0575C4CEE7;
	Tue,  8 Apr 2025 11:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113367;
	bh=+7sh84ocRXAQYxNjR1hvttPaKHiXrQVdvXV1iDqXHyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYxxZ8ja8wEcmzUuS4Jnxg4aM89ES6C6ZWrV4QYEkNDiPt1sH55lxpL7iV6i9ECM1
	 3EGoq0M9YzXWKBn9wCHYfLeF4W0uUslfDx+7GWGRHb8QofSrtW0aAUYXndYq9ioMDd
	 8UMD9Ge+UqJZhfHjCp1r08myCRqhJspjBOIMkqrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/268] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:49:04 +0200
Message-ID: <20250408104832.102822470@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 1376c195e8ad327bb9f2d32e0acc5ac39e7cb30a ]

Some old cut'n'paste error, its "ip", so the description should be
"event ip", not "event type".

Fixes: 877108e42b1b9ba6 ("perf tools: Initial python binding")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250312203141.285263-2-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index b01b0e5510563..8753c9d3670ac 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -238,7 +238,7 @@ struct pyrf_event {
 };
 
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event ip"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
 	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
-- 
2.39.5



