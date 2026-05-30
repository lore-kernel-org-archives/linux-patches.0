Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F603C4174;
	Sat, 30 May 2026 18:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165733; cv=none; b=iWP2bxkPRqtbvUCH3yc9k/RzBblmmMoMvq7gedOhzV+EKKlMtOlpU827GjeYfMIfFChctMkjIbwlKyZeMdcvuC2MfkFYgys+2+393HVVDsApLVSMjLgjE1f7dMKoINxirb/6BBuW9eW9IicSlBMnABuTivKADkMQvaY1DgOaQnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165733; c=relaxed/simple;
	bh=mrurF4Yzb7qVJmEYxg2B5dTR9uGGB3yGRvIiKjD78BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4ZWkvFKpzwSCFRKBDaL6vV2mgxbqHcUpfATBsFdU9z9PVHO3EVxdsyZ2yiVIbrigEL4kHcelQpd6kZwt5ekwfNvpUwFpX4U3EJnUx93f4CLYQJjjXF3ikqhVMxhR18lg3twGJn7oawh6m7WDKIT1CqfS6XGbZ3GTv8H5MlGCV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnsIPle3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnsIPle3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51F91F00893;
	Sat, 30 May 2026 18:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165731;
	bh=LqKKpavjjbyzEVZT49FBcmAOO3B/HEyx0oyp6jiFkGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnsIPle3zu/DGz5mAr+T985r+9XPbAshjEBUPYd95MTwcbDNSCPZ887H9T01Sc4ZY
	 Qu1HHnojdZkpt4sUkZmEbNCv3kdw2Jd7jZbdXxcar0tWKNNBVP1UgghE15pPrIWMgL
	 Swgv51JHU37Mt+H1xEyd7ivPhyMlPV5ORz/ddz28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 164/589] selftests/mqueue: Fix incorrectly named file
Date: Sat, 30 May 2026 18:00:45 +0200
Message-ID: <20260530160229.097820162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


