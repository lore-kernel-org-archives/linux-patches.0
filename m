Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E93B33981;
	Tue,  8 Oct 2024 12:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390384; cv=none; b=bhDR2j8RZitUvuUwI97FZDrTtNOdrLfiOQ2p430K+QjAsYOlcU+OB48h6rCTPQUdK7EGfl9119GsiiE2WubeNQkRhXHlMRaG1BkBJqqmWshpkpeOlVrDjEcHbtc8aXi/3Cd1vChp58QzMtgu6VphpvalZhpObBvrJCLJ9ol3AaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390384; c=relaxed/simple;
	bh=l1ZSDmmVQ2HZ6l3n6qQdk+/Bf/unMJlw9ag0N/08oOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNFCI5WsWaKY8YS3KyEqV3cD64LNiYDcl8WtbzzRUSQStqv7XA0GZvDnRB93NnrdT8T5TLjjfqsqmLX30BRrgrU0l8+eQYfAXDZvjk5oj7Fup8b5t0WPAURQ1FdZS/Xrez70Ilgikd52ipMnIoWk0Cd2Wjtr2LaSYn0Ab3Z16xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFb08u7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFb08u7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F74C4CEC7;
	Tue,  8 Oct 2024 12:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390384;
	bh=l1ZSDmmVQ2HZ6l3n6qQdk+/Bf/unMJlw9ag0N/08oOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFb08u7q+TxLJ/aeJC+uMeAfxQ+S319TbK/5LdOZJcPQJ7SteNRg40Yl+YkwmPvTn
	 vBg1hGNrxsDVhHt33qnlraVWAgCsRtHuA2NVxO9b2XjT70hVrgJYPpokx9LyXubzE4
	 ST47SeHwa6a8+CKxqquz1tc206hLLoT7JyPZaCrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 274/482] selftests: vDSO: fix vdso_config for powerpc
Date: Tue,  8 Oct 2024 14:05:37 +0200
Message-ID: <20241008115659.062996593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7b543e7f04d7b..00bfed6e4922e 100644
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



