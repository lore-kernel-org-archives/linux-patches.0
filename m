Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BAC3D9DBB;
	Mon,  4 May 2026 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904578; cv=none; b=oqFKhRsCNhUAph+qRvrahfzeNEP5ph2dhQFoehydNUuZuc1c2qLg4h8bRTlFhvzuG/tubccKQgNY1yqMxK0cxsyPKWvyhrGnjgLmm1zKQr9osGkgFrPjEjEqZTalbVLi0uk8HYo3EezDc7AHyxxaANE4yd0ScW1PCGEU/3CCsZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904578; c=relaxed/simple;
	bh=g6bSWw2INX/I/q7j48MSlrh4QoT1RqiMOKI/2rYG/Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4fEo+UBCAyvXk1KBYzd/ek3E0sctKPQSHTrZBH66o/4/OO7ogLK/AUZIl+Y1yCQNI9yKHBbp/+Fy6rynlr4UllILis0Yrvof91QQkRQyuM5FRwEzcakrJGj/CF7IA4PXdVdRoA/Pb6ZIF8SXJfQhI0NWsDdmlqZYgqhh59/x0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdY/wZaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdY/wZaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49149C2BCB8;
	Mon,  4 May 2026 14:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904578;
	bh=g6bSWw2INX/I/q7j48MSlrh4QoT1RqiMOKI/2rYG/Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdY/wZaQDCT7ind4mUTuE3GwETBvYed3ajKSI4VsXoyH8oAx7+WDDT3s4pBs32Tm/
	 x+9LnOteOeEKNzHdleyQxtEaIr5sPf9vqQG3IElrlqgVDmSwHGfvdUQ6EDKfvzsCON
	 EoFaSER76bf0ZOtkXMngdZ5sUZdvy1SRebJuyyvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 066/215] selftests/mqueue: Fix incorrectly named file
Date: Mon,  4 May 2026 15:51:25 +0200
Message-ID: <20260504135132.581916986@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


