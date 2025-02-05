Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9FE5228;
	Wed,  5 Feb 2025 14:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764090; cv=none; b=enyYbXvpR0h3wfYvgyodUuIY3Fs7PShL00KdD5Hiagic+tswPuT24PCkDmsU3s5UKihyAb3uyyeT4NMCgozeIHaBbI0U03u3FN6vd6Y8H9dH/yFGWH5RC4Pq8k7BDv9KIIpbTUTWUEO7UwPrqlyuE8sG4yKkzGN49Nzmfj0GpRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764090; c=relaxed/simple;
	bh=ScP+PjFTU3C9OHfPG6A9QesdeCIXpLg5rbZgUi9OVCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqQhKI+z1sDvwv81zUNP6csCfYkEERsBlzo7r6Og/aU5W05OTTMyYXXWMvcMKJ16f6PyemPEk7xGTcwqTC03+0AIB2JZj4GK2Drf9s/xpfF3AGYlFOEdHs5Xsaamo936y1zuTDVqY0vgn1HKS1I9DpGwMvOobD7f9fO0Ynvme+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRFS+vrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRFS+vrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D5EC4CED1;
	Wed,  5 Feb 2025 14:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764089;
	bh=ScP+PjFTU3C9OHfPG6A9QesdeCIXpLg5rbZgUi9OVCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRFS+vrgiVIZYwWR0/P9pQn1AF5DRW6VPXBoCg9rMjuOrvbLuCAWnc3cBIu+qKD6H
	 wIWVzIl6uzdpaTTBwDp/J7JHD1T64jpbyO5NEVb9f33XJkDozrbfgjNxliV1UaGrdd
	 3yQJPZBKmyTMwFsnMdPKojtWqPUHwvDiWCuriNbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/393] selftests: timers: clocksource-switch: Adapt progress to kselftest framework
Date: Wed,  5 Feb 2025 14:40:51 +0100
Message-ID: <20250205134425.347473544@linuxfoundation.org>
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



