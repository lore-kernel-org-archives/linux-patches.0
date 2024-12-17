Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62AD1F8923;
	Tue, 17 Dec 2024 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455760; cv=none; b=P5/eMuJswxCUt0+VH43AUADY+GbkqtibkV5URkZuzMgl62grvnlN4zbgQrtH8xKC4dbl+tZToiZ4ftei6qX9N4c+AmC2C6Cnynvbl5cAWphEYruoiMtlZ14nHZ7GHlpCG/LIwZjoDibBc2yk7lDC+80TzNwUEMV+A8o2xOdAr30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455760; c=relaxed/simple;
	bh=2QbwLgbicREenJqvl+6C1HgpuegdG7uHTctgDPMrGrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYPMR2aGKOXdi8uEnDWQYxZ+oGw/2zKMlnGqDowK0JpabGkQN7dmAfYSTFtW/bJZsaP3GHpEGppk46ahfJ1ljssDOLkvUn6tsnGuWCiW/xLVwMqkJVW3GMJhLZ5Xf9jLNFJdmlZz350MqADdSZtQGPq4/yQpav2il4yKKgffI80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaMa+AMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaMa+AMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9C0C4CED7;
	Tue, 17 Dec 2024 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455760;
	bh=2QbwLgbicREenJqvl+6C1HgpuegdG7uHTctgDPMrGrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaMa+AMlCwa11LTzfTC5iUCThQJy5mxqDFyDPmvJHGQUpnUxkCq4oaRz5vyUeprm1
	 /Qr6v39Ww3YJHkhorP7jYvmQPI0gPBRx4cqQGeFpbHxwLMy+ucL3X0Yhna3fWOEg3Y
	 6sNGfHgW6YU/cM9R60vF0CfniBWRdKptconFXIwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@outlook.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.1 16/76] drm/i915: Fix memory leak by correcting cache object name in error handler
Date: Tue, 17 Dec 2024 18:06:56 +0100
Message-ID: <20241217170526.924474914@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -506,6 +506,6 @@ int __init i915_scheduler_module_init(vo
 	return 0;
 
 err_priorities:
-	kmem_cache_destroy(slab_priorities);
+	kmem_cache_destroy(slab_dependencies);
 	return -ENOMEM;
 }


