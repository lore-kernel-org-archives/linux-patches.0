Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558741D1512;
	Tue, 15 Oct 2024 12:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993705; cv=none; b=hkrZ3sT0PQIMdzj0Kq6dgQ/TQj6jDot3iwzTf9bjjHWjvU+RBx7fxd8Q5oOsSDppI7Z0/7mZIozqDb7MQjnwh1zDcfzGdjBcrSlV2MVwGpHtwMHZLONU9x2coN8IYxtWGhXjKZLNobpPC5/aJ15S6pT/u2DK10LCPQEM/kz54AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993705; c=relaxed/simple;
	bh=3ryT81WhXEhmtsHuAOI8Lit8ICIBR77Xh+LOL0a8VTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlvJZUJfw9qRZ7YDYSQevTo9e1lDj2hPlTjpv3C+2D9q8BvD2rY75lehzG9fCZLkT0qsjd1kTHxQcQRU3/sPAGNmHBWMWpjKB8feKbqRoDSDOr3dma/m93+f+RLod+ZwSo88K/wNzQeaZVV2wb62LoyWxN8aK9JzOP2NgKFwSvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqmstP9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqmstP9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665BAC4CEC6;
	Tue, 15 Oct 2024 12:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993704;
	bh=3ryT81WhXEhmtsHuAOI8Lit8ICIBR77Xh+LOL0a8VTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqmstP9HBNcLtBoA8rRzGzjgiql7mfzg/MFkKugw5etGo8DOAZ5BSgO0w3o0Bm3Pv
	 snn+gmGQklm3/wdoMvsTCu0jBRI2JuRXIqs/BMVwpaWnN2BWli/XuAUAYCERbrLLaH
	 9PgALIyJ3V7LMxWXRQo2303ZQ0PvdzcBOOt0Nugs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 483/691] selftests: vDSO: fix vdso_config for powerpc
Date: Tue, 15 Oct 2024 13:27:11 +0200
Message-ID: <20241015112459.509825020@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6188b16827d1d..446eb9737273b 100644
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



