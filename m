Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629F32F2377;
	Tue, 17 Jun 2025 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176476; cv=none; b=qB9336184tMdnFiUBNe1/ZHQ//BKv88EzXtdf/CVxdaahOwcBnZy3xU6GS7sFUtqxCSFcHbW9DeXfWSUx1Jf4L6fNeKT9QZMTAt6C1NStEcTbWF3dX9ZPmYndu5F6HUdyW87ekqhQl7btAuRw+BAHZ5WDKfcec3Khqw6WiZUdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176476; c=relaxed/simple;
	bh=S3Gn76mj+eB/JSH7ZeLYGQn6iN9SdoX7ll9XL0gSV84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eICRMvjzMryU7RWtVIQaVL+TZnvLJiggmsg3ZzgOkahpjmaspgSUaAHIvArfV5B0d/Iz8Fq6P3KiudGVWQJhFT8x+5fPt+ma05hznl+GQrX6WTq0iUUrHtsWWo4DkBAGzxFLsjgFqFUbdyrt2quRIb2XM0UVTvfHBxZX6DzuRQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQ0GGKCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQ0GGKCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C563AC4CEE3;
	Tue, 17 Jun 2025 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176476;
	bh=S3Gn76mj+eB/JSH7ZeLYGQn6iN9SdoX7ll9XL0gSV84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQ0GGKCGJT3tVO3GuZyyu3AquOn6AaxTxKhdATlUgCUjN4+joXSgWoYIMsDxzDfB2
	 SME4PY0xa1W41hx+jFPRt9OsX4lAxkLe9nYpPcc3p/R5YoKOaWwnAquRWDEwYe1GOe
	 g1uNRsmaLU4qfd/XPEVpL3u44sVhriC2aOr+JUjU=
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
Subject: [PATCH 6.6 281/356] kasan: use unchecked __memset internally
Date: Tue, 17 Jun 2025 17:26:36 +0200
Message-ID: <20250617152349.503721984@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ecced40e51032..465e6a53b3bf2 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -538,7 +538,7 @@ void kasan_report_invalid_free(void *ptr, unsigned long ip, enum kasan_report_ty
 
 	start_report(&flags, true);
 
-	memset(&info, 0, sizeof(info));
+	__memset(&info, 0, sizeof(info));
 	info.type = type;
 	info.access_addr = ptr;
 	info.access_size = 0;
@@ -576,7 +576,7 @@ bool kasan_report(const void *addr, size_t size, bool is_write,
 
 	start_report(&irq_flags, true);
 
-	memset(&info, 0, sizeof(info));
+	__memset(&info, 0, sizeof(info));
 	info.type = KASAN_REPORT_ACCESS;
 	info.access_addr = addr;
 	info.access_size = size;
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index dd772f9d0f080..d687f09a7ae37 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -324,7 +324,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	if (!page)
 		return -ENOMEM;
 
-	memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
+	__memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
 	pte = pfn_pte(PFN_DOWN(__pa(page)), PAGE_KERNEL);
 
 	spin_lock(&init_mm.page_table_lock);
-- 
2.39.5



