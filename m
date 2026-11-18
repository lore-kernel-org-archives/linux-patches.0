Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015448;
	b=HtHUSS6k46kuP5XZr7Og5Ca5xH5yjTFKmJRbmlAQG2dHuNhExQc1FkdmEoKatH5hyWNI
	 iHpa/W37yoXNA2lw+Tl45L+6HzxZPlXytkdaY8MImPhSni7nsCxwKp6u7O8KPlu0dAtvG
	 JeCQZvj3oFYO5i64AhU6Vm/kyiwPt5pVrxJUNIfk+dA03W66gmit/vNY5znpmP9dj9+Zd
	 cUX14wfHQQFzc3omB7kn9gXm+cpBYRctSAkgjzfOWXMvCB4YkApbG2EehUZtWHhV4r0Bd
	 jaPcMBi/pGY8p1qQhnTeH6Xp6+ET7KmR9FKU5+Psw3OBw5JLaxUFe56yLCj6PVEEM0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JV3lr0fXD60NNdN+IU3D3x2+eFFt5gKr0NGnp/A+g3k=;
	b=LawVrWHCWgDQoM94JDD8sEVguIQfJcr1PTnKaqF+ESQXvSSnFSQ1DxqcfHK0+3HmfAH5
	 qdl4BcxFENtsBwtX7DB1LApN1QcPUUO91HFTHrGCvAMmOfQVtq9fAdgMaSggTqoPV0EPj
	 IAXLY6TbR3pzbY5VqQyJ1p7J/0jFJjkuj+e0y2O4Z1YP6TJoo8LKdOL74ThzGzWEi76E6
	 KR+ixM6kmlfS0n45LNYAEzfiVEwVhxXYsPft6pMt/pEa+mS0rXJ8PoYaUlkq3VgB4+QhX
	 DcX6VFcG8XoM0asQQUGDfpNhyA94PK/r2qvDESVIEYRFG6U4sTjL9IpC2gqyKKzmqdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmeA08Cp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCADB60A2617;
	Wed, 18 Nov 2026 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmeA08Cp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085991F000C5;
	Wed, 18 Nov 2026 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015448;
	bh=JV3lr0fXD60NNdN+IU3D3x2+eFFt5gKr0NGnp/A+g3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmeA08CpqAIgtPIaTT6hpecuo4RG5XHhPn2KuSujrL4fSOMtjAMBEbsmyt+PH/YB+
	 N/6uv9PjGhqHdSsUN2kGhdhLV0h545rvkgcrat+Av24No/N8tgcAsXHYsIjLWiCgip
	 glPXdTzYcPdaST2JkS/tnMxhnTlp4fIeQNoQJHSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ionut Nechita <ionut.nechita@windriver.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Bradley Morgan <brads@mainlining.org>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0178/2651] x86/crash: Reserve elfcorehdr for CONFIG_NR_CPUS, not CONFIG_NR_CPUS_DEFAULT
Date: Wed, 18 Nov 2026 15:23:38 +0100
Message-ID: <20261118150254.254127435@linuxfoundation.org>
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

From: Ionut Nechita <ionut.nechita@windriver.com>

[ Upstream commit 6664ad1026b558563702f9a1ce637df33e7c001e ]

NR_CPUS_DEFAULT is purely a Kconfig thing.  Its entire purpose in life is
to start NR_CPUS at a sane value.  There is precisely one (buggy)
reference to it outside of Kconfig in the whole kernel: the x86 crash
code.

That code undersizes the elfcorehdr reservation whenever NR_CPUS exceeds
NR_CPUS_DEFAULT, because the header carries one phdr per possible CPU and
num_possible_cpus() is bounded by NR_CPUS.  kexec_file_load(2) then fails
with -EINVAL from sanity_check_segment_list(), and kexec_load(2) silently
truncates the elfcorehdr, which surfaces later as a bad or unusable dump.

Size the elfcorehdr reservation with NR_CPUS instead.

Fixes: ea53ad9cf73b ("x86/crash: add x86 crash hotplug support")
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Link: https://patch.msgid.link/20260901071041.16311-2-ionut.nechita@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/crash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e681ec9cf1dc8..e6f23933a6df2 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -369,9 +369,9 @@ int crash_load_segments(struct kimage *image)
 	 * maximum CPUs and maximum memory ranges.
 	 */
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
-		pnum = 2 + CONFIG_NR_CPUS_DEFAULT + CONFIG_CRASH_MAX_MEMORY_RANGES;
+		pnum = 2 + CONFIG_NR_CPUS + CONFIG_CRASH_MAX_MEMORY_RANGES;
 	else
-		pnum += 2 + CONFIG_NR_CPUS_DEFAULT;
+		pnum += 2 + CONFIG_NR_CPUS;
 
 	if (pnum < (unsigned long)PN_XNUM) {
 		kbuf.memsz = pnum * sizeof(Elf64_Phdr);
@@ -430,7 +430,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	unsigned int sz;
 
 	/* kernel_map, VMCOREINFO and maximum CPUs */
-	sz = 2 + CONFIG_NR_CPUS_DEFAULT;
+	sz = 2 + CONFIG_NR_CPUS;
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
 	sz *= sizeof(Elf64_Phdr);
-- 
2.53.0



