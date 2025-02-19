Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BF81DED5A;
	Wed, 19 Feb 2025 09:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956164; cv=none; b=uUbtpB6GaHlpelVi/dX+xb1Ph1z1qQ1FC6lTRg2M6Av+haanb825zlK90NE+AQQr6M+GQeKythCP7ewXMWnIMfSc9/vidl3td/FKBXYDGEQyR+HNnjAOvYJo6nwL8yCF4SL5q7oLJ2t2uSbExEuO6ZEEc6OOX1e1FMHf0p6QSrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956164; c=relaxed/simple;
	bh=H4faPKW4+wzCE5oO2YXrrTRq8lHouETfkewE1PwxjKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJmqK0zk7c5Edpe90FQrpV2Wzut8X2BpZfa3hm4gt0K2tjSN97FqRwbpr3Ypa5mOMnfiBdvqzk/xM0sbsSvAWILihqst7fB7iDBXkx8LoA08kZ0WuEzEcZLaZ1ncewG/czUPrnfSKzauYADFKFjb/04k7aJOtzbYpirDlk2fDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3Q7NrFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3Q7NrFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5461C4CEE6;
	Wed, 19 Feb 2025 09:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956164;
	bh=H4faPKW4+wzCE5oO2YXrrTRq8lHouETfkewE1PwxjKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3Q7NrFNQt2zzTGx5hwZyTo6MLcW3IQrwLFwVlcBRr/95GCQxRtdrHGouz4aHq678
	 KAGfEkijj4JxT1f3Scx3KE0H9n0EAC3RQMuTWb9QRhVDbUZBaQEZZGNyDBoc/Vl+vP
	 FHz8ZMqRPQ7wc81LSd/gJA+OLt3fxqhjmGF5sDZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/578] selftests: timers: clocksource-switch: Adapt progress to kselftest framework
Date: Wed, 19 Feb 2025 09:21:31 +0100
Message-ID: <20250219082656.384656052@linuxfoundation.org>
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



