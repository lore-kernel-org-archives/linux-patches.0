Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029049;
	b=LrPu3UnMTSBwL4MZc7jpty0UAqZ4o9c8stQlHF2wVe9kCuxuBIFOisuZsTFQj9KwFAVQ
	 yhnSeTSXx8PFpROaJeXqJ9BZOv6j65illzZ8RWsbhJ9TMaTdCE2j+cVzwlhLsycnjW2I1
	 hkDQs07hwg3ziJILAQAimXQMcKlurSgNrPCOfXGq9gKgLafQUsnyhcZT0pcRKAKff9wP2
	 pbos9RWkUOFtxGepHSXd1UXQBM0CSN/r+xABocxRh87JqlQjbXTFzEzsFTWPk1fkoh99N
	 FpDOiDWcVQ3Qf4GxLw+HjPN0Wy42d0HGd3nwIJ2uXmClZ/zy65LgF3vC90IbDUUOrQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+KsMor2S84UfGYG7aIABNA7rXoReqevFFHokNVSE6Rg=;
	b=FbrmIh9yGAZuh+Ybv/1i6nenLdwPgQAppqE++NL1cz4+l3KXaQbGVjpiq38OQOUlxduy
	 RapFFX4tP7fm1Yb6NKaUp9iOR6m1cSvag8DtTstom3fNEB0cXJgSOUNAyRJt6ty7YcYup
	 B+26BV9DaSr4+O9ivPZFu0ODuU8qNzlgKRAC19LfIATftn0awffKYFeOw/5uifI7cgx+D
	 4zBgJEBy0aez3xfhKow1fQa7UAa0VwGaT9HIxXod4DsJ0pB2DcF8g1Ucdc31J2+1aLFym
	 A9RLX8uKx2PRihoLffYMF8YaViesHaXFKc/Tum+PMC8Od9l3HLLXNU0qdtzq16GkXPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv8W3ojE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC6E606A31C;
	Wed, 18 Nov 2026 19:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv8W3ojE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFEF1F000C4;
	Wed, 18 Nov 2026 19:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029049;
	bh=+KsMor2S84UfGYG7aIABNA7rXoReqevFFHokNVSE6Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uv8W3ojEes/qPY2I1xMUY5B5Kx0dDqRECvnsX/N356e7D3ElyptJS3hfVtcJ74BsY
	 szIJwxfyzJImS+8n5GB1tPZbizstSlFXyON+5tDVGge4G9pqSV5/dSLhPi2nYfgJyg
	 XFVMvgIxz17oe0LttQ87xR5peom+9KTERtwDmN0Q=
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
Subject: [PATCH 6.12 0209/1756] x86/crash: Reserve elfcorehdr for CONFIG_NR_CPUS, not CONFIG_NR_CPUS_DEFAULT
Date: Wed, 18 Nov 2026 15:38:56 +0100
Message-ID: <20261118150016.667343793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 340af81556584..957b8464a9aaa 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -379,9 +379,9 @@ int crash_load_segments(struct kimage *image)
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
@@ -440,7 +440,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	unsigned int sz;
 
 	/* kernel_map, VMCOREINFO and maximum CPUs */
-	sz = 2 + CONFIG_NR_CPUS_DEFAULT;
+	sz = 2 + CONFIG_NR_CPUS;
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
 	sz *= sizeof(Elf64_Phdr);
-- 
2.53.0



