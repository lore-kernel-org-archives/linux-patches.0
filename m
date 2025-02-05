Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED47FF510;
	Wed,  5 Feb 2025 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764496; cv=none; b=dMRMMv7NEN7uQiXKWsRxkf1XQjI1XJUUdDBcp4tqZxqTjvP0QwDUqFEM1xeFaeVjD8LNly7OSBv6lRB7kkDILnJaa/QS+OxsPGMzcAa2fOSeQtpe0OGoFBVb+MP4Iu0h3gz2I7ZwjYqgYOT3JjSvmpeCL29TC5OJJOvIhrJIAc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764496; c=relaxed/simple;
	bh=VXxuC8TSGs3nczTIePN17vtAHlrDaLQdteJbJdI3Yh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ed43jedC5UMLxoXyvBV/cYd4uKE8Zpf7enC6PyrGYecGKa8Q52Hk5GOXSqmPP4w9jQlciJiZ8de7Jwm9i35HXaDrFt9ZGpgxfvdmp7w2NU7H74BaBdNXCG0zNhpIcht5rkbDxXHQN6yXv9ZGxQ0bOcxDMtothgYyUc82e1FoJbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2i7sNkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2i7sNkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66F9C4CED1;
	Wed,  5 Feb 2025 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764495;
	bh=VXxuC8TSGs3nczTIePN17vtAHlrDaLQdteJbJdI3Yh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2i7sNkX0LsDf8uFbaxiX5MLfU/Pwk8HzIjjU2Q/2mha+0VTRL2gubV+7cVtnhfNH
	 5RgasCCV+LPpNDDGylmeInme1c1pCmLUpHENWOeY9k8QwLWr+3lbeG80fmr1r4S9u0
	 dGu0/xzVYtpe5zPEzmlJRMnX/aapGbEihgKuVSck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Nigro <fnigro@redhat.com>,
	Ilan Green <igreen@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Clark Williams <williams@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/393] perf namespaces: Fixup the nsinfo__in_pidns() return type, its bool
Date: Wed,  5 Feb 2025 14:41:36 +0100
Message-ID: <20250205134427.070256822@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

[ Upstream commit 64a7617efd5ae1d57a75e464d7134eec947c3fe3 ]

When adding support for refconunt checking a cut'n'paste made this
function, that is just an accessor to a bool member of 'struct nsinfo',
return a pid_t, when that member is a boolean, fix it.

Fixes: bcaf0a97858de7ab ("perf namespaces: Add functions to access nsinfo")
Reported-by: Francesco Nigro <fnigro@redhat.com>
Reported-by: Ilan Green <igreen@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>
Link: https://lore.kernel.org/r/20241206204828.507527-6-acme@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/namespaces.c | 2 +-
 tools/perf/util/namespaces.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/namespaces.c b/tools/perf/util/namespaces.c
index 36047184d76e2..68f5de2d79c72 100644
--- a/tools/perf/util/namespaces.c
+++ b/tools/perf/util/namespaces.c
@@ -266,7 +266,7 @@ pid_t nsinfo__pid(const struct nsinfo  *nsi)
 	return RC_CHK_ACCESS(nsi)->pid;
 }
 
-pid_t nsinfo__in_pidns(const struct nsinfo  *nsi)
+bool nsinfo__in_pidns(const struct nsinfo *nsi)
 {
 	return RC_CHK_ACCESS(nsi)->in_pidns;
 }
diff --git a/tools/perf/util/namespaces.h b/tools/perf/util/namespaces.h
index e014becb9cd8e..e95c79b80e27c 100644
--- a/tools/perf/util/namespaces.h
+++ b/tools/perf/util/namespaces.h
@@ -58,7 +58,7 @@ void nsinfo__clear_need_setns(struct nsinfo *nsi);
 pid_t nsinfo__tgid(const struct nsinfo  *nsi);
 pid_t nsinfo__nstgid(const struct nsinfo  *nsi);
 pid_t nsinfo__pid(const struct nsinfo  *nsi);
-pid_t nsinfo__in_pidns(const struct nsinfo  *nsi);
+bool nsinfo__in_pidns(const struct nsinfo  *nsi);
 void nsinfo__set_in_pidns(struct nsinfo *nsi);
 
 void nsinfo__mountns_enter(struct nsinfo *nsi, struct nscookie *nc);
-- 
2.39.5



