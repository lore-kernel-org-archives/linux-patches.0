Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3143336404D;
	Sat, 12 Sep 2026 07:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198837; cv=none; b=lO0SO3YkGE7mjED8FGNUtv+t1yGvf7ipyN7ohi6VxhI0Hl4KvNKar0nA7E8OrCPXwPiQTItsCM52L9DtONgDsAcCj1xLkOExfvwCXBKx1RxcTagfA7duZPAKozUSAG62oPhrWiQmY2uuW+JXgCQInYu0oXboaXABXJ/gVCL1On8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198837; c=relaxed/simple;
	bh=jKYkYoCPDubDMjcfQD7yl64pm1AuQFJ2mTJAcEU7yt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7W3+2scDIWnZwvNnuL0a1uiAzvSVzjDefOcT/nAOQ32562pc06Gq27i9iX1mMo71bH5I2jS1EQqh1x3RC0lnIx/sOiJbmoxlOu1aUGxs9ObY1D4tD1TttDRQ+h1PMV3MJVRmmIc+iTvDnS2i4ZS2LW209dKCkXwC1/2RqC3MzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lMP5Pdt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lMP5Pdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA0A1F000FF;
	Sat, 12 Sep 2026 07:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198835;
	bh=L1vr360BuxFTzB4okj7o5OWv3ayj7dCQHTqxd0bZ74s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lMP5Pdt6o9VdeQCoHpTtwzNrUiOqCsPv8c2kdghEF+WUz9TeL+3JnAWsLT0Ol3tL
	 NL7Xy9Rhp9KBimtnGzIyq/wsnzNQBuwA+/blI82bK7lAZ9r/00Ni2YEdOX8VaDxTLp
	 HmNhFNYuOc4kvdQzYe5Rij9dUYVOdbirLAS015kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>
Subject: [PATCH 7.2 0455/1815] perf sched: Add missing perf_session__delete()
Date: Sat, 12 Sep 2026 08:36:45 +0200
Message-ID: <20260912065659.571459932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 2bd4ad6914ed73189ccc2fb2740e94dafd1a9a8f ]

The perf sched stats record missed to release the session and ASAN
reported a leak.

Fixes: c3030995f23b ("perf sched stats: Add record and rawdump support")
Reviewed-and-tested-by: Swapnil Sapkal <swapnil.sapkal@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ae033ffd1079a..a91921fb3b736 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -4023,8 +4023,8 @@ static int perf_sched__schedstat_record(struct perf_sched *sched,
 	else
 		fprintf(stderr, "[ perf sched stats: Failed !! ]\n");
 
+	perf_session__delete(session);
 	evlist__put(evlist);
-	close(fd);
 	return err;
 }
 
-- 
2.53.0



