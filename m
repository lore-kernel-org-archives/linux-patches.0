Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C4D261B9E;
	Sat, 30 May 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163289; cv=none; b=kG0KbwWT50BarfroE1SZ2WhwZN/6vpH8fWKP8kML/NpU4djkJ0FeTeFnw+uZtXYyXaYNFVxIG7XXqHeD0e2EtNJ4i/ni4hBpKpWkFaCPvXoOlvXX6mlnS6FeA/cU/AXhLMxCsQn9P9q1s4ptjC6Ze7DopPZ9I5gr1znRGjlAWn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163289; c=relaxed/simple;
	bh=rns9XMbjh2xFyiHKZQOpgtL9rhjYws9cT5ThMJgtfpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeFS0357oQ578TqgO58Kh+0VTj7JbzUnAKeiFdFtPYRG4oY1uqvnv1RVg1oxT+T5kfvmWwn0tl0rxdbEWxtgdzNswFeX4TyMo8DS2n+S5YEc5KYbIghP/UwhgpObLq5G5P09MmlCUgZz5+X8CjtiTBTVbNctVebEilhLGW/hia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeRuLk2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeRuLk2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275641F00893;
	Sat, 30 May 2026 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163288;
	bh=utJmgki0r0MyccyO/2aSyMtPL+KVrwBEo/GBIbwnWs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeRuLk2gr6pMhAFBowDsb8QaDaojD7PBMz2HKhLlkUVzytp7eO1t75ZyLlRKHFln5
	 A52x7ma95O/kUWQnRJQHCglC6/chESYNxNq0n20JLdcJk2MBLoTlyA+hSiqaf0DcXO
	 24dYn764+zhzZyymlO7rO2NJmqeQUmDSYlwF299c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 214/776] selftests/mqueue: Fix incorrectly named file
Date: Sat, 30 May 2026 17:58:48 +0200
Message-ID: <20260530160246.048327995@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Liebold <simonlie@amazon.de>

commit 64fac99037689020ad97e472ae898e96ea3616dc upstream.

Commit 85506aca2eb4 ("selftests/mqueue: Set timeout to 180 seconds")
intended to increase the timeout for mq_perf_tests from the default
kselftest limit of 45 seconds to 180 seconds.

Unfortunately, the file storing this information was incorrectly named
`setting` instead of `settings`, causing the kselftest runner not to
pick up the limit and keep using the default 45 seconds limit.

Fix this by renaming it to `settings` to ensure that the kselftest
runner uses the increased timeout of 180 seconds for this test.

Fixes: 85506aca2eb4 ("selftests/mqueue: Set timeout to 180 seconds")
Cc: <stable@vger.kernel.org> # 5.10.y
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Link: https://lore.kernel.org/r/20260312140200.2224850-1-simonlie@amazon.de
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mqueue/{setting => settings} | 0
 tools/testing/selftests/mqueue/setting  |    1 -
 tools/testing/selftests/mqueue/settings |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/mqueue/{setting => settings} (100%)

--- a/tools/testing/selftests/mqueue/setting
+++ /dev/null
@@ -1 +0,0 @@
-timeout=180
--- /dev/null
+++ b/tools/testing/selftests/mqueue/settings
@@ -0,0 +1 @@
+timeout=180


