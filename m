Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021441;
	b=KHuoIfS1o2c8vF1VGV718mVf905QeFeEl5d458sr2uTQGWvCDOk44/64GpRhTsDFRwjL
	 w9WBesApoxscWocs+wUGYoqWsPGct0nf/uFxBCk+sQ5xxawrPFALj33FC6Dc9TJHl/K7i
	 0iKbAmGe1S30NuFOTLRM9j5IjoQB2617rN8SXvaL8tgfWLIEbAeMHLaA3MFi3ncxW7fP9
	 zzMCuxa0A1HxQMuzfDMzyg6ZdCo5yn6nU+CPsNwPcbGAJF3UkhgFypWws01KpOMPsjgcJ
	 w8036Rzj7HtnpX9lPmtZQyUFW38bFLoG7mooLE5etQ81b4L6UmzfTRQdr7DGbsDZDJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IRsbeNyr26S8Nuprcxc6YSsHy3XrT0kCExY964Ozs28=;
	b=GMUogTGbje2ncpt04wPIKKWTFAK0r7LpjbT5bIMigjQwjRbzRVODDAuViqxO3CgW8YR0
	 hSf/3QYb+X1G/9Fj+Pz13bwFhMWl0yrOHeM8rEmNbOfEYFvR/l6uxMlChwDqJC0YwuE40
	 UnkLLCNgyaHZaxsstepj1zoUYUUQRtScANofkAaLSzqoil/A548jFX9qB6dg7Pe4kKJzl
	 Th2P671ArzkwLzs/sORlIh82vgO8Ib7rkY7BZZJFoECVucJdAUq/Cmff2mU5JUBl3c1Wz
	 +6t3RCEn/OIH9h95nFkAbuHBl5VdlQBttQi2JTtmO9KBv7AusCcUMUr1oOkmh3GDEpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfhKTFAA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0560A2601;
	Wed, 18 Nov 2026 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfhKTFAA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FC41F000C4;
	Wed, 18 Nov 2026 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021441;
	bh=IRsbeNyr26S8Nuprcxc6YSsHy3XrT0kCExY964Ozs28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfhKTFAA2woP/O08w+XXJUp03jdH0X1MwfiH7zTF1uEpLubo0D+MuTM/Eb/qNd3XI
	 YEIyHtyNZGoCcLSBrFpXPsZgnn+mf6oiVA+n7xh0FGW+sitOGYEzMmHbhlGUmdORpo
	 6h68FyjbC2VjPsmmWT8RwjbHAwmlB2VJtYqQiKJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Bradley Morgan <brads@mainlining.org>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2307/2651] kexec: Add helper to report an active kexec reboot
Date: Wed, 18 Nov 2026 15:59:07 +0100
Message-ID: <20261118150408.305599890@linuxfoundation.org>
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

From: Shradha Gupta <shradhagupta@linux.microsoft.com>

[ Upstream commit 14c73a2b061e494ab6da346ab075b14f2a4b2d06 ]

A shutdown callback in a loadable module may need to distinguish a
kexec reboot from a normal restart, halt, or poweroff. The Hyper-V
VMBus driver needs this distinction when moving its kexec cleanup into
a common syscore shutdown callback.

Add kexec_is_in_progress() and export it to GPL modules so the callback
can remain guarded when VMBus is built as a module. Provide a false
inline implementation when CONFIG_KEXEC_CORE is disabled.

The helper reports only the normal kexec reboot path. Crash kexec and
preserve-context kexec do not set this state.

Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 228e21764b38 ("Drivers: hv: Run VMBus kexec cleanup from syscore shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kexec.h | 2 ++
 kernel/kexec_core.c   | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 0af8ae4fdd087..aeb74b47c36e4 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -468,6 +468,7 @@ bool kexec_load_permitted(int kexec_image_type);
 
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
+bool kexec_is_in_progress(void);
 
 #ifndef page_to_boot_pfn
 static inline unsigned long page_to_boot_pfn(struct page *page)
@@ -544,6 +545,7 @@ static inline void *kimage_map_segment(struct kimage *image, int idx)
 { return NULL; }
 static inline void kimage_unmap_segment(void *buffer) { }
 #define kexec_in_progress false
+static inline bool kexec_is_in_progress(void) { return false; }
 #endif /* CONFIG_KEXEC_CORE */
 
 #ifdef CONFIG_KEXEC_SIG
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d053..282c7b3c6c353 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -23,6 +23,7 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/export.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
 #include <linux/suspend.h>
@@ -54,6 +55,12 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
+bool kexec_is_in_progress(void)
+{
+	return kexec_in_progress;
+}
+EXPORT_SYMBOL_GPL(kexec_is_in_progress);
+
 bool kexec_file_dbg_print;
 
 /*
-- 
2.53.0



