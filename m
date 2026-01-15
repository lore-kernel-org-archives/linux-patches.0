Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8C92D060B;
	Thu, 15 Jan 2026 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498586; cv=none; b=Yu0mbfJ8lqIkZBrxo2Mfz0ytMeJEWEGvRT1vic1hrPukhsQuPAYRxErgFni0ZF05SzJxH1dLsCFWgUpr7W5Q6ZNKFc6O7ozSTcP1sr61F2uViNbV/Klb3v7HNVV4+LtaWBZQBRRVSllF4FIvCSk09rDAWQk2Kpw7343vDSf7Z+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498586; c=relaxed/simple;
	bh=X6TBzOhQt3JCcf1dZkR5TsKi4cnTpxYRqWFHZwl3dcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2aT63Sd9xPwYyqqAUA+m6pttx1XfwhZIkr2KDjgiXbGPUCK2R7qqH2d1ltnR3qbBEJBQQngNUNcLI4uxvqlic63fKZfrvqOiJyiyjpaoIZE2s4J+EeYg1DPKJX/QfrexzR2s8xUUhP23dxHa5qwKxS9T1aW1R+vG+Wma9vjyrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwkMEB8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwkMEB8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F86C116D0;
	Thu, 15 Jan 2026 17:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498585;
	bh=X6TBzOhQt3JCcf1dZkR5TsKi4cnTpxYRqWFHZwl3dcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwkMEB8FaEnOh+swzb0/qgiev3Y/54H8O3fl3a2kl/aG1yXGrha+mvpV4QnKBY+hu
	 zJo8rC4Cr/zJcFGXjEq8Us26dYDHqrqN9JWx1Xlq1JPtYi72ODqnGX3hcSVQ/8dHOw
	 bVdNXYUExkVPr08f5hLOZucX2RxSQFKfu5nl1oEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 5.15 483/554] drm/i915/selftests: fix subtraction overflow bug
Date: Thu, 15 Jan 2026 17:49:09 +0100
Message-ID: <20260115164303.794013994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit ab3edc679c552a466e4bf0b11af3666008bd65a2 ]

On some machines hole_end can be small enough to cause subtraction
overflow. On the other side (addr + 2 * min_alignment) can overflow
in case of mock tests. This patch should handle both cases.

Fixes: e1c5f754067b59 ("drm/i915: Avoid overflow in computing pot_hole loop termination")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3674
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220624113528.2159210-1-andrzej.hajda@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[ Using I915_GTT_PAGE_SIZE instead of min_alignment due to 5.15 missing commit:87bd701ee268 ("drm/i915: enforce min GTT alignment for discrete cards")]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -715,7 +715,7 @@ static int pot_hole(struct i915_address_
 		u64 addr;
 
 		for (addr = round_up(hole_start + I915_GTT_PAGE_SIZE, step) - I915_GTT_PAGE_SIZE;
-		     addr <= round_down(hole_end - 2*I915_GTT_PAGE_SIZE, step) - I915_GTT_PAGE_SIZE;
+		     hole_end > addr && hole_end - addr >= 2 * I915_GTT_PAGE_SIZE;
 		     addr += step) {
 			err = i915_vma_pin(vma, 0, 0, addr | flags);
 			if (err) {


