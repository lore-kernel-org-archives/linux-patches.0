Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774524;
	b=LvQdocCTQGRZsGhg4HrAk+BwJ6NrPjdsDTUUyG27QYSdLUbBQQjehd1lrmInxcvrkq1c
	 TdFhGHBxbaWRG5CF/dL/lwkCoN/utMARLaQRZHl38ANyqtaUHE/4i5cSwZpVC92tL8cN0
	 NeXOs9422zT4YGczkv7aPJKbFll0vCPwdojfUjs6yZjWmA1TDLr4gk+E95vhxGjySnSWg
	 pUGbuJcJcOUNUGSuJdgoSdRu5WagP/eAwFcHe18nXuEhXcLZSwgVdTfCTtFbeW5srKEKj
	 GA0ChdkICqAajGXfVsRmfUtY04GLsYFW0X3RIJn6OJHliThxy4Beh+PlPZKqrfHwl6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zr7R7bHws/nsta9kgDGBLBl3xfFPDa2kEJqFoeeJG9A=;
	b=NpmEyQ2ULqwRmOJyKnUxiSai5gPYpxfBqjaPmWFqSDzzFHCG0zd/+4r0MjkuD7MY9hur
	 XPEJNifIkFQ49jnyFZOZCLudwteSqemVSr61MuT14c9kgt44Lsgx5jc1nLUv6P7UHHnJX
	 Qngptj1paxQ18Mzk1H9c/r4v1KEvpfX5nCazJfiaSdlrnvE6XVQPSjC4IOmrx7MBMn7Ot
	 ZgZpL2StiLvqQSyDRt5sEi9pwP+F/W1Ooq1kBPDX/SagRXJtqBIiQI5LcqfQ/UXkieWV+
	 IKIaVXBIOgEbehdwspO/LW5h+t25bRYe6DJlJWImmbR6ZSD5hVCiLPgAOlq+sGgp3Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+FJ6qt3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7352606A31A;
	Fri, 23 Oct 2026 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+FJ6qt3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134231F01825;
	Fri, 23 Oct 2026 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774523;
	bh=Zr7R7bHws/nsta9kgDGBLBl3xfFPDa2kEJqFoeeJG9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+FJ6qt3/2eejRhLEL0foawdXAqyxuvkmV0/tftJcKy9Or5T7D4QidM9ngEjeBUjF
	 lzc7+RWqLBWGa8ofB+Ktf7AYcGPBVkaz+GMiwu+6PdCbV/YvuLxiwmZVU7INZnW6IU
	 kih/vNHtOCOodmtLtphmrBmWOI2ZFDwBcjkeUECo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 069/242] tracing: Fix simple_ring_buffer undef check on parisc
Date: Fri, 23 Oct 2026 18:38:31 +0200
Message-ID: <20261023163715.414035832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit ba875c4483359ad4c056e00d3da089c7db56bea6 ]

simple_ring_buffer uses local_set() and cmpxchg() on unsigned long. Add
them to undefsyms_base.c to extend the allowlist for the parisc
architecture.

Link: https://patch.msgid.link/20260923074213.3077182-3-vdonnefort@google.com
Fixes: 1211907ac0b5 ("tracing: Generate undef symbols allowlist for simple_ring_buffer")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/5574c9e6-9ed2-4ee6-a2b2-fb6ee81e83a1@roeck-us.net/
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/undefsyms_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/undefsyms_base.c b/kernel/trace/undefsyms_base.c
index e65baf58e6ffc..37310baf706b0 100644
--- a/kernel/trace/undefsyms_base.c
+++ b/kernel/trace/undefsyms_base.c
@@ -9,6 +9,7 @@
 
 #include <linux/atomic.h>
 #include <linux/string.h>
+#include <asm/local.h>
 #include <asm/page.h>
 
 void undefsyms_base(void *p, int n);
@@ -18,11 +19,13 @@ static char page[PAGE_SIZE] __aligned(PAGE_SIZE);
 void undefsyms_base(void *p, int n)
 {
 	char buffer[256] = { 0 };
-
 	u32 u = 0;
+
 	memset((char * volatile)page, 8, PAGE_SIZE);
 	memset((char * volatile)buffer, 8, sizeof(buffer));
 	memcpy((void * volatile)p, buffer, sizeof(buffer));
 	cmpxchg((u32 * volatile)&u, 0, 8);
+	cmpxchg((unsigned long *)p, 0, 8);
+	local_set((local_t *)p, 8);
 	WARN_ON(n == 0xdeadbeef);
 }
-- 
2.53.0



