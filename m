Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016242;
	b=Yvz9vnl9w18iHWDipCG8P/YWoATIwBWeWlXUuYzN25JramfyAqbIeXCBznW9uwcE9AQG
	 guUnd0EsbfokX/khAbUDSlVx9vnG31M3OFCjRHhIzhASsklMq3lHAz4/ELZDLOI87PL0G
	 R1Oo1LYO2VWcOVciXrDvFV0Ut7Uixtpnc96y2/i4jOkhDwgENwbemhJLqD24R3agLBG8r
	 QDVzHYaLylgMkFVf8XPsEPO5jHnJupQ0U0dmMkq/x2np/r/lwg4qjmdxZDtJ9fihO+Zc+
	 zfOT2L0Ek0cPCDaYFEXUW1CzD/was3swV3iITcNq0YW1D3uIt0zRU2AQwCrtjxStb/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kS944m1CdKjOUVg7AGfJAktRDI6aM/lphbtMuNX3h3c=;
	b=aCTlBbvo3rejPQTktkgZrZTl5mFdOeZ0W+3n2Nav8TfD/+E7uTJv0MoBW5KQRe5p5PCq
	 Nr2GkFlRP2zM+HMkMMyFrUb6wrafsWhaR6P5UK8wL8t6+vIJC3jDdwSBHAXLvlai8V29x
	 hBvELXWjG2kOIQR6tyBE7Lg/03ZN17CfCSPEhJViQ7eQbApIijb26PvDl1tuFMY2Ed7ZL
	 MFR0MEmjzp+3KJ95+dNuqhn0i8cXZUaT4FUcc63bDG3rlW/OcVVErEnjIjJtKGdf/zFmO
	 GqKaFr3Wg3orMxNiyFNmN9/stOQP7PoqLNfhE/o3jgfZyjwAiVRrqv233brk2/q6PUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LuFa+UA1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774F3606A325;
	Wed, 18 Nov 2026 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LuFa+UA1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B7D1F000CA;
	Wed, 18 Nov 2026 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016242;
	bh=kS944m1CdKjOUVg7AGfJAktRDI6aM/lphbtMuNX3h3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LuFa+UA1RvO9BQvBxgLp39Uqudupu6HCL5z9khu1AG+Rels9R+j+leMoWLBw6nslL
	 XYqC9fPjzJx2X6oM7IaAQl60N1e+uKbTVNcn40pvnKzbY3nvdlhrnCEA0yCyA2QSuA
	 9gu1apxN5VRbhL4zkt7hrsCjVzjlvBlrnS7Los3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0458/2651] dma-fence: Fix dma_fence_enable_signaling() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:28:18 +0100
Message-ID: <20261118150304.291812934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 65221358b6a6ea5128accbaa6117565ab8e24aa1 ]

The kernel-doc comment of dma_fence_is_signaled_locked() refers to
dma_fence_enable_sw_signaling, which was renamed to
dma_fence_enable_signaling by commit 9370a5c664e8 ("dma-buf: rename
dma_fence_enable_sw_signaling"). Say dma_fence_enable_signaling.

Fixes: 9370a5c664e8 ("dma-buf: rename dma_fence_enable_sw_signaling")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260911221100.7079-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-fence.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index ffa99b930843e..dd07d128adc3b 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -507,7 +507,7 @@ dma_fence_test_signaled_flag(struct dma_fence *fence)
  * Returns true if the fence was already signaled, false if not. Since this
  * function doesn't enable signaling, it is not guaranteed to ever return
  * true if dma_fence_add_callback(), dma_fence_wait() or
- * dma_fence_enable_sw_signaling() haven't been called before.
+ * dma_fence_enable_signaling() haven't been called before.
  *
  * This function requires &dma_fence.lock to be held.
  *
-- 
2.53.0



