Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8531A1ED30
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CE1C433C8;
	Tue,  1 Aug 2023 09:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883380;
	bh=yrBDOiIu0aV9oXezmy5/7ovkM7W/KcH1JXR6mfXWPI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oo6lx5ySkNyU44xXNIxc1QKQMcn/IbqBlSRHDm4FYTfn+DkSfUjUNud5OJwVEU/qN
	 zrlVa5qiZeqm+LqtR+UDvmdfk/ASdiNwRgqSVR7DgKETPkze6ZovxLC5o7zmGggAxL
	 9dfHfMReWKSuShY/R0pht41CAnqI2T+FidHJlY98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.4 215/239] LoongArch: BPF: Enable bpf_probe_read{, str}() on LoongArch
Date: Tue,  1 Aug 2023 11:21:19 +0200
Message-ID: <20230801091933.641357262@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

commit de0e30bee86d0f99c696a1fea34474e556a946ec upstream.

Currently nettrace does not work on LoongArch due to missing
bpf_probe_read{,str}() support, with the error message:

     ERROR: failed to load kprobe-based eBPF
     ERROR: failed to load kprobe-based bpf

According to commit 0ebeea8ca8a4d1d ("bpf: Restrict bpf_probe_read{,
str}() only to archs where they work"), we only need to select
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE to add said support,
because LoongArch does have non-overlapping address ranges for kernel
and userspace.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -12,6 +12,7 @@ config LOONGARCH
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_INLINE_READ_LOCK if !PREEMPTION


