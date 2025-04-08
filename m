Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DD226981A;
	Tue,  8 Apr 2025 12:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114057; cv=none; b=UCWweYFwXyGYFw8tDuBYcj+dPEUuzL/VzPUzWSDo/YcjWXjyS9eXu+5BNo2CUeX0lrXybD+1Iu9gqVL2GMRV/BJSDSLFiS2Bl9qjtJ8Ycp7UPwwIx5/srZw4bBdpkC/XphmPZ/9CjHNvYKo/9h3/CYZ6wNbfddAmXTcSTgYSyow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114057; c=relaxed/simple;
	bh=wH6+vwWFOaWUB2/kmQY/luY+3wAtQVTnrAgkgLu6gTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Snbp9tuVnuvQdFIJlFA66RAOvQooABm8SimL/KQVBTT2l4zHxFR1ayezXLnrpKBpkjm4c3ejCZeT6tIRAYKBLiKcQEgOGE5nLXItwhJ3Q1QqlxxMSgm8GRgjlumFLlDZnLNcxuyiqON1UQUS7YUZ3AFCpIiqHpkvS/OIG2rsKKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=es4M0XLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="es4M0XLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E9CC4CEE5;
	Tue,  8 Apr 2025 12:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114057;
	bh=wH6+vwWFOaWUB2/kmQY/luY+3wAtQVTnrAgkgLu6gTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=es4M0XLUPOLyzaLmK+KoUExfknxgc64BQ4+h+eEd9EItB7ZZYGzhu6nuUn4VSLNdl
	 6jXbf/PcQqwrGQG3QzRjixfEK2kXI5QUATRgZ0I+VAmFzdQNWNuvcNmZ89DxHZD4o5
	 lcIaH6pHCXN+Y2RuE5L1HMVFIZ8C+heCJ6Rn7/r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/154] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:51:02 +0200
Message-ID: <20250408104819.193308301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 02460362256d1..2ff87ad8d7e88 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -110,7 +110,7 @@ struct pyrf_event {
 };
 
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event ip"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
 	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
-- 
2.39.5



