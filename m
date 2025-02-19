Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C881A315E;
	Wed, 19 Feb 2025 09:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956256; cv=none; b=cikiQjv1bXhBGiMU6zOBLA4dPISoxNYyun+jAXJuz2dIlUn14W1iU/JG4PTXesAHYoz9eY2lKrIIJnmx2b23hRN4WOAhP4A82TrsFMoNjcxjRQccnY/6NE3Rd5/sGTCh4P4ImcT3Gvj/+VWm3oOXPAE3Z01EEGFafU2yc1ccKak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956256; c=relaxed/simple;
	bh=XpNFDKmkDwtqcNadAbgSOC9iaNqwoULKLFeTKKeu2Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ/0FbmYv0dXTaHDBMxPAlxEKOy/B6CaEJNTgHAR3kx24vnSyCOeCDoJJUH903RlipzHt7zo/r4Vb4Wno2iuOGoWRjtjj79JYH+wYCV/L8iFJCYlxmS3pOXxXAuHHmW9dPBKi1nU7zAC6lEtrB6H2qpXf5q7x7+CfqKD2sLQyPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kI7SRWOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kI7SRWOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F98C4CEE6;
	Wed, 19 Feb 2025 09:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956254;
	bh=XpNFDKmkDwtqcNadAbgSOC9iaNqwoULKLFeTKKeu2Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kI7SRWOJwwj7cTiaYNMc6Vx+tCQtrjfyaqzHe27DutP0TYv4xH+FA/cwyvngVQMVs
	 xI22UXaZD1poYlDPHNfx+Y/jvzLefBe/EsfWt3UFAfe2NBW8QB1hw+S9UyPz/h/jyC
	 +M6K6GiK+STuXz0LfFa6HsS6nJEs7FrCzQ590g2E=
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
Subject: [PATCH 6.1 118/578] perf namespaces: Fixup the nsinfo__in_pidns() return type, its bool
Date: Wed, 19 Feb 2025 09:22:02 +0100
Message-ID: <20250219082657.624275302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe59c2b9cd624..33cf78a4a28b5 100644
--- a/tools/perf/util/namespaces.c
+++ b/tools/perf/util/namespaces.c
@@ -237,7 +237,7 @@ pid_t nsinfo__pid(const struct nsinfo  *nsi)
         return nsi->pid;
 }
 
-pid_t nsinfo__in_pidns(const struct nsinfo  *nsi)
+bool nsinfo__in_pidns(const struct nsinfo *nsi)
 {
         return nsi->in_pidns;
 }
diff --git a/tools/perf/util/namespaces.h b/tools/perf/util/namespaces.h
index 62a9145a6ffba..c108972a97ef5 100644
--- a/tools/perf/util/namespaces.h
+++ b/tools/perf/util/namespaces.h
@@ -57,7 +57,7 @@ void nsinfo__clear_need_setns(struct nsinfo *nsi);
 pid_t nsinfo__tgid(const struct nsinfo  *nsi);
 pid_t nsinfo__nstgid(const struct nsinfo  *nsi);
 pid_t nsinfo__pid(const struct nsinfo  *nsi);
-pid_t nsinfo__in_pidns(const struct nsinfo  *nsi);
+bool nsinfo__in_pidns(const struct nsinfo  *nsi);
 void nsinfo__set_in_pidns(struct nsinfo *nsi);
 
 void nsinfo__mountns_enter(struct nsinfo *nsi, struct nscookie *nc);
-- 
2.39.5



