Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E37266583;
	Tue,  8 Apr 2025 11:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110150; cv=none; b=miQDp2zTA1fe0jHqpglSpBvDBWfFDoOHNLReXGrxVQlM7vvkIi2aaTE5Q8+dRVE+JwxIkn7R2Oy6iE+46wHvup/F0ay1zMRH8ywaBNcxsEeUk6q59d8XhPHzpWjyjZ/ENlehkQiIbdMr3YkurkckIua447EP2X/68RZsqwQnH8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110150; c=relaxed/simple;
	bh=CPa9kdYkXdIwvl3GcTPxPNuba86TNciOQ+036aQKqYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsG7ECNSpPHd1ZfW4w82onhCaW/4lF+KtgvacAbaWclIAeB2kmJCFG8VCrZ9ArGVhVcOdfrfPpdXX7orbERwlqIqMARqqCr16dmp0d1tG0ypX6tuzq5D26VG8GqRgCzOuPVMR0h3tUnmQZvsOadotmJvDpBXkuKg29fWNK6sOYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLzL4b9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLzL4b9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF3EC4CEE5;
	Tue,  8 Apr 2025 11:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110150;
	bh=CPa9kdYkXdIwvl3GcTPxPNuba86TNciOQ+036aQKqYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLzL4b9Dxo3AuKaF30bH/tHS3Ra6wJecrr61crSOMuhZBDKvxFmMMYJDyHBIz7LD6
	 P1X1GtRNiZDfoIF7ocmSgKx9Q5/28LjdgoU6cr9za4tJ80nnEYc8sTKcJ71GSYRs4/
	 oQeF6DgithFUPay4KnFxScYbXyFlwZrO4oA5kD4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/227] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:49:07 +0200
Message-ID: <20250408104825.386022794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ae8edde7c50ef..51679d8d40b1b 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -131,7 +131,7 @@ struct pyrf_event {
 };
 
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event ip"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
 	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
-- 
2.39.5



