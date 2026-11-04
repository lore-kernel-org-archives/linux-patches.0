Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831280;
	b=AEhMWl7lSgHJKESGv7UJBn3467lrHe9wMN+s6NhIUMhqQg/1kdMXtZ2K33mLb5cvlxVh
	 CpllOxZs7mIMkc5sCkpCBMqlQOw2bOHWMTRltr7xIhep0YkQRBuhcUPhnt1zzkttoj4D8
	 D/3pgiOpSuQU2VN/AybG8HmP2PpwlJOl42ALHrF0c01hMNQjzWIUgpVT/1oyyYT9L9Slw
	 2I6h0du8U5Zx0b+/F3hYh1RoXKkO8drotm6Z+QCnZQxmEFtWVyVNlE+DtS4QoSv9TE0Ig
	 jk0Uv+43lQKonAfNOtt40nrwVqfPUvr9uPw/LG/Rap9lsZ5Gx2dO/FmAgcHqZdud0UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bFITSyvYw8ObphXZoU5GCIRgaM5jOoYi+m8g0Lyb1Rk=;
	b=V8gUTCLSI3kZZOcvxRhBUyZMhxJC9IdOQxMIJf8uUNacOtHUMS5NAYVWsn039aFR1XbE
	 wHhshLcmFULk+qe4q6VrnxBIq7sZVLZjbk3hPi7OmQHVKjq6Ol5pdxrC5TLD99cf0EMRe
	 1l27XJzCf6mZOko7a6uEoJHtH+MmnWRH8fbty71etzyDv4Ab+UB4NB2kJVAJSPETxG9lb
	 iTCSThCE7f0tfuajtihXDy53wuJaW4NhF04MqLk4OF8sE/KUYTm+UZTRHjmHeDCH0hX+o
	 Nh4/46BdSJ6DbCt6bzG//2ZxtbS8+hgzIh8pV4tbfFA5JVIIyMsFLcgiitdaDN4r5Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NCJvmK2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408CA606A335;
	Wed,  4 Nov 2026 22:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NCJvmK2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F771F000C1;
	Wed,  4 Nov 2026 22:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831280;
	bh=bFITSyvYw8ObphXZoU5GCIRgaM5jOoYi+m8g0Lyb1Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCJvmK2A2dcbt45GOgIxIMHF2J9AQT/mjZTeE6issrAuG7Zc09hPUv/MNmq66zXSY
	 vp0Jy2Pt5BX5HSa0tRI+zSawz7zeNai6j7W+4oelI3pn3RAEjPUp6xlL9ZtFIb3MDU
	 oQWtkv9tVOTozq7eiTrj9ghxsiNptvfyEWBtmzkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0609/1005] tools/power turbostat: Read complete CPU lists
Date: Wed,  4 Nov 2026 16:05:42 -0500
Message-ID: <20261104211100.905867185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit c24362650f7a8573dc9a9991a034b8500af8eb19 ]

CPU_SUBSET_MAXCPUS accepts CPU IDs through 8191, but the sysfs and
cgroup CPU-list readers stop at 1024 bytes. A fragmented cpuset or
hybrid PMU CPU list can exceed that size and be truncated.
initialize_cpu_set_from_sysfs() can also pass a full, non-NUL-terminated
buffer to parse_cpu_str(), causing an out-of-bounds read.

Additionally, initialize_cpu_set_from_sysfs() returns with the file
still open on success. It is now called once per CPU for
thread_siblings_list, so large systems can leak thousands of descriptors
during topology discovery.

Use getline() so both readers receive a complete, NUL-terminated line.
Close and free the sysfs CPU-list resources on every path, and report
malformed input from the correct buffer.

Fixes: eb187540d13a ("tools/power turbostat: Increase CPU_SUBSET_MAXCPUS to 8192")
Fixes: 58839fdbd441 ("tools/power turbostat: Process HT siblings in CPU order")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Len Brown <len.brown@intel.com>
[ sashal: Dropped the initialize_cpu_set_from_sysfs() hunk because that function doesn't exist here, and adapted the update_effective_str() context, where the err() message still had a trailing \n. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 3bab2677b0670..fb8f679549279 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6176,33 +6176,35 @@ int for_all_proc_cpus(int (func) (int))
 
 #define PATH_EFFECTIVE_CPUS	"/sys/fs/cgroup/cpuset.cpus.effective"
 
-static char cpu_effective_str[1024];
+static char *cpu_effective_str;
 
 static int update_effective_str(bool startup)
 {
 	FILE *fp;
-	char *pos;
-	char buf[1024];
+	char *buf = NULL;
+	size_t size = 0;
 	int ret;
 
-	if (cpu_effective_str[0] == '\0' && !startup)
+	if (!cpu_effective_str && !startup)
 		return 0;
 
 	fp = fopen(PATH_EFFECTIVE_CPUS, "r");
 	if (!fp)
 		return 0;
 
-	pos = fgets(buf, 1024, fp);
-	if (!pos)
-		err(1, "%s: file read failed\n", PATH_EFFECTIVE_CPUS);
+	if (getline(&buf, &size, fp) < 0)
+		err(1, "%s: file read failed", PATH_EFFECTIVE_CPUS);
 
 	fclose(fp);
 
-	ret = strncmp(cpu_effective_str, buf, 1024);
-	if (!ret)
+	ret = cpu_effective_str ? strcmp(cpu_effective_str, buf) : 1;
+	if (!ret) {
+		free(buf);
 		return 0;
+	}
 
-	strncpy(cpu_effective_str, buf, 1024);
+	free(cpu_effective_str);
+	cpu_effective_str = buf;
 	return 1;
 }
 
-- 
2.53.0



