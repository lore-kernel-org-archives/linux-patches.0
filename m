Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119FE269808;
	Tue,  8 Apr 2025 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111695; cv=none; b=HW3DIcd+IojcgQFxVm/S0uhlwoA8Q5QAR/SX4hpDMPvEeXAcVFdRcByXbdonx6cRwiqp0yrb+1uUPB7eE+HoElS4p3A8a+xi/USARGYGi+Gdp1vorAttGv4mn2xM5GygTEWqAZ9MtVeKvnxPJatnnyryEtZvI6uUrjDL2jGTeUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111695; c=relaxed/simple;
	bh=z3VwmTuq0TZE+mbqH2ERc33x1+w+2H0Zx4If/houmAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=om+KBV+NTZ8rRZYxBwac9/00Cdioa8zf7HHP90m1ZG1UNraPwl0QsyqvywkkMNiMFQ73A+Z6xwViqssyr17Zas9X8nVlWHGFD0r5MzTIqeWHgoCoytsTHJUmUdKcBSCLeo/NBbh7JboNKuWbDYkDdvghxMrK6fu9I6IkRFr9mP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnC4OcCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnC4OcCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939B9C4CEE5;
	Tue,  8 Apr 2025 11:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111694;
	bh=z3VwmTuq0TZE+mbqH2ERc33x1+w+2H0Zx4If/houmAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnC4OcCxtDXxF/urzbc40pm47qTfStLUaeuGHi0B+CgtHVaS6AX8WaLKbdZV1Hp6K
	 gWQD8Er+lgqA+I4FHWXsuAYMij4bYO4YJAPdzsgAQTF44pVaQh+UUo0sX45enJJaCD
	 Pp242RU2vtCvutmSTZSIfRbzRgkYKADt1QkLSlf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 526/731] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:47:03 +0200
Message-ID: <20250408104926.506871590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index b4bc57859f730..ae6bcd39a2001 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -47,7 +47,7 @@ struct pyrf_event {
 };
 
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event ip"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
 	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
-- 
2.39.5



