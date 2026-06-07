Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3218287510;
	Sun,  7 Jun 2026 10:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829713; cv=none; b=oqcdmEaiEVNVskQyyBbpuhFI0hUMJblhyc+fMk42MnP0bnZyg9p2yJLYAa2iCHVBGdLFkvRMH/f8VFegzzyxkXWgroKNLgysYs06fNYSQMgM6FIBI7P7KKkkRXJ1DuzJqPvQMeokErJt9gA0YtayiRcJ36le7eH79EVrdVQte60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829713; c=relaxed/simple;
	bh=1aZpopYgdI7vGt0dVE3KMSdqbFDMTH1YOj2PlP9faeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FZkuEVyzsq7EIl8IcaecfwhaHBjJrEvuf331Dr3D8z3nsbz93PvTyZW72WEYMDza1Yqm9XTrUJbs9Tv+/Bh08TV+mRRCz+GxInGAHeCVDNJcMjA9xrFg5MFHqDbr+kuAXVccyW/3Ein+kmGfOYyDU+459gRymVlY2W2ruNZ0Si4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOn/bDa1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOn/bDa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45861F00893;
	Sun,  7 Jun 2026 10:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829712;
	bh=qIgGREfk34jAxaFVucJQ7q1eiYU2ZsOyeNsanXw1+Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOn/bDa1cq348/RDLU7w0j4fdMgc+3tj+Z5shH9ltrEkcaXpxxIqM/JygUbvgOwqZ
	 6dKzY3pO9aUZwV9Rh8Kvm4okN8Jxp+zm8zBeAlkApzcyVnFaurBs78bfeLOLr+pMhO
	 ZPXLb8KtFEzb6BEoTC6mtZNxjtKWuKfRD90dLFIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 307/332] drm/amdgpu: fix amdgpu_hmm_range_get_pages
Date: Sun,  7 Jun 2026 12:01:16 +0200
Message-ID: <20260607095739.359901296@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 962d684b5dc0741dcd93485d41b450de402d5592 upstream.

The notifier sequence must only be read once or otherwise we could work
with invalid pages.

While at it also fix the coding style, e.g. drop the pre-initialized
return value and use the common define for 2G range.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c08972f555945cda57b0adb72272a37910153390)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -51,8 +51,6 @@
 #include "amdgpu_amdkfd.h"
 #include "amdgpu_hmm.h"
 
-#define MAX_WALK_BYTE	(2UL << 30)
-
 /**
  * amdgpu_hmm_invalidate_gfx - callback to notify about mm change
  *
@@ -171,11 +169,13 @@ int amdgpu_hmm_range_get_pages(struct mm
 			       void *owner,
 			       struct amdgpu_hmm_range *range)
 {
-	unsigned long end;
+	const u64 max_bytes = SZ_2G;
+
+	struct hmm_range *hmm_range = &range->hmm_range;
 	unsigned long timeout;
 	unsigned long *pfns;
-	int r = 0;
-	struct hmm_range *hmm_range = &range->hmm_range;
+	unsigned long end;
+	int r;
 
 	pfns = kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL);
 	if (unlikely(!pfns)) {
@@ -192,8 +192,9 @@ int amdgpu_hmm_range_get_pages(struct mm
 	end = start + npages * PAGE_SIZE;
 	hmm_range->dev_private_owner = owner;
 
+	hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 	do {
-		hmm_range->end = min(hmm_range->start + MAX_WALK_BYTE, end);
+		hmm_range->end = min(hmm_range->start + max_bytes, end);
 
 		pr_debug("hmm range: start = 0x%lx, end = 0x%lx",
 			hmm_range->start, hmm_range->end);
@@ -201,7 +202,6 @@ int amdgpu_hmm_range_get_pages(struct mm
 		timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 
 retry:
-		hmm_range->notifier_seq = mmu_interval_read_begin(notifier);
 		r = hmm_range_fault(hmm_range);
 		if (unlikely(r)) {
 			if (r == -EBUSY && !time_after(jiffies, timeout))
@@ -211,7 +211,7 @@ retry:
 
 		if (hmm_range->end == end)
 			break;
-		hmm_range->hmm_pfns += MAX_WALK_BYTE >> PAGE_SHIFT;
+		hmm_range->hmm_pfns += max_bytes >> PAGE_SHIFT;
 		hmm_range->start = hmm_range->end;
 	} while (hmm_range->end < end);
 


