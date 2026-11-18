Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027655;
	b=IfMW3yfE2i8NEAs6q5ttfx7Qs6P6KengxAV9zjU8iXDzSvzL3kvd4B9bqbtkcctJNqC+
	 9AZjJCTXlAOfChKtvBOGcN69ijXWeSeGS2JBsGVyWLLLj/ICsZOdBSk/884boKm4TPHKm
	 PdUF/C2TFgyxuGF2bToFLuhN90ai3d6z3eq15onlR+kZgVBBOF/7i3vl+1RcMDh2I5agw
	 Nc1hbLMUAiNYN8eRrR4ERkfp1FWloenRpgtFRCtihAsWA5ORs+VjgjpKKhzZ7AK4xPNCU
	 p6A5qaD7l2s0ev1DaeY6MUqWkXniLdY0CQwUGJ9U4bvyeROjLZzjTQ4+u5SgqOypRmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cgXe4cSHLM8moBElbPQZTAmoFlYvVYhVrcXjnKBwnEY=;
	b=plQpSQsaxSeXAO49d/lA6P8jozcvo5pGCtKP7s09TuOdlFWy1Nel9AAc/bONxxuAdQ+U
	 Yrl+qx164ZdU7FtSdTnXnk4lTQfumYa/YuacdYUJbbQSwej56XWqH7WlLhGkEB7DpJk6e
	 JMFQXVLp5axdv0aKz+yDvXDXqJjQMaNQra+MtmnHLcSGF4EH1D0QYKytnuQw5WruLTMvx
	 +WdE0D7801z8QnEdsxwryubV7nVYOuO3H/eXM+olqXZk8fXlg+L7m1IYXCRar6FAo9yC5
	 QnXwayBRsd4Cn0BAdlMPTkX6OKw2DvgEoUuNrII59olLGriGPVGwIggWkzK5zxFOrtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UaQkz9pa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1477B606A337;
	Wed, 18 Nov 2026 18:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UaQkz9pa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D7F1F000C4;
	Wed, 18 Nov 2026 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027654;
	bh=cgXe4cSHLM8moBElbPQZTAmoFlYvVYhVrcXjnKBwnEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaQkz9paJy8xmw1HqZ0B8PTWYOLVhHYc0UUzakmXZ+N3VbKGxy89ESxWqu9dNto2n
	 tqqMMmik7X+a18pTXIvLbzt+4bb0B30x7mt9T8bQp8Yt1S5exmz19MoNJNYs3/NhlS
	 eBHjsP56IFoNNvh93BUaldYjyzTO9Hc3hu2j0SEQ=
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
Subject: [PATCH 6.18 1864/2151] kexec: Add helper to report an active kexec reboot
Date: Wed, 18 Nov 2026 15:59:59 +0100
Message-ID: <20261118150229.703520628@linuxfoundation.org>
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
index 8a22bc9b8c6c8..827a5311d97a3 100644
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
index 08ae3c64caca5..08ed4e14cf39e 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -22,6 +22,7 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/export.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
 #include <linux/suspend.h>
@@ -53,6 +54,12 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
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



