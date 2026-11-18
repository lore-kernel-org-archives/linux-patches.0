Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022981;
	b=NnXsdJJnYsECl4bg/EgFraI5AeXtmXZQDOGi9nIm4Kd5/gifEshF1Qxyo/YSt5h3I7xE
	 9w6wmlfHBtUINxEyI/9jQr24o4nLf3SCSS8W4zEiLSBC1iCQw64N/kJGjEwzanGdvq7e8
	 Q8yNkdl55MLL+q7CtoA4TQ+n3jh51qiz1B8bLinucsD1Rv00hywmSvP/M4JyK2NDeqp3o
	 OOPRMmAHFCNDokjGYP1zJCZCsVSNeOBfA02sdsjtPlMstMA72NczJ7lomcVhq3FB07lLX
	 q1m+mT8ur82ZmyapxDERTgyoUFCdW+KDkKYZI8+zouHskMQkQDBTOxTLIuk3+ck3bIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6hTTsW0ZBsVzGhR8XCR1/XpJbKHWOcsRN2e3n7mQ31I=;
	b=JOzba+SLeBJyX1UjrjmKZmGjaRbdDXfRGCaRnZtit+ACQbcYQbEdUxg5qn88d65dWoUD
	 uUCmTZ3DzBMC5Kr9QuJJzjV8p3nK3R2von7NWM4tjFeWvxLhSlyY4i5uyfmqc2Njiwlmn
	 EG8xaDNgsEKKBXFDnQqbmO+hRwcCxhiRsp+dKZN0tKMFH4jb9XXLns0AZdf6UF5xVx2Dd
	 m8QbRzyEV4lL6b+4I7ML346cIU3hIVS4TnLk4PlFgVwluSTTw8BxSo/bzdaazH4z2W1XX
	 aVSkpvZEZix0AIxor8PGZ44C0VYtHMMCMXK9hzKvb1WZk8BVn8QtAQVOFsmzlgSLEBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NkTt/YBn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B118606A31C;
	Wed, 18 Nov 2026 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkTt/YBn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54261F000C4;
	Wed, 18 Nov 2026 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022981;
	bh=6hTTsW0ZBsVzGhR8XCR1/XpJbKHWOcsRN2e3n7mQ31I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkTt/YBn8nVFh3LyFR0VGf3BncKV3PKNE/D5ITz+MhefFgk/w1ryQv/q/JncKxKD8
	 Ssb2iDVitxVYC4c0NOqN4hui5E/EJAEw1EU+w3YHW2sRdD4Shro4Y5UWMwx83TcYhZ
	 x9VBKiMFe9gtuSyrPbghEr26WbSehCqWuuY3OcwY=
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
Subject: [PATCH 6.18 0206/2151] x86/crash: Reserve elfcorehdr for CONFIG_NR_CPUS, not CONFIG_NR_CPUS_DEFAULT
Date: Wed, 18 Nov 2026 15:32:21 +0100
Message-ID: <20261118150129.287401337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 335fd2ee9766d..521ff276f5c5a 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -432,9 +432,9 @@ int crash_load_segments(struct kimage *image)
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
@@ -493,7 +493,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	unsigned int sz;
 
 	/* kernel_map, VMCOREINFO and maximum CPUs */
-	sz = 2 + CONFIG_NR_CPUS_DEFAULT;
+	sz = 2 + CONFIG_NR_CPUS;
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
 	sz *= sizeof(Elf64_Phdr);
-- 
2.53.0



