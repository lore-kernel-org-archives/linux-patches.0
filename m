Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77217258CF9;
	Thu, 17 Apr 2025 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912521; cv=none; b=mQ0nKYPFC2vNVvDi3rjeqQ58ntgzJ6O1iVbooDDIefW3YWEqxbSzK4rkorzdqV0brXM41BIn39mewMP7DikOz33XQl8OZirSXLHiBVSwPDCuSeXfgdrhZ8r2lYYHSLjRElv37+1wUd9KSKrtyzd5HC19yg0We+ga7nZOpgjPLQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912521; c=relaxed/simple;
	bh=3RtikbNb+KA8wo0hUD8XqstA09XDyWyTnOvFJnc2dbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKw1C8Ig6uVaoVNjHpSMIYJ0LrhYzciKmjocRslpZItaXkzNX/tvMKko1i25AV/+584IEd/+znxgZ+tQM2ZWH8qcuMr5blJ/4pYVAeGy2SYUp1qA2qEz2rw1d1rIVKc9pGTW5bUeTxu3N6n8eTXP0aWmWj90UqA4lchABde/6fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHobfY0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHobfY0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0032AC4CEF2;
	Thu, 17 Apr 2025 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912521;
	bh=3RtikbNb+KA8wo0hUD8XqstA09XDyWyTnOvFJnc2dbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHobfY0Vz/0jgkZoODgVrPd0IaReZYXH9UfJpYqkg1dNO9LUR2G9yUaacLNbuz49O
	 QmxqiOQ4XE1xQf8/6PPqmsVH87YdG3IuM0WPgYuzk8MlrXYGXsmU1cTME7qi8z8jxC
	 dOfholb9V9kW+jB2/WoWGUkcCNurbQcnPtXCFFjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 007/449] selftests/futex: futex_waitv wouldblock test should fail
Date: Thu, 17 Apr 2025 19:44:55 +0200
Message-ID: <20250417175118.280299005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Liaw <edliaw@google.com>

[ Upstream commit 7d50e00fef2832e98d7e06bbfc85c1d66ee110ca ]

Testcase should fail if -EWOULDBLOCK is not returned when expected value
differs from actual value from the waiter.

Link: https://lore.kernel.org/r/20250404221225.1596324-1-edliaw@google.com
Fixes: 9d57f7c79748920636f8293d2f01192d702fe390 ("selftests: futex: Test sys_futex_waitv() wouldblock")
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/futex/functional/futex_wait_wouldblock.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/functional/futex_wait_wouldblock.c b/tools/testing/selftests/futex/functional/futex_wait_wouldblock.c
index 7d7a6a06cdb75..2d8230da90642 100644
--- a/tools/testing/selftests/futex/functional/futex_wait_wouldblock.c
+++ b/tools/testing/selftests/futex/functional/futex_wait_wouldblock.c
@@ -98,7 +98,7 @@ int main(int argc, char *argv[])
 	info("Calling futex_waitv on f1: %u @ %p with val=%u\n", f1, &f1, f1+1);
 	res = futex_waitv(&waitv, 1, 0, &to, CLOCK_MONOTONIC);
 	if (!res || errno != EWOULDBLOCK) {
-		ksft_test_result_pass("futex_waitv returned: %d %s\n",
+		ksft_test_result_fail("futex_waitv returned: %d %s\n",
 				      res ? errno : res,
 				      res ? strerror(errno) : "");
 		ret = RET_FAIL;
-- 
2.39.5



