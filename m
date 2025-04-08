Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BB8269D01;
	Tue,  8 Apr 2025 12:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116634; cv=none; b=JJApXmO8z2BFonE2FyuUh3Bn0iKSJAw2wajQYbZIUm7xe72s9wCtvCcd820pUEtptLs8jnH5tDDMzqrmey0l8/4BzRWH6Y3S+MpVb+mhIDPHkKgKyg9GHuoJWGmV/32lblSNIdze29gL8biNCHekOVCpapokG64vMKwbjHvHAn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116634; c=relaxed/simple;
	bh=cqeYDQKmv7QWYHiZuYFW8GGM9Dc7tSrnHR8Bm/DJHqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAj7zgK6HiVkV0fXpOO+fvJBPXOtoyOEztwdExT5Hd5K0PX9IimlKBfHXwmjjgt+UZODoLonRzMT5S2APgregFoIDoXvx6VraDxH1t9x4BkJXa7mKD1mZMDFq0a/nestrU7NypjHQozmwG751RMDOzdaYIvZXnp4BYUjBjBP9h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWVYnZHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWVYnZHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D006C4CEE5;
	Tue,  8 Apr 2025 12:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116634;
	bh=cqeYDQKmv7QWYHiZuYFW8GGM9Dc7tSrnHR8Bm/DJHqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWVYnZHwryLucLurYocLgSncC+UUH4kYEGbH+dcArm0+cNeDggagiXljQk1q4w+vm
	 alx2E0zXGJFvzaO6akNaVrtvHa5Qyw0QkhhJDOrzQ+eN9N8rx250mmw05rcxN7wHkb
	 OXC+tTt9jv3/5MhwJxxAoVSOFuXdVZ/Ja0yiU2VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/423] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:48:57 +0200
Message-ID: <20250408104850.647102313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ee3d43a7ba457..80ca08efb9bfd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -79,7 +79,7 @@ struct pyrf_event {
 };
 
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event ip"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
 	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
-- 
2.39.5



