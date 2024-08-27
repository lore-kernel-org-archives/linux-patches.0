Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B942C1E520;
	Tue, 27 Aug 2024 15:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771171; cv=none; b=e+swb1HuBwe3QanmmISktyU0uiC8it8ubrm7hlenoJhtsHiGmihEjsDJRQR0E2tjFhGklUCEC77z5SixAyjJ+gT7i3q2byP79flJ9esbYZufPI7cjjaTZ1NiHRTwqXtjc7yMzNThYXoRjSzW4tTlMMDq2c0fp6b542uBuV1ZLyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771171; c=relaxed/simple;
	bh=dAqaHTmrvT0RjmBKjwHzmmOx6iBzkhoYAg3iJz/G+x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G5J03fLkOenSJJtca+HGkWYuriEY/FRAdc9iN/9oZaf1SAQel7c6Uwv1tnUgI7pDqqhzSP/e3a4fdwHBLBcSs1/jpaqUqfDSelePp5eu0BjFa7p5xzHjngdk14eKd+w/XqeKQZ9Q72hjQOFt0D6AkpOPgoHSEDtp5fncdJ0zgcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jw24SC67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jw24SC67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321AFC4AF0F;
	Tue, 27 Aug 2024 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771171;
	bh=dAqaHTmrvT0RjmBKjwHzmmOx6iBzkhoYAg3iJz/G+x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jw24SC67dSw/5N+AwjgPwTyBKfmdxdCfCFT+cxcyPNn6MrO7I0rChlOzJTKwN+jfi
	 161Zmzafl99IiJtkdGs0n5Aawke6V3P+MaOw909kuCuyuELlF3rs7CreDh6L9Tfjeo
	 Rq2XcfKonpee/MXsXBH/94f1/Whex64L3GAIPIWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Jain <jain.abhinav177@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 109/273] selftest: af_unix: Fix kselftest compilation warnings
Date: Tue, 27 Aug 2024 16:37:13 +0200
Message-ID: <20240827143837.557560250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Jain <jain.abhinav177@gmail.com>

[ Upstream commit 6c569b77f0300f8a9960277c7094fa0f128eb811 ]

Change expected_buf from (const void *) to (const char *)
in function __recvpair().
This change fixes the below warnings during test compilation:

```
In file included from msg_oob.c:14:
msg_oob.c: In function ‘__recvpair’:

../../kselftest_harness.h:106:40: warning: format ‘%s’ expects argument
of type ‘char *’,but argument 6 has type ‘const void *’ [-Wformat=]

../../kselftest_harness.h:101:17: note: in expansion of macro ‘__TH_LOG’
msg_oob.c:235:17: note: in expansion of macro ‘TH_LOG’

../../kselftest_harness.h:106:40: warning: format ‘%s’ expects argument
of type ‘char *’,but argument 6 has type ‘const void *’ [-Wformat=]

../../kselftest_harness.h:101:17: note: in expansion of macro ‘__TH_LOG’
msg_oob.c:259:25: note: in expansion of macro ‘TH_LOG’
```

Fixes: d098d77232c3 ("selftest: af_unix: Add msg_oob.c.")
Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240814080743.1156166-1-jain.abhinav177@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/af_unix/msg_oob.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/af_unix/msg_oob.c b/tools/testing/selftests/net/af_unix/msg_oob.c
index 16d0c172eaebe..535eb2c3d7d1c 100644
--- a/tools/testing/selftests/net/af_unix/msg_oob.c
+++ b/tools/testing/selftests/net/af_unix/msg_oob.c
@@ -209,7 +209,7 @@ static void __sendpair(struct __test_metadata *_metadata,
 
 static void __recvpair(struct __test_metadata *_metadata,
 		       FIXTURE_DATA(msg_oob) *self,
-		       const void *expected_buf, int expected_len,
+		       const char *expected_buf, int expected_len,
 		       int buf_len, int flags)
 {
 	int i, ret[2], recv_errno[2], expected_errno = 0;
-- 
2.43.0



