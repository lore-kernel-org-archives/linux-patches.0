Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00133254AF0;
	Thu, 17 Apr 2025 18:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915134; cv=none; b=uJasskNIp5j8EJdqM8qacPwu0b3FgwlgZIBWhKg1HKnDOTTWYLcrodN3c1710lqISiPaxyuXwQOnuO8zLVnxkKOWrRPmiNRNAajRZFYZYt7Hhfo/d4iFM4fojdWuDZFDR0dluZHRfo7qkGBnoeuc4GbbqPxSwGOkUMHhBfrOJG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915134; c=relaxed/simple;
	bh=59SZm7j4Q/nPefdzmO+oIrHwZ/mo8sNSX+4SRqilqjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HO5mSGurRH3X3tk72wR7awF70GkgwL0l8aznZN0U28tn09n+v0PzQ33o6u1cGLZbg0GRqOjC/NtcOMP4qzEdHWBBHv9vuHWAeuvkZXIaOw9AU5KKOXffhIwnvCd/s+BmzrZKzoMrgH1qvxje81CVl4XR6tycW1H9PGHnQg+Gyl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXqrlIot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXqrlIot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C65BC4CEE4;
	Thu, 17 Apr 2025 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915133;
	bh=59SZm7j4Q/nPefdzmO+oIrHwZ/mo8sNSX+4SRqilqjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXqrlIotQpc1z8zM/CLyE3K0lFepBGXebHgs/54xub3xc9/H+W/+oVk3wsqoug/0+
	 s9xHCWMkzbDl/I1+OiGX2Rp5GdQhU4nPb8B0ekLyVzuRf5yEnKb/9T8U6Ht1JGwr3G
	 eJMJzOTxv5udh/v4jXqvTz4k+kL/Ajn+SNnynZAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/393] selftests/futex: futex_waitv wouldblock test should fail
Date: Thu, 17 Apr 2025 19:46:58 +0200
Message-ID: <20250417175107.951100863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



