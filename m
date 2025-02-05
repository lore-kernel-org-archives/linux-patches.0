Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247FF157465;
	Wed,  5 Feb 2025 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765340; cv=none; b=eXB8FREN0FKlERc80Gd5kafXHkNWprs/CnXoGmUvBXU+2o47a93U0ef37LBO6orTYeUxYJKLkbUZpHzUoUb9rGHkAvkMxslTJSk0QXIivisTKW87mu0Cbc7ijX+b6jJrzjw9F2IrLziYVNgpHxeu3KmF4z/5ZyeUY3diGg07wNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765340; c=relaxed/simple;
	bh=aZ/hbv3PAzUe9NeBFFiQ60UhdgTGOyMYgODwpA03v10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntRZfHpytsO8ybSgNt174GJTAehnByXO4aHihUHQKzW5OnCfTLsgCI2nzdsrkqIWP+uN0fSbxAzxP/kyU7VkofQi1t7m/HEjwW7BSt/B6lGtARISL3w08CNtDtMNQMkpIJAv+BMvqvu3pir40eONozTxxVvHgMQFXhF84K5WfDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sA4Jt47k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sA4Jt47k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA72C4CED1;
	Wed,  5 Feb 2025 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765339;
	bh=aZ/hbv3PAzUe9NeBFFiQ60UhdgTGOyMYgODwpA03v10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sA4Jt47k4ikgcfgFcseYxvgV0BaDeDO3ERDjUDXv1g2CEGTObNG1w6mtkjtfssjhD
	 VUpi+1SteHJSevbjzjSg2wOslsYfF73dKo9b3mAd2GU/XZawky/UbuBzaooETyh4q4
	 js7+eDIz2L7BwcVORQfyT4vYReXYwolMQhYcR+gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/590] selftests: timers: clocksource-switch: Adapt progress to kselftest framework
Date: Wed,  5 Feb 2025 14:39:26 +0100
Message-ID: <20250205134503.359201374@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



