Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51A51F8682;
	Tue, 17 Dec 2024 17:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455567; cv=none; b=DOdCd9rvn9dy30sZaMxX+CG+PS2SQxGgbxwHR9i5+xGlM2OpZVh8W/5Uh62myOeT09LH/aoGXnAQ4ItRnVQQTMtYoaCTk1MMO8ExSX7pUpCR+p6vWLZ312MvFFCJTUsVy6MGu476t1/g8h0FNZqPVYngA0dzcAKt/LDow51zhn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455567; c=relaxed/simple;
	bh=mtSRQJAOV73KiDM8HKiUts/LH0uqldsjxLpkeHFkrtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gl1/qS+gpt3B0sdECpZx5x996hff+KP67/UFbPyiTRqwDXaWASmoVn8NqqrE6TlfZATPe3bYeuB58ZVMXldUVrkd65R/XquVd6rJKgWk0LpQ9pQjZgv1MqRIj9gJbXuXAw+6u3LLD11goR9V3+WP2mG0fsLdSiLNavR1p4Qym/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcpUXW7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcpUXW7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEBAC4CED3;
	Tue, 17 Dec 2024 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455566;
	bh=mtSRQJAOV73KiDM8HKiUts/LH0uqldsjxLpkeHFkrtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcpUXW7/1/eXUpA4eWVADsna4XVVR7mM5gTkeh08ZSgYO8vO1FlNJJdOnLPL+9fOc
	 6JlfYmjjHEQSDM37kZmEJL/Tg28H99HNZI9EnFGnlqcEs1bJnsMkqSDkdwDQho/mnd
	 pQyH4eujRyjjq9OBgasgcfYmxeQ0+VUC7oZpXmvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@outlook.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 5.15 10/51] drm/i915: Fix memory leak by correcting cache object name in error handler
Date: Tue, 17 Dec 2024 18:07:03 +0100
Message-ID: <20241217170520.730458876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


