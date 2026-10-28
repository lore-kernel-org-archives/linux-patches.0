Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214224;
	b=jYiOvt/Ujk8bcbH/kplGw1ZgaApgNLEIPNN9bzCmTpAE1cYTI9YlUnsDPlrwSdjMK7xr
	 wLTaY+/C16Q2ckbfUALg4pwtv5kZbH2Ku6Wk4Njg1g5DyPLtKIlq2Wrurd3kpc5Ai7F4+
	 qEAxjGyJA6T0fVG0DyRb/fX35O76WXgAk2JgciEnm/gjssRtkonl2wT7MkJY8Q7RTVN9h
	 iQcxNfdDozT68EeIbHqgvkU0+b+mn6yQUtduOJkePOei4fh7FVjV7oZtotlyQ9ya1i5AV
	 5to9MQdc0+EZrpuF1vOY/MCO7XkbdWkrisqHfYlo4q7hKkWjk5kVxhnpf39BL0i8z/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SD2Sq3GReykw2NUT7j7PFVTJO3pRGQ/ZJoSW+wg+R9c=;
	b=ynM8TykpW5sgsUcVukB9BX/AstzZ8EYhKnUUuGBYcOhgw7yVazSF/nhubs6pgGEopLUi
	 +Vdfs1OlgLFIx5378aLu4G0rQWXPqVZEulEC5A3vUfjFLaoOk+EFMSS50vWofY9Izp110
	 QNQkFYaiS0pt/EkxksxkYOpooEeDMbD6aOGFbuikessbzyP7hoifS4SfM1NKm39VMDSNA
	 mCFqcSaTPxpBP426MBsD8kNU+goBnjnK+/ejCSjDYA+1cN1ZxxqOj9TL+ltD2CZ7e7acn
	 wxfBXNTAk4VKTEsrLdDaAohbll8mUEfLizyvyfzlvs1FxAFlkzUHegXd7UrqdKldaaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAjMPbJl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078F9606A331;
	Wed, 28 Oct 2026 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAjMPbJl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB5D1F013C0;
	Wed, 28 Oct 2026 19:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214223;
	bh=SD2Sq3GReykw2NUT7j7PFVTJO3pRGQ/ZJoSW+wg+R9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAjMPbJlC5O0tE7c/PfDbRk2p0kq2I0PFUI42aTTTKnWSbjSp2LXtQg9T5m8D5i1K
	 rq1Ccpmwj5BeZsRU6aqoOdIQm1pQRL6hEnT2vLRSsUBIVHTkl5SU2uek80o3Lrwsk/
	 0u9ASi5L5VNUviMKmYuT/Zwv9I23wTpG7YWO6v9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@google.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0783/1887] kasan: use unchecked __memset internally
Date: Wed, 28 Oct 2026 17:47:59 +0100
Message-ID: <20261028170517.257249644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@google.com>

[ Upstream commit 01a5ad81637672940844052404678678a0ec8854 ]

KASAN code is supposed to use the unchecked __memset implementation when
accessing its metadata.

Change uses of memset to __memset in mm/kasan/.

Link: https://lkml.kernel.org/r/6f621966c6f52241b5aaa7220c348be90c075371.1696605143.git.andreyknvl@google.com
Fixes: 59e6e098d1c1 ("kasan: introduce kasan_complete_mode_report_info")
Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b6ea95a34cbd ("kasan: avoid sleepable page allocation from atomic context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/report.c | 4 ++--
 mm/kasan/shadow.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 240560ec8d99a..a69d0812a9220 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -477,7 +477,7 @@ void kasan_report_invalid_free(void *ptr, unsigned long ip, enum kasan_report_ty
 
 	start_report(&flags, true);
 
-	memset(&info, 0, sizeof(info));
+	__memset(&info, 0, sizeof(info));
 	info.type = type;
 	info.access_addr = ptr;
 	info.access_size = 0;
@@ -512,7 +512,7 @@ bool kasan_report(unsigned long addr, size_t size, bool is_write,
 
 	start_report(&irq_flags, true);
 
-	memset(&info, 0, sizeof(info));
+	__memset(&info, 0, sizeof(info));
 	info.type = KASAN_REPORT_ACCESS;
 	info.access_addr = ptr;
 	info.access_size = size;
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index ecb7acb3897cd..578877ed49564 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -272,7 +272,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	if (!page)
 		return -ENOMEM;
 
-	memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
+	__memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
 	pte = pfn_pte(PFN_DOWN(__pa(page)), PAGE_KERNEL);
 
 	spin_lock(&init_mm.page_table_lock);
-- 
2.53.0



