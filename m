Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EA21FCC42;
	Wed,  6 Nov 2024 12:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897764; cv=none; b=qln0bTk6R7esXY0rBpb45+J7ndCjh0hwr37DjVvMBRgq7IUjWk64r4AioXnfASy0yyGEuVBXm08ZzyfFXcLerG69fKe8SWO+T9mx+9ZVeAd4aMfN+58XHNYfnCmB6sxQjDNynnZ9PmUE5vuFT80lZHEbHoe7uMzpuIG4U/blbVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897764; c=relaxed/simple;
	bh=Oo375zwQwuVrRkWeleMJWx6BLI6rC9roBysg3ULAHDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUTWbT+51eR3/+IBE6e7Ax7NTA4e4CGZqPwuHGP0avtuv6bWiDNHwp1xBKPVJmaqKOuJHlX7P9TEmFT84ZK6YGD4lJJwpaPsOEkDkgPfORbuqk5972CmyI/26zyFjMkvWZEl3hEJ2SIluTGDQPuCODDPuT2rE08FFLRdhXQl5i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJnAxqPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJnAxqPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5C9C4CECD;
	Wed,  6 Nov 2024 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897764;
	bh=Oo375zwQwuVrRkWeleMJWx6BLI6rC9roBysg3ULAHDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJnAxqPQuQ7oI9KKsrv9I3OBw0HYi5s29FqVUTsKgin1bYDbUVq4SxdHcGXQTdHQy
	 mBOvCkCTwE8bv7nNVdk7XS8SM9P2b/5QGA9JEQsOx6mXtDUa0VcNJJCt3Y0tgVQ1cf
	 o28Ly4b7MoJ84x7m+3P91/M8gClqOVId/QFoTQT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Takahashi <takahashi.jun_s@aa.socionext.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Subject: [PATCH 5.4 012/462] selftests: breakpoints: Fix a typo of function name
Date: Wed,  6 Nov 2024 12:58:25 +0100
Message-ID: <20241106120331.810097022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 5b06eeae52c02dd0d9bc8488275a1207d410870b upstream.

Since commit 5821ba969511 ("selftests: Add test plan API to kselftest.h
and adjust callers") accidentally introduced 'a' typo in the front of
run_test() function, breakpoint_test_arm64.c became not able to be
compiled.

Remove the 'a' from arun_test().

Fixes: 5821ba969511 ("selftests: Add test plan API to kselftest.h and adjust callers")
Reported-by: Jun Takahashi <takahashi.jun_s@aa.socionext.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/breakpoints/breakpoint_test_arm64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/breakpoints/breakpoint_test_arm64.c
+++ b/tools/testing/selftests/breakpoints/breakpoint_test_arm64.c
@@ -109,7 +109,7 @@ static bool set_watchpoint(pid_t pid, in
 	return false;
 }
 
-static bool arun_test(int wr_size, int wp_size, int wr, int wp)
+static bool run_test(int wr_size, int wp_size, int wr, int wp)
 {
 	int status;
 	siginfo_t siginfo;


