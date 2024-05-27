Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE51E168C4;
	Mon, 27 May 2024 19:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837461; cv=none; b=QJsW+KW6aZ8O+eRT7aOBH5FLwtk893B/LDe4vP2/O+Uz4hweUTR8vDxhNMslHNLR4BHksRTJ7pthqako6qrMIWLRxcI7cfIWXuBd/f048kXLNDWqvbpkyUsSbll3vcnmKGG/eoDWfEY7i63JPAHp5n0P+GG7AnsNkG/tVJsypzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837461; c=relaxed/simple;
	bh=PJpwb/acKnxI6u9YOszAQz1QO0P4MiBZvP2NKWYBgsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P3cIwulGwGEyGF1iyck/dQBtRFz7uDwOk9ASUDaa4bKUksifdB1hd4bLpmf46bll+9XLFdhd7sLg77it91JFFK6wgBT8JsV3JS9b4iwaIx6xKqiTaZPISaeG6+Z8b2uq0KiMBZh9uTKSJg9WT9UUjwlEBuKnkravKTjr0aA/6GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WS9veLuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WS9veLuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D04C2BBFC;
	Mon, 27 May 2024 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837461;
	bh=PJpwb/acKnxI6u9YOszAQz1QO0P4MiBZvP2NKWYBgsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WS9veLuSyWBiFx9r0syZMbPFuc69zSzELQjcu087LdwpV+nTg5gxwaqObGKebOQd+
	 MMUTPUzRbdtawuAMQIjJsrXZUkSFrEon/ehHcF556PoqJ0teyhMm9jGXD+7Md3TRXz
	 CaGf9U/jUjluWhmEcWl4Z+nadoR9ziSYe0GsV4aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.8 020/493] tools/latency-collector: Fix -Wformat-security compile warns
Date: Mon, 27 May 2024 20:50:22 +0200
Message-ID: <20240527185628.519584307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <skhan@linuxfoundation.org>

commit df73757cf8f66fa54c4721c53b0916af3c4d9818 upstream.

Fix the following -Wformat-security compile warnings adding missing
format arguments:

latency-collector.c: In function ‘show_available’:
latency-collector.c:938:17: warning: format not a string literal and
no format arguments [-Wformat-security]
  938 |                 warnx(no_tracer_msg);
      |                 ^~~~~

latency-collector.c:943:17: warning: format not a string literal and
no format arguments [-Wformat-security]
  943 |                 warnx(no_latency_tr_msg);
      |                 ^~~~~

latency-collector.c: In function ‘find_default_tracer’:
latency-collector.c:986:25: warning: format not a string literal and
no format arguments [-Wformat-security]
  986 |                         errx(EXIT_FAILURE, no_tracer_msg);
      |
                         ^~~~
latency-collector.c: In function ‘scan_arguments’:
latency-collector.c:1881:33: warning: format not a string literal and
no format arguments [-Wformat-security]
 1881 |                                 errx(EXIT_FAILURE, no_tracer_msg);
      |                                 ^~~~

Link: https://lore.kernel.org/linux-trace-kernel/20240404011009.32945-1-skhan@linuxfoundation.org

Cc: stable@vger.kernel.org
Fixes: e23db805da2df ("tracing/tools: Add the latency-collector to tools directory")
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/latency/latency-collector.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/tracing/latency/latency-collector.c
+++ b/tools/tracing/latency/latency-collector.c
@@ -935,12 +935,12 @@ static void show_available(void)
 	}
 
 	if (!tracers) {
-		warnx(no_tracer_msg);
+		warnx("%s", no_tracer_msg);
 		return;
 	}
 
 	if (!found) {
-		warnx(no_latency_tr_msg);
+		warnx("%s", no_latency_tr_msg);
 		tracefs_list_free(tracers);
 		return;
 	}
@@ -983,7 +983,7 @@ static const char *find_default_tracer(v
 	for (i = 0; relevant_tracers[i]; i++) {
 		valid = tracer_valid(relevant_tracers[i], &notracer);
 		if (notracer)
-			errx(EXIT_FAILURE, no_tracer_msg);
+			errx(EXIT_FAILURE, "%s", no_tracer_msg);
 		if (valid)
 			return relevant_tracers[i];
 	}
@@ -1878,7 +1878,7 @@ static void scan_arguments(int argc, cha
 			}
 			valid = tracer_valid(current_tracer, &notracer);
 			if (notracer)
-				errx(EXIT_FAILURE, no_tracer_msg);
+				errx(EXIT_FAILURE, "%s", no_tracer_msg);
 			if (!valid)
 				errx(EXIT_FAILURE,
 "The tracer %s is not supported by your kernel!\n", current_tracer);


