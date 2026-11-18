Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021436;
	b=0tVUb1hmTDA2xspy5gBHkn2/1bOW6Ft/gjjaBF+NYM4dQ5IRyirF3h+5NLCzqDvqCRVv
	 m6LzTOKAQd6oo9wJ5cbeCi1c8hdmQg20KpzpF/sXctmDTtnPG1c8K3l2iWPkhhOFJe5t1
	 +0/FjYOi4K6+LdxxCyzau1esEorvCV3Ym08CFkemdF5hxZwLJclg3P2CHSqzi0fcm3FDa
	 h+D0stmHh9VoSnq/R0HFjLwsjEMFDaR3b+f2xNNXxtw1u0c9CybhoRRtmKq0b884xbET6
	 OQZfrxmt+JUEs9E1WHT7cRTUXKg3esUFfz+LenamZUF4zEiDxgpTvT6BkGrOcn6WF7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1VXFjEx+NgDmaaSZ3vpv3Pa0MOfYVM3CJRkUI2FjucY=;
	b=C2Gv84ijcF3OSqgMS7N1UWoAjLcKQNkYPxG1FHoS1HW9r2VVoyEkrRGmNTvkoPZVItcI
	 bNce2AT3H09AaqKiF81R24q9dsduzlgWHEbTds+xgi7dR1/PJVG4I1DP3/di7tZ1YgIv4
	 6oeMFvMdF1MPFaAdXBfXWT0KdZ4APJWaSg1vxNSaFpQO3GNx8bXWh1+NLBkaEOs/f19eE
	 7XWKUniBmk1w4YKPy1tCvdd+r2lXA0LUxeKoadRy7xXK4O9g9GLHTmW0WHwJC0WuSNHGC
	 pJ/dRAuSd39b3K76980TjnoXRIH59ZwC5of1pYzvx91jLo1JBYcuqEf84WuBHXBp15A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okalov0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99E6606A320;
	Wed, 18 Nov 2026 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okalov0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340C91F000C6;
	Wed, 18 Nov 2026 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021435;
	bh=1VXFjEx+NgDmaaSZ3vpv3Pa0MOfYVM3CJRkUI2FjucY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okalov0PEPp3Z+Se11uGbxOs2K5p90AQcqg94x4EMYXc0oV0JULVYf/sbJNiT4XLx
	 IpmlpexK92yo842C9xXVr9Qws/K5A/0mhUMSPVwC550sP+By8GlUWMNt3MKlcLr4nJ
	 L1B7BZ9D4LSPJ7AxYusU4vVaAbOlq6p7xmZWq8RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 7.3 2305/2651] selftests/proc: proc-pid-vm: fix unused variable warning on non-x86
Date: Wed, 18 Nov 2026 15:59:05 +0100
Message-ID: <20261118150408.246618600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit c4d9005e7e1ee6ce277f47cf53d44fc5b90b287b ]

g_vsyscall is only used by the x86_64 test, so clang builds for other
architectures get:

  proc-pid-vm.c:224:21: warning: unused variable 'g_vsyscall' [-Wunused-variable]

The vsyscall strings next to it had the same problem and were marked
__maybe_unused for it. Move all of the vsyscall variables into the
__x86_64__ block that uses them instead, and drop those annotations
along with the local __maybe_unused fallback that was added for them.

Link: https://lore.kernel.org/20261012115330.3777115-1-sashal@kernel.org
Fixes: 17415606f9d8 ("tools/testing/selftests/proc/proc-pid-vm.c: test with vsyscall in mind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/proc-pid-vm.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-pid-vm.c b/tools/testing/selftests/proc/proc-pid-vm.c
index 4e6a3e53f9757..98e882e568154 100644
--- a/tools/testing/selftests/proc/proc-pid-vm.c
+++ b/tools/testing/selftests/proc/proc-pid-vm.c
@@ -47,10 +47,6 @@
 #include <sys/resource.h>
 #include <linux/fs.h>
 
-#ifndef __maybe_unused
-#define __maybe_unused __attribute__((__unused__))
-#endif
-
 #include "kselftest.h"
 
 static inline long sys_execveat(int dirfd, const char *pathname, char **argv, char **envp, int flags)
@@ -214,7 +210,6 @@ static int make_exe(const uint8_t *payload, size_t len)
 
 	return fd1;
 }
-#endif
 
 /*
  * 0: vsyscall VMA doesn't exist	vsyscall=none
@@ -222,15 +217,14 @@ static int make_exe(const uint8_t *payload, size_t len)
  * 2: vsyscall VMA is r-xp		vsyscall=emulate
  */
 static volatile int g_vsyscall;
-static const char *str_vsyscall __maybe_unused;
+static const char *str_vsyscall;
 
-static const char str_vsyscall_0[] __maybe_unused = "";
-static const char str_vsyscall_1[] __maybe_unused =
+static const char str_vsyscall_0[] = "";
+static const char str_vsyscall_1[] =
 "ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n";
-static const char str_vsyscall_2[] __maybe_unused =
+static const char str_vsyscall_2[] =
 "ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
 
-#ifdef __x86_64__
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
 {
 	_exit(g_vsyscall);
-- 
2.53.0



