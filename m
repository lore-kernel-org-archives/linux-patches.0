Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8894315F;
	Thu, 25 Jul 2024 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919090; cv=none; b=ZMu1QW8SJdAn/RWvIBQPRsu4S1n8+uG0WGMfOJAe3U5IDlmiFZWFBzDA8p/jHvIncEdiyBmMnaf4QojTPc1ZB/MWcLC5bWo72pXp18bjgwf01MpSvFRaadI20QxjAr10SIkfr7fvpxvE5Rs274kBXYkjoBmp8WbTZp9wZOIggu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919090; c=relaxed/simple;
	bh=uVmCNtXPwlEJB+KTQhtfVoYUugsSByFjIZw19Dzb2F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YvQSBH+lhtf9m471/8tBxp+7IlgdJdrm0vz/RlHWzoYlN+NeHMqBg+dLGhPtiOSdJ16b6EajBUMitc5wLh1rD1n/ptUlSlm2PJSHwg6oWK8BxTS/hzhdKcyYQKD8llMpQb2rVnFep5lQE//1pOs7de5XfG98RqjO+k5dPFt0mQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k58eg/rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k58eg/rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F1C116B1;
	Thu, 25 Jul 2024 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919090;
	bh=uVmCNtXPwlEJB+KTQhtfVoYUugsSByFjIZw19Dzb2F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k58eg/rl1tk3Mh8NKAFXY+AsrTsBzZ+GfTIDpWR/C9x6TCUolfk8vi7RXa0MDoMg5
	 DQfUfihpQ+Z3+kceQDCz0GJxTdnDKpfHjXbndhlCr4bhqfEYp5CJpoqSqPFCoRq0W6
	 QhuXAAvdDxaQQQfjTjlA616aq/B3kKHXmru6Kp74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/87] selftests/openat2: Fix build warnings on ppc64
Date: Thu, 25 Jul 2024 16:36:53 +0200
Message-ID: <20240725142739.195476642@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 84b6df4c49a1cc2854a16937acd5fd3e6315d083 ]

Fix warnings like:

  openat2_test.c: In function ‘test_openat2_flags’:
  openat2_test.c:303:73: warning: format ‘%llX’ expects argument of type
  ‘long long unsigned int’, but argument 5 has type ‘__u64’ {aka ‘long
  unsigned int’} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/openat2_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 7fb902099de45..f9d2b0ec77564 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -5,6 +5,7 @@
  */
 
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <fcntl.h>
 #include <sched.h>
 #include <sys/stat.h>
-- 
2.43.0



