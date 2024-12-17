Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDAE1E0493;
	Tue, 17 Dec 2024 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455987; cv=none; b=CtkI7CXX8455mAMcEtBOHl1NnuK+KbSHTe4CH1ubLDZPLk85IPZvqGIxyAyqYhqii2ZPOxvMdUiv98aqL6SjMk48YI+sicAurlh7SMEc2WzQ069IXvl4sv2vjkjmv7xmblEFYl5oeDURDZgbZPf+YlBWHOHbNswXGM6cWU+SSfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455987; c=relaxed/simple;
	bh=zoECW1UQTrRUx9LLcmcQ3tLwL7biJVjk+ri9voJAu88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5C0H1qPAxfkr0uJBRx6CwNZNn3Q3lsGo4BI7pnAdsCy/8nSWcuKl/3lyica7y0/dFpu8XKz1aBWUbrDTaMGfrn14qjqh23nBaKM/AwOFNP4HWMSYXumpR8eEYcRzpV5nrXFjKVDB95hKpJhR0/8cjYkBa/KV569zzWw9kfZG5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpqTTGZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpqTTGZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CCBC4CED3;
	Tue, 17 Dec 2024 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455987;
	bh=zoECW1UQTrRUx9LLcmcQ3tLwL7biJVjk+ri9voJAu88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpqTTGZhLuy4UeVgD9KetAoJwT8zHusfPtuT8s0wo32mEszrnvvfgWC+IcR+vj+on
	 eL6/WnDoq84vdz3rFciq5ynumpOnsDh/AxJVsA8+RWZgORLrO8o8W3F5ACJWrJRN7l
	 qeJukht480lChM9bQc0Zs8hAcLzbBZXkfawyzewc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@outlook.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.6 022/109] drm/i915: Fix memory leak by correcting cache object name in error handler
Date: Tue, 17 Dec 2024 18:07:06 +0100
Message-ID: <20241217170534.292909377@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


