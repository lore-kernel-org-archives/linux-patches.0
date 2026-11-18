Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039272;
	b=QMR4+1YowwO4XGe7k8yQTsZIAC6GVmCXjG/+oPY37zeVgKnkjSM50xwauMlP7VYLyRux
	 OuvPdWQ4Oz2C8Q8tb3TZIeZNLKeobg++BwQKN+npNN6ZJvrnRp6JM4MZsrSP8bCHOUmOO
	 0TUeKSJikDPhAIJJVHPU4CZAz2/OD32i1IQ0vfTptPG/XUv9czAaa3yCfo6TiiWIiLu4b
	 vjRJicZsf4LUsb4pFYJpjByRz7fVO22cjkoMPLA8BC9y8tNpWI3QLX7ApXiRuQD8PEEeT
	 kgfl+zLhGBFW7HC9ixC7v0euluRPppWYd+AoPjdTFoTE9ZOSFzapoR/813RxZm8O2GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/eGpog9xihtSVMgxNNG5RJP8hE9lOb3VoI9DKabttWY=;
	b=ywZigM1BQM8Apll/UU0EKn9J3ZyWwXfu2g1kFX4KkY8Od2Y5cr+2dai4DnWTj9385l6m
	 NhHuyGBBsN0QT0l8hwax6iKlUy8UOeaxOl9rkzsJJYB7EYguis+PaqlcW8Tc5OE+CXdXd
	 tSqQATOjOh9SkSmelEMMF47qbst96gUcarYbq19HJoCQztDaC17MSLtBJ5gYHg6y/BReT
	 fC8dLnqWiBIk1SqPEKZP2n1jEuQ0TIMDryhNBYvJoHrgWj0UBO7grFB/lYJi/ezOCwnZk
	 INl4y7tI5JsURqzuYpTQha1MUB9rc/bxopLVtwtkmsd7ZjxJX0SwWWW1FH0fgsiuf0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhpqgvFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6631606A325;
	Wed, 18 Nov 2026 22:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhpqgvFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E59A1F000C4;
	Wed, 18 Nov 2026 22:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039271;
	bh=/eGpog9xihtSVMgxNNG5RJP8hE9lOb3VoI9DKabttWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhpqgvFKbgZwf57m+lblvvrgtfme1p0qFUMfeEAS6ApFhxmHgLOtfCEL5/c/u535+
	 /v2lH/aiBcZe9zmHDq/aKN0QIKOvX01SZ+xFUh0I109XjWI57WmMPfsZ+43A2Ed17W
	 dAmJwK+/oUOKJAnKGMd34n4OLPyrni74SOpCy+AI=
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
Subject: [PATCH 6.6 2040/3318] x86/crash: Reserve elfcorehdr for CONFIG_NR_CPUS, not CONFIG_NR_CPUS_DEFAULT
Date: Wed, 18 Nov 2026 15:44:22 +0100
Message-ID: <20261118150423.243943918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c92d88680dbf1..56ef7c0966f85 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -363,9 +363,9 @@ int crash_load_segments(struct kimage *image)
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
@@ -418,7 +418,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	unsigned int sz;
 
 	/* kernel_map, VMCOREINFO and maximum CPUs */
-	sz = 2 + CONFIG_NR_CPUS_DEFAULT;
+	sz = 2 + CONFIG_NR_CPUS;
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
 	sz *= sizeof(Elf64_Phdr);
-- 
2.53.0



