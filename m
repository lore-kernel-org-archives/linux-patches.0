Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE703998B1;
	Sat, 30 May 2026 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159941; cv=none; b=XTa7eRI9tRg528jb8xWOugxUtXGkUo2/RFi9EhhQ5l6iyjVuDnuMLBOZqhka1oHqBwVXEgAMGCad7DXBHgzLmosqIAlFypIqYj7VUY0WV5TxxoNFwCNn/efYmrfgn9IqG8FTFIaYgvpMm0ZaCo71LRe3LLzvc20KcyeOhs/MnuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159941; c=relaxed/simple;
	bh=qxbEeQhPLQk/MYxe5XA9Y2o9ZCAuuJ7hmv6exQPdxkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eb5AEWJyogkozNyo21RuS6Xh/5r+MHna114ANJfwguCKpUfsagqPuEIH1X1zpJ33aeDv4dmWEC+Vy8h+Vgr02H+abZKS5ahZzdUUFPUAtq8QFidZLnNdshN8xOhyTgRXZpCM65aF6SFficMtozkTI01eq9bMEVpUiAbySSD4NQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsVnxxbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsVnxxbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2B61F00893;
	Sat, 30 May 2026 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159939;
	bh=yeYlKKZkbM/oldPESEF3YYr1dVpovXvELnym8Xxb51s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsVnxxbD2Hchja8eCX0Pd9LHA3h/6zo99RVEwOw6vhBQPwwIdyqvvxwCAH260MGnV
	 7iWJiYFyREKn3fC06ALKx85al41swaj3Gu7y9t2ioZlrY+YC1+nXa/N1asAC7Lx+lL
	 wXSCcWZQS6aPwQTa9jn8FvhoqvonGi604MrImTXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 202/969] selftests/mqueue: Fix incorrectly named file
Date: Sat, 30 May 2026 17:55:26 +0200
Message-ID: <20260530160306.055813975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


