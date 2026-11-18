Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025045;
	b=vpwp8Y9zD3GIo7pUlEYu1YYcDC9jG/6uTUTq7O7ptiRlld0tPvNT4RNbmAUA4igUm6Ka
	 VAB+Sz4YfCcfUEZ5e+W1E30aVsPeJmd1n2pw+HNiIOl9s5M4bCmop+KuiTX58Ktsbw7z5
	 5oiuxYE89OUEgLd4Hmqwjp79a3Fry7JsqKjYBIcbmqKuFlyaMrPN0HOVtcUcl23xRqZWr
	 ALMD8sQ5AkkrobPxxoywXkwSj1sbaQ/CIy1TWS9hLUDR0h1YXLvAAGOZ2JPHAhJhU1139
	 EDtYY/cfJoSB6dI0Sc45+b4TXm9Tg9IPRp1vhdAnAXZ0S0IigJr4vvpSK1OfAI9Xl3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+wHme6jnXV3mlqyHo91aZFcJcjAeXVjUzRqTCiIm4E=;
	b=w9Y6UgDrzQHA+u7eC8Ie2N+7D2pgdsr29Tcs9aY7f1T5/LgsoRkwB8cil4nLTHK4B2Dm
	 uzdD0NL9eNEcsg+GrcchHuhFSOZKZOugwlQ4d6NpBU483hRI+l15jh2EP5keMK+NMfp1n
	 NMatTdKy5BA0+dLuao1bADe9O5qT7g1WVziL3BHrl2sGWqLfS5C1DtB6X86vz3/IC9xPF
	 GA5Z8Rjo+gW8PDCuVL8cEGUe3lHr8JSU1DVpOnSPlPXHQz0wxbEJljQMG/AhMw5MYQesd
	 TtHVInPR16F44NJOPVcmxLD8xxyw8PSBBpGTHWbCEdECygJjHBrJ0J1V3JTD6UpI8fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vuflb2UO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D787606A320;
	Wed, 18 Nov 2026 18:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vuflb2UO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F37C1F000C4;
	Wed, 18 Nov 2026 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025044;
	bh=M+wHme6jnXV3mlqyHo91aZFcJcjAeXVjUzRqTCiIm4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vuflb2UOkOG2U8TmgGGWlw/ijxBLOOcuo/4oR6CBmISEfK/QWO14EaQEjCzkb0q7D
	 8VLHsCImBYlGGTAt5JRs4skG2HxgDatRTafjqhUGFfhWZ9u+I1Npj4Hsx8MRvhOMUA
	 ske3qPRsbX+cUM7zYYOYc+SuR4BQk6rePtlC0ONk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0941/2151] drm/amdgpu/userq: fix reading the WPTR at a non-zero BO offset
Date: Wed, 18 Nov 2026 15:44:36 +0100
Message-ID: <20261118150156.753083942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit c7ae3b2043282da8de92bd925c8f6bb614633181 ]

The user queue UAPI permits the WPTR at any 8-byte aligned offset within a
BO. amdgpu_userq_fence_read_wptr() locates the mapping containing the WPTR
address, but amdgpu_bo_kmap() returns the start of the BO, so the code read
the first u64 regardless of the WPTR offset. USERQ_SIGNAL uses this value as
the exported fence seqno, so a wrong read makes the fence signal early (or
never), breaking dependency synchronization.

Translate the WPTR GPU address to a byte offset within the BO, accounting
for the VA mapping start and the mapping's BO offset, before reading it.

Fixes: a292fdecd728 ("drm/amdgpu: Implement userqueue signal/wait IOCTL")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index e4c5674c91fea..602af4b645b9e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -371,7 +371,7 @@ static int amdgpu_userq_fence_read_wptr(struct amdgpu_usermode_queue *queue,
 	struct amdgpu_bo_va_mapping *mapping;
 	struct amdgpu_bo *bo;
 	struct drm_exec exec;
-	u64 addr, *ptr;
+	u64 addr, offset, *ptr;
 	int ret;
 
 	addr = queue->userq_prop->wptr_gpu_addr;
@@ -403,7 +403,10 @@ static int amdgpu_userq_fence_read_wptr(struct amdgpu_usermode_queue *queue,
 		goto lock_error;
 	}
 
-	*wptr = le64_to_cpu(*ptr);
+	/* The WPTR can be anywhere within the BO's VA mapping. */
+	offset = addr - (mapping->start << AMDGPU_GPU_PAGE_SHIFT);
+	offset += mapping->offset;
+	*wptr = le64_to_cpu(ptr[offset / sizeof(*ptr)]);
 
 	amdgpu_bo_kunmap(bo);
 	drm_exec_fini(&exec);
-- 
2.53.0



