Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009801F757B;
	Tue, 17 Dec 2024 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455538; cv=none; b=CDbFgUJlbT5J/p7exSiQ3muxyJ50Z8/6L/u9MrK3rD3Xrb645KwJ2GaOKkXBIlHfW2Qt8nhNT+lc5OXWHhiCrzzty3yXYpt0SvgTKFWR6EUp5qN+W4UOipubROzVO5chE8a6WfCEFMGtzkoEpEmQnU8wrvMUikxQYIb2q7y8k9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455538; c=relaxed/simple;
	bh=ulzlLvXXoA6cVYAEdBL38xkgb+FO71TYasKPQEZaB6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhRLdSr7Qe187I/20TbN8PsBmL+LcSAPwrQAg5sacYV6c9UYhDcWN8A7V2DwgRDJ6/FW4dO+hWMpiTqNUbn+u7neEl/V3aL9XQPdvNYePT4FUmd0AA3GP1hIy1XKQhV9mOeD+QuV0knUlN2xN1ByLCcbsYPaha2/StN7WKfi1zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUzLKilq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUzLKilq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7782AC4CED3;
	Tue, 17 Dec 2024 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455537;
	bh=ulzlLvXXoA6cVYAEdBL38xkgb+FO71TYasKPQEZaB6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUzLKilq9cZ+tk8Zqt1KVtmoNc0nMIzbrVfDcySjBwwQLQSF78SUb/w/YzfkanZVF
	 uQvnCopWXtTCF8gMaLv675gt8do64+RVaf0AOzI5rqTjWYiZ3pGKfvi4DR8XNIdE2p
	 U7ccW0MIOZbVneKaAJRhruarRmDm11z4P+vFpbmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@outlook.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 5.10 32/43] drm/i915: Fix memory leak by correcting cache object name in error handler
Date: Tue, 17 Dec 2024 18:07:23 +0100
Message-ID: <20241217170521.816591290@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@outlook.com>

commit 2828e5808bcd5aae7fdcd169cac1efa2701fa2dd upstream.

Replace "slab_priorities" with "slab_dependencies" in the error handler
to avoid memory leak.

Fixes: 32eb6bcfdda9 ("drm/i915: Make request allocation caches global")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@outlook.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241127201042.29620-1-jiashengjiangcool@gmail.com
(cherry picked from commit 9bc5e7dc694d3112bbf0fa4c46ef0fa0f114937a)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_scheduler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_scheduler.c
+++ b/drivers/gpu/drm/i915/i915_scheduler.c
@@ -538,6 +538,6 @@ int __init i915_global_scheduler_init(vo
 	return 0;
 
 err_priorities:
-	kmem_cache_destroy(global.slab_priorities);
+	kmem_cache_destroy(global.slab_dependencies);
 	return -ENOMEM;
 }


