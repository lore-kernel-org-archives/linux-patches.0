Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FD31DF265;
	Tue,  8 Oct 2024 12:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392150; cv=none; b=SFcNbbBHT0ehE9zUoTlfz2xN4w2/t+xqXgOIqGu4QR2Ov1WTRQJa+TKIIqqF4tDlm9Vf6tyNB337JFUknjb540FOGQ8upwbWnndD1zBBnEuOUqfH+eUYj7KftEIVqp7QzZcgPijECp2u9pZjZ9JnmaqiNBH5lB++huFvB2YUfXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392150; c=relaxed/simple;
	bh=bfIQuPq8i/K0D5LWCXbb8vZXVbv0W3nqz7CobZ4PVzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxpW+vQrsLGKQ8FDejFyC4D9T2bNbEk8gCcd01tL47YNvYZhZk5Ei845sPiAwNAOyeFWrl/s6ds2FXMDdNcjjAY22y/6WyKdQM7++Bxio8SZNdUhMet2BJ6fZY8S+LMYyoB4gj52zbhUWA0EjxDoh6ELnBs+69aozXUUVqpgEt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zc6Q9lcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zc6Q9lcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE1CC4CEC7;
	Tue,  8 Oct 2024 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392149;
	bh=bfIQuPq8i/K0D5LWCXbb8vZXVbv0W3nqz7CobZ4PVzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zc6Q9lcsGfv6SKzkt7gJlsZFFHfJAK2UNwk5FqJxSegndfCoG+5WhqU0OAZsz2fDv
	 55NHEY6BqFVTpSxmEaQlsGR5tzNYg95MJ7oSE1UzaqE63OjJLyW1092FKK9o77/NLS
	 3ksz3nm32j3PzOEdnosaYOFSdCUq5d14UuXgHcXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 330/558] selftests: vDSO: fix vdso_config for powerpc
Date: Tue,  8 Oct 2024 14:06:00 +0200
Message-ID: <20241008115715.291448008@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



