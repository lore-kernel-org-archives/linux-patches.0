Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54511DA60C;
	Tue,  8 Oct 2024 12:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391011; cv=none; b=QlTDlJveYs7YkKhNXGI13jcjXizF2uFc94eNaXMUe0XOCWLOtoc4FCNtwZ9cQCekDsU1uEfCT765qKhC4VydT/HxZ0/qle26wYqxNv7/1wJ5pc4Wqx9nWwdBxJncVo3W9+ExE8ioFoK1PPC+/FS5LUmfuUZ+bMj02VWOeGfdXRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391011; c=relaxed/simple;
	bh=5ZTmKkIK0UdHqcObQcFDI6bY1jRJtCXBQ+9J9r2NovU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrTUNwBSYG7W1Yt1G8VtnYVfG68IrfBpKqeIJmBrudTCOHj1NRTgLKoqTVBq9VP1fk9Wa/Zb+VArGcZlsijU6ujqIUfNUw91oqHHZIeOnSegF1dkAWwZBHrPG0iAnLPokqzt6Np5Tfgoe99Tqk0tEcX/LRo0PYUGCQDiZcHrAhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmsxPz0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmsxPz0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF55C4CEC7;
	Tue,  8 Oct 2024 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391011;
	bh=5ZTmKkIK0UdHqcObQcFDI6bY1jRJtCXBQ+9J9r2NovU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmsxPz0j1zfhVnU072mGoJ8s0Xq2SexaIdLwtybrRhGuyEl20wF7yxgmoert8uy/i
	 2ZKUw5pI+U9roFbHEh8wNcJQLh6hW3sKyHitsAJHm7LKissWumGWZvmx+Tzc6reBjy
	 7xD65pbwStnv+z+a/1ygPuhkSRTmi0zsFrjimep4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	Eder Zulian <ezulian@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 432/482] rtla: Fix the help text in osnoise and timerlat top tools
Date: Tue,  8 Oct 2024 14:08:15 +0200
Message-ID: <20241008115705.523508867@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eder Zulian <ezulian@redhat.com>

commit 3d7b8ea7a8a20a45d019382c4dc6ed79e8bb95cf upstream.

The help text in osnoise top and timerlat top had some minor errors
and omissions. The -d option was missing the 's' (second) abbreviation and
the error message for '-d' used '-D'.

Cc: stable@vger.kernel.org
Fixes: 1eceb2fc2ca54 ("rtla/osnoise: Add osnoise top mode")
Fixes: a828cd18bc4ad ("rtla: Add timerlat tool and timelart top mode")
Link: https://lore.kernel.org/20240813155831.384446-1-ezulian@redhat.com
Suggested-by: Tomas Glozar <tglozar@redhat.com>
Reviewed-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Eder Zulian <ezulian@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/osnoise_top.c  |    2 +-
 tools/tracing/rtla/src/timerlat_top.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -434,7 +434,7 @@ struct osnoise_top_params *osnoise_top_p
 		case 'd':
 			params->duration = parse_seconds_duration(optarg);
 			if (!params->duration)
-				osnoise_top_usage(params, "Invalid -D duration\n");
+				osnoise_top_usage(params, "Invalid -d duration\n");
 			break;
 		case 'e':
 			tevent = trace_event_alloc(optarg);
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -459,7 +459,7 @@ static void timerlat_top_usage(char *usa
 		"	  -c/--cpus cpus: run the tracer only on the given cpus",
 		"	  -H/--house-keeping cpus: run rtla control threads only on the given cpus",
 		"	  -C/--cgroup[=cgroup_name]: set cgroup, if no cgroup_name is passed, the rtla's cgroup will be inherited",
-		"	  -d/--duration time[m|h|d]: duration of the session in seconds",
+		"	  -d/--duration time[s|m|h|d]: duration of the session",
 		"	  -D/--debug: print debug info",
 		"	     --dump-tasks: prints the task running on all CPUs if stop conditions are met (depends on !--no-aa)",
 		"	  -t/--trace[file]: save the stopped trace to [file|timerlat_trace.txt]",
@@ -613,7 +613,7 @@ static struct timerlat_top_params
 		case 'd':
 			params->duration = parse_seconds_duration(optarg);
 			if (!params->duration)
-				timerlat_top_usage("Invalid -D duration\n");
+				timerlat_top_usage("Invalid -d duration\n");
 			break;
 		case 'e':
 			tevent = trace_event_alloc(optarg);


