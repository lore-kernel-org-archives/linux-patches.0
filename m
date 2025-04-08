Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D00A94A;
	Tue,  8 Apr 2025 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112942; cv=none; b=MR5xNyGd9ao2kmHwTVb78FiUXrUXEoequKSx6znkJF5UgagkGW7noxtsrVt4U3rXU6Za3DnXs1HAyQLdiDgHMoF/6YdeSSLsSacPGMewH7S6kFh+f31ieKQrXQtjsrvSZBnrRMDkaXdKI1Zc3TJNl04DNcmat/H2fLj4xAp7hLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112942; c=relaxed/simple;
	bh=QjIy4301mv9leJz6ftYfTPBZ45308ZQgR+/acAVyPPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvQIFWKsCT7ZD1iAdStvyekTeBn8JXIeu//hQB1liivyE4klvdzIkeTI0jDzdZf65mjGYlUG+LyDf8IhgqkC0ZyliR2xEQN6O1qBPcJxIDXCfCtK+U8yfQpdaUPghdIFhMBEL5CsNMmKwH3mjHHFYRYmKVx1CDrJTHQ7W7wGH0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoGPllOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoGPllOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D4CC4CEE5;
	Tue,  8 Apr 2025 11:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112942;
	bh=QjIy4301mv9leJz6ftYfTPBZ45308ZQgR+/acAVyPPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoGPllOjxkkia4DA2I9doCjuhu6/mhWVLiRmeV7oLHQx7bXMZPzzeg/tdTL4s1hwc
	 44kELNCdi4wdEpPx7aHg/o5cMg22RyoWGnSgRzvh+xbUvdSzriTwVCWWkHgeRUQHgP
	 A/Nxdzss0AtKxcbmieuzXGERQQ+A7nh9vKqKR/Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/279] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:49:49 +0200
Message-ID: <20250408104831.902806718@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8feef3a05af7b..13d65a3cc6d7d 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -158,7 +158,7 @@ struct pyrf_event {
 };
 
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event ip"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
 	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
-- 
2.39.5



