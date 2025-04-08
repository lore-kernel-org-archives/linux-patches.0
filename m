Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235E268681;
	Tue,  8 Apr 2025 12:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114953; cv=none; b=fOA3SJ9biy0dfNykSJfGlsDPrJ52X0HhTbRShx+RG0k95N8PTTVw/QlHcSrQCya7/rp/Sd9uOAEs3SLg1UP0k+u6/NqdT3C149oMwyqXIwt/Qa7NvkTQetpJA2zN9s9t3BvNtqPwQqh5OENWEFe1Ft3pIxPOoiQcaM411vfPmPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114953; c=relaxed/simple;
	bh=S6ShDeK055+SBCVnHDW70J7WA8me4LNVLNgToXFJYqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohWG/Rl8o5Ekn1dG+iPYKRD2zucqgxGRfD71CjHzmoKscf39HFbyHLTX+rMGTWFJ4xYE1QOmv8my6VTMNrgqKXTwx81ZXMJeMIVYVGq/Drr1rfe+aynuCvhvzyhICnSuc3UiqvCPcWzkZxg/y+yoVrqqdB9/pc1K5y91jOL8CjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqiMGYQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqiMGYQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C9AC4CEE5;
	Tue,  8 Apr 2025 12:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114952;
	bh=S6ShDeK055+SBCVnHDW70J7WA8me4LNVLNgToXFJYqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqiMGYQYKEXGJBU7ST8t6RWZm/PO9zZci/IYr7GZQdsDLB4t1kiSK4DhYAcP11AE2
	 l3SMYaeFsxfnS3EJmdl9OSHt+OVRge9cjl9v0ulKP0Ocqj19HLnSyOX/Ku+ru/ItdE
	 1SIh0CcVkcfzsZCaE2Bl5hL8FA6E+bZvYurGhSqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 256/499] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:47:48 +0200
Message-ID: <20250408104857.596802558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 2096cdbaa53b4..14d7347ac0f38 100644
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



