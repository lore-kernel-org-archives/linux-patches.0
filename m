Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5885E1D1F6B;
	Wed,  2 Oct 2024 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879682; cv=none; b=ZtSSeAOfEzUemC+i6FwxprKGoKYtv01xPdiWbEleMlQFtu8Qh0OJvwT0tNvZwEJZ7+LkPlXlS407Rt5rVxTTgQhuZmXslN6HfixSOrIiqmEvdZU/uJZqkab6XE9eQgs8o/mvsXXyZ3zcvWZXC0P8u0X5jHmI3jNnyTSEkLvvgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879682; c=relaxed/simple;
	bh=DV7/iAcgSL+lfyHJTnNfSAqVZ/ex4HEbaCFw8BFWdjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/ycTRmr8P1ZoPhqrHiVYcwoEcyOiaEJQ+XFs5+d/pEkHBNVhKDGaiEfoIciatRuNf84M2hZ+WsT0vxTmXbfKttPA58ZIZSRhlcbz9eaFR2ef+pKE5M9JOYLc9r1/SYprcQhPDHSNVYdTXi+cfUh6PyJI7bHVxlnhrtybcFK17I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVc6cWjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVc6cWjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56D8C4CEC2;
	Wed,  2 Oct 2024 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879682;
	bh=DV7/iAcgSL+lfyHJTnNfSAqVZ/ex4HEbaCFw8BFWdjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVc6cWjYwGq5Bh7G0xSn+qxbR4pRn3qX9YTj+Uu4fpOOp9qiu+10vMqxPIeSxfomb
	 kVluSPaYemmWRLUzVlbXlFuV3NEB9MTNQ8XcQdwQZojmiMaMTIikLMlYmAdiGmSA1B
	 ptu5GMQMHOaHxSprdUa5sYiqSkvtYgmjCX6TDGMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/538] selftests/bpf: Fix missing BUILD_BUG_ON() declaration
Date: Wed,  2 Oct 2024 14:57:14 +0200
Message-ID: <20241002125759.952927533@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 6495eb79ca7d15bd87c38d77307e8f9b6b7bf4ef ]

Explicitly include '<linux/build_bug.h>' to fix errors seen compiling with
gcc targeting mips64el/musl-libc:

  user_ringbuf.c: In function 'test_user_ringbuf_loop':
  user_ringbuf.c:426:9: error: implicit declaration of function 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]
    426 |         BUILD_BUG_ON(total_samples <= c_max_entries);
        |         ^~~~~~~~~~~~
  cc1: all warnings being treated as errors

Fixes: e5a9df51c746 ("selftests/bpf: Add selftests validating the user ringbuf")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/b28575f9221ec54871c46a2e87612bb4bbf46ccd.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/user_ringbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c b/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
index e51721df14fc1..dfff6feac12c3 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
@@ -4,6 +4,7 @@
 #define _GNU_SOURCE
 #include <linux/compiler.h>
 #include <linux/ring_buffer.h>
+#include <linux/build_bug.h>
 #include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.43.0



