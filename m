Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD95227D788;
	Wed, 23 Apr 2025 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419543; cv=none; b=FQ2m7tj6+bucrKznQl3EG0jve6AcYACq9Dqh10tbcSCSJ1zGtQ8fGOGnqcLnmGB9nDK9H+TJOD6UIKtjvYw/17e0TkGt6J4Z+KU3aVYx2czNprR79VEmo3mwl1iq8Rjue8tvra3A0M1cLh1ADBNDtC4iaxEJmAX+4/eIocbGRSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419543; c=relaxed/simple;
	bh=HRQrBnwmLhBMoR6P1TrQVonhsdqP5KdHNBMKyHAMqVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=szTumnXqHa6I4NkEsnKuVmQWJrlEN4xYbW2r2JjgGUm260xLEis+AVV7pL0bEyc3G+Kmw9Wn3yX0G+F99PfeQGNxf/Kv8i12LgzdgqG4H+wmVQEkMK3ZTBmovwQ6k2qxDtry9XVEQcyUDQSDWdZKs9XlqLHMleJ9m76FABM7CBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaXiQlPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaXiQlPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C2CC4CEE8;
	Wed, 23 Apr 2025 14:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419542;
	bh=HRQrBnwmLhBMoR6P1TrQVonhsdqP5KdHNBMKyHAMqVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaXiQlPiAIpzZDys/wI3GgpXwRAmgSUyaWxTBDRPPGaCeXuEiCMVZQ3k69hzMQ1jd
	 kCYAGyIve+SuNZG4+ys7SeFAlTPanqYb/Och72YKmeGVzgDoMrlaReoiaIbyDirGdn
	 8oewDs0zqGVV3OnyArQaArt2hmLMmKpEdyjbngjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/393] selftests/futex: futex_waitv wouldblock test should fail
Date: Wed, 23 Apr 2025 16:38:17 +0200
Message-ID: <20250423142643.310771942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



