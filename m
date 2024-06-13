Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566C73209;
	Thu, 13 Jun 2024 12:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281680; cv=none; b=EoKz5HwoG/oV/CpezU6OMkxe98W11LSEptCDaTFTq5tX7yC5ZYwwVEEMst0yH5jyTlscsNNt4qhr6pMkrKJs/Kca9gL1oimeDuoQncJAvphCoC+GdrRScq6bIQ3oZ/duO49OAAjDI+2avrWQr3UZ+ZLVtmOyG4M+7Sdu/S7pjZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281680; c=relaxed/simple;
	bh=a13VL2ywjdMB6u37GGkSMJG2dAnhQ8jdyfwa2GVPlIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2VZSx/5gEArKdpzRhc6YVyONAgg0MlAzsnXlKJ87vCZndf4/6hgi9LDhd9AnWDZmG5DFgW5BjhuSlAIqLSRxOE5oqpAc6CeZRF5M1R2yPhLbvm1agt5P2PQnh8p3Y6pbHEfII6RkvGZmLJxoWfYKCSLoHFpomKi9aaiu0iwRig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hG25Y13m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hG25Y13m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF12C2BBFC;
	Thu, 13 Jun 2024 12:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281680;
	bh=a13VL2ywjdMB6u37GGkSMJG2dAnhQ8jdyfwa2GVPlIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hG25Y13m18N5BImLEeI6Op51lAZH9Xq8E2LOBwSHIfpzMmMfKKU23R7tg7uXQECii
	 itB9xA6ymHUxW3vHtmObz5vGeOtS0PWMQ9c4GoEgGk8gMLBNJEFXovtuLsWVeodk62
	 1mi03pE//w885qJs6CPNPROfHfVGN3G3i2pHBAG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 009/402] tools/latency-collector: Fix -Wformat-security compile warns
Date: Thu, 13 Jun 2024 13:29:26 +0200
Message-ID: <20240613113302.500787114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 tools/tracing/latency/latency-collector.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/tracing/latency/latency-collector.c b/tools/tracing/latency/latency-collector.c
index 0fd9c747d396..cf263fe9deaf 100644
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
@@ -983,7 +983,7 @@ static const char *find_default_tracer(void)
 	for (i = 0; relevant_tracers[i]; i++) {
 		valid = tracer_valid(relevant_tracers[i], &notracer);
 		if (notracer)
-			errx(EXIT_FAILURE, no_tracer_msg);
+			errx(EXIT_FAILURE, "%s", no_tracer_msg);
 		if (valid)
 			return relevant_tracers[i];
 	}
@@ -1878,7 +1878,7 @@ static void scan_arguments(int argc, char *argv[])
 			}
 			valid = tracer_valid(current_tracer, &notracer);
 			if (notracer)
-				errx(EXIT_FAILURE, no_tracer_msg);
+				errx(EXIT_FAILURE, "%s", no_tracer_msg);
 			if (!valid)
 				errx(EXIT_FAILURE,
 "The tracer %s is not supported by your kernel!\n", current_tracer);
-- 
2.45.1



