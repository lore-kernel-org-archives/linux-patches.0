Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2537919FA7F;
	Thu,  6 Jun 2024 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683140; cv=none; b=PU+AIzAvsMEXGnWboJnuaB58mRFrEToE/F0r1V7lkNNRsRKyAqatNFtpUBOUcftuR5aJo5QkFZjhERsfA+n/tPq1IZt3YMIzLXNmvNeesvMaGU07O68kAkFMBUnGotKvoMJLk1eYDV39B1oPpCrwIf4Nbc6DRAbHNFWdx+yihb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683140; c=relaxed/simple;
	bh=icB+IGJwBXwGSMBu3CENpIYTcNWTU9a2b+Uc/CfzZ3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCePW7W4T6RlC5WNn7lGEQcjB1HhSLImVekOMTVmI7mBeLJ6UmbeGjNGTiletrmc4BYo9x6C8UBd4r3ZHznxtwjww8VsdyBWE6MbeCInBF2Uv+rViMLW3kle/PBtWYRscDyCZtiC+qLpR+rUVU/JSJcIy1xir5oAirXZURMoMAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbdmM1hU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbdmM1hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E32C2BD10;
	Thu,  6 Jun 2024 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683140;
	bh=icB+IGJwBXwGSMBu3CENpIYTcNWTU9a2b+Uc/CfzZ3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbdmM1hU6DhV4sdN9gLyk9FV08OvBcUhkuXG1BrgJEeFX7w790/p25oUbCdEM0I2n
	 xkuMPQTpPVGxLQzIN91zlmla1P+TSz/VqDLVaVD1e0jGqyLLrFOa8NM4V61Phkzi7S
	 IPGwnGmTRsZZC/7F+KGOisVGwa1Ac26fYDSDvpIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 012/473] tools/latency-collector: Fix -Wformat-security compile warns
Date: Thu,  6 Jun 2024 15:59:01 +0200
Message-ID: <20240606131700.232487271@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


