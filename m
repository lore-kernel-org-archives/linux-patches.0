Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8B18615A;
	Tue, 17 Dec 2024 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456430; cv=none; b=tLx3sWP9ofCSewh/QOUYZ/Y0K9TR0atGAQuzcUr3XJfRI9e+1r/INeVvJmAgXRredZGwu8DFigWhn9HXM+ckOKkEInyH4OhVaXuc3GhO68yASEVfsvGasCjGatDpXSyk8OcyfRy6C9Mf7Vl5bH67awn/h0zG9JfhCI4TbZLCqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456430; c=relaxed/simple;
	bh=4zK36/APan3GGXaMDrlRt1vezDSIhPFxrtENWn42h+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIg8S0Wf+fHWg11BQrPX3lGAo/X0nfgwd6icCHYKOo191ds/DWHxBwMhvNwapPicfWW1L47cui8gtJjMF272adt/ZUTqgAD3rA+Fpe4UCLv8ef+w1iWQzLDbJsTM/5Awy6fQcjIQ562HLWYHSYDVKfbwiVLUIPBuVVn/Y88f6Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/Cq60Uu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/Cq60Uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBE2C4CED3;
	Tue, 17 Dec 2024 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456430;
	bh=4zK36/APan3GGXaMDrlRt1vezDSIhPFxrtENWn42h+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/Cq60UuCGjuJ/zDAuQlKBupiyuNnQZubvPdXt9sdE6Fe2PsmBEPk6XFXwIR2YX3r
	 VUBSUBmwPpzGvzSleKxOCyhSwce81PZ7Tb8BA7Zkz/8jHjvd0+odVEETNk7cGzuIyV
	 OTj5gzlnHdeKyg4z/1GDzfPTB7ud7YnHffYyghJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@outlook.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.12 058/172] drm/i915: Fix memory leak by correcting cache object name in error handler
Date: Tue, 17 Dec 2024 18:06:54 +0100
Message-ID: <20241217170548.679644757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


