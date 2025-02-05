Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFEE487BF;
	Wed,  5 Feb 2025 14:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765834; cv=none; b=C1GzUdSlm42uzYfYhsEkL5ly4nB+GeoZTOdJBoLrom6gu8NO4MZWKurEDO9W1TzdqP2Lryt+CYM0g2AyGmjhRBzEl10/qPJEaR+OBMt8cmEWqcWb0MHt9hntU2pblX3+4Y4cIYI706AoFew4LgJcDP4gwFSQgsCo7zBP1ST/eTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765834; c=relaxed/simple;
	bh=ux/HIXqj0NplXvZ9k9nZSC0CAam7ZyZZPIBTjVxrtVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIHcy4+ZQ90aMilNwdY41vLedO7tMg36wgZVotcw6aRMOLnTs9HQUAFE/h1O1JPgvVu9sHbFqNMOmmvnkP6Eq1QmMic4zJ2KngkhZgzg6wxhlW7jtZEOgvLsFMf8uk8kSpCJGyEMtXkwNKprEPMu33Ac1ZcN+F9eHDG3oWr11EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hNPYC0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hNPYC0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99375C4CED1;
	Wed,  5 Feb 2025 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765834;
	bh=ux/HIXqj0NplXvZ9k9nZSC0CAam7ZyZZPIBTjVxrtVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hNPYC0hr4Sxa6yoyq41VRfSO9tvcN6CYSSNjhk8lrAm91Lm93f6mhDELQ1z89bUD
	 VK1F8toDbrA69RVzzuwHQzGSBIxKJeJ7ZjOjUOyfAH2O1ZlzgkBqdbdgRdLo28CnCc
	 W1x0jv78vGZ5l9Yk85fh4wt/ZHHLLcFfyXKivggM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 218/623] selftests: timers: clocksource-switch: Adapt progress to kselftest framework
Date: Wed,  5 Feb 2025 14:39:20 +0100
Message-ID: <20250205134504.565671088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 8694e6a7f7dba23d3abd9f5a96f64d161704c7b1 ]

When adapting the test to the kselftest framework, a few printf() calls
indicating test progress were not updated.

Fix this by replacing these printf() calls by ksft_print_msg() calls.

Link: https://lore.kernel.org/r/7dd4b9ab6e43268846e250878ebf25ae6d3d01ce.1733994134.git.geert+renesas@glider.be
Fixes: ce7d101750ff ("selftests: timers: clocksource-switch: adapt to kselftest framework")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/clocksource-switch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/timers/clocksource-switch.c b/tools/testing/selftests/timers/clocksource-switch.c
index c5264594064c8..83faa4e354e38 100644
--- a/tools/testing/selftests/timers/clocksource-switch.c
+++ b/tools/testing/selftests/timers/clocksource-switch.c
@@ -156,8 +156,8 @@ int main(int argc, char **argv)
 	/* Check everything is sane before we start switching asynchronously */
 	if (do_sanity_check) {
 		for (i = 0; i < count; i++) {
-			printf("Validating clocksource %s\n",
-				clocksource_list[i]);
+			ksft_print_msg("Validating clocksource %s\n",
+					clocksource_list[i]);
 			if (change_clocksource(clocksource_list[i])) {
 				status = -1;
 				goto out;
@@ -169,7 +169,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	printf("Running Asynchronous Switching Tests...\n");
+	ksft_print_msg("Running Asynchronous Switching Tests...\n");
 	pid = fork();
 	if (!pid)
 		return run_tests(runtime);
-- 
2.39.5



