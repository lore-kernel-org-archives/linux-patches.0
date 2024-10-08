Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAB01DFDA8;
	Tue,  8 Oct 2024 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393699; cv=none; b=XfiY/FfD5w9zb8uyurGzq7yqwJuWwvxQRJH0CCK6Scto7Xe8DLJJm2vsgOPdXR0dien1UzNy37/iUNvmJsl9Cuo+bkBwbxhv/0uXwlL3jxmGw/NnczlUr8CY3Fn2EGg7gMTN5Do+Ddf0sf3gkntoBhsduEC7vhrrsMKWDazZiDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393699; c=relaxed/simple;
	bh=J48fGW0hS3YHgeJorBjbLFwB9Jv70vCMnKv4n1jd++s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbIJF7qxr/Xlogmjck+biunUIMQgTvSW/Q/drwVL9SIs7z/n07tAQQlypnoV3s3Bg4ell7Iqq6vbaGFlZKO/A2neOLQPXFZbjpzHz5EHNkUxJb69fdReMtOATZFO4ALQWVM4SWwFWHZNgqmPrY+3/0ygW5cT/jEv/q1qoJQEZYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfPVA9Su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfPVA9Su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1856C4CECC;
	Tue,  8 Oct 2024 13:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393698;
	bh=J48fGW0hS3YHgeJorBjbLFwB9Jv70vCMnKv4n1jd++s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfPVA9SuL20B71+83650rIR043OhZRwJ31z9OL0GHtg7qNMhG7SwrbOUgoI/wtGGm
	 cfV6FgBrj3VLwx5cB0G8Zkxi1OXerJ8A6KQtosloByurlzz7JmILnRN+rWmyZ3/Zo1
	 twUANFyHr3/xbTvV5SWsEXQomvQVqrbIh/DgOvSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/386] selftests: vDSO: fix vdso_config for powerpc
Date: Tue,  8 Oct 2024 14:07:23 +0200
Message-ID: <20241008115637.198287992@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7d297c419b08eafa69ce27243ee9bbecab4fcaa4 ]

Running vdso_test_correctness on powerpc64 gives the following warning:

  ~ # ./vdso_test_correctness
  Warning: failed to find clock_gettime64 in vDSO

This is because vdso_test_correctness was built with VDSO_32BIT defined.

__powerpc__ macro is defined on both powerpc32 and powerpc64 so
__powerpc64__ needs to be checked first in vdso_config.h

Fixes: 693f5ca08ca0 ("kselftest: Extend vDSO selftest")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_config.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_config.h b/tools/testing/selftests/vDSO/vdso_config.h
index cdfed403ba13f..f9890584f6fb4 100644
--- a/tools/testing/selftests/vDSO/vdso_config.h
+++ b/tools/testing/selftests/vDSO/vdso_config.h
@@ -18,13 +18,13 @@
 #elif defined(__aarch64__)
 #define VDSO_VERSION		3
 #define VDSO_NAMES		0
-#elif defined(__powerpc__)
+#elif defined(__powerpc64__)
 #define VDSO_VERSION		1
 #define VDSO_NAMES		0
-#define VDSO_32BIT		1
-#elif defined(__powerpc64__)
+#elif defined(__powerpc__)
 #define VDSO_VERSION		1
 #define VDSO_NAMES		0
+#define VDSO_32BIT		1
 #elif defined (__s390__)
 #define VDSO_VERSION		2
 #define VDSO_NAMES		0
-- 
2.43.0



