Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B7F340260;
	Fri, 15 May 2026 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860720; cv=none; b=hNwQ0P/lB5bG+igzpp5XRBG0+QL1gMkeXdLbQHgsJkvDY0rHb8fpYCXXzDeUOzx3OjWNZURHbBRbGQGU1fDS/a2M72ZojuKUj04LOuZy+0I5GK14z3EgpKe7Jyg/Dec/XpMmiWhoTUhyKuarOm0Yw8y9gtPxUF3rO/PAJ7E0134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860720; c=relaxed/simple;
	bh=SOYLLujfZpIgdRjQ0FQLGWXM1r8W1F6XazB6Sr/NyCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiRi3Asq6W/CfUUh+7elBn02jNx+Z0lEDInz3GCY/QuxSCHsCbTdeboVz0JTXnAtxvsLmcdQKiVp4NIF2Q0GoFCxrkMvRgZUOdu38w5/atdLr0+N1IalkIqp/ejlUwX/qwKFGf4knUxYOgb+9A6X0XHdeWIBlz9Mi9bsZTxvnT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3NIEEYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3NIEEYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5F2C2BCB3;
	Fri, 15 May 2026 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860720;
	bh=SOYLLujfZpIgdRjQ0FQLGWXM1r8W1F6XazB6Sr/NyCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3NIEEYVP/Lh7hrvktuirn1J9G/uxuM+Ol1gMI50otPKSrbS5/Q4wgOhdOVL3VIqP
	 WKk/rPYEXvN74ytgq5d+DYupQMmaosok0YmH8vn8CxeytPiv/yPjn9E61zuhX/wp6A
	 j5zoVciTEY17QBirWHo6b0m1Fan5YpQyNTXVA/TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 052/474] selftests/mqueue: Fix incorrectly named file
Date: Fri, 15 May 2026 17:42:41 +0200
Message-ID: <20260515154716.172318242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


