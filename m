Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214709;
	b=y/t2zkkXlQYmceHM0HdW9jLGcRb9okT1/eM8rSm7B6j4ELO+Gq2mwM1vluihnyPPoMJU
	 tgS86D0XcutUTvfSCRmhbLe+EBy728Lw99sIt6ep88GD9WU3w+YXmpPQjFxQYFO8ObYG1
	 RXspXqQYiKl6J5JjeUCmG6C1KwQm1LPiSuCg3PqYEYA53YMsNIh+Xu+c3ONcTOyDZ3TRQ
	 ylaBoFBOhabWwWq7zetpi5Kkdn24XQpIZ1HF/CTwxmX21M4r64qB5lHdw2qgfj2MaBp+g
	 02uyo+2bxX5L2+6WxJdlRawYX9fFgTMgqsKQRLWm/hUuSy0YyKMSqyimYrbdp42cGAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nG2tTKJmjporZ0yTA+LdSsk3jRHrxl0VtcZ+EOvMugI=;
	b=h2miKC0u3ljQqhcSAK3K802IXa10VpH0rrG9Vg5yw0kUroFAQe0D5pt/tCAxjEeHGFEj
	 wRkwWSzLKEt+oQ3nBmjc0ejt9+P3zQBWLpXwJbSgJ8B2M/JPKTlo5cr2BWX/r+gKZy3Dx
	 RhL/+hRxHFJCsm5NrO6snODb1No+oUTL1eShxPD2gNyWZ5Mp3k6ggQ5E6Zsl9BxRcPaQe
	 ENTfZ/BBOHobGlhsKDz1aXgKm5RxCCc0zcdIo0YxInpP0rtmqFX/TgngAL76W02evlw7S
	 pz7rbAjQE9/hEhb8+EzP3I9cw/x7PI371fTaRcdmdHLSYqvNYFLeHZHu3Sh2WIoETLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmpyaZ4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC388606BFB3;
	Wed, 28 Oct 2026 19:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmpyaZ4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A49F1F01828;
	Wed, 28 Oct 2026 19:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214708;
	bh=nG2tTKJmjporZ0yTA+LdSsk3jRHrxl0VtcZ+EOvMugI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmpyaZ4VLnjr+5X3vDBUNQHJe+h0Z8XbVCdJXvqiSZdL41dPtjzUdkhoSxCkbAReY
	 RvIhqm+eLqKcqfWJsy41tBPYTA0oBWviCR5QCVo4X+9i5CKKXq5cQ7btuMPzJ6eoSo
	 7yA3glunt6MgH9WY7KhFHuPtBbh4/y/kPz9ktAYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0947/1887] drm/amdgpu: Remove usage of the deprecated ida_simple_xx() API
Date: Wed, 28 Oct 2026 17:50:43 +0100
Message-ID: <20261028170520.958333137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8a1f7fddabe112f463c2fd5d1e41c9c87d0a9957 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 14b81abe7bdc ("drm/amdgpu: prevent immediate PASID reuse case")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index 03d115d2b5edd..43557748d1139 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -62,9 +62,8 @@ int amdgpu_pasid_alloc(unsigned int bits)
 	int pasid = -EINVAL;
 
 	for (bits = min(bits, 31U); bits > 0; bits--) {
-		pasid = ida_simple_get(&amdgpu_pasid_ida,
-				       1U << (bits - 1), 1U << bits,
-				       GFP_KERNEL);
+		pasid = ida_alloc_range(&amdgpu_pasid_ida, 1U << (bits - 1),
+					(1U << bits) - 1, GFP_KERNEL);
 		if (pasid != -ENOSPC)
 			break;
 	}
@@ -82,7 +81,7 @@ int amdgpu_pasid_alloc(unsigned int bits)
 void amdgpu_pasid_free(u32 pasid)
 {
 	trace_amdgpu_pasid_freed(pasid);
-	ida_simple_remove(&amdgpu_pasid_ida, pasid);
+	ida_free(&amdgpu_pasid_ida, pasid);
 }
 
 static void amdgpu_pasid_free_cb(struct dma_fence *fence,
-- 
2.53.0



